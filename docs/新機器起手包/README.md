# 新機器起手包

**2026-10-06**　|　給「有 AutoCAD 環境的那台機器」上的新工作階段

> **這份是給接手的人與新的 Claude Code 工作階段看的第一份文件。**
> 舊機器（`RD-DPC07`）上的工作階段沒有 AutoCAD，只能靠截圖往返診斷；
> 真正要動手改程式碼，必須在這台機器上進行。

---

## 一、這是什麼專案，現在在哪個階段

藝祥「機械設計家」（Designer6 + POWERPARTS）是一套跑了二十多年的
AutoCAD LISP 機械設計外掛。

```
2026-06 ~ 2026-09   移植到 DraftSight 2025  →  已結案
                    436 項功能全部實測通過，release-20260918 已交付
2026-10 ~           回頭重整 AutoCAD 原版    →  現在在這裡
```

**兩個任務：**

| | 任務 | 文件 |
|---|------|------|
| 一 | 移除加密狗的檢查及相關程式碼 | `AutoCAD版-加密狗移除交接-20261006.md` |
| 二 | 修正移植過程中發現的原版既有錯誤 | `AutoCAD版回移植清單-20260918.md` |

目標是 **`C:\DESIGNER6`** 與 **`C:\POWPARTS`**（AutoCAD 原版）。

---

## 二、已經確認的事（實測，不是推論）

2026-10-06 在這台 AutoCAD 機器上測出來的：

### 加密狗的閘門只有三個變數

```lisp
(setq jin "#$%" #### 85 sspp 0)
```

設完之後 `&E-LEN` 立刻正常運作——**在此之前它打下去完全沒反應**。

### 完整鏈路

```
CONFIG.lsp:188  (load "loadsys")        → 實際載到 C:\POWPARTS\loadsys.lsp
CONFIG.lsp:189  (check_which_app)
LOADSYS.LSP:66    (setq data (creat_keypro_data))
LOADSYS.LSP:5       (startapp KEYPRO_path + "findkey.exe")   ← 真正讀加密狗
                    (while (null sysini) (findfile "c:\powsoft.ini"))
LOADSYS.LSP:69    (foreach nn data … 設 jin / #### / sspp)
```

### 沒插加密狗的機器上的實測值

```
c:autoload      = SUBR                      COMMAND.lsp 有載入
powdesign_path  = C:\DESIGNER6\             CONFIG.lsp 跑到第 87 行
check_which_app = SUBR                      loadsys 有載入，189 行有執行
powsoft.ini     = nil                       加密狗沒寫出來
data            = nil
jin/####/sspp   = nil / nil / nil           閘門關閉
getval          = nil                       SYSTEM.lsp 沒載入
```

**結論：那 334 處 `WHILE` 外殼包住的程式碼，目前全部不會執行。**

### ⚠ 一件還沒釐清的事

文件裡推論「`CONFIG.lsp` 停在第 189 行」，**那是推論、沒有實測**。

反證：`startapp` 在 AutoLISP 失敗時回 `nil` 而不報錯；若真如此，
`creat_keypro_data` 的 `(while (null sysini) …)` 應該會**無限迴圈卡死 AutoCAD**
——但它沒有。所以實際發生什麼還不知道。

**釐清方法**：重開 AutoCAD 時盯著指令列看載入訊息有沒有中斷。
它影響「要不要順便把 `CONFIG.lsp:188-189` 註解掉」。

---

## 三、接下來做什麼（順序很重要）

```
1. 環境就緒          clone repo、原版納入版控、確認 AutoCAD 載得到系統
2. 任務二 A-5        *error* 三層 —— 先讓錯誤訊息看得見
3. 加上加密狗繞過     讓功能活過來
4. 建立行為基準       這時才做得到
5. 任務一            正式拆除 334 處
6. 回頭比對基準
7. 任務二 其餘 A 類
8. 任務二 B 類（可選）
```

### 為什麼 A-5 要排在最前面

A-5 是 `*error*` 的三個層次，會讓**整個 AutoCAD 工作階段的錯誤訊息被吞掉**：

- 19 處頂層 `(defun *error* (msg) (princ))`——載入就永久換掉全域 `*error*`
- 33 處 `(if oerr (setq *error* oerr))`——`oerr` 為 nil 時不還原
- 17 個安裝點正常結束時不還原

不先修它，拆加密狗時出任何問題都是**無聲失敗**，排查會非常痛苦。
DraftSight 移植初期為了這件事繞了十幾輪。

### 為什麼繞過要排在建立基準之前

閘門關閉時那 334 支指令**完全沒反應**，沒有東西可以當基準。
先繞過讓它們活過來，記錄正確行為，拆完才有得比對。

繞過寫進 `C:\DESIGNER6\acaddoc.lsp`，放在 `(c:autoload)` **之前**：

