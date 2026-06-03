;;;;
(defun usermenu(dclmenu_mnu dclmenu_dcl dialog_name backcol func_id / flag)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (actdcl (strcat usermenu_path dclmenu_dcl) dialog_name)
   (set_tile "title" "POWER TOOLS   開放式功能表                                        系統發展: 藝祥資訊")
   (if (null usermenu_function_list)
      (start_function_list dclmenu_mnu)
      (act_pop_list usermenu_function_list "function")
   )
   (if func_id
     (progn
       (set_tile "function" func_id)
       (usermenu_selitem func_id)
     )
   )
   (action_tile "function" "(setq func_id (get_tile \"function\"))(usermenu_selitem func_id)")
   (action_tile "sld1"  "(setq funcflag (nth 0  objlist))(usermenu_whichfunc)")
   (action_tile "sld2"  "(setq funcflag (nth 1  objlist))(usermenu_whichfunc)")
   (action_tile "sld3"  "(setq funcflag (nth 2  objlist))(usermenu_whichfunc)")
   (action_tile "sld4"  "(setq funcflag (nth 3  objlist))(usermenu_whichfunc)")
   (action_tile "sld5"  "(setq funcflag (nth 4  objlist))(usermenu_whichfunc)")
   (action_tile "sld6"  "(setq funcflag (nth 5  objlist))(usermenu_whichfunc)")
   (action_tile "sld7"  "(setq funcflag (nth 6  objlist))(usermenu_whichfunc)")
   (action_tile "sld8"  "(setq funcflag (nth 7  objlist))(usermenu_whichfunc)")
   (action_tile "sld9"  "(setq funcflag (nth 8  objlist))(usermenu_whichfunc)")
   (action_tile "sld10" "(setq funcflag (nth 9  objlist))(usermenu_whichfunc)")
   (action_tile "sld11" "(setq funcflag (nth 10 objlist))(usermenu_whichfunc)")
   (action_tile "sld12" "(setq funcflag (nth 11 objlist))(usermenu_whichfunc)")
   (action_tile "sld13" "(setq funcflag (nth 12 objlist))(usermenu_whichfunc)")
   (action_tile "sld14" "(setq funcflag (nth 13 objlist))(usermenu_whichfunc)")
   (action_tile "sld15" "(setq funcflag (nth 14 objlist))(usermenu_whichfunc)")
   (action_tile "sld16" "(setq funcflag (nth 15 objlist))(usermenu_whichfunc)")
   (action_tile "sld17" "(setq funcflag (nth 16 objlist))(usermenu_whichfunc)")
   (action_tile "sld18" "(setq funcflag (nth 17 objlist))(usermenu_whichfunc)")
   (action_tile "sld19" "(setq funcflag (nth 18 objlist))(usermenu_whichfunc)")
   (action_tile "sld20" "(setq funcflag (nth 19 objlist))(usermenu_whichfunc)")

   (action_tile "comm" "(usermenu_showcomm 0)")


   (action_tile "accept" "(setq funcflag nil)(done_dialog)")
   (start_dialog)
   (if funcflag (usermenu_exefunc funcflag))

   (SETQ FFF nil))
   (princ)
);defun

(defun usermenu_showcomm(typ / coun data)
  (if (= 0 typ)
    (progn
      (setq coun 1)
      (foreach nn objlist
         (progn
           (setq data (nth 3 (read nn)))
           (set_tile (strcat "sld" (rtos coun 2 0) "_txt") "")
           (setq commtype (nth 2 data))
           (if (= "(" (substr commtype 1 1))
             (set_tile (strcat "sld" (rtos coun 2 0) "_txt") (strcat (nth 0 data) ".lsp" commtype))
             (set_tile (strcat "sld" (rtos coun 2 0) "_txt") (strcat (nth 0 data) ".lsp(c:" commtype ")"))
           )
           (setq coun (1+ coun))
         );progn
      );foreach
    );progn
    (progn
      (setq coun 1)
      (foreach nn objlist
         (progn
           (setq data (nth 1 (read nn)))
           (set_tile (strcat "sld" (rtos coun 2 0) "_txt") data)
           (setq coun (1+ coun))
         );progn
      );foreach
    )
  );if
)


(defun usermenu_whichfunc()
  (cond
    ((= "1" (get_tile "exe")) (done_dialog))
    ((= "1" (get_tile "zoom"))
       (actdcl (strcat usermenu_path dclmenu_dcl) "zoomblock")
       (show_sld "sld_name" (strcat usermenu_path "FUNCSLD\\" (nth 0 (read funcflag))))
       (action_tile "accept" "(done_dialog)")
       (start_dialog))
    (T (princ))
  );cond
)

