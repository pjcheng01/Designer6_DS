# 瘦身分析：PDM 連結與外部 .exe

> 2026-09-11 盤點。
> **執行進度：階段 1-3 已完成並通過實測**（見 §5 表格的狀態欄）。
> 相關背景見 `移植專案交接手冊.md`。

---

## 0. 三分鐘版本

**PDM 在移植時就已經斷線了。** `CONFIG.lsp` 開頭第 3 條寫明「移除 PDM 模組（不需移植）」，
`config.doc` 裡一個 `POWERPDM_*` key 都沒有，所以 `powerpdm_path`、
`powerpdm_attribdata_path`、`powerpdmclient_path` 在執行期**一律是 nil**。

因此要處理的不是「還活著的 PDM 連結」，而是**殭屍程式碼**——不會執行，
但佔著篇幅、讓每次讀程式的人多花時間判斷「這段到底會不會跑」。

好消息是：我逐一查過 `BOM.lsp` 的每一個 PDM 呼叫點，**全部都在守衛後面**
（`(= "Yes" yyesno)` 或 `(/= nil powerpdm_path)`），兩個條件都永遠不成立。
**沒有地雷**，可以安心分批移除，不急著一次做完。

真正還會在執行期外呼 .exe 的只有 **13 個點**，其中：

- **6 個**是 CAMPRO/ERP 相關，後端已死 → 直接移除
- **2 個**（`tree1.exe`、`bom1.exe`）→ 可改 .csv，而且**已有現成範本與替代品**
- **2 個**（`partout.exe`、`topdmatt.exe`）→ 死碼，隨 PDM 分支一起移除
- **3 個**（`manadwg.exe`、`change.exe`、`selfile.exe`）→ **與 PDM 無關，不在本次範圍**

---

## 1. 查證過程與證據

### 1.1 PDM 路徑從未被設定

`CONFIG.lsp` 的 `config_des50_system` 讀 `config.doc`，設定了
`POWDESIGN_*`、`USERMENU_PATH`、`BMANAGER_*`、`AUTOPLOT_*`、`POWERISO_PATH`、
`POWERPARTS_*`——**沒有任何 `powerpdm_*`**。

`config.doc` 全文也沒有 `POWERPDM` 開頭的 key。

唯一會設定它們的是 `SETUP.lsp:302-304`（SETUP 對話框），而 `SETUP.lsp`
**從來沒有被任何 `(load ...)` 載入過**（見 §3.2），所以 `c:setup` 這個指令
在目前的 DraftSight 環境根本不存在。

**結論**：`powerpdm_path` 等變數執行期恆為 nil，這是本文所有判斷的基礎。

### 1.2 所有 PDM 分支都有守衛

| 位置 | 動作 | 守衛條件 | 會執行嗎 |
|------|------|----------|----------|
| `BOM.lsp:204` | `partout.exe`（PDM 取號） | `(= yyesno "Yes")` | 否 |
| `BOM.lsp:282` | 讀 `pdmcad.txt` | 被 `ccctest` 包住，兩個呼叫點見下 | 否 |
| `BOM.lsp:372` | 寫 `topdmatt.txt` | `(= "Yes" yyesno)` | 否 |
| `BOM.lsp:430` | 追加 `topdmatt.txt` | 同上（在同一個 `foreach` 內） | 否 |
| `BOM.lsp:455` | `topdmatt.exe` | `(= "Yes" yyesno)` | 否 |
| `BOM.lsp:777` | 寫 `partnum.txt` | `out_ok` 的 `(and (/= nil powerpdm_path) …)` | 否 |
| `BOM.lsp:223` | `ccctest` | 在 `get_att_data_list`，其唯一呼叫點 `BOM.lsp:605` 位於 `chg##` 的 `(= "Yes" yyesno)` 內 | 否 |
| `BOM.lsp:346` | `ccctest` | `(= "Yes" yyesno)` | 否 |

`yyesno` 由 `c:out` 開頭設為 nil，只有 `connect_powerpdm` 會改它——
而那個函式整段包在 `(if (and (/= nil powerpdm_path) (/= nil $pdm_dwgname)) …)` 裡。

**所以 `yyesno` 永遠是 nil，不可能是 `"Yes"`。**