```lisp
;;;預先載入程式
(setq jin "#$%" #### 85 sspp 0)     ; temporary dongle bypass - remove after cleanup
(load "command")
(load "quickey")
(c:autoload)
```

**這是權宜措施，正式拆完要刪掉。**

### 建立基準時必測的清單

這幾支是拆外殼時**最可能壞掉**的（DraftSight 版都真的壞過）：

```
&e-len                 線段公英制長度      算式用到 ppss
&pul &pur &pdl &pdr    旋轉投影線          同上，當年沒人發現，是掃出來的
&lc → 然後打 SLOT5     軸銑雙邊            沒有選單分派，只能指令列直接打
```

---

## 四、最大的坑：刪外殼會連帶刪掉 `(setq ppss sspp)`

加密狗外殼長這樣：

```lisp
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   …函式本體…
 (SETQ FFF nil))
```

**`(setq ppss sspp)` 寫在 WHILE 的開頭。** 整段刪掉，`ppss` 變未繫結，
而算式裡還留著 `(+ (distance sp ep) ppss)` → `(+ 數字 nil)` → **指令中斷**。

症狀很有誤導性：錯誤發生在 `entsel` **之後**的同一個 `setq`，
所以畫面會先出現「找到 1」才中斷，看起來像選取有問題。

**`ppss` 永遠是 0，直接從算式拿掉即可**（三個獨立證據見加密狗文件 §0）。

每刪一個外殼，就檢查該函式本體有沒有讀 `ppss`。原版全庫：
`(setq ppss sspp)` **138 處**、讀取 `ppss` **161 處**。

---

## 五、盤點數字（2026-10-06 掃原版所得）

44 個檔案命中加密狗記號：

| 記號 | 次數 |
|------|------|
| 檢查式 `(= jin "#$%")` / `(= #### 85)` | **334** |
| `FFF` | 510 |
| `####` | 180 |
| `jin` | 178 |
| `ppss` | 161 |
| `sspp` | 159 |

命中最多：`AUXDRAW1.lsp` 32、`AUXDIM.lsp` 27、`LAYER.lsp` 11、
`AUXEDIT.lsp` 10、`BOM.lsp` 10、`AUX-QURY.lsp` 8、`AUXDRAW.lsp` 8。

> ⚠ **引用舊手冊的數字前，先回原版數一次。** 手冊裡多數數字是**移植版**的，
> 而移植版做過瘦身。例：`(setq ppss sspp)` 手冊寫 15 處，原版實際 **138 處**。

---

## 六、⚠ 這個專案的鐵律（與 DraftSight 版**不同**）

### 編碼：AutoCAD 原版是 Big5，**不是 UTF-8**

這是最容易出事的一條。`C:\DESIGNER6_DS` 的 `CLAUDE.md` 寫「`.lsp` 必須 UTF-8」
——**那是 DraftSight 版的規則，套到這裡會把中文全部毀掉**。

| | DraftSight 版 | **AutoCAD 原版** |
|---|---|---|
| `.lsp` | UTF-8（無 BOM） | **cp950 / Big5** |
| `.dcl` `.ini` `.doc` `.dat` | cp950 | cp950 |
| `core.autocrlf` | `true` | **`false`** |

- **AutoCAD 版沒有理由轉 UTF-8**，維持 Big5
- 絕不可在單一檔案內混用編碼；寫中文註解前先確認該檔編碼
- **不要整批重跑編碼轉換**——DraftSight 移植早期一次用 `errors='replace'` 的
  批次轉換，在 6 個檔案裡留下約 11,953 個 U+FFFD，中文**永久損毀**

```bash
python -c "d=open('AUXDIM.lsp','rb').read(); d.decode('cp950'); print('cp950 OK')"
```

### 工具陷阱

- **不要用 `sed -i` 改 CRLF 檔**。這個環境的 `sed`／`awk`／`grep` 都是文字模式，
  讀寫都會吃掉 `\r`，而 **`grep -c $'\r'` 驗不出來**（它自己也吃 CR）。
  正確的計數方式是 `tr -cd '\r' | wc -c`。
  改 CRLF 檔用逐位元組安全的 `head`／`tail`／`cat`／`printf` 拼接。
- **指令是 `python`，不是 `python3`**（後者指到 Microsoft Store 的轉接殼）。
- **掃原始碼一律加 `-i`**。這套程式的大小寫完全不一致——
  `KEYPRO_path` vs `KEYPRO_PATH`、`.lsp` vs `.LSP`、`HP-K._LS`。
  我就因為沒加 `-i` 而誤判過「`KEYPRO_path` 從未被賦值」。

### 括號平衡

拆 WHILE 外殼等於少一層括號，**很容易漏補**。要用**會跳過字串與註解**的掃描器，
單純數 `(` `)` 會把字串裡的括號算進去。

