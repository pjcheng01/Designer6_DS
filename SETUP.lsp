;;;;
;; setup.lsp - DraftSight 2025 移植版本
;; 原始版本：AutoCAD Designer6
;; 移植說明：
;;   1. get_support_path 改用 SRCHPATH 系統變數（DraftSight）
;;   2. writeto_acaddoc_lsp 改為 writeto_startup_lsp
;;   3. 移除 AutoCAD LT 相關判斷（writeto_toolkitdoc_lsp）
;;   4. 移除加密狗檢查
;;   5. 選單系統待後續移植

;;----------------------------------------------------------------
;; 取得 Support 路徑
;; DraftSight 使用 SRCHPATH 系統變數（格式與 acadprefix 相同，分號分隔）
;;----------------------------------------------------------------
(defun get_support_path (/ text_data k_num test_txt support_path)
  (setq text_data (getvar "SRCHPATH"))
  (if (and text_data (/= "" text_data))
    (progn
      (setq k_num (get_word text_data ";"))
      (setq test_txt (substr text_data 1 k_num))
      (setq support_path (sub_get_support_path test_txt))
      (setq text_data (substr text_data (1+ k_num)))
      (setq k_num (get_word text_data ";"))
      (while (/= nil k_num)
        (setq test_txt (substr text_data 1 k_num))
        (setq support_path (sub_get_support_path test_txt))
        (setq text_data (substr text_data (1+ k_num)))
        (setq k_num (get_word text_data ";"))
      )
      (setq k_path nil)
      (if support_path
        (setq support_path (strcat support_path "\\"))
        (if disk_path
          (setq support_path (strcat disk_path "\\"))
          (setq support_path "C:\\DESIGNER6_DS\\")
        )
      )
    )
    ;; SRCHPATH 無法取得時，fallback
    (if disk_path
      (setq support_path (strcat disk_path "\\"))
      (setq support_path "C:\\DESIGNER6_DS\\")
    )
  )
  support_path
)

(defun sub_get_support_path (typ / kword str_len)
  (setq str_len (strlen typ))
  (setq kword (substr typ (- str_len 7)))
  (if (= "SUPPORT;" (strcase kword)) (setq k_path (substr typ 1 (- str_len 1))))
  k_path
)

;;----------------------------------------------------------------
;; 字串處理工具函式（與 AutoCAD 版本完全相同）
;;----------------------------------------------------------------

;; 去除字串前端空白 "    123" ==> "123"
(defun getrealstr2 (txt)
  (if (> (strlen txt) 0)
    (progn
      (while (= " " (substr txt 1 1))
        (setq txt (substr txt 2))
      )
    )
  )
  txt
)

;; 去除字串所有空白 "    123 qwer   " ==> "123qwer"
(defun getrealstr4 (txtt / count txt ttid)
  (setq count 1 txt "")
  (repeat (strlen txtt)
    (if (/= " " (setq ttid (substr txtt count 1)))
      (setq txt (strcat txt ttid))
    )
    (setq count (1+ count))
  )
  txt
)

;; 去除前後空白 "    123 qwer   " ==> "123 qwer"
(defun getrealstr3 (txtt / a b)
  (setq a (getrealstr txtt))
  (setq b (getrealstr2 a))
  b
)

;; 去除路徑尾端的 / 或 \
(defun canceltxt (txtt / len txt)
  (if (/= "" txtt)
    (progn
      (setq len (strlen txtt))
      (setq txt (substr txtt len 1))
      (if (or (= "/" txt) (= "\\" txt))
        (setq txtt (substr txtt 1 (- len 1)))
      )
    )
  )
  txtt
)

;;----------------------------------------------------------------
;; 檢查檔案是否已寫入設定標記
;;----------------------------------------------------------------
(defun check_have_write (docname / qq data already_write)
  (setq already_write nil)
  (setq qq (open docname "r"))
  (setq data (read-line qq))
  (while data
    (if (= ";已寫入系統設定" data)
      (progn
        (setq already_write t data nil)
      )
      (setq data (read-line qq))
    )
  )
  (close qq)
  already_write
)