### 1.3 「pdm」這個字有三種意思，只有一種該砍

這是本次最容易誤砍的地方。全專案 `pdm` 出現在 11 支檔案裡，但意思完全不同：

| 類別 | 例子 | 處置 |
|------|------|------|
| **A. 真正的 PDM 連線** | `powerpdm_path`、`topdmatt.exe`、`sheet_to_pdm` | **可移除** |
| **B. 欄位對應名稱** | `DFSYSTEM.lsp` 全部 37 處、`MANAPART.lsp` 的 `pdmlist` | **絕對不可動** |
| **C. 名字裡有 pdm 但與 PDM 無關** | `c:pdmwblk`、`c:cap_sybom`、`pdmbom3.txt` | **功能保留** |

**類別 B 的說明**：`PART_DEF` 與 `BOM_FIELD_DEF` 的每一筆是
`("顯示名稱" "PDM欄位名" "TAGn")`，第 2 欄歷史上叫「PDM 欄位」，
但現在它只是**物料清單欄位與圖塊屬性 TAG 的對應鍵**。
`c:defbom`（定義材料清單欄位）、`c:bomlist`、`bomtree` 全部靠它運作。
動它等於打掉整個物料清單系統。

**類別 C 的說明**：`c:pdmwblk`（選單上是「建立內部 BLOCK」）
實際內容是 `getfiled` + `wblock` + `append_to_dwg_db`，
從頭到尾沒碰 PDM，只是名字誤導。**最多改名，不能移除功能。**

---

## 2. 外部 .exe 完整清單

以 `startapp` 為準（`git grep -in startapp`）。註：`change.exe`、`P.EXE`、`U.exe`、
`SETUP.EXE` 用檔名字串去搜會有大量假陽性，因為 `change`、`p`、`u`、`setup`
同時是 LISP 的內建指令名與常用變數名。

### 2.1 CAMPRO / ERP 系列（建議全部移除）

| # | 位置 | 外呼 | 用途 | 備註 |
|---|------|------|------|------|
| 1 | `COMMAND.lsp:25` | `campro.exe DrawNo;0` | 開圖時自動更新圖框資料 | **每次開新圖都會跑**，見下方警告 |
| 2 | `campro.lsp:297` | `campro.exe DrawNo;2` | PDM 取圖框定比例 | 選單「PDM取圖框定比例」 |
| 3 | `campro.lsp:303` | `campro.exe DrawNo;1` | 更新圖框資料 | 選單「更新圖框資料」 |
| 4 | `campro.lsp:322` | `CamproPdm.bat` → `campropdm.exe` | 圖框資料寫入 PDM | 選單「圖框資料寫入PDM」 |
| 5 | `campro.lsp:360` | `CamproBom.bat` → `camprobom.exe` | 查 SQL 取料號資料 | **已被 `partdata.txt` 取代** |
| 6 | `campro.lsp:135` | `Bomtopdm.bat` → `bomtopdm.exe` | 物料清單寫入 PDM | 選單「組合圖框資料寫入PDM」 |

> ### ⚠ 第 1 項現在是活的
>
> `campro.ini` 目前是 `[SHEET] update=1`（commit `7ab9ba4`，測試中切換的）。
> 在這個狀態下，`c:autoload` 每次執行都會跑 `(startapp "campro.exe" "圖號;0")`
> ——也就是**每開一張新圖就啟動一次 campro.exe**。
> 後端 ERP 已經不存在，所以它要嘛安靜失敗、要嘛留下一個沒有回應的處理程序。
> 這是目前唯一「還在動」的 PDM 外呼。

三個 `.bat` 的內容都是：

```bat
c:
cd \
cd designer6
xxx.exe
```

注意 `cd designer6`——指向**舊的 AutoCAD 安裝目錄**，不是 `DESIGNER6_DS`。
就算後端還活著，這些 .bat 在目前環境下操作的也是舊資料夾。

### 2.2 PDM 資料庫寫入（死碼，隨分支移除）

| # | 位置 | 外呼 | 守衛 |
|---|------|------|------|
| 7 | `BOM.lsp:204` | `partout.exe` | `yyesno="Yes"` → 永不執行 |
| 8 | `BOM.lsp:455` | `topdmatt.exe` | `yyesno="Yes"` → 永不執行 |

