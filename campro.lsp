;;
;;
;;
;;
;;
;;
;;
;;;
;;;凱柏連結晶英 ERP 系統 pdmbom3
(defun campro_sybom( / qq bomball_grp partdata count balllist num ff fname rf tittxt title_list
                     qty ent data8 qf data bomdata outtxt tag txt num outf)
  (load "manapart")
  (princ "\n--開始--")
  (setq typ 1)
  (if (findfile (strcat POWdesign_path "atitle.txt")) (progn
      (setq needlayer (coll_all_layer))  ;; 選擇所有圖層,並過濾不建立資訊點的圖層
      (foreach nn needlayer (progn
          (setq ggg (ssget "x" (list (cons 8 nn))))
          (if (null ggg) (setq needlayer (removelist nn needlayer)))
      ));foreach
      (setq bomball_grp (ssget "x" (list (cons 0 "INSERT") (cons 2 "PARTREF"))))  ;;取所有資訊點
      (setq partdata (read (getfile_val (strcat POWdesign_path "SYSTEM.ini") "零件定義資料")))
      (setq count 0 balllist '() num 1)

      (cond ((or (= typ 2)(= typ 0)(= typ 3))(setq ff (open (strcat  POWDESIGN_path "bom.out") "w")))
            ((= typ 1) (setq ff (open (strcat  powdesign_path "pdmbom3.txt") "w")))
      )
      (setq rf (open (strcat  POWDESIGN_path "atitle.txt") "r"))
      (setq tittxt (read-line rf))                               ;;tittxt 層名;品名;材質;圖號;製圖;說明;數量;表面處理;機種;規格;英文品名
      (close rf)                                                 ;; 寫出本組合圖名
      ;;;======================================================================================================
      ;;;取出[檔號]與 [組立圖料號]
      (setq str_filename(curdwgname)) ;取出[檔號]
      (setq str_attdef "DWGNO")   ;;[組立圖料號]
      (setq str_assmatno "") ;;[組立圖料號]
      (setq set_blk (ssget "x" '((0 . "INSERT")(-3 ("SHEETFLAG")))))
      (if set_blk (progn
	  (setq ent_obj (ssname set_blk 0))
	  (setq lst_att (search_attrib ent_obj))
	  (setq str_assmatno (nth 1 (assoc "DWGNO" lst_att)))
	  (setq str_assmname (nth 1 (assoc "DWGNAME-C" lst_att)))
	  ;;(setq int_i 0)
	  ;;(repeat 10
	  ;;      (setq ent_obj (entnext ent_obj))
	  ;;	(if (= "ATTRIB" (cdr (assoc 0 (entget ent_obj))))(progn
	  ;;	    (setq str_attrib (cdr (assoc 2 (entget ent_obj))))
	  ;; 	    (if (= str_attdef str_attrib)(setq str_assmatno (cdr (assoc 1 (entget ent_obj)))))
	  ;;	))
	  ;;)
      ))
      ;;;======================================================================================================
      ;;;寫出 title至pdmbom3.txt
      ;;(write-line (strcat "檔號;組立圖料號;" tittxt) ff)
      (write-line (strcat "檔號;組立圖料號;組立圖名稱;" tittxt) ff)
      (princ "\n--產生欄位--")
      (setq title_list (TXT_TRAN_LIST tittxt))                   ;;title_list ("層名" "品名" "材質" ...)
      (if (or (= typ 2)(= typ 0)(= typ 3))(write-line (curdwgname) ff))
      (if (/= nil bomball_grp)
        (progn
          (setq qty (sslength bomball_grp))
          (princ (strcat "\n--" (itoa qty) "筆資料--"))
          (repeat qty
	    (setq ent (ssname bomball_grp count))
            (setq data8 (cdr (assoc 8 (entget ent))))
            (if (member data8 needlayer)
                (setq needlayer (removelist data8 needlayer))     ;;needlayer 沒有資訊點的零件圖層
            );if
            ;;寫出有資訊點的零件圖層
            (setq qf (open (strcat POWDESIGN_path "atitle.txt") "r"))
            (setq data (read-line qf))(close qf)
            (setq bomdata (reverse (get_bomdata ent)))
            ;;title_list ("層名" "品名" "材質" "#圖號" "製圖" "數量" "表面處理" "英文品名" "規格" "機種" "說明")
            ;;bomdata (("TAG3" "內六角承窩螺絲") ("TAG8" "") ("TAG13" "") ("TAG1" "") ("TAG2" "") ("TAG6" "") ("TAG7" "") ("TAG11" "") ("TAG12" "") ("TAG4" "") ("TAG5" "") ("TAG10" "8mm*20mm*P1.25") ("TAG9" "Screw.SKT.HD CAP") ("TAG14" "") ("TAG15" ""))
            ;;partdata (("組合件號" "" "TAG1") ("次組合名稱" "" "TAG2") ("品名" "PARTNAME" "TAG3") ("材質" "MATERIAL" "TAG4") ("#圖號" "DWGNO" "TAG5") ("製圖" "DRAWER" "TAG6") ("數量" "QTY" "TAG7") ("表面處理" "SURFACE" "TAG8") ("英文品名" "" "TAG9") ("規格" "" "TAG10") ("機種" "ITEM" "TAG11") ("說明" "" "TAG12"))
            (if (or (= typ 0)(= typ 2)(= typ 3)) (progn
                (if (assoc count subdata_list)                                     ;rex
                    (setq subid (nth 1 (assoc count subdata_list)))                ;rex
                    (setq subid "")                                                ;rex
                )                                                                  ;rex
                (if (/= "" subid)                                                  ;rex
                    (setq outtxt (strcat "1;" (rtos num 2) ";" subid ";" data8))   ;rex
                    (setq outtxt (strcat "1;" (rtos num 2) ";0;" data8))
                )                                                                  ;rex
            )(progn
                (setq outtxt data8)
            ))
            (foreach nn (cdr title_list) (progn
                (setq tag (nth 2 (assoc nn partdata)))
                (setq txt (nth 1 (assoc tag bomdata)))
                (if (= "" txt)(progn
                    (if(or(= typ 2)(= typ 3) (= typ 0))(setq txt "nil") (setq txt ""))
                ))
                (setq outtxt (strcat outtxt ";" txt))
            ));foreach

            ;;;加入[檔號]與 [組立圖料號]與 [組立圖名稱]
            (setq outtxt(strcat str_filename ";" str_assmatno ";" str_assmname ";" outtxt))
            ;;;======================================================================================================
            (write-line (strcat "/*" outtxt "*/") ff)  ;;20140813
            (setq count (1+ count))
            (setq num (1+ num))
            (princ ".")
          );repeat
	  (princ "\n--資料產生完成--")
        );progn
      );if
      
      ;;needlayer沒有資訊點的零件圖層資料寫出               ;; outtxt 沒有資訊點的資料 0;5;0;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil
      (if (/= nil needlayer) (progn
          (foreach nn needlayer (progn
              (if (or (= typ 0)(= typ 2)(= typ 3))                          ;; 0;5;0;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil
                  (progn                                                    ;; │││ │
                       (setq outtxt (strcat "0;" (rtos num 2 ) ";0;" nn))   ;; │││ └─────  第 4 筆以後: 與 title_list 欄位對應的資料
                       (repeat (- (length title_list) 1)                    ;; ││└─────── 第 3 筆: 父系編號
                       (setq outtxt (strcat outtxt ";nil")))                ;; │└──────── 第 2 筆: 流水號
                  );progn                                                   ;; └───────── 第 1 筆: 0 ->沒資訊點(tree狀不顯示圖示)
                  (progn                                                    ;;                               1 ->有資訊點(tree狀顯示圖示)
                       (setq outtxt nn)
                       (repeat (length title_list) (setq outtxt (strcat outtxt ";")))
                  );progn
              );if
              (setq num (1+ num))
              ;;;加入[檔號]與 [組立圖料號]與 [組立圖名稱]
              (setq outtxt(strcat str_filename ";" str_assmatno ";" str_assmname ";" outtxt))
              ;;(write-line outtxt ff) ;;SAM
              (princ ".")
          ));foreach
      ));if
      (close ff)
      (princ "\n--資料檢查--")
      (if (and (= 1 typ) (findfile (strcat  powdesign_path "pdmbom3.txt")))(progn
	  (princ (strcat "\n--資料匯出完成--" powdesign_path "pdmbom3.txt"))
	  (if (not (findfile (strcat powdesign_path "pdmbom3.txt")))(princ "\n--找不到pdmbom3.txt--"))
	  
          (startapp (strcat  POWDESIGN_path "Bomtopdm.bat"))
	  (princ (strcat "\n--執行檔匯入--" powdesign_path "Bomtopdm.exe"))
	  (if (not (findfile (strcat powdesign_path "Bomtopdm.exe")))(princ "\n--找不到Bomtopdm.exe--"))
	  
          (sheet_to_pdm)
	  (princ "\n--圖框資料寫入--")
          ;;(if (null c:cad_to_pdm)(load "pdm-cad"))
          ;;(c:cad_to_pdm)
      ))
  );progn
  (progn
      (c:sortcol)
      (c:outbom_out)
  ));if
  (princ "\n--結束--")
  (princ)
)

;;
;;自動更新開關
(defun change_onoff()
    (setvar "cmdecho" 0)
    (setq str_onoff (getini (strcat POWDESIGN_path "campro.ini") "SHEET" "update"))
    (if (= str_onoff "0")
	(progn
	    (setini (strcat POWDESIGN_path "campro.ini") "SHEET" "update" "1")
	    (alert "圖框自動更新已開啟!")
	)
	(progn
	    (setini (strcat POWDESIGN_path "campro.ini") "SHEET" "update" "0")
	    (alert "圖框自動更新已關閉!")
	)
    )
    (princ)
)
(defun campro_insert_sheet(/ att_flag vctr cl ccol cltype attdia_type sheet_typedata &&sheet_id)

    (setvar "cmdecho" 0)
    (setq &oldos (getvar "osmode"))
    (setq oerr *error* *error* te_err_pub)
    (load "shscal")
    (command "select" "ALL" "")
    (comp_cur_limits)

    (read_autoshscal_data)
    ;;(setq sheet_typedata "凱柏零件圖框") ;;**
    (cond ((= vb_SHTTYPE "0")(setq sheet_typedata "凱柏零件圖框"))
	  ((= vb_SHTTYPE "1")(setq sheet_typedata "凱柏圖框"))
	  (T (setq sheet_typedata "凱柏零件圖框"))
    )
    (if (null (list_id sheet_typedata sheet_type))
        (progn (alert "圖框屬性無法對應 ! ")(setq sheet_typedata "0"))
        (setq sheet_typedata (itoa (- (list_id sheet_typedata sheet_type) 1)))
    )
    (reset_sheettype)
    (setq get_cur_scal (getvar "dimscale"))

    ;;(setq sdata (assoc "A4" (cdr stype_data))) ;;**
    (cond ((and (= vb_SHTSIZE "A4")(= vb_SHTTYPE "0"))(setq sdata (assoc "A4" (cdr stype_data))))
	  ((and (= vb_SHTSIZE "A3")(= vb_SHTTYPE "0"))(setq sdata (assoc "A3" (cdr stype_data))))
	  ((and (= vb_SHTSIZE "A2")(= vb_SHTTYPE "0"))(setq sdata (assoc "A2" (cdr stype_data))))
	  ((and (= vb_SHTSIZE "A1")(= vb_SHTTYPE "0"))(setq sdata (assoc "A1" (cdr stype_data))))
	  ((and (= vb_SHTSIZE "A3")(= vb_SHTTYPE "1"))(setq sdata (assoc "ASMA3" (cdr stype_data))))
	  ((and (= vb_SHTSIZE "A2")(= vb_SHTTYPE "1"))(setq sdata (assoc "ASMA2" (cdr stype_data))))
	  ((and (= vb_SHTSIZE "A1")(= vb_SHTTYPE "1"))(setq sdata (assoc "ASMA1" (cdr stype_data))))
	  (T (setq sdata (assoc "A4" (cdr stype_data))))
    )
  
    (setq size_flag (nth 0 sdata))
    (setq attqty (atoi (nth 5 sdata)))
    (setq sfilename (nth 2 sdata))
    (setq sheetsize (nth 1 sdata))
    (setq ssize (nth 3 sdata))
    (setq xval (nth 0 ssize))
    (setq yval (nth 1 ssize))
    (if (/= sx nil)(progn
        (setq aascal (/ sx xval))
        (cond ((> aascal 0.9)
               (setq out_mm "1")
               (setq ddx (+ 1 (fix aascal)))
               (setq out_unit (rtos ddx 2 0))
              )
              ((< aascal 0.5)
               (setq out_unit "1")
               (setq ddx (- (fix (/ 1 aascal)) 1))
               (setq out_mm (rtos ddx 2 0))
              )
              (T (setq out_mm "1")
                 (setq out_unit "1")
              );T
       );cond
       (cond ((< 1 (/ (atof out_mm) (atof out_unit))) (setq ?scl (/ (atof out_unit) (atof out_mm))))
             ((> 1 (/ (atof out_mm) (atof out_unit))) (setq ?scl (atof out_unit)))
	     (T (setq ?scl 1))
       )
    ))
    (if (= ?scl nil)(setq ?scl 1))
    
    (setvar "ltscale" ?scl)
    (setvar "dimscale" (* base_dimscale ?scl))
    (setvar "textsize" (* ?scl 3))

    (setq cl (getvar "clayer"))
    (setq ccol (getvar "cecolor"))
    (setq cltype (getvar "celtype"))
    (setq attdia_type (getvar "attdia"))
    (setvar "attdia" 0)
    (command "layer" "m" sys_sheet_layer "c" sys_sheet_layercol "" "")
    (setq vctr (getvar "viewctr"))
    (setvar "osmode" 0)
    (setvar "attreq" 0)
    (command "insert" sfilename vctr ?scl "" "0")
    (command "insert" (strcat sfilename "tzt") vctr ?scl "" "0")
    (setvar "attreq" 1)
    (ad1xdata (entlast) "SHEETFLAG" (list "SHEETFLAG" (cons 1000 stype_flag)(cons 1000 size_flag)))
    (command "zoom" "E")
    (setvar "attdia" attdia_type)
    (command "layer" "s" cl "")
    (command "color" ccol)
    (command "linetype" "s" cltype "")
    (princ "\n請調整圖框位置...")
    (command "move" (ssget "x" (list (cons 0 "INSERT")(cons 8 sys_sheet_layer))) "" vctr pause)
    (command "zoom" "e")

    (if (/= vb_PDWG nil)(Update_Sheet_AttData "PDWG" vb_PDWG))
    (if (/= vb_PARTNO nil)(Update_Sheet_AttData "PARTNO" vb_PARTNO))
    (if (/= vb_DWGNO nil)(Update_Sheet_AttData "DWGNO" vb_DWGNO))
    ;(if (/= vb_TYPE nil)(Update_Sheet_AttData "TYPE" vb_TYPE))
    (if (/= vb_DWGNAME-C nil)(Update_Sheet_AttData "DWGNAME-C" vb_DWGNAME-C))
    (if (/= vb_DWGNAME-E nil)(Update_Sheet_AttData "DWGNAME-E" vb_DWGNAME-E))
    (if (/= vb_DRAWER nil)(Update_Sheet_AttData "DRAWER" vb_DRAWER))
    (if (/= vb_DATE1 nil)(Update_Sheet_AttData "DATE1" vb_DATE1))
    (if (/= vb_CHEACK nil)(Update_Sheet_AttData "CHEACK" vb_CHEACK))
    (if (/= vb_DATE2 nil)(Update_Sheet_AttData "DATE2" vb_DATE2))
    (if (/= vb_PROVEN nil)(Update_Sheet_AttData "PROVEN" vb_PROVEN))
    (if (/= vb_DATE3 nil)(Update_Sheet_AttData "DATE3" vb_DATE3))
    (if (/= vb_SURFACE nil)(Update_Sheet_AttData "SURFACE" vb_SURFACE))
    (if (/= vb_MATERIAL nil)(Update_Sheet_AttData "MATERIAL" vb_MATERIAL))
    (if (/= vb_SCALE nil)(Update_Sheet_AttData "SCALE" vb_SCALE))
    ;(if (/= vb_ASMDRAWNO nil)(Update_Sheet_AttData "ASMDRAWNO" vb_ASMDRAWNO))
    (if (/= vb_HOT nil)(Update_Sheet_AttData "HOT" vb_HOT))
    (if (/= vb_HEAD nil)(Update_Sheet_AttData "HEAD" vb_HEAD))
    (if (/= vb_SURHEA nil)(Update_Sheet_AttData "SURHEA" vb_SURHEA))
    (if (/= vb_INHEA nil)(Update_Sheet_AttData "INHEA" vb_INHEA))
    (if (/= vb_FILLET nil)(Update_Sheet_AttData "FILLET" vb_FILLET))
    (if (/= vb_CHAMFER nil)(Update_Sheet_AttData "CHAMFER" vb_CHAMFER))
    (if (/= vb_ARC nil)(Update_Sheet_AttData "ARC" vb_ARC))
    (setq vb_PDWG nil vb_PARTNO nil vb_DWGNO nil vb_TYPE nil vb_DWGNAME-C nil vb_DWGNAME-E nil vb_DRAWER nil
	  vb_DATE1 nil vb_CHEACK nil vb_DATE2 nil vb_PROVEN nil vb_DATE3 nil vb_SURFACE nil vb_MATERIAL nil vb_SCALE nil
	  vb_ASMDRAWNO nil vb_HOT nil vb_HEAD nil vb_SURHEA nil vb_INHEA nil vb_FILLET nil vb_CHAMFER nil vb_ARC nil)

    (change_bomball)
    (reset_block_scale)
    ;;(rest_dimdtyle_dimscale)
    (resetting_text)
      
    (setvar "osmode" &oldos)
    (princ)
)
(defun campro_shscal(/ DrawNo)
    (setq DrawNo (string_remove (getvar "DWGNAME") ".DWG"))
    (startapp "campro.exe" (strcat DrawNo ";2"))
    (princ)
)
;;更新圖框資料
(defun update_sheet(/ DrawNo)
    (setq DrawNo (string_remove (getvar "DWGNAME") ".DWG"))
    (startapp "campro.exe" (strcat DrawNo ";1"))
    (princ)
)
;;圖框資料寫入PDM
(defun sheet_to_pdm(/ ssg_sht lst_att DrawNo fil_wrt txt_file)
    (setq ssg_sht (ssget "x" '((-3 ("SHEETFLAG")))))
    (if (/= ssg_sht nil)(progn
    	(setq lst_att (search_attrib (ssname ssg_sht 0)))
	(setq DrawNo (string_remove (getvar "DWGNAME") ".DWG"))

	(close (open (strcat powdesign_path "CamproPdm.txt") "w"))
	(setq fil_wrt (open (strcat powdesign_path "CamproPdm.txt") "w"))
	(write-line DrawNo fil_wrt)
	(foreach lst_nn lst_att
    	    (write-line (strcat ";" (nth 0 lst_nn) "=" (nth 1 lst_nn) ";") fil_wrt)
  	)
	(close fil_wrt)
  	(setq txt_file (strcat powdesign_path "CamproPdm.txt"))
  	(if (findfile txt_file)(progn
	    (startapp (strcat powdesign_path "CamproPdm.bat")) ;;campro.roger modify
	    ;;(startapp (strcat "\"" powdesign_path "CamproPdm.exe\" " txt_file)) ;;original by simmon
	))
    )(progn
	(alert "無法取得圖框資料!")
    ))
    (princ)
)


;;給 campro.exe 呼叫用
(defun Update_Sheet_AttData(AttName AttData / ssg_sht)
    	(setvar "cmdecho" 0)
    	(setq ssg_sht (ssget "x" '((-3 ("SHEETFLAG")))))
    	(if (/= ssg_sht nil)(progn
	    (change_attrib (ssname ssg_sht 0) (list AttName AttData))
	))
    	(setvar "cmdecho" 1)
    	(princ)
)
;;
(defun campro_getbom_data(ntlayer / fil_wrt line1 strlay lst_dat txt_file)
	(setq fil_wrt (open (strcat powdesign_path "database.txt") "r"))
   	(setq line1 (read-line fil_wrt))          ;;line1 -> 料號;TAG3;TAG10;TAG4;TAG8;TAG5;TAG9
	(close fil_wrt)
    	;;(setq lst_tag (get_taglist data)) 	  ;; ("TAG3" "TAG10" "TAG4" "TAG5" "TAG9")
        ;;(if (null get_defpart) (load "dfsystem"))
        ;;(setq lst_deftag (nth 1 (get_defpart)))	  ;;(("TAG1" "組合件號") ("TAG2" "次組合名稱") ("TAG3" "品名"))

    
	(setq fil_wrt (open (strcat powdesign_path "campro.txt") "w"))
    	(write-line line1 fil_wrt)
    	(foreach strlay ntlayer (write-line strlay fil_wrt))
    	(close fil_wrt)
  	(setq txt_file (strcat powdesign_path "campro.txt"))
  	(if (findfile txt_file)(progn
	    (close (open (strcat powdesign_path "CamproBom.txt") "w")) //20140901 move to here
	    ;;(startapp (strcat "\"" powdesign_path "CamproBom.exe\" " txt_file)) ;;original from simmon
	    (startapp (strcat powdesign_path "CamproBom.bat")) ;;campro.roger modify
	    ;;(close (open (strcat powdesign_path "CamproBom.txt") "w")) //origin here
	    (command "delay" 5000) //20140901 add this line
	    (setq lst_dat (get_sqlrun_data (strcat powdesign_path "CamproBom.txt")))
	))
	lst_dat
)

;;;文字檔為字串模式
;;;==================================================================
(defun txt_readfile_tolist(str_fname / fle_fr str_tmp lst_tmp)
	(if (setq str_fname (findfile str_fname))(progn
    	    (setq fle_fr  (open str_fname "r"))
	    (setq str_tmp (read-line fle_fr))
	    (while str_tmp
	           (setq lst_tmp (cons str_tmp lst_tmp))
	           (setq str_tmp (read-line fle_fr))
	    )
	    (close fle_fr)
	    (setq lst_tmp (reverse lst_tmp))
        ))
  	lst_tmp
)
;;; "AA,BB,CC" --> (symbolstr_list string ",") --> ("AA" "BB" "CC")
;;;==================================================================
(defun symbolstr_list(string symbol / i str_unit lst_strs)
	(setq i 1)
	(while  (/= 0 (strlen string))
  		(while  (= symbol (substr string i 1))
		  	(setq str_unit (substr string 1 (- i 1)))
		  	(setq lst_strs (cons str_unit lst_strs))
		  	(setq string   (substr string (+ i 1)))
		  	(setq i 1)
		)
	  	(setq i (1+ i))
	  	(if (> i (strlen string))(progn
			(setq lst_strs (cons (substr string 1) lst_strs))
			(setq string   (substr string (+ i 1)))
		))
	)
  	(setq lst_strs  (reverse lst_strs))
  	lst_strs
)
;;; "ABC.DWG" ".DWG" --> "ABC"
;;;==================================================================
(defun string_remove(str1 str2 / strlen1 strlen2 i intkey strf strb)
  	(setq strlen1 (strlen str1))
  	(setq strlen2 (strlen str2))
  	(setq i 1)
	(repeat (strlen str1)
		(if (= (strcase str2) (strcase (substr str1 i strlen2)))(setq intkey i))
	  	(setq i (1+ i))
	)
	(if intkey (progn
	  	(setq strf (substr str1 1 (- intkey 1)))
		(setq strb (substr str1 (+ intkey strlen2)))
		(setq str1 (strcat strf strb))
	))
	str1
)
;;; 取INI檔設定
;;;==================================================================
(defun getini(str_file str_area str_key / lst_data int_i bol_break str_tmp str_ret)
	(setq lst_data (txt_readfile_tolist str_file))
  	(setq lst_data (member (strcat "[" str_area "]") lst_data))
  	(if lst_data (setq lst_data (cdr lst_data)))
  	(setq int_i 0)
  	(while (null bol_break)
	       (setq str_tmp (nth int_i lst_data))
	       (cond ((null str_tmp)(setq bol_break T))
		     ((= "[" (substr str_tmp 1 1))(setq bol_break T))
		     ((= str_key (substr str_tmp 1 (strlen str_key)))(setq str_ret str_tmp))
	       )
	       (setq int_i (1+ int_i))
	)
  	(if str_ret (setq str_ret (nth 1 (symbolstr_list str_ret "="))))
  	str_ret
)
;;; 新增設定到INI檔
;;;==================================================================
(defun setini(str_file str_area str_key str_val / lst_data int_i str_tmp bol_break lst_ret bol_get)
	(setq lst_data (txt_readfile_tolist str_file))
  	(setq bol_get T)
	(setq int_i 0)
  	(setq str_tmp (nth int_i lst_data))
  	(while str_tmp
   	    (if (= (strcat "[" str_area "]") str_tmp)(progn
		(setq lst_ret (cons str_tmp lst_ret))
		(while (null bol_break)
		       (setq int_i (1+ int_i))
		       (setq str_tmp (nth int_i lst_data))
		       (cond ((null  str_tmp)
			      (if bol_get (progn
				  (setq lst_ret (cons (strcat str_key "=" str_val) lst_ret))
				  (setq bol_get nil)
			      ))
			      (setq bol_break T)
			     )
			     ((= ""  str_tmp)(setq lst_ret (cons str_tmp lst_ret)))
			     ((= "[" (substr str_tmp 1 1))
			      (if bol_get (progn
				  (setq lst_ret (cons (strcat str_key "=" str_val) lst_ret))
				  (setq bol_get nil)
			      ))
			      (setq lst_ret (cons str_tmp lst_ret))
			      (setq bol_break T)
			     )
			     ((= str_key (nth 0 (symbolstr_list str_tmp "=")))
			      (setq lst_ret (cons (strcat str_key "=" str_val) lst_ret))
			      (setq bol_get nil)
			     )
			     (t (setq lst_ret (cons str_tmp lst_ret)))
		        )
		)
	    )(progn (if str_tmp (setq lst_ret (cons str_tmp lst_ret)))))
	    (setq int_i (1+ int_i))
	    (setq str_tmp (nth int_i lst_data))
	)
        (setq lst_ret (reverse lst_ret))
  	(setq fle_fw (open str_file "w"))
  	(foreach str_tmp lst_ret (write-line str_tmp fle_fw))
)
;;; 屬性值變更  (change_attrib (car(entsel)) '("屬性名稱" "取代值"))
;;;====================================================================
(defun change_attrib(ent_blk lst_mod / str_ename lst_obj)
	(setq ent_blk (entnext ent_blk))
  	(while ent_blk
	  	(setq str_ename (cdr (assoc 0 (entget ent_blk))))
	  	(cond ((= "ATTRIB" str_ename)
		       (if (= (nth 0 lst_mod) (cdr (assoc 2 (entget ent_blk))))(progn
			   (setq lst_obj (entget ent_blk))
			   (setq lst_obj (subst (cons 1 (nth 1 lst_mod))(assoc 1 lst_obj) lst_obj))
			   (entmod lst_obj)
		       ))
		       (setq ent_blk (entnext ent_blk))
		      )
		      ((= "SEQEND" str_ename)(setq ent_blk nil))
		      (t (setq ent_blk (entnext ent_blk)))
		)
	)
)
;;; 屬性 BLOCK 萃取 ("屬性標籤" "屬性值")
;;;==================================================================
(defun search_attrib(ent_sht / str_ename ent_att str_lab1 str_lab2 lst_att str_att)
	(setq ent_att (entnext ent_sht))
	(while ent_att
		(setq str_ename (cdr (assoc 0 (entget ent_att))))
	  	(cond ((= "ATTRIB" str_ename)
		       (setq str_lab1 (cdr (assoc 1 (entget ent_att))))
	  	       (setq str_lab2 (cdr (assoc 2 (entget ent_att))))
		       (setq lst_att  (cons (list str_lab2 str_lab1) lst_att));;(("屬性標籤" "屬性值")...)
		       ;;(setq lst_att  (cons str_lab1 lst_att))
		       ;;(setq lst_att  (cons str_lab2 lst_att))
	  	       ;;(if (= ?str_xkey? str_lab2)(setq str_att (cdr (assoc 1 (entget ent_att)))));;將標籤傳入找出提示
		       (setq ent_att (entnext ent_att)))
		      ((= "SEQEND" str_ename)(setq ent_att nil))
		      (t (setq ent_att (entnext ent_att)))
		)
	)
  	(reverse lst_att)
)
;;取出SQL查詢後的資料
;;;==================================================================
(defun get_sqlrun_data(str_txt / str_txt str_chk1 str_chk2 bol_file bol_time fle_dat str_tmp lst_dat)
  	(if (findfile str_txt)(progn
	    (setq str_chk1 (rtos (getvar "cdate") 2 5))
	    (while (and (null bol_file)(null bol_time))
	      	   (setq fle_dat (open str_txt "r"))
	      	   (setq str_tmp (read-line fle_dat));;避免寫入延遲以重覆讀取直到有資料為止
	      	   (close fle_dat)
	      	   (setq str_chk2 (rtos (getvar "cdate") 2 5))
	      	   (if str_tmp (setq bol_file T))
	      	   (if (/= str_chk1 str_chk2)(setq bol_time T))
	    )
	)(progn (princ (strcat str_txt " not found!"))))
  	(if bol_file (progn
	    (setq lst_dat (txt_readfile_tolist str_txt));;("AA" "BB" "CC")
	    ;;(setq lst_dat (mapcar '(lambda (x) (symbolstr_list x ";")) lst_dat));;(("AA" "BB")("11" "22"))
	))
  	lst_dat
)
;;;
(defun get_taglist(txt / txt aalist idt tt)
    (setq aalist '())
    (setq txt (substr txt (1+ (get_word txt ";"))))
    (while (setq idt (get_word txt ";"))
        (setq tt (substr txt 1 (- idt 1)))
        (setq aalist (cons tt aalist))
        (setq txt (substr txt (1+ (get_word txt ";"))))
    );while
    (setq aaalist (cons txt aalist))
    (reverse aaalist)
);defun