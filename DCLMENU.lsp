;;;

 (defun dclmenu(dclmenu_mnu dclmenu_dcl dialog_name func_id / exec_id)

   ;; 已移除加密狗判斷(progn ;; DraftSight: 移除加密狗 WHILE 迴圈(setq ppss sspp)

  (cond ((null actdcl) (load "pub-lisp")) (t (princ)))
  (actdcl (strcat dclmenu_path dclmenu_dcl) dialog_name)

  (dclmenu_read_data)

  (cond
    ((= func_id 1)(show_func subfunc1_list))
    ((= func_id 2)(show_func subfunc2_list))
    ((= func_id 3)(show_func subfunc3_list))
    ((= func_id 4)(show_func subfunc4_list))
    ((= func_id 5)(show_func subfunc5_list))
    ((= func_id 6)(show_func subfunc6_list))
    ((= func_id 7)(show_func subfunc7_list))
    ((= func_id 8)(show_func subfunc8_list))
    ((= func_id 9)(show_func subfunc9_list))
    ((= func_id 10)(show_func subfunc10_list))
    ((= func_id 11)(show_func subfunc11_list))
    ((= func_id 12)(show_func subfunc12_list))
    ((= func_id 13)(show_func subfunc13_list))
    ((= func_id 14)(show_func subfunc14_list))
    ((= func_id 15)(show_func subfunc15_list))
    ((= func_id 16)(show_func subfunc16_list))
    ((= func_id 17)(show_func subfunc17_list))
    ((= func_id 18)(show_func subfunc18_list))
  )

;set tile value
  (set_tile "title" func_name)
  (action_tile "func1"  "(setq func_id 1)(show_func subfunc1_list)")
  (action_tile "func2"  "(setq func_id 2)(show_func subfunc2_list)")
  (action_tile "func3"  "(setq func_id 3)(show_func subfunc3_list)")
  (action_tile "func4"  "(setq func_id 4)(show_func subfunc4_list)")
  (action_tile "func5"  "(setq func_id 5)(show_func subfunc5_list)")
  (action_tile "func6"  "(setq func_id 6)(show_func subfunc6_list)")
  (action_tile "func7"  "(setq func_id 7)(show_func subfunc7_list)")
  (action_tile "func8"  "(setq func_id 8)(show_func subfunc8_list)")
  (action_tile "func9"  "(setq func_id 9)(show_func subfunc9_list)")
  (action_tile "func10" "(setq func_id 10)(show_func subfunc10_list)")
  (action_tile "func11" "(setq func_id 11)(show_func subfunc11_list)")
  (action_tile "func12" "(setq func_id 12)(show_func subfunc12_list)")
  (action_tile "func13" "(setq func_id 13)(show_func subfunc13_list)")
  (action_tile "func14" "(setq func_id 14)(show_func subfunc14_list)")
  (action_tile "func15" "(setq func_id 15)(show_func subfunc15_list)")
  (action_tile "func16" "(setq func_id 16)(show_func subfunc16_list)")
  (action_tile "func17" "(setq func_id 17)(show_func subfunc17_list)")
  (action_tile "func18" "(setq func_id 18)(show_func subfunc18_list)")

  (action_tile "accept" "(done_dialog)")

  (start_dialog)
  (if exec_id (dclmenu_exe exec_id))

  (SETQ FFF nil))
  (princ)
)

(defun DCLMENU_EXE(id_p)
  (setq word (read (nth id_p cur_func_list)))
  (setq kword (nth 3 word))
  (cond
    ((= KWORD "*")                                ;* is Autolist file
      (setq C_TYPE (nth 4 word)
            load_file (car C_TYPE)          ;load file
            EXE_TYPE (cadr C_TYPE)          ;exe type
            EXE_COMM (caddr C_TYPE)          ;exe command
            fff (open (strcat dclmenu_path "dclmenu.scr") "w")
            txt (strcat "(cond ((null " EXE_TYPE ")(load " "\"" load_file "\"" "))(t (princ)))"))
      (write-line txt fff)
      (write-line EXE_COMM fff) (close fff)(setvar "cmdecho" 0)
      (command "script" (strcat dclmenu_path "dclmenu.scr"))
    )
    ((= KWORD "@")
      (setq count 0)
      (setq fff (open (strcat dclmenu_path "dclmenu.scr") "w"))
      (setq word (nth 4 word))
      (repeat (length word)
        (write-line (nth count word) fff)
        (setq count (+ count 1)))
      (close fff)
      (command "script" (strcat dclmenu_path "dclmenu.scr"))
    )
    (T
      (setq fff (open (strcat dclmenu_path "dclmenu.scr") "w"))
      (write-line (nth 4 word) fff) (close fff)
      (command "script" (strcat dclmenu_path "dclmenu.scr"))
    )
  )
)