這兩支 .exe **不在本專案資料夾裡**（路徑是 `powerpdm_path\autocad\...`），
所以沒有檔案要刪，只有程式碼要清。

### 2.3 清單／結構樹（建議改 .csv）

| # | 位置 | 外呼 | 用途 |
|---|------|------|------|
| 9 | `MANAPART.lsp:1509` | `tree1.exe` | 讀 `bom.out`，顯示結構樹 GUI |
| 10 | `MANAPART.lsp:1511` | `bom1.exe` | 讀 `bom.out`，顯示物料清單 GUI，回寫 `bomup.txt` |

詳見 §4。

### 2.4 與 PDM 無關（**不在本次範圍**）

| # | 位置 | 外呼 | 用途 |
|---|------|------|------|
| 11 | `MANAPART.lsp:437, 512` | `manadwg.exe` | 圖檔管理的縮圖瀏覽選擇器（`c:opendwg` / `c:insdwg`），回寫 `c:\part.txt` |
| 12 | `MANAPART.lsp:416` | `change.exe` | `dwgdata.txt` → `DATA.TXT` / `dwg.db` 轉檔 |
| 13 | `BOM.lsp:849`、`TRANSHT.lsp:14`、`TRAN_ACT.lsp:50`、`HP-K.LSP:162` | `selfile.exe` | 多檔選擇器，回寫 `trans\filelist.txt` |

