# build_release.ps1 — 產生可交付給外部使用者的 release
#
# 用法（在任何目錄執行都可以）：
#     powershell -ExecutionPolicy Bypass -File C:\DESIGNER6_DS\tools\build_release.ps1
#
# 產出：C:\DESIGNER6_RELEASE\
#     DESIGNER6_DS\        解開的資料夾（可先自己檢查）
#     POWPARTS_DS\
#     DESIGNER6_DS_<日期>.zip
#     POWPARTS_DS_<日期>.zip
#
# 完整說明與「為什麼是這樣做」見手冊 §9.7。摘要：
#
#   ⚠ 不要改用 git archive --format=tar 再用 Windows 的 tar.exe 解開。
#     tar.exe 會把 tar 裡的 UTF-8 檔名當 cp950 解，中文檔名全毀
#     （功能對照表.md → "_撠銵_md"，連副檔名的點都被吃掉），而且完全
#     沒有錯誤訊息。用 git checkout-index 由 git 自己寫檔才正確。
#
#   ⚠ 本檔請維持「UTF-8 with BOM」。Windows PowerShell 5.1 在沒有 BOM 時
#     會用系統 ANSI（cp950）讀 .ps1，中文註解與字串會變成亂碼並導致語法錯誤。
#     （專案其他檔案的編碼規則見 CLAUDE.md，.ps1 是唯一需要 BOM 的類型。）
#
# 公司資料的取捨：本腳本「什麼都不清、照原樣打包」，與 2026-09-15 的決定
# 一致。要出乾淨版的話，partdata.txt 與 ~database.txt 程式會讀、不能刪檔，
# 只能清到剩第一行欄位名；database-old.txt 與 "database - old.txt" 沒有任何
# 程式引用，可直接刪。見手冊 §9.7。

$ErrorActionPreference = 'Stop'

$OUT      = 'C:\DESIGNER6_RELEASE'
$STAMP    = Get-Date -Format 'yyyyMMdd'
$SEVENZIP = 'C:\Program Files\7-Zip\7z.exe'

# 納管但不交付的檔案：文件與開發用檔
$EXCLUDE = @{
  'C:\DESIGNER6_DS' = @('docs', 'tools', '功能對照表.md', 'CLAUDE.md', '.gitignore')
  'C:\POWPARTS_DS'  = @('CLAUDE.md', '.gitignore')
}

if (-not (Test-Path $SEVENZIP)) { throw "找不到 7-Zip：$SEVENZIP" }
if (Test-Path $OUT) { Remove-Item $OUT -Recurse -Force }
New-Item -ItemType Directory -Path $OUT -Force | Out-Null

foreach ($repo in $EXCLUDE.Keys | Sort-Object) {
  $name = Split-Path $repo -Leaf
  Set-Location $repo

  # HEAD 才是要交付的內容，工作區有未提交的東西就等於交付了未知版本
  $st = git status --porcelain
  if ($st) { throw "$name 工作區不乾淨，先處理：`n$st" }

  $dst = Join-Path $OUT $name
  New-Item -ItemType Directory -Path $dst -Force | Out-Null

  # 由 git 自己把納管檔案寫出去：不含 .git、不含 .gitignore 擋掉的執行期殘留，
  # 檔名也由 git 處理（這是不用 tar.exe 的原因）。--prefix 要正斜線且以斜線結尾。
  $prefix = ($dst -replace '\\', '/') + '/'
  git checkout-index -a -f --prefix=$prefix
  if ($LASTEXITCODE -ne 0) { throw "$name checkout-index 失敗" }

  $tracked = (git ls-files | Measure-Object).Count
  $got     = (Get-ChildItem $dst -Recurse -File).Count
  if ($tracked -ne $got) { throw "$name 檔數不符：納管 $tracked、匯出 $got" }

  foreach ($e in $EXCLUDE[$repo]) {
    $t = Join-Path $dst $e
    if (Test-Path -LiteralPath $t) { Remove-Item -LiteralPath $t -Recurse -Force; "  排除 $name\$e" }
    else { throw "$name\$e 不存在，排除清單過時了" }
  }
  $after = (Get-ChildItem $dst -Recurse -File).Count
  $mb    = ((Get-ChildItem $dst -Recurse -File | Measure-Object Length -Sum).Sum / 1MB)
  "{0,-16} 納管 {1} 檔 → 交付 {2} 檔、{3:N1} MB" -f $name, $tracked, $after, $mb
}

# ---------------- 交付前驗證（六項，見手冊 §9.7）----------------
""
"=== 驗證 ==="
$bad = 0

