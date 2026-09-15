;;;
;; config.lsp - DraftSight 2025 移植版本
;; 原始版本：AutoCAD Designer6
;; 移植說明：
;;   1. get_support_path 的系統變數改成了 SRCHPATH——那是錯的，見下方說明
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
;; 取得 Support 路徑（與 setup.lsp 同一份實作）
;;----------------------------------------------------------------
;; ⚠ 這裡的 "SRCHPATH" 是移植時選錯的變數，不是刻意的設計。
;;    DraftSight 的 325 個系統變數裡沒有 SRCHPATH（原版 AutoCAD 用的是
;;    acadprefix），實測 (getvar "SRCHPATH") 回 nil——不報錯，所以下面
;;    整個 if 的第一分支走不到，一律掉到 fallback 回 disk_path\。
;;
;;    ★ 不要「順手修正」成 acadprefix：DraftSight 回傳的每一段結尾是
;;      "Support\;"（多一個反斜線），sub_get_support_path 比對的是
;;      "SUPPORT;"，取最後 8 字元得到 "upport\;"，一段都不會 match，
;;      結果仍然是 fallback。兩個變數一樣，改了只是多繞一圈，而且會讓
;;      sub_get_support_path 的 (substr typ (- str_len 7)) 活過來
;;      （路徑段少於 8 字元時起始位置 <= 0，substr 會報錯）。
;;
;;    而且對「從資料夾直接跑 setup.lsp」的安裝流程來說，fallback 到
;;    disk_path 反而是唯一正確的答案——那個時間點搜尋路徑還沒設。
;;    詳見手冊 §2.0。
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
;; 去除字串末尾的 \r（Windows CRLF 問題）
;;----------------------------------------------------------------
(defun strip_cr (txt / len)
  (if (and txt (/= "" txt))
    (progn
      (setq len (strlen txt))
      (if (= "\r" (substr txt len 1))
        (setq txt (substr txt 1 (- len 1)))
      )
    )
  )
  txt
)


;;----------------------------------------------------------------
;; 讀取 config.doc（英文 key）- 診斷版本
;;----------------------------------------------------------------
(defun config_des50_system (/ OUT_LSPPATH)
  (setq OUT_LSPPATH (get_support_path))
  (setq config_des50_systemdoc (strcat OUT_LSPPATH "config.doc"))
  (if (null (findfile config_des50_systemdoc))
    (setq config_des50_systemdoc (findfile "config.doc"))
  )
  (if (null config_des50_systemdoc)
    (progn
      (princ "\n[機械設計家] 尚未設定系統路徑，請執行 SETUP 指令進行初始設定。")
      (setq *designer6_ready* nil)
    )
    (progn
      (setq POWDESIGN_path (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "DESIGN_PATH")))))
      (if POWDESIGN_path
        (progn
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
        )
      )
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
      (if (and POWPARTS_path (/= "" POWPARTS_path))
        (progn
          (setq POWPARTS_sld_path  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS_SLD_PATH")))))
          (setq POWPARTS_dcl_path  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS_DCL_PATH")))))
          (setq POWPARTS_dwg_path  (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS_DWG_PATH")))))
          (setq POWPARTS_DATA_path (strip_cr (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS_DATA_PATH")))))
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