;;----------------------------------------------------------------
;; 寫入 DraftSight 啟動載入檔 STARTUP.LSP
;; 取代 AutoCAD 的 writeto_acaddoc_lsp
;; DraftSight 在 Support Files Search Path 中自動執行 STARTUP.LSP
;;----------------------------------------------------------------
(defun writeto_startup_lsp (/ startup_path startup_file qq)
  (setq startup_path (strcat disk_path "\\STARTUP.LSP"))
  (if (null (findfile startup_path))
    ;; STARTUP.LSP 不存在，建立新檔
    (progn
      (setq qq (open startup_path "w"))
      (write-line ";; STARTUP.LSP - Designer6 DraftSight 2025 自動載入" qq)
      (write-line (strcat "(load \"" disk_path "\\\\command\")") qq)
      (write-line (strcat "(load \"" disk_path "\\\\quickey\")") qq)
      (write-line "(c:autoload)" qq)
      (write-line ";已寫入系統設定" qq)
      (close qq)
      (princ (strcat "\n已建立 STARTUP.LSP：" startup_path))
    )
    ;; STARTUP.LSP 已存在，檢查是否已寫入
    (if (null (check_have_write startup_path))
      (progn
        (setq qq (open startup_path "a"))
        (write-line (strcat "(load \"" disk_path "\\\\command\")") qq)
        (write-line (strcat "(load \"" disk_path "\\\\quickey\")") qq)
        (write-line "(c:autoload)" qq)
        (write-line ";已寫入系統設定" qq)
        (close qq)
        (princ (strcat "\n已更新 STARTUP.LSP：" startup_path))
      )
      (princ "\nSTARTUP.LSP 已包含設定，略過。")
    )
  )
)

;;----------------------------------------------------------------
;; 設定對話框主函式
;;----------------------------------------------------------------
(defun c:setup (/ yesno design50_id poweriso_id powparts_id fm_id
                   des50database_path des50item_path
                   iso_path parts_path flm_path sp_fg setup_fg ffname)
  (setq ffname (findfile (strcat disk_path "\\setup.lsp")))
  (if (null ffname)
    (princ "\n機械設計家系統安裝路徑輸入錯誤!")
    (progn
      (setq ffname (strcat disk_path "\\pub-lisp"))
      (load ffname)
      (actdcl (strcat disk_path "\\setup") "setup")
      (mode_tile "poweriso_path" 1)
      (mode_tile "powparts_path" 1)
      (mode_tile "fm_path" 1)
      (mode_tile "pdmserver_path" 1)
      (mode_tile "pdmclient_path" 1)
      (mode_tile "atttxt_path" 1)
      (mode_tile "pout_typ" 1)
      (mode_tile "purg_blk" 1)

      (set_tile "design50_path" (strcase disk_path))
      (set_tile "database_path" (strcase (strcat disk_path "\\DATABASE")))
      (set_tile "block_path"    (strcase disk_path))

      (action_tile "design50"  "(set_tile \"design50\" \"1\")")
      (action_tile "poweriso"  "(set_poweriso)")
      (action_tile "powparts"  "(set_powparts)")
      (action_tile "fm"        "(set_fm)")
      (action_tile "powerpdm"  "(set_pdm)")
      (action_tile "accept"    "(setup_ok)")
      (action_tile "cancel"    "(done_dialog)")
      (start_dialog)

      (if setup_fg
        (progn
          (write_configdoc)
          (load_softmenu)
          (c:config_ok)
        )
        (faile_setup)
      )
    )
  )
  (princ)
)

(defun faile_setup ()
  (actdcl (strcat disk_path "\\setup") "allert1")
  (set_tile "messlable"  "安裝不完整!")
  (set_tile "ms_allert1" "安裝不完整!")
  (set_tile "ms_allert2" "機械設計家系統尚未安裝完成!")
  (action_tile "accept" "(setq sp_fg t)(done_dialog)")
  (action_tile "cancel" "(done_dialog)")
  (start_dialog)
)

;;----------------------------------------------------------------
;; 載入選單
;; TODO: DraftSight 選單系統待移植（目前保留 AutoCAD 版本供參考）
;;----------------------------------------------------------------
(defun load_softmenu ()
  ;; [待移植] DraftSight 不支援 .MNS 選單，此函式待後續移植
  ;; 原 AutoCAD 版本：
  ;;   (command "menuunload" "POWSOFT")
  ;;   (command "menuload" (strcat (get_support_path) "POWSOFT.MNS"))
  ;;   (menucmd "P14=+powsoft.pop11") ...
  (princ "\n[提示] 選單載入功能待移植至 DraftSight，暫時略過。")
  (princ)
)