```awk
# balance.awk
{
  line = $0; n = length(line)
  for (i = 1; i <= n; i++) {
    ch = substr(line, i, 1)
    if (instr) { if (ch == "\\") { i++ } else if (ch == "\"") { instr = 0 } }
    else {
      if (ch == ";") break
      else if (ch == "\"") instr = 1
      else if (ch == "(") depth++
      else if (ch == ")") depth--
    }
    if (depth < 0) { print "  第 " NR " 行多餘的 )"; depth = 0 }
  }
}
END { print "  最終深度 = " depth }
```

⚠ 它不認得 `;| … |;` 區塊註解。
⚠ **Big5 的第二位元組可能是 `(` `)` `"` `\`**——位元組層級的掃描對 Big5 檔不可靠，
工具必須以字元（先 decode cp950）而非位元組處理。

### 沒有自動化測試

**所有驗證都得由人在 AutoCAD 裡實際跑指令。**

- 改完不要說「已修復」，說「已修改，待實測」
- 一次只改一個問題，讓人能單點驗證
- 推論要說清楚是推論；無法從檔案證實的，明確標示「未查核」

### 不要動的東西

- 保留一份**未修改的原版副本**當對照組，整個重整期間不要動它
- `C:\DESIGNER6_DS` / `C:\POWPARTS_DS`（DraftSight 版，已結案）不要改

---

## 七、環境設定

### git

AutoCAD 原版納入版控時，**`core.autocrlf` 要設 `false`**——與 DraftSight 版相反。
這個 repo 的用途是忠實保存原版，不做任何正規化。

```bash
cd C:\DESIGNER6
git init
git config core.autocrlf false
git add -A
git commit -m "原版 C:\DESIGNER6，未修改"
```

`C:\POWPARTS` 同樣處理。建議的 `.gitignore`：

```
Thumbs.db
*.dwl
*.dwl2
*.sv$
*.ac$
*.err
*.bak
~$*
campro.txt
CamproBom.txt
```

### 取得 DraftSight 版的文件

```bash
git -c core.autocrlf=true clone https://github.com/pjcheng01/Designer6_DS.git C:\DESIGNER6_DS
git -c core.autocrlf=true clone https://github.com/pjcheng01/POWPARTS_DS.git  C:\POWPARTS_DS
```

### 需要的工具

| 工具 | 用途 |
|------|------|
| AutoCAD | 實測（**唯一的驗證方式**） |
| git | 版控 |
| Python 3 | 編碼驗證、批次掃描（指令是 `python`） |
| 編輯器 | 要能處理 **cp950** 且不自動轉碼（VS Code 設 `files.encoding: big5`） |

---

## 八、文件地圖

全部在 `C:\DESIGNER6_DS\docs\`：

| 文件 | 內容 |
|------|------|
| `新機器起手包\README.md` | **就是這份** |
| `新機器起手包\CLAUDE.md.範本` | 複製到 `C:\DESIGNER6\CLAUDE.md`，新工作階段會自動載入 |
| `AutoCAD版重整-移交索引-20261006.md` | 兩個任務的總覽、搬運清單、新電腦起步 |
| `AutoCAD版-加密狗移除交接-20261006.md` | **任務一**。§0 最大的坑、§0.5 實測結果、§2 作業順序 |
| `AutoCAD版回移植清單-20260918.md` | **任務二**。A/B/C 三類分開，**C 類不要回移植** |
| `移植專案交接手冊.md` | DraftSight 版的完整紀錄。§7.12 `ppss` 事件、§5.16 `*error*`、第 3 章編碼 |
| `專案結案報告-20260918.md` | DraftSight 版結案紀錄 |

---

## 九、舊機器上的工作階段發生過什麼錯，別重蹈

誠實記錄，因為同樣的錯很容易再犯：

| 錯誤 | 教訓 |
|------|------|
| 連續兩次猜錯加密狗為何失效（猜「loadsys 載不到」、猜「findfile 失敗」） | **載入鏈靠靜態掃描只能猜到一半。** 真正的答案在 `check_which_app` 的第一行。有執行環境時**先量再推論** |
| 誤判「`KEYPRO_path` 從未被賦值」 | grep 沒加 `-i` |
| 引用手冊的數字而沒回原版核對（15 處 vs 138 處） | **手冊的數字多半是移植版的** |
| 用 `grep -c $'\r'` 驗換行，整個工作階段的驗證都不算數 | 工具自己會吃 CR，用 `tr -cd '\r' \| wc -c` |
| `git add -A` 把 Word 鎖定檔掃進版控 | 提交前看一眼 `git status` 的完整清單 |

---

*本起手包的每一項實測數據都來自 2026-10-06 在 AutoCAD 機器上的實際執行，
盤點數字來自同日掃描 `C:\DESIGNER6` 與 `C:\POWPARTS` 原始碼。*
