;;;;
;;配合config.lsp 若修改則須同步修改(setup.lsp & config.lsp)
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

;;去除文字串前後面所有空格 "    123 qwer   " ==> "123 qwer"
(defun getrealstr4(txtt / count txt ttid)
   (setq count 1 txt "")
   (repeat (strlen txtt)
     (if (/= " " (setq ttid (substr txtt count 1)))
        (setq txt (strcat txt ttid))
     )(setq count (1+ count))
   )
   txt
)

;;去除文字串前後面與中間所有空格 "    123 qwer   " ==> "123qwer"
(defun getrealstr3(txtt / a b)
   (setq a (getrealstr  txtt))
   (setq b (getrealstr2 a))
   b
)

(defun canceltxt(txtt / len txt)
  (if (/= "" txtt)
    (progn
      (setq len (strlen txtt))
      (setq txt (substr txtt len 1))
      (if (or (= "/" txt)(= "\\" txt))(setq txtt (substr txtt 1 (- len 1))))
    );progn
  );if
  txtt
)

(defun c:setup(/  yesno design50_id poweriso_id powparts_id fm_id  des50database_path des50item_path
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
           ;(set_tile "database_path" "\\\\CSF205-PDM\\POWERTECH\\DESIGNER6\\DATABASE")
           ;(set_tile "block_path" "\\\\CSF205-PDM\\POWERTECH\\DESIGNER6")
           (set_tile "database_path" (strcase (strcat disk_path  "\\DATABASE")))
           (set_tile "block_path" (strcase disk_path))

           (action_tile "design50" "(set_tile \"design50\" \"1\")")
           (action_tile "poweriso" "(set_poweriso)")
           (action_tile "powparts" "(set_powparts)")
           (action_tile "fm" "(set_fm)")
           (action_tile "powerpdm" "(set_pdm)")

           (action_tile "accept" "(setup_ok)")
           (action_tile "cancel" "(done_dialog)")
           (start_dialog)
           (if setup_fg
              (progn
                
                ; (alert "A")
                 (write_configdoc)
                ; (alert "B")
                 (load_softmenu)
                ; (alert "C")
                 (c:config_ok)
                ; (alert "D")
              );progn
              (faile_setup)
             
           );if
           
         );progn
       );if
   (princ)

)

(defun faile_setup()
                 (actdcl (strcat disk_path "\\setup") "allert1")
                 (set_tile "messlable" "安裝中斷!")
                 (set_tile "ms_allert1" "安裝中斷!")
                 (set_tile "ms_allert2" "機械設計家系統未安裝完成!")
                 (action_tile "accept" "(setq sp_fg t)(done_dialog)")
                 (action_tile "cancel" "(done_dialog)")
                 (start_dialog)
)
(defun load_softmenu()
        (command "menuunload" "POWSOFT")                              ;移除POWER系列功能表
;       (command "menuload" (STRCAT des50_path "\\" "POWSOFT"))        ;重新載入POWER系列功能表
      ; (if pgpfile
      ;     (command "menuload" (STRCAT pgpfile "\\" "POWSOFT"))        ;重新載入POWER系列功能表
            (command "menuload" (STRCAT (get_support_path) "POWSOFT.MNS"))        ;重新載入POWER系列功能表
      ; );if
        (menucmd "P14=+powsoft.pop11")     ;下拉式功能表加入機械設計家
        (menucmd "P15=+powsoft.pop12")     ;下拉式功能表加入機械設計家
        (menucmd "P16=+powsoft.pop13")            ;下拉式功能表加入POWERISO

        (command "toolbar" "辭庫與計算機" "s")
        (command "toolbar" "開放圖庫"     "s")
        (command "toolbar" "放圖框定比例" "s")
        (if (= "1" poweriso_id)(progn
                               (menucmd "P17=+powsoft.pop14")            ;下拉式功能表加入POWERISO
                               (command "toolbar" "POWERISO 等角立體系統圖" "s")
                            );progn
        );if
        (if (= "1" powparts_id) (menucmd "P18=+powsoft.pop15"))           ;下拉式功能表加入POWPARTS
        (if (= "1" fm_id) (progn
                               (menucmd "P19=+powsoft.pop16")            ;下拉式功能表加入POWPARTS
                               (command "toolbar" "POWERMANAGER 圖檔管理" "s")
                           );progn
        );if
        (if (= "1" pdm_id) (menucmd "P20=+powsoft.pop17"))    ;下拉式功能表加入機械設計家


)


