;;預先載入程式
(LOAD "PUB-LISP")

;;;與 PowerPDM 系統聯結
(if (null powerpdm_cad_path)
  (progn
    (setq POWERPDM_CAD_PATH "D:\\圖文管理系統\\databse\\autocad\\")             ;CAD 工具程式路徑
    (setq word1_data_path "D:\\圖文管理系統\\databse\\autocad\\")           ; 辭庫路徑
    (setq POWERPDM_PATH "D:\\圖文管理系統\\")                       ;POWERPDM圖文管理系統路徑
    (setq powerpdm_attribdata_path "D:\\圖文管理系統\\圖文資料\\圖框屬性\\")       ;POWERPDM屬性萃取檔路徑
    (setq save_purge_block "YES")                               ;存圖時自動PURGE不存在的BLOCK
    (setq acadlt_yesno t)                                       ; (setq acadlt_yesno t) acad 版本是 LT 版
    (load "powerpdm")
  );progn
);if
(princ)
(load "command")
(load "quickey")