這三支是**功能性工具**，不是 PDM 連結。它們的共同問題是都要寫
`C:\` 根目錄（`c:\bompath.txt`、`c:\part.txt`），在 Windows 10 UAC 下
非提權執行會失敗——這正是手冊 §5.11 記錄過的無聲失敗來源。
建議另案處理，不要混進這次瘦身。

---

## 3. 可移除的檔案

### 3.1 第一批：PDM 專用，零風險

| 檔案 | 大小 | 理由 |
|------|------|------|
| `PDMSERVER/` 整個目錄（105 檔） | 1.41 MB | AutoCAD 端的 PDM 套件，有自己的 `ACADDOC.OLD.LSP`、`POWERPDM.MNS`。**DraftSight 完全不會載入它**（見 §3.2 可達性分析），與主樹沒有任何 `(load)` 關聯 |
| `bomtopdm.exe`、`bomtopdm.bat` | | 物料清單寫入 PDM |
| `campropdm.exe`、`campropdm.bat` | | 圖框資料寫入 PDM |
| `camprobom.exe`、`camprobom.bat` | | 查 ERP SQL，已被 `partdata.txt` 取代 |
| `Campro.exe` | | CAMPRO 主程式，後端已死 |
| `PDMBOM3.exe` | | 送 ERP 用；`PDMBOM3.LSP` 的呼叫已於 `a765fbc` 移除，現在沒有人叫它 |

小計：**113 檔，約 2.45 MB**

### 3.2 第二批：從未被載入的重複／舊版 .lsp

我從三個進入點（`acad.lsp`、`acaddoc.lsp`、`startup.lsp`）追 `(load "x")`，
可達 50 支 .lsp。以下是**不可達**且經確認有替代品的：

| 檔案 | 大小 | 理由 |
|------|------|------|
| `COMMAND-.LSP` | 59 KB | `COMMAND.lsp` 的舊版副本，內容幾乎相同但少了 campro 段 |
| `FIELDSET.lsp` | 9 KB | `c:fieldset` 的舊版；現行版在 `DFSYSTEM.lsp:4802`，而 `&fieldset` 載入的是 `dfsystem` |
| `HP-K-old.LSP` | 5 KB | 檔名自述 |
| `SYSTEM - 複製.lsp` | 14 KB | 檔名自述 |
| `ermsg.lsp` | 148 bytes | AutoCAD 加密的 LISP，DraftSight 不可能讀 |

小計：**5 檔，約 87 KB**

> **注意**：不可達清單裡還有 `CALA.lsp`、`DCLMENU.lsp`、`HIDEBLK1.lsp`、
> `LAYTOBLK.lsp`、`MANABLK.lsp`、`MECHDIM.lsp`、`SSW.lsp`、`SSX.lsp`、
> `TRANSHT.lsp`、`TRAP_DIR.lsp`、`XBLOCK.lsp`、`setup.lsp`。
> **這些先不要動**——「沒有被 `(load)` 到」可能代表功能壞了（例如 `setup.lsp`
> 讓 SETUP 指令根本不存在），而不是代表可以刪。要逐支確認是「重複」還是「漏接」。

### 3.3 第三批：加密狗相關（需您確認）

| 目錄 | 檔數 | 大小 |
|------|------|------|
| `KB/`（COMMAND / LOADSYS / SETUP + 選單） | 5 | 0.12 MB |
| `安裝Key程式/` | 27 | — |
| `SYSDRVR/`（Sentinel 驅動，含 WIN_31 / WIN_9X / WIN_NT） | 13 | — |

合計 **45 檔，約 6.05 MB**。

移植時已經移除加密狗判斷（`CONFIG.lsp` 第 2 條），`KB/LOADSYS.LSP` 的
`findkey.exe` 從未被載入。`SYSDRVR` 裡甚至有 Windows 3.1 與 Alpha/PowerPC 的
驅動程式。技術上全部可刪，但這牽涉到**您是否還需要保留原始授權安裝來源**，
我不擅自判斷。

### 3.4 這次不碰

- `SETUP/`（12.6 MB 安裝包）——原始安裝媒體，砍了就回不去
- `TUTORIAL/`（教學圖檔）——與程式無關
- `nopdm/`、`Powsoft.mns`、`Powsoft5.mns`、`try.mns` 等舊選單——
  `nopdm/` 這個名字很可能是前人做過的「無 PDM 版選單」，
  **在移除 PDM 選單項之前，這是很有價值的參考**，先留著

---

## 4. 改寫成 .csv 的可行性

### 4.1 結論：可行，而且範本已經在專案裡

`bomtree` 有四種模式，共用同一段資料組裝邏輯，只差輸出目的地：

| typ | 輸出 | 後續動作 | 選單 |
|-----|------|----------|------|
| 0 | `bom.out` | `bom1.exe`，並讀回 `bomup.txt` 更新次組立名稱 | `&bomtree0` |
| 1 | `<檔名>.csv` | **無**（直接完成） | `&bomtree1` |
| 2 | `bom.out` | `tree1.exe` | `&bomtree2` |
| 3 | `bom.out` | 無 | `&bomtree3` |

**typ=1 已經是純 .csv 輸出、不呼叫任何外部程式**（2026-09-10 改的，
含 `sep=;` 表頭讓 Excel 正確分欄）。這就是現成的範本。

而且 `bom.out` 本身就已經是**分號分隔的純文字**：

```
1;3;0;圖層名;品名;材質;#圖號;...
│ │ │
│ │ └── 父系編號
│ └──── 流水號
└────── 1=有資訊點 / 0=無資訊點
```

改寫工作量很小——把 `(setq ff (open ... "bom.out" "w"))` 換成
跟 typ=1 一樣的 `.csv` 開檔 + `sep=;` 表頭，再拿掉 `startapp` 那一行。
**資料本身一個字都不用動。**

### 4.2 各模式的具體建議

**typ=2（結構樹）→ 直接改 .csv。**
`tree1.exe` 的價值是把前三欄渲染成樹狀圖示。改成 .csv 後會失去 GUI 樹狀呈現，
但三欄階層資料完整保留，Excel 裡可以排序、篩選，甚至用樞紐分析。
以「可維護性」換「一個 20 年前的 GUI」，我認為划算。

**typ=0（物料清單）→ 改 .csv，回寫功能改用既有的 `c:bomlist`。**
這一項稍微複雜，因為 `bom1.exe` 有一個**互動回寫**：使用者在 GUI 裡改次組立名稱，
存成 `bomup.txt`，LISP 再讀回來跑 `c:subassname_into_infopoint` 更新資訊點。
單純的 .csv 做不到這件事。

**但專案裡已經有替代品**：`c:bomlist`（選單「產生圖面物料清單」）
用的是 `free_list_designer`——**純 LISP 的 DCL 清單對話框**，
完全不需要外部程式。也就是說「在 DraftSight 裡看物料清單」這件事已經有實作了。

所以建議拆成兩個獨立動作：
- **看清單** → 用現有的 `c:bomlist`
- **匯出** → `bomtree` 改寫 .csv
- **改次組立名稱** → 如果實際還在用，另外評估是否要做一個 DCL 編輯對話框；
  如果已經不用，`bomup.txt` 那段連同 `c:subassname_into_infopoint` 一起清掉

**「還在不在用」這件事我無法從程式判斷，需要您確認。**

### 4.3 .csv 的兩個已知限制

1. **必須寫 `sep=;` 表頭。** 繁體中文 Windows 的 Excel 預設清單分隔符是逗號，
   不寫這行會全部擠在 A 欄。不能改用逗號分隔，因為欄位內容本身可能含逗號。
2. **AutoLISP 產不出真正的 `.xlsx`**（那是 ZIP 壓縮檔）。
   如果最終要 `.xlsx`，得靠外部轉檔——那等於又走回外部程式的老路。
   手冊 §10.8 有記錄這個取捨。

---

## 5. 建議的執行順序

每一步都獨立可驗證、可單獨 revert，維持一次改一件事。

| 階段 | 內容 | 風險 | 狀態 |
|------|------|------|------|
| **1** | 關掉 `campro.ini` 的 `update=1` | 極低 | **完成** `08f1656`，已實測 |
| **2** | 移除 campro 的外呼與 5 個選單項 | 低 | **完成** `70af588` + `5efea7f`，已實測 |
| **3** | 刪 `PDMSERVER/`、13 支 PDM exe/設定、孤立的 campro 模組 | 極低 | **完成** `8ef2594` + `eb3bf8c` + `fc7e4d3` |
| **4** | 清 `BOM.lsp` 的 PDM 程式碼 | 中 | **完成** `834f7cd`(4a) + `aebecf8`(4b)，4a 已實測 |
| **5** | `bomtree` typ=2 改 .csv，移除 `tree1.exe` | 低 | **完成** `f7092da` + `1765c24` |
| **6** | `bomtree` typ=0 改 .csv，移除 `bom1.exe` | 中 | 待辦 — 需先確認次組立名稱回寫還用不用 |
| **7** | 刪 5 支重複／舊版 .lsp | 極低 | 待辦 |
| **8** | 加密狗相關（`KB/`、`安裝Key程式/`、`SYSDRVR/`） | 極低 | 待辦 — 您決定是否保留授權來源 |

### 階段 2 的做法與原計畫不同

原本打算進 `campro.lsp` 逐一挖掉 5 個 `startapp`。查完相依關係後改成
**把 `COMMAND.lsp` 裡唯一的 `(load "campro")` 一起移除**——那 5 個指令是
`campro.lsp` 僅有的進入點，拿掉後整支檔案不可達，裡面的 `startapp` 自然全部失效。
diff 小很多，revert 也乾淨。

而且留著 `(load "campro")` 反而有害：`campro.lsp` 另外定義了 `get_taglist` 與
`symbolstr_list`，這兩個名字 `MANAPART.lsp:3468` 與 `PUB-LISP.lsp:2337`
也各有定義，誰生效取決於載入順序。不載入它就順便消除了這個潛在衝突。

### 階段 3 多刪了三個原本沒列的檔

- `CamproPdm.ini` — 那三支 CAMPRO exe 的 Oracle 連線設定（見 §7）
- `PDMsys.ini` — PowerPDM 用戶端設定，欄位皆空，0 引用
- `.pbd` ×3 — PowerBuilder 動態程式庫，隨對應的 exe 一起走

### 階段 3 完成後的實際狀態

- 刪除 **120 檔**（13 + 2 + 105）。版控檔案 2237 → 2118
  （2237 - 120 = 2117，再加上期間新增的本文件 1 檔）
- 可達的 `.lsp` 50 → 49 支
- 全樹 `startapp` 外呼：campro 系列**歸零**；剩下的是
  `BOM.lsp:204/455`（階段 4）、`MANAPART.lsp:1509/1511`（階段 5-6）、
  以及範圍外的 `selfile.exe` ×4、`manadwg.exe` ×2、`change.exe` ×1

**階段 4 風險標「中」的原因**：`c:out`（拆圖）是這支檔案裡最長的流程，
PDM 分支與正常分支交錯在同一個 `foreach` 裡（`BOM.lsp:425-460`）。
雖然守衛確定永不成立，但刪除時容易誤刪到共用的變數設定。
建議這一階段**先只刪最外層完整的 `(if (= "Yes" yyesno) …)` 區塊**，
保留 `yyesno` 變數本身，分兩次做。

### 預估效果

| 項目 | 數量 |
|------|------|
| 移除檔案（階段 3+7） | 118 檔，約 2.5 MB |
| 加上加密狗（階段 8） | 163 檔，約 8.6 MB |
| 移除程式碼 | `BOM.lsp` 約 120 行、`campro.lsp` 約 80 行 |
| 移除選單項 | 5 項（全部是 campro 的 PDM 功能） |
| 消滅的外部程式相依 | 8 個外呼點 |


### 階段 4 拆兩步的實際結果

4a 只刪不會執行的 `(= "Yes" yyesno)` 區塊（63 行），保留所有會執行的路徑，
讓拆圖功能可以單點驗證；通過後 4b 再清掉孤兒函式與恆真條件（249 行）。
BOM.lsp 1902 → 1590 行，**共減 312 行**。

4a 過程中踩到兩個陷阱，都是「看起來是死區塊、其實不是」：

1. `head` 的 `(if (= "Yes" yyesno) A B)` 是 **if-then-else**，
   else 分支 `(setq insp (getpoint "零件插入點"))` 才是實際執行的。
   整塊刪掉會讓 `insp` 變 nil，而 `chg##` 的 `wblock` 要用它。