(defun check_have_write(docname)
   (setq already_write nil)
   (setq qq (open docname "r"))
   (setq data (read-line qq))
   (while data
      (if (= ";載入系統完成" data)
        (progn
          (setq already_write t data nil)
        );progn
        (setq data (read-line qq))
      )
   );while
   (close qq)
   already_write
);defun

(defun writeto_toolkitdoc_lsp()
  (if (findfile "c:\\Program Files\\Toolkit\\Toolkitdoc.lsp")
    (progn
       (setq name "c:\\Program Files\\Toolkit\\Toolkitdoc.lsp")
       (if (/= t (check_have_write name))
         (progn
           (setq qq (open name "a"))
           (write-line (strcat "(load" " " "\"command\")") qq)
           (write-line (strcat "(load" " " "\"quickey\")") qq)
           (write-line ";載入系統完成" qq) 
       ;   (write-line (strcat "(load" " " "\"designer\")") qq)
       ;   (write-line "(loaddesigner)" qq)
           (close qq)
         );progn
       );if
    );progn
    (progn
      (setq name (getfiled "選取 toolkitdoc.lsp"  "c:\\Program Files\\" "lsp" 8))
      (setq lspname (get_filename (trans_pathtxt name) "/"))
      (if (= "TOOLKITDOC.LSP" (strcase lspname))
        (progn
           (if (/= t (check_have_write name))
             (progn
               (setq qq (open name "a"))
               (write-line (strcat "(load" " " "\"command\")") qq)
               (write-line (strcat "(load" " " "\"quickey\")") qq)
               (write-line ";載入系統完成" qq) 
           ;    (write-line (strcat "(load" " " "\"designer\")") qq)
           ;    (write-line "(loaddesigner)" qq)
               (close qq)
             );progn
           );if
        );progn
      );if
    );progn
  );if
)


