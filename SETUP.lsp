;;;;
;; setup.lsp - DraftSight 2025 移植版本
;; 移植說明：
;;   1. get_support_path 改用 SRCHPATH
;;   2. writeto_acaddoc_lsp 改為 writeto_startup_lsp
;;   3. 移除 AutoCAD LT 判斷
;;   4. config.doc 改用英文 key，避免編碼問題

;;----------------------------------------------------------------
;; 取得 Support 路徑
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
;; 字串工具
;;----------------------------------------------------------------
(defun getrealstr2 (txt)
  (if (> (strlen txt) 0)
    (while (= " " (substr txt 1 1))
      (setq txt (substr txt 2))
    )
  )
  txt
)

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

(defun getrealstr3 (txtt / a b)
  (setq a (getrealstr txtt))
  (setq b (getrealstr2 a))
  b
)

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

(defun check_have_write (docname / qq data already_write)
  (setq already_write nil)
  (setq qq (open docname "r"))
  (setq data (read-line qq))
  (while data
    (if (= ";DS_CONFIG_WRITTEN" data)
      (setq already_write t data nil)
      (setq data (read-line qq))
    )
  )
  (close qq)
  already_write
)

;;----------------------------------------------------------------
;; 寫入 STARTUP.LSP
;;----------------------------------------------------------------
(defun writeto_startup_lsp (/ startup_path qq)
  (setq startup_path (strcat disk_path "\\STARTUP.LSP"))
  (if (null (findfile startup_path))
    (progn
      (setq qq (open startup_path "w"))
      (write-line ";; STARTUP.LSP - Designer6 DraftSight 2025" qq)
      (write-line "(load \"command\")" qq)
      (write-line "(load \"quickey\")" qq)
      (write-line "(c:autoload)" qq)
      (write-line ";DS_CONFIG_WRITTEN" qq)
      (close qq)
      (princ (strcat "\n已建立 STARTUP.LSP：" startup_path))
    )
    (if (null (check_have_write startup_path))
      (progn
        (setq qq (open startup_path "a"))
        (write-line "(load \"command\")" qq)
        (write-line "(load \"quickey\")" qq)
        (write-line "(c:autoload)" qq)
        (write-line ";DS_CONFIG_WRITTEN" qq)
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
      (unload_dialog dcl_id)
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
  (unload_dialog dcl_id)
)

(defun load_softmenu ()
  ;; [待移植] DraftSight 選單系統待後續移植
  (princ "\n[提示] 選單載入功能待移植至 DraftSight，暫時略過。")
  (princ)
)

;;----------------------------------------------------------------
;; 寫入 config.doc（全用英文 key，避免編碼問題）
;;----------------------------------------------------------------
(defun write_configdoc (/ wf out_lsppath ffname)
  (setq out_lsppath (get_support_path))

  ;; 複製 powsoft.mns
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

  ;; 寫入 STARTUP.LSP
  (writeto_startup_lsp)

  ;; 寫入 config.doc
  (setq ffname (strcat out_lsppath "config.doc"))
  (setq wf (open ffname "w"))
  (write-line ";;Designer6 DraftSight config" wf)
  (write-line (strcat "DESIGN_PATH=" (strcase des50_path) "\\") wf)
  (write-line (strcat "DESIGN_SLD_PATH=" (strcase des50_path) "\\SLD\\") wf)
  (write-line (strcat "DESIGN_DCL_PATH=" (strcase des50_path) "\\DCL\\") wf)
  (write-line (strcat "DESIGN_DWG_PATH=" (strcase des50_path) "\\DWG\\") wf)
  (write-line (strcat "DESIGN_DATA_PATH=" (strcase des50database_path) "\\") wf)
  (write-line "" wf)
  (write-line (strcat "USERMENU_PATH=" (strcase des50_path) "\\") wf)
  (write-line "FUNC_COL=5" wf)
  (write-line "" wf)
  (write-line (strcat "WORD_DATA_PATH=" (strcase des50database_path) "\\") wf)
  (write-line "" wf)
  (write-line (strcat "BMANAGER_PATH=" (strcase des50item_path) "\\") wf)
  (write-line (strcat "BMANAGER_ITEM_PATH=" (strcase des50item_path) "\\") wf)
  (write-line "" wf)
  (write-line (strcat "AUTOPLOT_DWGPATH=" (strcase des50_path) "\\") wf)
  (write-line (strcat "AUTOPLOT_FILEPATH=" (strcase des50_path) "\\") wf)
  (write-line "" wf)
  (if (= "1" fm_id)
    (progn
      (write-line (strcat "POWERMANAGER_PATH=" (strcase flm_path) "\\") wf)
      (write-line "POWERMANAGER_VER=1" wf)
    )
    (progn
      (write-line ";;POWERMANAGER_PATH=" wf)
      (write-line ";;POWERMANAGER_VER=1" wf)
    )
  )
  (write-line "" wf)
  (if (= "1" poweriso_id)
    (write-line (strcat "POWERISO_PATH=" (strcase iso_path) "\\") wf)
    (write-line ";;POWERISO_PATH=" wf)
  )
  (write-line "" wf)
  (if (= "1" powparts_id)
    (progn
      (write-line (strcat "POWERPARTS_PATH=" (strcase parts_path) "\\") wf)
      (write-line (strcat "POWERPARTS_SLD_PATH=" (strcase parts_path) "\\sld\\") wf)
      (write-line (strcat "POWERPARTS_DCL_PATH=" (strcase parts_path) "\\dcl\\") wf)
      (write-line (strcat "POWERPARTS_DWG_PATH=" (strcase parts_path) "\\dwg\\") wf)
      (write-line (strcat "POWERPARTS_DATA_PATH=" (strcase parts_path) "\\database\\") wf)
      (write-line "POWPARTS_BLOCK=0" wf)
      (write-line "POWPARTS_BLKNAME=0" wf)
    )
    (progn
      (write-line ";;POWERPARTS_PATH=" wf)
      (write-line ";;POWERPARTS_SLD_PATH=" wf)
      (write-line ";;POWERPARTS_DCL_PATH=" wf)
      (write-line ";;POWERPARTS_DWG_PATH=" wf)
      (write-line ";;POWERPARTS_DATA_PATH=" wf)
      (write-line ";;POWPARTS_BLOCK=0" wf)
      (write-line ";;POWPARTS_BLKNAME=0" wf)
    )
  )
  (close wf)
)

;;----------------------------------------------------------------
;; 讀取對話框，驗證路徑
;;----------------------------------------------------------------
(defun setup_ok ()
  (setq design50_id       (get_tile "design50"))
  (setq poweriso_id       (get_tile "poweriso"))
  (setq powparts_id       (get_tile "powparts"))
  (setq fm_id             (get_tile "fm"))
  (setq pdm_id            (get_tile "powerpdm"))
  (setq des50_path        (getrealstr3 (get_tile "design50_path")))
  (setq des50database_path (getrealstr3 (get_tile "database_path")))
  (setq des50item_path    (getrealstr3 (get_tile "block_path")))
  (if (= "1" poweriso_id) (setq iso_path   (canceltxt (getrealstr3 (get_tile "poweriso_path")))))
  (if (= "1" powparts_id) (setq parts_path (canceltxt (getrealstr3 (get_tile "powparts_path")))))
  (if (= "1" fm_id)       (setq flm_path   (canceltxt (getrealstr3 (get_tile "fm_path")))))
  (if (= "1" pdm_id)
    (progn
      (setq powerpdmclient_path  (getrealstr3 (get_tile "pdmclient_path")))
      (setq powerpdm_path        (getrealstr3 (get_tile "pdmserver_path")))
      (setq powerpdm_atttxt_path (getrealstr3 (get_tile "atttxt_path")))
      (setq pout_typ   (nth (atoi (get_tile "pout_typ"))  pout_list))
      (setq atttxt_typ (nth (atoi (get_tile "purg_blk")) pg_list))
    )
  )
  (cond
    ((null (findfile (strcat des50_path "\\config.lsp")))
     (set_tile "error" "機械設計家安裝目錄輸入錯誤!"))
    ((null (findfile (strcat des50database_path "\\WORDLIB.DAT")))
     (set_tile "error" "系統資料庫路徑輸入錯誤!"))
    ((null (findfile (strcat des50item_path "\\userblkm.lsp")))
     (set_tile "error" "圖庫系統路徑輸入錯誤!"))
    ((and (= "1" poweriso_id) (null (findfile (strcat iso_path "\\isosha.lsp"))))
     (set_tile "error" "POWERISO安裝目錄輸入錯誤!"))
    ((and (= "1" powparts_id) (null (findfile (strcat parts_path "\\V1PARTS.lsp"))))
     (set_tile "error" "POWERPARTS安裝目錄輸入錯誤!"))
    ((and (= "1" fm_id) (null (findfile (strcat flm_path "\\fm.lsp"))))
     (set_tile "error" "POWER MANAGER安裝目錄輸入錯誤!"))
    (T (done_dialog) (setq setup_fg t))
  )
  (princ)
)

;;----------------------------------------------------------------
;; 模組勾選事件
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
      (set_tile "atttxt_path"    "\\\\NTSERVER\\POWERTECH\\atttxt")
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
  (unload_dialog dcl_id)
  (princ)
)

;;----------------------------------------------------------------
;; 設定進入點
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