(defun userMENU_EXEfunc(word)
  (setq  word (read word))
  (setq kword (nth 2 word))
  (cond
    ((= KWORD "*")
      (setq C_TYPE (nth 3 word))
      (setq acad_ver (getvar "acadver"))
      (setq fff (open (strcat usermenu_path "usermenu.scr") "w"))
      (if (> (strlen acad_ver) 5)
        (progn
          (setq load_file (car C_TYPE))         ;load file
          (setq EXE_TYPE (cadr C_TYPE))         ;exe type
          (setq EXE_COMM (caddr C_TYPE))         ;exe command
          (setq txt (strcat "(cond ((null " EXE_TYPE ")(load " "\"" load_file "\"" "))(t (princ)))"))
          (write-line txt fff)
          (write-line EXE_COMM fff)
        );progn
        (write-line (nth 4 word) fff) ;配合 autocadLT 版之簡易指令
      );if
      (close fff)
      (setvar "cmdecho" 0)
      (command "script" (strcat usermenu_path "usermenu.scr"))
    )
    ((= KWORD "@")
      (setq fff (open (strcat usermenu_path "usermenu.scr") "w"))
      (setq aa word)
      (write-line (nth 3 word) fff) (close fff)
      (command "script" (strcat usermenu_path "usermenu.scr"))
    )
  )
)


(defun usermenu_selitem(func_id)
   (setq objlist (nth (atoi func_id) detail_funclist))
   (if (> (length objlist) 1)
     (progn
       (set_tile "error" "")
       (setq objlist (reverse (cdr (reverse objlist))))
       (setq count 0)

       (foreach nn objlist
         (progn
            (setq data (read nn))                                ;  key="sld16";
            (setq sldname (strcat usermenu_path "FUNCSLD\\" (nth 0 data)))
            (mode_tile (strcat "sld" (rtos (1+ count) 2 0)) 0)
            (if (findfile (strcat sldname ".sld"))
               (show_sld_col (strcat "sld" (rtos (1+ count) 2 0)) sldname  backcol)
            )
            (mode_tile (strcat "sld" (rtos (1+ count) 2 0) "_txt") 0)
         ;  (set_tile (strcat "sld" (rtos (1+ count) 2 0) "_txt") (nth 1 data))

            (setq count (1+ count))
         );progn
       );foreach

       (setq showcomm (get_tile "comm"))
       (if (= "1" showcomm) (usermenu_showcomm 0)  (usermenu_showcomm 1))

       (setq count (1+ count))
       (setq sldname (strcat usermenu_path "FUNCSLD\\none"))
       (repeat (- 17 count)
          (show_sld_col (strcat "sld" (rtos count 2 0)) sldname backcol)
          (mode_tile (strcat "sld" (rtos count 2 0)) 1)
            (set_tile (strcat "sld" (rtos count 2 0) "_txt") "")
          (mode_tile (strcat "sld" (rtos count 2 0) "_txt") 1)
         (setq count (1+ count))
       )
     );progn
     (progn
       (set_tile "error" "未建立任何功能!! ")
       (setq count 1)
       (repeat 16
          (setq sldname (strcat usermenu_path "FUNCSLD\\none"))
          (show_sld_col (strcat "sld" (rtos count 2 0)) sldname backcol)
          (mode_tile (strcat "sld" (rtos count 2 0)) 1)
          (set_tile (strcat "sld" (rtos count 2 0) "_txt") "")
          (mode_tile (strcat "sld" (rtos count 2 0) "_txt") 1)
          (setq count (1+ count))
       )
     )
   );if
)



