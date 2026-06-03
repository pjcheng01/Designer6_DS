;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 批次轉換圖框			                     │
;;;│  主程式 : transht.lsp                                          │
;;;│  日  期 : 2003/09/17                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 : 	                                             │
;;;│  方  法 : btrsht                                               │
;;;│  相關檔案:                                                     │
;;;└────────────────────────────────┘
;;;====================================================================
(defun c:btrsht()
	(setvar "cmdecho" 0)
        (startapp (strcat powdesign_path "selfile.exe"))
        (getpoint "\n請選取檔案後按 Enter 鍵!")
  	(close (open (strcat powdesign_path "btrinfo.txt") "w"))	;;將批次轉換資訊檔清空
  	(exec_script_btrsht)
  	(setvar "cmdecho" 1)
  	(princ)
)
(defun exec_script_btrsht(/ lst_files fle_files str_ver int_i str_afile str_tfile str_tflag str_cmd)
  	(setq lst_files (readfile_tolist_btrsht (strcat powdesign_path "trans\\filelist.txt")))
  	(if lst_files (progn
		(setq fle_files (open (strcat powdesign_path "btrsht.scr") "w"))
		(setq str_ver (substr (getvar "acadver") 1 2))
		(setq int_i 0)
		;;(princ "proxynotice 0\n" fle_files)
		(repeat (length lst_files)
		  	(setq str_afile (nth int_i lst_files))
		  	;;(setq str_tfile (transfile_btrsht str_afile "_"))		;;(另存新檔)將這邊打開("_" 前置符號)
			;;(setq str_tflag (findfile str_tfile))				;;
		  	(cond ((= "14" str_ver)
			       (setq str_cmd (strcat "open " str_afile " transht save " str_afile "\n")))
			      ((= "15" str_ver)
			       (setq str_cmd (strcat "open " str_afile " transht save " str_afile " close\n")))
			)
		  	(princ str_cmd fle_files)
		  	(setq int_i (1+ int_i))
		)
		;;(princ "proxynotice 1\n" fle_files)
		(close fle_files)
		(if (and (/= 0 (getvar "dbmod"))(= "14" str_ver))(command "save" "" "Y"))

		(initget "Yes No")
		(setq yesno (getkword "\n原來檔案將被覆蓋<Yes>: "))
		(if (or (null yesno) (= "Yes" yesno)) 
		    (command "._script" (strcat powdesign_path "btrsht.scr"))
		    (princ)
		)
	))
)
(defun readfile_tolist_btrsht(str_filepath / fle_files str_afile lst_files)
	(setq fle_files (open str_filepath "r"))
        (setq str_afile (read-line fle_files))
        (while str_afile
        	(setq lst_files (cons str_afile lst_files))
                (setq str_afile (read-line fle_files))
        )
        (close fle_files)
        (reverse lst_files)
)
(defun transfile_btrsht(str_afile str_title / str_fname str_fpath int_i str_char str_temp str_temp1 str_temp2)
	(setq str_fname (get_filename str_afile "\\"))
  	(setq str_fpath (get_filepath str_afile "\\"))
  	(setq int_i 1)
  	(repeat (strlen str_fname)
	  	(setq str_char (substr str_fname int_i 1))
	  	(if (= "." str_char)(progn
		    (setq str_temp1 (substr str_fname 1 (- int_i 1)))
		    (setq str_temp2 (substr str_fname int_i))
		    (setq str_temp  (strcat str_fpath str_title str_temp1 str_temp2))
		))
	  	(setq int_i (1+ int_i))
	)
	(if (null str_temp)(setq str_temp str_afile))
  	str_temp
)
;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 舊圖框轉換新圖框		                     │
;;;│  主程式 : transht.lsp                                          │
;;;│  日  期 : 2003/09/17                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 : 	                                             │
;;;│  方  法 : transht                                              │
;;;│  相關檔案:                                                     │
;;;└────────────────────────────────┘
;;;====================================================================
;;;全域變數 glst_inifile  transht.ini
;;;	    gstr_shtype 圖框種類  gstr_shsize 圖框大小
;;;	    gfle_info 批次轉換資訊檔
;;;舊圖框轉新圖框(單一轉換可直接執行)
(defun c:transht(/ lst_curblock int_next int_idd str_pair str_mode osmode *error* gstr_shtype gstr_shsize)

  	(setq osmode (getvar "osmode"))
  	(setvar "cmdecho" 0)
  	(setvar "osmode" 0)
 	(defun *error*(msg)
	  	(if osmode (setvar "osmode" osmode))
  		(setvar "cmdecho" 1)
	  	(setvar "attreq" 1)
	)
	(setq glst_inifile (readfile_tolist (strcat powdesign_path "ini\\transht.ini")))
  	(setq lst_curblock (coll_block_transht))
  	(setq int_next 0)
  	(repeat (length glst_inifile)
	  	(setq str_pair (nth 0 (nth 1 (nth int_next glst_inifile))))
	  	(if (member (strcase str_pair) lst_curblock)(setq int_idd int_next))
	  	(setq int_next (1+ int_next))
	)
  	(if int_idd (setq str_mode (nth 0 (nth int_idd glst_inifile))))

  	(setq gfle_info (open (strcat powdesign_path "btrinfo.txt") "a"))	;;將自己判斷的錯誤訊息寫入批次轉換資訊檔
 	(princ (strcat "\n" (getvar "DWGNAME") " ") gfle_info)			;;目前檔名

  	(cond ((= "1" str_mode)(command "zoom" "e")(attdef_transht int_idd)(command "zoom" "p"))
	      ((= "2" str_mode)(command "zoom" "e")(notatt_transht int_idd)(command "zoom" "p"))
	      (t (princ "找不到設定的圖塊 ")
	         (princ "找不到設定的圖塊 " gfle_info))
	)
	(close gfle_info)     
  	(setvar "osmode" osmode)
  	(setvar "cmdecho" 1)
  	(princ)
)
(defun attdef_transht(int_idd / lst_setlist set_filter ent_next str_etype lst_entname)
  	(setq lst_setlist (nth int_idd glst_inifile))
  	(setq set_filter (ssget "x" (list (cons 0 "INSERT")(cons 2 (car (nth 1 lst_setlist))))))
  	(if set_filter (progn
	  	(setq ent_next (entnext (ssname set_filter 0)))
		(while ent_next
		  	(setq str_etype (cdr (assoc 0 (entget ent_next))))
		  	(cond ((= "ATTRIB" str_etype)
			                 (setq lst_entname (cons ent_next lst_entname))
			       	         (setq ent_next (entnext ent_next)))
			      ((= "SEQEND" str_etype)(setq ent_next nil))
			      (t (setq ent_next (entnext ent_next))))
		)
	)(progn (princ "圖塊不在圖面上 " gfle_info)))
  
	(if lst_entname
	  	(change_att_transht lst_setlist lst_entname)		;;變更ATTRIB屬性標籤名稱
	  	(if set_filter (princ "圖塊中不含屬性標籤 " gfle_info))
	)
)
(defun notatt_transht(int_idd / lst_setlist set_filter set_attdef lst_shscal pnt_insert pnt_base
		      	        flt_coorx flt_coory flt_coorz int_i pnt_bleft pnt_uright str_attdef
		      		pnt_xleft pnt_xright set_gettext ent_enttext str_entname lst_setatt
		      		str_att_text lst_att_text lst_att_sset int_ssi)
  	(setq set_attdef (ssadd))
  	(setq lst_setlist (nth int_idd glst_inifile))					;;transht.ini 的第 N 項
  	(setq set_filter (ssget "x" (list (cons 0 "INSERT")(cons 2 (car (nth 1 lst_setlist))))))
  	(setq lst_shscal (shscal_data_id_transht (nth 1 (nth 1 lst_setlist))))  	;;求得Block在shscal.ini的串列
  	(if (and set_filter lst_shscal) (progn	
		(setq pnt_insert (cdr (assoc 10 (entget (ssname set_filter 0)))))
		(setq pnt_base   (nth 2 lst_setlist))
		(setq flt_coorx (- (nth 0 pnt_insert)(nth 0 pnt_base)))
		(setq flt_coory (- (nth 1 pnt_insert)(nth 1 pnt_base)))
		(setq flt_coorz (- (nth 2 pnt_insert)(nth 2 pnt_base)))
		;;------------計算點位置 & TEXT換為ATTDEF-------------------
		(setq int_i 3)
		(repeat (- (length lst_setlist) 3)
		  	(setq pnt_bleft  (nth 0 (nth int_i lst_setlist)))
		  	(setq pnt_uright (nth 1 (nth int_i lst_setlist)))
		  	(setq str_attdef (nth 2 (nth int_i lst_setlist)));;屬性標籤名稱(transht.ini)
		  	(setq pnt_xleft  (list (+ (nth 0 pnt_bleft) flt_coorx)
			      	               (+ (nth 1 pnt_bleft) flt_coory)
			                       (+ (nth 2 pnt_bleft) flt_coorz)))
		  	(setq pnt_xright (list (+ (nth 0 pnt_uright) flt_coorx)
					       (+ (nth 1 pnt_uright) flt_coory)
					       (+ (nth 2 pnt_uright) flt_coorz)))
			(if (setq set_gettext (ssget "f" (list pnt_xleft pnt_xright)))(progn
			    (setq int_ssi 0)
			    (repeat (sslength set_gettext)
			    	    (setq ent_enttext (ssname set_gettext int_ssi))
			    	    (setq str_entname (cdr (assoc 0 (entget ent_enttext))))
			            (if (or (= "TEXT" str_entname)(= "MTEXT" str_entname))(progn
				        (setq lst_setatt (assoc str_attdef (nth 4 lst_shscal)))
				        (if lst_setatt (progn
				    	    (setq str_att_text (cdr (assoc 1 (entget ent_enttext))))
					    (setq lst_att_text (list str_attdef str_att_text))
					    (setq lst_att_sset (cons lst_att_text lst_att_sset))	;;EX (("DRAWER" "SAM")("COMPANY" "???"))
					    (entdel ent_enttext)					;;清除文字
				        ))
			            ))
			      	    (setq int_ssi (1+ int_ssi))
			    );repeat
			))	
		  	(setq int_i (1+ int_i))
		)
		;;-----------------製造BLOCK並且插入-------------------------
		(setq lst_shscal (shscal_data_id_transht (nth 1 (nth 1 lst_setlist))))	;;取得圖框種類與圖框大小字串
	       
  		(if (and gstr_shtype gstr_shsize lst_att_sset)(progn
		    (change_sht_transht lst_att_sset (nth 2 lst_shscal))
	            (ad1xdata (entlast) "SHEETFLAG" (list "SHEETFLAG" (cons 1000 gstr_shtype)(cons 1000 gstr_shsize)))
	            (write_pdmtxt_transht (entlast))	;;寫出文字檔到PDM Autocad目錄
	            (princ "完成! " gfle_info)
	        ))
	)(progn (princ "圖塊不在圖面上 " gfle_info)))	
)
(defun change_att_transht(lst_setlist lst_entname / int_i str_oldatt str_newatt lst_oldatt lst_newatt
			  			    lst_entity lst_rti int_idx lst_attval lst_grpatt)
  	(setq int_i 2)
  	(repeat (- (length lst_setlist) 2)
	  	(setq str_oldatt (car  (nth int_i lst_setlist)))
	  	(setq str_newatt (cadr (nth int_i lst_setlist)))
	  	(setq lst_oldatt (cons str_oldatt lst_oldatt))		;;Ex ("ATT1" "ATT2" "ATT3")
	  	(setq lst_newatt (cons str_newatt lst_newatt))		;;Ex ("DRAWER" "COMPANY" "DATE1")
	  	(setq int_i (1+ int_i))
	)
  	(setq int_i 0)
  	(repeat (length lst_entname)
	  	(setq lst_entity (entget (nth int_i lst_entname)))
	  	(setq str_oldatt (cdr (assoc 2 lst_entity)))
	  	(if (setq lst_rti (member str_oldatt lst_oldatt))(progn
		    (setq str_val (cdr (assoc 1 lst_entity)))
		    (setq int_idx (- (length lst_oldatt)(length lst_rti)))
		    (setq str_newatt (nth int_idx lst_newatt))
		    (setq lst_attval (list str_newatt str_val))
		    (setq lst_grpatt (cons lst_attval lst_grpatt))		;;Ex (("DRAWER" "SAM)("COMPANY" "???"))
		))
	  	(setq int_i (1+ int_i))
	)
  	(setq lst_shscal (shscal_data_id_transht (nth 1 (nth 1 lst_setlist))))	;;取得圖框種類與圖框大小字串
	       
  	(if (and gstr_shtype gstr_shsize lst_grpatt)(progn
	    (change_sht_transht lst_grpatt (nth 2 lst_shscal))
	    (ad1xdata (entlast) "SHEETFLAG" (list "SHEETFLAG" (cons 1000 gstr_shtype)(cons 1000 gstr_shsize)))
	    (write_pdmtxt_transht (entlast))	;;寫出文字檔到PDM Autocad目錄
	    (princ "完成! " gfle_info)
	))

)
(defun change_sht_transht(lst_grpatt str_sfile / clay ccol cltype vctr)
   	(setq clay  (getvar "clayer"))
        (setq ccol  (getvar "cecolor"))
        (setq cltype(getvar "celtype"))
  	(setq vctr  (getvar "viewctr"))
        (if (null chg_sheetatt) (load "shscal"))
        (if (findfile (strcat str_sfile "tzt.dwg"))(progn
  	    (entdel (entlast))
  	    (setvar "osmode" 0)
  	    (setvar "attreq" 0)
   	    (command "layer" "m" sys_sheet_layer "c" sys_sheet_layercol "" "")
            (command "insert" str_sfile vctr "1" "" "0")
            (command "insert" (strcat str_sfile "tzt") vctr "1" "" "0")
   	    (command "zoom" "e")
  	    (setvar "attreq" 1)
   	    (command "layer" "s" clay "")
   	    (command "color" ccol)
   	    (command "linetype" "s" cltype "")
   	    (chg_sheetatt (entlast) lst_grpatt)
  	    (command "zoom" "e")
	)(progn (princ "找不到新圖框的檔案 " gfle_info)))
   	(princ)
)
(defun coll_block_transht(/ total_block_list bldata)
  	(if (tblnext "BLOCK" t)(progn
	    (setq total_block_list (list (strcase (cdadr (tblnext "BLOCK" t)))))
	    (setq bldata (tblnext "BLOCK"))
	    (while bldata
	    	    (setq total_block_list (cons (strcase (cdadr bldata)) total_block_list))
		    (setq bldata (tblnext "BLOCK"))
 	    )
	))
 	total_block_list
)
(defun shscal_data_id_transht(str_block / lst_shtdata lst_temp1 lst_temp2 int_i int_j int_id int_jd str_blk lst_shscal)
  	(if (null read_autoshscal_data)(load "shscal"))
  	(setq lst_shtdata (read_autoshscal_data))
  	(setq int_i 0 int_j 0)
  	(foreach lst_temp1 lst_shtdata (progn
		(foreach lst_temp2 (cdr lst_temp1)(progn
			(setq str_blk (get_filename (nth 2 lst_temp2) "\\"))
			(if (= str_blk (strcase str_block))(progn
			    (setq gstr_shtype (nth 0 lst_temp1))
			    (setq gstr_shsize (nth 0 lst_temp2))
			    (setq int_jd int_j)
			    (setq int_id int_i)
			))
			(setq int_j (1+ int_j))
		))
		(setq int_j 0)
		(setq int_i (1+ int_i))
	))
  	(if (and int_id int_jd)
	    (setq lst_shscal (nth int_jd (cdr (nth int_id lst_shtdata))))
	    (princ "找不到套用的圖框 " gfle_info)
	)
  	lst_shscal
)
(defun write_pdmtxt_transht(entsht / sheetddtt sheetdata sheettype attent attall_list ff)
  	(if (null POWERPDM_CAD_PATH)(load "config")) 
        (if (setq sheetddtt (getxdata entsht "SHEETFLAG"))(progn
            (setq sheettype (cdr (nth 1 (nth 1 (assoc -3 sheetddtt)))))
            (setq attent entsht)
        ))
        (if (null sheet_type)(read_autoshscal_data))
  	(setq &&sheet_id (list_id sheettype sheet_type))
	(setq sheetdata (list attent &&sheet_id))
  	(setq attall_list (getent_allatt attent))
  	(if (null POWERPDM_CAD_PATH)
	    (princ "POWERPDM_CAD_PATH 路徑不存在")
	    (progn
  	         (setq ff (open (strcat POWERPDM_CAD_PATH "DWGIN\\" (curdwgname) ".txt") "w"))	;;POWERPDM 2001
	         (write-line (rtos (- (nth 1 sheetdata) 1) 2 0) ff)
  		 (foreach nn attall_list
		       (write-line (strcat (nth 0 nn) " " (nth 1 nn)) ff)
  		 )
  		 (if ff (close ff)(princ "POWERPDM_CAD_PATH 路徑不存在"))
	    )
	)
)