;;;
;; config.lsp - DraftSight 2025 移植版本
;; 原始版本：AutoCAD Designer6
;; 移植說明：
;;   1. get_support_path 改用 SRCHPATH（與 setup.lsp 一致）
;;   2. 移除加密狗：刪除 (load "loadsys")、(check_which_app)、KEYPRO_PATH
;;   3. 移除 PDM 模組（不需移植）
;;   4. 移除 AutoCAD LT 相關判斷

;;----------------------------------------------------------------
;; 字串工具函式
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

(defun sys_getstring (string / count txt chktxt utxt)
  (if (null string)(setq string ""))
  (setq count 1 txt "" chktxt t)
  (while chktxt
    (setq utxt (substr string count 1))
    (if (and (/= "" utxt) (/= " " utxt) (/= nil utxt))
      (setq txt   (strcat txt utxt)
            count (1+ count))
      (setq chktxt nil)
    )
  )
  txt
)

;;----------------------------------------------------------------
;; 取得 Support 路徑（與 setup.lsp 一致，使用 SRCHPATH）
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
          (setq support_path "C:\\DESIGNER6_DS\\")  ; 最終 fallback
        )
      )
    )
    (if disk_path
      (setq support_path (strcat disk_path "\\"))
      (setq support_path "C:\\DESIGNER6_DS\\")  ; 最終 fallback
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
;; 讀取 config.doc（英文 key）- 診斷版本
;;----------------------------------------------------------------
(defun config_des50_system (/ OUT_LSPPATH)
  (princ "\n[DEBUG 1] config_des50_system 開始")
  (setq OUT_LSPPATH (get_support_path))
  (princ (strcat "\n[DEBUG 2] OUT_LSPPATH=" (if OUT_LSPPATH OUT_LSPPATH "NIL")))
  (setq config_des50_systemdoc (strcat OUT_LSPPATH "config.doc"))
  (princ (strcat "\n[DEBUG 3] config_des50_systemdoc=" config_des50_systemdoc))
  (if (null (findfile config_des50_systemdoc))
    (setq config_des50_systemdoc (findfile "config.doc"))
  )
  (princ (strcat "\n[DEBUG 4] findfile result=" (if config_des50_systemdoc config_des50_systemdoc "NIL")))
  (if (null config_des50_systemdoc)
    (progn
      (princ "\n[機械設計家] 尚未設定系統路徑，請執行 SETUP 指令進行初始設定。")
      (setq *designer6_ready* nil)
    )
    (progn
      (princ "\n[DEBUG 5] 開始讀取 DESIGN_PATH")
      (setq POWDESIGN_path (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "DESIGN_PATH")))))
      (princ (strcat "\n[DEBUG 6] POWDESIGN_path=" (if POWDESIGN_path POWDESIGN_path "NIL")))
      (if POWDESIGN_path
        (progn
          (princ "\n[DEBUG 7] 讀取其他路徑變數")
          (setq POWDESIGN_sld_path  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "DESIGN_SLD_PATH")))))
          (setq POWDESIGN_dcl_path  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "DESIGN_DCL_PATH")))))
          (setq POWDESIGN_dwg_path  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "DESIGN_DWG_PATH")))))
          (setq POWDESIGN_DATA_path (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "DESIGN_DATA_PATH")))))
          (setq USERMENU_PATH       (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "USERMENU_PATH")))))
          (setq func_col            (atoi (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "FUNC_COL"))))))
          (setq word1_data_path     (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "WORD_DATA_PATH")))))
          (setq BMANAGER_PATH       (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "BMANAGER_PATH")))))
          (setq BMANAGER_ITEM_PATH  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "BMANAGER_ITEM_PATH")))))
          (setq autoplot_dwgpath    (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "AUTOPLOT_DWGPATH")))))
          (setq autoplot_filepath   (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "AUTOPLOT_FILEPATH")))))
          (setq powdesign_ini_path  (strcat POWDESIGN_path "ini\\"))
          (setq base_dimscale 1)
          (princ "\n[DEBUG 8] 路徑變數讀取完成")
        )
      )
      (princ "\n[DEBUG 9] 讀取模組路徑")
      (setq fmpath (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERMANAGER_PATH")))))
      (if (and fmpath (/= "" fmpath))
        (progn
          (load "fm")
          (setq VER_LSP (atoi (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERMANAGER_VER"))))))
          (if (= 1 ver_lsp) (setq ver_lsp T))
        )
      )
      (setq poweriso_path (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERISO_PATH")))))
      (if (and poweriso_path (/= "" poweriso_path))
        (progn
          (defun c:isomenu1 () (setq sld1$$ 1 dirpt (strcat poweriso_path "isomenu1\\")) (cond ((null C:sld1) (load "sld1")) (t (princ))) (C:sld1))
          (defun c:isomenu2 () (setq sld1$$ 1 dirpt (strcat poweriso_path "isomenu2\\")) (cond ((null C:sld1) (load "sld1")) (t (princ))) (C:sld1))
          (defun c:isoblk1  () (setq dclmenu_path bmanager_path) (princ) (cond ((null userblkm) (load "userblkm")) (t (princ))) (userblkm "userblkm" "userblkm" "ISODWG" "poweriso" 0))
          (defun c:isoblk2  () (setq dclmenu_path bmanager_path) (princ) (cond ((null userblku) (load "userblku")) (t (princ))) (userblku "userblku" "userblku" "ISODWG" "poweriso" 0))
        )
      )
      (setq POWPARTS_path (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS_PATH")))))
      (princ (strcat "\n[DEBUG 10] POWPARTS_path=" (if POWPARTS_path POWPARTS_path "NIL")))
      (if (and POWPARTS_path (/= "" POWPARTS_path))
        (progn
          (setq POWPARTS_sld_path  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS_SLD_PATH")))))
          (setq POWPARTS_dcl_path  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS_DCL_PATH")))))
          (setq POWPARTS_dwg_path  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS_DWG_PATH")))))
          (setq POWPARTS_DATA_path (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS_DATA_PATH")))))
          (princ "\n[DEBUG 11] 載入 FUNCTION.lsp")
          (load "FUNCTION")
          (setq powparts_block   (atoi (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWPARTS_BLOCK"))))))
          (setq powparts_BLKNAME (atoi (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWPARTS_BLKNAME"))))))
        )
      )
      (setq *designer6_ready* t)
      (princ (strcat "\n[機械設計家] 系統載入完成。路徑：" POWDESIGN_path))
    )
  )
)

(config_des50_system)
;; 診斷版本
