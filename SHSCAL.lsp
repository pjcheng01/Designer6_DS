;;;
;; 設定圖紙與比例式  c:shscal
;; 重定比例
;;更換圖框           c:ch_sheet()
(if (null base_dimscale) (setq base_dimscale 1))

(setq &&scale_tag (read (getfile_val (strcat POWDESIGN_path "shscal.ini") "ALL_SHEET_SCALE_TAG")))

;;=============================================================================================
;╭═════════════════════════════════════╮
;║設計日期: 1997. 2. 24   V1.0                                              ║
;║更新日期: 1998. 3. 31   V1.1                                              ║
;║設 計 者: 陳冠達                                                          ║
;║功能說明: 設定圖紙與比例式                                                ║
;║                                                                          ║
;║關聯檔案: shscal.dcl ,SH_TYPPE.SLD,A4HOR.DWG,A3HOR.DWG,A2HOR.DWG,A1HOR.DWG║
;║               A0HOR.DWGA,4VER.DWG,A3VER.DWG,A2VER.DWG,A1VER.DWG,A0VER.DWG║
;╰═════════════════════════════════════╯
(defun c:shscal()
   ;; DraftSight: 移除加密狗 WHILE 迴圈
    (setvar "cmdecho" 0)
    (command "select" "ALL" "")
    (comp_cur_limits)
    (actdcl "shscal" "shscal")

    (setq horv (get_tile "hor"))
;  (if (= horv 1) (setq sh_type 0))
   (if (= horv 1) (setq sh_type "hor")(setq sh_type "ver"))

    (setq get_cur_scal (getvar "dimscale"))
    (if (= get_cur_scal 0)(progn (setvar "dimscale" 1) (setq get_cur_scal 1)))
    (shscal_show_data_on_dcl)
    (show_sld "sh_sld" "sh_type")

    (action_tile "a0" "(setq sh_size 0)")
    (action_tile "a1" "(setq sh_size 1)")
    (action_tile "a2" "(setq sh_size 2)")
    (action_tile "a3" "(setq sh_size 3)")
    (action_tile "a4" "(setq sh_size 4)")

    (action_tile "ver" "(setq sh_type \"ver\")")
    (action_tile "hor" "(setq sh_type \"hor\")")


    (action_tile "setcal" "(setcal)")


    (action_tile "cancel" "(done_dialog)(setq check_p nil)")
    (action_tile "accept" "(setscal_ok)")
    (start_dialog)
    (if check_p (insert_sheet))
    ;; removed FFF
    (princ)
)

;;取得圖框日期型式
;(defun sheet_datetype()
;    (getfile_val (strcat POWDESIGN_path "shscal.ini") "圖框日期型式")
;)


(defun insert_sheet()
    (princ "\n請調整滿意圖框位置!!")

   (setq cl (getvar "clayer")
         ccol (getvar "cecolor")
         cltype (getvar "celtype")
         attdia_type (getvar "attdia"))
   (setvar "attdia" 1)
   (command "layer" "m" sys_sheet_layer "c" sys_sheet_layercol "" "")
;  (command "layer" "m" sys_sheet_layer "c" sys_sheet_layercol "")

    (if (= "GENIUS" acad_ver)
       (progn
        (if (null vctr)
         (progn
          (command ".insert" sheet_name (setq vctr (getvar "viewctr")) "1" "" "0")
         )
         (progn
          (command ".insert" sheet_name vctr "1" "" "0")
         )
        )
       );progn
       (progn
        (if (null vctr)
         (progn
          (command "insert" sheet_name (setq vctr (getvar "viewctr")) "1" "" "0")
         )
         (progn
          (command "insert" sheet_name vctr "1" "" "0")
         )
        )
       );progn
    )



    (setq moveent (entlast))
    (if (/= ?scl 1) (command "scale" "l" "" vctr ?scl)
                    (command "scale" "l" "" vctr "1"))
    (command "move" moveent "" vctr pause)
    (command "zoom" "E")
   (setvar "attdia" attdia_type)
   (command "layer" "s" cl "")
   (command "color" ccol)
   (command "linetype" "s" cltype "")
    (princ)
)


(defun setscal_ok()
   (setq check_p t)
   (setq fact1 (atof (get_tile "out_mm"))
         fact2 (atof (get_tile "out_unit")))

    (setq horv (get_tile "hor"))
   (if (= horv "1") (setq sh_type "hor")(setq sh_type "ver"))


   (done_dialog)
   (cond
    ((= 0 sh_size) (setq sh_size "a0"))
    ((= 1 sh_size) (setq sh_size "a1"))
    ((= 2 sh_size) (setq sh_size "a2"))
    ((= 3 sh_size) (setq sh_size "a3"))
    (T (setq sh_size "a4"))
   )
    (setq sheet_name (strcat sh_size sh_type))

    (cond
      ((< 1 (/ fact1 fact2)) (setq ?scl (/ fact2 fact1)))
      ((> 1 (/ fact1 fact2)) (setq ?scl fact2))
      (T (setq ?scl 1))
    )
    (setvar "ltscale" ?scl)
;;;;(setvar "dimscale" ?scl)
    (setvar "dimscale" (* base_dimscale ?scl))
    (setvar "textsize" (* ?scl 3))
)