(defun show_func(listname)
  (setq cur_func_list listname)
  (setq sld_list '(""))
  (setq txt_list '(""))
  (setq func_list '(""))
  (setq count 1)
  (repeat 16
     (setq sld (nth 1 (read (nth count listname))))
     (setq sld_list (cons (strcat dclmenu_path sld) sld_list))
     (setq txt (nth 2 (read (nth count listname))))
     (setq txt_list (cons txt txt_list))
     (setq func (nth 3 (read (nth count listname))))
     (setq func_list (cons func func_list))
     (setq count (1+ count))
  )
  (setq sld_list (cdr (reverse sld_list)))
  (setq txt_list (cdr (reverse txt_list)))
  (setq sldkey_list '("sld11" "sld12" "sld13" "sld14"
                      "sld21" "sld22" "sld23" "sld24"
                      "sld31" "sld32" "sld33" "sld34"
                      "sld41" "sld42" "sld43" "sld44"))
  (setq txtkey_list '("sld11_txt" "sld12_txt" "sld13_txt" "sld14_txt"
                      "sld21_txt" "sld22_txt" "sld23_txt" "sld24_txt"
                      "sld31_txt" "sld32_txt" "sld33_txt" "sld34_txt"
                      "sld41_txt" "sld42_txt" "sld43_txt" "sld44_txt"))

  (mapcar 'show_sld sldkey_list sld_list)
  (mapcar 'show_txt txtkey_list txt_list)


  (action_tile "sld11" "(setq exec_id 1)(done_dialog)")
  (action_tile "sld12" "(setq exec_id 2)(done_dialog)")
  (action_tile "sld13" "(setq exec_id 3)(done_dialog)")
  (action_tile "sld14" "(setq exec_id 4)(done_dialog)")
  (action_tile "sld21" "(setq exec_id 5)(done_dialog)")
  (action_tile "sld22" "(setq exec_id 6)(done_dialog)")
  (action_tile "sld23" "(setq exec_id 7)(done_dialog)")
  (action_tile "sld24" "(setq exec_id 8)(done_dialog)")
  (action_tile "sld31" "(setq exec_id 9)(done_dialog)")
  (action_tile "sld32" "(setq exec_id 10)(done_dialog)")
  (action_tile "sld33" "(setq exec_id 11)(done_dialog)")
  (action_tile "sld34" "(setq exec_id 12)(done_dialog)")
  (action_tile "sld41" "(setq exec_id 13)(done_dialog)")
  (action_tile "sld42" "(setq exec_id 14)(done_dialog)")
  (action_tile "sld43" "(setq exec_id 15)(done_dialog)")
  (action_tile "sld44" "(setq exec_id 16)(done_dialog)")
  (set_tile "func_tile" (nth 0 listname))
)


(defun menu_ok()
   (done_dialog)
   (princ)
)

; open dclmenu.mnu  & read data
(defun dclmenu_read_data()
  (setq dclmenu_file (open (strcat dclmenu_path dclmenu_mnu) "r"))
  (setq data (read-line dclmenu_file))
  (while data
     (if (= "***" (substr data 1 3))
        (setq func_name (substr data 4) data nil)
        (setq data (read-line dclmenu_file))
     )
  )

  (setq subfunc1_list '(""))
  (setq subfunc2_list '(""))
  (setq subfunc3_list '(""))
  (setq subfunc4_list '(""))
  (setq subfunc5_list '(""))
  (setq subfunc6_list '(""))
  (setq subfunc7_list '(""))
  (setq subfunc8_list '(""))
  (setq subfunc9_list '(""))
  (setq subfunc10_list '(""))
  (setq subfunc11_list '(""))
  (setq subfunc12_list '(""))
  (setq subfunc13_list '(""))
  (setq subfunc14_list '(""))
  (setq subfunc15_list '(""))
  (setq subfunc16_list '(""))
  (setq subfunc17_list '(""))
  (setq subfunc18_list '(""))

  (setq data (read-line dclmenu_file))
; (while data
;;collect subfunc1_list
    (if (= "**" (substr data 1 2))
       (progn
          (setq subfunc1_list (cons (substr data 3) subfunc1_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc1_list (cons (substr data 2) subfunc1_list))
            )(setq data (read-line dclmenu_file))
          );while
       );progn
    );if
    (setq subfunc1_list (cdr (reverse subfunc1_list)))

;;collect subfunc2_list
;   (if (= "**" (substr data 1 2))
;      (progn
          (setq subfunc2_list (cons (substr data 3) subfunc2_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc2_list (cons (substr data 2) subfunc2_list))
            )(setq data (read-line dclmenu_file))
          );while
;      );progn
;   );if
       (setq subfunc2_list (cdr (reverse subfunc2_list)))
;
;;collect subfunc3_list
          (setq subfunc3_list (cons (substr data 3) subfunc3_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc3_list (cons (substr data 2) subfunc3_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc3_list (cdr (reverse subfunc3_list)))

;;collect subfunc4_list
          (setq subfunc4_list (cons (substr data 3) subfunc4_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc4_list (cons (substr data 2) subfunc4_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc4_list (cdr (reverse subfunc4_list)))

;;collect subfunc5_list
          (setq subfunc5_list (cons (substr data 3) subfunc5_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc5_list (cons (substr data 2) subfunc5_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc5_list (cdr (reverse subfunc5_list)))

;;collect subfunc6_list
          (setq subfunc6_list (cons (substr data 3) subfunc6_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc6_list (cons (substr data 2) subfunc6_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc6_list (cdr (reverse subfunc6_list)))

;;collect subfunc7_list
          (setq subfunc7_list (cons (substr data 3) subfunc7_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc7_list (cons (substr data 2) subfunc7_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc7_list (cdr (reverse subfunc7_list)))

;;collect subfunc8_list
          (setq subfunc8_list (cons (substr data 3) subfunc8_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc8_list (cons (substr data 2) subfunc8_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc8_list (cdr (reverse subfunc8_list)))

;;collect subfunc9_list
          (setq subfunc9_list (cons (substr data 3) subfunc9_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc9_list (cons (substr data 2) subfunc9_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc9_list (cdr (reverse subfunc9_list)))

;;collect subfunc10_list
          (setq subfunc10_list (cons (substr data 3) subfunc10_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc10_list (cons (substr data 2) subfunc10_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc10_list (cdr (reverse subfunc10_list)))

;;collect subfunc11_list
          (setq subfunc11_list (cons (substr data 3) subfunc11_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc11_list (cons (substr data 2) subfunc11_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc11_list (cdr (reverse subfunc11_list)))

;;collect subfunc12_list
          (setq subfunc12_list (cons (substr data 3) subfunc12_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc12_list (cons (substr data 2) subfunc12_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc12_list (cdr (reverse subfunc12_list)))

;;collect subfunc13_list
          (setq subfunc13_list (cons (substr data 3) subfunc13_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc13_list (cons (substr data 2) subfunc13_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc13_list (cdr (reverse subfunc13_list)))

;;collect subfunc14_list
          (setq subfunc14_list (cons (substr data 3) subfunc14_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc14_list (cons (substr data 2) subfunc14_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc14_list (cdr (reverse subfunc14_list)))

;;collect subfunc15_list
          (setq subfunc15_list (cons (substr data 3) subfunc15_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc15_list (cons (substr data 2) subfunc15_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc15_list (cdr (reverse subfunc15_list)))

;;collect subfunc16_list
          (setq subfunc16_list (cons (substr data 3) subfunc16_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc16_list (cons (substr data 2) subfunc16_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc16_list (cdr (reverse subfunc16_list)))

;;collect subfunc17_list
          (setq subfunc17_list (cons (substr data 3) subfunc17_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc17_list (cons (substr data 2) subfunc17_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc17_list (cdr (reverse subfunc17_list)))

;;collect subfunc18_list
          (setq subfunc18_list (cons (substr data 3) subfunc18_list))
          (setq data (read-line dclmenu_file))
          (while (/= "**" (substr data 1 2))
            (if (= "*" (substr data 1 1))
               (setq subfunc18_list (cons (substr data 2) subfunc18_list))
            )(setq data (read-line dclmenu_file))
          );while
       (setq subfunc18_list (cdr (reverse subfunc18_list)))

  (close dclmenu_file)
)

;╭═══════════════════════╮
;║設計日期: 1995. 9.14                          ║
;║更新日期:                                     ║
;║設 計 者: 陳冠達                              ║
;║功能說明: 顯示data於text DCL                  ║
;║                                              ║
;║執行方式:(show_txt key串列 data串列)          ║
;║相關檔案:                                     ║
;╰═══════════════════════╯
(defun show_txt(key txt)
   (set_tile key txt)
)