(defun start_function_list(mnu)
   (setq ff (open (strcat usermenu_path mnu) "r"))
   (setq usermenu_function_list '() anyone_list nil data (read-line ff))
   (while data
      (if (= "**" (substr data 1 2))
         (progn
            (if anyone_list
                (setq detail_funclist (cons (reverse anyone_list) detail_funclist))
            )
            (setq anyone_list '())
            (setq usermenu_function_list (cons (substr data 3) usermenu_function_list))
            (if (null detail_funclist)
             (setq detail_funclist '())
            )
         );progn
         (progn
            (if (/= (strlen data) 0)
               (setq anyone_list (cons data anyone_list)))
         );progn
      )
      (setq data (read-line ff))
   )
   (setq detail_funclist (reverse (cons (reverse anyone_list) detail_funclist)))
   (setq usermenu_function_list (reverse usermenu_function_list))
   (act_pop_list usermenu_function_list "function")
   (close ff)
)

;;=============================================================================================

(defun c:manamenu(dclmenu_mnu dclmenu_dcl dialog_name)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setq count nil)
   (actdcl (strcat usermenu_path dclmenu_dcl) dialog_name)
   (set_tile "title" "客戶化功能表  V1.1 版            系統發展:藝祥資訊  04-4372371")
   (set_tile "error" "您若要建立新功能, 則請先點選功能目錄中的目錄!")

   (start_function_list dclmenu_mnu)

   (mode_tile "comtype" 1)
   (mode_tile "lispfname" 1)
   (mode_tile "deftype" 1)
   (mode_tile "descript" 1)
   (mode_tile "lisp" 1)
   (mode_tile "comm" 1)
   (mode_tile "selfile" 1)
   (mode_tile "addfunc" 1)
   (mode_tile "clear" 1)
   (show_sld_col "sld" "" 9)

   (action_tile "addcala" "(addcala dclmenu_mnu)")
   (action_tile "addfunc" "(addfunc_ok dclmenu_mnu)(set_tile \"allert\" \"\")")
   (action_tile "lisp" "(mode_tile \"comtype\" 0) (mode_tile \"lispfname\" 0) (mode_tile \"deftype\" 0)(mode_tile \"descript\" 0)(mode_tile \"selfile\" 0)(mode_tile \"addfunc\" 0)(mode_tile \"clear\" 0)")
   (action_tile "comm" "(mode_tile \"comtype\" 0) (mode_tile \"lispfname\" 1) (mode_tile \"deftype\" 1)(mode_tile \"descript\" 0)(mode_tile \"selfile\" 0)(mode_tile \"addfunc\" 0)(mode_tile \"clear\" 0)")

   (action_tile "function" "(set_tile \"allert\" \"\")(manamenu_check)")
   (action_tile "clear" "(manamenu_clear_ok)")
   (action_tile "selfile" "(manamenu_selfile)")

   (action_tile "accept" "(done_dialog)")
   (action_tile "cancel" "(done_dialog)")
   (start_dialog)

   (setq usermenu_function_list nil detail_funclist nil anyone_list nil)
   (SETQ FFF nil))
   (princ)
)

(defun manamenu_check(/ op ff data)
   (setq op (strcat usermenu_path dclmenu_mnu))
   (setq func_id (get_tile "function"))
;;;;;;;;;
   (setq search_txt (strcat "**" (nth (atoi func_id) usermenu_function_list)))
   (setq ff (open op "r"))
 ; (princ search_txt)
   (setq data (read-line ff))
   (while (/= search_txt data)
     (setq data (read-line ff))
   )
   (setq count 0)
 ; (if (= search_txt data)
 ;   (progn
        (setq data (read-line ff))
        (while (/= "END" data)
           (setq count (1+ count))
           (setq data (read-line ff))
        );while
  ;  )
  ;)
  (close ff)
  (if (< count 16)
    (progn
      (mode_tile "lisp" 0)
      (mode_tile "comm" 0)
      (set_tile "error" (strcat "每一功能目錄可建立 16 項子功能, 目前已建立 " (rtos count 2 0) " 項!" ))
    )
    (set_tile "error" (strcat "此目錄已達 16 項子功能, 不能再新增, 請選擇其它目錄, 或建立新目錄!" ))
  );if
)


(defun manamenu_selfile()
    (setq ff (getfiled "選擇幻燈片檔名" (strcat usermenu_path "funcsld\\") "SLD" 2))
    (setq ff (substr ff (1+ (strlen (strcat (strcat usermenu_path "funcsld\\"))))   ))
    (set_tile "sldfname" (strcase ff))
)

(defun manamenu_clear_ok()
   (set_tile "cataname" "")
   (set_tile "error" "")
   (set_tile "note" "")
   (set_tile "error" "")
   (set_tile "sldfname" "")
   (set_tile "function" "")
   (set_tile "sldname" "")
   (set_tile "descript" "")
   (set_tile "lisp" "")
   (set_tile "comm" "")
   (set_tile "comtype" "")
   (set_tile "lispfname" "")
   (set_tile "deftype" "")
   (show_sld_col "sld" "" -15)
   (mode_tile "comtype" 1)
   (mode_tile "lispfname" 1)
   (mode_tile "deftype" 1)
)


(defun addfunc_ok(MENUname / op wr)
   (setq fn fname)
   (setq sldname (get_tile "sldfname")
         descript (get_tile "descript")
         lisp (get_tile "lisp")
         comm (get_tile "comm")
         func_id (get_tile "function")
         comtype (get_tile "comtype")
         lispfname (get_tile "lispfname")
         deftype (get_tile "deftype"))
   (setq fname (strcat usermenu_path "funcsld\\" sldname))
   (setq op (strcat usermenu_path MENUname))
   (setq wr (strcat usermenu_path "SWAPFILE.TXT"))

   (cond
     ((= "" func_id) (set_tile "error" "請先選擇左方一項功能目錄,以判別新功能之群組歸屬!"))
     ((= "" sldname)(set_tile "error" "未選擇幻燈片檔名!"))
     ((null (findfile fname))(set_tile "error" (strcat  usermenu_path "funcsld\\" sldname "不存在!!")))
     ((and (= lisp "0") (= comm "0")) (set_tile "error" "未選擇功能類型,功能建立不成功!!"))
     ((and (= "1" lisp)(= "" comtype)) (set_tile "error" "指令執行方式未輸入!"))
     ((and (= "1" lisp)(= "" lispfname))(set_tile "error" "lisp檔名未輸入!"))
     ((and (= "1" lisp)(= "" deftype)) (set_tile "error" "lisp 函數定義方式未輸入!"))
     ((and (= "1" comm)(= "" comtype))(set_tile "error" "指令執行方式未輸入!"))
     ((= count 16)
        (manamenu_clear_ok)
        (set_tile "error" (strcat "此目錄已達 16 項子功能, 不能再新增!"))
         (mode_tile "comtype" 1)
         (mode_tile "lispfname" 1)
         (mode_tile "deftype" 1)
         (mode_tile "descript" 1)
         (mode_tile "lisp" 1)
         (mode_tile "comm" 1)
         (mode_tile "selfile" 1)
         (mode_tile "addfunc" 1)
         (mode_tile "clear" 1)
         (show_sld_col "sld" "" 9)
     )
     (T
        (setq sldname (substr sldname 1 (- (strlen sldname) 4)))
        (if (= "1" comm)
         (setq out_txt (strcat "(\"" sldname  "\" \"" descript "\" \"" "@" "\" \"" comtype "\")"))
         (setq out_txt (strcat "(\"" sldname  "\" \"" descript "\" \"" "*" "\" (\""
                      lispfname "\" \"" deftype "\" \"" comtype "\"))"))
        );if
        (insline_tofile op wr search_txt out_txt 0)
   ;    (set_tile "note" "功能建立成功!")
        (show_sld_col "sld" (strcat usermenu_path "funcsld\\" sldname) 250)
        (setq count (+ count 1))
        (set_tile "note" (strcat "目前已建立 " (rtos count 2 0) " 項!" ))
   ;    (set_tile "note" "VVERAVRV")
   ;    (PRINC "sdsdsdd")
     );T
   );cond

)


(defun addcala(mnu)
   (setq funcname (get_tile "cataname"))
   (cond
    ((= "" funcname) (set_tile "error" "未輸入目錄名稱 !"))
    ((member funcname usermenu_function_list) (set_tile "error" "目錄名稱已存在 ! 不能重覆建立!!"))
    (T (setq ff (open (strcat usermenu_path mnu) "a"))
       (write-line (strcat "**" funcname) ff)
       (write-line "END" ff)
       (close ff)
       (set_tile "mess" (strcat funcname "目錄名稱建立成功!!"))
       (start_function_list mnu))
   )
   (princ)
)


;╭═══════════════════════════════════╮
;║設計日期: 1997. 05.21   V1.0                                          ║
;║更新日期:                                                             ║
;║設 計 者: 陳冠達                                                      ║
;║功能說明: 製作功能幻燈片                                              ║
;║                                                                      ║
;║關聯檔案:                                                             ║
;║                                                                      ║
;╰═══════════════════════════════════╯
(defun c:usermake_part_sld(/ flag p1 p2 yesno)
   (setvar "cmdecho" 0)
   (setq p1 (getpoint "\n選擇幻燈片範圍第一點: ")
         p2 (getcorner p1 "\n選擇幻燈片範圍第二點: ")
         fname (getstring (strcat "\n輸入幻燈片檔名 "
                                  (strcase usermenu_path) "FUNCSLD\\")))
   (setq ffname (strcat usermenu_path "FUNCSLD\\" fname ".sld"))
   (if (findfile ffname)
      (progn
         (initget "Yes No")
         (setq yesno (getkword (strcase (strcat "\n" usermenu_path "FUNCSLD\\" fname "已經存在! 是否取代它<N0>: "))))
         (if (or (= "No" yesno) (null yesno)) (setq flag t))
      );progn
   );if
   (if (null flag)
     (progn
      (command "zoom" "w" p1 p2)
      (command "mslide" (strcat usermenu_path "FUNCsld\\" fname))
      (command "zoom" "p")
      (princ (strcat "\n幻燈片製作成功!! " (strcase fname) ".SLD 檔案放在 "
              (strcase usermenu_path) "FUNCSLD 目錄內!!"))
     )
   )
   (setvar "cmdecho" 1)
   (princ)
)