(defun setcal()
   (actdcl "shscal" "selscal")
   (setq scal_list '("1:100" "1:50" "1:45" "1:40" "1:35" "1:30" "1:25" "1:20" "1:15" "1:12" "1:10" "1:9" "1:8" "1:7" "1:6" "1:5" "1:4" "1:3" "1:2" "1:1" "2:1" "3:1" "4:1" "5:1" "6:1" "7:1" "8:1" "9:1" "10:1" "12:1" "15:1" "20:1" "25:1" "30:1" "35:1" "40:1" "45:1" "50:1" "100:1"))
   (start_list "scal_list")
   (mapcar 'add_list scal_list)
   (end_list)
   (set_tile "scal_list" "8")
   (action_tile "scal_list" "(shscal_getdata $value)")
   (action_tile "accept" "(scal_ok)(done_dialog 0)(settile)")
   (start_dialog)
)

(defun scal_ok()
   (if (null id_value)
     (setq id_value "1:1"))
   (setq k_num (get_word id_value ":"))
   (setq w1 (substr id_value 1 (- k_num 1))
         w2 (substr id_value (+ k_num 1)))
)
(defun settile()
   (set_tile "out_mm" w1)
   (set_tile "out_unit" w2)
)

(defun shscal_getdata(value)
      (setq nn (atoi value)
            id_value (nth nn scal_list))
)


(defun comp_cur_limits()
   (if (ssget "p")
     (progn
       (command "zoom" "e")
       (setq VCTR (getvar "viewctr")
             LEFT_DOWN (getvar "vsmin")
             RIGHT_UP (getvar "vsmax")
             S_RATIO (/ (- (car RIGHT_UP) (car LEFT_DOWN))
                        (- (cadr RIGHT_UP) (cadr LEFT_DOWN)))
             SY (getvar "viewsize")
             SX (* S_RATIO SY)
       )
       (command "zoom" "p")
     ) )
)

(defun shscal_show_data_on_dcl()
    (if (>= get_cur_scal 1) (setq out_mm 1 out_unit get_cur_scal)
       (setq out_mm (/ 1.0 get_cur_scal) out_unit 1))
   (setq int_zin (getvar "dimzin"))
   (setvar "dimzin" 9)

   (set_tile "out_mm" (rtos out_mm 2 ))
   (set_tile "out_unit" (rtos out_unit 2 ))

   (if (ssget "p")
     (set_tile "draw_limit" (strcat "目前圖形所佔範圍是: " (rtos sx 2) "  " "*" " " (rtos sy 2)))
   )
    (setvar "dimzin" int_zin)
)
;;;改變圖框
(defun shscal_show_data_on_dcl_chsheet(cur_scal)
    (if (>= cur_scal 1) (setq out_mm 1 out_unit cur_scal)
       (setq out_mm (/ 1.0 cur_scal) out_unit 1))

   (setq int_zin (getvar "dimzin"))
   (setvar "dimzin" 9)

   (set_tile "out_mm" (rtos out_mm 2))
   (set_tile "out_unit" (rtos out_unit 2))

   (if (ssget "p")
     (set_tile "draw_limit" (strcat "目前圖形所佔範圍是: " (rtos sx 2) "  " "*" " " (rtos sy 2)))
   )
     (setvar "dimzin" int_zin)
)

; 重定比例
(defun c:resetting(/ resetting_fg allup sheet_blk)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
   (setq olddimscal (getvar "dimscale"))
   (resetscal_val)
   (if (/= nil (ssget "x" (list (cons 8 sys_sheet_layer) (cons 0 "INSERT"))))
     (progn
       (setq #osmode (getvar "osmode")) ;2003.06.06 SAM
       (setvar "osmode" 0)              ;2003.06.06 SAM
       (resetting_val)
       (resetting_text)
       (reset_block_scale)
       (rest_dimdtyle_dimscale)
       (setvar "osmode" #osmode)        ;2003.06.06 SAM
     )
     (progn
         (setvar "cmdecho" 0)
         (setvar "ltscale" ?scl?)
;;;;;    (setvar "dimscale" ?scl?)
         (setvar "dimscale" (* base_dimscale ?scl?))
         (setvar "textsize" (* ?scl? 3))
         (resetting_text)
         (reset_block_scale)
         (rest_dimdtyle_dimscale)
         (command "regen")
         (princ (strcat "\n比例重新設定完成!!"))
     );progn
   )
   ;; removed FFF
   (PRINC)
)

(defun resetting_text(/ txtgrp count ent entdata data10)
   (setq txtgrp (ssget "x" (list  (cons 0 "TEXT"))))
   (if (/= nil txtgrp)
     (progn
        (setq count 0)
        (repeat (sslength txtgrp)
          (setq ent (ssname txtgrp count)
                entdata (entget ent)
                data10 (cdr (assoc 10 entdata)))
          (command "scale" ent "" data10 (/ 1.0 olddimscal))  ;;先還原到 1:1
          (command "scale" ent "" data10 ?scl?)               ;;變化到新比例
          (setq count (1+ count))
        );repeat
     );progn
   );if
   (setq olddimscal nil)
)




(defun resetscal_val()
         (actdcl "shscal" "reselscal")
         (setq curscal (getvar "dimscale"))

          (setq int_zin (getvar "dimzin"))
          (setvar "dimzin" 9)
         (cond
           ((= 1 curscal)  (set_tile "curscal" (strcat "目前整體比例= 1 : 1")))
           ((< 1 curscal)  (set_tile "curscal" (strcat "目前整體比例= 1 : " (rtos curscal 2))))
           (T  (set_tile "curscal" (strcat "目前整體比例=" (rtos (/ 1 curscal) 2)  " : 1" )))
         )
          (setvar "dimzin" int_zin)
         (setq scal_list '("1:100" "1:50" "1:45" "1:40" "1:35" "1:30" "1:25" "1:20" "1:15" "1:12" "1:10" "1:9" "1:8" "1:7" "1:6" "1:5" "1:4" "1:3" "1:2" "1:1" "2:1" "3:1" "4:1" "5:1" "6:1" "7:1" "8:1" "9:1" "10:1" "12:1" "15:1" "20:1" "25:1" "30:1" "35:1" "40:1" "45:1" "50:1" "100:1"))
         (start_list "scal_list")
         (mapcar 'add_list scal_list)
         (end_list)
         (action_tile "scal_list" "(resetting_shscal_getdata $value)")
         (action_tile "accept" "(resetting_ok)")
         (action_tile "cancel" "(done_dialog)")
         (start_dialog)
)


(defun resetting_sval()
   (setvar "cmdecho" 0)
   (setvar "ltscale" ?scl?)
;  (setvar "dimscale" ?scl?)
    (setvar "dimscale" (* base_dimscale ?scl?))
   (setvar "textsize" (* ?scl? 3))
   (if (= "1" allup)
     (progn
;        (command "dim" "up" "all" "" "exit" "regen")
        (princ (strcat "\n比例重新設定完成!!"))
        (command "zoom" "e")
     )
     (progn
        (command "zoom" "e")
       (princ "\n比例重新設定完成, 但尺寸尚未自動更新 !")
       (princ "\n您可以在 [標註:] 模式下, 以 \"UP\" 指令, 選擇要更新的尺寸 !!")
     );progn
   );if
   (command "regen")
   (setvar "cmdecho" 1)
)
(defun resetting_val()

   (setvar "cmdecho" 0)
   (setvar "ltscale" ?scl?)
;;;(setvar "dimscale" ?scl?)
    (setvar "dimscale" (* base_dimscale ?scl?))
   (setvar "textsize" (* ?scl? 3))

   (setq sheetent (ssget "x" (list (cons 0 "INSERT")(cons 8 sys_sheet_layer))))
   (if (/= nil sheetent)
     (progn
       (setq entdata (entget (ssname sheetent 0)))
       (setq insp (cdr (assoc 10 entdata)))
       (setq sca (cdr (assoc 41 entdata)))

       (setq ~i 0)
       (repeat (sslength sheetent)
             (if (null (getxdata (ssname sheetent ~i) "MODFLAG"))
                 (progn
                       (if (/= sca 1) (command "scale" (ssname sheetent ~i) "" insp (/ 1.0 sca)))
                       (command "scale" (ssname sheetent ~i) "" insp ?scl?)
                 );progn
             );if
             (setq ~i (+ ~i 1)) 
       );repeat
     
       (SETQ modgrp (SSGET "X" '((0 . "INSERT") (-3 ("MODFLAG")))))
       (if (/= nil modgrp)
           (progn
                (if (/= sca 1) (command "scale" modgrp "" insp (/ 1.0 sca)))                 
                (command "scale" modgrp "" insp ?scl?) 
           );progn
       );if


     );progn
   );if
 

   (if (= "1" allup)
     (progn
;        (command "dim" "up" "all" "" "exit" "regen")
        (princ (strcat "\n比例重新設定完成!!"))
        (command "zoom" "e")
     )
     (progn
        (command "zoom" "e")
       (princ "\n比例重新設定完成, 但尺寸尚未自動更新 !")
       (princ "\n您可以在 [標註:] 模式下, 以 \"UP\" 指令, 選擇要更新的尺寸 !!")
     );progn
   );if

;   (setq data1 (getatt (ssname sheetent 0) 2 "SCALE")

   (setq sheetatt (ssget "x" '((0 . "INSERT") (-3 ("SHEETFLAG")))))
   (if sheetatt
       (progn
            (setq data1 (getatt (ssname sheetatt 0) 2 &&scale_tag)
                  data1 (subst (cons 1 (strcat w1 ":" w2)) (assoc 1 data1) data1))
            (entmod data1)
            (setq ccd data1)
        );progn
   );if
   (command "regen")

   (setvar "cmdecho" 1)
   (princ)
)
(defun resetting_val2()
   (setvar "cmdecho" 0)
   (setvar "ltscale" ?scl?)
;;;(setvar "dimscale" ?scl?)
    (setvar "dimscale" (* base_dimscale ?scl?))
   (setvar "textsize" (* ?scl? 3))
   (command "regen")
   (setvar "cmdecho" 1)
   (princ)
)
(defun resetting_ok()
   (setq w1 (get_tile "out_mm")
         w2 (get_tile "out_unit")
         allup (get_tile "all"))
   (cond
    ((and (= "" w2)(= "" w1))(set_tile "error" "未輸入比例!"))
    ((= "" w1)(set_tile "error" "出圖公釐未輸入!"))
    ((= "" w2)(set_tile "error" "圖形單位未輸入!"))
    (t (setq ?scl? (/ (atof w2) (atof w1))
             resetting_fg t)
       (done_dialog))
   )
)

(defun resetting_scal_ok()
   (if (null id_value)
     (setq id_value "1:1"))
   (setq k_num (get_word id_value ":"))
   (setq w1 (substr id_value 1 (- k_num 1))
         w2 (substr id_value (+ k_num 1)))
)

(defun resetting_shscal_getdata(value)
   (setq nn (atoi value)
         id_value (nth nn scal_list))
   (resetting_scal_ok)
   (settile)

   (setq w1 (get_tile "out_mm")
         w2 (get_tile "out_unit"))

   (setq ?scl? (/ (atof w2) (atof w1)))
   (set_tile "error" (strcat "文字字高: " (rtos (* 3 ?scl?) 2 3) ", 線型比例: " (rtos ?scl? 2 3) ", 尺寸比例: " (rtos ?scl? 2 3)))
)

;;===============================================================================================
;╭═════════════════════════════════════╮
;║設計日期: 1998.11. 9    V1.0                                              ║
;║設 計 者: 陳冠達                                                          ║
;║功能說明: 選圖紙, 比例與屬性資料                                          ║
;║                                                                          ║
;║關聯檔案: shscal.dcl ,SH_TYPPE.SLD,A4HOR.DWG,A3HOR.DWG,A2HOR.DWG,A1HOR.DWG║
;║               A0HOR.DWGA,4VER.DWG,A3VER.DWG,A2VER.DWG,A1VER.DWG,A0VER.DWG║
;╰═════════════════════════════════════╯
;sys_sheet_layer 系統圖框層名稱
(defun c:autoshscal()

      (setvar "cmdecho" 0)
      (setq bordergrp (ssget "x" (list (cons 8 sys_sheet_layer) (cons 0 "INSERT"))))
      (if (/= nil bordergrp) (princ "\n圖面上已有圖框,不能執行此功能!")
        (progn
          (command "purge" "b" "*" "n")(setq aname "")
          (setq a1b (ssget "x" (list (cons 2 "A1")(cons 0 "INSERT"))))
          (if (/= a1b nil) (setq aname (strcat aname "A1")))

          (setq a2b (ssget "x" (list (cons 2 "A2")(cons 0 "INSERT"))))
          (if (and (/= "" aname)(/= a2b nil)) (setq aname (strcat aname ",A2")))
          (if (and (= "" aname)(/= a2b nil)) (setq aname (strcat aname "A2")))

          (setq a3b (ssget "x" (list (cons 2 "A3")(cons 0 "INSERT"))))
          (if (and (/= "" aname)(/= a3b nil)) (setq aname (strcat aname ",A3 ")))
          (if (and (= "" aname)(/= a3b nil)) (setq aname (strcat aname "A3 ")))

          (setq a4b (ssget "x" (list (cons 2 "A4")(cons 0 "INSERT"))))
          (if (and (/= "" aname)(/= a4b nil)) (setq aname (strcat aname ",A4 ")))
          (if (and (= "" aname)(/= a4b nil)) (setq aname (strcat aname "A4 ")))

          (if (or (/= nil a1b)(/= nil a2b)(/= nil a3b)(/= nil a4b))
            (princ (strcat "請注意:本圖內有命名為 "
                            aname
                            " 的 BLOCK 因此不能執行 [放圖框定比例] 功能,您必須先將 "
                            aname " BLOCK 刪除,炸開或改名!"))
            (progn
               
               (atoshscal 1)
              
               (change_bomball)
               (reset_block_scale)
               (rest_dimdtyle_dimscale)
            );progn
          );if
        );progn
      );if

      (setvar "cmdecho" 1)
    (princ)
)

;;;比例變動時重新設定各個 dimstyle 之 dimscale
(defun rest_dimdtyle_dimscale(/ celdimstyle dimstyle_data celdimscale dimstyle_list)
       (setvar "cmdecho" 0)
       (setq dimstyle_list '())
       (setq celdimstyle (getvar "dimstyle"))
       (setq celdimscale (getvar "dimscale"))
       (setq dimstyle_list(cons celdimstyle dimstyle_list))
       (setq dimstyle_data(tblnext "dimstyle" T))
       (while dimstyle_data
              (if (/= celdimstyle (cdr (assoc 2 dimstyle_data)))
                  (setq dimstyle_list(cons (cdr (assoc 2 dimstyle_data)) dimstyle_list))
              );if
              (setq dimstyle_data(tblnext "dimstyle"))
       )
       (setq dimstyle_list(reverse dimstyle_list))
       (if dimstyle_list
           (foreach XX dimstyle_list
                    (if (= XX celdimstyle)
                        (command "dimstyle" "s" celdimstyle "y")
                        (progn
                              (command "dimstyle" "r" XX)
                              (setvar "dimscale" celdimscale)
                              (command "dimstyle" "s" XX "y")
                        );progn
                    );if
           );foreach
       );if
       (command "dimstyle" "r" celdimstyle)
);defun



;;;比例變動時 block 重新設定比例
(defun reset_block_scale(/ i block_list blockgrp data10 data41)
       (setvar "cmdecho" 0)
       (setq os(getvar "osmode"))
       (setvar "osmode" 0)
       (setq block_list (read (getfile_val (strcat POWdesign_path "system.ini") "比例變動時會連動的BLOCK")))
       (foreach XX block_list
                (setq blockgrp (ssget "x" (list (cons 0 "INSERT") (cons 2 XX))))
                (setq i 0)
                (if blockgrp
                    (repeat (sslength blockgrp)
                            (setq data10 (cdr(assoc 10 (entget (ssname blockgrp i)))))
                            (setq data41 (cdr (assoc 41 (entget (ssname blockgrp i)))))
                            (if (/= (abs data41) 1.0) (command "scale" (ssname blockgrp i) "" "none" data10 (/ 1.0 (abs data41))))
                           ; (if (> data41 0)
                           ;     (command "scale" (ssname blockgrp i) "" "none" data10 (/ 1.0 data41))
                           ;     (command "scale" (ssname blockgrp i) "" "none" data10 (/ data41 1.0))
                           ; );if
                            (command "scale" (ssname blockgrp i) "" "none" data10 (getvar "dimscale"))
                            (setq i (+ i 1))
                    );repeat
                );if
       );foreach



       (setvar "osmode" os)
);defun

(defun change_bomball()
    (setq blk_scal (* (atof sys_ballpoint_size) (getvar "dimscale")))
    (setq bomgrp (ssget "x" (list (cons 0 "INSERT") (cons 2 "PARTREF"))))
    (if (/= nil bomgrp)
      (progn
        (setq os(getvar "osmode"))
        (setvar "osmode" 0)
        (setq count 0)
        (repeat (sslength bomgrp)
           (setq ent (ssname bomgrp count))
           (setq data10 (cdr (assoc 10 (entget ent))))
           (setq data41 (cdr (assoc 41 (entget ent))))
           (if (/= (abs data41) 1.0) (command "scale" ent "" "none" data10 (/ 1.0 (abs data41))))
        ;   (if (> data41 0)
        ;       (command "scale" ent "" data10 (/ 1.0 data41))
        ;       (command "scale" ent "" data10 (/ data41 1.0))
        ;   );if
           (command "scale" ent "" data10 blk_scal)
           (setq count (1+ count))
        );repeat
        (setvar "osmode" os)
      );progn
    );if
)


(defun te_err_pub(msg)
   (if (/= msg "Function cancelled")(princ (strcat "\nError: " msg)))
   (if oerr (setq *error* oerr))
      (progn
           (setvar "osmode" &oldos)
      )
   (princ)
)

;***區域變數檢查 OK !
;typ=0 用於 (c:change_sheet) , typ=1 用於 (c:autoshscal)
(defun ATOshscal(typ / sx sy stx sty check_p
                      lib1_list lib2_list lib3_list lib4_list lib5_list lib6_list lib7_list lib8_list lib9_list
                      lib10_list lib11_list lib12_list
                      lib1_id lib2_id lib3_id lib4_id lib5_id lib6_id lib7_id
                      lib8_id lib9_id lib10_id lib11_id lib12_id
                      get_cur_scal attlist check_p
                      sca1 sca2 scaletxt fact1 fact2 ?scl sdata attqty ssize
                      xval yval sx ssscal ddx stype stype_data sheetsize_list
                      attflg attdata_list count cc_list sheet_type sheet_typelist
                      data_list type_list ini_file stype_flag
                      )
;(defun ATOshscal(typ)
  ;; DraftSight: 移除加密狗 WHILE 迴圈

    (setvar "cmdecho" 0)
    (setq &oldos (getvar "osmode"))
    (setq oerr *error* *error* te_err_pub)

    (setq check_p nil)
    (command "select" "ALL" "")
    (comp_cur_limits)
    (actdcl "shscal" "autoshscal")
    (mode_tile "out_mm" 1)
    (mode_tile "out_unit" 1)

    (read_autoshscal_data)
    (act_pop_list sheet_type "type")
 ;  (set_tile "type" "0")


						   
   (if powerpdm_attribdata_path
       (progn
            (setq ini_file (strcat powerpdm_attribdata_path (curdwgname) ".txt"))    ;;POWERPDM 2001
            (if (findfile ini_file)                                                  ;;POWERPDM 2001
              (progn                                                                 ;;POWERPDM 2001
                (setq ff (open ini_file "r"))                                        ;;POWERPDM 2001
           ;    (setq ffdata (read-line ff))                          ;;圖檔屬性          ;;POWERPDM 2001
                (setq SHEET_TYPEdata (read-line ff))                  ;;那一類屬性圖框    POWERPDM 2001
                (if (null (list_id sheet_typedata sheet_type))
                    (progn (alert "圖框屬性無法對應 ! ")(setq sheet_typedata "0"))
                    (setq sheet_typedata (itoa (- (list_id sheet_typedata sheet_type) 1)))
                );if
                (close ff)                                                                ;;POWERPDM 2001
              )                                                                           ;;POWERPDM 2001
             ) 
                                                                                     ;;POWERPDM 2001
       );progn
   );if
    
    (reset_sheettype)
    (setq get_cur_scal (getvar "dimscale"))
    (if (/= typ 2)
        (shscal_show_data_on_dcl)
        (shscal_show_data_on_dcl_chsheet mod_sca)
    );if

    (action_tile "type" "(reset_sheettype)")
    (if (/= typ 2)
        (action_tile "size" "(cala_scale)(setq check_p t)")
        (action_tile "size" "(cala_scale_mod)(setq check_p t)")
    );if  
    (if (and (= typ 2) (/= nil &&sheet_id))
        (progn
             (set_tile "type" (rtos (- &&sheet_id 1) 2 0))
             (reset_sheettype)
        );progn
    );if
    (action_tile "setcal" "(setcal)")

    (action_tile "cancel" "(done_dialog)(setq check_p nil)(setq check_p2 t)")
    (action_tile "accept" "(autosetscal_ok)")
    (start_dialog)

    (if check_p
     (progn
       (cond
         ((= 2 typ)
           (setq attall_list (getent_allatt attent))
           (command "erase" bordergrp "")
           (auto_insert_attsheet)
         ; (setq attall_list (subst (list "SCALE" scaletxt) (assoc "SCALE" attall_list) attall_list))
           (setq attall_list (subst (list &&scale_tag scaletxt) (assoc &&scale_tag attall_list) attall_list))
               ;(input_pdm (entlast) attall_list)    ;pdm-cad.lsp 功能與(chg_sheetatt )一樣
               (chg_sheetatt (entlast) attall_list)
               (change_bomball)
               (reset_block_scale)
               (rest_dimdtyle_dimscale)
               (resetting_text)
         )
         ((and (= "1" instype) (/= "" (setq attlist (nth 4 sdata))))
          
          (input_attedata attlist)
            
         )
         (T (AUTO_insert_sheet))
       );cond
     );progn
    );if
    ;; removed FFF
    (setvar "osmode" &oldos)
    (setq instype nil sheet_typedata nil &&sheet_id nil)
    (princ)
)

(defun autosetscal_ok()
   (setq sca1 (get_tile "out_mm")
         sca2 (get_tile "out_unit"))
   (setq scaletxt  (strcat sca1 ":" sca2))
   (setq fact1 (atof sca1)
         fact2 (atof sca2)
         instype "1")
   (if check_p
     (progn
       (done_dialog)
     );progn
     (progn
       (set_tile "errtxt" "未選擇圖紙尺寸!")
     );progn
   )
    (cond
      ((< 1 (/ fact1 fact2)) (setq ?scl (/ fact2 fact1)))
      ((> 1 (/ fact1 fact2)) (setq ?scl fact2))
      (T (setq ?scl 1))
    )
    (setvar "ltscale" ?scl)
;;;;(setvar "dimscale" ?scl)
    (setvar "dimscale" (* base_dimscale ?scl))
    (setvar "textsize" (* ?scl 3))
)

(defun auto_insert_sheet(/ att_flag cl ccol cltype attdia_type vctr)
   (setq cl (getvar "clayer")
         ccol (getvar "cecolor")
         cltype (getvar "celtype")
         attdia_type (getvar "attdia")
         vctr (getvar "viewctr"))
   (setvar "attdia" 1)
   (command "layer" "m" sys_sheet_layer "c" sys_sheet_layercol "" "")
;  (command "layer" "m" sys_sheet_layer "c" sys_sheet_layercol "")

;  (if (= "1" instype)
;    (progn
        (if (= "GENIUS" acad_ver)
          (command ".insert" sfilename vctr ?scl "" "0")
          (command "insert" sfilename vctr ?scl "" "0")
        );if
;    );progn
;    (command "xref" "A" sfilename vctr ?scl "" "0")
;  )
   (command "zoom" "E")
   (setvar "attdia" attdia_type)
   (command "layer" "s" cl "")
   (command "color" ccol)
   (command "linetype" "s" cltype "")
   (princ "\n請調整圖框位置...")
   (command "move" (ssget "x" (list (cons 0 "INSERT")(cons 8 sys_sheet_layer))) "" vctr pause)
   (command "zoom" "e")
   (princ)
)

(defun chg_sheetatt(enttt data_list / ent newdata label data1)
   ;(setq ent (entlast))
   ;(setq abc attdata_list)
   (foreach nn data_list

       (setq newdata (getrealstr3 (nth 1 nn))
             label (nth 0 nn)
             data1 (getatt enttt 2 label)
             data1 (subst (cons 1 newdata) (assoc 1 data1) data1))
       (entmod data1)
   );foreach
   (command "regen")
)



(defun auto_insert_attsheet(/ att_flag vctr cl ccol cltype attdia_type)
   (setq cl (getvar "clayer")
         ccol (getvar "cecolor")
         cltype (getvar "celtype")
         attdia_type (getvar "attdia"))
   (setvar "attdia" 0)
   (command "layer" "m" sys_sheet_layer "c" sys_sheet_layercol "" "")
   (setq vctr (getvar "viewctr"))

   (setvar "osmode" 0)
   (if (= "GENIUS" acad_ver)
     (progn
      (command ".insert" sfilename vctr ?scl "" "0")
      (command ".insert" (strcat sfilename "atte") vctr ?scl "" "0")
     )
     (progn
      (command "insert" sfilename vctr ?scl "" "0")
      (command "insert" (strcat sfilename "tzt") vctr ?scl "" "0")
     )
   )

   (repeat attqty (command ""))
   (ad1xdata (entlast) "SHEETFLAG" (list "SHEETFLAG" (cons 1000 stype_flag)(cons 1000 size_flag)))
   (command "zoom" "E")
   (setvar "attdia" attdia_type)
   (command "layer" "s" cl "")
   (command "color" ccol)
   (command "linetype" "s" cltype "")
   (princ "\n請調整圖框位置...")
   (command "move" (ssget "x" (list (cons 0 "INSERT")(cons 8 sys_sheet_layer))) "" vctr pause)
   (command "zoom" "e")
   (if (= "1" instype) (chg_sheetatt (entlast) attdata_list))
   (princ)
)

(defun cala_scale_mod(/ sel_id)
         (setq sel_id (atoi (get_tile "size")))
    (setq sdata (nth sel_id (cdr stype_data))
          size_flag (nth 0 sdata)
          attqty (atoi (nth 5 sdata))
          sfilename (nth 2 sdata)
          sheetsize (nth 1 sdata)
          ssize (nth 3 sdata))
    (set_tile "ssize" (strcat "檔名:" sfilename ".DWG")) 
       (mode_tile "out_mm" 0)
       (mode_tile "out_unit" 0)
)
(defun cala_scale(/ sel_id)
    (setq sel_id (atoi (get_tile "size")))
    (setq sdata (nth sel_id (cdr stype_data))
          size_flag (nth 0 sdata)
          attqty (atoi (nth 5 sdata))
          sfilename (nth 2 sdata)
          sheetsize (nth 1 sdata)
          ssize (nth 3 sdata))
    (set_tile "ssize" (strcat "檔名:" sfilename ".DWG"))

    (setq xval (nth 0 ssize)
          yval (nth 1 ssize))

    (mode_tile "out_mm" 0)
    (mode_tile "out_unit" 0)
    (if (/= sx nil)
       (progn
          (setq aascal (/ sx xval))
          (cond
            ((> aascal 0.9)
               (set_tile "out_mm" "1")
               (setq ddx (+ 1 (fix aascal)))
               (set_tile "out_unit"  (rtos ddx 2 0))
            )
            ((< aascal 0.5)
               (set_tile "out_unit" "1")
               (setq ddx (- (fix (/ 1 aascal)) 1))
               (set_tile "out_mm"  (rtos ddx 2 0))
            )

            (T (set_tile "out_mm" "1")
               (set_tile "out_unit" "1")
            );T
          );cond
       );progn
       (progn
          (set_tile "out_mm" "1")
          (set_tile "out_unit" "1")
       );progn
    )
)

(defun reset_sheettype()
   (set_tile "size" "")
   (if (= nil SHEET_TYPEdata)
      (setq stype (get_tile "type"))
      (progn
         (setq stype SHEET_TYPEdata)  ;;POWERPDM 2001
       ; (set_tile "type" (rtos (- (atoi SHEET_TYPEdata) 1) 2 0))  ;;POWERPDM 2001
         (set_tile "type" SHEET_TYPEdata)  ;;POWERPDM 2001
         (mode_tile "type" 1)
      );progn
   );if
 ; (setq stype (get_tile "type"))

   (setq stype_flag (nth (atoi stype) sheet_type))
   (setq stype_data (assoc (nth (atoi stype) sheet_type) sheet_typelist))
   (setq sheetsize_list '())
   (foreach nn (cdr stype_data)
        (setq sheetsize_list (cons (nth 0 nn) sheetsize_list))
   )
   (setq sheetsize_list (reverse sheetsize_list))

   (act_pop_list sheetsize_list "size")
)


(defun input_attedata(defatt_list / attflg lib1_id lib2_id lib3_id lib4_id lib5_id lib6_id lib7_id lib8_id lib9_id
                                    lib10_id lib11_id lib12_id lib13_id lib14_id lib15_id lib16_id lib17_id lib18_id
                                     lib19_id lib20_id lib21_id lib22_id lib23_id lib24_id lib25_id lib26_id lib27_id
                                     lib28_id lib29_id lib30_id lib31_id lib32_id lib33_id lib34_id lib35_id lib36_id
		      		     lib37_id lib38_id)

    (defun reshow_liblist(/ newdatalist)
       (creat_wordlib_list)
       (setq cou 1)
;      (setq aaa data_list bbb type_list ccc attlist)
       (foreach nn attlist
         (progn
           (if (/= nil (setq newdatalist (assoc (nth 2 nn) data_list)))
             (progn
                 (setq checklib (nth 2 nn))
;                (if (= "" checklib) (princ "!")(princ checklib))
                 (cond
                   ((and (/= "" checklib)(= 1 cou)) (setq lib1_list (cdr newdatalist))(act_pop_list lib1_list "lib1"))
                   ((and (/= "" checklib)(= 2 cou)) (setq lib2_list (cdr newdatalist))(act_pop_list lib2_list "lib2"))
                   ((and (/= "" checklib)(= 3 cou)) (setq lib3_list (cdr newdatalist))(act_pop_list lib3_list "lib3"))
                   ((and (/= "" checklib)(= 4 cou)) (setq lib4_list (cdr newdatalist))(act_pop_list lib4_list "lib4"))
                   ((and (/= "" checklib)(= 5 cou)) (setq lib5_list (cdr newdatalist))(act_pop_list lib5_list "lib5"))
                   ((and (/= "" checklib)(= 6 cou)) (setq lib6_list (cdr newdatalist))(act_pop_list lib6_list "lib6"))
                   ((and (/= "" checklib)(= 7 cou)) (setq lib7_list (cdr newdatalist))(act_pop_list lib7_list "lib7"))
                   ((and (/= "" checklib)(= 8 cou)) (setq lib8_list (cdr newdatalist))(act_pop_list lib8_list "lib8"))
                   ((and (/= "" checklib)(= 9 cou)) (setq lib9_list (cdr newdatalist))(act_pop_list lib9_list "lib9"))

                   ((and (/= "" checklib)(= 10 cou)) (setq lib10_list (cdr newdatalist))(act_pop_list lib10_list "lib10"))
                   ((and (/= "" checklib)(= 11 cou)) (setq lib11_list (cdr newdatalist))(act_pop_list lib11_list "lib11"))
                   ((and (/= "" checklib)(= 12 cou)) (setq lib12_list (cdr newdatalist))(act_pop_list lib12_list "lib12"))
                   ((and (/= "" checklib)(= 13 cou)) (setq lib13_list (cdr newdatalist))(act_pop_list lib13_list "lib13"))
                   ((and (/= "" checklib)(= 14 cou)) (setq lib14_list (cdr newdatalist))(act_pop_list lib14_list "lib14"))
                   ((and (/= "" checklib)(= 15 cou)) (setq lib15_list (cdr newdatalist))(act_pop_list lib15_list "lib15"))
                   ((and (/= "" checklib)(= 16 cou)) (setq lib16_list (cdr newdatalist))(act_pop_list lib16_list "lib16"))
                   ((and (/= "" checklib)(= 17 cou)) (setq lib17_list (cdr newdatalist))(act_pop_list lib17_list "lib17"))
                   ((and (/= "" checklib)(= 18 cou)) (setq lib18_list (cdr newdatalist))(act_pop_list lib18_list "lib18"))
                   ((and (/= "" checklib)(= 19 cou)) (setq lib19_list (cdr newdatalist))(act_pop_list lib19_list "lib19"))

                   ((and (/= "" checklib)(= 20 cou)) (setq lib20_list (cdr newdatalist))(act_pop_list lib20_list "lib20"))
                   ((and (/= "" checklib)(= 21 cou)) (setq lib21_list (cdr newdatalist))(act_pop_list lib21_list "lib21"))
                   ((and (/= "" checklib)(= 22 cou)) (setq lib22_list (cdr newdatalist))(act_pop_list lib22_list "lib22"))
                   ((and (/= "" checklib)(= 23 cou)) (setq lib23_list (cdr newdatalist))(act_pop_list lib23_list "lib23"))
                   ((and (/= "" checklib)(= 24 cou)) (setq lib24_list (cdr newdatalist))(act_pop_list lib24_list "lib24"))
                   ((and (/= "" checklib)(= 25 cou)) (setq lib25_list (cdr newdatalist))(act_pop_list lib25_list "lib25"))
                   ((and (/= "" checklib)(= 26 cou)) (setq lib26_list (cdr newdatalist))(act_pop_list lib26_list "lib26"))
                   ((and (/= "" checklib)(= 27 cou)) (setq lib27_list (cdr newdatalist))(act_pop_list lib27_list "lib27"))
                   ((and (/= "" checklib)(= 28 cou)) (setq lib28_list (cdr newdatalist))(act_pop_list lib28_list "lib28"))
                   ((and (/= "" checklib)(= 29 cou)) (setq lib29_list (cdr newdatalist))(act_pop_list lib29_list "lib29"))

                   ((and (/= "" checklib)(= 30 cou)) (setq lib30_list (cdr newdatalist))(act_pop_list lib30_list "lib30"))
                   ((and (/= "" checklib)(= 31 cou)) (setq lib31_list (cdr newdatalist))(act_pop_list lib31_list "lib31"))
                   ((and (/= "" checklib)(= 32 cou)) (setq lib32_list (cdr newdatalist))(act_pop_list lib32_list "lib32"))
                   ((and (/= "" checklib)(= 33 cou)) (setq lib33_list (cdr newdatalist))(act_pop_list lib33_list "lib33"))
                   ((and (/= "" checklib)(= 34 cou)) (setq lib34_list (cdr newdatalist))(act_pop_list lib34_list "lib34"))
                   ((and (/= "" checklib)(= 35 cou)) (setq lib35_list (cdr newdatalist))(act_pop_list lib35_list "lib35"))
                   ((and (/= "" checklib)(= 36 cou)) (setq lib36_list (cdr newdatalist))(act_pop_list lib36_list "lib36"))
                   ((and (/= "" checklib)(= 37 cou)) (setq lib37_list (cdr newdatalist))(act_pop_list lib37_list "lib37"))
                   ((and (/= "" checklib)(= 38 cou)) (setq lib38_list (cdr newdatalist))(act_pop_list lib38_list "lib38"))
                 );cond
                 (setq cou (1+ cou))
             );progn
                 (setq cou (1+ cou))
           );if
         );progn
       );foreach
    );defun
;;;pdmbom=======================

    (if (null get_bomdata)(load "manapart"))
    (setq attbomp (ssget "x" (list (cons 2 "PARTREF") (cons 0 "INSERT"))))
    (if (null attbomp)
        (princ)
        (progn
             (if (= 1 (sslength attbomp))
                 (progn
                   (setq dlist (get_bomdata (ssname attbomp 0)))
                   (setq partdata (read (getfile_val (strcat POWdesign_path "system.ini") "零件定義資料")))
                   (setq qqq defatt_list aaalist '())
                   (foreach nn dlist
                     (progn
                        (setq count 0)
                        (while (setq dd (nth count partdata))
                          (if (and (/= "" (nth 1 dd))(/= "" (nth 1 nn))(= (nth 2 dd) (nth 0 nn))) (setq ddata (nth 1 nn) aaalist (cons (list (nth 1 dd) ddata) aaalist)))
                          (setq count (1+ count))
                        );while
                     );progn
                   );foreach
                 );progn
             );if
         );progn
     );if
;;;aaalist=(("DWGNAME" "前腳架") ("SURFACE" "噴漆") ("DRAWER" "陳冠達") ("QTY" "1") ("MATERIAL" "鋁"))
;   (foreach nn aaalist
;      (progn
;        (setq count 0 coun 1)
;        (while (setq ddd (nth count qqq))
;          (if (= (strcase (nth 0 nn)) (strcase (nth 0 ddd))) (set_tile (strcat "data" (rtos coun 2 0)) (nth 1 nn)))
;          (setq count (1+ count) coun (1+ coun))
;        );while
;      );progn
;   );foreach
;;;pdmbom=======================

    (if powerpdm_attribdata_path
        (progn
             (setq ini_file (strcat powerpdm_attribdata_path (curdwgname) ".txt"))
             (if (findfile ini_file)
                 (setq bol_attfile T)
                 (setq bol_attfile nil)
             );if
        );progn
        (setq bol_attfile nil)
    );if

    (if bol_attfile
       (progn
         (auto_insert_attsheet)
         (c:input_pdm_attdata)     ;;;PDM-CAD.LSP
         
       )
       (progn
          
          (actdcl "shscal" "sheetatt")
          (setq count 1)
          (if (null c:creatword)(load " wordlib1"))
          (action_tile "editlib" "(c:creatword)(reshow_liblist)")
          (setq aaa defatt_list)
          (setq ~data (getsys_date (atoi (getfile_val (strcat POWDESIGN_path "shscal.ini") "圖框日期型式"))))
          (foreach nn defatt_list
            (progn
              (set_tile (strcat "label" (rtos count 2 0)) (nth 1 nn))
              (setq code_id (nth 3 nn))
              
              (cond
                 ((null code_id) (princ))
                 ((= "S" (strcase code_id))
 (set_tile (strcat "data" (rtos count 2 0)) SCALETXT)(mode_tile (strcat "data" (rtos count 2 0)) 1))
                 ((= "T" (strcase code_id))
 (set_tile (strcat "data" (rtos count 2 0)) sheetsize)(mode_tile (strcat "data" (rtos count 2 0)) 1))
                 ((= "D" (strcase code_id)) 
 (set_tile (strcat "data" (rtos count 2 0)) ~data))
                       
                 ((= "F" (strcase code_id)) 
 (set_tile (strcat "data" (rtos count 2 0)) (curdwgname)))
              )
              (setq lib_id (nth 2 nn))
              (if (= "" lib_id)
                 (mode_tile (strcat "lib" (rtos count 2 0)) 1)
                 (progn
                    (mode_tile (strcat "lib" (rtos count 2 0)) 0)
                    (cond
                      ((= count 1) (setq lib1_id t))
                      ((= count 2) (setq lib2_id t))
                      ((= count 3) (setq lib3_id t))
                      ((= count 4) (setq lib4_id t))
                      ((= count 5) (setq lib5_id t))
                      ((= count 6) (setq lib6_id t))
                      ((= count 7) (setq lib7_id t))
                      ((= count 8) (setq lib8_id t))
                      ((= count 9) (setq lib9_id t))

                      ((= count 10) (setq lib10_id t))
                      ((= count 11) (setq lib11_id t))
                      ((= count 12) (setq lib12_id t))
                      ((= count 13) (setq lib13_id t))
                      ((= count 14) (setq lib14_id t))
                      ((= count 15) (setq lib15_id t))
                      ((= count 16) (setq lib16_id t))
                      ((= count 17) (setq lib17_id t))
                      ((= count 18) (setq lib18_id t))
                      ((= count 19) (setq lib19_id t))

                      ((= count 20) (setq lib20_id t))
                      ((= count 21) (setq lib21_id t))
                      ((= count 22) (setq lib22_id t))
                      ((= count 23) (setq lib23_id t))
                      ((= count 24) (setq lib24_id t))
                      ((= count 25) (setq lib25_id t))
                      ((= count 26) (setq lib26_id t))
                      ((= count 27) (setq lib27_id t))
                      ((= count 28) (setq lib28_id t))
                      ((= count 29) (setq lib29_id t))

                      ((= count 30) (setq lib30_id t))
                      ((= count 31) (setq lib31_id t))
                      ((= count 32) (setq lib32_id t))
                      ((= count 33) (setq lib33_id t))
                      ((= count 34) (setq lib34_id t))
		      ((= count 35) (setq lib35_id t))
		      ((= count 36) (setq lib36_id t))
		      ((= count 37) (setq lib37_id t))
		      ((= count 38) (setq lib38_id t))
                    );cond
                 );progn
              );if
              (setq count (1+ count))
            );progn
          )
          (if (and (/= nil attbomp) (= 1 (sslength attbomp)))
            (progn
              (foreach nn aaalist
                 (progn
                   (setq count 0 coun 1)
                   (while (setq ddd (nth count qqq))
                     (if (= (strcase (nth 0 nn)) (strcase (nth 0 ddd))) (set_tile (strcat "data" (rtos coun 2 0)) (nth 1 nn)))
                     (setq count (1+ count) coun (1+ coun))
                   );while
                 );progn
              );foreach
             );progn
          );if
          (repeat (- 39 count)
             (set_tile (strcat "data" (rtos count 2 0)) "")
             (mode_tile (strcat "data" (rtos count 2 0)) 1)
             (mode_tile (strcat "lib" (rtos count 2 0)) 1)
             (setq count (1+ count))
          )

          (if (= lib1_id t) (progn (setq libtype (nth 2 (nth 0 attlist))) (if (null word_data_path)(setq lib1_list (creatlib1_list libtype)) (setq lib1_list (creatlib1_list libtype))) (act_pop_list lib1_list "lib1")))
          (if (= lib2_id t) (progn (setq libtype (nth 2 (nth 1 attlist))) (if (null word_data_path)(setq lib2_list (creatlib1_list libtype)) (setq lib2_list (creatlib1_list libtype))) (act_pop_list lib2_list "lib2")))
          (if (= lib3_id t) (progn (setq libtype (nth 2 (nth 2 attlist))) (if (null word_data_path)(setq lib3_list (creatlib1_list libtype)) (setq lib3_list (creatlib1_list libtype))) (act_pop_list lib3_list "lib3")))
          (if (= lib4_id t) (progn (setq libtype (nth 2 (nth 3 attlist))) (if (null word_data_path)(setq lib4_list (creatlib1_list libtype)) (setq lib4_list (creatlib1_list libtype))) (act_pop_list lib4_list "lib4")))
          (if (= lib5_id t) (progn (setq libtype (nth 2 (nth 4 attlist))) (if (null word_data_path)(setq lib5_list (creatlib1_list libtype)) (setq lib5_list (creatlib1_list libtype))) (act_pop_list lib5_list "lib5")))
          (if (= lib6_id t) (progn (setq libtype (nth 2 (nth 5 attlist))) (if (null word_data_path)(setq lib6_list (creatlib1_list libtype)) (setq lib6_list (creatlib1_list libtype))) (act_pop_list lib6_list "lib6")))
          (if (= lib7_id t) (progn (setq libtype (nth 2 (nth 6 attlist))) (if (null word_data_path)(setq lib7_list (creatlib1_list libtype)) (setq lib7_list (creatlib1_list libtype))) (act_pop_list lib7_list "lib7")))
          (if (= lib8_id t) (progn (setq libtype (nth 2 (nth 7 attlist))) (if (null word_data_path)(setq lib8_list (creatlib1_list libtype)) (setq lib8_list (creatlib1_list libtype))) (act_pop_list lib8_list "lib8")))
          (if (= lib9_id t) (progn (setq libtype (nth 2 (nth 8 attlist))) (if (null word_data_path)(setq lib9_list (creatlib1_list libtype)) (setq lib9_list (creatlib1_list libtype))) (act_pop_list lib9_list "lib9")))

          (if (= lib10_id t) (progn (setq libtype (nth 2 (nth 9 attlist))) (if (null word_data_path)(setq lib10_list (creatlib1_list libtype)) (setq lib10_list (creatlib1_list libtype))) (act_pop_list lib10_list "lib10")))
          (if (= lib11_id t) (progn (setq libtype (nth 2 (nth 10 attlist)))(if (null word_data_path)(setq lib11_list (creatlib1_list libtype)) (setq lib11_list (creatlib1_list libtype)))  (act_pop_list lib11_list "lib11")))
          (if (= lib12_id t) (progn (setq libtype (nth 2 (nth 11 attlist)))(if (null word_data_path)(setq lib12_list (creatlib1_list libtype)) (setq lib12_list (creatlib1_list libtype)))  (act_pop_list lib12_list "lib12")))
          (if (= lib13_id t) (progn (setq libtype (nth 2 (nth 12 attlist)))(if (null word_data_path)(setq lib13_list (creatlib1_list libtype)) (setq lib13_list (creatlib1_list libtype)))  (act_pop_list lib13_list "lib13")))
          (if (= lib14_id t) (progn (setq libtype (nth 2 (nth 13 attlist)))(if (null word_data_path)(setq lib14_list (creatlib1_list libtype)) (setq lib14_list (creatlib1_list libtype)))  (act_pop_list lib14_list "lib14")))
          (if (= lib15_id t) (progn (setq libtype (nth 2 (nth 14 attlist)))(if (null word_data_path)(setq lib15_list (creatlib1_list libtype)) (setq lib15_list (creatlib1_list libtype)))  (act_pop_list lib15_list "lib15")))
          (if (= lib16_id t) (progn (setq libtype (nth 2 (nth 15 attlist)))(if (null word_data_path)(setq lib16_list (creatlib1_list libtype)) (setq lib16_list (creatlib1_list libtype)))  (act_pop_list lib16_list "lib16")))
          (if (= lib17_id t) (progn (setq libtype (nth 2 (nth 16 attlist)))(if (null word_data_path)(setq lib17_list (creatlib1_list libtype)) (setq lib17_list (creatlib1_list libtype)))  (act_pop_list lib17_list "lib17")))
          (if (= lib18_id t) (progn (setq libtype (nth 2 (nth 17 attlist)))(if (null word_data_path)(setq lib18_list (creatlib1_list libtype)) (setq lib18_list (creatlib1_list libtype)))  (act_pop_list lib18_list "lib18")))
          (if (= lib19_id t) (progn (setq libtype (nth 2 (nth 18 attlist)))(if (null word_data_path)(setq lib19_list (creatlib1_list libtype)) (setq lib19_list (creatlib1_list libtype)))  (act_pop_list lib19_list "lib19")))

          (if (= lib20_id t) (progn (setq libtype (nth 2 (nth 19 attlist)))(if (null word_data_path)(setq lib20_list (creatlib1_list libtype)) (setq lib20_list (creatlib1_list libtype)))  (act_pop_list lib20_list "lib20")))
          (if (= lib21_id t) (progn (setq libtype (nth 2 (nth 20 attlist)))(if (null word_data_path)(setq lib21_list (creatlib1_list libtype)) (setq lib21_list (creatlib1_list libtype)))  (act_pop_list lib21_list "lib21")))
          (if (= lib22_id t) (progn (setq libtype (nth 2 (nth 21 attlist)))(if (null word_data_path)(setq lib22_list (creatlib1_list libtype)) (setq lib22_list (creatlib1_list libtype)))  (act_pop_list lib22_list "lib22")))
          (if (= lib23_id t) (progn (setq libtype (nth 2 (nth 22 attlist)))(if (null word_data_path)(setq lib23_list (creatlib1_list libtype)) (setq lib23_list (creatlib1_list libtype)))  (act_pop_list lib23_list "lib23")))
          (if (= lib24_id t) (progn (setq libtype (nth 2 (nth 23 attlist)))(if (null word_data_path)(setq lib24_list (creatlib1_list libtype)) (setq lib24_list (creatlib1_list libtype)))  (act_pop_list lib24_list "lib24")))
          (if (= lib25_id t) (progn (setq libtype (nth 2 (nth 24 attlist)))(if (null word_data_path)(setq lib25_list (creatlib1_list libtype)) (setq lib25_list (creatlib1_list libtype)))  (act_pop_list lib25_list "lib25")))
          (if (= lib26_id t) (progn (setq libtype (nth 2 (nth 25 attlist)))(if (null word_data_path)(setq lib26_list (creatlib1_list libtype)) (setq lib26_list (creatlib1_list libtype)))  (act_pop_list lib26_list "lib26")))
          (if (= lib27_id t) (progn (setq libtype (nth 2 (nth 26 attlist)))(if (null word_data_path)(setq lib27_list (creatlib1_list libtype)) (setq lib27_list (creatlib1_list libtype)))  (act_pop_list lib27_list "lib27")))
          (if (= lib28_id t) (progn (setq libtype (nth 2 (nth 27 attlist)))(if (null word_data_path)(setq lib28_list (creatlib1_list libtype)) (setq lib28_list (creatlib1_list libtype)))  (act_pop_list lib28_list "lib28")))
          (if (= lib29_id t) (progn (setq libtype (nth 2 (nth 28 attlist)))(if (null word_data_path)(setq lib29_list (creatlib1_list libtype)) (setq lib29_list (creatlib1_list libtype)))  (act_pop_list lib29_list "lib29")))

          (if (= lib30_id t) (progn (setq libtype (nth 2 (nth 29 attlist)))(if (null word_data_path)(setq lib30_list (creatlib1_list libtype)) (setq lib30_list (creatlib1_list libtype)))  (act_pop_list lib30_list "lib30")))
          (if (= lib31_id t) (progn (setq libtype (nth 2 (nth 30 attlist)))(if (null word_data_path)(setq lib31_list (creatlib1_list libtype)) (setq lib31_list (creatlib1_list libtype)))  (act_pop_list lib31_list "lib31")))
          (if (= lib32_id t) (progn (setq libtype (nth 2 (nth 31 attlist)))(if (null word_data_path)(setq lib32_list (creatlib1_list libtype)) (setq lib32_list (creatlib1_list libtype)))  (act_pop_list lib32_list "lib32")))
          (if (= lib33_id t) (progn (setq libtype (nth 2 (nth 32 attlist)))(if (null word_data_path)(setq lib33_list (creatlib1_list libtype)) (setq lib33_list (creatlib1_list libtype)))  (act_pop_list lib33_list "lib33")))
          (if (= lib34_id t) (progn (setq libtype (nth 2 (nth 33 attlist)))(if (null word_data_path)(setq lib34_list (creatlib1_list libtype)) (setq lib34_list (creatlib1_list libtype)))  (act_pop_list lib34_list "lib34")))
          (if (= lib35_id t) (progn (setq libtype (nth 2 (nth 34 attlist)))(if (null word_data_path)(setq lib35_list (creatlib1_list libtype)) (setq lib35_list (creatlib1_list libtype)))  (act_pop_list lib35_list "lib35")))
          (if (= lib36_id t) (progn (setq libtype (nth 2 (nth 35 attlist)))(if (null word_data_path)(setq lib36_list (creatlib1_list libtype)) (setq lib36_list (creatlib1_list libtype)))  (act_pop_list lib36_list "lib36")))
          (if (= lib37_id t) (progn (setq libtype (nth 2 (nth 36 attlist)))(if (null word_data_path)(setq lib37_list (creatlib1_list libtype)) (setq lib37_list (creatlib1_list libtype)))  (act_pop_list lib37_list "lib37")))
          (if (= lib38_id t) (progn (setq libtype (nth 2 (nth 37 attlist)))(if (null word_data_path)(setq lib38_list (creatlib1_list libtype)) (setq lib38_list (creatlib1_list libtype)))  (act_pop_list lib38_list "lib38")))

          (action_tile "lib1"   "(getlib_setval \"lib1\" lib1_list \"data1\")")
          (action_tile "lib2"   "(getlib_setval \"lib2\" lib2_list \"data2\")")
          (action_tile "lib3"   "(getlib_setval \"lib3\" lib3_list \"data3\")")
          (action_tile "lib4"   "(getlib_setval \"lib4\" lib4_list \"data4\")")
          (action_tile "lib5"   "(getlib_setval \"lib5\" lib5_list \"data5\")")
          (action_tile "lib6"   "(getlib_setval \"lib6\" lib6_list \"data6\")")
          (action_tile "lib7"   "(getlib_setval \"lib7\" lib7_list \"data7\")")
          (action_tile "lib8"   "(getlib_setval \"lib8\" lib8_list \"data8\")")
          (action_tile "lib9"   "(getlib_setval \"lib9\" lib9_list \"data9\")")

          (action_tile "lib10"  "(getlib_setval \"lib10\" lib10_list \"data10\")")
          (action_tile "lib11"  "(getlib_setval \"lib11\" lib11_list \"data11\")")
          (action_tile "lib12"  "(getlib_setval \"lib12\" lib12_list \"data12\")")
          (action_tile "lib13"  "(getlib_setval \"lib13\" lib13_list \"data13\")")
          (action_tile "lib14"  "(getlib_setval \"lib14\" lib14_list \"data14\")")
          (action_tile "lib15"  "(getlib_setval \"lib15\" lib15_list \"data15\")")
          (action_tile "lib16"  "(getlib_setval \"lib16\" lib16_list \"data16\")")
          (action_tile "lib17"  "(getlib_setval \"lib17\" lib17_list \"data17\")")
          (action_tile "lib18"  "(getlib_setval \"lib18\" lib18_list \"data18\")")
          (action_tile "lib19"  "(getlib_setval \"lib19\" lib19_list \"data19\")")

          (action_tile "lib20"  "(getlib_setval \"lib20\" lib20_list \"data20\")")
          (action_tile "lib21"  "(getlib_setval \"lib21\" lib21_list \"data21\")")
          (action_tile "lib22"  "(getlib_setval \"lib22\" lib22_list \"data22\")")
          (action_tile "lib23"  "(getlib_setval \"lib23\" lib23_list \"data23\")")
          (action_tile "lib24"  "(getlib_setval \"lib24\" lib24_list \"data24\")")
          (action_tile "lib25"  "(getlib_setval \"lib25\" lib25_list \"data25\")")
          (action_tile "lib26"  "(getlib_setval \"lib26\" lib26_list \"data26\")")
          (action_tile "lib27"  "(getlib_setval \"lib27\" lib27_list \"data27\")")
          (action_tile "lib28"  "(getlib_setval \"lib28\" lib28_list \"data28\")")
          (action_tile "lib29"  "(getlib_setval \"lib29\" lib29_list \"data29\")")

          (action_tile "lib30"  "(getlib_setval \"lib30\" lib30_list \"data30\")")
          (action_tile "lib31"  "(getlib_setval \"lib31\" lib31_list \"data31\")")
          (action_tile "lib32"  "(getlib_setval \"lib32\" lib32_list \"data32\")")
          (action_tile "lib33"  "(getlib_setval \"lib33\" lib33_list \"data33\")")
          (action_tile "lib34"  "(getlib_setval \"lib34\" lib34_list \"data34\")")
          (action_tile "lib35"  "(getlib_setval \"lib35\" lib35_list \"data35\")")
          (action_tile "lib36"  "(getlib_setval \"lib36\" lib36_list \"data36\")")
          (action_tile "lib37"  "(getlib_setval \"lib37\" lib37_list \"data37\")")
          (action_tile "lib38"  "(getlib_setval \"lib38\" lib38_list \"data38\")")


          (action_tile "cancel" "(done_dialog)(setq check_p nil)(setq check_p2 t)")
          (action_tile "accept" "(input_attedata_ok)")
          (start_dialog)
          (if attflg
             (auto_insert_attsheet)
          )
       );progn
    );if
    (princ)
)

(defun read_edmssystem()
   (setq ini_file (strcat powerpdm_attribdata_path (curdwgname) ".txt"))    ;;POWERPDM 2001

   (if (findfile ini_file)
       (progn
            (setq ff (open ini_file "r"))
            (setq ffdata (read-line ff))                          ;;圖檔屬性
            (setq SHEET_TYPEdata (read-line ff))                  ;;那一類屬性圖框    POWERPDM 2001
            (close ff)
            (setq countt 1 txtcount 1)
            (if (/= nil ffdata)
                (progn
                     (foreach nn edms_sheetatt
                       (progn
                         (setq attdata (substr ffdata txtcount (atoi (nth 1 nn))))
                         (if (/= "" attdata) (set_tile (strcat "data" (rtos countt 2 0)) attdata))
                         (setq txtcount (+ txtcount (atoi (nth 1 nn))) countt (1+ countt))
                       );progn
                     );foreach
                     (setq ff (open (strcat POWDESIGN_path "delfile.scr") "w"))
                     (write-line (strcat "shell del " ini_file) ff)
                     (close ff)
                     (setq aacount 1)

                      (setq ~data (getsys_date (atoi (getfile_val (strcat POWDESIGN_path "shscal.ini") "圖框日期型式"))))

                     (foreach nn defatt_list
                       (progn
                         (setq code_id (nth 3 nn))
                         (cond
                            ((null code_id) (princ))
                            ((= "S" (strcase code_id)) (set_tile (strcat "data" (rtos aacount 2 0)) SCALETXT)(mode_tile (strcat "data" (rtos aacount 2 0)) 1))
                            ((= "T" (strcase code_id)) (set_tile (strcat "data" (rtos aacount 2 0)) sheetsize)(mode_tile (strcat "data" (rtos aacount 2 0)) 1))
                            ((= "D" (strcase code_id)) (set_tile (strcat "data" (rtos aacount 2 0)) ~data))
                                ;(getsys_date (atoi (getfile_val (strcat POWDESIGN_path "shscal.ini") "圖框日期型式")))))
                            ((= "F" (strcase code_id)) (set_tile (strcat "data" (rtos aacount 2 0)) (curdwgname)))
                         )
                         (setq aacount (1+ aacount))
                       );progn
                     );foreach
                );progn
            );if
       );progn
       (princ)
   );if
)


(defun input_attedata_ok()
  (setq attflg t)
  (setq attdata_list '() count 1)
  (foreach nn attlist
    (progn
       (setq attdata_list (cons (list (nth 0 nn) (get_tile (strcat "data" (rtos count 2 0)))) attdata_list))
       (setq count (1+ count))
    );progn
  );foreach
; (princ ?scl)
  (done_dialog)
)

(defun getlib_setval(typ1 typ2 typ3 / iid data)
   (setq iid (get_tile typ1))
   (setq data (nth (atoi iid) typ2))
   (set_tile typ3 data)
)

;;此副程式用於辭庫為 DBF 格式
;(defun creatlib_list(obj / stm data)
;   (setq stm (strcat "select DATA from powbase.database.wordlib where TYPE ='" obj "'"))
;    (setq cc_list '())     ;only one data
;    (if (prepare-stm stm)
;      (progn
;        (setq data (open-csr))
;        (while data
;          (setq data (nth 0 data))
;          (setq cc_list (cons (getrealstr data) cc_list))
;          (setq data (fetch-csr "next"))
;        )(close-stm)
;      );progn
;      (setq cc_list nil)
;   );if
;   (if cc_list (setq cc_list (reverse cc_list)))
;   cc_list
;)

;;此副程式用於辭庫為 ASCII格式
(defun creatlib1_list(obj / data_list type_list)

   (cond ((null creat_wordlib_list)(load "wordlib1"))(t (creat_wordlib_list)))
   (if (null (assoc obj data_list))
      (setq cc_list '(""))
      (setq cc_list (cdr (assoc obj data_list)))
   )
;  (setq stm (strcat "select DATA from powbase.database.wordlib where TYPE ='" obj "'"))
;   (setq cc_list '())     ;only one data
;   (if (prepare-stm stm)
;     (progn
;       (setq data (open-csr))
;       (while data
;         (setq data (nth 0 data))
;         (setq cc_list (cons (getrealstr data) cc_list))
;         (setq data (fetch-csr "next"))
;       )(close-stm)
;     );progn
;     (setq cc_list nil)
;  );if
;  (if cc_list (setq cc_list (reverse cc_list)))
   cc_list
)



(defun powerpdm_sheet_att_def(sh_typedata / data opf atttxt_id atttxt otxt numtxt_id numtxt newlist pdm_sheetatt)
  (cond                                                                                       ;;POWERPDM 2001
    ((= sh_typedata "1") (setq opf (open (strcat POWERPDM_CAD_PATH "atttemp0.txt") "r")))     ;;POWERPDM 2001
    ((= sh_typedata "1") (setq opf (open (strcat POWERPDM_CAD_PATH "atttemp1.txt") "r")))     ;;POWERPDM 2001
    ((= sh_typedata "2") (setq opf (open (strcat POWERPDM_CAD_PATH "atttemp2.txt") "r")))     ;;POWERPDM 2001
    ((= sh_typedata "3") (setq opf (open (strcat POWERPDM_CAD_PATH "atttemp3.txt") "r")))     ;;POWERPDM 2001
    ((= sh_typedata "4") (setq opf (open (strcat POWERPDM_CAD_PATH "atttemp4.txt") "r")))     ;;POWERPDM 2001
    ((= sh_typedata "5") (setq opf (open (strcat POWERPDM_CAD_PATH "atttemp5.txt") "r")))     ;;POWERPDM 2001
  );cond                                                                                      ;;POWERPDM 2001
  (setq data (read-line opf) pdm_sheetatt '())                                                ;;POWERPDM 2001
                                                                                              ;;POWERPDM 2001
;CADNO       C020000                                                                          ;;POWERPDM 2001
;CADNO       C020000                                                                          ;;POWERPDM 2001
;DWGNO       C020000                                                                          ;;POWERPDM 2001
;DWGNAME     C020000                                                                          ;;POWERPDM 2001
                                                                                              ;;POWERPDM 2001
  (while data                                                                                 ;;POWERPDM 2001
     (setq atttxt_id (get_word data " "))                                                     ;;POWERPDM 2001
     (setq atttxt (substr data 1 (- atttxt_id 1)))                                            ;;POWERPDM 2001
     (setq otxt (substr data 7))                                                              ;;POWERPDM 2001
     (setq numtxt_id (get_word otxt "C"))                                                     ;;POWERPDM 2001
     (setq numtxt (substr otxt numtxt_id))    ;"C020000"                                      ;;POWERPDM 2001
     (setq numtxt (substr numtxt 2))          ;"020000"                                       ;;POWERPDM 2001
     (setq numtxt (substr numtxt 1 3))        ;"020"                                          ;;POWERPDM 2001
     (setq numtxt (rtos (atoi numtxt) 2 0))          ;"20"                                    ;;POWERPDM 2001
     (setq newlist (list atttxt numtxt))                                                      ;;POWERPDM 2001
     (setq pdm_sheetatt (cons newlist pdm_sheetatt))                                          ;;POWERPDM 2001
     (setq data (read-line opf))                                                              ;;POWERPDM 2001
  );while                                                                                     ;;POWERPDM 2001
  (close opf)                                                                                 ;;POWERPDM 2001
  (reverse pdm_sheetatt)                                                                      ;;POWERPDM 2001
; pdm_sheetatt (("CADNO" "8")("DWGNO" "12")("DWGNAME" "36")("TYPE" "12")("DRAWER" "8")("DATE1" "8")("SCALE" "6")("DATE2" "8")("MATERIAL" "12")("QTY" "4")("DATE_C" "8")("DRAWING_C" "8")("DWGNO_C" "8"))
)                                                                                             ;;POWERPDM 2001


(defun read_autoshscal_data(/ ff data fg rdlist ddata)
   (setq ff (open (strcat POWDESIGN_path "shscal.ini") "r"))
   (setq sheet_type '())
   (if ff
     (progn
       (setq data (read-line ff))
       (while data
         (setq fg (substr data 1 2))
         (cond
           ((= fg ">>")(princ))
       ;   ((= fg "$$")(setq edms_sheetatt (read (substr data (1+ (get_word data "="))))))
           ((= fg "**") (setq sheet_type (cons (substr data 3) sheet_type)))
         )
         (setq data (read-line ff))
       );while
     );progn
   );if
   (close ff)

;   (if (/= sheet_typedata nil) (setq edms_sheetatt (powerpdm_sheet_att_def sheet_typedata)))  ;POWERPDM 2001

   (setq sheet_type (reverse sheet_type))

   (setq sheet_typelist '() rdlist '())
   (foreach nn sheet_type
     (progn
        (setq ff (open (strcat POWDESIGN_path "shscal.ini") "r"))
        (setq data (read-line ff))
        (while data
           (setq fg (substr data 3))
           (if (= nn fg)
             (progn
               (setq rdlist (cons nn rdlist))
               (setq ddata (read-line ff))
               (while (and (/= nil ddata) (/= "**" (substr ddata 1 2)))
                  (setq rdlist (cons (read ddata) rdlist))
                  (setq ddata (read-line ff))
               );while
               (close ff)
               (setq data nil)
             );progn
             (setq data (read-line ff))
           );if
        );while
        (setq sheet_typelist (cons (reverse (cdr rdlist)) sheet_typelist))
        (setq rdlist '())
     );progn
   );foreach
   (setq sheet_typelist (reverse sheet_typelist))
)

;;;============================================================================================
;╭═════════════════════════════════════╮
;║設計日期: 1998.11. 9    V1.0                                              ║
;║設 計 者: 陳冠達                                                          ║
;║功能說明: 變更圖紙                                                        ║
;║關聯檔案: shscal.dcl ,SH_TYPPE.SLD,A4HOR.DWG,A3HOR.DWG,A2HOR.DWG,A1HOR.DWG║
;║               A0HOR.DWGA,4VER.DWG,A3VER.DWG,A2VER.DWG,A1VER.DWG,A0VER.DWG║
;╰═════════════════════════════════════╯
;;***區域變數檢查 OK !
(defun c:change_sheet(/ sx sy stx sty check_p
                      lib1_list lib2_list lib3_list lib4_list lib5_list lib6_list lib7_list lib8_list lib9_list
                      lib10_list lib11_list lib12_list
                      lib1_id lib2_id lib3_id lib4_id lib5_id lib6_id lib7_id
                      lib8_id lib9_id lib10_id lib11_id lib12_id
                      get_cur_scal attlist check_p
                      sca1 sca2 scaletxt fact1 fact2 ?scl sdata attqty sfilename ssize
                      xval yval sx ssscal ddx stype stype_data sheetsize_list
                      attflg attdata_list count cc_list sheet_type sheet_typelist
;                     instype
                      )
    (setvar "cmdecho" 0)

    (setq bordergrp (ssget "x" (list (cons 8 sys_sheet_layer) (cons 0 "INSERT"))))
    (if (= nil bordergrp) (princ "\n圖面上沒有圖框,不能執行此功能!")
       (progn
          (command "attext" "sdf" (strcat powdesign_path "DBF.TXT")  "")
          (SETQ modgrp (SSGET "X" '((0 . "INSERT") (-3 ("MODFLAG")))))
          (if (/= nil modgrp)
              (progn
                    (command "erase" bordergrp "r" modgrp "")
              );progn
              (command "erase" bordergrp "")
          );if
          (atoshscal 0)
          (if (/= nil modgrp)
              (progn
                   (setq mod_sca (cdr (assoc 41 (entget (ssname modgrp 0)))))     
                   (setq mod_insp (cdr (assoc 10 (entget (ssname modgrp (- (sslength modgrp) 1))))))
                   (if (/= mod_sca 1) (command "scale" modgrp "" mod_insp (/ 1.0 mod_sca)))
                   (command "move" modgrp "" mod_insp (getpoint "\n設變欄位新基準點")) 
                   
              );progn
          );if
           
       )
    )
    (if (/= nil check_p2) (progn (command "oops")(setq check_p2 nil)))
    (princ)
)

(defun c:change_xref(/ objent objdata data2 data8 data0)
   (setq objent (entsel "\n選取要併入的外部參考(XREF)圖框: "))
   (while (null objent)
      (princ "\n沒有選到請再選一次..")
      (setq objent (entsel "\n選取要併入的外部參考(XREF)圖框: "))
   )
   (setq objdata (entget (car objent)))
   (setq data2 (cdr (assoc 2 objdata)))
   (setq data8 (cdr (assoc 8 objdata)))
   (setq data0 (cdr (assoc 0 objdata)))
   (if (and (= sys_sheet_layer data8) (= "INSERT" data0))
     (progn
        (command "xref" "b" data2)
        (princ "\n外部參考(XREF)的圖框已併入本圖!!")
     )
     (princ "\n您選的圖元不是圖框!!")
   )
   (princ)
)

;;;圖框屬性修改義
;(defun c:chSHEET_ATT(/ ff data txt_id)
;         (setq ff (open (strcat POWDESIGN_path "shscal.ini") "r"))
;         (setq sheet_list '())
;         (setq data (read-line ff))
;         (while data
;            (setq txt_id (substr data 1 1))
;            (if (= "(" (setq txt_id (substr data 1 1)))
;              (progn
;                (setq data (nth 2 (read data)))
;                (while (setq fg (get_word data "\\"))
;                   (setq data (substr data (1+ fg)))
;                )
;                (setq sheet_list (cons data sheet_list))
;              );progn
;            )
;            (setq data (read-line ff))
;         );while
;         (close ff)
;         (setq sheet_list (int_list_sort 0 sheet_list))
;         (foreach nn sheet_list
;           (progn
;              (if (/= nil (setq blk (ssget "x" (list (cons 2 (strcat nn "TZT"))))))
;         ;       (princ (strcat nn "TZT"))
;                 (princ)
;              );if
;           );progn
;         );foreach
;         (if (null blk)
;           (princ "\n圖面上沒有圖框屬性!")
;           (progn
;              (setq blk (getxdata (ssname blk 0) "SHEETFLAG"))
;              (setq data-3 (assoc -3 blk))
;              (if data-3
;                (progn
;                   (reread_blkatt blk)
;                   (setq shtype (cdr (nth 1 (nth 1 data-3))))
;                   (setq sztype (cdr (nth 2 (nth 1 data-3))))
;                   (read_autoshscal_data)
;                   (setq shdata (assoc shtype sheet_typelist))
;                   (setq szdata (assoc sztype (cdr shdata)))
;                   (setq attlist (nth 4 szdata))
;                   (reread_attedata attlist)
;                );progn
;                (progn
;                   (setvar "attdia" 1)
;                   (command "ddatte" (cdr (assoc -2 blk)))
;                );progn
;              )
;             (princ)
;           );progn
;         );if
;    (princ)
;)
(defun c:chSHEET_ATT(/ ff data txt_id bordergrp count bk blk)
         (setq bordergrp (ssget "x" (list (cons 8 sys_sheet_layer) (cons 0 "INSERT"))))
         (if (null bordergrp) (princ "\n圖框屬性不存在!")
            (progn
               (setq count 0)
               (repeat (sslength bordergrp)
                 (progn
                    (setq bk (getxdata (ssname bordergrp count) "SHEETFLAG"))
                    (if (/= nil bk) (setq blk (ssname bordergrp count) attsheet_name blk))
                    (setq count (1+ count))
                 );progn
               );repeat
            );progn
         );if
         (if (null blk)
           (princ "\n圖框屬性不存在!")
           (progn
              (setq blk (getxdata blk "SHEETFLAG"))
              (setq data-3 (assoc -3 blk))
              (if data-3
                (progn
                   (setq shtype (cdr (nth 1 (nth 1 data-3))))
                   (setq sztype (cdr (nth 2 (nth 1 data-3))))
                   (setq ccc (cdr (nth 1 (nth 1 data-3))))
                   (setq ddd (cdr (nth 2 (nth 1 data-3))))
                   (read_autoshscal_data)
                   (setq shdata (assoc shtype sheet_typelist))
                   (setq szdata (assoc sztype (cdr shdata)))
                   (setq attlist (nth 4 szdata))
                   (reread_blkatt blk)
                   (reread_attedata attlist)
                );progn
                (progn
                   (setvar "attdia" 1)
                   (command "ddatte" (cdr (assoc -2 blk)))
                );progn
              )
             (princ)
           );progn
         );if
    (princ)
)
;;|(defun reread_blkatt(bk)
;    (setq blk_attlist '())
;    (setq ent (cdr (assoc -1 bk)))
;    (setq entname (entnext ent))
;    (setq aaaa attlist)
;    (repeat (length attlist)
;      (setq tdata (entget entname))
;      (setq data2 (cdr (assoc 2 (entget entname)))
;            data1 (cdr (assoc 1 (entget entname))))
;      (setq blk_attlist (cons (list data2 data1) blk_attlist))
;      (setq entname (entnext entname))
;    );repeat
;    (setq blk_attlist (reverse blk_attlist))
;    (setq oldattlist blk_attlist)
;)|;
;;2003.09.16 SAM 重寫 (reread_blkatt)
(defun reread_blkatt(bk)
        (setq blk_attlist '())
        (setq ent (cdr (assoc -1 bk)))
        (setq entname (entnext ent))
        (while entname
                (setq str_etype (cdr (assoc 0 (entget entname))))
                (cond ((= "ATTRIB" str_etype)
                       (setq data2 (cdr (assoc 2 (entget entname))))
                       (setq data1 (cdr (assoc 1 (entget entname))))
                       (setq blk_attlist (cons (list data2 data1) blk_attlist))
                       (setq entname (entnext entname)))
                      ((= "SEQEND" str_etype)(setq entname nil))
                      (t (setq entname (entnext entname)))
        ))
        (setq blk_attlist (reverse blk_attlist))
        (setq oldattlist blk_attlist)
)
  
;defun reread_blkatt(bk)
;   (setq blk_attlist '())
;   (princ "11")
;   (setq ent (cdr (assoc -1 bk)))
;   (princ "22")
;   (setq entname (entnext ent))
;   (princ "33")
;   (repeat 6
;   (princ "ab")
;     (princ entname)
;   (princ "cd")
;     (setq entname (entnext entname))
;   (princ "ef")
;   );repeat
;   (setq blk_attlist (reverse blk_attlist))
;   (setq oldattlist blk_attlist)
;

(defun reread_attedata(defatt_list / attflg lib1_id lib2_id lib3_id lib4_id lib5_id lib6_id
                                    lib7_id lib8_id lib9_id lib10_id lib11_id lib12_id
                                    lib13_id lib14_id lib15_id lib16_id lib17_id)
    (actdcl "shscal" "sheetatt")
    (setq count 1)
    (if (null c:creatword)(load "wordlib1"))
    (action_tile "editlib" "(c:creatword)(reshow_liblist)")

    (foreach nn defatt_list
      (progn
        (set_tile (strcat "label" (rtos count 2 0)) (nth 1 nn))
        (setq code_id (nth 3 nn))
        (cond
           ((null code_id) (princ))
           ((= "S" (strcase code_id)) (mode_tile (strcat "data" (rtos count 2 0)) 1))
           ((= "T" (strcase code_id)) (mode_tile (strcat "data" (rtos count 2 0)) 1))
                ((= "D" (strcase code_id)) (set_tile (strcat "data" (rtos count 2 0))
                       (getsys_date (atoi (getfile_val (strcat POWDESIGN_path "shscal.ini") "圖框日期型式")))))
                 ((= "F" (strcase code_id)) (set_tile (strcat "data" (rtos count 2 0)) (curdwgname)))
 
       ;   ((= "D" (strcase code_id)) (set_tile (strcat "data" (rtos count 2 0)) (getsys_date 2)))
       ;   ((= "F" (strcase code_id)) (set_tile (strcat "data" (rtos count 2 0)) (curdwgname)))
        )
        (setq lib_id (nth 2 nn))
        (if (= "" lib_id)
           (mode_tile (strcat "lib" (rtos count 2 0)) 1)
           (progn
              (mode_tile (strcat "lib" (rtos count 2 0)) 0)
              (cond
                ((= count 1) (setq lib1_id t))
                ((= count 2) (setq lib2_id t))
                ((= count 3) (setq lib3_id t))
                ((= count 4) (setq lib4_id t))
                ((= count 5) (setq lib5_id t))
                ((= count 6) (setq lib6_id t))
                ((= count 7) (setq lib7_id t))
                ((= count 8) (setq lib8_id t))
                ((= count 9) (setq lib9_id t))

                ((= count 10) (setq lib10_id t))
                ((= count 11) (setq lib11_id t))
                ((= count 12) (setq lib12_id t))
                ((= count 13) (setq lib13_id t))
                ((= count 14) (setq lib14_id t))
                ((= count 15) (setq lib15_id t))
                ((= count 16) (setq lib16_id t))
                ((= count 17) (setq lib17_id t))
                ((= count 18) (setq lib18_id t))
                ((= count 19) (setq lib19_id t))

                ((= count 20) (setq lib20_id t))
                ((= count 21) (setq lib21_id t))
                ((= count 22) (setq lib22_id t))
                ((= count 23) (setq lib23_id t))
                ((= count 24) (setq lib24_id t))
                ((= count 25) (setq lib25_id t))
                ((= count 26) (setq lib26_id t))
                ((= count 27) (setq lib27_id t))
                ((= count 28) (setq lib28_id t))
                ((= count 29) (setq lib29_id t))

                ((= count 30) (setq lib30_id t))
                ((= count 31) (setq lib31_id t))
                ((= count 32) (setq lib32_id t))
                ((= count 33) (setq lib33_id t))
                ((= count 34) (setq lib34_id t))
                ((= count 35) (setq lib35_id t))
                ((= count 36) (setq lib36_id t))
                ((= count 37) (setq lib37_id t))
                ((= count 38) (setq lib38_id t))
              );cond
           );progn
        );if
        (setq count (1+ count))
      );progn
    )
    (repeat (- 39 count)
       (set_tile (strcat "data" (rtos count 2 0)) "")
       (mode_tile (strcat "data" (rtos count 2 0)) 1)
       (mode_tile (strcat "lib" (rtos count 2 0)) 1)
       (setq count (1+ count))
    )

    (if (= lib1_id t) (progn (setq libtype (nth 2 (nth 0 attlist))) (if (null word_data_path)(setq lib1_list (creatlib1_list libtype)) (setq lib1_list (creatlib1_list libtype))) (act_pop_list lib1_list "lib1")))
    (if (= lib2_id t) (progn (setq libtype (nth 2 (nth 1 attlist))) (if (null word_data_path)(setq lib2_list (creatlib1_list libtype)) (setq lib2_list (creatlib1_list libtype))) (act_pop_list lib2_list "lib2")))
    (if (= lib3_id t) (progn (setq libtype (nth 2 (nth 2 attlist))) (if (null word_data_path)(setq lib3_list (creatlib1_list libtype)) (setq lib3_list (creatlib1_list libtype))) (act_pop_list lib3_list "lib3")))
    (if (= lib4_id t) (progn (setq libtype (nth 2 (nth 3 attlist))) (if (null word_data_path)(setq lib4_list (creatlib1_list libtype)) (setq lib4_list (creatlib1_list libtype))) (act_pop_list lib4_list "lib4")))
    (if (= lib5_id t) (progn (setq libtype (nth 2 (nth 4 attlist))) (if (null word_data_path)(setq lib5_list (creatlib1_list libtype)) (setq lib5_list (creatlib1_list libtype))) (act_pop_list lib5_list "lib5")))
    (if (= lib6_id t) (progn (setq libtype (nth 2 (nth 5 attlist))) (if (null word_data_path)(setq lib6_list (creatlib1_list libtype)) (setq lib6_list (creatlib1_list libtype))) (act_pop_list lib6_list "lib6")))
    (if (= lib7_id t) (progn (setq libtype (nth 2 (nth 6 attlist))) (if (null word_data_path)(setq lib7_list (creatlib1_list libtype)) (setq lib7_list (creatlib1_list libtype))) (act_pop_list lib7_list "lib7")))
    (if (= lib8_id t) (progn (setq libtype (nth 2 (nth 7 attlist))) (if (null word_data_path)(setq lib8_list (creatlib1_list libtype)) (setq lib8_list (creatlib1_list libtype))) (act_pop_list lib8_list "lib8")))
    (if (= lib9_id t) (progn (setq libtype (nth 2 (nth 8 attlist))) (if (null word_data_path)(setq lib9_list (creatlib1_list libtype)) (setq lib9_list (creatlib1_list libtype))) (act_pop_list lib9_list "lib9")))

    (if (= lib10_id t) (progn (setq libtype (nth 2 (nth 9 attlist))) (if (null word_data_path)(setq lib10_list (creatlib1_list libtype)) (setq lib10_list (creatlib1_list libtype))) (act_pop_list lib10_list "lib10")))
    (if (= lib11_id t) (progn (setq libtype (nth 2 (nth 10 attlist)))(if (null word_data_path)(setq lib11_list (creatlib1_list libtype)) (setq lib11_list (creatlib1_list libtype)))  (act_pop_list lib11_list "lib11")))
    (if (= lib12_id t) (progn (setq libtype (nth 2 (nth 11 attlist)))(if (null word_data_path)(setq lib12_list (creatlib1_list libtype)) (setq lib12_list (creatlib1_list libtype)))  (act_pop_list lib12_list "lib12")))
    (if (= lib13_id t) (progn (setq libtype (nth 2 (nth 12 attlist)))(if (null word_data_path)(setq lib13_list (creatlib1_list libtype)) (setq lib13_list (creatlib1_list libtype)))  (act_pop_list lib13_list "lib13")))
    (if (= lib14_id t) (progn (setq libtype (nth 2 (nth 13 attlist)))(if (null word_data_path)(setq lib14_list (creatlib1_list libtype)) (setq lib14_list (creatlib1_list libtype)))  (act_pop_list lib14_list "lib14")))
    (if (= lib15_id t) (progn (setq libtype (nth 2 (nth 14 attlist)))(if (null word_data_path)(setq lib15_list (creatlib1_list libtype)) (setq lib15_list (creatlib1_list libtype)))  (act_pop_list lib15_list "lib15")))
    (if (= lib16_id t) (progn (setq libtype (nth 2 (nth 15 attlist)))(if (null word_data_path)(setq lib16_list (creatlib1_list libtype)) (setq lib16_list (creatlib1_list libtype)))  (act_pop_list lib16_list "lib16")))
    (if (= lib17_id t) (progn (setq libtype (nth 2 (nth 16 attlist)))(if (null word_data_path)(setq lib17_list (creatlib1_list libtype)) (setq lib17_list (creatlib1_list libtype)))  (act_pop_list lib17_list "lib17")))
    (if (= lib18_id t) (progn (setq libtype (nth 2 (nth 17 attlist)))(if (null word_data_path)(setq lib18_list (creatlib1_list libtype)) (setq lib18_list (creatlib1_list libtype)))  (act_pop_list lib18_list "lib18")))
    (if (= lib19_id t) (progn (setq libtype (nth 2 (nth 18 attlist)))(if (null word_data_path)(setq lib19_list (creatlib1_list libtype)) (setq lib19_list (creatlib1_list libtype)))  (act_pop_list lib19_list "lib19")))

    (if (= lib20_id t) (progn (setq libtype (nth 2 (nth 19 attlist)))(if (null word_data_path)(setq lib20_list (creatlib1_list libtype)) (setq lib20_list (creatlib1_list libtype)))  (act_pop_list lib20_list "lib20")))
    (if (= lib21_id t) (progn (setq libtype (nth 2 (nth 20 attlist)))(if (null word_data_path)(setq lib21_list (creatlib1_list libtype)) (setq lib21_list (creatlib1_list libtype)))  (act_pop_list lib21_list "lib21")))
    (if (= lib22_id t) (progn (setq libtype (nth 2 (nth 21 attlist)))(if (null word_data_path)(setq lib22_list (creatlib1_list libtype)) (setq lib22_list (creatlib1_list libtype)))  (act_pop_list lib22_list "lib22")))
    (if (= lib23_id t) (progn (setq libtype (nth 2 (nth 22 attlist)))(if (null word_data_path)(setq lib23_list (creatlib1_list libtype)) (setq lib23_list (creatlib1_list libtype)))  (act_pop_list lib23_list "lib23")))
    (if (= lib24_id t) (progn (setq libtype (nth 2 (nth 23 attlist)))(if (null word_data_path)(setq lib24_list (creatlib1_list libtype)) (setq lib24_list (creatlib1_list libtype)))  (act_pop_list lib24_list "lib24")))
    (if (= lib25_id t) (progn (setq libtype (nth 2 (nth 24 attlist)))(if (null word_data_path)(setq lib25_list (creatlib1_list libtype)) (setq lib25_list (creatlib1_list libtype)))  (act_pop_list lib25_list "lib25")))
    (if (= lib26_id t) (progn (setq libtype (nth 2 (nth 25 attlist)))(if (null word_data_path)(setq lib26_list (creatlib1_list libtype)) (setq lib26_list (creatlib1_list libtype)))  (act_pop_list lib26_list "lib26")))
    (if (= lib27_id t) (progn (setq libtype (nth 2 (nth 26 attlist)))(if (null word_data_path)(setq lib27_list (creatlib1_list libtype)) (setq lib27_list (creatlib1_list libtype)))  (act_pop_list lib27_list "lib27")))
    (if (= lib28_id t) (progn (setq libtype (nth 2 (nth 27 attlist)))(if (null word_data_path)(setq lib28_list (creatlib1_list libtype)) (setq lib28_list (creatlib1_list libtype)))  (act_pop_list lib28_list "lib28")))
    (if (= lib29_id t) (progn (setq libtype (nth 2 (nth 28 attlist)))(if (null word_data_path)(setq lib29_list (creatlib1_list libtype)) (setq lib29_list (creatlib1_list libtype)))  (act_pop_list lib29_list "lib29")))

    (if (= lib30_id t) (progn (setq libtype (nth 2 (nth 29 attlist)))(if (null word_data_path)(setq lib30_list (creatlib1_list libtype)) (setq lib30_list (creatlib1_list libtype)))  (act_pop_list lib30_list "lib30")))
    (if (= lib31_id t) (progn (setq libtype (nth 2 (nth 30 attlist)))(if (null word_data_path)(setq lib31_list (creatlib1_list libtype)) (setq lib31_list (creatlib1_list libtype)))  (act_pop_list lib31_list "lib31")))
    (if (= lib32_id t) (progn (setq libtype (nth 2 (nth 31 attlist)))(if (null word_data_path)(setq lib32_list (creatlib1_list libtype)) (setq lib32_list (creatlib1_list libtype)))  (act_pop_list lib32_list "lib32")))
    (if (= lib33_id t) (progn (setq libtype (nth 2 (nth 32 attlist)))(if (null word_data_path)(setq lib33_list (creatlib1_list libtype)) (setq lib33_list (creatlib1_list libtype)))  (act_pop_list lib33_list "lib33")))
    (if (= lib34_id t) (progn (setq libtype (nth 2 (nth 33 attlist)))(if (null word_data_path)(setq lib34_list (creatlib1_list libtype)) (setq lib34_list (creatlib1_list libtype)))  (act_pop_list lib34_list "lib34")))
    (if (= lib35_id t) (progn (setq libtype (nth 2 (nth 34 attlist)))(if (null word_data_path)(setq lib35_list (creatlib1_list libtype)) (setq lib35_list (creatlib1_list libtype)))  (act_pop_list lib35_list "lib35")))
    (if (= lib36_id t) (progn (setq libtype (nth 2 (nth 35 attlist)))(if (null word_data_path)(setq lib36_list (creatlib1_list libtype)) (setq lib36_list (creatlib1_list libtype)))  (act_pop_list lib36_list "lib36")))
    (if (= lib37_id t) (progn (setq libtype (nth 2 (nth 36 attlist)))(if (null word_data_path)(setq lib37_list (creatlib1_list libtype)) (setq lib37_list (creatlib1_list libtype)))  (act_pop_list lib37_list "lib37")))
    (if (= lib38_id t) (progn (setq libtype (nth 2 (nth 37 attlist)))(if (null word_data_path)(setq lib38_list (creatlib1_list libtype)) (setq lib38_list (creatlib1_list libtype)))  (act_pop_list lib38_list "lib38")))

    (action_tile "lib1"   "(getlib_setval \"lib1\" lib1_list \"data1\")")
    (action_tile "lib2"   "(getlib_setval \"lib2\" lib2_list \"data2\")")
    (action_tile "lib3"   "(getlib_setval \"lib3\" lib3_list \"data3\")")
    (action_tile "lib4"   "(getlib_setval \"lib4\" lib4_list \"data4\")")
    (action_tile "lib5"   "(getlib_setval \"lib5\" lib5_list \"data5\")")
    (action_tile "lib6"   "(getlib_setval \"lib6\" lib6_list \"data6\")")
    (action_tile "lib7"   "(getlib_setval \"lib7\" lib7_list \"data7\")")
    (action_tile "lib8"   "(getlib_setval \"lib8\" lib8_list \"data8\")")
    (action_tile "lib9"   "(getlib_setval \"lib9\" lib9_list \"data9\")")

    (action_tile "lib10"  "(getlib_setval \"lib10\" lib10_list \"data10\")")
    (action_tile "lib11"  "(getlib_setval \"lib11\" lib11_list \"data11\")")
    (action_tile "lib12"  "(getlib_setval \"lib12\" lib12_list \"data12\")")
    (action_tile "lib13"  "(getlib_setval \"lib13\" lib13_list \"data13\")")
    (action_tile "lib14"  "(getlib_setval \"lib14\" lib14_list \"data14\")")
    (action_tile "lib15"  "(getlib_setval \"lib15\" lib15_list \"data15\")")
    (action_tile "lib16"  "(getlib_setval \"lib16\" lib16_list \"data16\")")
    (action_tile "lib17"  "(getlib_setval \"lib17\" lib17_list \"data17\")")
    (action_tile "lib18"  "(getlib_setval \"lib18\" lib18_list \"data18\")")
    (action_tile "lib19"  "(getlib_setval \"lib19\" lib19_list \"data19\")")

    (action_tile "lib20"  "(getlib_setval \"lib20\" lib20_list \"data20\")")
    (action_tile "lib21"  "(getlib_setval \"lib21\" lib21_list \"data21\")")
    (action_tile "lib22"  "(getlib_setval \"lib22\" lib22_list \"data22\")")
    (action_tile "lib23"  "(getlib_setval \"lib23\" lib23_list \"data23\")")
    (action_tile "lib24"  "(getlib_setval \"lib24\" lib24_list \"data24\")")
    (action_tile "lib25"  "(getlib_setval \"lib25\" lib25_list \"data25\")")
    (action_tile "lib26"  "(getlib_setval \"lib26\" lib26_list \"data26\")")
    (action_tile "lib27"  "(getlib_setval \"lib27\" lib27_list \"data27\")")
    (action_tile "lib28"  "(getlib_setval \"lib28\" lib28_list \"data28\")")
    (action_tile "lib29"  "(getlib_setval \"lib29\" lib29_list \"data29\")")

    (action_tile "lib30"  "(getlib_setval \"lib30\" lib30_list \"data30\")")
    (action_tile "lib31"  "(getlib_setval \"lib31\" lib31_list \"data31\")")
    (action_tile "lib32"  "(getlib_setval \"lib32\" lib32_list \"data32\")")
    (action_tile "lib33"  "(getlib_setval \"lib33\" lib33_list \"data33\")")
    (action_tile "lib34"  "(getlib_setval \"lib34\" lib34_list \"data34\")")
    (action_tile "lib35"  "(getlib_setval \"lib35\" lib35_list \"data35\")")
    (action_tile "lib36"  "(getlib_setval \"lib36\" lib36_list \"data36\")")
    (action_tile "lib37"  "(getlib_setval \"lib37\" lib37_list \"data37\")")
    (action_tile "lib38"  "(getlib_setval \"lib38\" lib38_list \"data38\")")

    (setq count 1)
    (foreach nn attlist
      (progn
          ;;==============2003.09.16 SAM===============
          (setq temp (assoc (nth 0 nn) blk_attlist))
          (if temp  (progn
                (setq txt (nth 1 temp))
                (set_tile (strcat "data" (rtos count 2 0)) txt)
          ))
          ;(setq txt (nth 1 (assoc  (nth 0 nn) blk_attlist)))
          ;(set_tile (strcat "data" (rtos count 2 0)) txt)
          ;;==============2003.09.16 SAM===============
         (setq count (1+ count))
      );progn
    );foreach
    (action_tile "cancel" "(done_dialog)(setq check_p nil)")
    (action_tile "accept" "(setq check_p T)(input_attedata_ok)")
    (start_dialog)
    (if check_p (aachg_sheetatt))
    (princ)
)

(defun aachg_sheetatt(/ ent newdata label data1)
   (setq ent attsheet_name)
   (foreach nn attdata_list
     (progn
       (setq newdata (getrealstr3 (nth 1 nn))
             label (nth 0 nn))
       (setq data1 (getatt ent 2 label)
             data1 (subst (cons 1 newdata) (assoc 1 data1) data1))
       (entmod data1)
     );progn
   );foreach
   (command "regen")
)
;;======================================================================================================================
;;更換圖框尺寸
(defun ch_sheet(typ / int_ret)
   (setq mod_sca (getvar "dimscale"))
   (setq bordergrp (ssget "x" (list (cons 8 sys_sheet_layer) (cons 0 "INSERT"))))
   (SETQ modgrp (SSGET "X" '((0 . "INSERT") (-3 ("MODFLAG")))))
   (if (/= nil modgrp)
       (progn
             (setq ~i 0)
             (repeat (sslength modgrp)        
                     (setq bordergrp(ssdel (ssname modgrp ~i) bordergrp))
                     (setq ~i (+ ~i 1)) 
             );repeat
       );progn
   );if  
   (cond
     ((null bordergrp) (princ "\n圖面上沒有圖框,不能執行此功能!"))
     ((= 1 (sslength bordergrp)) 
      (princ "\n沒有圖框屬性資料!")
           
       (command "erase" bordergrp "")
     
          (c:autoshscal)
          
     )
     (T

       (setq ent1 (ssname bordergrp 0))
       (setq ent2 (ssname bordergrp 1))
       (cond
         ((/= nil (setq sheetdata (getxdata ent1 "SHEETFLAG")))
             (setq sheettype (cdr (nth 1 (nth 1 (assoc -3 sheetdata)))))
             (setq attent ent1)
         )
         ((/= nil (setq sheetdata (getxdata ent2 "SHEETFLAG")))
             (setq sheettype (cdr (nth 1 (nth 1 (assoc -3 sheetdata)))))
             (setq attent ent2)
         )
         (T 
    
            (command "erase" bordergrp "")
           
            (c:autoshscal)
         )
       );cond
       (if (null sheet_type) (read_autoshscal_data))
       (setq cou 0)
       (setq &&sheet_id (list_id sheettype sheet_type))
       (if (= typ 1) 
           (progn
               (atoshscal 2)
               (if (/= nil modgrp)
                    (progn
                                 
                         (setq mod_sca (cdr (assoc 41 (entget (ssname modgrp 0)))))     
        
                         (setq mod_insp (cdr (assoc 10 (entget (ssname modgrp (- (sslength modgrp) 1))))))
          
                         (if (/= mod_sca 1) (command "scale" modgrp "" mod_insp (/ 1.0 mod_sca)))
                         (princ "\n設變欄位新基準點:")
                         (command "scale" modgrp "" mod_insp (getvar "dimscale")) 
                         (command "move" modgrp "" mod_insp pause) 
                    );progn
                );if
                
           );progn
           (princ)
       );if
       (princ)
     )
   )
  ; (command "dim" "up" "all" "" "exit")
   (if (/= 1 typ)
       (setq int_ret (list attent &&sheet_id))	;;2004.03.18 SAM CAD_TO_PDM's (ch_sheet 2) 的傳回值
       (rest_dimdtyle_dimscale)
   )
   int_ret
);defun

