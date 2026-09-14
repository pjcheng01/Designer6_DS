# CLAUDE.md — Designer6_DS

DESIGNER6（AutoCAD LISP）移植到 DraftSight 的專案。完整背景、現況盤點與待辦清單在
`docs/移植專案交接手冊.md`，**接手時請先讀那份**。這裡只放「每次動手前都必須記得的規則」。

## 這個專案的特殊之處

程式是 AutoLISP，執行環境是 DraftSight，**沒有辦法在此工作階段自動化測試**。
任何修改都只能靠人工在 DraftSight 裡跑指令驗證。因此：

- 改完不要說「已修復」，說「已修改，待你在 DraftSight 驗證」。
- 一次只改一個問題，讓使用者能單點驗證。
- 推論要說清楚是推論。無法從檔案證實的行為差異，明確標示「未查核」。

## 編碼：這個專案最大的雷

| 類型 | 必須編碼 | 理由 |
|------|---------|------|
| `.lsp` | **UTF-8**（無 BOM） | DraftSight 2025 可正確讀取 |
| `.dcl` | **cp950 / Big5** | DraftSight 不支援 UTF-8 DCL，`load_dialog` 會回傳 -1 |
| `.ini` `.doc` `.dat` | **cp950 / Big5** | DraftSight 的 `open`/`read-line` 以 cp950 讀檔 |
| `.md` `.gitignore` | UTF-8 | 給人和工具讀的 |

**動手前先驗編碼，不要憑檔名或印象猜**：

```bash
python3 -c "d=open('SHSCAL.lsp','rb').read(); d.decode('utf-8'); print('UTF-8 OK')"
python3 -c "d=open('shscal.ini','rb').read(); d.decode('cp950'); print('cp950 OK')"
```

- **絕不可在單一檔案內混用編碼。** 曾經發生過：往 UTF-8 的 `SHSCAL.lsp` 插入 Big5 中文註解，
  造成同檔混編碼（已於 c690ade 修正）。寫中文註解前先確認該檔目前的編碼。
- **不要整批重跑編碼轉換。** 早期的一次 Big5→UTF-8 批次轉換使用了 `errors='replace'`，
  在 6 個檔案裡留下約 11,953 個 U+FFFD（`�`），中文永久損毀，詳見手冊「已知問題」。
  再跑一次只會製造更多損失。

## 換行：進 repo 前務必確認設定

repo 歷史以 `core.autocrlf=true` 從 Windows 提交（版本庫存 LF、工作目錄 CRLF）。
若在沒有這個設定的環境操作 git，`git status` 會把 **265 個檔案全部誤判為已修改**。

```bash
git config --get core.autocrlf   # 必須是 true，不是就設定它
```

看到 `git status` 一次冒出上百個修改檔，先懷疑這一項，不要照單全收去 commit。

## 修改 LISP 時的固定流程

1. **先看原版。** `C:\DESIGNER6`（AutoCAD 版）與 `C:\POWPARTS` 是未移植的對照組，
   多數「移植版壞掉」的問題可以靠 diff 原版快速定位。
2. **確認編碼**（見上）。
3. **用指令或腳本就地修改**，例如 `sed -i` 或 python read-modify-write。
   不要憑工具輸出重打整份檔案內容——輸出可能被截斷。
4. **驗證括號平衡**（LISP 檔改完必做）。注意：Big5 檔的第二位元組可能是 `(` `)` `"` `\`，
   位元組層級的掃描對 Big5 檔不可靠，只對 UTF-8 檔有效。
5. **請使用者在 DraftSight 實測**，通過後才 commit。

## 不要做的事

- 不要動 `SHEET/*.dwg`、`DWG/*.dwg`、`SLD/*.sld` 等圖檔與圖庫二進位檔，除非使用者明確要求。
- 不要刪除 `C:\DESIGNER6` / `C:\POWPARTS`（原版對照組）裡的任何東西。
- 不要把執行期輸出（`campro.txt`、`CamproBom.txt`、`*.dwl`、`Thumbs.db`）加回版控，`.gitignore` 已擋。

## 推送

**commit 隨時可以做；push 要使用者說了才做。**

2026-09-14 更正：原本這裡寫「不要幫使用者 push（此環境沒有 GitHub 憑證）」，
但實測 `git push origin main` 是會成功的，憑證是有的。使用者也明確表示
要求時就可以推。

所以現在的規則是：

- 做完一段工作 → commit，並告知推送了幾個 commit
- 使用者說「push」→ 直接推，不用再問
- 沒說 → 不要自己推

> 附帶一提：Claude Code 的權限機制偶爾會攔下 `git push`（回報
> 「Blocked by classifier」）。那不是 git 或憑證的問題，也不是穩定規則——
> 同一道指令稍後再試可能就通過。被攔下時不要想辦法繞過，
> 告訴使用者讓他自己跑就好。

## 這個 repo 的 git 環境陷阱

透過網路磁碟/掛載操作 git 時，`.git/index.lock`、`.git/HEAD.lock` 與 `tmp_obj_*` 可能無法刪除，
會卡住後續指令。發生時先清乾淨再繼續：

```bash
rm -f .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock
find .git/objects -name "tmp_obj_*" -delete
```