2. `chg##` 裡的「檔案已存在是否覆蓋」看似共用邏輯，實為 PDM 模式專用的
   重複版本——存活路徑的提示在 `str_dwgname` 已經有了。

**教訓**：`(if (= X) A B)` 與 `(if (= X) A)` 在掃描結果裡長得一樣，
必須逐一展開看有沒有 else 分支。用括號計數算出區塊範圍後，
還要確認區塊內只有一個子運算式才能整塊刪。

### 階段 4 順帶發現、尚未處理

- `SHSCAL.lsp:1336` 的 `powerpdm_sheet_att_def`：原本唯一的呼叫者是
  `trans_datatxt`，現已無人使用。
- `DCL/Bom.dcl:367` 的 `pdm_selsheet` 對話框定義：隨 `pdm_sel_sheet`
  失去用途。該檔是 cp950，另案處理較安全。

### 階段 5：評估結論被實測推翻

原本的評估是「`tree1.exe` 跑得好好的，改成 .csv 會失去 GUI 樹狀呈現，
要權衡」。實測後發現**前提不成立——它從移植到現在就沒有成功執行過**。

`tree1.exe` 是 Delphi 4 以「執行期套件」方式編譯的，啟動時需要：

| 檔案 | 用途 |
|------|------|
| `Vcl40.bpl` | Delphi 4 VCL 執行期套件 |
| `borlndmm.dll` | Borland 記憶體管理員 |
| `cp3245mt.dll` | Borland C++ 執行期程式庫 |