(defun writeto_acaddoc_lsp( / nid nid_path slspname support_path_list qq)
       (if (= "14" (substr (getvar "acadver") 1 2))
           (setq slspname "acad.lsp")
           (setq slspname "acaddoc.lsp")
       );if
       (setq support_path(getvar "acadprefix") support_path_list '() nid 1 nid_path "")
       (repeat (strlen support_path)
               (if (= ";" (substr support_path nid 1))
                   (setq support_path_list(cons nid_path support_path_list) nid_path "")
                   (setq nid_path(strcat nid_path (substr support_path nid 1)))
               );if
               (setq nid(+ nid 1))
       );repeat
       (setq support_path_list(reverse support_path_list) nid 0)
       (setq slspfg nil)
       (while (and (null slspfg) (< nid (length support_path_list)))
              (setq slspfg (findfile (strcat (nth nid support_path_list) "\\" slspname)))
              (setq nid (+ nid 1))
       );while
       (if (and (>= nid (length support_path_list)) (null slspfg))
           (setq slspfg (strcat (nth 0 support_path_list) "\\" slspname))
       );if
       ;(alert slspfg)
       
       (if (null (check_have_write slspfg))
           (progn
                (setq qq (open slspfg "a"))
                (write-line (strcat "(load" " " "\"command\")") qq)
                (write-line (strcat "(load" " " "\"quickey\")") qq)
                (if (= "14" (substr (getvar "acadver") 1 2)) 
                    (progn
                         (write-line "(defun S::STARTUP()" qq)
                         (write-line "       (C:autoload)" qq)
                         (write-line ")" qq)
                    );progn
                    (write-line "(c:autoload)" qq)
                );if
                (write-line ";載入系統完成" qq)  
                (close qq)
           );progn
       );if
)

(defun write_configdoc(/ wf OUT_LSPPATH dd_id prefix ff ffname)
;  (setq prefix (getvar "dctcust"))
;  (if (= "" prefix)
;    (progn
 ;      (setq fontmap (getvar "fontmap"))
 ;      (setq OUT_LSPPATH (substr fontmap 1 (- (strlen fontmap) 8)))
;    );progn
;    (setq OUT_LSPPATH (substr PREFIX 1 (- (strlen prefix) 10)))
;  );if
   (setq out_lsppath (get_support_path))

     (setq config_des50_systemdoc (strcat out_lsppath "config.doc"))

        (setq $aver (getvar "acadver"))
        (setq check_id (substr $aver (strlen $aver) 1))

        (if (and (/= ")"  check_id) (/= "14" (substr $aver 1 2)))
          (progn
            (setq mnsf1 (open (strcat DISK_PATH "\\powsoft.mns") "r"))
           (setq mnsf2 (open (strcat (get_support_path) "powsoft.mns") "w"))
           (setq data (read-line mnsf1))
           (while data
             (write-line data mnsf2)
             (setq data (read-line mnsf1))
           );while
           (close mnsf1)
           (close mnsf2)

          ;(setq out_lsppath (STRCAT (getvar "exedir") "SUPPORT\\"))
           (setq out_lsppath (get_support_path))
            (if acadlt_yes (writeto_toolkitdoc_lsp))
          );progn
          (progn
         ;  (setq prefix (getvar "dctcust"))
         ;  (setq OUT_LSPPATH (substr PREFIX 1 (- (strlen prefix) 10)))
         ;  (setq mnsfile (substr PREFIX 1 (- (strlen prefix) 11)))

            (setq config_des50_systemdoc (strcat out_lsppath "config.doc"))

            (setq mnsf1 (open (strcat DISK_PATH "\\powsoft.mns") "r"))
            (setq mnsf2 (open (strcat (get_support_path) "powsoft.mns") "w"))
          ;  (setq mnsf2 (open (strcat mnsfile "\\powsoft.mns") "w"))
            (setq data (read-line mnsf1))
            (while data
              (write-line data mnsf2)
              (setq data (read-line mnsf1))
            );while
            (close mnsf1)
            (close mnsf2)
            (if (null acadlt_yes) (writeto_acaddoc_lsp))
          );progn
        );if
        (setq ffname (strcat out_lsppath "\\config.doc"))
        (setq wf (open ffname "w"))
        (write-line ";;設定 機械設計家5.0" wf)
        (write-line (strcat "機械設計家5.0系統路徑=" (strcase des50_path) "\\") wf)
        (write-line (strcat "KEYPRO執行檔路徑=" (strcase des50_path) "\\") wf)
        (write-line (strcat "機械設計家5.0系統幻燈片路徑=" (strcase des50_path) "\\SLD\\") wf)
        (write-line (strcat "機械設計家5.0系統對話框路徑=" (strcase des50_path) "\\DCL\\") wf)
        (write-line (strcat "機械設計家5.0系統BLOCK路徑=" (strcase des50_path) "\\DWG\\") wf)
        (write-line (strcat "機械設計家5.0系統資料庫路徑=" (strcase des50database_path) "\\") wf)

        (write-line "" wf)
        (write-line ";;客戶化功能表設定" wf)
        (write-line (strcat "機械設計家5.0客戶化功能表主程式路徑=" (strcase des50_path) "\\") wf)
        (write-line "機械設計家5.0客戶化功能表底色=5" wf)
        (write-line "" wf)
        (write-line ";;辭庫庫定=" wf)
        (write-line (strcat "辭庫路徑=" (strcase des50database_path) "\\") wf)
        (write-line "" wf)
        (write-line ";;系統圖庫" wf)
        (write-line (strcat "POWERBLOCK系統主程式路徑=" (strcase des50item_path) "\\") wf)
        (write-line (strcat "POWERBLOCK系統圖庫路徑=" (strcase des50item_path) "\\") wf)
        (write-line "" wf)
        (write-line ";連續出圖" wf)
        (write-line (strcat "機械設計家連續出圖內定圖檔路徑=" (strcase des50_path) "\\") wf)
        (write-line (strcat "連續出圖主程式與相關檔案路徑=" (strcase des50_path) "\\") wf)
        (write-line "" wf)
        (write-line ";;設定與 PowerPDM 系統聯結" wf)
        (if (= "1" pdm_id)
          (progn

            (write-line (strcat "POWERPDM圖文管理SERVER端路徑=" (strcase powerpdm_path) "\\") wf)
            (write-line (strcat "POWERPDM圖文管理系統CLIENT端路徑=" (strcase powerpdmclient_path) "\\") wf)
            (write-line (strcat "POWERPDM屬性萃取檔路徑=" (strcase powerpdm_atttxt_path) "\\") wf)
            (write-line (strcat "CAD拆零件時機種命名方式=" pout_typ) wf)
            (write-line (strcat "存圖時自動PURGE不存在的BLOCK=" atttxt_typ) wf)
          );progn
          (progn
            (write-line ";;POWERPDM圖文管理SERVER端路徑" wf)
            (write-line ";;POWERPDM圖文管理系統CLIENT端路徑" wf)
            (write-line ";;POWERPDM屬性萃取檔路徑=" wf)
            (write-line ";;CAD拆零件時機種命名方式=" wf)
            (write-line ";;存圖時自動PURGE不存在的BLOCK=" wf)
          );progn
        );if
        (write-line "" wf)
        (write-line ";;設定 POWER MANAGER" wf)
        (if (= "1" fm_id)
          (progn
           (write-line (strcat "POWERMANAGER系統路徑=" (strcase flm_path) "\\") wf)
           (write-line "POWERMANAGER中文版=1" wf)      ;1=中文版   0=英文版
          )
          (progn
           (write-line ";;POWERMANAGER系統路徑=" wf)
           (write-line ";;POWERMANAGER中文版=1" wf)      ;1=中文版   0=英文版
          )
        )
        (write-line "" wf)
        (write-line ";;設定 POWERISO" wf)
        (if (= "1" poweriso_id)
          (progn
           (write-line (strcat "POWERISO系統路徑=" (strcase iso_path) "\\") wf)
          );progn
          (progn
           (write-line ";;POWERISO系統路徑=" wf)
          );progn
        )
        (write-line "" wf)
        (write-line ";;設定 POWERPARTS" wf)
        (if (= "1" powparts_id)
          (progn
           (write-line (strcat "POWERPARTS系統路徑=" (strcase parts_path) "\\") wf)
           (write-line (strcat "POWERPARTS系統幻燈片路徑=" (strcase parts_path) "\\sld\\") wf)
           (write-line (strcat "POWERPARTS系統對話框路徑=" (strcase parts_path) "\\dcl\\") wf)
           (write-line (strcat "POWERPARTS系統BLOCK路徑=" (strcase parts_path) "\\dwg\\") wf)
           (write-line (strcat "POWERPARTS系統資料庫路徑=" (strcase parts_path) "\\database\\") wf)
           (write-line "機械零件以BLOCK型態建立=0" wf)                             ; 1: 建成BLOCK   0: 不建成BLOCK
           (write-line "機械零件名稱建立方式=0" wf)                                ; BLOCK 名稱:   1: USER定   0: 與層名相同
          );progn
          (progn
           (write-line ";;POWERPARTS系統路徑=" wf)
           (write-line ";;POWERPARTS系統幻燈片路徑=" wf)
           (write-line ";;POWERPARTS系統對話框路徑=" wf)
           (write-line ";;POWERPARTS系統BLOCK路徑=" wf)
           (write-line ";;POWERPARTS系統資料庫路徑=" wf)
           (write-line ";;機械零件以BLOCK型態建立=0" wf)                             ; 1: 建成BLOCK   0: 不建成BLOCK
           (write-line ";;機械零件名稱建立方式=0" wf)                                ; BLOCK 名稱:   1: USER定   0: 與層名相同
          );progn
        );if
        (close wf)
)

(defun setup_ok()
   (setq design50_id (get_tile "design50"))
   (setq poweriso_id (get_tile "poweriso"))
   (setq powparts_id (get_tile "powparts"))
   (setq fm_id       (get_tile "fm"))
   (setq pdm_id     (get_tile "powerpdm"))
   (setq des50_path (getrealstr3 (get_tile "design50_path")))
   (setq des50database_path (getrealstr3 (get_tile "database_path")))
   (setq des50item_path (getrealstr3 (get_tile "block_path")))

   (if (= "1" poweriso_id) (setq iso_path (canceltxt (getrealstr3 (get_tile "poweriso_path")))))
   (if (= "1" powparts_id) (setq parts_path (canceltxt (getrealstr3 (get_tile "powparts_path")))))
   (if (= "1" fm_id) (setq flm_path (canceltxt (getrealstr3 (get_tile "fm_path")))))
   (if (= "1" pdm_id)
     (progn
       (setq powerpdmclient_path (getrealstr3 (get_tile "pdmclient_path")))
       (setq powerpdm_path (getrealstr3 (get_tile "pdmserver_path")))
       (setq powerpdm_atttxt_path (getrealstr3 (get_tile "atttxt_path")))
       (setq pout_typ (nth (atoi (get_tile "pout_typ")) pout_list))
       (setq atttxt_typ (nth (atoi (get_tile "purg_blk")) pg_list))
     );progn
   );if
   (cond
     ((null (findfile (strcat des50_path "\\config.lsp")))(set_tile "error" "機械設計家安裝目錄輸入錯誤!"))
     ((null (findfile (strcat des50database_path "\\WORDLIB.DAT")))(set_tile "error" "系統資料庫路徑(辭庫)輸入錯誤!"))
     ((null (findfile (strcat des50item_path "\\userblkm.lsp")))(set_tile "error" "圖庫系統(ITEM*)路徑輸入錯誤!"))
     ((and (= "1" poweriso_id)(null (findfile (strcat iso_path "\\isosha.lsp"))))(set_tile "error" "POWERISO安裝目錄:輸入錯誤!"))
     ((and (= "1" powparts_id)(null (findfile (strcat parts_path "\\V1PARTS.lsp"))))(set_tile "error" "POWERPARTS安裝目錄輸入錯誤!"))
     ((and (= "1" fm_id)(null (findfile (strcat flm_path "\\fm.lsp"))))(set_tile "error" "POWER MANAGER安裝目錄輸入錯誤!"))
   ; ((and (= "1" pdm_id)(null (findfile (strcat powerpdm_path "\\POWERPDM1.exe"))))(set_tile "error" "POWERPDM 圖文管理系統安裝目錄輸入錯誤!"))
     (T (done_dialog)(setq setup_fg t))
   )
   (princ)
);defun


(defun set_poweriso(/ iso_id)
  (setq iso_id (get_tile "poweriso"))
  (if (= "1" iso_id)
    (progn
      (mode_tile "poweriso_path" 0)
      (set_tile "poweriso_path" "C:\\POWERISO")
    );progn
    (progn
      (mode_tile "poweriso_path" 1)
      (set_tile "poweriso_path" "")
    );progn
  );if
);defun

(defun set_powparts(/ parts_id)
  (setq parts_id (get_tile "powparts"))
  (if (= "1" parts_id)
    (progn
      (mode_tile "powparts_path" 0)
      (set_tile "powparts_path" "C:\\POWPARTS")
    );progn
    (progn
      (mode_tile "powparts_path" 1)
      (set_tile "powparts_path" "")
    );progn
  );if
);defun


(defun set_fm(/ fm_id)
  (setq fm_id (get_tile "fm"))
  (if (= "1" fm_id)
    (progn
      (mode_tile "fm_path" 0)
      (set_tile "fm_path" "C:\\FM")
    );progn
    (progn
      (mode_tile "fm_path" 1)
      (set_tile "fm_path" "")
    );progn
  );if
);defun

(defun set_pdm(/ pdm_id)
  (setq pdm_id (get_tile "powerpdm"))
  (if (= "1" pdm_id)
    (progn
      (mode_tile "pdmserver_path" 0)
      (mode_tile "pdmclient_path" 0)
      (mode_tile "atttxt_path" 0)
      (mode_tile "pout_typ" 0)
      (mode_tile "purg_blk" 0)
      (setq pout_list (list "自定" "總類" "子類" "細類"))
      (setq pg_list (list "YES" "NO"))
      (act_pop_list pout_list "pout_typ")
      (act_pop_list pg_list "purg_blk")
      (set_tile "pdmserver_path" "\\\\NTSERVER\\POWERTECH")
      (set_tile "pdmclient_path" "C:\\PowerPDM")
      (set_tile "atttxt_path" "\\\\NTSERVER\\POWERTECH\\圖框屬性萃取")
    );progn
    (progn
      (mode_tile "pdmclient_path" 1)
      (mode_tile "pdmserver_path" 1)
      (mode_tile "atttxt_path" 1)
      (mode_tile "pout_typ" 1)
      (mode_tile "purg_blk" 1)
      (set_tile "pdmserver_path" "")
      (set_tile "pdmclient_path" "")
      (set_tile "atttxt_path" "")
    );progn
  );if
);defun

(defun c:config_ok(/ kpy_fg ffname)
    (setq ffname (strcat disk_path "\\setup"))
    (actdcl ffname "allert1")
    (set_tile "messlable" "系統安裝完成")
    (set_tile "ms_allert1" "系統安裝完成,感謝您的惠顧,並祝您使用愉快!       [藝祥資訊]")
    (action_tile "accept" "(done_dialog)")
    (start_dialog)
    (princ)
)

(defun c:config_path()
   (setvar "cmdecho" 0)
   (setq disk_path nil)
   (initget "Yes No")
   (setq yesno (getkword "\nCAD 平台是不是AutoCAD LT 版<Yes>"))
   (if (or (null yesno) (= "Yes" yesno)) (setq acadlt_yes t) (setq acadlt_yes nil))
   (if (null disk_path) (setq disk_path (getstring "\n機械設計家系統安裝路徑: ")))
   (setq ffname (findfile (strcat disk_path "\\setup.lsp")))
   (if (null ffname)
      (princ "\n機械設計家系統安裝路徑輸入錯誤!")
      (progn
        (setq aver (getvar "acadver"))
        (if (= "15" (substr aver 1 2))
            (command "script" (strcat disk_path "\\auto"))
            (progn
                (command "preferences")
                (c:setup)
            );progn
        );if
      )
   )
   (setvar "cmdecho" 1)
);defun
(c:config_path)
(princ)
