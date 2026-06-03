;;;


;;去除文字串前面所有空格 "    123" ==> "123"
(defun getrealstr2(txt)
   (if (> (strlen txt) 0)
     (progn
       (while (= " " (substr txt 1 1))
         (setq txt (substr txt 2))
       );while
     );progn
   );if
   txt
)

(defun sys_getstring(string)
  (setq count 1 txt "" chktxt t)
  (while chktxt
    (setq utxt (substr string count 1))
    (if (and (/= "" utxt) (/= " " utxt) (/= nil utxt))
      (setq txt (strcat txt utxt)
            count (1+ count))
      (setq chktxt nil)
    );if                                 `
  );while
  txt
)  

;;****************************************************************************************************
;;截取自setup.lsp 若修改則須同步修改(setup.lsp & config.lsp)
;;取support路徑
(defun get_support_path(/ text_data k_num test_txt support_path)
   (setq text_data (getvar "acadprefix"))
   (if (/= nil text_data)
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
       (setq support_path (strcat support_path "\\"))
     );progn
     (progn ;LT
       (setq prefix (getvar "dctcust"))
       (if (= "" prefix)
         (progn
            (setq fontmap (getvar "fontmap"))
            (setq support_path (substr fontmap 1 (- (strlen fontmap) 8)))
         );progn
         (setq support_path (substr PREFIX 1 (- (strlen prefix) 10)))
       );if

     );progn
   );if
   support_path
)
(defun sub_get_support_path(typ / kword str_len)
       (setq str_len (strlen typ))
       (setq kword (substr typ (- str_len 7)))
       (if (= "SUPPORT;" (strcase kword)) (setq k_path (substr typ 1 (- str_len 1))))
       k_path
)
;;****************************************************************************************************

;(defun config_des50_system(/ prefix aa_id out_lsppath)
(defun config_des50_system()
   ;(setq prefix (getvar "dctcust"))
   ;(if (= "" prefix) 
   ;  (progn
   ;     (setq fontmap (getvar "fontmap"))
   ;     (setq OUT_LSPPATH (substr fontmap 1 (- (strlen fontmap) 8)))
   ;  );progn
   ;  (setq OUT_LSPPATH (substr PREFIX 1 (- (strlen prefix) 10)))
   ;);if

   (setq OUT_LSPPATH (get_support_path))

   (setq config_des50_systemdoc (strcat out_lsppath "config.doc"))

   (setq POWDESIGN_path (getfile_val config_des50_systemdoc "機械設計家5.0系統路徑"))
   (if (/= nil POWDESIGN_path)
     (progn
       (setq KEYPRO_PATH POWDESIGN_path)                                         ; keypro 路徑
       (setq POWDESIGN_sld_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc  "機械設計家5.0系統幻燈片路徑"))))
       (setq POWDESIGN_dcl_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc  "機械設計家5.0系統對話框路徑"))))
       (setq POWDESIGN_dwg_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc  "機械設計家5.0系統BLOCK路徑"))))
       (setq POWDESIGN_DATA_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0系統資料庫路徑"))))
     ; (setq des50_bmpdatabase_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0系統影像檔路徑"))))
;;;客戶化功能表設定
       (setq USERMENU_PATH (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0客戶化功能表主程式路徑"))))                    ; 機械設計家 FOR A2000PP客戶化功能表主程式路徑
       (setq func_col (atoi (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家5.0客戶化功能表底色")))))                        ; 機械設計家 FOR A2000PP客戶化功能表色
;;;辭庫設定
       (setq word1_data_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "辭庫路徑"))))         ; 辭庫徑
;;;系統圖庫
       (setq BMANAGER_PATH (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERBLOCK系統主程式路徑"))))                   ; POWER BLOCK 系統主程式路徑
       (setq BMANAGER_ITEM_PATH (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERBLOCK系統圖庫路徑"))))                ; POWER BLOCK 系統圖庫路徑
;;;連續出圖
       (setq autoplot_dwgpath (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械設計家連續出圖內定圖檔路徑"))))                ;  機械設計家 FOR A2000PP 連續出圖內定圖檔路徑
       (setq autoplot_filepath (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "連續出圖主程式與相關檔案路徑"))))                ; 連續出圖內定.lsp, .dcl, .scr, .ini 路徑

       (setq powdesign_ini_path (strcat powdesign_path "ini\\"))
;;客戶比例 1:1 時, dimscale 值為 1 則 (setq base_dimscale 1), dimscale 值為 3 則 (setq base_dimscale 3)
       (setq base_dimscale 1)

     );progn
   );if


;POWERPDM屬性萃取檔路徑=d:\pdmdata\txt\
;CAD拆零件時機種命名方式=1                            ;;拆零件時機種以1.總類 2.子類 3.細類 命名(個人工作目錄partout.txt )
;存圖時自動PURGE不存在的BLOCK=T

;;載入POWER MANAGER
  (setq fmpath (getfile_val config_des50_systemdoc "POWERMANAGER系統路徑"))
  (if (and (/= "" fmpath)(/= nil fmpath))
    (progn
      (setq fmpath (getrealstr2 (sys_getstring fmpath)))       ;POWERMANAGER系統徑
      (load "fm")
      (setq VER_LSP (atoi (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERMANAGER中文版")))))
      (if (= 1 ver_lsp)(setq ver_lsp T))
    );progn
  );if

;載入POWERISO
 (setq poweriso_path (getfile_val config_des50_systemdoc "POWERISO系統路徑"))
 (if (AND (/= nil poweriso_path) (/= "" poweriso_path))
   (progn
     (setq poweriso_path (getrealstr2 (sys_getstring poweriso_path)))       ; POWERISO系統路徑
     (DEFUN C:isomenu1() (setq sld1$$ 1 dirpt (strcat poweriso_path "isomenu1\\"))(cond ((null C:sld1)(load "sld1"))(t (princ))) (C:sld1))
     (DEFUN C:isomenu2() (setq sld1$$ 1 dirpt (strcat poweriso_path "isomenu2\\"))(cond ((null C:sld1)(load "sld1"))(t (princ))) (C:sld1))
     (defun c:isoblk1()(setq dclmenu_path bmanager_path)(PRINC) (cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "ISODWG" "poweriso" 0))
     (defun c:isoblk2()(setq dclmenu_path bmanager_path)(PRINC) (cond ((null userblku)(load "userblku"))(t (princ)))(userblku "userblku" "userblku" "ISODWG" "poweriso" 0))
   );progn
 );if


;載入 POWERPARTS
 (setq POWPARTS_path (getfile_val config_des50_systemdoc "POWERPARTS系統路徑"))
 (if (and (/= nil POWPARTS_path)  (/= "" POWPARTS_path))
   (progn
     (setq POWPARTS_path (getrealstr2 (sys_getstring POWPARTS_path)))       ; POWER PARTS 系統路徑
     (setq POWPARTS_sld_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS系統幻燈片路徑"))))            ; POWER PARTS 系統幻燈片路徑
     (setq POWPARTS_dcl_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS系統對話框路徑"))))            ; POWER PARTS 系統對話框路徑
     (setq POWPARTS_dwg_path  (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS系統BLOCK路徑"))))        ; POWER PARTS 系統BLOCK路徑
     (setq POWPARTS_DATA_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPARTS系統資料庫路徑"))))      ; POWER PARTS 系統資料庫路徑
     (LOAD "FUNCTION")                                          ; 載入 POWPARTS 主程式
     (setq powparts_block (atoi (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械零件以BLOCK型態建立")))))                                ; 1: 建成BLOCK   0: 不建成BLOCK
     (setq powparts_BLKNAME (atoi (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "機械零件名稱建立方式")))))                               ; BLOCK 名稱:   1: USER定   0: 與層名相同
   );progn
 );if

;;;與 PowerPDM 系統聯結
   ;(setq POWERPDM_PATH (getfile_val config_des50_systemdoc "POWERPDM圖文管理系統路徑"))
   (setq POWERPDM_PATH (getfile_val config_des50_systemdoc "POWERPDM圖文管理SERVER端路徑"))
   (if (/= nil POWERPDM_PATH)
     (progn
       ;(setq POWERPDM_PATH (getrealstr2 (sys_getstring powerpdm_path)))
       ;(setq powerpdm_attribdata_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPDM屬性萃取檔路徑"))))
       ;(setq pdm_partouttxt_itemid (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "CAD拆零件時機種命名方式"))))
       ;(setq save_purge_block (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "存圖時自動PURGE不存在的BLOCK"))))
       ;(setq POWERPDM_CAD_PATH (strcat powerpdm_path "autocad\\"))            ;CAD 工具程式路徑
       ;(load "undefine")
       (setq POWERPDM_PATH (getrealstr2 (sys_getstring powerpdm_path)))
       (setq powerpdm_client_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPDM圖文管理系統CLIENT端路徑"))))
       ;;(setq powerpdm_attribdata_path (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "POWERPDM屬性萃取檔路徑"))))
	(setq powerpdm_attribdata_path (getrealstr2 (getfile_val config_des50_systemdoc "POWERPDM屬性萃取檔路徑")))

       (setq pdm_partouttxt_itemid (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "CAD拆零件時機種命名方式"))))
       (setq save_purge_block (getrealstr2 (sys_getstring (getfile_val config_des50_systemdoc "存圖時自動PURGE不存在的BLOCK"))))
       ;(setq POWERPDM_CAD_PATH (strcat (substr powerpdm_path 1 (- (strlen POWERPDM_PATH) 7)) "autocad\\"))            ;CAD 工具程式路徑
       (setq POWERPDM_CAD_PATH (strcat powerpdm_path "autocad\\"))            ;CAD 工具程式路徑
       ;(setq powerpdm_path (strcat powerpdm_path "server\\"))
     );progn
   );if


);defun

(config_des50_system)

(load "loadsys")  ;;載入keypro 系統判斷式
(check_which_app) ;;檢查應用軟體類別
(if (/= nil powerpdm_path) (load "powerpdm"));;此程式之載入,會自動判斷是否有審圖,故必須放在此程式最後一行