三個都不是 Windows 內建。全機搜尋（`C:\Windows`、`C:\DESIGNER6`、
`C:\DESIGNER6_DS`、`C:\POWPARTS`）**一個都沒有**。
Windows 載入器找不到就直接放棄建立行程，而 `startapp` 用的 `ShellExecute`
失敗時不回報，所以症狀是「執行後毫無反應」，連錯誤訊息都沒有。

對照組：`bom1.exe` 856 KB（執行期靜態連結）可以執行，
`tree1.exe` 只有 32 KB（依賴外部套件）不能——差別就在這裡。
**判斷一支舊 exe 能不能跑，看檔案大小與匯入表比看它有沒有被呼叫更準。**

所以這一步不是「用 GUI 換 .csv」，而是**把一個壞掉的功能修好**。

### 階段 5 順帶處理的三件事

1. **表頭補上階層三欄。** typ=0/2/3 的資料列開頭多了「有無資訊點、流水號、
   父系編號」，但表頭原本只有 `title.txt` 的欄位名——那兩支 exe 自己知道
   格式所以無所謂，給 Excel 看就會整排錯開。只對 typ=2 補，
   不影響 `bom1.exe` 讀的 `bom.out` 格式。
2. **裸圖名改為 `組合圖;<圖名>`**，否則在 Excel 裡是孤立的一格。
3. **補上 `open` 失敗的守衛**，四種 typ 都受惠（見手冊 §5.11）。

