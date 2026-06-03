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
;; 讀取 config.doc，設定所有路徑變數
;; 移除：KEYPRO_PATH（加密狗）、PDM 相關變數
;;----------------------------------------------------------------
(defun config_des50_system (/ OUT_LSPPATH)
  ;; 防護：disk_path 未設定，或 config.doc 不存在時，提示並回傳
  (setq OUT_LSPPATH (if disk_path (get_support_path) "C:\\DESIGNER6_DS\\"))
  (setq config_des50_systemdoc (strcat OUT_LSPPATH "config.doc"))
  (if (or (null disk_path) (null (findfile config_des50_systemdoc)))
    (progn
      (princ "\n[機械設計家] 尚未設定系統路徑，請執行 SETUP 指令進行初始設定。")
      (setq *designer6_ready* nil)
    )
    (progn
      (setq POWDESIGN_path (getfile_val config_des50_systemdoc "機械設計家5.0系統路徑"))
      (if (/= nil POWDESIGN_path)
        (progn
          (setq POWDESIGN_sld_path  (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0系統投影片路徑"))))
          (setq POWDESIGN_dcl_path  (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0系統對話框路徑"))))
          (setq POWDESIGN_dwg_path  (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0系統BLOCK路徑"))))
          (setq POWDESIGN_DATA_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0系統資料庫路徑"))))
          (setq USERMENU_PATH (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0預設功能主程式路徑"))))
          (setq func_col      (atoi (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0預設功能層數")))))
          (setq word1_data_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "標準路徑"))))
          (setq BMANAGER_PATH      (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERBLOCK系統主程式路徑"))))
          (setq BMANAGER_ITEM_PATH (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERBLOCK系統圖庫路徑"))))
          (setq autoplot_dwgpath  (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家新零件出圖中文設定路徑"))))
          (setq autoplot_filepath (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "新零件出圖主程式及設定檔路徑"))))
          (setq powdesign_ini_path (strcat powdesign_path "ini\\"))
          (setq base_dimscale 1)
        )
      )
      ;; POWER MANAGER
      (setq fmpath (getfile_val config_des50_systemdoc "POWERMANAGER系統路徑"))
      (if (and fmpath (/= "" fmpath))
        (progn
          (setq fmpath (getrealstr2 (sys_getstring fmpath)))
          (load "fm")
          (setq VER_LSP (atoi (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERMANAGER語言版")))))
          (if (= 1 ver_lsp) (setq ver_lsp T))
        )
      )
      ;; POWERISO
      (setq poweriso_path (getfile_val config_des50_systemdoc "POWERISO系統路徑"))
      (if (and poweriso_path (/= "" poweriso_path))
        (progn
          (setq poweriso_path (getrealstr2 (sys_getstring poweriso_path)))
          (defun c:isomenu1 () (setq sld1$$ 1 dirpt (strcat poweriso_path "isomenu1\\")) (cond ((null C:sld1) (load "sld1")) (t (princ))) (C:sld1))
          (defun c:isomenu2 () (setq sld1$$ 1 dirpt (strcat poweriso_path "isomenu2\\")) (cond ((null C:sld1) (load "sld1")) (t (princ))) (C:sld1))
          (defun c:isoblk1  () (setq dclmenu_path bmanager_path) (princ) (cond ((null userblkm) (load "userblkm")) (t (princ))) (userblkm "userblkm" "userblkm" "ISODWG" "poweriso" 0))
          (defun c:isoblk2  () (setq dclmenu_path bmanager_path) (princ) (cond ((null userblku) (load "userblku")) (t (princ))) (userblku "userblku" "userblku" "ISODWG" "poweriso" 0))
        )
      )
      ;; POWERPARTS
      (setq POWPARTS_path (getfile_val config_des50_systemdoc "POWERPARTS系統路徑"))
      (if (and POWPARTS_path (/= "" POWPARTS_path))
        (progn
          (setq POWPARTS_path      (getrealstr2 (sys_getstring POWPARTS_path)))
          (setq POWPARTS_sld_path  (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS系統投影片路徑"))))
          (setq POWPARTS_dcl_path  (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS系統對話框路徑"))))
          (setq POWPARTS_dwg_path  (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS系統BLOCK路徑"))))
          (setq POWPARTS_DATA_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS系統資料庫路徑"))))
          (load "FUNCTION")
          (setq powparts_block   (atoi (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "插入新零件HBLOCK後狀態建立")))))
          (setq powparts_BLKNAME (atoi (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "插入新零件名稱建立方式")))))
        )
      )
      (setq *designer6_ready* t)
    )
  )
)

(config_des50_system)
;; 注意：(load "loadsys") 與 (check_which_app) 已移除（加密狗取消）
;; 注意：(load "powerpdm") 已移除（PDM 模組不移植）
