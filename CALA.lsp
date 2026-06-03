;;;
;╭════════════════════╮
;║設計日期: 1998. 1. 22                   ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 標準計算機功能                ║
;║                                        ║
;║執行方式:                               ║
;║相關檔案:cala.dcl ,pub-lisp.lsp         ║
;║                                        ║
;╰════════════════════╯

;(defun c:cala(/ exeok chk)
(defun c:cala(/ exeok )
   ;; DraftSight: 移除加密狗 WHILE 迴圈
 (setvar "cmdecho" 0)
 (actdcl "cala" "cala")

 (setq caltxt "" mp_val nil)

 (action_tile "ac"  "(set_tile \"function\" \"\")(setq mp_val nil) (set_tile \"mtitle\" \"\") (set_tile \"memory\" \"\")")
 (action_tile "c"  "(set_tile \"function\" \"\")")

 (action_tile  "m+"       "(set_tile \"error\" \"\")(memoryp)")
 (action_tile  "m-"       "(set_tile \"error\" \"\")(memorym)")
 (action_tile  "mr"       "(set_tile \"error\" \"\")(if mp_val (cala_coltxt mp_val 0))")
 (action_tile "mc"  "(set_tile \"error\" \"\")(setq mp_val nil) (set_tile \"mtitle\" \"\") (set_tile \"memory\" \"\")")

 (action_tile  "7"        "(cala_coltxt \"7\" 0)"  )
 (action_tile  "8"        "(cala_coltxt \"8\" 0)"  )
 (action_tile  "9"        "(cala_coltxt \"9\" 0)"  )
 (action_tile  "4"        "(cala_coltxt \"4\" 0)"  )
 (action_tile  "5"        "(cala_coltxt \"5\" 0)"  )
 (action_tile  "6"        "(cala_coltxt \"6\" 0)"  )
 (action_tile  "1"        "(cala_coltxt \"1\" 0)"  )
 (action_tile  "2"        "(cala_coltxt \"2\" 0)"  )
 (action_tile  "3"        "(cala_coltxt \"3\" 0)"  )
 (action_tile  "0"        "(cala_coltxt \"0\" 0)"  )
 (action_tile  "0d"       "(cala_coltxt \"00\" 0)"  )
 (action_tile  "pd"       "(setq pd t)(cala_coltxt \".\" 0)"  )
 (action_tile  "left_c"   "(cala_coltxt \"(\" 0)"  )
 (action_tile  "right_c"  "(setq pd t)(cala_coltxt \")\" 1)"  )
 (action_tile  "x"        "(cala_coltxt \"*\" 1)(setq pd nil)"  )
 (action_tile  "dv"       "(cala_coltxt \"/\" 1)(setq pd nil)"  )
 (action_tile  "+"        "(cala_coltxt \"+\" 1)(setq pd nil)"  )
 (action_tile  "-"        "(cala_coltxt \"-\" 0)(setq pd nil)"  )
 (action_tile  "exp"      "(cala_coltxt \"^\" 1)" )
 (action_tile  "sqrt"     "(cala_coltxt \"sqrt(\" 0)")
 (action_tile  "="        "(setq pd t)(cale_cala_coltxt \".\" 0)(setq pd nil)(cala_ok)")

 (action_tile "accept" "(done_dialog)")
 (start_dialog)
 (setvar "cmdecho" 1)
   ;; removed FFF
 (prin1)
)

(defun memoryp()
  (setq chk (get_tile "function"))
  (if (or (= "" chk) (null (cal chk)))
    (set_tile "error" "運算式不正確或空值, 不記憶該值!")
    (progn
;     (setq val (c:cal (get_tile "function")))
      (setq val (cal (get_tile "function")))
        (if val
          (progn
            (if mp_val (setq mp_val (rtos (+ (atof mp_val) val) 2))
                       (setq mp_val (rtos val 2)))
            (set_tile "mtitle" "Ｍ記憶值: ")
            (set_tile "memory" mp_val)
            (set_tile "function" "")
            (if (= (atof mp_val) 0)(set_tile "mtitle" ""))
          );progn
       );if
    );progn
  );if
)
(defun memorym()
  (setq chk (get_tile "function"))
  (if (or (= "" chk) (null (cal chk)))
    (set_tile "error" "運算式不正確或空值, 不記憶該值!")
    (progn
;     (setq val (c:cal (get_tile "function")))
      (setq val (cal (get_tile "function")))
        (if val
          (progn
            (if mp_val (setq mp_val (rtos (- (atof mp_val) val) 2))
                       (setq mp_val (rtos val 2)))
            (set_tile "mtitle" "Ｍ記憶值: ")
            (set_tile "memory" mp_val)
            (set_tile "function" "")
            (if (= (atof mp_val) 0)(set_tile "mtitle" ""))
         );progn
       );if
    );progn
  )
)


(defun coltxt(fg fg1)
; (setq aaa fg)
  (set_tile "error" "")
  (if exeok
    (progn
       (setq exeok nil)
       (if (= 0 fg1)
        (set_tile "function" "")
       )
    )
  )
  (setq caltxt (get_tile "function"))
  (if (and (/= "" caltxt) (null (get_word caltxt ".")))
     (setq caltxt (strcat caltxt "." fg))
     (setq caltxt (strcat caltxt fg))
  )
  (set_tile "function" caltxt)
)


(defun cala_coltxt(fg fg1)
  (set_tile "error" "")
  (if exeok
    (progn
       (setq exeok nil)
       (if (= 0 fg1)
        (set_tile "function" "")
       )
    )
  )
  (setq caltxt (get_tile "function"))
  (if (and (/= caltxt "") (null pd) (/= fg "0")(/= fg "1")(/= fg "2")(/= fg "3")(/= fg "4")
           (/= fg "5")(/= fg "6")(/= fg "7")(/= fg "8")(/= fg "9")(/= fg "(")(/= fg "00"))
    (setq caltxt (strcat caltxt "." fg))
    (setq caltxt (strcat caltxt fg))
  )

  (set_tile "function" caltxt)
)

(defun cala_ok()
  (setq exeok t caltxt "")
  (setq func (get_tile "function"))
  (setq caltxt "")
  (setq cala_val (cal func))
  (if cala_val
    (progn
       (set_tile "function" (rtos cala_val 2))
    )
    (progn
       (set_tile "error" "運算式輸入不正確, 請再輸入一次!!")
       (set_tile "function" "")
    )
  )
)

;
;╭════════════════════╮
;║設計日期: 1998. 1. 22                   ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 工程計算機功能                ║
;║                                        ║
;║執行方式:                               ║
;║相關檔案:cal.dcl ,pub-lisp.lsp          ║
;║                                        ║
;╰════════════════════╯

;(defun c:cale(/ exeok chk)
(defun c:cale(/ exeok )
   ;; DraftSight: 移除加密狗 WHILE 迴圈
 (setvar "cmdecho" 0)
 (actdcl "cala" "cale")

 (setq caltxt "" mp_val nil)

 (action_tile "itom"  "(itom)")
 (action_tile "mtoi"  "(mtoi)")
 (action_tile "1/x"  "(1/x)")
 (action_tile "+/-"  "(addm)")
 (action_tile  "pi"  "(cale_cala_coltxt \"3.14159\" 0)"  )
 (action_tile "x!" "(x!)")


 (action_tile  "sin"        "(setq pd t)(cale_cala_coltxt  \"sin(\"  0)"  )
 (action_tile  "cos"        "(setq pd t)(cale_cala_coltxt  \"cos(\"  0)"  )
 (action_tile  "tan"        "(setq pd t)(cale_cala_coltxt  \"tan(\"  0)"  )
 (action_tile  "asin"        "(setq pd t)(cale_cala_coltxt \"asin(\" 0)"  )
 (action_tile  "acos"        "(setq pd t)(cale_cala_coltxt \"acos(\" 0)"  )
 (action_tile  "atan"        "(setq pd t)(cale_cala_coltxt \"atan(\" 0)"  )



 (action_tile "ac"  "(set_tile \"function\" \"\")(setq mp_val nil) (set_tile \"mtitle\" \"\") (set_tile \"memory\" \"\")")
 (action_tile "c"  "(set_tile \"function\" \"\")")

 (action_tile  "m+"       "(set_tile \"error\" \"\")(cale_memoryp)")
 (action_tile  "m-"       "(set_tile \"error\" \"\")(cale_memorym)")
 (action_tile  "mr"       "(set_tile \"error\" \"\")(if mp_val (cala_coltxt mp_val 0))")
 (action_tile "mc"  "(set_tile \"error\" \"\")(setq mp_val nil) (set_tile \"mtitle\" \"\") (set_tile \"memory\" \"\")")

 (action_tile  "7"        "(cale_cala_coltxt \"7\" 0)"  )
 (action_tile  "8"        "(cale_cala_coltxt \"8\" 0)"  )
 (action_tile  "9"        "(cale_cala_coltxt \"9\" 0)"  )
 (action_tile  "4"        "(cale_cala_coltxt \"4\" 0)"  )
 (action_tile  "5"        "(cale_cala_coltxt \"5\" 0)"  )
 (action_tile  "6"        "(cale_cala_coltxt \"6\" 0)"  )
 (action_tile  "1"        "(cale_cala_coltxt \"1\" 0)"  )
 (action_tile  "2"        "(cale_cala_coltxt \"2\" 0)"  )
 (action_tile  "3"        "(cale_cala_coltxt \"3\" 0)"  )
 (action_tile  "0"        "(cale_cala_coltxt \"0\" 0)"  )
 (action_tile  "0d"       "(cale_cala_coltxt \"00\" 0)"  )
 (action_tile  "pd"       "(setq pd t)(cale_cala_coltxt \".\" 0)"  )
 (action_tile  "left_c"   "(cale_cala_coltxt \"(\" 0)"  )
 (action_tile  "right_c"  "(setq pd t)(cale_cala_coltxt \")\" 0)"  )
 (action_tile  "x"        "(cale_cala_coltxt \"*\" 0)(setq pd nil)"  )
 (action_tile  "dv"       "(cale_cala_coltxt \"/\" 0)(setq pd nil)"  )
 (action_tile  "+"        "(cale_cala_coltxt \"+\" 0)(setq pd nil)"  )
 (action_tile  "-"        "(cale_cala_coltxt \"-\" 0)(setq pd nil)"  )
 (action_tile  "exp"      "(cale_cala_coltxt \"^\" 0)" )
 (action_tile  "sqrt"     "(cale_cala_coltxt \"sqrt(\" 0)")
 (action_tile  "="        "(setq pd t)(cale_cala_ok)")

 (action_tile "accept" "(done_dialog)")
 (start_dialog)
 (setvar "cmdecho" 1)
   ;; removed FFF
 (prin1)
)


(defun addm()
  (setq chk (get_tile "function"))
  (if (or (= "" chk) (null (cal chk)))
    (set_tile "error" "運算式不正確或空值! 請先輸入數值!")
    (progn
      (set_tile "function" "")
      (set_tile "function" (strcat "-" chk))
   );progn
 );if
)


(defun 1/x()
  (if exeok
    (progn
       (setq exeok nil)
       (if (= 0 fg1)
        (set_tile "function" "")
       )
    )
  )
  (setq chk (get_tile "function"))
  (if (or (= "" chk) (null (cal chk)))
    (set_tile "error" "運算式不正確或空值! 請先輸入數值!")
    (progn
      (set_tile "function" "")
      (cale_cala_coltxt (rtos (/ 1 (atof chk)) 2) 0)
    )
  )
)

(defun itom()
  (if exeok
    (progn
       (setq exeok nil)
       (if (= 0 fg1)
        (set_tile "function" "")
       )
    )
  )
  (setq chk (get_tile "function"))
  (if (or (= "" chk) (null (cal chk)))
    (set_tile "error" "運算式不正確或空值! 請先輸入數值!")
    (progn
      (set_tile "function" "")
      (cale_cala_coltxt (rtos (* (atof chk) 25.4) 2) 0)
    )
  )
)

(defun mtoi()
  (if exeok
    (progn
       (setq exeok nil)
       (if (= 0 fg1)
        (set_tile "function" "")
       )
    )
  )
  (setq chk (get_tile "function"))
  (if (or (= "" chk) (null (cal chk)))
    (set_tile "error" "運算式不正確或空值! 請先輸入數值!")
    (progn
      (set_tile "function" "")
      (cale_cala_coltxt (rtos (/ (atof chk) 25.4) 2) 0)
    )
  )
)

(defun cale_memoryp()
  (setq chk (get_tile "function"))
  (if (or (= "" chk) (null (cal chk)))
    (set_tile "error" "運算式不正確或空值, 不記憶該值!")
    (progn
;     (setq val (c:cal (get_tile "function")))
      (setq val (cal (get_tile "function")))
        (if val
          (progn
            (if mp_val (setq mp_val (rtos (+ (atof mp_val) val) 2))
                       (setq mp_val (rtos val 2)))
            (set_tile "mtitle" "Ｍ記憶值: ")
            (set_tile "memory" mp_val)
            (set_tile "function" "")
            (if (= (atof mp_val) 0)(set_tile "mtitle" ""))
          );progn
       );if
    );progn
  );if
)
(defun cale_memorym()
  (setq chk (get_tile "function"))
  (if (or (= "" chk) (null (cal chk)))
    (set_tile "error" "運算式不正確或空值, 不記憶該值!")
    (progn
;     (setq val (c:cal (get_tile "function")))
      (setq val (cal (get_tile "function")))
        (if val
          (progn
            (if mp_val (setq mp_val (rtos (- (atof mp_val) val) 2))
                       (setq mp_val (rtos val 2)))
            (set_tile "mtitle" "Ｍ記憶值: ")
            (set_tile "memory" mp_val)
            (set_tile "function" "")
            (if (= (atof mp_val) 0)(set_tile "mtitle" ""))
         );progn
       );if
    );progn
  )
)


(defun cale_cala_coltxt(fg fg1)
  (set_tile "error" "")
  (if exeok
    (progn
       (setq exeok nil)
       (if (= 0 fg1)
        (set_tile "function" "")
       )
    )
  )
  (setq caltxt (get_tile "function"))
  (if (and (/= caltxt "") (null pd) (/= fg "0")(/= fg "1")(/= fg "2")(/= fg "3")(/= fg "4")
           (/= fg "5")(/= fg "6")(/= fg "7")(/= fg "8")(/= fg "9")(/= fg "(")(/= fg "00"))
    (setq caltxt (strcat caltxt "." fg))
    (setq caltxt (strcat caltxt fg))
  )
  (set_tile "function" caltxt)
)

(defun cale_cala_ok()
  (setq exeok t caltxt "")
; (setq exeok t)
  (setq func (get_tile "function"))
; (setq aaa caltxt)
  (setq cala_val (cal func))
  (if cala_val
    (progn
       (set_tile "function" (rtos cala_val 2))
    )
    (progn
       (set_tile "error" "運算式輸入不正確, 請再輸入一次!!")
       (set_tile "function" "")
    )
  )
)