;;----------------------------------------------------------------
;; 寫入 config.doc
;;----------------------------------------------------------------
(defun write_configdoc (/ wf out_lsppath)
  (setq out_lsppath (get_support_path))
  (setq config_des50_systemdoc (strcat out_lsppath "config.doc"))

  ;; 複製 powsoft.mns 至 support 路徑
  (if (findfile (strcat disk_path "\\powsoft.mns"))
    (progn
      (setq mnsf1 (open (strcat disk_path "\\powsoft.mns") "r"))
      (setq mnsf2 (open (strcat out_lsppath "powsoft.mns") "w"))
      (setq data (read-line mnsf1))
      (while data
        (write-line data mnsf2)
        (setq data (read-line mnsf1))
      )
      (close mnsf1)
      (close mnsf2)
    )
  )

  ;; 寫入 STARTUP.LSP（DraftSight 自動載入機制）
  (writeto_startup_lsp)

  ;; 寫入 config.doc
  (setq ffname (strcat out_lsppath "config.doc"))
  (setq wf (open ffname "w"))
  (write-line ";;設定 機械設計家5.0" wf)
  (write-line (strcat "機械設計家5.0系統路徑=" (strcase des50_path) "\\") wf)
  (write-line (strcat "KEYPRO加密路徑=" (strcase des50_path) "\\") wf)
  (write-line (strcat "機械設計家5.0系統投影片路徑=" (strcase des50_path) "\\SLD\\") wf)
  (write-line (strcat "機械設計家5.0系統對話框路徑=" (strcase des50_path) "\\DCL\\") wf)
  (write-line (strcat "機械設計家5.0系統BLOCK路徑=" (strcase des50_path) "\\DWG\\") wf)
  (write-line (strcat "機械設計家5.0系統資料庫路徑=" (strcase des50database_path) "\\") wf)

  (write-line "" wf)
  (write-line ";;預設功能設定" wf)
  (write-line (strcat "機械設計家5.0預設功能主程式路徑=" (strcase des50_path) "\\") wf)
  (write-line "機械設計家5.0預設功能層數=5" wf)
  (write-line "" wf)
  (write-line ";;標準庫=" wf)
  (write-line (strcat "標準路徑=" (strcase des50database_path) "\\") wf)
  (write-line "" wf)
  (write-line ";;系統圖庫" wf)
  (write-line (strcat "POWERBLOCK系統主程式路徑=" (strcase des50item_path) "\\") wf)
  (write-line (strcat "POWERBLOCK系統圖庫路徑=" (strcase des50item_path) "\\") wf)
  (write-line "" wf)
  (write-line ";新零件出圖" wf)
  (write-line (strcat "機械設計家新零件出圖中文設定路徑=" (strcase des50_path) "\\") wf)
  (write-line (strcat "新零件出圖主程式及設定檔路徑=" (strcase des50_path) "\\") wf)
  (write-line "" wf)
  (write-line ";;設定與 PowerPDM 系統連接" wf)
  (if (= "1" pdm_id)
    (progn
      (write-line (strcat "POWERPDM用戶管理SERVER端路徑=" (strcase powerpdm_path) "\\") wf)
      (write-line (strcat "POWERPDM用戶管理系統CLIENT端路徑=" (strcase powerpdmclient_path) "\\") wf)
      (write-line (strcat "POWERPDM屬性參照檔路徑=" (strcase powerpdm_atttxt_path) "\\") wf)
      (write-line (strcat "CAD儲存檔案命名方式=" pout_typ) wf)
      (write-line (strcat "儲圖時自動PURGE殘存在庫BLOCK=" atttxt_typ) wf)
    )
    (progn
      (write-line ";;POWERPDM用戶管理SERVER端路徑" wf)
      (write-line ";;POWERPDM用戶管理系統CLIENT端路徑" wf)
      (write-line ";;POWERPDM屬性參照檔路徑=" wf)
      (write-line ";;CAD儲存檔案命名方式=" wf)
      (write-line ";;儲圖時自動PURGE殘存在庫BLOCK=" wf)
    )
  )
  (write-line "" wf)
  (write-line ";;設定 POWER MANAGER" wf)
  (if (= "1" fm_id)
    (progn
      (write-line (strcat "POWERMANAGER系統路徑=" (strcase flm_path) "\\") wf)
      (write-line "POWERMANAGER語言版=1" wf)
    )
    (progn
      (write-line ";;POWERMANAGER系統路徑=" wf)
      (write-line ";;POWERMANAGER語言版=1" wf)
    )
  )
  (write-line "" wf)
  (write-line ";;設定 POWERISO" wf)
  (if (= "1" poweriso_id)
    (write-line (strcat "POWERISO系統路徑=" (strcase iso_path) "\\") wf)
    (write-line ";;POWERISO系統路徑=" wf)
  )
  (write-line "" wf)
  (write-line ";;設定 POWERPARTS" wf)
  (if (= "1" powparts_id)
    (progn
      (write-line (strcat "POWERPARTS系統路徑=" (strcase parts_path) "\\") wf)
      (write-line (strcat "POWERPARTS系統投影片路徑=" (strcase parts_path) "\\sld\\") wf)
      (write-line (strcat "POWERPARTS系統對話框路徑=" (strcase parts_path) "\\dcl\\") wf)
      (write-line (strcat "POWERPARTS系統BLOCK路徑=" (strcase parts_path) "\\dwg\\") wf)
      (write-line (strcat "POWERPARTS系統資料庫路徑=" (strcase parts_path) "\\database\\") wf)
      (write-line "插入新零件HBLOCK後狀態建立=0" wf)
      (write-line "插入新零件名稱建立方式=0" wf)
    )
    (progn
      (write-line ";;POWERPARTS系統路徑=" wf)
      (write-line ";;POWERPARTS系統投影片路徑=" wf)
      (write-line ";;POWERPARTS系統對話框路徑=" wf)
      (write-line ";;POWERPARTS系統BLOCK路徑=" wf)
      (write-line ";;POWERPARTS系統資料庫路徑=" wf)
      (write-line ";;插入新零件HBLOCK後狀態建立=0" wf)
      (write-line ";;插入新零件名稱建立方式=0" wf)
    )
  )
  (close wf)
)