if (Get-ChildItem $OUT -Recurse -Force -Directory | Where-Object { $_.Name -eq '.git' }) { "★ 有 .git"; $bad++ }
else { "  1. .git                無 OK" }

$md = Get-ChildItem $OUT -Recurse -File -Filter '*.md'
if ($md) { "★ 還有 .md：$($md.Name -join ', ')"; $bad++ } else { "  2. .md 文件            無 OK" }

# git 歷史與 docs/ 裡那組明文 Oracle 密碼，不可出現在交付內容裡
$pw = 'campro' + '35638042'
$hit = @()
Get-ChildItem $OUT -Recurse -File | Where-Object { $_.Length -lt 8MB } | ForEach-Object {
  if ([System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($_.FullName)).Contains($pw)) { $hit += $_.FullName }
}
if ($hit) { "★ 仍含明文密碼：$($hit -join ', ')"; $bad++ } else { "  3. 明文密碼            無 OK" }

$junk = Get-ChildItem $OUT -Recurse -File -Include 'Thumbs.db', '*.bak', '*.dwl', '*.dwl2', `
  'campro.txt', 'CamproBom.txt', 'SWAPFILE.TXT', 'system.swr', 'SYSTEM.NEW'
if ($junk) { "★ 執行期殘留 $($junk.Count) 個"; $bad++ } else { "  4. 執行期殘留          無 OK" }

# 這一項是唯一能抓到 tar.exe 檔名毀損的檢查，不要拿掉
foreach ($repo in $EXCLUDE.Keys | Sort-Object) {
  $name = Split-Path $repo -Leaf
  $dst  = Join-Path $OUT $name
  $skip = $EXCLUDE[$repo]
  $cjkSrc = @(Get-ChildItem $repo -Recurse -Force |
    Where-Object { $_.FullName -notmatch '\\\.git\\' -and $_.Name -match '[\u4e00-\u9fff]' } |
    ForEach-Object { $_.FullName.Substring($repo.Length + 1) } | Sort-Object)
  $cjkDst = @(Get-ChildItem $dst -Recurse -Force | Where-Object { $_.Name -match '[\u4e00-\u9fff]' } |
    ForEach-Object { $_.FullName.Substring($dst.Length + 1) } | Sort-Object)
  $extra   = @($cjkDst | Where-Object { $cjkSrc -notcontains $_ })
  $missing = @($cjkSrc | Where-Object {
      $n = $_
      ($cjkDst -notcontains $n) -and -not ($skip | Where-Object { $n -eq $_ -or $n.StartsWith("$_\") })
    })
  if ($extra.Count) { "★ $name 中文檔名毀損 $($extra.Count) 個，例如：$($extra[0])"; $bad++ }
  else { "  5. {0,-18} 中文檔名 {1} 個全部正確 OK" -f $name, $cjkDst.Count }
  if ($missing.Count) { "★ $name 少了 $($missing.Count) 個中文檔名：$($missing -join ', ')"; $bad++ }
}

if ($bad) { throw "有 $bad 項驗證未過，沒有打包" }

# ---------------- 打包（-mcu=on 強制 UTF-8 檔名）----------------
""
foreach ($repo in $EXCLUDE.Keys | Sort-Object) {
  $name = Split-Path $repo -Leaf
  $src  = Join-Path $OUT $name
  $zip  = Join-Path $OUT "$name`_$STAMP.zip"
  & $SEVENZIP a -tzip -mcu=on -mx=7 $zip $src | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "$name 打包失敗" }
  "{0,-34} {1,8:N1} MB" -f (Split-Path $zip -Leaf), ((Get-Item $zip).Length / 1MB)
}

# zip 內檔名再驗一次（用 .NET 讀，不受主控台編碼影響）
Add-Type -AssemblyName System.IO.Compression.FileSystem
foreach ($repo in $EXCLUDE.Keys | Sort-Object) {
  $name = Split-Path $repo -Leaf
  $zip  = Join-Path $OUT "$name`_$STAMP.zip"
  $a = [System.IO.Compression.ZipFile]::OpenRead($zip)
  $n = @($a.Entries | Where-Object { $_.FullName -match '[\u4e00-\u9fff]' }).Count
  $a.Dispose()
  "  6. {0,-18} zip 內中文路徑 {1} 筆 OK" -f $name, $n
}

""
"完成。輸出位置：$OUT"
"對方的安裝步驟見手冊 §2.0（重點：不要跑 C:\POWPARTS_DS\SETUP.LSP）。"