### 另一個實測發現：`C:\bompath.txt` 與完整性標籤

`bom1.exe` 與 `tree1.exe` 都要讀 `C:\bompath.txt` 才知道系統路徑
（那兩支 exe 的年代路徑寫死在 `C:\DESIGNER6`）。而 Windows 10 的 UAC
不允許非提權程式寫入 C 槽根目錄，所以這個檔一直不存在。

**光是建立檔案並給 ACL 權限還不夠**——C 槽根目錄會讓其下建立的檔案繼承
「高完整性等級」標籤（`Mandatory Label\High Mandatory Level:(NW)`），
中完整性的行程（DraftSight 這種一般程式）**不論 ACL 給什麼權限都無法寫入**。

以系統管理員身分執行，兩段缺一不可：

```bat
> C:\bompath.txt echo C:\DESIGNER6_DS\
icacls C:\bompath.txt /setintegritylevel Medium
```

注意重導向要寫在前面（`> 檔案 echo 內容`），否則 cmd 會在內容尾端留一個空格。

這個設定是**每台機器專屬**、沒有進版控。`c:opendwg`、`c:insdwg`、
`trans_data_todwg_db` 三個功能同樣依賴它，而且它們還要讀 `manadwg.exe`
寫的 `c:\part.txt`，那個檔很可能有同樣的完整性標籤問題（未驗證）。
---

## 6. 尚待您確認的三件事

1. **次組立名稱回寫功能還在用嗎？**（`bom1.exe` → `bomup.txt` →
   `c:subassname_into_infopoint`）決定階段 6 要不要補做 DCL 對話框。
2. **結構樹的 GUI 樹狀呈現需要保留嗎？** 若需要，改 .csv 會失去；
   若只是要資料，.csv 更好用。
3. **加密狗的原始安裝來源要保留嗎？**（階段 8，約 6 MB）

---

## 7. ⚠ 發現：版本庫歷史中有明文資料庫密碼

階段 3 刪除 `CamproPdm.ini` 時發現的，**與瘦身本身無關，但需要您處理**。

該檔內容包含：

```ini
[Database]
DBMS=O10 Oracle10g (10.1.0)
LogId=campro
LogPassword=campro35638042
DbParm=PBCatalogOwner='campro'
ServerName=sr2
```

**檔案已在 `8ef2594` 刪除，但這不會把它從 git 歷史中移除。**
它自 `a0c0ec6`（第一個 commit）就存在，任何人 clone 這個 repo
或瀏覽該 commit 都看得到。

### 要判斷的第一件事

`github.com/pjcheng01/Designer6_DS` 這個 repo 目前是 public 還是 private？

- **若是 public** — 應視為已外洩。即使 Oracle 主機 `sr2` 早已不存在，
  `campro35638042` 這組密碼若在別處重複使用過，那些地方都要換掉。
- **若是 private** — 風險低很多，但仍建議處理。

### 可選的處理方式

| 做法 | 效果 | 代價 |
|------|------|------|
| 什麼都不做 | 密碼留在歷史 | 若 repo 為 public 則持續暴露 |
| 改掉該帳號密碼 | 歷史中的字串失效 | 需要能存取該 Oracle 主機；若主機已不存在則無從改起 |
| 用 `git filter-repo` 重寫歷史 | 從所有 commit 中抹除 | **需要 force-push，會改寫所有 commit 的 SHA**；已 clone 的人要重新 clone |
| 把 repo 轉為 private | 阻止外部存取 | 歷史仍在，但只有您看得到 |

**我沒有擅自處理**，因為重寫歷史是破壞性操作且需要 force-push，
而這個環境沒有 GitHub 憑證。這是您的決定。

另外掃過其餘 233 個文字檔，只有 `PDMsys.ini` 有 `UserName=sa`
但 `Password=` 是空的，沒有其他外洩。
