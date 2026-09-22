# 資料來源

存放**產生 repo 內資料檔的上游原始資料**。這裡的東西不是程式，也不隨 release 交付。

> ⚠ 這個目錄整個列在 `tools\build_release.ps1` 的 `$EXCLUDE` 裡，**預設不交付**。
> 往這裡新增任何檔案都會自動被擋，這是刻意的（與 `docs\` 同一個設計）。

---

## `CP2匯出料號總表_20260910.xml.gz`

**`partdata.txt` 的上游原始資料。** 2026-09-22 納入版控備份。

| | |
|---|---|
| 來源 | CPII（CP2）以「XML」格式匯出的料號總表 |
| 匯出日 | 2026-09-10 |
| 原始檔 | `CP2匯出料號總表_20260910.xml`，UTF-16LE + BOM，160,834,364 bytes |
| 原始檔 SHA-256 | `63d309e1fcadc8e13fed049f22ae00c745ef178ed01f7a1de518be1089ad5013` |
| 壓縮後 | 4,617,038 bytes（gzip -9，**保留原始位元組，未做編碼轉換**） |
| 內容 | 83,205 筆 × 38 個欄位 |

### 為什麼要留這一份

**一、很可能無法重新產生。** CPII 已停用（所以「CPII 停用後在 Workflow ERP
新建的料號不在這個檔案內」）。系統關掉之後，這份匯出做不出第二次。

**二、`partdata.txt` 救不回它。** 轉檔只留了 6 個欄位、83,190 筆：

```
cod_item / nam_item / nam_eng / dsc_item / material_item / surface_item
```

**其餘 32 個欄位在轉檔時就丟掉了**，包括單位 `cod_unit`、重量
`wgt_item`／`wgt_unit`、分類 `cls_item`／`typ_item`、狀態 `sts_item`、
備註 `remark`、條碼 `barcode_item`、圖片路徑 `pic_path1~3`，
以及建檔／異動／確認／結案的人員與日期時間共 12 個欄位。

日後若要讓資訊點多帶一個欄位（例如重量或單位），**沒有這份 XML 就補不回來**。

**三、OneDrive 不算備份。** 原檔放在 `C:\Users\pjcheng\OneDrive\`，那是同步不是
備份——誤刪會同步過去，版本紀錄與資源回收筒都有保留期限。

### ⚠ 不可隨 release 交付

這份 XML 含**員工帳號**（`emp_inst`、`emp_last`、`emp_conf`、`emp_close`）與完整的
建檔異動軌跡。目前交付給使用者的 `partdata.txt` 只有料號與品名，**沒有**這些資訊。

### 還原方式

```bash
python -c "import gzip,shutil; shutil.copyfileobj(gzip.open(r'CP2匯出料號總表_20260910.xml.gz','rb'), open('CP2匯出料號總表_20260910.xml','wb'))"
```

還原後請用上表的 SHA-256 核對：

```bash
python -c "import hashlib; print(hashlib.sha256(open('CP2匯出料號總表_20260910.xml','rb').read()).hexdigest())"
```

### 怎麼從它產生 `partdata.txt`

```bash
python tools\xml2partdata.py CP2匯出料號總表_20260910.xml
```

預設覆寫 `C:\DESIGNER6_DS\partdata.txt`。詳見手冊 §10.5 與 §9.7。