;;----------------------------------------------------------------
;; 讀取對話框，驗證路徑
;;----------------------------------------------------------------
(defun setup_ok ()
  (setq design50_id      (get_tile "design50"))
  (setq poweriso_id      (get_tile "poweriso"))
  (setq powparts_id      (get_tile "powparts"))
  (setq fm_id            (get_tile "fm"))
  (setq pdm_id           (get_tile "powerpdm"))
  (setq des50_path        (getrealstr3 (get_tile "design50_path")))
  (setq des50database_path (getrealstr3 (get_tile "database_path")))
  (setq des50item_path    (getrealstr3 (get_tile "block_path")))

  (if (= "1" poweriso_id) (setq iso_path  (canceltxt (getrealstr3 (get_tile "poweriso_path")))))
  (if (= "1" powparts_id) (setq parts_path (canceltxt (getrealstr3 (get_tile "powparts_path")))))
  (if (= "1" fm_id)       (setq flm_path   (canceltxt (getrealstr3 (get_tile "fm_path")))))
  (if (= "1" pdm_id)
    (progn
      (setq powerpdmclient_path    (getrealstr3 (get_tile "pdmclient_path")))
      (setq powerpdm_path          (getrealstr3 (get_tile "pdmserver_path")))
      (setq powerpdm_atttxt_path   (getrealstr3 (get_tile "atttxt_path")))
      (setq pout_typ  (nth (atoi (get_tile "pout_typ"))  pout_list))
      (setq atttxt_typ (nth (atoi (get_tile "purg_blk")) pg_list))
    )
  )
  (cond
    ((null (findfile (strcat des50_path "\\config.lsp")))
     (set_tile "error" "機械設計家安裝目錄輸入錯誤!"))
    ((null (findfile (strcat des50database_path "\\WORDLIB.DAT")))
     (set_tile "error" "系統資料庫路徑(標準)輸入錯誤!"))
    ((null (findfile (strcat des50item_path "\\userblkm.lsp")))
     (set_tile "error" "圖庫系統(ITEM*)路徑輸入錯誤!"))
    ((and (= "1" poweriso_id) (null (findfile (strcat iso_path "\\isosha.lsp"))))
     (set_tile "error" "POWERISO安裝目錄:輸入錯誤!"))
    ((and (= "1" powparts_id) (null (findfile (strcat parts_path "\\V1PARTS.lsp"))))
     (set_tile "error" "POWERPARTS安裝目錄輸入錯誤!"))
    ((and (= "1" fm_id) (null (findfile (strcat flm_path "\\fm.lsp"))))
     (set_tile "error" "POWER MANAGER安裝目錄輸入錯誤!"))
    (T (done_dialog) (setq setup_fg t))
  )
  (princ)
)

