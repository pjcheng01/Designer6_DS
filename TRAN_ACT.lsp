;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 舊圖轉新圖(應用)                                     │
;;;│  主程式 : trs.lsp                                              │
;;;│  日  期 : 2003/02/10                                           │
;;;│  姓  名 : 許勝瑜                                               │
;;;│  對話框 : transheet.dcl                                        │
;;;│  方  法 : trs                                                  │
;;;│  相關檔案: transdwg.ini transheet.dcl trs.lsp                 │
;;;└────────────────────────────────┘
;;;

(defun c:tran_act()
  
       ;(setq powdesign_path "c:\\designer6\\")
       ;(setq powdesign_ini_path (strcat powdesign_path "ini\\"))

       (setvar "cmdecho" 0)
       (actdcl (strcat powdesign_dcl_path "transdwg.dcl") "trs")
       (setq #g_syslt (read (getfile_val (strcat powdesign_path "system.ini") "線性定義")))
       (read_list_transact)
       (action_tile "accept" "(get_key_tranact)(setq ~flag 1)")
       (action_tile "cancel" "(setq ~flag 0)(done_dialog)")
       (start_dialog)

       (if (= 1 ~flag)
           (progn
               (app_trans_tranact #g_list_id)
               (alert "\n                 作業完成..!\n\n新圖檔存放於子資料夾 DWG_NEW\n")
           )
       )
       (setvar "cmdecho" 1)
)
;=====================================================================================
(defun get_key_tranact()
    (if (/= "" (get_tile "ts_list"))
        (progn
            (setq #g_list_id (atoi (get_tile "ts_list")))
            (done_dialog)
        )
    )
)
;=====================================================================================
(defun app_trans_tranact(~list_id / ~keyin ~flagin ~row ~temp ~dwg_name ~file_name ~trans_list
                            ~save_path ~make_dir ~match_dir ~p ~n ~file_path ~dwg_list)
       (setq ~trans_list '())
       (setq ~dwg_list '())
       (startapp (strcat powdesign_path "selfile.exe"))
       (getpoint "\n請選取檔案後按 Enter 鍵!")
       ;(setq ~keyin (getstring "\n清除未使用之線型字形與圖層 [<Yes>/No]: "))
       ;(cond ((= "" ~keyin)(setq ~flagin 1))
       ;      ((= (strcase ~keyin) "Y")(setq ~flagin 1))
       ;      ((= (strcase ~keyin) "N")(setq ~flagin 0))
       ;      ((= (strcase ~keyin) "YES")(setq ~flagin 1))
       ;      ((= (strcase ~keyin) "NO")(setq ~flagin 0))
       ;      (T (quit))
       ;)
       ;------------------------------------------------------
       (setq ~row (* ~list_id 3))
       (repeat 3
             (setq ~temp (cdr (cdr (nth ~row #g_file_list))))
             (setq ~trans_list (cons ~temp ~trans_list))
             (setq ~row (1+ ~row))
       )
       (setq ~trans_list (reverse ~trans_list))
       ;------------------------------------------------------
       (setq ~file_path (open (strcat powdesign_path "trans\\filelist.txt") "r"))
       (setq ~dwg_name (read-line ~file_path))
       (while ~dwg_name
             (setq ~dwg_list (cons ~dwg_name ~dwg_list))
             (setq ~dwg_name (read-line ~file_path))
       )
       (close ~file_path)
       (setq ~dwg_list (reverse ~dwg_list))
       ;------------------------------------------------------
       (setq ~p 0)
       (setq ~n 0)
       (repeat (length ~dwg_list)
             (get_ltypedef)
             (setq ~file_name (trans_pathtxt (nth ~n ~dwg_list)))
             (command "insert" ~file_name "0,0" "1" "1" "")
             (command "zoom" "e")
             (command "explode" "l")
             (trans_lt_tranact (nth 0 ~trans_list))
             (trans_fn_tranact (nth 1 ~trans_list))
             (trans_la_tranact (nth 2 ~trans_list))
             (setq ~save_path (strcat (strcat (get_filepath ~file_name "/") "DWG_NEW/") (get_filename ~file_name "/")))
             (setq ~make_dir (strcat "md " (strcat (get_filepath (nth ~n ~dwg_list) "\\") "DWG_NEW")))
             (if (/= ~match_dir ~make_dir)(setq ~p 0))
             (if (= 0 ~p)
                 (progn
                     (command "shell" ~make_dir)
                     (command "delay" "1200")
                     (setq ~match_dir ~make_dir)
                     (setq ~p 1)
                 )
             )
	     (command "wblock" ~save_path "*")
	 
             ;(if (= 1 ~flagin)(command "wblock" ~save_path "*"))    ;存檔方式 1 -- WBLOCK
             ;(if (= 0 ~flagin)(progn
	     ;    (cond ((= T (wcmatch (ver) "*2000*"))
	     ;		 (command "saveas" "2000" ~save_path)
	     ;	        )
	     ;	        ((= T (wcmatch (ver) "*14*"))
	     ;		 (command "saveas" "R14" ~save_path)
	     ;	        )
	     ;	        (T
	     ;		 (command "saveas" "2000" ~save_path)
	     ;	        )
	     ;    )))                                                 ;存檔方式 2 -- SAVE  

	     (command "erase" "all" "")
             (command "purge" "a" "*" "n")
             (command "purge" "a" "*" "n")
             (command "purge" "a" "*" "n")
             (setq ~n (1+ ~n))
       )
       (get_ltypedef)
)
;=====================================================================================
(defun read_list_transact( / ~item ~items ~n ~KS)
    (setq #g_item_list '())
    (setq #g_file_list '())

    (setq #g_file_list (readfile_tolist (strcat powdesign_ini_path "transdwg.ini")))
    (setq ~n 0)
    (repeat (length #g_file_list)
            (setq ~item (nth 0 (nth ~n #g_file_list)))
            (setq ~items (cons ~item ~items))
            (setq ~n (1+ ~n))
    )
    (setq ~n 0)
    (repeat (length ~items)
            (setq ~KS (nth ~n ~items))
            (if (= nil (member ~KS #g_item_list))
                (setq #g_item_list (cons ~KS #g_item_list))
            )
            (setq ~n (1+ ~n))
    )
    (act_pop_list #g_item_list "ts_list")
)
;=====================================================================================
(defun trans_lt_tranact(~trans)
       (setq ~i 0)
       (repeat (length ~trans)
               (setq ~old_new (nth ~i ~trans))
               (setq ~old_lt (nth 0 ~old_new))         ;;"~old_lt"
               (setq ~new_lt (nth 1 ~old_new))         ;;"~new_lt"
               (setq ~dot_lt (list (cons 6 ~old_lt)))  ;;Ex:'((6 . "CENTER"))
               (setq ~j 0)
               (repeat (length #g_syslt)
                       (setq ~temp (nth ~j #g_syslt))
                       (setq ~flag (member ~new_lt ~temp))
                       (if (/= nil ~flag)(setq ~color (nth 1 ~flag))) ;;"~color"
                       (setq ~j (1+ ~j))
               )
               (setq ~sel_lt (ssget "X" ~dot_lt))
               (if (/= nil ~sel_lt)
                   (progn
                       (command "_chprop" ~sel_lt "" "lt" ~new_lt  "c" ~color "")
                   )
               )    
       (setq ~i (1+ ~i))
       )
       (layer_line)
)
(defun layer_line()
  	(setq ~i 0)
  	(setq laylist (symbol_list "LAYER"))
  	(repeat (length laylist)
	  	(setq lay_item  (nth ~i laylist))
	  	(setq lay_table (tblsearch "LAYER" lay_item))
	  	(setq lntype (strcase (cdr (assoc 6  lay_table))))
	  	(setq lcolor (cdr (assoc 62 lay_table)))
	  	(setq ~j 0)
	  	(repeat (length ~trans)
		  	(setq ~old_lt (nth 0 (nth ~j ~trans)))
		  	(setq ~new_lt (nth 1 (nth ~j ~trans)))
    	                (setq ~k 0)
               		(repeat (length #g_syslt)
                       		(setq ~temp (nth ~k #g_syslt))
                       		(setq ~flag (member ~new_lt ~temp))
                       		(if (/= nil ~flag)(setq ~color (atoi (nth 1 ~flag)))) ;;"~color"
                       		(setq ~k (1+ ~k))
               		)
		  	(if (= ~old_lt lntype)(progn
			    (setq ent1 (tblobjname "LAYER" lay_item))
			    (setq ent2 (entget ent1))
			    (setq ent2 (subst (cons 62 ~color) (assoc 62 ent2) ent2))
			    (setq ent2 (subst (cons 6 ~new_lt) (assoc 6  ent2) ent2))
			    (entmod ent2)
			    )
			);if
		  	(setq ~j (1+ ~j))
		);repeat
	  	(setq ~i (1+ ~i))
	);repeat
)

;=====================================================================================
(defun trans_fn_tranact(~trans)
  (setq ~style_list '())
  (setq ~style (cdr (assoc 2 (tblnext "STYLE" T))))
  (while (/= nil ~style)
         (setq ~style_list (cons ~style ~style_list))
         (setq ~style (cdr (assoc 2 (tblnext "STYLE"))))
  )
  (setq ~style_list (reverse ~style_list))

  (setq ~i 0)
  (repeat (length ~style_list)
    	  (setq ~str_sitem (nth ~i ~style_list))
    	  (setq ~lst_sitem (tblsearch "STYLE" ~str_sitem))
          (setq ~str_style1 (txtr_transact (strcase (cdr (assoc 3 ~lst_sitem)))))
    	  (setq ~str_style2 (txtr_transact (strcase (cdr (assoc 4 ~lst_sitem)))))
    	  (if (= "KAIU" ~str_style1)(setq ~str_style1 "標楷體"))
    	  (if (= "PMINGLIU" ~str_style1)(setq ~str_style1 "新細明體"))
    	  (if (= "MINGLIU"  ~str_style1)(setq ~str_style1 "細明體"))
    		(setq ~j 0)
    		(repeat (length ~trans)
			(setq ~old_fn (txtr_transact (nth 0 (nth ~j ~trans))))
		  	(setq ~new_fn (txtr_transact (nth 1 (nth ~j ~trans))))
		  	(if (= ~old_fn ~str_style1)(command "style" ~str_sitem (strcat ~new_fn ",") "" "" "" "" "" "N"))
			(if (= ~old_fn ~str_style2)(command "style" ~str_sitem (strcat "," ~new_fn) "" "" "" "" "" "N"))
		  	(setq ~j (1+ ~j))
		)
    	  (setq ~i (1+ ~i))
  )
)
;=====================================================================================
(defun trans_la_tranact(~trans)
  (setq ~layer_list '())
  (setq ~layer (cdr (assoc 2 (tblnext "LAYER" T))))
  (while (/= nil ~layer)
         (setq ~layer_list (cons ~layer ~layer_list))
         (setq ~layer (cdr (assoc 2 (tblnext "LAYER"))))
  )
  (setq ~layer_list (reverse ~layer_list))

  (setq bbs ~trans)
  (setq ~i 0)
  (repeat (length ~trans)
	  (setq ~old_la (nth 0 (nth ~i ~trans)))
	  (setq ~new_la (nth 1 (nth ~i ~trans)))
    	  (cond ((member ~new_la ~layer_list)
		 (if (member ~old_la ~layer_list)
		     (progn
		       	  (if (setq ~entobj (ssget "X" (list (cons 8 ~old_la))))
		       	      (progn
				  (command "change" ~entobj "" "p" "la" ~new_la "")
				  (command "purge" "la" ~old_la "n")
			      )
		          )
		     )
		))
		((= nil (member ~new_la ~layer_list))
		 (if (member ~old_la ~layer_list)
		     (progn
		          (command "rename" "la" ~old_la ~new_la)
		     )
		))
	  )
    	  (setq ~i (1+ ~i))
  ))
;=====================================================================================
(defun txtr_transact(str_test / str_trans ~flag ~n)
  	(setq ~n 1)
  	(repeat (strlen str_test)
	  	(if (= "." (substr str_test ~n 1))(progn
		    (setq str_trans (substr str_test 1 (1- ~n)))
		    (setq ~flag 1))
		)
	  	(setq ~n (1+ ~n))
	)
  	(if (/= 1 ~flag)(setq str_trans str_test))
  	str_trans
)

;====================================================================================
(defun symbol_list(sym_name / symlist name_item)
  	(setq name_item (cdr (assoc 2 (tblnext sym_name T))))
  	(while (/= nil name_item)
	       (setq symlist   (cons name_item symlist))
	       (setq name_item (cdr (assoc 2 (tblnext sym_name))))
	)
  	(setq symlist (reverse symlist))   symlist
)
(defun *error(msg)
  (princ "---")
)