;;----------------------------------------------------------------
;; 模組勾選事件處理
;;----------------------------------------------------------------
(defun set_poweriso (/ iso_id)
  (setq iso_id (get_tile "poweriso"))
  (if (= "1" iso_id)
    (progn (mode_tile "poweriso_path" 0) (set_tile "poweriso_path" "C:\\POWERISO"))
    (progn (mode_tile "poweriso_path" 1) (set_tile "poweriso_path" ""))
  )
)

(defun set_powparts (/ parts_id)
  (setq parts_id (get_tile "powparts"))
  (if (= "1" parts_id)
    (progn (mode_tile "powparts_path" 0) (set_tile "powparts_path" "C:\\POWPARTS_DS"))
    (progn (mode_tile "powparts_path" 1) (set_tile "powparts_path" ""))
  )
)

(defun set_fm (/ fm_id)
  (setq fm_id (get_tile "fm"))
  (if (= "1" fm_id)
    (progn (mode_tile "fm_path" 0) (set_tile "fm_path" "C:\\FM"))
    (progn (mode_tile "fm_path" 1) (set_tile "fm_path" ""))
  )
)

(defun set_pdm (/ pdm_id)
  (setq pdm_id (get_tile "powerpdm"))
  (if (= "1" pdm_id)
    (progn
      (mode_tile "pdmserver_path" 0)
      (mode_tile "pdmclient_path" 0)
      (mode_tile "atttxt_path"    0)
      (mode_tile "pout_typ"       0)
      (mode_tile "purg_blk"       0)
      (setq pout_list (list "自訂" "一般" "子圖" "組圖"))
      (setq pg_list   (list "YES" "NO"))
      (act_pop_list pout_list "pout_typ")
      (act_pop_list pg_list   "purg_blk")
      (set_tile "pdmserver_path" "\\\\NTSERVER\\POWERTECH")
      (set_tile "pdmclient_path" "C:\\PowerPDM")
      (set_tile "atttxt_path"    "\\\\NTSERVER\\POWERTECH\\圖庫屬性參照檔")
    )
    (progn
      (mode_tile "pdmclient_path" 1)
      (mode_tile "pdmserver_path" 1)
      (mode_tile "atttxt_path"    1)
      (mode_tile "pout_typ"       1)
      (mode_tile "purg_blk"       1)
      (set_tile "pdmserver_path" "")
      (set_tile "pdmclient_path" "")
      (set_tile "atttxt_path"    "")
    )
  )
)

;;----------------------------------------------------------------
;; 設定完成訊息
;;----------------------------------------------------------------
(defun c:config_ok (/ ffname)
  (setq ffname (strcat disk_path "\\setup"))
  (actdcl ffname "allert1")
  (set_tile "messlable"  "系統安裝完成")
  (set_tile "ms_allert1" "系統安裝完成,請重新啟動,並請您儲存後,重新使用程式!")
  (action_tile "accept" "(done_dialog)")
  (start_dialog)
  (princ)
)

;;----------------------------------------------------------------
;; 設定進入點
;; 取代原 c:config_path，移除 AutoCAD LT 判斷與 acadver 版本判斷
;;----------------------------------------------------------------
(defun c:config_path (/ ffname)
  (setvar "cmdecho" 0)
  (setq disk_path nil)
  (if (null disk_path)
    (setq disk_path (getstring "\n機械設計家系統安裝路徑: "))
  )
  (setq ffname (findfile (strcat disk_path "\\setup.lsp")))
  (if (null ffname)
    (princ "\n機械設計家系統安裝路徑輸入錯誤!")
    (c:setup)
  )
  (setvar "cmdecho" 1)
)

(c:config_path)
(princ)
