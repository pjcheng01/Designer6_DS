;;;
;;;幾何公差標註
;;;常用配合軸與孔之容許差
;;;小尺寸連續標註
;;;改變為尺寸標註
;;;CNS 加工符號
;;;JIS 加工符號
;;;基準線
;;;指引線
;;;標直徑
;;;熔接標註
;;; 自動水平標註
;;; 自動垂直標註
;;; 尺寸爆炸回原層
;;; 功能說明:萃取修改尺寸標註內容
;;; 取消公差尺寸標註
;;;扣環標註(2003.02.12)(c:cring_auxdim)
;;;鍵槽鍵座標註(2003.03.17)(c:keydim)
;;;引線標註帶辭庫
;;;45 度倒角標註
;;;熔接符號
;;;使用者自定公差標註
;==============================================================================================
(defun adddimtxt(addtxt addtxt2)
  (setvar "cmdecho" 0)
  (setq beselent (entsel "\n選取標註:"))
  (if beselent
    (progn
       (setq ent (car beselent))
       (setq ed(entget ent))
       (setq data0 (cdr (assoc 0 ed)))
       (if (= data0 "DIMENSION")
         (progn
           (setq 1data (cdr (assoc 1 ed)))
           (if (= "" 1data)
             (setq ed (subst (cons 1 (strcat addtxt "<>" addtxt2)) (assoc 1 ed) ed))
             (progn
               (cond
                 ((= "<>" (substr 1data 1 2))
                  (setq ed (subst (cons 1 (strcat addtxt "<>" addtxt2)) (assoc 1 ed) ed))
                 )
                 ((and (setq s_no (get_word 1data ";")) (setq e_no (get_word 1data "{")))
                  (if (getxdata ent "DIM")
                     (progn
                      (setq oldim (cdr(cadr(cadr (assoc -3 (getxdata ent "DIM"))))))
                      (setq ed (subst (cons 1 (strcat addtxt (substr 1data (+ 1 s_no) (- e_no s_no 1 (strlen oldim))) addtxt2)) (assoc 1 ed) ed))
                     );progn
                      (setq ed (subst (cons 1 (strcat addtxt (substr 1data (+ 1 s_no) (- e_no s_no 1)) addtxt2)) (assoc 1 ed) ed))
                  );if
                 )
                 (t (setq ed (subst (cons 1 (strcat addtxt 1data addtxt2)) (assoc 1 ed) ed)))
               );cond
             );progn
           );if
           (entmod ed)
           (entupd (entlast))
           (setq entname ent)
         );progn
         (princ "\n您選的圖元不是整體的尺寸標註圖元!")
        );if
     );progn
     (princ "\n未選到任何圖元!")
  );if
  (princ)
  (setvar "cmdecho" 1)
)


(defun adddimtxt1(addtxt addtxt2)
  (setvar "cmdecho" 0)
  (setq beselent (entsel "\n選取標註:"))
  (if beselent
    (progn
       (setq ent (car beselent))
       (setq ed(entget ent))
       (setq data0 (cdr (assoc 0 ed)))
       (if (= data0 "DIMENSION")
         (progn
           (setq 1data (cdr (assoc 1 ed)))
           (if (or (= "" 1data) (and (wcmatch (cdr olddim) "*<*") (wcmatch (cdr olddim) "*>*")))
               (setq ed (subst (cons 1 (strcat addtxt "<>" addtxt2)) (assoc 1 ed) ed))
               (setq ed (subst (cons 1 (strcat addtxt 1data addtxt2)) (assoc 1 ed) ed))
           )
           (entmod ed)
           (entupd (entlast))
         );progn
         (princ "\n您選的圖元不是整體的尺寸標註圖元!")
        );if
     );progn
     (princ "\n未選到任何圖元!")
  );if
  (princ)
  (setvar "cmdecho" 1)
)
;;方體標註
(defun c:rectdim()
       (adddimtxt "□ " "")
       (while beselent
              (adddimtxt "□ " "")
       );while
)
;;面標註
(defun c:facedim1()
       (adddimtxt "SR" "")
       (while beselent
              (adddimtxt "SR" "")
       );while
)
;;面標註
(defun c:facedim2()
       (adddimtxt "S%%C" "")
       (while beselent
              (adddimtxt "S%%C" "")
       );while
)
;;參考標註
(defun c:refdim()
       (adddimtxt "(" ")")
       (while beselent
              (adddimtxt "(" ")")
       );while
)
;;加入直徑符號
(defun c:diadim()
       (adddimtxt "%%c" "")
       (while beselent
              (adddimtxt "%%c" "")
       );while
)


;;還原標註
(defun c:rt_dim()
  (setvar "cmdecho" 0)
  (princ "\n請注意! 當您執行此項功能後,尺寸將還原為內定尺寸值!!")
  (setq beselent (entsel "\n按 ENTER 結束或選取標註:"))
  (while beselent
      (progn
         (setq ent (car beselent))
         (setq ed(entget ent))
         (setq data0 (cdr (assoc 0 ed)))
         (if (= data0 "DIMENSION")
             (progn
                  (setq 1data (cdr (assoc 1 ed)))
                  (if (/= "" 1data) (setq txt1 (substr 1data 1 1) engnum (check_engtxt 1data)))

                  (cond
                    ((= "" 1data)
                        (setvar "dimtol" 0)
                        (command "dim" "up" ent "" "exit")
                        (princ)
                    )
                   ; ((and (= "\\" txt1) (null (get_word 1data "{")))
                   ;  (princ)
                   ; )
                    ((and (get_word 1data "{") (setq txtid (get_word 1data "\\")))
                     (setq newtxt (substr 1data txtid))
                     (setq ed (subst (cons 1 newtxt) (assoc 1 ed) ed))
                     (entmod ed)
                     (entupd ent)
                     (princ)
                    )
                    ((and (/= "" 1data) (setq txtid (get_word 1data "{")))
                      (setq newtxt (substr 1data 1 (- txtid 1)))
                      (if (and (/= 1 txtid)(setq txtid (get_word newtxt "(")))
                            (setq newtxt (substr 1data 1 (- txtid 1)))
                      );if
                      (setq ed (subst (cons 1 newtxt) (assoc 1 ed) ed))
                      (entmod ed)
                      (entupd ent) )
                    ((and (/= "" 1data) (setq txtid (get_word 1data "(")))
                      (if (/= 1 txtid)
                        (progn
                            (setq newtxt (substr 1data 1 (- txtid 1)))
                            (setq ed (subst (cons 1 newtxt) (assoc 1 ed) ed))
                            (entmod ed)
                            (entupd ent)
                        );progn
                        (progn
                            (setq newtxt (substr 1data 2))
                            (setq len (strlen newtxt))
                            (setq newtxt (substr newtxt 1 (- len 1)))
                            (setq ed (subst (cons 1 newtxt) (assoc 1 ed) ed))
                            (entmod ed)
                            (entupd ent)
                        )
                      );if
                    )
                    ((and (/= "" 1data) (get_word 1data "<"))
                       (setq ed (subst (cons 1 "<>") (assoc 1 ed) ed))
                       (entmod ed)
                       (entupd ent)
                    )
                    ((and (/= "" 1data) (null (member txt1 (list "1" "2" "3" "4" "5" "6" "7" "8" "9"))))
                       (setq count 2)
                       (setq txt1 (substr 1data count 1) flag t)
                       (while flag
                          (if (member txt1 (list "1" "2" "3" "4" "5" "6" "7" "8" "9"))
                            (progn
                              (setq txt (substr 1data count))
                              (setq ed (subst (cons 1 txt) (assoc 1 ed) ed))
                              (entmod ed)
                              (entupd ent)
                              (setq flag nil)
                            );progn
                            (setq count (1+ count) txt1 (substr 1data count 1))
                          );if
                       );while
                    )
                     ((and (/= 1data "") (/= nil engnum))
                       (setq newtxt (substr 1data 1 (- engnum 1)))
                       (setq ed (subst (cons 1 newtxt) (assoc 1 ed) ed))
                       (entmod ed)
                       (entupd ent)
                     )
                     (T
                       (setq ed (subst (cons 1 "<>") (assoc 1 ed) ed))
                       (entmod ed)
                       (entupd ent)
                    )
                  );cond
             );progn
             (princ "\n您選的圖元不是整體的尺寸標註圖元!")
         );if
      );progn
      (setq beselent (entsel "\n選取標註:"))
     ; (princ "\n未選到任何圖元!")
  );while
  (setvar "cmdecho" 1)
  (princ)
)
;; 尺寸爆炸回原層
;-----------------------------------------------------------------------------+
;                               LEXPLODE.LSP                                  |
;                                                                             |
;    Larry Knott                Version 1.0                  5/25/88          |
;                                                                             |
;    Explode a BLOCK, POLYLINE, or DIMENSION and copy the entities            |
;    that replace it to the layer that the original entity was on.            |
;                                                                             |
;-----------------------------------------------------------------------------+

;-------------------------- INTERNAL ERROR HANDLER ---------------------------|

(defun lexerr (s)                     ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
  (if (/= s "Function cancelled")
    (princ (strcat "\nError: " s))
  )
  (setvar "highlight" ohl)            ; restore old highlight value
  (setvar "cmdecho" oce)              ; restore old cmdecho value
  (setq *error* olderr)               ; restore old *error* handler
  (princ)
)
;------------------------------ COMMON FUNCTION ------------------------------|

(defun getval (n e) (cdr (assoc n e)))

;--------------------------- GET ENTITY TO EXPLODE ---------------------------|

(defun getent (t1 / no_ent e0)
(setq no_ent T)
(while no_ent
  (if (setq e0 (entsel "\nSelect block reference, polyline, dimension, or mesh: "))
    (if (member (getval 0 (setq e1 (entget (car e0)))) t1)
      (if (equal (getval 0 e1) "INSERT")
        (if (and (equal (getval 41 e1) (getval 42 e1))
                 (equal (getval 42 e1) (getval 43 e1)))
          (setq no_ent nil)
          (princ "\nX, Y, and Z scale factors must be equal."))
        (setq no_ent nil))
      (princ "\nNot a block reference, polyline, or dimension."))
    (princ " No object found."))
))

;-------------------------------- MAIN PROGRAM -------------------------------|

(defun c:lexplode (/ oce ohl e0 en e1 s0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
(setq olderr *error*
      *error* lexerr)
(setq oce (getvar "cmdecho"))         ; save value of cmdecho
(setq ohl (getvar "highlight"))       ; save value of highlight
(setvar "cmdecho" 0)                  ; turn cmdecho off
(setvar "highlight" 0)                ; turn highlight off
(setq e0 (entlast))
(setq en (entnext e0))
(while (not (null en))                ; find the last entity
  (setq e0 en)
  (setq en (entnext e0))
)
(getent '("INSERT" "DIMENSION" "POLYLINE"))
(if (= acad_ver "GENIUS")
    (command ".explode" (getval -1 e1))    ; explode the entity
    (command "explode" (getval -1 e1))    ; explode the entity
)
(setq s0 (ssadd))
(while (entnext e0) (ssadd (setq e0 (entnext e0)) s0))
(command "chprop" s0 ""               ; change entities to the proper layer
         "c"   "bylayer"              ; regardless of their extrusion direction
         "lt"  "bylayer"
         "la"  (getval 8 e1) "")
(princ (strcat "\nEntities exploded onto layer " (getval 8 e1) "."))
(setvar "highlight" ohl)              ; restore old highlight value
(setvar "cmdecho" oce)                ; restore old cmdecho value
(setq *error* olderr)                 ; restore old *error* handler
   (SETQ FFF nil))
(prin1))

;------------------------------------ END ------------------------------------|

;常用配合軸與孔之容許差
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 1. 15                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明:                                                                               ║
;║                                                                                        ║
;║執行方式:                                                                               ║
;║相關檔案:pub-lisp.lsp, sha_tol.dat,hole_tol.dat                                         ║
;║                                                                                        ║
;║                                                                                        ║
;╰════════════════════════════════════════════╯
;(setq size_list (list "         3以下" "  3以上  6以下" "  6以上 10以下" " 10以上 14以下"
;            " 14以上 18以下" " 18以上 24以下" " 24以上 30以下" " 30以上 40以下"
;            " 40以上 50以下" " 50以上 65以下" " 65以上 80以下" " 80以上100以下"
;            "100以上120以下" "120以上140以下" "140以上160以下" "160以上180以下"
;            "180以上200以下" "200以上225以下" "225以上250以下" "250以上280以下"
;            "280以上315以下" "315以上355以下" "355以上400以下" "400以上450以下"
;            "450以上500以下"))

(setq size_list (list "  3以下" "  3 ~   6" "  6 ~  10" " 10 ~  14"
            " 14 ~  18" " 18 ~  24" " 24 ~  30" " 30 ~  40"
            " 40 ~  50" " 50 ~  65" " 65 ~  80" " 80 ~ 100"
            "100 ~ 120" "120 ~ 140" "140 ~ 160" "160 ~ 180"
            "180 ~ 200" "200 ~ 225" "225 ~ 250" "250 ~ 280"
            "280 ~ 315" "315 ~ 355" "355 ~ 400" "400 ~ 450"
            "450 ~ 500"))

(setq hole_radio_list (list "B10" "C9" "C10" "D8" "D9" "D10" "E7" "E8" "E9" "F6" "F7" "F8"
                 "G6" "G7" "H6" "H7" "H8" "H9" "H10" "Js6" "Js7" "K6" "K7"
                 "M6" "M7" "N6" "N7" "P6" "P7" "R7" "S7" "T7" "U7" "X7"))

(setq sha_radio_list (list "b9" "c9" "d8" "d9" "e7" "e8" "e9" "f6" "f7" "f8"
                 "g5" "g6" "h5" "h6" "h7" "h8" "h9" "js5" "js6" "js7" "k5" "k6"
                 "m5" "m6" "n6" "p6" "r6" "s6" "t6" "u6" "x6"))

(defun c:toler_hole(/ ptile)
       (if (and (= jin "#$%")(= #### 85))(setq FFF t))
       (WHILE (/= FFF nil)
              (setq ppss sspp)
              (setvar "cmdecho" 0)

              (defun *error* (msg)
                 (princ msg)
                 (setvar "dimtol" 0)
                 (prin1)
              )
             (setq toluv nil toldv nil)
             (actdcl (strcat powdesign_dcl_path "auxdim") "hole_tol")
             (act_pop_list size_list "sizetype")

             (setq ptile "B9")
             (setq fname (strcat powdesign_data_path "hole_tol.DAT"))

             (action_tile "sizetype" "(tol_tile_mode hole_radio_list 0 0)(setq toluv nil toldv nil)
             (sel_sizetype 1 hole_radio_list fname)")

             (tol_tile_mode hole_radio_list 0 1)

             (action_tile "B10" "(setq tolv 1  toltxt \"B10\")(set_tile ptile \"0\")(set_tile \"B10\"  \"1\")(setq ptile \"B10\")(gettol_val 1 \"B10\") ")
             (action_tile "C9"  "(setq tolv 2  toltxt \"C9\" )(set_tile ptile \"0\")(set_tile \"C9\"  \"1\")(setq ptile \"C9\") (gettol_val 1 \"C9\")  ")
             (action_tile "C10" "(setq tolv 3  toltxt \"C10\")(set_tile ptile \"0\")(set_tile \"C10\" \"1\")(setq ptile \"C10\")(gettol_val 1 \"C10\") ")
             (action_tile "D8"  "(setq tolv 4  toltxt \"D8\" )(set_tile ptile \"0\")(set_tile \"D8\"  \"1\")(setq ptile \"D8\") (gettol_val 1 \"D8\")  ")
             (action_tile "D9"  "(setq tolv 5  toltxt \"D9\" )(set_tile ptile \"0\")(set_tile \"D9\"  \"1\")(setq ptile \"D9\") (gettol_val 1 \"D9\")  ")
             (action_tile "D10" "(setq tolv 6  toltxt \"D10\")(set_tile ptile \"0\")(set_tile \"D10\" \"1\")(setq ptile \"D10\")(gettol_val 1 \"D10\") ")
             (action_tile "E7"  "(setq tolv 7  toltxt \"E7\" )(set_tile ptile \"0\")(set_tile \"E7\"  \"1\")(setq ptile \"E7\") (gettol_val 1 \"E7\")  ")
             (action_tile "E8"  "(setq tolv 8  toltxt \"E8\" )(set_tile ptile \"0\")(set_tile \"E8\"  \"1\")(setq ptile \"E8\") (gettol_val 1 \"E8\")  ")
             (action_tile "E9"  "(setq tolv 9  toltxt \"E9\" )(set_tile ptile \"0\")(set_tile \"E9\"  \"1\")(setq ptile \"E9\") (gettol_val 1 \"E9\")  ")
             (action_tile "F6"  "(setq tolv 10 toltxt \"F6\" )(set_tile ptile \"0\")(set_tile \"F6\"  \"1\")(setq ptile \"F6\") (gettol_val 1 \"F6\")  ")
             (action_tile "F7"  "(setq tolv 11 toltxt \"F7\" )(set_tile ptile \"0\")(set_tile \"F7\"  \"1\")(setq ptile \"F7\") (gettol_val 1 \"F7\")  ")
             (action_tile "F8"  "(setq tolv 12 toltxt \"F8\" )(set_tile ptile \"0\")(set_tile \"F8\"  \"1\")(setq ptile \"F8\") (gettol_val 1 \"F8\")  ")
             (action_tile "G6"  "(setq tolv 13 toltxt \"G6\" )(set_tile ptile \"0\")(set_tile \"G6\"  \"1\")(setq ptile \"G6\") (gettol_val 1 \"G6\")  ")
             (action_tile "G7"  "(setq tolv 14 toltxt \"G7\" )(set_tile ptile \"0\")(set_tile \"G7\"  \"1\")(setq ptile \"G7\") (gettol_val 1 \"G7\")  ")
             (action_tile "H6"  "(setq tolv 15 toltxt \"H6\" )(set_tile ptile \"0\")(set_tile \"H6\"  \"1\")(setq ptile \"H6\") (gettol_val 1 \"H6\")  ")
             (action_tile "H7"  "(setq tolv 16 toltxt \"H7\" )(set_tile ptile \"0\")(set_tile \"H7\"  \"1\")(setq ptile \"H7\") (gettol_val 1 \"H7\")  ")
             (action_tile "H8"  "(setq tolv 17 toltxt \"H8\" )(set_tile ptile \"0\")(set_tile \"H8\"  \"1\")(setq ptile \"H8\") (gettol_val 1 \"H8\")  ")
             (action_tile "H9"  "(setq tolv 18 toltxt \"H9\" )(set_tile ptile \"0\")(set_tile \"H9\"  \"1\")(setq ptile \"H9\") (gettol_val 1 \"H9\")  ")
             (action_tile "H10" "(setq tolv 19 toltxt \"H10\")(set_tile ptile \"0\")(set_tile \"H10\" \"1\")(setq ptile \"H10\")(gettol_val 1 \"H10\") ")
             (action_tile "Js6" "(setq tolv 20 toltxt \"Js6\")(set_tile ptile \"0\")(set_tile \"Js6\" \"1\")(setq ptile \"Js6\")(gettol_val 1 \"Js6\") ")
             (action_tile "Js7" "(setq tolv 21 toltxt \"Js7\")(set_tile ptile \"0\")(set_tile \"Js7\" \"1\")(setq ptile \"Js7\")(gettol_val 1 \"Js7\") ")
             (action_tile "K6"  "(setq tolv 22 toltxt \"K6\" )(set_tile ptile \"0\")(set_tile \"K6\"  \"1\")(setq ptile \"K6\") (gettol_val 1 \"K6\")  ")
             (action_tile "K7"  "(setq tolv 23 toltxt \"K7\" )(set_tile ptile \"0\")(set_tile \"K7\"  \"1\")(setq ptile \"K7\") (gettol_val 1 \"K7\")  ")
             (action_tile "B9"  "(setq tolv 24 toltxt \"B9\" )(set_tile ptile \"0\")(set_tile \"B9\"  \"1\")(setq ptile \"B9\") (gettol_val 1 \"B9\")  ")
             (action_tile "M6"  "(setq tolv 25 toltxt \"M6\" )(set_tile ptile \"0\")(set_tile \"M6\"  \"1\")(setq ptile \"M6\") (gettol_val 1 \"M6\")  ")
             (action_tile "M7"  "(setq tolv 26 toltxt \"M7\" )(set_tile ptile \"0\")(set_tile \"M7\"  \"1\")(setq ptile \"M7\") (gettol_val 1 \"M7\")  ")
             (action_tile "N6"  "(setq tolv 27 toltxt \"N6\" )(set_tile ptile \"0\")(set_tile \"N6\"  \"1\")(setq ptile \"N6\") (gettol_val 1 \"N6\")  ")
             (action_tile "N7"  "(setq tolv 28 toltxt \"N7\" )(set_tile ptile \"0\")(set_tile \"N7\"  \"1\")(setq ptile \"N7\") (gettol_val 1 \"N7\")  ")
             (action_tile "P6"  "(setq tolv 29 toltxt \"P6\" )(set_tile ptile \"0\")(set_tile \"P6\"  \"1\")(setq ptile \"P6\") (gettol_val 1 \"P6\")  ")
             (action_tile "P7"  "(setq tolv 30 toltxt \"P7\" )(set_tile ptile \"0\")(set_tile \"P7\"  \"1\")(setq ptile \"P7\") (gettol_val 1 \"P7\")  ")
             (action_tile "R7"  "(setq tolv 31 toltxt \"R7\" )(set_tile ptile \"0\")(set_tile \"R7\"  \"1\")(setq ptile \"R7\") (gettol_val 1 \"R7\")  ")
             (action_tile "S7"  "(setq tolv 32 toltxt \"S7\" )(set_tile ptile \"0\")(set_tile \"S7\"  \"1\")(setq ptile \"S7\") (gettol_val 1 \"S7\")  ")
             (action_tile "T7"  "(setq tolv 33 toltxt \"T7\" )(set_tile ptile \"0\")(set_tile \"T7\"  \"1\")(setq ptile \"T7\") (gettol_val 1 \"T7\")  ")
             (action_tile "U7"  "(setq tolv 34 toltxt \"U7\" )(set_tile ptile \"0\")(set_tile \"U7\"  \"1\")(setq ptile \"U7\") (gettol_val 1 \"U7\")  ")
             (action_tile "X7"  "(setq tolv 35 toltxt \"X7\" )(set_tile ptile \"0\")(set_tile \"X7\"  \"1\")(setq ptile \"X7\") (gettol_val 1 \"X7\")  ")



             (action_tile "cancel" "(setq tolu nil told nil toluv nil)(done_dialog)")
             (action_tile "accept" "(dimtol_type)(done_dialog)")

             (start_dialog)

             (if toluv
               (progn
                 (setq entname nil)
                 (cond
                   ((= 1 modetyp)(toler_ok))
                   ((= 2 modetyp)(aDDdimtxt "" (strcat "(" toltxt ")"))(toler_ok2))
                   ((= 3 modetyp)(adddimtxt "" (strcat "(" toltxt ")")))
                   ((= 4 modetyp)(adddimtxt "" toltxt)(toler_ok2))
                   ((= 5 modetyp)(adddimtxt "" toltxt))
                 );cond

                 (if entname
                      (cond
                        ((= 1 modetyp)(adxdata_auxdim "DIM" 1000 toltxt))
                        ((= 2 modetyp)(adxdata_auxdim "DIM" 1000 (strcat "(" toltxt ")")))
                        ((= 3 modetyp)(adxdata_auxdim "DIM" 1000 (strcat "(" toltxt ")")))
                        ((= 4 modetyp)(adxdata_auxdim "DIM" 1000 toltxt))
                        ((= 5 modetyp)(adxdata_auxdim "DIM" 1000 toltxt))
                      )
                 );if
               );progn
             )

;            (if toluv
;              (progn
;                (setq $toluv toluv $toldv toldv)
;                (cond
;                  ((= 1 modetyp)
;                      (toler_ok)
;                      (while up_dim
;                             (setq toluv $toluv toldv $toldv)
;                             (toler_ok)
;                      )
;                  )
;                  ((= 2 modetyp)
;                      (adddimtxt "" (strcat "(" toltxt ")"))
;                      (if beselent (toler_ok2))
;                      (while beselent
;                             (adddimtxt "" (strcat "(" toltxt ")"))
;                             (setq toluv $toluv toldv $toldv)
;                             (if beselent (toler_ok2))
;                      );while
;                  )
;                  ((= 3 modetyp)
;                      (adddimtxt "" (strcat "(" toltxt ")"))
;                      (while beselent
;                             (adddimtxt "" (strcat "(" toltxt ")"))
;                      );while
;                  )
;                  ((= 4 modetyp)
;                      (adddimtxt "" toltxt)
;                      (if beselent (toler_ok2))
;                      (while beselent
;                             (adddimtxt "" toltxt)
;                             (setq toluv $toluv toldv $toldv)
;                             (if beselent (toler_ok2))
;                      );while
;                  )
;                  ((= 5 modetyp)
;                      (adddimtxt "" toltxt)
;                      (while beselent
;                             (adddimtxt "" toltxt)
;                      );while
;                  )
;                );cond
;              );progn
;            )
             (setvar "cmdecho" 1)
             (SETQ FFF nil)
       );while
       (prin1)
)

(defun adxdata_auxdim(xdata_flag_single id x_data)
   (regapp xdata_flag_single)
   (setq oldentdata (entget entname))
   (setq d10 (cons id x_data))
   (setq dd (list xdata_flag_single d10)
         newdata (append (list -3 dd)))
   (setq newent (append oldentdata (list newdata)))
   (entmod newent)
 (princ)
)

(defun dimtol_type()
;  (setq aa (get_tile "mode1"))
   (cond
     ((= "1" (get_tile "mode1"))(setq modetyp 1))
     ((= "1" (get_tile "mode2"))(setq modetyp 2))
     ((= "1" (get_tile "mode3"))(setq modetyp 3))
     ((= "1" (get_tile "mode4"))(setq modetyp 4))
     ((= "1" (get_tile "mode5"))(setq modetyp 5))
   );cond
   (done_dialog)
)

;;hors-> 0: hole   1:sha
;;fg  -> 0: show   1:hide
(defun tol_tile_mode(key_list hors fg)
   (foreach n key_list
     (progn
        (mode_tile n fg)
        (if (= hors 0)
          (progn
             (mode_tile (strcat n "U") fg)
             (mode_tile (strcat n "D") fg)
          )
          (progn
             (mode_tile (strcat n "u") fg)
             (mode_tile (strcat n "d") fg)
          )
        )

     )
   )
)


;;區域變數check OK!!
;(defun toler_ok2(/ cl_tol dim_tzin cl_tfac dimsc told_1)
(defun toler_ok2(/ cl_tol dim_tzin cl_tfac)
     (setvar "cmdecho" 1)
     (setq cl_tol(getvar "dimtol"))
     (setq dim_tzin(getvar "dimtzin"))
     (setq cl_tfac(getvar "dimtfac"))
     (setq dimsc(getvar "dimscale"))

    (setvar "dimtol" 1)
    (setvar "dimtzin" 8)
    (setvar "dimtfac" 0.8)

   (setq told_1 (substr toldv 1 1))

   (if (= "-" told_1) (setq toldv (substr toldv 2))
                      (setq toldv (strcat "-"  toldv )))

   (chg_dim_ok2 toluv toldv)

   (setvar "dimtzin" dim_tzin)
   (setvar "dimtfac" cl_tfac)
   (setvar "dimtol" 0)
   (setq dimsc nil told_1 nil)
)

;;區域變數check OK!!
(defun chg_dim_ok2(tol_up tol_down / up_dim)
         (setq up_dim beselent)  ;; pub-lisp.lsp(auto_chgdim==> beselent 變數)
         (cond
            ((/= (cdr (assoc 0 (entget (car up_dim)))) "DIMENSION")(chg_dim_errmsg))
            ((= (cdr (assoc 1 (entget (car up_dim)))) "")
              (progn
                  (setvar "dimtp" (atof tol_up))
                  (setvar "dimtm" (atof tol_down))
                 (command "dim")
                 (command "update" up_dim "")
                 (command "exit")

              );progn
            )
            ((/= (cdr (assoc 1 (entget (car up_dim)))) "") (chg_dim_edited_txt))
          );cond
        ;  (setq beselent nil)
);defun ok2


;;toluv->上公差       toldv->下公差
(defun toler_ok()
     (setq cl_tol(getvar "dimtol"))
     (setq dim_tzin(getvar "dimtzin"))
     (setq cl_tfac(getvar "dimtfac"))
     (setq dimsc(getvar "dimscale"))

    (setvar "dimtol" 1)
    (setvar "dimtzin" 8)
    (setvar "dimtfac" 0.8)

   (setq told_1 (substr toldv 1 1))

   (if (= "-" told_1) (setq toldv (substr toldv 2))
                      (setq toldv (strcat "-"  toldv )))

   (chg_dim_ok toluv toldv)

      (setvar "dimtzin" dim_tzin)
      (setvar "dimtfac" cl_tfac)
;     (setvar "dimtol" cl_tol)
      (setvar "dimtol" 0)

)

;;=======
(defun gettol_val(fg keyname)
  (cond
    ((= 1 fg) (setq toluv (get_tile (strcat keyname "U"))
                    toldv (get_tile (strcat keyname "D"))))
    ((= 2 fg) (setq toluv (get_tile (strcat keyname "u"))
                    toldv (get_tile (strcat keyname "d"))))
  )
)
(defun sel_sizetype(fg list_fg fname)

  (setq size_id (atoi (get_tile "sizetype")))

  (setq ff (open fname "r"))
  (repeat (1+ size_id)
    (setq data (read-line ff))
  )(close ff)
  (setq data (read data))
  (setq aa data)
  (foreach n list_fg
     (progn
       (setq data (cdr data))
       (setq tolu (nth 0 (nth 0 data))
             told (nth 1 (nth 0 data)))
     ;  (if (null tolu) (setq tolu ""))
     ;  (if (null told) (setq told ""))
       (if (= "INTELLICAD" cad_version)
         (progn
           (if (null tolu) (setq tolu "") (setq tolu (rtos tolu 2 4)))
           (if (null told) (setq told "") (setq told (rtos told 2 4)))
           (if (> (strlen tolu) 6) (setq tolu (substr tolu 1 6)))
           (if (> (strlen told) 6) (setq told (substr told 1 6)))
         );progn
         (progn
           (if (null tolu) (setq tolu "")(setq tolu (rtos tolu 2 4)))
           (if (null told) (setq told "")(setq told (rtos told 2 4)))
         );progn
       );if
       (if (and (= "" tolu) (= "" tolu)) (mode_tile n 1) (mode_tile n 0))
       (cond
         ((= 1 fg) (if (= "" tolu) (set_tile (strcat n "U") "")
                       ;(set_tile (strcat n "U") (rtos tolu 2 4)))
                       (set_tile (strcat n "U") tolu))

                   (if (= "" tolu) (set_tile (strcat n "D") "")
                       ;(set_tile (strcat n "D") (rtos told 2 4))))
                       (set_tile (strcat n "D") told)))

         ((= 2 fg) (if (= "" tolu) (set_tile (strcat n "u") "")
                       ;(set_tile (strcat n "u") (rtos tolu 2 4)))
                       (set_tile (strcat n "u") tolu))

                   (if (= "" tolu) (set_tile (strcat n "d") "")
                       ;(set_tile (strcat n "d") (rtos told 2 4))))
                       (set_tile (strcat n "d") told)))

       );cond
     );progn
  );foreach
)

(defun c:toler_sha(/ ptile)
     (if (and (= jin "#$%")(= #### 85))(setq FFF t))
     (WHILE (/= FFF nil)
            (setq ppss sspp)
            (setvar "cmdecho" 0)

            (setq toluv nil toldv nil)
            (actdcl (strcat powdesign_dcl_path "auxdim") "sha_tol")
            (setq fname (strcat powdesign_data_path "sha_tol.DAT"))

            (act_pop_list size_list "sizetype")

;           (setq dimmode_list (list "XXX±0.05" "XXX(h?)±0.05" "XXX(h?)" "XXX h?±0.05" "XXX h?"))
;           (act_pop_list dimmode_list "dimmode")

            (action_tile "sizetype" "(tol_tile_mode sha_radio_list 1 0)
                                     (setq tolu nil told nil)
            (sel_sizetype 2 sha_radio_list fname)")


            (setq ptile "b9")(tol_tile_mode sha_radio_list 1 1)

            (action_tile "b9"  "(setq tolv 1  toltxt \"b9\")(set_tile ptile \"0\")(set_tile \"b9\"  \"1\")(setq ptile \"b9\") (gettol_val 2 \"b9\") ")
            (action_tile "c9"  "(setq tolv 2  toltxt \"c9\")(set_tile ptile \"0\")(set_tile \"c9\"  \"1\")(setq ptile \"c9\") (gettol_val 2 \"c9\") ")
            (action_tile "d8"  "(setq tolv 3  toltxt \"d8\")(set_tile ptile \"0\")(set_tile \"d8\"  \"1\")(setq ptile \"d8\") (gettol_val 2 \"d8\") ")
            (action_tile "d9"  "(setq tolv 4  toltxt \"d9\")(set_tile ptile \"0\")(set_tile \"d9\"  \"1\")(setq ptile \"d9\") (gettol_val 2 \"d9\") ")
            (action_tile "e7"  "(setq tolv 5  toltxt \"e7\")(set_tile ptile \"0\")(set_tile \"e7\"  \"1\")(setq ptile \"e7\") (gettol_val 2 \"e7\") ")
            (action_tile "e8"  "(setq tolv 6  toltxt \"e8\")(set_tile ptile \"0\")(set_tile \"e8\"  \"1\")(setq ptile \"e8\") (gettol_val 2 \"e8\") ")
            (action_tile "e9"  "(setq tolv 7  toltxt \"e9\")(set_tile ptile \"0\")(set_tile \"e9\"  \"1\")(setq ptile \"e9\") (gettol_val 2 \"e9\") ")
            (action_tile "f6"  "(setq tolv 8  toltxt \"f6\")(set_tile ptile \"0\")(set_tile \"f6\"  \"1\")(setq ptile \"f6\") (gettol_val 2 \"f6\") ")
            (action_tile "f7"  "(setq tolv 9  toltxt \"f7\")(set_tile ptile \"0\")(set_tile \"f7\"  \"1\")(setq ptile \"f7\") (gettol_val 2 \"f7\") ")
            (action_tile "f8"  "(setq tolv 10 toltxt \"f8\")(set_tile ptile \"0\")(set_tile \"f8\"  \"1\")(setq ptile \"f8\") (gettol_val 2 \"f8\") ")
            (action_tile "g5"  "(setq tolv 11 toltxt \"g5\")(set_tile ptile \"0\")(set_tile \"g5\"  \"1\")(setq ptile \"g5\") (gettol_val 2 \"g5\") ")
            (action_tile "g6"  "(setq tolv 12 toltxt \"g6\")(set_tile ptile \"0\")(set_tile \"g6\"  \"1\")(setq ptile \"g6\") (gettol_val 2 \"g6\") ")
            (action_tile "h5"  "(setq tolv 13 toltxt \"h5\")(set_tile ptile \"0\")(set_tile \"h5\"  \"1\")(setq ptile \"h5\") (gettol_val 2 \"h5\") ")
            (action_tile "h6"  "(setq tolv 14 toltxt \"h6\")(set_tile ptile \"0\")(set_tile \"h6\"  \"1\")(setq ptile \"h6\") (gettol_val 2 \"h6\") ")
            (action_tile "h7"  "(setq tolv 15 toltxt \"h7\")(set_tile ptile \"0\")(set_tile \"h7\"  \"1\")(setq ptile \"h7\") (gettol_val 2 \"h7\") ")
            (action_tile "h8"  "(setq tolv 16 toltxt \"h8\")(set_tile ptile \"0\")(set_tile \"h8\"  \"1\")(setq ptile \"h8\") (gettol_val 2 \"h8\") ")
            (action_tile "h9"  "(setq tolv 17 toltxt \"h9\")(set_tile ptile \"0\")(set_tile \"h9\"  \"1\")(setq ptile \"h9\") (gettol_val 2 \"h9\") ")
            (action_tile "js5" "(setq tolv 18 toltxt \"js5\")(set_tile ptile \"0\")(set_tile \"js5\" \"1\")(setq ptile \"js5\")(gettol_val 2 \"js5\") ")
            (action_tile "js6" "(setq tolv 19 toltxt \"js6\")(set_tile ptile \"0\")(set_tile \"js6\" \"1\")(setq ptile \"js6\")(gettol_val 2 \"js6\") ")
            (action_tile "js7" "(setq tolv 20 toltxt \"js7\")(set_tile ptile \"0\")(set_tile \"js7\" \"1\")(setq ptile \"js7\")(gettol_val 2 \"js7\") ")
            (action_tile "k5"  "(setq tolv 21 toltxt \"k5\")(set_tile ptile \"0\")(set_tile \"k5\"  \"1\")(setq ptile \"k5\") (gettol_val 2 \"k5\") ")
            (action_tile "k6"  "(setq tolv 22 toltxt \"k6\")(set_tile ptile \"0\")(set_tile \"k6\"  \"1\")(setq ptile \"k6\") (gettol_val 2 \"k6\") ")
            (action_tile "m5"  "(setq tolv 23 toltxt \"m5\")(set_tile ptile \"0\")(set_tile \"m5\"  \"1\")(setq ptile \"m5\") (gettol_val 2 \"m5\") ")
            (action_tile "m6"  "(setq tolv 24 toltxt \"m6\")(set_tile ptile \"0\")(set_tile \"m6\"  \"1\")(setq ptile \"m6\") (gettol_val 2 \"m6\") ")
            (action_tile "n6"  "(setq tolv 25 toltxt \"n6\")(set_tile ptile \"0\")(set_tile \"n6\"  \"1\")(setq ptile \"n6\") (gettol_val 2 \"n6\") ")
            (action_tile "p6"  "(setq tolv 26 toltxt \"p6\")(set_tile ptile \"0\")(set_tile \"p6\"  \"1\")(setq ptile \"p6\") (gettol_val 2 \"p6\") ")
            (action_tile "r6"  "(setq tolv 27 toltxt \"r6\")(set_tile ptile \"0\")(set_tile \"r6\"  \"1\")(setq ptile \"r6\") (gettol_val 2 \"r6\") ")
            (action_tile "s6"  "(setq tolv 28 toltxt \"s6\")(set_tile ptile \"0\")(set_tile \"s6\"  \"1\")(setq ptile \"s6\") (gettol_val 2 \"s6\") ")
            (action_tile "t6"  "(setq tolv 29 toltxt \"t6\")(set_tile ptile \"0\")(set_tile \"t6\"  \"1\")(setq ptile \"t6\") (gettol_val 2 \"t6\") ")
            (action_tile "u6"  "(setq tolv 30 toltxt \"u6\")(set_tile ptile \"0\")(set_tile \"u6\"  \"1\")(setq ptile \"u6\") (gettol_val 2 \"u6\") ")
            (action_tile "x6"  "(setq tolv 31 toltxt \"x6\")(set_tile ptile \"0\")(set_tile \"x6\"  \"1\")(setq ptile \"x6\") (gettol_val 2 \"x6\") ")

           ;(action_tile "cancel" "(setq tolu nil told nil)(done_dialog)")
           ;(action_tile "accept" "(done_dialog)")

            (action_tile "accept" "(dimtol_type)(done_dialog)")
            (action_tile "cancel" "(setq tolu nil told nil toluv nil)(done_dialog)")

            (start_dialog)

            (if toluv
              (progn
                (setq entname nil)
                (cond
                  ((= 1 modetyp)(toler_ok))
                  ((= 2 modetyp)(aDDdimtxt "" (strcat "(" toltxt ")"))(toler_ok2))
                  ((= 3 modetyp)(adddimtxt "" (strcat "(" toltxt ")")))
                  ((= 4 modetyp)(adddimtxt "" toltxt)(toler_ok2))
                  ((= 5 modetyp)(adddimtxt "" toltxt))
                );cond
                (if entname
                     (cond
                       ((= 1 modetyp)(adxdata_auxdim "DIM" 1000 toltxt))
                       ((= 2 modetyp)(adxdata_auxdim "DIM" 1000 (strcat "(" toltxt ")")))
                       ((= 3 modetyp)(adxdata_auxdim "DIM" 1000 (strcat "(" toltxt ")")))
                       ((= 4 modetyp)(adxdata_auxdim "DIM" 1000 toltxt))
                       ((= 5 modetyp)(adxdata_auxdim "DIM" 1000 toltxt))
                     )
                );if
              );progn
            )
;            (if toluv
;              (progn
;                (setq $toluv toluv $toldv toldv)
;                (cond
;                  ((= 1 modetyp)
;                      (toler_ok)
;                      (while up_dim
;                             (setq toluv $toluv toldv $toldv)
;                             (toler_ok)
;                      )
;                  )
;                  ((= 2 modetyp)
;                      (adddimtxt "" (strcat "(" toltxt ")"))
;                      (if beselent (toler_ok2))
;                      (while beselent
;                             (adddimtxt "" (strcat "(" toltxt ")"))
;                             (setq toluv $toluv toldv $toldv)
;                             (if beselent (toler_ok2))
;                      );while
;                  )
;                  ((= 3 modetyp)
;                      (adddimtxt "" (strcat "(" toltxt ")"))
;                      (while beselent
;                             (adddimtxt "" (strcat "(" toltxt ")"))
;                      );while
;                  )
;                  ((= 4 modetyp)
;                      (adddimtxt "" toltxt)
;                      (if beselent (toler_ok2))
;                      (while beselent
;                             (adddimtxt "" toltxt)
;                             (setq toluv $toluv toldv $toldv)
;                             (if beselent (toler_ok2))
;                      );while
;                  )
;                  ((= 5 modetyp)
;                      (adddimtxt "" toltxt)
;                      (while beselent
;                             (adddimtxt "" toltxt)
;                      );while
;                  )
;                );cond
;              );progn
;            )

            (setvar "cmdecho" 1)
            (SETQ FFF nil)
     )
     (prin1)
)

;;┌────────────────────────────────┐
;;│ 程  式 : 改變為公差尺寸標註                                    │
;;│ 主程式 : chg_dim.lsp                                           │
;;│ 日  期 : 88:01:20                                              │
;;│ 姓  名 : 佘宗紋                                                │
;;│ 對話框 : chg_dim.dcl                                           │
;;│ 方  法 : 輸入正負公差後點取欲更改之尺寸                        │
;;│                                                                │
;;└────────────────────────────────┘
(defun c:chg_dim(/ dcl_id tolnum_list)
(if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "dimtdec" 8)
   (defun *error* (msg)
      (princ msg)
      (setvar "dimtzin" dim_tzin)
      (setvar "dimtfac" cl_tfac)
      (setvar "dimtol" 0)
      (redraw)
   )
  (setq dcl_pt '(-1 -1))
  (setq dcl_id (load_dialog (STRCAT powdesign_dcl_path "auxdim.dcl")))
  (new_dialog "chg_dim" dcl_id)
  (if (< dcl_id 0) (exit))
  (setq fun_id 0)
  (setq cl_tol(getvar "dimtol"))
  (setq dim_tzin(getvar "dimtzin"))
  (setq cl_tfac(getvar "dimtfac"))
  (setq dimsc(getvar "dimscale"))
; (setq tolnum_list (list "1" "2" "3" "4" "5" "6" "7" "8"))
; (act_pop_list tolnum_list "tolnum")

   (action_tile "accept" "(chg_dim_accept_ok)")
   (action_tile "cancel" "(done_dialog 0)")
   (start_dialog)
   (if (= fun_id 1)
       (progn
            (chg_dim_ok tol_up tol_down)
            (while up_dim
                 (chg_dim_ok tol_up tol_down)
            );while
       );progn
   );if
   (setvar "dimtzin" dim_tzin)
   (setvar "dimtfac" cl_tfac)
   (setvar "dimtol" cl_tol)
   (redraw)
  (SETQ FFF nil))
      (princ)
);defun


 (defun chg_dim_accept_ok()
    (setvar "dimtol" 1)
    (setvar "dimtzin" 8)
    (setq tol_up (get_tile "up"))
    (setq tol_down (get_tile "down"))
;   (setq tolnum (nth (atoi (get_tile "tolnum")) tolnum_list))
;   (setvar "dimtdec" (atoi tolnum))
    (setvar "dimtfac" 0.8)


    (cond
         ((or (= tol_up "") (= tol_down "")) (set_tile "error" "警告:輸入不完整請重新輸入!"))
     ;   ((= (substr tol_up 1 1) "+") (set_tile "error" "警告:上公差輸入錯誤請重新輸入!"))
     ;   ((= (substr tol_down 1 1) "+") (set_tile "error" "警告:下公差輸入錯誤請重新輸入!"))
         ((< (atof tol_up) (atof tol_down))(set_tile "error" "警告:上公差不可小於下公差請重新輸入!"))
         (t (setq fun_id 1)

            (setq chkid (substr tol_up 1 1))
            (if (= "+" chkid) (setq tol_up (substr tol_up 2)))

            (setq chkid (substr tol_down 1 1))
            (cond
               ((= "-" chkid) (setq tol_down (substr tol_down 2)))
               ((= "+" chkid) (setq tol_down (strcat "-" tol_down 2)))
               (t (setq tol_down (strcat "-" tol_down)))
            )
            (done_dialog 1)
         )
    );cond
  );defun

;**************************
;修改未編輯過文字之尺寸公差
;**************************
 (defun chg_dim_ok(tol_up tol_down)
          (setq up_dim(entsel "\n選取欲變更之尺寸"))
          (setq updim_data (entget (car up_dim)))
          (setq olddim (assoc 1 updim_data))
          (if up_dim
              (cond
        ;         ((/= (cdr (assoc 0 (entget (car up_dim)))) "DIMENSION")(chg_dim_errmsg))
                 ((/= (cdr (assoc 0 updim_data)) "DIMENSION")(chg_dim_errmsg))
        ;         ((or (= (cdr (assoc 1 (entget (car up_dim)))) "") (= (substr (cdr (assoc 1 (entget (car up_dim)))) (- (strlen(cdr (assoc 1 (entget (car up_dim))))) 1) 2) "<>"))
                 ((or (= (cdr (assoc 1 updim_data)) "") (= (substr (cdr (assoc 1 updim_data)) (- (strlen(cdr (assoc 1 updim_data))) 1) 2) "<>"))
                    (setvar "dimtp" (atof tol_up))
                    (setvar "dimtm" (atof tol_down))
        ;            (setvar "dimtp" (atof tol_up))
        ;            (setvar "dimtm" (- 0 (atof tol_down)))
                    (command "dim")
                    (command "update" up_dim "")
                    (command "exit")
                 )
                 ((and (wcmatch (cdr olddim) "*<*") (wcmatch (cdr olddim) "*>*")
                       (null (wcmatch (cdr olddim) "*{*")) (null (wcmatch (cdr olddim) "*}*")))
                       (setq newdim(cons 1 ""))

                    (setvar "dimtp" (atof tol_up))
                    (setvar "dimtm" (atof tol_down))
         ;           (setvar "dimtp" (atof tol_up))
         ;           (setvar "dimtm" (- 0 (atof tol_down)))
                    (command "dim")
                    (command "update" up_dim "")
                    (command "exit")
                 )
                 ((/= (cdr (assoc 1 updim_data)) "") (chg_dim_edited_txt))
               );cond
               (princ "\n未選到任何圖元!")
          );if
 );defun ok
       (defun chg_dim_errmsg()
                    (new_dialog "err" dcl_id)
                    (action_tile "accept" "(done_dialog)")
                    (start_dialog)
                    (unload_dialog dcl_id)
        )

;**************************
;修改已編輯過文字之尺寸公差
;**************************

(defun chg_dim_edited_txt()
   (setq dimsc(getvar "dimscale"))
   (setq tol_h(rtos (* dimsc (* 0.8 (getvar "dimtxt"))) 2 6))
     (setq ent_data(entget(car up_dim)))
   (setq dim_txtstr(assoc 1 ent_data))
   (setq te(cdr dim_txtstr))
   (setq str_len(strlen te))
      (if (= (substr te 1 1) "{")(setq dim_int(substr te 2 (- str_len 2)))
           (setq dim_int(substr te 1))
      );if
 
       (if (< str_len 20)  (setq str_ing dim_int)  ;r13
 
              (progn
                    (setq n 1)
                    (setq fg nil)
                      (while (/= fg 1)
                           (setq keystr(substr te n 1))
                              (if (= keystr ";")(setq start_no (+ n 1)))
                              (if (= keystr "{")(setq fg 1 end_no n))
                            (setq n(+ n 1))
                      );while
                  (setq str_ing(substr te start_no (- end_no start_no)))
              );progn
        );if
           (if (/= (substr tol_up 1 1) "-")(setq tole_up (strcat "+" tol_up)))
           (if (= (substr tol_up 1 1) "-")(setq tole_up tol_up))
           (if (/= (substr tol_down 1 1) "-")(setq tole_down (strcat "-" tol_down)))
           (if (= (substr tol_down 1 1) "-")(setq tole_down (strcat "+" (substr tol_down 2))))

           (if (zerop (atof tole_up))(setq tole_up (strcat " " (substr tole_up 2))))
           (if (zerop (atof tole_down))(setq tole_down (strcat " " (substr tole_down 2))))

   (if (/=  tol_up tol_down)
     (setq new_str(strcat "\\A1;" str_ing "{\\H" tol_h ";\\S" tole_up "^" tole_down ";}"))
     (setq new_str(strcat "\\A1;" str_ing "{\\H" tol_h "%%p" tol_up "}"))
   )
   (setq newdata(cons 1 new_str))
   (setq ent_newdata(subst newdata dim_txtstr ent_data))
    (entmod ent_newdata)
)

;CNS 加工符號
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 1. 1527                                                                 ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明:                                                                               ║
;║                                                                                        ║
;║執行方式:                                                                               ║
;║相關檔案:pub-lisp.lsp                                                                   ║
;║                                                                                        ║
;║                                                                                        ║
;╰════════════════════════════════════════════╯

(setq att1_list (list "" "0.0125" "0.025" "0.05" "0.1" "0.2" "0.4" "0.8" "1.6" "3.2" "6.3" "12.5" "25" "50"
                      "N1" "N2" "N3" "N4" "N5" "N6" "N7" "N8" "N9" "N10" "N11" "N12"))
(setq att2_list (list "" "車" "銑" "刨" "搪" "鑽" "絞" "攻" "拉" "輪磨" "搪光" "研光" "拋光" "擦光" "砂光" "滾磨" "鋼刷" "挫" "刮" "鑄"
                      "鍛" "落鍛" "壓鑄" "超光" "鋸" "燄割" "擠" "壓光" "抽製" "衝製" "衝孔" "放電" "電化" "化銑" "化削" "雷射" "電化磨"))
(setq att3_list (list "" "＝" "⊥" "×" "Ｍ" "Ｃ" "Ｒ"))
(setq att5_list (list "" "0.08" "0.25" "0.8" "2.5" "8"))


(defun c:out_l_r_arc()
   (initget 1 "1 2")
   (setq rorl (getkword "\n(1) 左括號 ( (2) 右括號 ) :"))

   (if (null bs) (setq bs 3 bst bs)(setq bst bs))
   (setq bs (getdist (strcat "\n放大倍數<" (rtos bs 2 1) ">: ")))
   (if (null bs) (setq bs bst))
   (if (= "1" rorl)
    (progn
     (command "insert" (strcat powdesign_dwg_path "fflc") "0,0,0" bs bs "0")
     (setq arcent (entlast))
    );progn
    (progn
     (command "insert" (strcat powdesign_dwg_path "ffrc") "0,0,0" bs bs "0")
     (setq arcent (entlast))
    );progn
   )
   (command "move" arcent "" "0,0,0")
   (setq arcent nil)(princ)
)


(defun c:out_cns_finish(/ cnssymble symdata insp scal ang syml)
  (if (null uline)(setq uline "Yes"))
  (initget "Yes No")
  (setq uline (getkword (strcat "\n是否加底線<" uline ">:")))
  (if (null uline)(setq uline "Yes"))

  (setq cnssymble (entsel "\n選擇圖面上的 CNS 加工符號: "))
  (if (/= nil cnssymble)
    (progn
       (setq symdata (entget (car cnssymble)))
       (if (= "INSERT" (cdr (assoc 0 symdata)))
          (progn
             (setq insp (cdr (assoc 10 symdata)))
             (setq scal (cdr (assoc 41 symdata)))
             (setq ang (cdr (assoc 50 symdata)))
             (if (null bs) (setq bs 3 bst bs)(setq bst bs))
             (setq bs (getdist (strcat "\n放大倍數<" (rtos bs 2 1) ">: ")))
             (if (null bs) (setq bs bst))

             (command "copy" cnssymble "" insp insp)
             (command "scale" "l" "" insp bs)
             (setq syml (entlast))
             (if (= 0 ang)
               (progn
                 (setq oldcol (getvar "cecolor"))
                 (setq oldlty (getvar "celtype"))
                 (setq oldlay (getvar "clayer"))
                 (setq oldos (getvar "osmode"))
                 (setvar "osmode" 0)
                 (c:&d&)
                 (if (= "Yes" uline) (command "line" (polar insp pi (* bs 1.5)) (polar insp 0 (* bs 1.5)) ""))
;                (if (= "Yes" uline) (command "line" (polar insp pi (* (/ 1 base_dimscale) bs 1.5)) (polar insp 0 (* (/ 1 base_dimscale)  bs 1.5)) ""))
                 (setvar "cecolor" oldcol)
                 (setvar "celtype" oldlty)
                 (setvar "clayer" oldlay)
                 (setvar "osmode" oldos)
                 (command "move" syml "l" "" insp)
               );progn
               (progn
                 (command "rotate" "l" "" insp (- 0 (rtd ang)))
                 (setq oldcol (getvar "cecolor"))
                 (setq oldlty (getvar "celtype"))
                 (setq oldlay (getvar "clayer"))
                 (c:&d&)
                 (if (= "Yes" uline) (command "line" (polar insp pi (* bs 1.5)) (polar insp 0 (* bs 1.5)) ""))
                 (setvar "cecolor" oldcol)
                 (setvar "celtype" oldlty)
                 (setvar "clayer" oldlay)
                 (command "move" syml "l" "" insp)
               );progn
             )
          );progn
       );if
    );progn
  )
)



(defun c:cns_finish()
(if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setvar "cmdecho" 1)
 (actdcl (strcat powdesign_dcl_path "auxdim") "cns_finish")

 (setq f00 nil f01 nil f02 nil f03 nil f04 nil)
 (cns_fin_mode 1 1 1 1 1)

 (show_sld_col "cnsf00" (strcat  powdesign_sld_path "cnsf00") -2)
 (show_sld_col "cnsf01" (strcat  powdesign_sld_path "cnsf01") -2)
 (show_sld_col "cnsf02" (strcat  powdesign_sld_path "cnsf02") -2)
 (show_sld_col "cnsf03" (strcat  powdesign_sld_path "cnsf03") -2)
 (show_sld_col "cnsf04" (strcat  powdesign_sld_path "cnsf04") -2)

 (act_pop_list att1_list "att1")
 (act_pop_list att2_list "att2")
 (act_pop_list att3_list "att3")
 (act_pop_list att5_list "att5")

 (action_tile "cnsf00" "(setq f00 t f01 nil f02 nil f03 nil f04 nil)(cns_fin_mode 0 1 1 1 1)")
 (action_tile "cnsf01" "(setq f01 t f00 nil f02 nil f03 nil f04 nil)(cns_fin_mode 0 1 0 0 0)")
 (action_tile "cnsf02" "(setq f02 t f00 nil f01 nil f03 nil f04 nil)(cns_fin_mode 0 1 0 0 0)")
 (action_tile "cnsf03" "(setq f03 t f00 nil f02 nil f01 nil f04 nil)(cns_fin_mode 0 0 0 0 0)")
 (action_tile "cnsf04" "(setq f04 t f00 nil f02 nil f03 nil f01 nil)(cns_fin_mode 0 0 0 0 0)")

 (action_tile "cancel" "(setq tolu nil told nil f00 nil f01 nil f02 nil f03 nil f04 nil)(done_dialog)")
 (action_tile "accept" "(get_fin_att)(done_dialog)")


 (start_dialog)
 (cns_input_pvalue)                                              
 (while p
      (setq p1 (osnap p "nea,per"))
      (setq ang (atof (angtos (angle p1 p ) 0 3)))
      (setq ang1 (- ang 90.000))
      (setvar "attdia" 0)
      (cond
          (f00
             (if (or  (= ang 90)
                      (= ang 180)
                      (and (> ang 90)(< ang 180))
                      (and (> ang 0)(< ang 90))
                  );or    
                  (ins_cnsfin "CNSF00")
                  (ins_cnsfin "CNSF00REV")
              );if              
          );f00
          (f01
             (if (or  (= ang 90)
                      (= ang 180)
                      (and (> ang 90)(< ang 180))
                      (and (> ang 0)(< ang 90))
                  );or    
                  (ins_cnsfin "CNSF01")
                  (ins_cnsfin "CNSF01REV")
              );if
          );f01
          (f02
             (if (or  (= ang 90)
                      (= ang 180)
                      (and (> ang 90)(< ang 180))
                      (and (> ang 0)(< ang 90))
                  );or    
                  (ins_cnsfin "CNSF02")
                  (ins_cnsfin "CNSF02REV")
              );if
          );f02
          (f03
             (if (or  (= ang 90)
                      (= ang 180)
                      (and (> ang 90)(< ang 180))
                      (and (> ang 0)(< ang 90))
                  );or    
                  (ins_cnsfin "CNSF03")
                  (ins_cnsfin "CNSF03REV")
              );if
          );f03
          (f04
             (if (or  (= ang 90)
                      (= ang 180)
                      (and (> ang 90)(< ang 180))
                      (and (> ang 0)(< ang 90))
                  );or    
                  (ins_cnsfin "CNSF04")
                  (ins_cnsfin "CNSF04REV")
              );if
          );f04
          ;(f02 (ins_cnsfin "CNSF02"))
          ;(f03 (ins_cnsfin "CNSF03"))
          ;(f04 (ins_cnsfin "CNSF04"))
      );cond
      (setvar "attdia" 1)
      (setq p (cadr (entsel "\n請選擇插入點: ")))
 );while  
 (setvar "osmode" oldosmode)
 (setvar "cmdecho" 1)
 (SETQ FFF nil));while
 (prin1)
)

 (defun cns_fin_mode(fg1 fg2 fg3 fg4 fg5)
  (mode_tile "att1" fg1)
  (mode_tile "att2" fg2)
  (mode_tile "att3" fg3)
  (mode_tile "att4" fg4)
  (mode_tile "att5" fg5)
 )

(defun get_fin_att()
  (setq att1 (nth (atoi (get_tile "att1")) att1_list))
  (setq att2 (nth (atoi (get_tile "att2")) att2_list))
  (setq att3 (nth (atoi (get_tile "att3")) att3_list))
  (setq att4 (get_tile "att4"))
  (setq att5 (nth (atoi (get_tile "att5")) att5_list))
)

(defun cns_input_pvalue()
     (setq olderr *error*)
     (defun *error* (msg)
          (princ msg)
          (setvar "osmode" oldosmode)
          (setq *error* olderr)
          (prin1)
     );defun
     (setvar "CMDECHO" 0)
;  (setq p (cadr (entsel "\n請選擇插入點: ")))
     (setq oldosmode (getvar "osmode"))
     (setvar "osmode" 0)
     (setq p (cadr (entsel "\n請選擇插入點: ")))
 );defun 

(defun ins_cnsfin(fg)
 
  
      
      (cond
        ((= (strcase fg) "CNSF00")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att1)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att1)
         );if
        );cnsf00
        ((= (strcase fg) "CNSF00REV")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att1)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att1)
         )
        );cnsfoorev
        ((= (strcase fg) "CNSF01")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att5 att1 att4 att3)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att5 att1 att4 att3)
         )
        );CNSFO1
        ((= (strcase fg) "CNSF01REV")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att5 att1 att4 att3)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att5 att1 att4 att3)
         )
        );CNSFO1REV
        ((= (strcase fg) "CNSF02")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att5 att1 att4 att3)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att5 att1 att4 att3)
         )
        )
        ((= (strcase fg) "CNSF02REV")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att5 att1 att4 att3)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att5 att1 att4 att3)
         )
        );cnsf02rev
        ((= (strcase fg) "CNSF03")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att2 att1 att4 att5 att3)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att2 att1 att4 att5 att3)
         )
        )
        ((= (strcase fg) "CNSF03REV")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att2 att1 att4 att5 att3)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att2 att1 att4 att5 att3)
         )
        );CNSF03REV
        ((= (strcase fg) "CNSF04")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att1 att4 att5 att2 att3)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att1 att4 att5 att2 att3)
         )
        )
        ((= (strcase fg) "CNSF04REV")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att1 att4 att5 att2 att3)
             (command "insert" (strcat powdesign_dwg_path fg) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1 att1 att4 att5 att2 att3)
         )
        );CNSF04REV
      );cond
      (setvar "osmode" oldosmode)
      (setvar "CMDECHO" 1)
      (princ)
 
   
);defun  


;JIS 加工符號
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 8. 30                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明:                                                                               ║
;║執行方式:                                                                               ║
;║相關檔案:pub-lisp.lsp                                                                   ║
;╰════════════════════════════════════════════╯
(defun c:jis_finish(/ func os)
(if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setvar "cmdecho" 0)
 (setq os (getvar "osmode"))
 (setvar "osmode" 0)
 (setq olderr *error*)

 (defun *error* (msg)
    (princ msg)
    (setvar "osmode" os)
    (setq *error* olderr)
    (prin1)
 )

 (actdcl (strcat powdesign_dcl_path "auxdim") "jis_finish")

 (show_sld_col "jisf00" (strcat  powdesign_sld_path "jisf00") -2)
 (show_sld_col "jisf01" (strcat  powdesign_sld_path "jisf01") -2)
 (show_sld_col "jisf02" (strcat  powdesign_sld_path "jisf02") -2)
 (show_sld_col "jisf03" (strcat  powdesign_sld_path "jisf03") -2)
 (show_sld_col "jisf04" (strcat  powdesign_sld_path "jisf04") -2)
 (show_sld_col "jisf05" (strcat  powdesign_sld_path "jisf05") -2)
 (show_sld_col "jisf06" (strcat  powdesign_sld_path "jisf06") -2)
 (show_sld_col "jisf07" (strcat  powdesign_sld_path "jisf07") -2)
 (show_sld_col "jisf08" (strcat  powdesign_sld_path "jisf08") -2)

 (action_tile "jisf00" "(done_dialog)(setq func 0)")
 (action_tile "jisf01" "(done_dialog)(setq func 1)")
 (action_tile "jisf02" "(done_dialog)(setq func 2)")
 (action_tile "jisf03" "(done_dialog)(setq func 3)")
 (action_tile "jisf04" "(done_dialog)(setq func 4)")
 (action_tile "jisf05" "(done_dialog)(setq func 5)")
 (action_tile "jisf07" "(done_dialog)(setq func 7)")
 (action_tile "jisf08" "(done_dialog)(setq func 8)")
 (action_tile "jisf06" "(done_dialog)(setq func 6)")
 (action_tile "accept" "(done_dialog)")
 (start_dialog)
 (cond
   ((= 0 func) (ins_finish "f00s"))
   ((= 1 func) (ins_finish "f01s"))
   ((= 2 func) (ins_finish "f02s"))
   ((= 3 func) (ins_finish "f03s"))
   ((= 4 func) (ins_finish "f04s"))
   ((= 5 func) (ins_finish "f05s"))
   ((= 7 func) (ins_finish "f06s"))
   ((= 8 func) (ins_finish "f07s"))
   ((= 6 func) (ff1))
 )
 (setvar "osmode" os)
 (setq *error* olderr)
 (setvar "cmdecho" 1)
  (SETQ FFF nil))
 (prin1)
)

(defun ins_finish(typ / ang1 p p1)
   (c:&d&)
;  (command "exit")
   (setvar "osmode" 0)
   (setvar "pickbox" 5)
   (setq p (cadr (entsel "\n請選擇插入點: ")))
   (setvar "cmdecho" 0)
   (while p
     (setq p1 (osnap p "nea,per"))
     (setq ang (rtd (angle p1 p )))
     (setq ang1 (- ang 90.000))
     (cond
       ((and (< ang1 270)(> ang1 90)(= typ "f04s"))
          (if (= acad_ver "GENIUS")
              (command ".insert" (strcat POWDESIGN_dwg_path "f04s1") p1 (getvar "dimscale") "" ang1)
              (command "insert" (strcat POWDESIGN_dwg_path "f04s1") p1 (getvar "dimscale") "" ang1)
          )
       )
       ((and (< ang1 270)(> ang1 90)(= typ "f05s"))
          (if (= acad_ver "GENIUS")
              (command ".insert" (strcat POWDESIGN_dwg_path "f05s1") p1 (getvar "dimscale") "" ang1)
              (command "insert" (strcat POWDESIGN_dwg_path "f05s1") p1 (getvar "dimscale") "" ang1)
          )
       )
       ((and (< ang1 270)(> ang1 90)(= typ "f06s"))
          (if (= acad_ver "GENIUS")
              (command ".insert" (strcat POWDESIGN_dwg_path "f06s1") p1 (getvar "dimscale") "" ang1)
              (command "insert" (strcat POWDESIGN_dwg_path "f06s1") p1 (getvar "dimscale") "" ang1)
          )
       )
       ((and (< ang1 270)(> ang1 90)(= typ "f07s"))
          (if (= acad_ver "GENIUS")
              (command ".insert" (strcat POWDESIGN_dwg_path "f07s1") p1 (getvar "dimscale") "" ang1)
              (command "insert" (strcat POWDESIGN_dwg_path "f07s1") p1 (getvar "dimscale") "" ang1)
          )
       )
       (t
          (if (= acad_ver "GENIUS")
              (command ".insert" (strcat POWDESIGN_dwg_path typ) p1 (getvar "dimscale") "" ang1)
              (command "insert" (strcat POWDESIGN_dwg_path typ) p1 (getvar "dimscale") "" ang1)
          )
       )
     );cond
;     (if (= acad_ver "GENIUS")
;         (command ".insert" (strcat POWDESIGN_dwg_path typ) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1)
;         (command "insert" (strcat POWDESIGN_dwg_path typ) p1 (* (/ 1 base_dimscale) (getvar "dimscale")) "" ang1)
;     )
     (setq p (cadr (entsel "\n請選擇插入點: ")))
   );while
   (princ "\n按 Enter 鍵後, 繼續選擇其他符號!")
;   (setvar "cmdecho" 0)
  (princ)
)

(defun ff1(/ fff_flag)

    (setvar "cmdecho" 0)
    (actdcl (strcat powdesign_dcl_path "auxdim") "ff")
    (ff_fin)

    (action_tile "f0" "(set_tile \"error\" \"\")(sel_another)(show_selblk)")

    (action_tile "accept" "(fff_ok)")
    (action_tile "cancel" "(done_dialog)(setq fff_flag nil)")

    (start_dialog)

    (if fff_flag (exe_insjinblk))

;    (setvar "cmdecho" 1)
    (PRINC)
)

(defun exe_insjinblk()
   (setq scal (getvar "dimscale"))
   (setq sss (* 0.5 scal))
   (setq oldos (getvar "osmode"))
   (setq p1 (getpoint "\n請選擇插入點:"))
   (setvar "osmode" 0)

   (command "insert" (strcat powdesign_dwg_path (nth 1 (assoc outff blk_datalist))) p1 (* (/ 1 base_dimscale) sss)(* (/ 1 base_dimscale) sss) "")
   (setq tdist (nth 2 (assoc outff blk_datalist)))
   (if (/= haveblk_list nil)
     (progn
        (command "insert" (strcat powdesign_dwg_path "fflc") (polar p1 0 (* (/ 1 base_dimscale) scal tdist)) (* (/ 1 base_dimscale) scal) (* (/ 1 base_dimscale) scal)  "")
        (setq tdist (+ tdist 5))
        (foreach nn haveblk_list
           (progn
             (command "insert" (strcat powdesign_dwg_path (nth 1 (assoc nn blk_datalist))) (polar p1 0 (* (/ 1 base_dimscale)  scal tdist))  (* (/ 1 base_dimscale) sss) (* (/ 1 base_dimscale) sss)  "")
             (setq tdist (+ tdist (nth 2 (assoc nn blk_datalist))))
           );progn
        );foreach
        (command "insert" (strcat powdesign_dwg_path "ffrc") (polar p1 0 (* (/ 1 base_dimscale)  scal (+ 3 tdist))) (* (/ 1 base_dimscale) scal)(* (/ 1 base_dimscale) scal)  "")
     );progn
   );if
   (setvar "osmode" oldos)
)



(defun fff_ok()
    (if (null outff)
       (set_tile "error" "整體性加工符號未選取! 請再選擇!!")
       (progn (setq fff_flag t) (done_dialog))
    )
)

(defun show_selblk()
  (if (/= nil outff)
    (show_sld_col "f0" (strcat powdesign_sld_path (nth 1 (assoc outff blk_datalist))) -2)
  )

)
(defun sel_another()
    (actdcl (strcat powdesign_dcl_path "auxdim") "ff1")
    (set_tile "error" "請選擇一項!")
    (setq outff nil)
    (setq count 1)
    (foreach nn noblk_list
       (progn
         (show_sld_col (strcat "f" (rtos count 2 0)) (strcat powdesign_sld_path (nth 1 (assoc nn blk_datalist))) -2)
         (setq count (1+ count))
       );progn
    );foreach
    (repeat (- 9 count)
      (show_sld_col (strcat "f" (rtos count 2 0)) (strcat powdesign_sld_path "none") 252)
      (mode_tile (strcat "f" (rtos count 2 0)) 1)
      (setq count (1+ count))
    )
    (action_tile "f1" "(setq outff (nth 0 noblk_list))")
    (action_tile "f2" "(setq outff (nth 1 noblk_list))")
    (action_tile "f3" "(setq outff (nth 2 noblk_list))")
    (action_tile "f4" "(setq outff (nth 3 noblk_list))")
    (action_tile "f5" "(setq outff (nth 4 noblk_list))")
    (action_tile "f6" "(setq outff (nth 5 noblk_list))")
    (action_tile "f7" "(setq outff (nth 6 noblk_list))")
    (action_tile "f8" "(setq outff (nth 7 noblk_list))")
    (action_tile "accept" "(sel_another_ok)")
    (start_dialog)
    (PRINC)
)

(defun sel_another_ok()
    (if (null outff)
       (set_tile "error" "符號未選取! 請再選擇!!")
    )
)

(defun ff_fin()
   (setq scal (getvar "dimscale"))

   (setq blk_datalist (list (list "F00S" "f00" 18.8)
                            (list "F01S" "f01" 10.75)
                            (list "F02S" "f02" 16.5)
                            (list "F03S" "f03" 22.5)
                            (list "F06S" "f06" 22.5)
                            (list "F04S" "f04" 22.5)
                            (list "F05S" "f05" 25.5)
                            (list "F07S" "f07" 22.5)))

   (setq ff (open (strcat powdesign_path "finish.ini") "r"))
   (setq blk_datalist '() data (read-line ff))
   (while data
     (setq blk_datalist (cons (read data) blk_datalist))
     (setq data (read-line ff))
   );while
   (if (/= nil blk_datalist) (setq blk_datalist (reverse blk_datalist)))
   (close ff)


    (show_sld_col "fflc" (strcat powdesign_sld_path "none") 252)
    (show_sld_col "f1" (strcat powdesign_sld_path "none") 252)
    (show_sld_col "f2" (strcat powdesign_sld_path "none") 252)
    (show_sld_col "f3" (strcat powdesign_sld_path "none") 252)
    (show_sld_col "f4" (strcat powdesign_sld_path "none") 252)
    (show_sld_col "f5" (strcat powdesign_sld_path "none") 252)
    (show_sld_col "f6" (strcat powdesign_sld_path "none") 252)
    (show_sld_col "f7" (strcat powdesign_sld_path "none") 252)
    (show_sld_col "f8" (strcat powdesign_sld_path "none") 252)

   (setq haveblk_list '() noblk_list '()
         blk_list (list "F00S" "F01S" "F02S" "F03S" "F06S" "F04S" "F05S" "F07S"))
   (foreach nn blk_list
      (progn
          (setq oldbksel nil)
          (setq bksel (ssget "x" (list (cons 0 "INSERT") (cons 2 nn))))

          (cond
              ((= nn "F04S") (setq oldbksel (ssget "x" (list (cons 0 "INSERT") (cons 2 "F04S1")))))
              ((= nn "F05S") (setq oldbksel (ssget "x" (list (cons 0 "INSERT") (cons 2 "F05S1")))))
              ((= nn "F06S") (setq oldbksel (ssget "x" (list (cons 0 "INSERT") (cons 2 "F06S1")))))
              ((= nn "F07S") (setq oldbksel (ssget "x" (list (cons 0 "INSERT") (cons 2 "F07S1")))))
          )

          (if (or (/= nil bksel)(/= nil oldbksel))
              (setq haveblk_list (cons nn haveblk_list))
              (setq noblk_list (cons nn noblk_list))
          );if
      );progn
   );foreach
   (if (and (/= nil noblk_list) (> (length noblk_list) 1)) (setq noblk_list (reverse noblk_list)))
   (if (/= nil haveblk_list)
      (progn
        (setq haveblk_list (reverse haveblk_list))
        (show_sld_col "fflc" (strcat powdesign_sld_path "fflc")  252)
        (setq count 1)
        (foreach nn haveblk_list
          (progn
            (show_sld_col (strcat "f" (rtos count 2 0)) (strcat powdesign_sld_path (nth 1 (assoc nn blk_datalist) ))  252)
            (setq count (1+ count))
          );progn
        );foreach
        (show_sld_col (strcat "f" (rtos count 2 0)) (strcat powdesign_sld_path "ffrc") 252)
      );progn
   )
)


;;幾何公差基準面
;╭═════════════════════════════════════════════╮
;║設計日期: 1998. 3. 7                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明:                                                                                 ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案:                                                                                 ║
;╰═════════════════════════════════════════════╯
(setq sym_list (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q"
                     "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
(defun c:dim-gbase(/ sym_fg)
(if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setvar "cmdecho" 0)

 (actdcl (strcat powdesign_dcl_path "auxdim") "dim_gbase")

 (show_sld_col "dimgbase" (strcat powdesign_sld_path "dimgbase") -2)

 (act_pop_list sym_list "atoz")

 (mode_tile "input_atoz" 1)

 (action_tile "selbase" "(mode_tile \"input_atoz\" 1)(mode_tile \"atoz\" 0)")
 (action_tile "inputbase" "(mode_tile \"input_atoz\" 0)(mode_tile \"atoz\" 1)")

 (action_tile "accept" "(ok_dim-gbase)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)

 (if sym_fg (draw_gbase))

 (setvar "cmdecho" 1)
  (SETQ FFF nil))
 (prin1)
)


(defun ok_dim-gbase()
  (setq input_type (get_tile "selbase"))
  (if (= "1" input_type)
    (progn
       (setq sym_id (get_tile "atoz"))
       (setq basetxt (nth (atoi sym_id) sym_list))
       (done_dialog)(setq sym_fg t)
    )
    (progn
       (setq basetxt (get_tile "input_atoz"))
       (if (= basetxt "")
         (set_tile "error" "請輸入基準面代號碼!")
         (progn
            (done_dialog)(setq sym_fg t)
         );progn
       );if
    );progn
  );if
);defun

;(defun draw_gbase()
;   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
;  (c:&d&)(command "exit")
;  (setvar "orthomode" 1)
;  (setq scal (getvar "dimscale"))
;  (setvar "osmode" 512)
;
;  (setq ent (entsel "\n從哪一點:  "))
;  (while (null ent)
;    (princ "\n您必須選擇一個圖元當作基準面, 請再選一次...")
;    (setq nt (entsel "\n從哪一點:  "))
;  )
;  (setvar "osmode" 0)
;  (setq bsp (nth 1 ent))
;  (setq bep (getpoint bsp "\n到哪一點: "))
;  (setq ang (angle bsp bep))
;
;  (setq entdata (entget (nth 0 ent)))
;  (if (= (cdr (assoc 0 entdata)) "LINE")
;    (progn
;      (setq 10p (cdr (assoc 10 entdata))
;            11p (cdr (assoc 11 entdata))
;            solbase (polar bsp ang (* scal 2.6))
;            solp1 (polar solbase (+ ang (* pi (/ 5 6.0))) 2)
;            solp2 (polar solbase (+ ang (* pi (/ 7 6.0))) 2)
;            solp1 (inters 10p 11p solbase solp1 nil)
;            solp2 (inters 10p 11p solbase solp2 nil))
;      (command "pline" bsp "w" (* 5.77 scal) "0" (polar bsp ang (* 5 scal)) "w" "0" "0" bep "")
;    )
;   (setvar "cmdecho" 0)
;  )
;
;  (setq bsp bep lastp bep)
;  (while (setq bep (getpoint bsp "\n到哪一點: "))
;    (command "line" bsp bep "")
;    (setq ang (angle bsp bep) bsp bep lastp bep)
;  )
;  (setq bep lastp)
;  (setvar "orthomode" 0)
;  (save_sysvar)
;
;
;  (setq txtp (polar bep ang (* scal 3)))
;  (command "text" "m" txtp (* 3.9 scal) "0" basetxt)
;  (txt_data (entlast))   ;pub-lisp.lsp(txt_data)
;  (if (< txtlen (* scal 6)) (setq txtlen (* scal 6))
;                            (setq txtlen (+ txtlen (* scal 4))))
;
;  (setvar "osmode" 0)
;  (cond
;    ((or (= ang 0) (and (> ang 0) (< ang (* pi 0.5))))
;       (setq p1 (polar bep (* pi 1.5) (* txtlen 0.5))
;             p2 (polar p1 0 txtlen)
;             p3 (polar p2 (* pi 0.5) (* 6 scal))
;             p4 (polar p3 pi txtlen))
;    )
;    ((or (= ang (* pi 0.5))(and (> ang (* pi 0.5)) (< ang pi)))
;       (setq p1 (polar bep pi (* txtlen 0.5))
;             p2 (polar p1 0 txtlen)
;             p3 (polar p2 (* pi 0.5) (* 6 scal))
;             p4 (polar p3 pi txtlen))
;    )
;    ((or (= ang pi) (and (> ang pi) (< ang (* pi 1.5))))
;       (setq p1 (polar bep (* pi 1.5) (* txtlen 0.5))
;             p2 (polar p1 (* 0.5 pi) txtlen)
;             p3 (polar p2 pi (* scal 6))
;             p4 (polar p3 (* 1.5 pi) txtlen))
;    )
;    (T
;       (setq p1 (polar bep pi (* scal 3))
;             p2 (polar p1 0 txtlen)
;             p3 (polar p2 (* pi 1.5) (* scal 6))
;             p4 (polar p3 pi txtlen))
;    )
;  );cond
;  (command "pline" p1 p2 p3 p4 "c")
;  (reset_sysvar)
;   (SETQ FFF nil))
;  (princ)
;)

(defun draw_gbase()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (c:&d&)
  (setvar "orthomode" 1)
  (setq scal (* (/ 1 base_dimscale) (getvar "dimscale")))
  (setq oldos (getvar "osmode"))
  (setvar "osmode" 512)
;  (if (= "15.05" (getvar "acadver")) ;acadlt2000i
;      (setq bsp (getpoint "\n從哪一點:  "))
  (if (= cad_version "INTELLICAD")
      (setq bsp (getpoint "\n從哪一點:  "))
      (progn
            (princ "\n必須靠近圖元 !")
            (setq bsp (osnap (getpoint "\n從哪一點:  ") "nea"))
      );progn

  );if
  (setq bep (getpoint bsp "\n到哪一點: "))
  (setq ang (angle bsp bep))
  (setvar "osmode" 0)
; (command "pline" bsp "w" (* 5.7 scal) "0" (polar bsp ang (* 5 scal)) "w" "0" "0" bep "")
  (command "pline" bsp "w" (* 3 scal) "0" (polar bsp ang (* 3 scal)) "w" "0" "0" bep "")
  (setvar "cmdecho" 0)
  (setq bsp bep lastp bep)
  (while (setq bep (getpoint bsp "\n到哪一點: "))
    (command "line" bsp bep "")
    (setq ang (angle bsp bep) bsp bep lastp bep)
  )
  (setq bep lastp)
  (setvar "orthomode" 0)
  (save_sysvar)


  (setq txtp (polar bep ang (* scal 3)))
  (command "text" "m" txtp (* 3.9 scal) "0" basetxt)
  (txt_data (entlast))   ;pub-lisp.lsp(txt_data)
  (if (< txtlen (* scal 6)) (setq txtlen (* scal 6))
                            (setq txtlen (+ txtlen (* scal 4))))

  (setvar "osmode" 0)
  (cond
    ((or (= ang 0) (and (> ang 0) (< ang (* pi 0.5))))
       (setq p1 (polar bep (* pi 1.5) (* txtlen 0.5))
             p2 (polar p1 0 txtlen)
             p3 (polar p2 (* pi 0.5) (* 6 scal))
             p4 (polar p3 pi txtlen))
    )
    ((or (= ang (* pi 0.5))(and (> ang (* pi 0.5)) (< ang pi)))
       (setq p1 (polar bep pi (* txtlen 0.5))
             p2 (polar p1 0 txtlen)
             p3 (polar p2 (* pi 0.5) (* 6 scal))
             p4 (polar p3 pi txtlen))
    )
    ((or (= ang pi) (and (> ang pi) (< ang (* pi 1.5))))
       (setq p1 (polar bep (* pi 1.5) (* txtlen 0.5))
             p2 (polar p1 (* 0.5 pi) txtlen)
             p3 (polar p2 pi (* scal 6))
             p4 (polar p3 (* 1.5 pi) txtlen))
    )
    (T
       (setq p1 (polar bep pi (* scal 3))
             p2 (polar p1 0 txtlen)
             p3 (polar p2 (* pi 1.5) (* scal 6))
             p4 (polar p3 pi txtlen))
    )
  );cond
  (command "pline" p1 p2 p3 p4 "c")
  (reset_sysvar)
  (setvar "osmode" oldos)
   (SETQ FFF nil))
  (princ)
)

;;基準線
;╭═════════════════════════════════════════════╮
;║設計日期: 1998. 3. 7                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明:                                                                                 ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案:                                                                                 ║
;╰═════════════════════════════════════════════╯
(defun c:bsline(/ bsp bep lastp ang arrang arrl scal)
(if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (save_sysvar)
  (setvar "cmdecho" 0)
  (setvar "osmode" 512)
  (setvar "orthomode" 1)
  (c:&d&)
  (setq bsp (getpoint "\n從哪一點:  "))
  (setvar "osmode" 0)
  (setq bep (getpoint bsp "\n到哪一點: "))
  (command "line" bsp bep "")
  (setq lastp bep ang (angle bsp bep) arrang (angle bep bsp) bsp bep)
  (while (setq bep (getpoint bsp "\n到哪一點: "))
    (command "line" bsp bep "")
    (setq lastp bep ang (angle bsp bep) arrang (angle bep bsp) bsp bep)
  )
  (setq arrl (getvar "dimasz")
        scal (* (/ 1 base_dimscale)(getvar "dimscale")))

; (command "pline" bsp "w" (* 3 g-scal) "0" (polar bsp ang (* 2.6 g-scal)) "w" "0" "0" bep "")
  (command "pline" lastp "w" (* 3 scal) "0" (polar bsp arrang (* 2.6 scal)) "w" "0" "0" "")

  (reset_sysvar)
  (setvar "cmdecho" 1)
  (SETQ FFF nil))
  (princ)
)
;;指引線
;╭═════════════════════════════════════════════╮
;║設計日期: 1998. 3. 7                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明:                                                                                 ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案:                                                                                 ║
;╰═════════════════════════════════════════════╯
(defun c:lealine()
(if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (save_sysvar)
  (setvar "cmdecho" 0)
  (setvar "osmode" 512)
  (c:&d&)
  (setvar "orthomode" 1)
  (setq bsp (getpoint "\n從哪一點:  "))
  (setvar "osmode" 0)
  (setq bep (getpoint bsp "\n到哪一點: "))
  (command "line" bsp bep "")
  (setq lastp bep ang (angle bsp bep) arrang (angle bep bsp) bsp bep)
  (while (setq bep (getpoint bsp "\n到哪一點: "))
    (command "line" bsp bep "")
    (setq lastp bep ang (angle bsp bep) arrang (angle bep bsp) bsp bep)
  )

  (setq arrl (getvar "dimasz")
        scal (* (/ 1 base_dimscale) (getvar "dimscale")))

  (command "pline" lastp "w" "0" (* 0.833 scal) (polar lastp arrang (* scal arrl)) "w" "0" "0" "")

  (reset_sysvar)
  (setvar "cmdecho" 1)
  (SETQ FFF nil))
  (princ)
)


;;幾何公差標註
;╭═════════════════════════════════════════════╮
;║設計日期: 1998.3 .16                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明: 幾何公差標註                                                                    ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: pub-lisp.lsp(txt_data),aux-dim.dcl                                              ║
;╰═════════════════════════════════════════════╯
;c:dimgeo  ==> 結合 tolerance 指令(箭頭)
;c:dimgeo_base  ==> 結合 tolerance 指令(基準面)
;c:dimgeo2 ==> 藝祥發展之系統

(defun c:dimgeo(/ os gap txt scl point_list i)
  (setvar "cmdecho" 0)
  (setq point_list '())
  (save_sysvar)
 ; (setq os (getvar "osmode"))
 ; (setq gap (getvar "dimgap"))
 ; (setq txt (getvar "dimtxt"))
 ; (setq scl (getvar "dimscale"))
  (setq dimst(getvar "dimstyle"))

  (setq oerr *error* *error* te_err)
;  (setvar "dimgap" (* scl 0.35))
;  (setvar "dimtxt" (* scl 2.5))
  (if (= "14" (substr (getvar "acadver") 1 2))
      (setvar "dimblk" ".") ;R14
      (setvar "dimldrblk" ".")
  );if

  (c:&d&)
  (setq bsp (getpoint "\n從哪一點:  "))
  (setvar "osmode" 0)
  (setq point_list(cons bsp point_list))
  (setq bep (getpoint bsp "\n到哪一點: "))
  (setq point_list(cons bep point_list))
  (grdraw bsp bep 2)
;  (command "_leader" bsp bep)
  (setq bsp bep)
  (while (setq bep (getpoint bsp "\n到哪一點: "))
    (grdraw bsp bep 2)
    (setq point_list(cons bep point_list))
    (setq bsp bep)
;    (command bep)
  )
;  (command "A" "" "T")
  (setq point_list(reverse point_list) i 0)
  (command "_leader")
  (repeat (length point_list)
          (command (nth i point_list))
          (setq i (+ i 1))
  );repeat
  (command "A" "" "T")

  (reset_sysvar)
 ; (setvar "osmode" os)
 ; (setvar "dimgap" gap)
 ; (setvar "dimtxt" txt)
  (if (/= "14" (substr (getvar "acadver") 1 2))
      (command "dimstyle" "r" dimst)
  );if
  (redraw)
)

(defun c:dimgeo_base(/ os gap txt scl point_list i)
  (setvar "cmdecho" 0)
  (setq point_list '())

  (save_sysvar)
 ; (setq os (getvar "osmode"))
 ; (setq gap (getvar "dimgap"))
 ; (setq txt (getvar "dimtxt"))
 ; (setq scl (getvar "dimscale"))
  (setq dimst(getvar "dimstyle"))

  (setq oerr *error* *error* te_err)
 ; (setvar "dimgap" (* scl 0.35))
 ; (setvar "dimtxt" (* scl 2.5))
  (if (= "14" (substr (getvar "acadver") 1 2))
      (setvar "dimblk" "_DatumFilled") ;R14
     (if (= "15.05" (getvar "acadver"))
         (setvar "dimldrblk" "基準面填實三角形");R2000i
         (setvar "dimldrblk" "DatumFilled");R2000
      );if
  );if

  (c:&d&)
  (setq bsp (getpoint "\n從哪一點:  "))
  (setvar "osmode" 0)
  (setq point_list(cons bsp point_list))
  (setq bep (getpoint bsp "\n到哪一點: "))
  (setq point_list(cons bep point_list))
  (grdraw bsp bep 2)
;  (command "_leader" bsp bep)
  (setq bsp bep)
  (while (setq bep (getpoint bsp "\n到哪一點: "))
    (grdraw bsp bep 2)
    (setq point_list(cons bep point_list))
    (setq bsp bep)
;    (command bep)
  )
;  (command "A" "" "T")

  (setq point_list(reverse point_list) i 0)
  (command "_leader")
  (repeat (length point_list)
          (command (nth i point_list))
          (setq i (+ i 1))
  );repeat
  (command "A" "" "T")

  (reset_sysvar)
 ; (setvar "osmode" os)
 ; (setvar "dimgap" gap)
 ; (setvar "dimtxt" txt)
  (if (/= "14" (substr (getvar "acadver") 1 2))
      (command "dimstyle" "r" dimst)
      (setvar "dimblk" ".") ;R14
  );if
  (redraw)
)
(defun te_err(msg)
   (if (/= msg "Function cancelled")(princ (strcat "\nError: " msg)))
   (if oerr (setq *error* oerr))
   (reset_sysvar)
 ;  (setvar "osmode" os)
 ;  (setvar "dimgap" gap)
 ;  (setvar "dimtxt" txt)
   (if (/= "14" (substr (getvar "acadver") 1 2))
       (command "dimstyle" "r" dimst)
   );if
   (redraw)
   (princ)
)


;(defun c:dimgeo()
;(if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
;  (setq scal (* (/ 1 base_dimscale) (getvar "dimscale")))
;  (setq bsp (getpoint "\n從哪一點:  "))
;  (setvar "osmode" 0)
;  (setq bep (getpoint bsp "\n到哪一點: "))
;  (setq ang (angle bsp bep))
;
;  (command "pline" bsp "w" "0" (* 0.333 scal (getvar "dimasz")) (polar bsp ang (* scal (getvar "dimasz"))) "w" "0" "0" bep "")
;  (setq joinent (entlast))
;  (setq bsp bep lastp bep)
;  (while (setq bep (getpoint bsp "\n到哪一點: "))
;    (command "line" bsp bep "")
;    (command "pedit" joinent "j" (entlast) ""  "")
;    (setq joinent (entlast))
;    (setq ang (angle bsp bep) bsp bep lastp bep)
;  )
;  (setq bep lastp)
;  (command "tolerance" bep)
;  (setvar "osmode" 1)
;  (SETQ FFF nil))
;  (princ)
;)



(defun dimgeo_err(msg)
   (if (/= msg "Function cancelled")(princ (strcat "\nError: " msg)))
   (if oerr (setq *error* oerr))
   (reset_sysvar)
   (princ)
)
(defun c:dimgeo2(/ geotype gtype dimgeo_fg chk1 chk2 lastkey lastsld)
(if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setvar "cmdecho" 0)

 (actdcl (strcat powdesign_dcl_path "auxdim") "dimgeo")
 (act_pop_list sym_list "atoz")

 (geo_sld_mode 5 -2 -2)
 (setq gtype 1)

 (show_sld_col "geo1" (strcat powdesign_sld_path "geo1") -2)
 (show_sld_col "geo2" (strcat powdesign_sld_path "geo2") -2)
 (show_sld_col "geo3" (strcat powdesign_sld_path "geo3")  9)
 (show_sld_col "geo4" (strcat powdesign_sld_path "geo4")  9)
 (show_sld_col "geo5" (strcat powdesign_sld_path "geo5") -2)
 (show_sld_col "geo6" (strcat powdesign_sld_path "geo6") -2)
 (show_sld_col "geo7" (strcat powdesign_sld_path "geo7")  9)
 (show_sld_col "geo8" (strcat powdesign_sld_path "geo8")  9)
 (show_sld_col "geo9" (strcat powdesign_sld_path "geo9")  -2)
 (show_sld_col "geo14" (strcat powdesign_sld_path "geo14") -2)
 (show_sld_col "geo10" (strcat powdesign_sld_path "geo10") 9)
 (show_sld_col "geo11" (strcat powdesign_sld_path "geo11") -2)
 (show_sld_col "geo12" (strcat powdesign_sld_path "geo12") -2)
 (show_sld_col "geo13" (strcat powdesign_sld_path "geo13") 9)
;(geo_tile_mode 0 1 1)


 (action_tile "geotype1" "(setq gtype 1 geotype nil)(geo_sld_mode 5 -2 -2)(geo_sld1_mode -2 -2 9 9 -2 -2 9 9 -2 9 -2 -2 9 -2)(geo_tile_mode 0 0 0)")
 (action_tile "geotype2" "(setq gtype 2 geotype nil)(geo_sld_mode -2 5 -2)(geo_sld1_mode -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2)(geo_tile_mode 0 0 1)")
 (action_tile "geotype3" "(setq gtype 3 geotype nil)(geo_sld_mode -2 -2 5)(mode_tile \"max2\" 1)(geo_sld1_mode 9 9 9 9 9 9 9 9 9 9 9 9 9 9)(geo_tile_mode 1 0 1)")


 (action_tile "geo1"  "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo1\" lastsld \"geo1\" lastkey \"geo1\")(ttshow \"geo1\")")
 (action_tile "geo2"  "(set_tile \"val\" \"%%c\")(lastksl lastkey lastsld)(setq geotype \"geo2\" lastsld \"geo2\" lastkey \"geo2\")(ttshow \"geo2\")")
 (action_tile "geo5"  "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo5\" lastsld \"geo5\" lastkey \"geo5\")(ttshow \"geo5\")")
 (action_tile "geo6"  "(set_tile \"val\" \"%%c\")(lastksl lastkey lastsld)(setq geotype \"geo6\" lastsld \"geo6\" lastkey \"geo6\")(ttshow \"geo6\")")
 (action_tile "geo11" "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo11\" lastsld \"geo11\" lastkey \"geo11\")(ttshow \"geo11\")")
 (action_tile "geo12" "(set_tile \"val\" \"%%c\")(lastksl lastkey lastsld)(setq geotype \"geo12\" lastsld \"geo12\" lastkey \"geo12\")(ttshow \"geo12\")")

 (action_tile "geo9"  "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo9\" lastsld \"geo9\" lastkey \"geo9\")(ttshow \"geo9\")")
 (action_tile "geo14" "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo14\" lastsld \"geo14\" lastkey \"geo14\")(ttshow \"geo14\")")

 (action_tile "geo3"  "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo3\" lastsld \"geo3\" lastkey \"geo3\")(ttshow \"geo3\")")
 (action_tile "geo4"  "(set_tile \"val\" \"%%c\")(lastksl lastkey lastsld)(setq geotype \"geo4\" lastsld \"geo4\" lastkey \"geo4\")(ttshow \"geo4\")")
 (action_tile "geo7"  "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo7\" lastsld \"geo7\" lastkey \"geo7\")(ttshow \"geo7\")")
 (action_tile "geo8"  "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo8\" lastsld \"geo8\" lastkey \"geo8\")(ttshow \"geo8\")")
 (action_tile "geo10" "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo10\" lastsld \"geo10\" lastkey \"geo10\")(ttshow \"geo10\")")
 (action_tile "geo13" "(set_tile \"val\" \"\")(lastksl lastkey lastsld)(setq geotype \"geo13\" lastsld \"geo13\" lastkey \"geo13\")(ttshow \"geo13\")")


 (action_tile "accept" "(dimgeo_ok)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)

 (if dimgeo_fg (draw_dimgeo))

 (setvar "cmdecho" 1)
  (SETQ FFF nil))
 (prin1)
)


(defun ttshow(geotype)
  (show_sld_col geotype (strcat powdesign_sld_path geotype) 5)
)


(defun lastksl(lastkey lastsld)
   (if (and lastsld lastkey) (show_sld_col lastkey (strcat powdesign_sld_path lastsld) -2))

)

(defun def_tol_tgap()
   (setq txt_ml_st_gap (* scal gap)
         txt_ml_end_gap (* scal gap)
         txt_mr_st_gap (* scal gap)
         txt_mr_end_gap (* scal gap)
         sym_dist (* scal txth))

)


(defun draw_dimgeo()
  (c:&d&)
  (setvar "orthomode" 1)
  (setq scal (getvar "dimscale"))
  (setq gap (* scal (getvar "dimgap")))
  (setq txth (* scal (getvar "dimtxt")))
  (save_sysvar)
  (setq oerr *error* *error* dimgeo_err)

  (setvar "osmode" 512)

  (def_tol_tgap)

  (setq bsp (getpoint "\n從哪一點:  "))
  (setvar "osmode" 0)
  (setq bep (getpoint bsp "\n到哪一點: "))
  (setq ang (angle bsp bep))

  (command "pline" bsp "w" "0" (* 0.333 scal (getvar "dimasz")) (polar bsp ang (* scal (getvar "dimasz"))) "w" "0" "0" bep "")
  (setq joinent (entlast))
  (setq bsp bep lastp bep)
  (while (setq bep (getpoint bsp "\n到哪一點: "))
    (command "line" bsp bep "")
    (command "pedit" joinent "j" (entlast) ""  "")
    (setq joinent (entlast))
    (setq ang (angle bsp bep) bsp bep lastp bep)
  )
  (setq bep lastp)
  (setvar "orthomode" 0)
  (setvar "osmode" 0)
  (setq p1 (polar bep (* pi 1.5) (+ gap (* 0.5 txth) scal))
        p2 (polar bep (* pi 0.5) (+ gap (* 0.5 txth) scal)))
   (if (or (and (>= ang (* pi 1.5)) (< ang (* pi 2))) (and (>= ang 0) (<= ang (* pi 0.5))))
     (progn                       ;;;  0 度
       (cond
         ((= gtype 3)
           (setq geomd (* scal (+ gap txth)))
           (setq txtp (polar bep 0 (* scal gap 1.2)))
           (command "text" "ml" txtp (* scal txth) 0 geoval)
           (txt_data (entlast))
           (setq txt2p (textbox (list (assoc 1 (entget (entlast))))))
           (setq len (- (nth 0 (nth 1 txt2p)) (nth 0 (nth 0 txt2p))))
           (setq p1-1 (polar p1 0 (+ gap txth gap))
                 p2-1 (polar p2 0 (+ gap txth gap)))
            (if geodwg
               (progn
                  (setq geomp (polar bep 0 (+ gap txtlen (* 2 gap) (* 0.5 txth))))
                  (if (= acad_ver "GENIUS")
                      (command ".insert" (strcat powdesign_dwg_path geodwg) geomp (* 1.2 txth scal) (* 1.2 txth scal) "0")
                      (command "insert" (strcat powdesign_dwg_path geodwg) geomp (* 1.2 txth scal) (* 1.2 txth scal) "0")
                  )
                  (setq p3 (polar p2 0 (+ gap txtlen (* 2 gap) (* 1.2 txth scal) gap))
                        p4 (polar p1 0 (+ gap txtlen (* 2 gap) (* 1.2 txth scal) gap)))

               );progn
               (progn
                  (setq p3 (polar p2 0 (+ (* 2.85 gap scal) len))
                        p4 (polar p1 0 (+ (* 2.85 gap scal) len)))
               );progn
            );if
            (command "pline" p1 p2 p3 p4 "c")
        );;(= gtype 3)
        ((= gtype 2)
          (setq symp (polar bep 0 (+ gap (* 0.5 txth)))
                txtp (polar bep 0 (+ gap txth (* 2 gap)))
                p1-1 (polar p1 0 (+ gap txth gap))
                p2-1 (polar p2 0 (+ gap txth gap)))
          (if (= acad_ver "GENIUS")
              (command ".insert" (strcat powdesign_dwg_path geotype) symp txth txth "0")
              (command "insert" (strcat powdesign_dwg_path geotype) symp txth txth "0")
          )
          (command "text" "ml" txtp txth 0 geoval)
          (txt_data (entlast))
          (if  geodwg
            (progn
              (setq geomp (polar bep 0 (+ gap txth (* 2 gap) txtlen (* 1.5 gap) (* 0.5 txth))))
              (if (= acad_ver "GENIUS")
                  (command ".insert" (strcat powdesign_dwg_path geodwg) geomp txth txth "0")
                  (command "insert" (strcat powdesign_dwg_path geodwg) geomp txth txth "0")
              )
              (setq p3 (polar p2 0 (+ gap txth (* 2 gap) txtlen gap txth (* 2 gap)))
                    p4 (polar p1 0 (+ gap txth (* 2 gap) txtlen gap txth (* 2 gap))))
            );progn
            (progn
              (setq p3 (polar p2 0 (+ gap txth (* 2 gap) txtlen (* 2 gap)))
                    p4 (polar p1 0 (+ gap txth (* 2 gap) txtlen (* 2 gap))))
            );progn
          )
          (command "pline" p1 p2 p3 p4 "c")
          (command "pline" p1-1 p2-1 "")
          (princ)
        );;(= gtype 2)
        ((= gtype 1)
           (setq symp (polar bep 0 (+ gap (* 0.5 txth)))
                 txtp (polar bep 0 (+ gap txth (* 2 gap)))
                 p1-1 (polar p1 0 (+ gap txth gap))
                 p2-1 (polar p2 0 (+ gap txth gap)))
           (if (= acad_ver "GENIUS")
               (command ".insert" (strcat powdesign_dwg_path geotype) symp txth txth "0")
               (command "insert" (strcat powdesign_dwg_path geotype) symp txth txth "0")
           )
           (command "text" "ml" txtp txth 0 geoval)
           (txt_data (entlast))
           (if  geodwg
             (progn
               (setq geomp (polar bep 0 (+ gap txth (* 2 gap) txtlen (* 1.5 gap) (* 0.5 txth))))
               (if (= acad_ver "GENIUS")
                   (command ".insert" (strcat powdesign_dwg_path geodwg) geomp txth txth "0")
                   (command "insert" (strcat powdesign_dwg_path geodwg) geomp txth txth "0")
               )
               (setq p2-2 (polar p2 0 (+ gap txth (* 2 gap) txtlen gap txth (* 2 gap)))
                     p1-2 (polar p1 0 (+ gap txth (* 2 gap) txtlen gap txth (* 2 gap))))
               (setq basetxtp (polar bep 0 (+ gap txth (* 2 gap) txtlen gap txth (* 3 gap))))
               (command "text" "ml" basetxtp txth 0 basetxt)
             );progn
             (progn
               (setq p2-2 (polar p2 0 (+ gap txth (* 2 gap) txtlen (* 2 gap)))
                     p1-2 (polar p1 0 (+ gap txth (* 2 gap) txtlen (* 2 gap))))
               (setq basetxtp (polar bep 0 (+ gap txth (* 2 gap) txtlen (* 3 gap))))
               (command "text" "ml" basetxtp txth 0 basetxt)
             );progn
           );if
            (txt_data (entlast))
           (if (= max2 "1")
             (progn
               (setq geomp (polar basetxtp 0 (+ txtlen gap (* 0.5 txth))))
               (if (= acad_ver "GENIUS")
                   (command ".insert" (strcat powdesign_dwg_path "geom") geomp txth txth "0")
                   (command "insert" (strcat powdesign_dwg_path "geom") geomp txth txth "0")
               )
               (setq refp (polar geomp 0 (+ (* 0.5 txth) gap))
                     p3 (polar refp (* pi 0.5) (* 0.5 (distance p1 p2)))
                     p4 (polar refp (* pi 1.5) (* 0.5 (distance p1 p2))))

             );progn
             (progn
               (setq refp (polar basetxtp 0 (+ txtlen (* 2 gap)))
                     p3 (polar refp (* pi 0.5) (* 0.5 (distance p1 p2)))
                     p4 (polar refp (* pi 1.5) (* 0.5 (distance p1 p2))))
             );progn
           );if
             (command "pline" p1 p2 p3 p4 "c")
             (command "pline" p1-1 p2-1 "")
             (command "pline" p1-2 p2-2 "")
        );;(= gtype 1)
      );cond
    );progn
    (progn                                 ;;; 180 度
      (cond
        ((= gtype 3)
            (setq p1 (polar bep (* pi 1.5) (+ gap (* 0.5 txth) scal))
                  p2 (polar bep (* pi 0.5) (+ gap (* 0.5 txth) scal)))
            (if geodwg
               (progn
                  (setq geomp (polar bep pi (+ (* 1.5 gap) (* 0.5 txth))))
                  (if (= acad_ver "GENIUS")
                      (command ".insert" (strcat powdesign_dwg_path geodwg) geomp (* 1.2 txth scal) (* 1.2 txth scal) "0")
                      (command "insert" (strcat powdesign_dwg_path geodwg) geomp (* 1.2 txth scal) (* 1.2 txth scal) "0")
                  )
                  (setq txtp (polar geomp pi (+ gap (* 0.5 txth) gap)))
                  (command "text" "mr" txtp txth 0 geoval)
                  (txt_data (entlast))
                  (setq p3 (polar p2 pi (+ gap txth (* 4 gap) txtlen))
                        p4 (polar p1 pi (+ gap txth (* 4 gap) txtlen)))
               );progn
               (progn
                  (setq txtp (polar bep pi gap))
                  (command "text" "mr" txtp txth 0 geoval)
                  (txt_data (entlast))
                  (setq p3 (polar p2 pi (+ txtlen (* 2 gap)))
                        p4 (polar p1 pi (+ txtlen (* 2 gap))))
               );progn
            );if
            (command "pline" p1 p2 p3 p4 "c")
        );(= gtype 3)
        ((= gtype 2)
          (if geodwg
            (progn
              (setq geomp (polar bep pi (+ gap (* 0.5 txth))))
              (if (= acad_ver "GENIUS")
                  (command ".insert" (strcat powdesign_dwg_path geodwg) geomp txth txth "0")
                  (command "insert" (strcat powdesign_dwg_path geodwg) geomp txth txth "0")
              )
              (setq p3 (polar p2 pi (+ gap txth (* 2 gap) txtlen gap txth (* 2 gap)))
                    p4 (polar p1 pi (+ gap txth (* 2 gap) txtlen gap txth (* 2 gap)))
                    txtp (polar geomp pi (+ gap (* 0.5 txth))))
              (command "text" "mr" txtp txth 0 geoval)
              (txt_data (entlast))
              (setq p1-1 (polar txtp pi (+ txtlen gap))
                    p2-1 (polar txtp pi (+ txtlen gap)))
            );progn
            (progn
              (setq p3 (polar p2 pi (+ gap txth (* 2 gap) txtlen (* 2 gap)))
                    p4 (polar p1 pi (+ gap txth (* 2 gap) txtlen (* 2 gap)))
                    txtp (polar bep pi gap))
              (command "text" "mr" txtp txth 0 geoval)
            );progn
          );if
          (txt_data (entlast))
          (setq refp (polar txtp pi (+ txtlen gap)))
          (setq p1-1 (polar refp (* pi 1.5) (* 0.5 (distance p1 p2)))
                p2-1 (polar refp (* pi 0.5) (* 0.5 (distance p1 p2))))
          (setq symp (polar txtp pi (+ txtlen (* gap 2) (* 0.5 txth))))
          (if (= acad_ver "GENIUS")
              (command ".insert" (strcat powdesign_dwg_path geotype) symp txth txth "0")
              (command "insert" (strcat powdesign_dwg_path geotype) symp txth txth "0")
          )
          (setq refp (polar symp pi (+ (* 0.5 txth) gap))
                p3 (polar refp (* pi 0.5) (* 0.5 (distance p1 p2)))
                p4 (polar refp (* pi 1.5) (* 0.5 (distance p1 p2))))
          (command "pline" p1 p2 p3 p4 "c")
          (command "pline" p1-1 p2-1 "")
          (princ)
        );;(= gtype 2)
        ((= gtype 1)
          (if (= max2 "1")
            (progn
              (setq geomp (polar bep pi (+ gap (* 0.5 txth))))
              (if (= acad_ver "GENIUS")
                  (command ".insert" (strcat powdesign_dwg_path "geom") geomp txth txth "0")
                  (command "insert" (strcat powdesign_dwg_path "geom") geomp txth txth "0")
              )
              (setq basetxtp (polar geomp pi (+ gap (* 0.5 txth))))
            );progn
            (progn
              (setq basetxtp (polar bep pi gap))
            );progn
          );if
          (command "text" "mr" basetxtp txth 0 basetxt)
          (txt_data (entlast))
          (setq refp (polar basetxtp pi (+ txtlen gap))
                p1-1 (polar refp (* pi 0.5) (* 0.5 (distance p1 p2)))
                p2-1 (polar refp (* pi 1.5) (* 0.5 (distance p1 p2))))

          (if
            (progn
              (setq geomp (polar basetxtp pi (+ txtlen (* 2 gap) (* 0.5 txth))))
              (if (= acad_ver "GENIUS")
                  (command ".insert" (strcat powdesign_dwg_path geodwg) geomp txth txth "0")
                  (command "insert" (strcat powdesign_dwg_path geodwg) geomp txth txth "0")
              )
              (setq txtp (polar geomp pi (+ gap (* 0.5 txth))))
            );progn
            (progn
              (setq txtp (polar basetxtp pi (+ txtlen (* 2 gap))))
            );progn
          );if
          (command "text" "mr" txtp txth 0 geoval)
          (txt_data (entlast))
          (setq refp (polar txtp pi  (+ txtlen gap))
                p1-2 (polar refp  (* pi 0.5) (* 0.5 (distance p1 p2)))
                p2-2 (polar refp  (* pi 1.5) (* 0.5 (distance p1 p2))))
          (txt_data (entlast))
          (setq symp (polar txtp pi (+ txtlen (* gap 2) (* 0.5 txth))))
          (if (= acad_ver "GENIUS")
              (command ".insert" (strcat powdesign_dwg_path geotype) symp txth txth "0")
              (command "insert" (strcat powdesign_dwg_path geotype) symp txth txth "0")
          )
          (setq refp (polar symp pi (+ (* 0.5 txth) gap))
                p3 (polar refp (* pi 0.5) (* 0.5 (distance p1 p2)))
                p4 (polar refp (* pi 1.5) (* 0.5 (distance p1 p2))))
          (command "pline" p1 p2 p3 p4 "c")
          (command "pline" p1-1 p2-1 "")
          (command "pline" p1-2 p2-2 "")
        );;(= gtype 1)
      );cond
    );progn
  );if

  (reset_sysvar)
  (princ)
)


(defun dimgeo_ok()
  (setq geoval (get_tile "val"))
  (setq atoz (get_tile "atoz"))
  (setq sym_id (get_tile "atoz"))

  (setq geop (get_tile "geop"))
  (setq geol (get_tile "geol"))
  (setq geos (get_tile "geos"))
  (setq max1 (get_tile "max1"))

  (cond
    ((= geop "1") (setq geodwg "geop"))
    ((= geol "1") (setq geodwg "geol"))
    ((= geos "1") (setq geodwg "geos"))
    ((= max1 "1") (setq geodwg "geom"))
    (T (setq geodwg nil))
  )


  (setq max2 (get_tile "max2"))
  (if (= "" geoval)
    (progn
      (set_tile "error" "您尚未輸入幾何公差值!!")
      (setq chk1 nil)
    )
    (progn
      (setq basetxt (nth (atoi sym_id) sym_list) chk1 t)
    )
  )

  (if (and (= nil geotype) (or (= gtype 1)(= gtype 2)))
    (progn
       (set_tile "error" "您尚未選擇幾何公差標註模式!!")
       (setq chk2 nil)
    )
    (progn
      (setq chk2 t)
      (if (and chk1 chk2)
        (progn
         (setq dimgeo_fg t)
         (done_dialog)
        );progn
      );if
    );progn
  );if
)




(defun geo_sld_mode(fg1 fg2 fg3)
 (set_tile "error" "")
 (geo_tile_mode 0 0 0)
 (show_sld_col "geotype1" (strcat powdesign_sld_path "geotype1") fg1)
 (show_sld_col "geotype2" (strcat powdesign_sld_path "geotype2") fg2)
 (show_sld_col "geotype3" (strcat powdesign_sld_path "geotype3") fg3)
)

(defun geo_sld1_mode(fg1 fg2 fg3 fg4 fg5 fg6 fg7 fg8 fg9 fg10 fg11 fg12 fg13 fg14)
 (set_tile "error" "")
 (if (= gtpye 1)
   (progn
      (show_sld_col "geo3" (strcat powdesign_sld_path  "geo3") 9)
      (show_sld_col "geo4" (strcat powdesign_sld_path  "geo4") 9)
      (show_sld_col "geo7" (strcat powdesign_sld_path  "geo7") 9)
      (show_sld_col "geo8" (strcat powdesign_sld_path  "geo8") 9)
      (show_sld_col "geo10" (strcat powdesign_sld_path "geo10") 9)
      (show_sld_col "geo13" (strcat powdesign_sld_path "geo13") 9)
   )
   (progn
      (show_sld_col "geo3" (strcat powdesign_sld_path  "geo3") fg3)
      (show_sld_col "geo4" (strcat powdesign_sld_path  "geo4") fg4)
      (show_sld_col "geo7" (strcat powdesign_sld_path  "geo7") fg7)
      (show_sld_col "geo8" (strcat powdesign_sld_path  "geo8") fg8)
      (show_sld_col "geo10" (strcat powdesign_sld_path "geo10") fg10)
      (show_sld_col "geo13" (strcat powdesign_sld_path "geo13") fg13)
   )
 )

 (show_sld_col "geo1" (strcat powdesign_sld_path  "geo1") fg1)
 (show_sld_col "geo2" (strcat powdesign_sld_path  "geo2") fg2)
 (show_sld_col "geo5" (strcat powdesign_sld_path  "geo5") fg5)
 (show_sld_col "geo6" (strcat powdesign_sld_path  "geo6") fg6)
 (show_sld_col "geo9" (strcat powdesign_sld_path  "geo9") fg9)
 (show_sld_col "geo11" (strcat powdesign_sld_path "geo11") fg11)
 (show_sld_col "geo12" (strcat powdesign_sld_path "geo12") fg12)
 (show_sld_col "geo14" (strcat powdesign_sld_path "geo14") fg14)
)

(defun geo_tile_mode(fg1 fg2 fg3)

 (set_tile "error" "")

 (if (= gtype 1)
   (progn
     (mode_tile "geo3" 1)
     (mode_tile "geo4" 1)
     (mode_tile "geo7" 1)
     (mode_tile "geo8" 1)
     (mode_tile "geo10" 1)
     (mode_tile "geo13" 1)
   )
   (progn
     (mode_tile "geo3" fg1)
     (mode_tile "geo4" fg1)
     (mode_tile "geo7" fg1)
     (mode_tile "geo8" fg1)
     (mode_tile "geo10" fg1)
     (mode_tile "geo13" fg1)
   )
 )

 (mode_tile "geo1" fg1)
 (mode_tile "geo2" fg1)
 (mode_tile "geo5" fg1)
 (mode_tile "geo6" fg1)
 (mode_tile "geo9" fg1)
 (mode_tile "geo11" fg1)
 (mode_tile "geo12" fg1)
 (mode_tile "geo14" fg1)

 (mode_tile "val" fg2)
 (mode_tile "max2" fg2)

 (mode_tile "atoz" fg3)
 (mode_tile "max2" fg3)

)





;;標直徑
;;┌────────────────────────────────┐
;;│ 程  式 : 標直徑                                                │
;;│ 主程式 : rad.lsp                                               │
;;│ 日  期 : 88:03:10                                              │
;;│ 姓  名 : 佘宗紋                                                │
;;│ 對話框 :                                                       │
;;│ 方  法 :                                                       │
;;│                                                                │
;;└────────────────────────────────┘
(defun c:autodia()
(if (and (= jin "#$%")(= #### 85))(setq FFF t))
    (WHILE (/= FFF nil)
           (setq ppss sspp)
           (defun *error* (msg)
                (princ msg)
                (setvar "cmddia" cel_dia)
                (setvar "luprec" cel_prec)
                (redraw)
           )
           (setq
                cel_dia(getvar "cmddia")
                cel_dec(getvar "dimdec")
                cel_prec(getvar "luprec")
           )
           (setq ent1 T)
           (while ent1
                  (setq p0(getpoint "\n第 一 條 延伸線原點或按 ENTER 選取") )
                  (if (/= p0 nil)
                      (progn
                           (setq p1 p0)
                           (setq  p2(getpoint "\n第二條延伸線原點:"))
                      )
                      (progn
                           (setq ent1(car (entsel "\n按 ENTER 結束或選取要標註的物件:")))
                           (if (null ent1)
                               (progn
                                    (setvar "cmddia" cel_dia)
                                    (setvar "luprec" cel_prec)
                                    (SETQ FFF nil)
                                    (exit)
                               )
                               (setq
                                    p1 (cdr (assoc 10 (entget ent1)))
                                    p2 (cdr (assoc 11 (entget ent1)))
                               )
                           );if
                      )
                  );if
                  (setvar "luprec" cel_dec)
                  (setvar "cmddia" 0)
                  (setq
                       txt (distance p1 p2)
                       txt (rtos txt 2)
                       radtxt(strcat "%%C" txt)
                  )
;                  (command "_dimaligned" p1 p2 "t" radtxt)

                  (command  "dimlinear" p1 p2 pause)
                  (setq lent (entlast))
                  (setq ed (entget lent))

                  (setq ed (subst (cons 1 "%%c<>") (assoc 1 ed) ed))
                  (entmod ed)
                  (entupd (entlast))
           );while
           (setvar "cmddia" cel_dia)
           (setvar "luprec" cel_prec)
           (SETQ FFF nil)
    )
    (princ)
);defun



(defun te_err_ppub(msg)
   (if (/= msg "Function cancelled")(princ (strcat "\nError: " msg)))
   (if oerr (setq *error* oerr))

      (setvar "osmode" int_os)
   (princ)
)
;;熔接標註
;╭═════════════════════════════════════════════╮
;║設計日期: 1998.5 . 6                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 佘宗紋                                                                          ║
;║功能說明: 熔接標註                                                                        ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: pub-lisp.lsp,aux-dim.dcl wed01.dwg~wed13.dwg,                                   ║
;╰═════════════════════════════════════════════╯
;(defun wedding(tit sld)
(defun wedding(tit)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)

 (setvar "cmdecho" 0)
 (setq int_os(getvar "osmode"))
       (setq oerr *error* *error* te_err_ppub)
    (setq linedir nil cirw nil workw nil mode2 "0" mode3 nil mode4 nil subline nil subdir 1 wedtype nil wedftype nil)
   (cond
     ((= tit 1) (setq sld "wedding1"))
     ((= tit 2) (setq sld "wedding2"))
   )
   (setq scal (getvar "dimscale"))
   (setq gap (* (getvar "dimgap") scal))
   (setq asz (* (getvar "dimasz") scal))
   (setq txth (* 0.8 (* (getvar "dimtxt") scal)))


 (actdcl (strcat powdesign_dcl_path "auxdim") "wedding")

 (cond
   ((= 1 tit) (set_tile "title" "箭頭邊熔接標註"))
   ((= 2 tit) (set_tile "title" "箭頭對邊熔接標註")(set_tile "subline" "1"))
   ((= 3 tit) (set_tile "title" "箭頭雙邊熔接標註")(mode_tile "subline" 1))
 )


 (show_sld_col "wedding1" (strcat powdesign_sld_path sld) -2)
       (show_sld_col "imagei" (strcat powdesign_sld_path "wedi.sld") -2)
       (show_sld_col "imagev" (strcat powdesign_sld_path "wedv.sld") -2)
       (show_sld_col "imagesv" (strcat powdesign_sld_path "wedsv.sld") -2)
       (show_sld_col "imagey" (strcat powdesign_sld_path "wedy.sld") -2)
       (show_sld_col "imagesy" (strcat powdesign_sld_path "wedsy.sld") -2)
       (show_sld_col "imageu" (strcat powdesign_sld_path "wedu.sld") -2)
       (show_sld_col "imagej" (strcat powdesign_sld_path "wedj.sld") -2)
       (show_sld_col "imagebk" (strcat powdesign_sld_path "wedbk.sld") -2)
       (show_sld_col "imagefco" (strcat powdesign_sld_path "wedfco.sld") -2)
       (show_sld_col "imagefho" (strcat powdesign_sld_path "wedfho.sld") -2)
       (show_sld_col "imagept" (strcat powdesign_sld_path "wedpt.sld") -2)
       (show_sld_col "imagegap" (strcat powdesign_sld_path "wedgap.sld") -2)

 (disp_mode1)
  (action_tile "wedftype" "(disp_mode2)")
  (action_tile "swed" "(disp_mode3)")
  (action_tile "spec" "(disp_mode4)")
  (action_tile "cirw" "(setq cirw(get_tile \"cirw\"))")
  (action_tile "workw" "(setq workw(get_tile \"workw\"))")
  (action_tile "subline" "(setq subline(get_tile \"subline\"))")

     (action_tile "wedplan" "(setq wedftype 1)")
     (action_tile "wedtc" "(setq wedftype 2)")
     (action_tile "weduc" "(setq wedftype 3)")

       (action_tile "wedi" "(setq wedtype 1)")
       (action_tile "wedv" "(setq wedtype 2)")
       (action_tile "wedsv" "(setq wedtype 3)")
       (action_tile "wedy" "(setq wedtype 4)")
       (action_tile "wedsy" "(setq wedtype 5)")
       (action_tile "wedu" "(setq wedtype 6)")
       (action_tile "wedj" "(setq wedtype 7)")
       (action_tile "wedbk" "(setq wedtype 8)")
       (action_tile "wedfco" "(setq wedtype 9)")
       (action_tile "wedfho" "(setq wedtype 10)")
       (action_tile "wedpt" "(setq wedtype 11)")
       (action_tile "wedgap" "(setq wedtype 12)")

 (action_tile "accept" "(wed_ok)(setq flag 1)")
 (action_tile "cancel" "(done_dialog)(setq flag 0)")

 (start_dialog)

   (cond
       ((and (= flag 1) (= tit 1)) (wed_draw1))
       ((and (= flag 1) (= tit 2)) (wed_draw2))
       ((and (= flag 1) (= tit 3)) (wed_draw3))
   );cond

   (SETQ FFF nil))
 (setvar "cmdecho" 1)
 (setvar "osmode" int_os)
 (prinC)
)


(defun disp_mode1()
       (mode_tile "wedplan" 1)
       (mode_tile "wedtc" 1)
       (mode_tile "weduc" 1)
       (mode_tile "distn" 1)
       (mode_tile "distl" 1)
       (mode_tile "count" 1)
       (mode_tile "spec1" 1)
       (mode_tile "spec2" 1)
       (mode_tile "spec3" 1)
)

(defun disp_mode2()
     (setq mode2 (get_tile "wedftype"))
      (if (= mode2 "1")  
        (progn  (mode_tile "wedplan" 0)
                (mode_tile "wedtc" 0) 
                (mode_tile "weduc" 0)
               
        );progn

        (progn  (mode_tile "wedplan" 1)
                (mode_tile "wedtc" 1) 
                (mode_tile "weduc" 1)
             
        );progn
      );if
)

(defun disp_mode3()
       (setq mode3 (get_tile "swed"))
      (if (= mode3 "1")
        (progn  (mode_tile "distn" 0)
                (mode_tile "distl" 0)
                (mode_tile "count" 0)
                
        );progn

        (progn  (mode_tile "distn" 1)
                (mode_tile "distl" 1)
                (mode_tile "count" 1)
               
        );progn
      );if
)

(defun disp_mode4()
     (setq mode4 (get_tile "spec"))
      (if (= mode4 "1")
        (progn  (mode_tile "spec1" 0)
                (mode_tile "spec2" 0)
                (mode_tile "spec3" 0)
                
        );progn

        (progn  (mode_tile "spec1" 1)
                (mode_tile "spec2" 1)
                (mode_tile "spec3" 1)
               
        );progn
      );if
)


 (defun wed_ok()
        (setq 
             s (get_tile "weddep")
             a (get_tile "wedang")
             e (get_tile "distn")
             l (get_tile "distl")
             n (get_tile "count") 
             spec1  (get_tile "spec1")
             spec2  (get_tile "spec2")
             spec3  (get_tile "spec3")
        )  
  (if (= a "")(setq mode2 "0"))

;-----------------決定全周or現場熔接符號 
           (cond 
                ((and (= cirw "1") (= workw "1")) (setq typename (strcat powdesign_dwg_path "wedf-c")))
                ((= cirw "1")(setq typename (strcat powdesign_dwg_path "wedcir")))
                ((= workw "1")(setq typename (strcat powdesign_dwg_path "wedflag")))
           ) 
;-----------------決定表面形狀符號   
            (cond
                ((= wedftype 1)(setq ftypename (strcat powdesign_dwg_path "wedplan")))
                ((= wedftype 2)(setq ftypename (strcat powdesign_dwg_path "wedtc")))
                ((= wedftype 3)(setq ftypename (strcat powdesign_dwg_path "weduc")))
            )
;-----------------決定基本符號
        (cond
             ((= wedtype 1)(setq blockname (strcat powdesign_dwg_path "wed10")))
             ((= wedtype 2)(setq blockname (strcat powdesign_dwg_path "wed01")))
             ((= wedtype 3)(setq blockname (strcat powdesign_dwg_path "wed02")))
             ((= wedtype 4)(setq blockname (strcat powdesign_dwg_path "wed03")))
             ((= wedtype 5)(setq blockname (strcat powdesign_dwg_path "wed04")))
             ((= wedtype 6)(setq blockname (strcat powdesign_dwg_path "wed05")))
             ((= wedtype 7)(setq blockname (strcat powdesign_dwg_path "wed06")))
             ((= wedtype 8)(setq blockname (strcat powdesign_dwg_path "wed07")))
             ((= wedtype 9)(setq blockname (strcat powdesign_dwg_path "wed08")))
             ((= wedtype 10)(setq blockname (strcat powdesign_dwg_path "wed11")))
             ((= wedtype 11)(setq blockname (strcat powdesign_dwg_path "wed12")))
             ((= wedtype 12)(setq blockname (strcat powdesign_dwg_path "wed13")))
        );cond 

   (setq txt(strcat n "x" l "(" e ")")) 
         (cond
             ((= wedtype nil) (set_tile "error" "基本符號未選取!"))
             ((and (= mode2 "1") (= wedftype nil)) (set_tile "error" "表面形狀符號未選取!")) 
             ((and (= (atof e) 0) (= mode3 "1")) (set_tile "error"  "斷續熔接間斷距離輸入錯誤!"))
             ((and (= (atof l) 0) (= mode3 "1")) (set_tile "error"  "斷續熔接長度輸入錯誤!"))
             (t (done_dialog))
         );cond


 );defun wed_ok
;******************************************************* 
;箭頭邊熔接標註
;*******************************************************
 (defun wed_draw1()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
       (c:&d&)
       (setq p1(getpoint "\n點取起始點:"))

       (setvar "osmode" 0)
       (setq p2(getpoint P1 "\n點取第二點:"))
         (if (= subline "1")
           (progn
             (setq ps(getpoint "\n選擇副基線位置:"))
             (setq p2psang(angle p2 ps))
                ( if (<= p2psang  pi)
                    (setq subdir 1)
                    (setq subdir 2)
                );if
           );progn
           (progn
             (setq ps(getpoint "\n選擇文字放置位置:"))
             (setq p2psang(angle p2 ps))
                ( if (<= p2psang  pi)
                    (setq subdir 2)
                    (setq subdir 1)
                );if
           );progn
         );if

        (setq p1p2ang (angle p1 p2)
              parr (polar p1 p1p2ang asz)
              asw (* asz 0.33333)
        )
            (if (and (> p1p2ang (* pi 0.5)) (< p1p2ang (* pi 1.5)))
               (progn
                   (setq linedir 1)
                   (setq p3 (polar p2 pi (+ gap scal)))
               );progn
               (progn
                   (setq linedir 0)
                    (setq p3 (polar p2 0 (+ gap scal)))
               );progn
            );if
                  (if (= subdir 2)
                     (setq p4 (polar p3 (* pi 0.5) gap))
                     (setq p4 (polar p3 (* pi 1.5) gap))
                  );if
;---------------------箭頭&引線
      (command "pline" p1 "w" 0 asw parr "w" 0 0 p2 "")
;---------------------全周or現場熔接符號
        (if (or (= cirw "1") (= workw "1"))
          (progn
            (if (= acad_ver "GENIUS")
               (command ".insert" typename p2 (* 2 scal) (* 2 scal) 0)
               (command "insert" typename p2 (* 2 scal) (* 2 scal) 0)
            )
          )
        );if

;--------------------決定文字對齊方式
            (cond
                ((and (= linedir 1)(= subdir 1 )) (setq txtalign_type "tr" atxt_type "tc"))
                ((and (= linedir 0)(= subdir 1 )) (setq txtalign_type "tl" atxt_type "tc"))
                ((and (= linedir 1)(= subdir 2 )) (setq txtalign_type "br" atxt_type "bc"))
                ((and (= linedir 0)(= subdir 2 )) (setq txtalign_type "bl" atxt_type "bc"))
            );cond

;---------------------right   熔接深度
           (if (and (/= s "") (= linedir 0))
              (progn
                (command "text" "j" txtalign_type p4 txth 0 s)
                (txt_data (entlast))
              );progn
           );if
;---------------------left 斷續熔接
        (if (and (= mode3 "1") (= linedir 1))
          (progn
             (command "text" "j" txtalign_type p4 txth 0 txt)
             (txt_data (entlast))
          );progn

        );if
;-------------------left基本符號位置
            (if (and (= mode3 "1") (= linedir 1))
                (setq p5 (polar p3 pi (+ gap txtlen scal scal)))
            );if

            (if (and (/= mode3 "1") (= linedir 1))
               (setq p5 (polar p3 pi (+ gap scal scal)))
            );if
;-------------------right基本符號位置
            (if (and (/= s "") (= linedir 0))
                (setq p5 (polar p3 0 (+ gap txtlen scal scal)))
            );if
            (if (and (= s "") (= linedir 0))
                (setq p5 (polar p3 0 (+ gap scal scal)))
            );if
;------------------基本符號
          (if (= acad_ver "GENIUS")
              (command ".insert" blockname p5 (* 2 scal) "" 0)
              (command "insert" blockname p5 (* 2 scal) "" 0)
          )
             (setq ent1(entlast))

       (if (= subdir 1)
          (command "mirror" ent1 "" p2 p3 "y")
       );if
;------------------right 斷續熔接 or left熔接深度位置
            (if (= linedir 1)
             (setq p6 (polar p5 pi (+ gap scal scal)))
             (setq p6 (polar p5 0 (+ gap scal scal)))
            );if
              (if (= subdir 1)
               (setq p6_1 (polar p6 (* 1.5 pi) gap))
               (setq p6_1 (polar p6 (* 0.5 pi) gap))
              )
;-----------------right 斷續熔接
  (cond
        ((and (= mode3 "1") (= linedir 0))
;        (if (and (= mode3 "1") (= linedir 0))
          (progn
             (command "text" "j" txtalign_type p6_1 txth 0 txt)
             (txt_data (entlast))
             (setq p7 (polar p6 0 (+ txtlen gap scal scal)))
          );progn
        )
        ;);if
;-----------------left熔接深度
       ((and (/= s "") (= linedir 1))
                 (progn
                     (command "text" "j" txtalign_type p6_1 txth 0 s)
                     (txt_data (entlast))
                     (setq p7 (polar p6 pi (+ txtlen gap scal scal)))
                 );progn
       )
           (t (setq p7 p6))
  );cond
;-----------------基線
           (command "line" p2 p7 "")

;-----------------起槽角度
             (if (= subdir 1)
              (setq p8 (polar p5 (* pi 1.5) (+ gap gap txth)))
              (setq p8 (polar p5 (* pi 0.5) (+ gap gap txth)))
             );if

               (if (/= a "")
                  (command "text" "j" atxt_type p8 txth 0 a)

               );if

;-----------------表面形狀符號

           (if (= subdir 1)
              (setq p9 (polar p8 (* pi 1.5) (+ gap gap txth)))
              (setq p9 (polar p8 (* pi 0.5) (+ gap gap txth)))
           );if

                (if (/= mode2 "0")
                   (progn
                      (if (= acad_ver "GENIUS")
                          (command ".insert" ftypename p9 (* 2 scal) "" 0)
                          (command "insert" ftypename p9 (* 2 scal) "" 0)
                      )
                   )
                 );if

;-----------------特別說明
               (if (and (= mode4 "1") (= linedir 1))
                    (progn
                         (setq p22 (polar p7 (* pi 0.75) txth))
                         (setq p33 (polar p7 (* pi 1.25) txth))
                         (setq p44 (polar p7 pi txth))
                         (setq p55 (polar p44 (* pi 0.5) (+ gap (* 0.8 txth))))
                         (setq p66 (polar p44 (* pi 1.5) (+ gap (* 0.8 txth))))
                         (command "line" p22 p7 p33 "")
                         (command "text" "j" "mr" p55 (* 0.8 txth) 0 spec1)
                         (command "text" "j" "mr" p44 (* 0.8 txth) 0 spec2)
                         (command "text" "j" "mr" p66 (* 0.8 txth) 0 spec3)
                    );progn
                );if
               (if (and (= mode4 "1") (= linedir 0))
                    (progn
                         (setq p22 (polar p7 (* pi 0.25) txth))
                         (setq p33 (polar p7 (* pi 1.75) txth))
                         (setq p44 (polar p7 0 txth))
                         (setq p55 (polar p44 (* pi 0.5) (+ gap (* 0.8 txth))))
                         (setq p66 (polar p44 (* pi 1.5) (+ gap (* 0.8 txth))))
                         (command "line" p22 p7 p33 "")
                         (command "text" "j" "ml" p55 (* 0.8 txth) 0 spec1)
                         (command "text" "j" "ml" p44 (* 0.8 txth) 0 spec2)
                         (command "text" "j" "ml" p66 (* 0.8 txth) 0 spec3)
                    );progn
               );if
;-------------副基線
                (if (= subline "1")
                  (progn
                    (setq sub1 (polar p3 (* pi 0.5) gap))
                      (if (= linedir 0)
                        (setq subp1 (polar sub1 0 (* scal 0.5)))
                        (setq subp1 (polar sub1 pi (* scal 0.5)))
                      );if
                    (setq subp2 (polar p7 (* pi 0.5) gap))
                    (c:&dl&)
                    (command "line" subp1 subp2 "")
                     (setq ent2(entlast))
                       (if (= subdir 2)
                         (command "mirror" ent2 "" p2 p7 "y")
                       );if
                    (c:&sl&)
                  )
                );if
   (SETQ FFF nil))
   (PRINC)
 );defun wed_draw1


;***************************************************************
;箭頭對邊熔接標註
;***************************************************************

(defun wed_draw2()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
       (setq p1(getpoint "\n點取起始點:"))
       (setvar "osmode" 0)
       (setq p2(getpoint P1 "\n點取第二點:"))
;         (if (= subline "1")
;           (progn
             (setq ps(getpoint "\n選擇副基線位置:"))
             (setq p2psang(angle p2 ps))
                ( if (<= p2psang  pi)
                   (setq subdir 2)
                   (setq subdir 1)
                );if
;           );progn
;         );if

        (setq p1p2ang (angle p1 p2)
              parr (polar p1 p1p2ang asz)
              asw (* asz 0.33333)
        )
            (if (and (> p1p2ang (* pi 0.5)) (< p1p2ang (* pi 1.5)))
               (progn
                   (setq linedir 1)
                   (setq p3 (polar p2 pi (+ gap scal)))
               );progn
               (progn
                   (setq linedir 0)
                    (setq p3 (polar p2 0 (+ gap scal)))
               );progn
            );if
                  (if (= subdir 2)
                     (setq p4 (polar p3 (* pi 0.5) (* 2.0 gap)))
                     (setq p4 (polar p3 (* pi 1.5) (* 2.0 gap)))
                  );if
;---------------------箭頭&引線
      (command "pline" p1 "w" 0 asw parr "w" 0 0 p2 "")
;---------------------全周or現場熔接符號
        (if (or (= cirw "1") (= workw "1"))
            (progn
              (if (= acad_ver "GENIUS")
                  (command ".insert" typename p2 (* 2 scal) (* 2 scal) 0)
                  (command "insert" typename p2 (* 2 scal) (* 2 scal) 0)
              )
            )
        );if

;--------------------決定文字對齊方式
            (cond
                ((and (= linedir 1)(= subdir 1 )) (setq txtalign_type "tr" atxt_type "tc"))
                ((and (= linedir 0)(= subdir 1 )) (setq txtalign_type "tl" atxt_type "tc"))
                ((and (= linedir 1)(= subdir 2 )) (setq txtalign_type "br" atxt_type "bc"))
                ((and (= linedir 0)(= subdir 2 )) (setq txtalign_type "bl" atxt_type "bc"))
            );cond

;---------------------right   熔接深度
           (if (and (/= s "") (= linedir 0))
              (progn
                (command "text" "j" txtalign_type p4 txth 0 s)
                (txt_data (entlast))
              );progn
           );if
;---------------------left 斷續熔接
        (if (and (= mode3 "1") (= linedir 1))
          (progn
             (command "text" "j" txtalign_type p4 txth 0 txt)
             (txt_data (entlast))
          );progn

        );if
;-------------------left基本符號位置
            (cond
              ((and (= mode3 "1") (= linedir 1))
               (setq p5 (polar p3 pi (+ gap txtlen scal scal)))
              )

              ((and (/= mode3 "1") (= linedir 1))
               (setq p5 (polar p3 pi (+ gap scal scal)))
              )
;-------------------right基本符號位置
              ((and (/= s "") (= linedir 0))
                (setq p5 (polar p3 0 (+ gap txtlen scal scal)))
              )
              ((and (= s "") (= linedir 0))
                (setq p5 (polar p3 0 (+ gap scal scal)))
              )
            );cond
;-------------------
          (if (= subdir 2)
             (setq p5_v (polar p5 (* 0.5 pi) gap))
             (setq p5_v (polar p5 (* 1.5 pi) gap))
          );if
;------------------right 斷續熔接 or left熔接深度位置
            (if (= linedir 1)
             (setq p6 (polar p5_v pi (+ gap scal scal)))
             (setq p6 (polar p5_v 0 (+ gap scal scal)))
            );if
              (if (= subdir 1)
               (setq p6_1 (polar p6 (* 1.5 pi) gap))
               (setq p6_1 (polar p6 (* 0.5 pi) gap))
              )
;------------------基本符號
          (if (= acad_ver "GENIUS")
              (command ".insert" blockname p5_v (* 2 scal) "" 0)
              (command "insert" blockname p5_v (* 2 scal) "" 0)
          )
              (setq ent1(entlast))

       (if (= subdir 1)
          (command "mirror" ent1 "" p5_v p6 "y")
       );if

;-----------------right 斷續熔接
  (cond
        ((and (= mode3 "1") (= linedir 0))
;        (if (and (= mode3 "1") (= linedir 0))
          (progn
             (command "text" "j" txtalign_type p6_1 txth 0 txt)
             (txt_data (entlast))
             (setq p7 (polar p5 0 (+ txtlen gap scal scal gap scal scal)))
          );progn
        )
        ;);if
;-----------------left熔接深度
       ((and (/= s "") (= linedir 1))
                 (progn
                     (command "text" "j" txtalign_type p6_1 txth 0 s)
                     (txt_data (entlast))
                     (setq p7 (polar p5 pi (+ txtlen gap scal scal gap scal scal)))
                 );progn
       )
       ((= linedir 0) (setq p7 (polar p5 0 (+ gap scal scal))))
       ((= linedir 1) (setq p7 (polar p5 pi (+ gap scal scal))))
 ;          (t (setq p7 p6))
  );cond
;-----------------基線
           (command "line" p2 p7 "")

;-----------------起槽角度
             (if (= subdir 1)
              (setq p8 (polar p5_v (* pi 1.5) (+ gap gap txth)))
              (setq p8 (polar p5_v (* pi 0.5) (+ gap gap txth)))
             );if

               (if (/= a "")
                  (command "text" "j" atxt_type p8 txth 0 a)

               );if

;-----------------表面形狀符號

           (if (= subdir 1)
              (setq p9 (polar p8 (* pi 1.5) (+ gap gap txth)))
              (setq p9 (polar p8 (* pi 0.5) (+ gap gap txth)))
           );if

                (if (/= mode2 "0")
                    (progn
                       (if (= acad_ver "GENIUS")
                            (command ".insert" ftypename p9 (* 2 scal) "" 0)
                            (command "insert" ftypename p9 (* 2 scal) "" 0)
                       )
                    )progn
                );if

;-----------------特別說明
               (if (and (= mode4 "1") (= linedir 1))
                    (progn
                         (setq p22 (polar p7 (* pi 0.75) txth))
                         (setq p33 (polar p7 (* pi 1.25) txth))
                         (setq p44 (polar p7 pi txth))
                         (setq p55 (polar p44 (* pi 0.5) (+ gap (* 0.8 txth))))
                         (setq p66 (polar p44 (* pi 1.5) (+ gap (* 0.8 txth))))
                         (command "line" p22 p7 p33 "")
                         (command "text" "j" "mr" p55 (* 0.8 txth) 0 spec1)
                         (command "text" "j" "mr" p44 (* 0.8 txth) 0 spec2)
                         (command "text" "j" "mr" p66 (* 0.8 txth) 0 spec3)
                    );progn
                );if
               (if (and (= mode4 "1") (= linedir 0))
                    (progn
                         (setq p22 (polar p7 (* pi 0.25) txth))
                         (setq p33 (polar p7 (* pi 1.75) txth))
                         (setq p44 (polar p7 0 txth))
                         (setq p55 (polar p44 (* pi 0.5) (+ gap (* 0.8 txth))))
                         (setq p66 (polar p44 (* pi 1.5) (+ gap (* 0.8 txth))))
                         (command "line" p22 p7 p33 "")
                         (command "text" "j" "ml" p55 (* 0.8 txth) 0 spec1)
                         (command "text" "j" "ml" p44 (* 0.8 txth) 0 spec2)
                         (command "text" "j" "ml" p66 (* 0.8 txth) 0 spec3)
                    );progn
               );if
;-------------副基線
;                (if (= subline "1")
;                  (progn
                     (setq sub1 (polar p3 (* pi 1.5) gap))
                      (if (= linedir 0)
                        (setq subp1 (polar sub1 0 (* scal 0.5)))
                        (setq subp1 (polar sub1 pi (* scal 0.5)))
                      );if
                    (setq subp2 (polar p7 (* pi 1.5) gap))
                    (c:&dl&)
                    (command "line" subp1 subp2 "")
                     (setq ent2(entlast))
                       (if (= subdir 2)
                         (command "mirror" ent2 "" p2 p7 "y")
                       );if
                    (c:&sl&)
 ;                 )
 ;               );if
   (SETQ FFF nil))
   (PRINC)
 );defun wed_draw2



;************************************************************
;箭頭雙邊熔接標註
;************************************************************

(defun wed_draw3()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
     (setvar "mirrtext" 0)
       (setq p1(getpoint "\n點取起始點:"))
       (setvar "osmode" 0)
       (setq p2(getpoint "\n點取第二點:"))

        (setq p1p2ang (angle p1 p2)
              parr (polar p1 p1p2ang asz)
              asw (* asz 0.33333)
        )
            (if (and (> p1p2ang (* pi 0.5)) (< p1p2ang (* pi 1.5)))
               (progn
                   (setq linedir 1)
                   (setq p3 (polar p2 pi (+ gap scal)))
               );progn
               (progn
                   (setq linedir 0)
                    (setq p3 (polar p2 0 (+ gap scal)))
               );progn
            );if
                  (if (= subdir 2)
                     (setq p4 (polar p3 (* pi 0.5) (* 2.0 gap)))
                     (setq p4 (polar p3 (* pi 1.5) (* 2.0 gap)))
                  );if

;---------------------箭頭&引線
      (command "pline" p1 "w" 0 asw parr "w" 0 0 p2 "")
;---------------------全周or現場熔接符號
        (if (or (= cirw "1") (= workw "1"))
           (progn
              (if (= acad_ver "GENIUS")
                (command ".insert" typename p2 (* 2 scal) (* 2 scal) 0)
                (command "insert" typename p2 (* 2 scal) (* 2 scal) 0)
              )
           )
        );if

;--------------------決定文字對齊方式
            (cond
                ((and (= linedir 1)(= subdir 1 )) (setq txtalign_type "tr" atxt_type "tc"))
                ((and (= linedir 0)(= subdir 1 )) (setq txtalign_type "tl" atxt_type "tc"))

            );cond

;---------------------right   熔接深度
           (if (and (/= s "") (= linedir 0))
              (progn
                (command "text" "j" txtalign_type p4 txth 0 s)
                (setq ent1 (entlast))
                (txt_data (entlast))
                (command "mirror" ent1 "" p2 p3 "n")
              );progn
           );if
;---------------------left 斷續熔接
        (if (and (= mode3 "1") (= linedir 1))
          (progn
             (command "text" "j" txtalign_type p4 txth 0 txt)
                (setq ent1 (entlast))
             (txt_data (entlast))
                (command "mirror" ent1 "" p2 p3 "n")
          );progn

        );if
;-------------------left基本符號位置
            (if (and (= mode3 "1") (= linedir 1))
                (setq p5 (polar p3 pi (+ gap txtlen scal scal)))
            );if

            (if (and (/= mode3 "1") (= linedir 1))
               (setq p5 (polar p3 pi (+ gap scal scal)))
            );if
;-------------------right基本符號位置
            (if (and (/= s "") (= linedir 0))
                (setq p5 (polar p3 0 (+ gap txtlen scal scal)))
            );if
            (if (and (= s "") (= linedir 0))
                (setq p5 (polar p3 0 (+ gap scal scal)))
            );if
;------------------基本符號
          (if (= acad_ver "GENIUS")
              (command ".insert" blockname p5 (* 2 scal) "" 0)
              (command "insert" blockname p5 (* 2 scal) "" 0)
          )
             (setq ent2(entlast))
              (command "mirror" ent2 "" p2 p3 "n")
;------------------right 斷續熔接 or left熔接深度位置
            (if (= linedir 1)
             (setq p6 (polar p5 pi (+ gap scal scal)))
             (setq p6 (polar p5 0 (+ gap scal scal)))
            );if
              (if (= subdir 1)
               (setq p6_1 (polar p6 (* 1.5 pi) gap))
               (setq p6_1 (polar p6 (* 0.5 pi) gap))
              )
;-----------------right 斷續熔接
  (cond
        ((and (= mode3 "1") (= linedir 0))

          (progn
             (command "text" "j" txtalign_type p6_1 txth 0 txt)
                (setq ent3 (entlast))
             (txt_data (entlast))
              (command "mirror" ent3 "" p2 p3 "n")
             (setq p7 (polar p6 0 (+ txtlen gap scal scal)))
          );progn
        )

;-----------------left熔接深度
       ((and (/= s "") (= linedir 1))
                 (progn
                     (command "text" "j" txtalign_type p6_1 txth 0 s)
                         (setq ent3 (entlast))
                     (txt_data (entlast))
                     (command "mirror" ent3 "" p2 p3 "n")
                     (setq p7 (polar p6 pi (+ txtlen gap scal scal)))
                 );progn
       )
           (t (setq p7 p6))
  );cond
;-----------------基線
           (command "line" p2 p7 "")

;-----------------起槽角度
;             (if (= subdir 1)
              (setq p8 (polar p5 (* pi 1.5) (+ gap gap txth)))
;              (setq p8 (polar p5 (* pi 0.5) (+ gap gap txth)))
;             );if

               (if (/= a "")
                 (progn
                  (command "text" "j" atxt_type p8 txth 0 a)
                  (setq ent4 (entlast))
                  (command "mirror" ent4 "" p2 p3 "n")
                 );progn
               );if

;-----------------表面形狀符號

;           (if (= subdir 1)
              (setq p9 (polar p8 (* pi 1.5) (+ gap gap txth)))
;              (setq p9 (polar p8 (* pi 0.5) (+ gap gap txth)))
;           );if
         (setq p9_v (polar p5 (* pi 0.5) (+ gap gap txth gap gap txth)))
                (if (/= mode2 "0")
                  (progn
                   (setq xscale (* 2.0 scal))
                   (if (= acad_ver "GENIUS")
                       (command ".insert" ftypename p9 xscale "" 0)
                       (command "insert" ftypename p9 xscale "" 0)
                   )
                   (setq ent5 (entlast))
                   (if (= acad_ver "GENIUS")
                       (command ".copy" ent5 "" p9 p9_v)
                       (command "copy" ent5 "" p9 p9_v)
                   )
                  );progn
                );if

;-----------------特別說明
               (if (and (= mode4 "1") (= linedir 1))
                    (progn
                         (setq p22 (polar p7 (* pi 0.75) txth))
                         (setq p33 (polar p7 (* pi 1.25) txth))
                         (setq p44 (polar p7 pi txth))
                         (setq p55 (polar p44 (* pi 0.5) (+ gap (* 0.8 txth))))
                         (setq p66 (polar p44 (* pi 1.5) (+ gap (* 0.8 txth))))
                         (command "line" p22 p7 p33 "")
                         (command "text" "j" "mr" p55 (* 0.8 txth) 0 spec1)
                         (command "text" "j" "mr" p44 (* 0.8 txth) 0 spec2)
                         (command "text" "j" "mr" p66 (* 0.8 txth) 0 spec3)
                    );progn
                );if
               (if (and (= mode4 "1") (= linedir 0))
                    (progn
                         (setq p22 (polar p7 (* pi 0.25) txth))
                         (setq p33 (polar p7 (* pi 1.75) txth))
                         (setq p44 (polar p7 0 txth))
                         (setq p55 (polar p44 (* pi 0.5) (+ gap (* 0.8 txth))))
                         (setq p66 (polar p44 (* pi 1.5) (+ gap (* 0.8 txth))))
                         (command "line" p22 p7 p33 "")
                         (command "text" "j" "ml" p55 (* 0.8 txth) 0 spec1)
                         (command "text" "j" "ml" p44 (* 0.8 txth) 0 spec2)
                         (command "text" "j" "ml" p66 (* 0.8 txth) 0 spec3)
                    );progn
               );if

   (SETQ FFF nil))
   (PRINC)
);wed_draw3

;;;
;;; 自動水平標註
(defun c:adh()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "cmdecho" 0)
   (initget 0 "1 2")
   (setq dimtype (getkword "\n(1)連續式標註/(2)基準式標註<1>: "))
   (if (or (= "1" dimtype) (null dimtype)) (setq dimtype "1") (setq dimtype "2"))
   (princ "\n選擇要自動標尺寸的圖元...")
   (setq entgrop (ssget))
   (setq stp (getpoint "\n尺寸標註起點: "))
   (setq dimdir (getpoint "\n標註線位置: "))

;;篩選所有水平線 給 p_list
   (setq p_list '() count 0)
   (repeat (sslength entgrop)
      (setq ent (ssname entgrop count)
            entdata (entget ent)
            10data (cdr (assoc 10 entdata))
            11data (cdr (assoc 11 entdata))
            ang (angle 10data 11data))
      (if (or (= 0 ang) (= pi ang))
         (progn
            (setq 10dist (distance 10data stp)
                  11dist (distance 11data stp))
            (if (> 11dist 10dist)
               (setq line_list (list 10data 11data))
               (setq line_list (list 11data 10data))
            );if
            (setq p_list (cons line_list p_list))
         )
     );if
     (setq count (1+ count))
   );repeat


;;;排序所有水平線給 newp_list
   (setq count 0 fg t)

   (repeat (length p_list)
      (setq data (car (nth count p_list)))
      (if (= 0 (distance stp data))
         (setq 1line (nth count p_list))           ;取第一條線
         (setq count (1+ count))
      );if
   )
   (setq newp_list (list 1line))
   (setq 1p (nth 1 1line) count 0)
   (repeat (- (length p_list) 1)
     (foreach n p_list
       (progn
         (setq ang (angle 1p (nth 0 n)))
         (if (or (=  ang (* pi 0.5)) (= ang (* pi 1.5)))
           (setq newp_list (cons n newp_list) 1p (nth 1 n))
         )
       );progn
     );foreach

   );repeat
   (setq newp_list (reverse newp_list))

;;;篩選所要的尺標點給 dimp_list
   (setq dimp_list (list (car (nth 0 newp_list))) count 1)
   (setq chp1 (cadr (nth 0 newp_list)))

   (foreach n (cdr newp_list)
     (progn
        (setq chp2 (nth 0 n))
;       (if (> (nth 1 stp) (nth 1 chp1))
;         (progn
;           (if (> (nth 1 chp1) (nth 1 chp2))
;             (setq dimp_list (cons chp1 dimp_list))
;             (setq dimp_list (cons chp2 dimp_list))
;           )
;         )
;         (progn
;           (if (> (nth 1 chp1) (nth 1 chp2))
;             (setq dimp_list (cons chp2 dimp_list))
;             (setq dimp_list (cons chp1 dimp_list))
;           )
;         )
;       );if
        (setq dist1 (distance chp1 dimdir)
              dist2 (distance chp2 dimdir))
        (if (> dist1 dist2)
          (setq dimp_list (cons chp2 dimp_list))
          (setq dimp_list (cons chp1 dimp_list))
        )
        (setq chp1 (cadr n))
     );progn
   )
   (setq dimp_list (cons (cadr (nth (- (length newp_list) 1) newp_list)) dimp_list))
   (setq dimp_list (reverse dimp_list))

;;開始標註
   (setq p1 (nth 0 dimp_list))
   (setq p2 (nth 1 dimp_list))
   (setq otherp_list (cddr dimp_list))
   (command "dim1" "hor" p1 p2 dimdir "")
   (setq count 0)
   (if (= dimtype "1")
      (progn
        (repeat (length otherp_list)
          (command "dim1" "cont" (nth count otherp_list) "")
          (setq count (1+ count))
        );repeat
      );progn
      (progn
        (repeat (length otherp_list)
          (command "dim1" "base" (nth count otherp_list) "")
          (setq count (1+ count))
        );repeat
      );progn
   );if

   (SETQ FFF nil))
   (setvar "cmdecho" 1)(princ)
)

;;=============================================================================================
;;; 自動垂直標註
(defun c:adv()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "cmdecho" 0)
   (initget 0 "1 2")
   (setq dimtype (getkword "\n(1)連續式標註/(2)基準式標註<1>: "))
   (if (or (= "1" dimtype) (null dimtype)) (setq dimtype "1") (setq dimtype "2"))
   (princ "\n選擇要自動標尺寸的圖元...")
   (setq entgrop (ssget))
   (setq stp (getpoint "\n尺寸標註起點: "))
   (setq dimdir (getpoint "\n標註線位置: "))

;;篩選所有垂直線 給 p_list
   (setq p_list '() count 0)
   (repeat (sslength entgrop)
      (setq ent (ssname entgrop count)
            entdata (entget ent)
            10data (cdr (assoc 10 entdata))
            11data (cdr (assoc 11 entdata))
            ang (angle 10data 11data))
      (if (or (= (* pi 0.5) ang) (= (* pi 1.5) ang))
         (progn
            (setq 10dist (distance 10data stp)
                  11dist (distance 11data stp))
            (if (> 11dist 10dist)
               (setq line_list (list 10data 11data))
               (setq line_list (list 11data 10data))
            );if
            (setq p_list (cons line_list p_list))
         )
     );if
     (setq count (1+ count))
   );repeat

;;;排序所有垂直線給 newp_list
   (setq count 0 fg t)
   (repeat (length p_list)
      (setq data (car (nth count p_list)))
      (if (= 0 (distance stp data))
         (setq 1line (nth count p_list))           ;取第一條線
         (setq count (1+ count))
      );if
   )
   (setq newp_list (list 1line))
   (setq 1p (nth 1 1line) count 0)
   (repeat (- (length p_list) 1)
     (foreach n p_list
       (progn
         (setq ang (angle 1p (nth 0 n)))
         (if (or (=  ang pi) (= ang 0))
           (setq newp_list (cons n newp_list) 1p (nth 1 n))
         )
       );progn
     );foreach
   );repeat
   (setq newp_list (reverse newp_list))

;;;篩選所要的尺標點給 dimp_list
   (setq dimp_list (list (car (nth 0 newp_list))) count 1)
   (setq chp1 (cadr (nth 0 newp_list)))

   (foreach n (cdr newp_list)
     (progn
        (setq chp2 (nth 0 n))
        (setq dist1 (distance chp1 dimdir)
              dist2 (distance chp2 dimdir))
;       (setq dist1 (distance chp1 stp)
;             dist2 (distance chp2 stp))
        (if (> dist1 dist2)
          (setq dimp_list (cons chp2 dimp_list))
          (setq dimp_list (cons chp1 dimp_list))
        )
        (setq chp1 (cadr n))
     );progn
   )
   (setq dimp_list (cons (cadr (nth (- (length newp_list) 1) newp_list)) dimp_list))
   (setq dimp_list (reverse dimp_list))

;;開始標註
   (setq p1 (nth 0 dimp_list))
   (setq p2 (nth 1 dimp_list))
   (setq otherp_list (cddr dimp_list))
   (command "dim1" "ver" p1 p2 dimdir "")
   (setq count 0)
   (if (= dimtype "1")
      (progn
        (repeat (length otherp_list)
          (command "dim1" "cont" (nth count otherp_list) "")
          (setq count (1+ count))
        );repeat
      );progn
      (progn
        (repeat (length otherp_list)
          (command "dim1" "base" (nth count otherp_list) "")
          (setq count (1+ count))
        );repeat
      );progn
   );if


   (SETQ FFF nil))
   (setvar "cmdecho" 1)(princ)
)

;;;
;╭═════════════════════════════════════════════╮
;║設計日期: 1998.05.04                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 佘宗紋                                                                          ║
;║功能說明:萃取修改尺寸標註內容                                                                 ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案:                                                                                 ║
;╰═════════════════════════════════════════════╯
(defun c:uptxt()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setq n 1)
   (setq scl(getvar "dimscale"))
   (setq txt_list '())
   (setq ent1 (entget (car (entsel "\n請選取變更標註:"))))
   (setq p1 (getpoint "\n請點取修改內容放置位置:"))
        (setq txt1 (entget(entnext(cdr(assoc -1 ent1)))))
            (setq date1 (cdr(assoc 1 txt1)))
            (setq list1 (cons (cdr (assoc 1 txt1)) "6"))
            (setq txt_list (cons list1 txt_list))
        (setq txt2 (entget(entnext(cdr(assoc -1 txt1)))))
;           (setq date2 (cdr(assoc 1 txt2)))
;           (setq list2 (cons (cdr (assoc 1 txt2)) "9"))
;           (setq txt_list (cons list2 txt_list))
        (setq txt3 (entget(entnext(cdr(assoc -1 txt2)))))
            (setq date3 (cdr(assoc 1 txt3)))
            (setq list3 (cons (cdr (assoc 1 txt3)) "20"))
            (setq txt_list (cons list3 txt_list))
        (setq txt4 (entget(entnext(cdr(assoc -1 txt3)))))
            (setq date4 (cdr(assoc 1 txt4)))
            (setq list4 (cons (cdr (assoc 1 txt4)) "15"))
            (setq txt_list (cons list4 txt_list))
        (setq txt5 (entget(entnext(cdr(assoc -1 txt4)))))
            (setq date5 (cdr(assoc 1 txt5)))
            (setq list5 (cons (cdr (assoc 1 txt5)) "10"))
            (setq txt_list (cons list5 txt_list))
       (setq txt_list (reverse txt_list))  ;串列
          (setq
               p2 (polar p1 0 (* 5 scl))
               p3 (polar p1 (* 0.3333 pi) (* 5 scl))
               pc1 (polar p1 (* 0.166667 pi) (/ (* 5 scl) 1.732)) ;編號
               pc2 (polar pc1 0 (* (* 3 scl) 6))   ;更改內容
               pc3 (polar pc2 0 (* (* 3 scl) 20)) ;更改者
               pc4 (polar pc3 0 (* (* 3 scl) 15)) ;日期
          )
     (command "line" p1 p2 p3 p1 "")
     (command "text" "j" "mc" pc1 (* 3 scl) 0 date1 "")
     (command "text" "j" "ml" pc2 (* 3 scl) 0 date3 "")
     (command "text" "j" "ml" pc3 (* 3 scl) 0 date4 "")
     (command "text" "j" "ml" pc4 (* 3 scl) 0 date5 "")
   (SETQ FFF nil))
   (PRINC)
);defun


;;小尺寸連續標註
;;┌────────────────────────────────┐
;;│ 程  式 : 小尺寸連續標註                                        │
;;│ 主程式 : dim.lsp                                               │
;;│ 日  期 : 88:01:18                                              │
;;│ 姓  名 : 佘宗紋                                                │
;;│ 對話框 :                                                       │
;;│ 方  法 :                                                       │  
;;│                                                                │
;;└────────────────────────────────┘
(defun c:con_dim()
              (setq
                    dim_blk1(getvar "dimblk1")
                    dim_blk2(getvar "dimblk2")
                    dim_sah(getvar "dimsah")
                    dim_fit(getvar "dimfit")
                    dim_sca(getvar "dimscale")
                    dim_txt(getvar "dimtxt")
                    dim_gap(getvar "dimgap")
                    asz (* (getvar "dimscale") (getvar "dimasz"))
                    os(getvar "osmode")
              )
     (setq oerr *error* *error* te_err_con_dim)
            (setq p_1st (getpoint "\n第一條延伸原點"))
            (setq p_2nd (getpoint "\n第二條延伸原點"))
            (c:&d&)
            (setvar "cmdecho" 0)
            (initget  "H V N")
;           (setq dimtype_key (getkword "\n對齊標註(N)/<線性標註(L)>:"))
            (setq dimtype_key (getkword "\n對齊標註(N)/垂直標註(V)/<水平標註(H)>:"))

;            (setvar "dimblk1" " ")
            (setvar "dimsah" 1)
            (setvar "dimfit" 5)
;            (command "dimblk1" ".")
;            (setvar "dimblk2" "_DOTSMALL")
            (command "dimblk1" "_NONE")
            (setvar "dimblk2" "_NONE")
            (setvar "osmode" 0)
            (setq p_txt (getpoint "\n標註線位置"))
            (cond
                  ((or (null dimtype_key)(= dimtype_key "H"))
                   ;(command "dimlinear" p_1st p_2nd "h" p_txt)
                   (if (= cad_version "INTELLICAD")
                       (command "dimlinear" p_1st p_2nd "h" p_txt "")
                       (command "dimlinear" p_1st p_2nd "h" p_txt)
                   );if

                   (setq pang (angle (inters p_1st p_2nd p_txt (polar p_txt (* 0.5 pi) 3) nil) p_txt))
                   (setq pytxt1 (cadr(cdr(assoc 11(entget(entlast))))) pytxt2 (if (= pang (* 0.5 pi))(+ pytxt1 (* dim_sca (+ dim_gap dim_txt)))(- pytxt1 (* dim_sca (+ dim_gap dim_txt)))))

                   (if (or (and (>= (angle p_1st p_2nd) 0)(< (angle p_1st p_2nd) (* 0.5 pi)))(and (> (angle p_1st p_2nd) (* 1.5 pi))(<= (angle p_1st p_2nd) (* 2.0 pi))))
                       (setq lea_ang pi lea_ang2 0)
                       (setq lea_ang 0 lea_ang2 pi)
                   );if
                   (command "dimblk1" ".")
                   (command "_leader" (list (car p_1st) (cadr p_txt) 0) (polar (list (car p_1st) (cadr p_txt) 0) lea_ang (* 3.0 asz)) "" "" "n")
                  )
                  ((= dimtype_key "V")
                   ;(command "dimlinear" p_1st p_2nd "v" p_txt)
                   (if (= cad_version "INTELLICAD")
                       (command "dimlinear" p_1st p_2nd "v" p_txt "")
                       (command "dimlinear" p_1st p_2nd "v" p_txt)
                   );if
                   (setq pang (angle (inters p_1st p_2nd p_txt (polar p_txt pi 3) nil) p_txt))
                   (setq pytxt1 (car(cdr(assoc 11(entget(entlast))))) pytxt2 (if (= pang 0)(+ pytxt1 (* dim_sca (+ dim_gap dim_txt)))(- pytxt1 (* dim_sca (+ dim_gap dim_txt)))))

                   (if (and (>= (angle p_1st p_2nd) 0)(< (angle p_1st p_2nd) pi))
                       (setq lea_ang (* 1.5 pi) lea_ang2 (* 0.5 pi))
                       (setq lea_ang (* 0.5 pi) lea_ang2 (* 1.5 pi))
                   );if
                   (command "dimblk1" ".")
                   (command "_leader" (list (car p_txt) (cadr p_1st) 0) (polar (list (car p_txt) (cadr p_1st) 0) lea_ang (* 3.0 asz)) "" "" "n")
                  )
                  ((= dimtype_key "N")
                   (command "dimaligned" p_1st p_2nd p_txt)
                   (setq pang (angle (cdr(assoc 14(entget(entlast)))) (cdr(assoc 10(entget(entlast))))))
                   (setq tang (- pang (* 0.5 pi))
                         ps (cdr(assoc 10(entget(entlast))))
                         pts (cdr(assoc 11(entget(entlast))))
                         dts (* 0.5 (distance (cdr(assoc 13(entget(entlast)))) (cdr(assoc 14(entget(entlast))))))
                         sd 0 td dts
                   )

                   (setq lea_ang (+ (* 0.5 pi) pang) lea_ang2 (- pang (* 0.5 pi)))
                   (setq plea1 (inters ps p_txt (cdr(assoc 13(entget(entlast)))) (polar (cdr(assoc 13(entget(entlast)))) pang 4) nil))
                   (command "dimblk1" ".")
                   (command "_leader" plea1 (polar plea1 lea_ang (* 3.0 pi)) "" "" "n")
                  )
            );cond
            (setq txtflag T)
                       (setvar "dimblk2" "_NONE")
                       (setvar "dimblk1" "_DOTSMALL")
       (while  (/=  p_2nd nil)
           (setvar "osmode" os)
           (setq p_2nd(getpoint "\n按Enter結束標註/<第二條延伸原點>:"))
           (setvar "osmode" 0)
                (if (/= p_2nd nil)
                    (progn
                       (setq p_1st p_2nd)
                 ;      (setvar "dimblk1" "_NONE")
                 ;      (setvar "dimblk2" "_DOTSMALL")
                       (command "dimcontinue" p_2nd "" "")
                       (setq ent(entlast))
                       (setq entdata (entget ent))
                       (setq p_txt(assoc 11 entdata))
                       (if txtflag
                          (progn
                            (cond
                             ((or (null dimtype_key)(= dimtype_key "H"))
                               (setq dtyp(assoc 70 entdata))
                               (setq ndtyp(cons 70 160))
                               (setq ndata(subst ndtyp dtyp entdata))
                               (entmod ndata)
                               (setq np_txt(cons 11 (list (car(cdr p_txt)) pytxt2 0)))
                             )
                             ((= dimtype_key "V")
                               (setq dtyp(assoc 70 entdata))
                               (setq ndtyp(cons 70 160))
                               (setq ndata(subst ndtyp dtyp entdata))
                               (entmod ndata)
                               (setq np_txt(cons 11 (list pytxt2 (cadr(cdr p_txt)) 0)))
                             )
                             ((= dimtype_key "N")
                               (setq td (+ td sd))
                               (setq dtyp(assoc 70 entdata))
                               (setq ndtyp(cons 70 160))
                               (setq ndata(subst ndtyp dtyp entdata))
                               (entmod ndata)
                            ;   (setq ndata entdata)
                               (setq sd (* 0.5 (distance ps (setq pt (cdr(assoc 10 entdata))))))
                               (setq np_txt (polar pts tang (setq td (+ td sd))))
                               (setq np_txt(cons 11 (polar np_txt pang (* dim_sca (+ dim_gap dim_txt)))))
                            ;   (setq np_txt(cons 11 (polar (cdr p_txt) pang (* dim_sca (+ dim_gap dim_txt)))))
                               (setq ps pt)
                             )
                            );cond
                             (setq nentdata(subst np_txt p_txt ndata))
                             (entmod nentdata)
                             (setq txtflag nil)
                          );progn
                          (progn
                            (cond
                             ((or (null dimtype_key)(= dimtype_key "H"))
                               (setq dtyp(assoc 70 entdata))
                               (setq ndtyp(cons 70 160))
                               (setq ndata(subst ndtyp dtyp entdata))
                               (entmod ndata)
                               (setq np_txt(cons 11 (list (car(cdr p_txt)) pytxt1 0)))
                             )
                             ((= dimtype_key "V")
                               (setq dtyp(assoc 70 entdata))
                               (setq ndtyp(cons 70 160))
                               (setq ndata(subst ndtyp dtyp entdata))
                               (entmod ndata)
                               (setq np_txt(cons 11 (list pytxt1 (cadr(cdr p_txt)) 0)))
                             )
                             ((= dimtype_key "N")
                               (setq td (+ td sd))
                               (setq dtyp(assoc 70 entdata))
                               (setq ndtyp(cons 70 160))
                               (setq ndata(subst ndtyp dtyp entdata))
                               (entmod ndata)
                             ;  (setq ndata entdata)
                               (setq sd (* 0.5 (distance ps (setq pt (cdr(assoc 10 entdata))))))
                               (setq np_txt (cons 11 (polar pts tang (setq td (+ td sd)))))
                             ;  (setq np_txt(cons 11 (polar (cdr p_txt) (+ pi pang) (* dim_sca (+ dim_gap dim_txt)))))
                               (setq ps pt)
                             )
                            );cond
                             (setq nentdata(subst np_txt p_txt ndata))
                             (entmod nentdata)
                             (setq txtflag T)
                          );progn
                       );if
                    );progn
                    (progn
                      ; (if (= acad_ver "GENIUS")
                      ;    (command ".erase" "l" "")
                      ;    (command "erase" "l" "")
                      ; )
                       (setq ent(entlast))
                      ; (setq p_prv(cdr(assoc 10(entget ent))))
                      ; (setvar "dimblk1" "_NONE")
                      ; (command "dimblk2" ".")
                      ; (command "dimcontinue" p_prv p_1st "" "")
                       (command "dimblk1" ".")
                       (command "_leader" (cdr(assoc 10(entget ent))) (polar (cdr(assoc 10(entget ent))) lea_ang2 (* 3.0 asz)) "" "" "n")
                    );progn
                );if
      );while
            (setvar "dimsah" dim_sah)
            (command "dimblk1" dim_blk1)
            (command "dimblk2" dim_blk2)
            (setvar "dimfit" dim_fit)
            (setvar "osmode" os)
     (redraw)       
)

(defun te_err_con_dim(msg)
   (if (/= msg "Function cancelled")(princ (strcat "\nError: " msg)))
   (if oerr (setq *error* oerr))
      (progn
            (setvar "dimsah" dim_sah)
            (command "dimblk1" dim_blk1)
            (command "dimblk2" dim_blk2)
            (setvar "dimfit" dim_fit)
            (setvar "osmode" os)
      )
   (princ)
)

;; 取消公差尺寸標註
;(defun c:no_tol(/ ent entdata data0 txt1_id txt1 txt2_id txt2 txt3_id txt3 txt4_id txt4 txt5_id txt5
;                data1 txtlist count)
(defun c:no_tol()
       (setq ent (entsel "\n選擇尺寸: "))
     ;  (cond
     ;    ((null ent) (princ "\n未選擇尺寸!"))
     ;    (T
       (while ent
             (setq entdata (entget (car ent))
                   data0 (cdr (assoc 0 entdata)))
                          (setvar "dimtol" 0)
             (if (= "DIMENSION" data0)
               (progn
                 (setq data1 (cdr (assoc 1 entdata)))
                 (if (or (= "" data1) (= "<>" (substr data1 (- (strlen data1) 1) 2)))
                   (progn
                      (setvar "dimtol" 0)
                      (command "dim" "up" ent "" "exit")
                   );progn
                   (progn
                     (setq txt1_id (get_word data1 "{"))
                     (if (/= nil txt1_id)
                       (progn
                          (setq txt1 (substr data1 1 (- txt1_id 1)))
                          (setq txt2_id (get_word txt1 "("))
                          (cond
                            ((/= nil txt2_id)
                              (setq txt2 (substr txt1 1 (- txt2_id 1)))
                              (command "dim" "new" txt2 ent "" "exit")
                            )
                            ((/= nil (get_word txt1 ";"))
                              (setq txt2 (substr txt1 (+ 1 (get_word txt1 ";"))))
                              (command "dim" "new" txt2 ent "" "exit")
                            )
                            (t (command "dim" "new" txt1 ent "" "exit"))
                          );if
                       );progn
                     )
                      (setq txt3_id (get_word data1 "("))
                      (if (/= nil txt3_id)
                        (progn
                          (setq txt3 (substr data1 1 (- txt3_id 1)))
                          (command "dim" "new" txt3 ent "" "exit")
                          (setq data1 txt3)
                        );progn
                      );if
                      (setq txtlist (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))
                      (setq txt4_id (get_word data1 "a") count 1)
                      (while (and (< count 26) (null txt4_id))
                         (setq txt4_id (get_word data1 (nth count txtlist)))
                         (setq count (1+ count))
                      )
                     ; (if (/= txt4_id nil)
                     ;   (progn
                     ;     (if (setq txt5_id (get_word data1 ";"))
                     ;         (setq data1 (substr data1 (+ 1 txt5_id)))
                     ;     );if
                     ;     (setq txt4 (substr data1 1 (- txt4_id 1)))
                     ; ;    (command "dim" "new" txt4 ent "" "exit")
                     ;     (command "dim" "new" "" ent "" "exit")
                     ;   );progn
                     ; );if
                   );progn
                 );if
               );progn
               (princ "\n您選的圖元不是尺寸!!")
             );if

             (setq ent (entsel "\n選擇尺寸: "))

       );while
     ;    );t
     ;  );cond
       (princ)
)


;;;
(defun c:d-tol(/ ort p1 dimsca tolp tolm texth 2tolp 2tolm 3tolp 3tolm tolang p2
                 dtol)
  (if (and (= jin "#$%")(= #### 85))(setq FFF t))
  (WHILE (/= FFF nil)
         (setq ppss sspp)
         (setq re-att (getvar "attdia"))
         (setvar "cmdecho" 0)(setvar "attdia" 0)
         (setq ort (getvar "orthomode"))
         (setq p1 (getpoint "\n按 Enter 鍵選擇公差值/<插入點>: "))
;         (setq p1 (getpoint "\n選擇插入點: "))
         (if (null p1) (c:toldim)
             (progn
                  (setq dimsca (getvar "dimscale"))
                  (setq tolp (getstring "\n上公差 <None>: ")
                        tolm (getstring "\n下公差 <None>: ")
                        texth (* dimsca 0.8)
                        3tolp (substr tolp 1 1)
                        3tolm (substr tolm 1 1))

                  (if (= 3tolp "0")
                    (progn
                      (if (> (strlen tolp) 1)
                        (setq tolp (strcat "+" tolp))
                        (setq tolp (strcat " " tolp))
                      );if
                    );progn
                  );if
                  (if (= 3tolm "0")
                    (progn
                      (if (> (strlen tolm) 1)
                        (setq tolm (strcat "+" tolm))
                        (setq tolm (strcat " " tolm))
                      );if
                    );progn
                  );if

                  (setq 2tolp (substr tolp 2)
                        2tolm (substr tolm 2))
                  (setq tolang (getangle p1 "\n旋轉角度 <0>: "))
                  (if (or (= tolang 0) (= tolang nil)) (setq tolang 0))
                  (setq  tolang (/ (* tolang 180) pi))
                  (setq p2 T)
                  (while p2
                         (if (= 2tolp 2tolm)
                             (command "insert" (strcat POWDESIGN_dwg_path "si-tol") p1 texth texth tolang (strcat "%%p" 2tolp))
                             (command "insert" (strcat POWDESIGN_dwg_path "dou-tol") p1 texth texth tolang tolm tolp)
                         );if
                            (setq dtol (entlast))
                            (setvar "orthomode" 0)
                            (setq p2(getpoint p1 "\n選擇放置點: "))
                            (command "move" dtol "" p1 p2)
                  );while
                  (entdel dtol)
             );progn
         );if
  (setvar "orthomode" ort)
  (setvar "attdia" re-att)
  (setvar "cmdecho" 1)
  (SETQ FFF nil)
  )
  (princ)
)



;;扣環標註(2003.02.12) REX
(defun c:cring_auxdim()
       (if (and (= jin "#$%")(= #### 85))(setq FFF t))
       (WHILE (/= FFF nil)
              (setq ppss sspp funcflag nil)
              (setvar "cmdecho" 0)
              (setq cecol (getvar "cecolor"))
              (setq p1 (getpoint "\n起點: "))
              (while (null p1)
                 (princ "\n未點選起點,請再點選一次! ")
                 (setq p1 (getpoint "\n起點: "))
              );while
              (setq p2 (getpoint p1 "\n下一點: "))
              (while (null p2)
                 (princ "\n未點選下一點,請再點選一次! ")
                 (setq p1 (getpoint p1 "\n下一點: "))
              )

              (actdcl (strcat powdesign_dcl_path "auxdim") "cring_auxdim")
              (set_tile "shaftc" "1")
              (setq write_str "配 ")
              (get_dimdata_cring_auxdim "cringdim.doc")
              (act_pop_list no_list "sizetype")

              (action_tile "shaftc" "(disp_dimdata_cring_auxdim \"cringdim.doc\")")
              (action_tile "holec"  "(disp_dimdata_cring_auxdim \"dringdim.doc\")")


              (action_tile "accept" "(setq funcflag T)(ok_cring_auxdim)(done_dialog)")
              (action_tile "cancel" "(setq funcflag nil)(done_dialog)")
              (start_dialog)

              (if funcflag
                  (progn
                       (setvar "cmdecho" 0)
                       (c:&d&)
                       (command "leader" p1 p2 "" write1_str write_str "")
                       ;(command "leader" p1 p2 "" write_str "")

                       (wxhauxdim_cring_auxdim (entlast) str_d2u str_d2d str_mu str_md)
                       (command "move" (entlast) "" "0,0" "1,0")
                       (command "move" (entlast) "" "1,0" "0,0")
                       ;(setq p1 (cdr (assoc 10 (entget (entlast)))))
                  );progn
              );if

              (SETQ FFF nil)
              (princ)
       );WHILE
);defun

(defun disp_dimdata_cring_auxdim(fname / ~ff ~dimdata)
              (get_dimdata_cring_auxdim fname)
              (act_pop_list no_list "sizetype")
)

(defun ok_cring_auxdim()
       (if (= "1" (get_tile "shaftc"))
           (setq write_str "配 A") ;軸用
           (setq write_str "配 B") ;孔用
       );if
       (setq write_str (strcat write_str (nth 0 (nth (atoi (get_tile "sizetype")) g_dimdata_list)) " 扣環"))
       (setq str_d3 (nth 7 (nth (atoi (get_tile "sizetype")) g_dimdata_list)))
       (setq str_d2u (strcat "+" (nth 1 (nth (atoi (get_tile "sizetype")) g_dimdata_list))))
       (setq str_d2d (strcat "-" (nth 2 (nth (atoi (get_tile "sizetype")) g_dimdata_list))))
       (setq str_m  (nth 6 (nth (atoi (get_tile "sizetype")) g_dimdata_list)))
       (setq str_mu (strcat "+" (nth 3 (nth (atoi (get_tile "sizetype")) g_dimdata_list))))
       (setq str_md (strcat "-" (nth 4 (nth (atoi (get_tile "sizetype")) g_dimdata_list))))
       (setq write1_str (strcat str_d3 "x" str_m " "))
);defun


(defun wxhauxdim_cring_auxdim(ent wtole_up wtole_down htole_up htole_down)

   (setq ent_data(entget ent))
   (setq oldstr (assoc 1 ent_data))
   (setq odstr (cdr (assoc 1 ent_data)))

   (setq xid (get_word odstr "x"))
   (setq wstr(substr odstr 1 (- xid 1)))
   (setq wstr (getrealstr wstr))

   (setq sid (get_word odstr " "))
   (setq hstr(substr odstr xid (- sid xid)))
   (setq hstr (getrealstr hstr))
   (setq estr(substr odstr (+ sid 1)))
   (setq dimsc(getvar "dimscale"))
   ;(setq tol_h(rtos (* dimsc (* 0.5 (getvar "dimtxt"))) 2))
   (setq tol_h "0.5x")
;;;w
   (if (and (/= "" wtole_up) (/= "" wtole_down))
       (progn
            (if (and (> (atof wtole_up) 0) (/= "+" (substr wtole_up 1 1)))
                (setq wtoltp (strcat "+" wtole_up))
                (setq wtoltp wtole_up)
            );if
            (if (and (> (atof wtole_down) 0) (/= "+" (substr wtole_down 1 1)))
                (setq wtoltm (strcat "+" wtole_down))
                (setq wtoltm wtole_down)
            );if
           ; (cond
           ;     ((and (> (atof wtole_down) 0) (/= "+" (substr wtole_down 1 1)))
           ;      (setq wtoltm (strcat "-" wtole_down))
           ;     );
           ;     ((and (> (atof wtole_down) 0) (= "+" (substr wtole_down 1 1)))
           ;      (setq wtoltm (strcat "-" (substr wtole_down 2)))
           ;     );
           ;     ((and (< (atof wtole_down) 0) (= "-" (substr wtole_down 1 1)))
           ;      (setq wtoltm (strcat "+" (substr wtole_down 2 )))
           ;     )
           ; );cond

            (if (/=  (atof wtoltp) (- 0 (atof wtoltm)))
                (setq new_str(strcat  wstr "{\\H" tol_h ";\\S" wtoltp "^" wtoltm ";}"))
                (setq new_str(strcat  wstr "{\\H" tol_h "%%p" wtoltp "}"))
            )
       );progn
       (setq new_str wstr)
   );if
;;;h
   (if (and (/= "" htole_up) (/= "" htole_down))
       (progn
            (if (and (> (atof htole_up) 0) (/= "+" (substr htole_up 1 1)))
                (setq htoltp (strcat "+" htole_up))
                (setq htoltp htole_up)
            );if
            (if (and (> (atof htole_down) 0) (/= "+" (substr htole_down 1 1)))
                (setq htoltm (strcat "+" htole_down))
                (setq htoltm htole_down)
            );if
            ;(cond
            ;    ((and (> (atof wtole_down) 0) (/= "+" (substr htole_down 1 1)))
            ;     (setq htoltm (strcat "-" htole_down))
            ;    );
            ;    ((and (> (atof htole_down) 0) (= "+" (substr htole_down 1 1)))
            ;     (setq htoltm (strcat "-" (substr htole_down 2)))
            ;    );
            ;    ((and (< (atof htole_down) 0) (= "-" (substr htole_down 1 1)))
            ;     (setq htoltm (strcat "+" (substr htole_down 2 )))
            ;    )
            ;);cond

            (if (/=  (atof htoltp) (- 0 (atof htoltm)))
                (setq new_str(strcat new_str hstr "{\\H" tol_h ";\\S" htoltp "^" htoltm ";}" estr))
                (setq new_str(strcat new_str hstr "{\\H" tol_h "%%p" htoltp "}" estr))
            )
       );progn
       (setq new_str(strcat new_str hstr estr))
   );if
   (setq newdata(cons 1 new_str))
   (setq ent_newdata(subst newdata oldstr ent_data))
   (entmod ent_newdata)
);defun


(defun get_dimdata_cring_auxdim(fname / ~ff ~dimdata)
              (setq g_dimdata_list '() no_list '())
              (setq ~ff (open (strcat powdesign_data_path fname) "r"))
              (read-line ~ff)
              (setq ~dimdata (read-line ~ff))
              (while ~dimdata
                     (setq g_dimdata_list(cons (read ~dimdata) g_dimdata_list))
                     (setq no_list(cons (nth 0 (read ~dimdata)) no_list))
                     (setq ~dimdata (read-line ~ff))
              );while
              (close ~ff)
              (setq g_dimdata_list (reverse g_dimdata_list))
              (setq no_list (reverse no_list))
);defun

;;鍵槽鍵座標註(2003.03.17) SAM
(defun c:keydim()
        (if (and (= jin "#$%")(= #### 85))(setq FFF t))
        (WHILE (/= FFF nil)
              (setq ppss sspp funcflag nil)
              (setvar "cmdecho" 0)
                (setq gint_flag nil)
                (setq gint_image nil)
                (actdcl (strcat powdesign_dcl_path "keydim.dcl") "keydim")
                (show_sld_col "KP1" (strcat powdesign_sld_path "keydim1.sld") 166)(setq gint_image 1)
                (show_sld_col "KP2" (strcat powdesign_sld_path "keydim2.sld") -2)
                (getkey_keydim)
                (readata_keydim)
                (action_tile "KP1"    "(showsld_keydim 1)")
                (action_tile "KP2"    "(showsld_keydim 2)")
                (action_tile "KR1"    "(getkey_keydim)")
                (action_tile "KR2"    "(getkey_keydim)")
                (action_tile "accept" "(getkey_keydim)(setq bol_flag T)(done_dialog)")
                (action_tile "cancel" "(done_dialog)")
                (start_dialog)
        (if (= T bol_flag)(drawdim_keydim))
              (SETQ FFF nil)
              (princ)
        );WHILE
)
(defun showsld_keydim(int_image)
        (setq gint_image int_image)
        (cond ((= 1 int_image)
               (show_sld_col "KP1" (strcat powdesign_sld_path "keydim1.sld") 166)
               (show_sld_col "KP2" (strcat powdesign_sld_path "keydim2.sld")  -2))
              ((= 2 int_image)
               (show_sld_col "KP1" (strcat powdesign_sld_path "keydim1.sld")  -2)
               (show_sld_col "KP2" (strcat powdesign_sld_path "keydim2.sld") 166))
        )
)       
(defun getkey_keydim()
        (setq int_temp1 (atoi (get_tile "KR1")))
        (setq int_temp2 (atoi (get_tile "KR2")))
        (cond ((= 1 int_temp1)(setq gint_flag 1))
              ((= 1 int_temp2)(setq gint_flag 2))
        )
)
(defun readata_keydim(/ fle_datb fle_datt str_data_row str_data_rsw)
        (setq glst_data1 '() glst_data2 '() glst_data3 '() glst_data4 '() 
              glst_datt1 '() glst_datt2 '() glst_datt3 '() glst_datt4 '())

        (setq fle_datb (open (strcat powdesign_data_path "keydim1.dat") "r"))
        (setq fle_datt (open (strcat powdesign_data_path "keydim2.dat") "r"))
        (setq str_data_row (read-line fle_datb))
        (setq str_data_rsw (read-line fle_datt))
        (while str_data_row
                (setq lst_data_row (read str_data_row))
                (setq glst_data1 (cons (nth 0 lst_data_row) glst_data1))
                (setq glst_data2 (cons (nth 1 lst_data_row) glst_data2))
                (setq glst_data3 (cons (nth 2 lst_data_row) glst_data3))
                (setq glst_data4 (cons (nth 3 lst_data_row) glst_data4))
                (setq str_data_row (read-line fle_datb))
        )
        (while str_data_rsw
                (setq lst_data_rsw (read str_data_rsw))
                (setq glst_datt1 (cons (nth 0 lst_data_rsw) glst_datt1))
                (setq glst_datt2 (cons (nth 1 lst_data_rsw) glst_datt2))
                (setq glst_datt3 (cons (nth 2 lst_data_rsw) glst_datt3))
                (setq glst_datt4 (cons (nth 3 lst_data_rsw) glst_datt4))
                (setq str_data_rsw (read-line fle_datt))
        )
        (setq glst_data1 (reverse glst_data1))
        (setq glst_data2 (reverse glst_data2))
        (setq glst_data3 (reverse glst_data3))
        (setq glst_data4 (reverse glst_data4))
        (setq glst_datt1 (reverse glst_datt1))
        (setq glst_datt2 (reverse glst_datt2))
        (setq glst_datt3 (reverse glst_datt3))
        (setq glst_datt4 (reverse glst_datt4))
        (close fle_datb)(close fle_datt)
)

(defun drawdim_keydim(/ int_i int_p int_idx flt_dist flt_ang flt_radius lst_pick lst_ent1 pnt_center pnt_radius pnt_p3 pnt_p5 pnt_p6)
        (setq osmode (getvar "osmode"))
        (setq oerr *error* *error* te_err_keydim)
        (setq pnt_p1 (getpoint "\n標註第一點: "))
        (setq pnt_p2 (getpoint "\n標註第二點: "))
        (setvar "osmode" 0)
        (setq flt_dist (distance pnt_p1 pnt_p2))
        
        (setq int_i 0)
        (repeat (length glst_data1)
                (setq lst_item (nth int_i glst_data1))
                (if (and (>= flt_dist (atof (nth 0 lst_item)))(< flt_dist (atof (nth 1 lst_item))))(setq int_itemid int_i))
                (setq int_i (1+ int_i))
        );;;取得尺寸所在範圍 int_itemid
        (cond ((= 1 gint_image)
               (cond ((= 1 gint_flag)
                      (setq gflt_udim (nth 0 (nth int_itemid glst_data2)))
                      (setq gflt_sdim (nth 1 (nth int_itemid glst_data2)))
                     )
                     ((= 2 gint_flag)
                      (setq gflt_udim (nth 0 (nth int_itemid glst_data3)))
                      (setq gflt_sdim (nth 1 (nth int_itemid glst_data3)))
                     )
              ))
              ((= 2 gint_image)
               (cond ((= 1 gint_flag)
                      (setq gflt_udim (nth 0 (nth int_itemid glst_data2)))
                      (setq gflt_sdim (nth 1 (nth int_itemid glst_data2)))
                     )
                     ((= 2 gint_flag)
                      (setq gflt_dim (nth int_itemid glst_data4))
                     )
              ))
        );;;鍵槽或鍵座 gint_image 精級或普通級 gint_flag
        (setq flt_ang (angle pnt_p1 pnt_p2))
        (setq pnt_pt  (polar pnt_p2 (+ (* pi 0.5) flt_ang) (* (getvar "dimdli") 2)))
        (c:&d&)
        (command "dimaligned" pnt_p2 pnt_p1 pnt_pt)
  
        (if (and (= 2 gint_image)(= 2 gint_flag))
                (setq str_txt (strcat "<>%%p" gflt_dim))
                (setq str_txt (strcat "\\A1;<>{\\H0.5x;\\S" gflt_udim "^" gflt_sdim ";}"))
        )  
        (setq lst_dim1 (entget (entlast)))
        (setq lst_dim2 (assoc 1 lst_dim1))
        (setq lst_dim3 (cons  1 str_txt))
        (setq lst_dim1 (subst lst_dim3 lst_dim2 lst_dim1))
        (entmod lst_dim1)
        (setvar "osmode" osmode)
        ;;;-------------------------------------------------------------------------------------
        (setq lst_pick (entsel "\n選擇標註圓弧: "))
        (setvar "osmode" 0)
        (while (null pnt_p3)
        (while (null lst_pick)
               (setq lst_pick (entsel "\n非圓弧,請選擇標註圓弧: "))
        )
        (setq lst_ent1 (entget (car lst_pick)))

        (while (/= "ARC" (cdr (assoc 0 lst_ent1)))
               (setq lst_pick (entsel "\n非圓弧,請選擇標註圓弧: "))
               (if (/= nil lst_pick)(setq lst_ent1 (entget (car lst_pick))))
        )
        (setq flt_radius (cdr (assoc 40 lst_ent1)))
        (setq pnt_center (cdr (assoc 10 lst_ent1)))
        (if (= 2 gint_image)(progn
                            (setq pnt_radius (polar pnt_center (+ flt_ang (* 1.5 pi)) flt_radius))
                            (setq pnt_radius_dist (polar pnt_center (+ flt_ang (* 0.5 pi)) flt_radius))))
        (if (= 1 gint_image)(setq pnt_radius (polar pnt_center (+ flt_ang (* 0.5 pi)) flt_radius)))
        (if (= 2 gint_image)(setq pnt_p3  (inters pnt_p1 pnt_p2 pnt_center pnt_radius nil)))
        (if (= 1 gint_image)(progn
                            (setq ent_select (ssget "F" (list pnt_center pnt_radius)))
                            (if (null ent_select)(progn (princ "圖形錯誤")(exit)))
                            (setq int_idx 0)
                            (while (ssname ent_select int_idx)
                                   (setq lst_entity (entget (ssname ent_select int_idx)))
                                   (setq str_entname(cdr (assoc 0 lst_entity)))
                                   (cond ((= "LINE" str_entname)
                                          (setq pnt_temp1 (cdr (assoc 10 lst_entity)))
                                          (setq pnt_temp2 (cdr (assoc 11 lst_entity)))
                                          (setq str_dist0 (rtos flt_dist 2 2))
                                          (setq str_dist1 (rtos (distance pnt_temp1 pnt_temp2) 2 2))
                                          (setq str_dist2 (rtos (distance pnt_temp1 pnt_p1) 2 2))
                                          (setq str_dist3 (rtos (distance pnt_temp2 pnt_p2) 2 2))
                                          (setq str_ang1  (rtos (angle pnt_temp1 pnt_temp2) 2 2))
                                          (setq str_ang2  (rtos (angle pnt_p1 pnt_p2) 2 2))
                                          (cond ((and (= str_dist0 str_dist1)(= str_dist2 str_dist3))
                                                 (setq pnt_p3 (inters pnt_temp1 pnt_temp2 pnt_center pnt_radius nil))
                                                )
                                          ))
                                   )
                                   (setq int_idx (1+ int_idx))
                                   )
                            ))
                (if (= nil pnt_p3)(setq lst_pick nil))

        )
        ;(if (= 1 gint_image)(setq pnt_p5 (polar pnt_p3 flt_ang (* (getvar "dimdli") 2))))
        (setq pnt_p5 (polar pnt_p3 flt_ang (- (+ flt_radius (* (getvar "dimdli") 2))(/ flt_dist 2))))
        (setq pnt_p6 (polar pnt_p3 flt_ang (/ flt_dist 2)))

        (setq int_p 0)
        (cond ((= 1 gint_image)
               (setq lst_flag_data glst_datt1)
               (setq flt_dist_t (distance pnt_radius pnt_p3)))
              ((= 2 gint_image)
               (setq lst_flag_data glst_datt2)
               (setq flt_dist_t (distance pnt_radius_dist pnt_p3)))
        )
        (repeat (length lst_flag_data)
                (setq lst_item (nth int_p lst_flag_data))
                (if (and (>= flt_dist_t (atof (nth 0 lst_item)))(< flt_dist_t (atof (nth 1 lst_item))))(setq int_itemid int_p))
                (setq int_p (1+ int_p))
        );;;取得尺寸所在範圍 int_itemid

        (setq gflt_udimt (nth int_itemid glst_datt3))
        (setq gflt_sdimt (nth int_itemid glst_datt4))

        (if (= 1 gint_image)(command "dimaligned" pnt_p3 pnt_radius pnt_p5))
        (if (= 2 gint_image)(command "dimaligned" pnt_radius pnt_p3 pnt_p5))
        (setq ent_dimt (entlast))
        (if (= 1 gint_image)(command "move" ent_dimt "" pnt_p3 pnt_p6))
        (if (= 2 gint_image)(command "move" ent_dimt "" pnt_p3 pnt_p6))

        (setq str_txt (strcat "\\A1;<>{\\H0.5x;\\S" gflt_udimt "^" gflt_sdimt ";}"))
        (setq lst_dim1 (entget (entlast)))
        (setq lst_dim2 (assoc 1 lst_dim1))
        (setq lst_dim3 (cons  1 str_txt))
        (setq lst_dim1 (subst lst_dim3 lst_dim2 lst_dim1))
        (entmod lst_dim1)
        (setvar "osmode" osmode)
)
(defun te_err_keydim(msg)
   (if (/= msg "Function cancelled")(princ (strcat "\nError: " msg)))
   (if oerr (setq *error* oerr))
      (progn
       (setvar "osmode" osmode)
      )
   (princ)
)

;;引線標註帶辭庫(整體)
(defun c:autolead2()
       (if (and (= jin "#$%")(= #### 85))(setq FFF t))
       (WHILE (/= FFF nil)
              (setq ppss sspp)
              (if (null c:useword)(load "wordlib1"))
              (setvar "cmdecho" 0)
              (setq cecol (getvar "cecolor"))
              (setq p1 (getpoint "\n起點: "))
              (while (null p1)
                 (princ "\n未點選起點,請再點選一次! ")
                 (setq p1 (getpoint "\n起點: "))
              );while
              (setq p2 (getpoint p1 "\n下一點: "))
              (while (null p2)
                 (princ "\n未點選下一點,請再點選一次! ")
                 (setq p1 (getpoint p1 "\n下一點: "))
              )
              (setq get_wordlibdata t)
              (setq write_list (reverse (useword 1 2)))
              (setvar "cmdecho" 0)
              (c:&d&)
              (command "leader" p1 p2 "")
              (foreach nn write_list
                          (command nn)
              );foreach
              (command "")
              (SETQ FFF nil)
              (princ)
       );WHILE

);defun


;;引線標註帶辭庫
;typ=1 使用辭庫
;typ=0 使用於 45 度倒角
(defun c:autolead() (autolead 1))
(defun autolead(typ)
  (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (if (null c:useword)(load "wordlib1"))
  (setvar "cmdecho" 0)
  (setq cecol (getvar "cecolor"))
  (if (= typ 1)
    (progn
      (setq p1 (getpoint "\n起點: "))
      (while (null p1)
         (princ "\n未點選起點,請再點選一次! ")
         (setq p1 (getpoint "\n起點: "))
      );while
    );progn
  );if
    (setq p2 (getpoint p1 "\n下一點: "))
    (while (null p2)
       (princ "\n未點選下一點,請再點選一次! ")
       (setq p1 (getpoint p1 "\n下一點: "))
    )
   (if (= typ 1)
     (progn
       (setq get_wordlibdata t)
       (setq write_list (reverse (useword 1 2)))
       (setq txt (nth 0 write_list))
       (setvar "cmdecho" 0)
     );progn
   );if
   (mem_curset)
   (setvar "osmode" 0)
   (setq scal (getvar "dimscale")
         asz  (getvar "dimasz"))
   (c:&d&)
   (setq ang (angle p1 p2)
         ang2 (angle p1 (list (nth 0 p2) (nth 1 p1))))
   (if (= 0 ang2)
     (progn
       (setq p3 (polar p2 ang2 scal)
             txtp (polar p3 (* pi 0.5) (* scal (getvar "dimgap"))))
       (setq height (* scal (getvar "dimtxt")))
       (if (= typ 1)
         (progn
           (command "text" txtp (* scal (getvar "dimtxt")) "0" txt)
           (change_color_autolead "dimclrt")
           ;(setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
           (if (= cad_version "INTELLICAD")
               (setq txtlen (nth 0 (nth 1 (textbox (entget (entlast))))))
               (setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
           );if
           (foreach nn (cdr write_list)
              (progn
                (setq txtp (polar txtp (+ (* 0.5 pi) ang2) (* 1.62 (* scal (getvar "dimtxt")))))
                (command "text" txtp height ang2 nn)
                (change_color_autolead "dimclrt")
                ;(setq tl (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
                (if (= cad_version "INTELLICAD")
                    (setq tl (nth 0 (nth 1 (textbox (entget (entlast))))))
                    (setq tl (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
                );if
                (if (> tl txtlen)(setq txtlen tl))
                (setq height (cdr (assoc 40 (entget (entlast)))))
              );progn
           );foreach
         );progn
         (progn
           (command "text" txtp (* scal (getvar "dimtxt")) "0" ttttxt)
           (change_color_autolead "dimclrt")
           ;(setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
           (if (= cad_version "INTELLICAD")
               (setq txtlen (nth 0 (nth 1 (textbox (entget (entlast))))))
               (setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
           );if
         );progn
       );if
     );progn
     (progn
       (setq p3 (polar p2 ang2 (* 2 scal))
             txtp (polar p3 (* pi 0.5) (* scal (getvar "dimgap"))))
       (if (= typ 1)
         (progn
           (command "text" "R" txtp (* scal (getvar "dimtxt")) "0" txt)
           (change_color_autolead "dimclrt")
           ;(setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
           (if (= cad_version "INTELLICAD")
               (setq txtlen (nth 0 (nth 1 (textbox (entget (entlast))))))
               (setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
           )
           (setq height (* scal (getvar "dimtxt")))
           (foreach nn (cdr write_list)
             (progn
                (setq txtp (polar txtp (+ (* 1.5 pi) ang2) (* 1.62 (* scal (getvar "dimtxt")))))
                (command "text" "R" txtp (* scal (getvar "dimtxt")) "0" nn)
                (change_color_autolead "dimclrt")
                ;(setq tl (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
                (if (= cad_version "INTELLICAD")
                    (setq tl (nth 0 (nth 1 (textbox (entget (entlast))))))
                    (setq tl (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
                );if
                (if (> tl txtlen)(setq txtlen tl))
                (setq height (cdr (assoc 40 (entget (entlast)))))
              );progn
           );foreach
         );progn
         (progn
           (command "text" "R" txtp (* scal (getvar "dimtxt")) "0" ttttxt)
           (change_color_autolead "dimclrt")
           ;(setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
           (if (= cad_version "INTELLICAD")
               (setq txtlen (nth 0 (nth 1 (textbox (entget (entlast))))))
               (setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
           )
         );progn
       );if
     );progn
   )
 (setvar "cmdecho" 0)
   (setq a1 (polar p1 ang (* scal asz))
         p4 (polar p1 ang (distance p1 p2))
         p5 (polar p4 ang2 (+ (* 2 scal) txtlen)))
   (command "pline" p1 "w" "0" scal a1 "w" "0" "0" p4 p5 "")
   (change_color_autolead "dimclrd")
   (rt_to_old_set)
   (SETQ FFF nil))
   (setvar "cmdecho" 1)
    (princ)

)
;;;改變標註文字與引線顏色
;;;                         變數名稱  dimclrt=>標註文字顏色 dimclrd=>標註線&引線顏色
(defun change_color_autolead(varname)
       (cond
           ((= 256 (getvar varname)) (command "chprop" (entlast) "" "c" "bylayer" ""))
           ((= 0  (getvar varname)) (command "chprop" (entlast) "" "c" cecol ""))
           (t (command "chprop" (entlast) "" "c" (getvar varname) ""))
       )
);defun


;;45 度倒角標註 (REX)
(defun c:dimcham(/ entdata enttype 10data 11data p1_1 p1_2 grp1 grp2 chent1 chent1_0data
                   interp p1dist1 p1dist2 p2_1 p2_2 chent2 chent2_0data chent1_10data chent1_11data
                   p2dist1 p2dist2 dist1 dist2    dimtype txt chent2_10data chent2_11data entang)
   (mem_curset)
   (setvar "osmode" 512)
   (setq ent (entsel "\n選取倒角: "))
   (setvar "osmode" 0)
   (if ent
     (progn
        (setq entdata (entget (car ent)))
        (setq enttype (cdr (assoc 0 entdata)))
        (if (/= "LINE" enttype)
            (princ "\n您選的圖元不是 LINE !")
            (progn
                 (setq 10data (cdr (assoc 10 entdata)))
                 (setq 11data (cdr (assoc 11 entdata)))
                 (setq entang(* 180 (/ (angle 10data 11data) pi)))
                 (command "copy" (car ent) "" 10data 10data)
                 (setq ent1 (entlast))
                ; (setq ang1 (rtos (- 90.0 entang) 2))
                 (command "rotate" ent1 "" 10data "45")
                 (setq ent1_10data (cdr (assoc 10 (entget ent1))))
                 (setq ent1_11data (cdr (assoc 11 (entget ent1))))
                 (command "copy" (car ent) "" 11data 11data)
                 (setq ent2 (entlast))
                ; (setq ang2 (rtos (- 0.0 entang) 2))
                 (command "rotate" ent2 "" 11data "-45")
                 (setq ent2_10data (cdr (assoc 10 (entget ent2))))
                 (setq ent2_11data (cdr (assoc 11 (entget ent2))))
                 (setq interp (inters ent1_10data ent1_11data ent2_10data ent2_11data nil))
                 (setq dist1 (distance 10data interp))
                 (setq dist2 (distance 11data interp))
                 (setq dist1 (atof (rtos dist1 2 2)))
                 (setq dist2 (atof (rtos dist2 2 2)))
                 (entdel ent1)
                 (entdel ent2)
                 (if (= dist1 dist2)
                   (progn
                     (setq p1 (nth 1 ent))
                     (if (= dist1 (fix dist1))(setq dist (rtos dist1 2 0))(setq dist (rtos dist1 2 2)))
                     (initget "1 2")
                     (setq dimtype (getkword (strcat "\n選取標註模式(1) C" dist " (2) " dist "x45度 <1>: ")))
                     (if (null dimtype)(setq dimtype "1"))
                     (if (= "1" dimtype)(setq ttttxt (strcat "C" dist))
                                        (setq ttttxt (strcat dist "x45%%d")))
                     (setq p1 (osnap (nth 1 ent) "nea"))
                     (autolead 0)
                   )
                   (princ "\n不是 45度 倒角 , 不于處理 !")
                 )
            );progn
        );if
     );progn
   );if
   (rt_to_old_set)
   (princ)
);defun

;;45 度倒角標註
;; 相關程式 (autolead)
(defun c:dimcham_old(/ entdata enttype 10data 11data p1_1 p1_2 grp1 grp2 chent1 chent1_0data
                   interp p1dist1 p1dist2 p2_1 p2_2 chent2 chent2_0data chent1_10data chent1_11data
                   p2dist1 p2dist2 dist1 dist2    dimtype txt chent2_10data chent2_11data)
   (mem_curset)
   (setvar "osmode" 512)
   (setq ent (entsel "\n選取倒角: "))
   (setvar "osmode" 0)
   (if ent
     (progn
        (setq entdata (entget (car ent)))
        (setq enttype (cdr (assoc 0 entdata)))
        (if (/= "LINE" enttype)
          (princ "\n您選的圖元不是 LINE !")
          (progn
             (setq 10data (cdr (assoc 10 entdata)))
             (setq 11data (cdr (assoc 11 entdata)))
             (setq p1_1 (polar 10data (* pi 0.25) 0.1))
             (setq p1_2 (polar 10data (+ pi (* pi 0.25)) 0.1))
             (setq grp1 (ssget "c" p1_1 p1_2 ))
                  (setq p2_1 (polar 11data (* pi 0.25) 0.1))
                  (setq p2_2 (polar 11data (+ pi (* pi 0.25)) 0.1))
                  (setq grp2 (ssget "c" p2_1 p2_2 ))

             (setq aa1 (sslength grp1))
             (setq aa2 (sslength grp2))
             (if (and (>= (sslength grp1) 2)(>= (sslength grp2) 2))
               (progn
                  (setq grp1 (ssdel (car ent) grp1))
                  (setq chent1 (ssname grp1 0))
                  (setq chent1_0data (cdr (assoc 0 (entget chent1))))
                  (setq grp2 (ssdel (car ent) grp2))
                  (setq chent2 (ssname grp2 0))
                  (setq chent2_0data (cdr (assoc 0 (entget chent2))))
                  (if (and (= "LINE" chent1_0data) (= "LINE" chent2_0data))
                    (progn
                      (setq chent1_10data (cdr (assoc 10 (entget chent1))))
                      (setq chent1_11data (cdr (assoc 11 (entget chent1))))
                      (setq chent2_10data (cdr (assoc 10 (entget chent2))))
                      (setq chent2_11data (cdr (assoc 11 (entget chent2))))
                      (setq interp (inters chent1_10data chent1_11data chent2_10data chent2_11data nil)
                            p1dist1 (distance interp chent1_10data)
                            p1dist2 (distance interp chent1_11data)
                            p2dist1 (distance interp chent2_10data)
                            p2dist2 (distance interp chent2_11data))
                      (if (> p1dist1 p1dist2)(setq dist1 p1dist2)(setq dist1 p1dist1))
                      (if (> p2dist1 p2dist2)(setq dist2 p2dist2)(setq dist2 p2dist1))
                      (setq dist1 (atof (rtos dist1 2 2)))
                      (setq dist2 (atof (rtos dist2 2 2)))
                      (if (= dist1 dist2)
                        (progn
                          (setq p1 (nth 1 ent))
                          (if (= dist1 (fix dist1))(setq dist (rtos dist1 2 0))(setq dist (rtos dist1 2 2)))
                          (initget "1 2")
                          (setq dimtype (getkword (strcat "\n選取標註模式(1) C" dist " (2) " dist "x45度 <1>: ")))
                          (if (null dimtype)(setq dimtype "1"))
                          (if (= "1" dimtype)(setq ttttxt (strcat "C" dist))
                                             (setq ttttxt (strcat dist "x45%%d")))
                          (setq p1 (osnap (nth 1 ent) "nea"))
                          (autolead 0)
                        )
                        (princ "\n不是 45度 倒角!")
                      )
                    );progn
                    (princ "\n倒角兩邊的圖元不是 LINE, 無法計算其交點資料 !")
                  );if
               );progn
               (princ "\n不是 45度 倒角,不于處理!")
             );if
          );progn
        );if
     );progn
   )
   (rt_to_old_set)
   (princ)
)

;;熔接符號
(defun c:wedmark(/ p2 p1 p3 ~d1 ~d2)
  (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (setvar "cmdecho" 0)
  (mem_curset)

  (princ "\n畫熔接符號...")
  ;--------2003.02.13 SAM-------------------
  (setvar "osmode" 32)
  (setq p3 (getpoint "\n熔接點: "))
  (setvar "osmode" 512)
  (setq p1 (getangle p3 "\n第一腳長方向: "))
  (setq ~d1 (getreal "\n第一腳長長度: "))
  (setq p2 (getangle p3 "\n第二腳長方向: "))
  (setq ~d2 (getreal "\n第二腳長長度: "))
  (setq p1 (polar p3 p1 ~d1))
  (setq p2 (polar p3 p2 ~d2)) 
  (setvar "osmode" 0)
  (command "solid" p1 p2 p3 "" "")
  ;-----------------------------------------
  (rt_to_old_set)
  (setvar "cmdecho" 1)
   (SETQ FFF nil))
   (princ)
)

;;45 度倒角標註(rex)
;; 相關程式 (autolead)
(defun c:dimcham2(/ ent entdata enttype 10data 11data p1_1 p1_2 grp1
               grp2 p2_1 p2_2 chent1 chent1_0data entt
               interp dist1 p2 chent2 chent2_0data data10 data11
               p1dist1 dist2  chent1_10data ang scal asz a1 ang1 txtp
               p1dist2 p1 dist chent1_11data
               p2dist1 dimtype  chent2_10data
               p2dist2 txt    chent2_11data)
   (mem_curset)
   (setvar "osmode" 512)
   (setq cecol (getvar "cecolor"))
   (setq ent (entsel "\n選取倒角: "))
   (setvar "osmode" 0)
   (if ent
     (progn
        (setq entdata (entget (car ent)))
        (setq enttype (cdr (assoc 0 entdata)))
        (if (/= "LINE" enttype)
          (princ "\n您選的圖元不是 LINE !")
          (progn
                 (setq 10data (cdr (assoc 10 entdata)))
                 (setq 11data (cdr (assoc 11 entdata)))
                 (setq entang(* 180 (/ (angle 10data 11data) pi)))
                 (command "copy" (car ent) "" 10data 10data)
                 (setq ent1 (entlast))
                ; (setq ang1 (rtos (- 90.0 entang) 2))
                 (command "rotate" ent1 "" 10data "45")
                 (setq ent1_10data (cdr (assoc 10 (entget ent1))))
                 (setq ent1_11data (cdr (assoc 11 (entget ent1))))
                 (command "copy" (car ent) "" 11data 11data)
                 (setq ent2 (entlast))
                ; (setq ang2 (rtos (- 0.0 entang) 2))
                 (command "rotate" ent2 "" 11data "-45")
                 (setq ent2_10data (cdr (assoc 10 (entget ent2))))
                 (setq ent2_11data (cdr (assoc 11 (entget ent2))))
                 (setq interp (inters ent1_10data ent1_11data ent2_10data ent2_11data nil))
                 (setq dist1 (distance 10data interp))
                 (setq dist2 (distance 11data interp))
                 (setq dist1 (atof (rtos dist1 2 2)))
                 (setq dist2 (atof (rtos dist2 2 2)))
                 (entdel ent1)
                 (entdel ent2)
                 (if (= dist1 dist2)
                   (progn
                     (setq p1 (nth 1 ent))
                     (if (= dist1 (fix dist1))(setq dist (rtos dist1 2 0))(setq dist (rtos dist1 2 2)))
                     (initget "1 2")
                     (setq dimtype (getkword (strcat "\n選取標註模式(1) C" dist " (2) " dist "x45度 <1>: ")))
                     (if (null dimtype)(setq dimtype "1"))
                     (if (= "1" dimtype)(setq txt (strcat "C" dist))
                                        (setq txt (strcat dist "x45%%d")))
;;;=============================================================================
                     (setq p1 (osnap (nth 1 ent) "nea"))
                     (setq p2 (getpoint p1 "\n下一點: "))
                     (while (null p2)
                        (princ "\n未點選下一點,請再點選一次! ")
                        (setq p1 (getpoint p1 "\n下一點: "))
                     )
                     (command "line" p2 (osnap p1 "per") "")
                     (setq entt (entlast))
                     (setq data10 (cdr (assoc 10 (entget entt))))
                     (setq data11 (cdr (assoc 11 (entget entt))))
                     (entdel entt)
                     (if (= 0 (distance p2 data10))
                       (setq ang (angle data11 p2) p1 data11)
                       (setq ang (angle data10 p2) p1 data10)
                     )
                     (setq scal (getvar "dimscale")
                           asz  (getvar "dimasz"))
                     (setq a1 (polar p1 ang (* scal asz)))
                     (c:&d&)
                     (command "pline" p1 "w" "0" scal a1 "w" "0" "0" p2 "")
                     (change_color_autolead "dimclrd")
                     (setq ang1 (angle p1 p2))
                     (setq txtp (polar p2 (+ (* pi 0.5) ang1) (* scal (getvar "dimgap"))))
                     (if (or (and (> ang1  (* pi 1.5)) (< ang1  (* pi 2)))(and (>= ang1  0)(<= ang1  (* pi 0.5))))
                              (command "text" "R" (polar p2 (+ (* pi 0.5) ang1) (* scal (getvar "dimgap"))) (* scal (getvar "dimtxt")) (rtd (angle p1 p2)) txt)
                              (command "text" (polar p2 (- ang1 (* pi 0.5)) (* scal (getvar "dimgap"))) (* scal (getvar "dimtxt")) (rtd (angle p2 p1)) txt)
                     );if
                     (change_color_autolead "dimclrt")
                     (rt_to_old_set)
;;;=============================================================================
               )
               (princ "\n不是 45度 倒角,不于處理!")
             );if
          );progn
        );if
     );progn
   )
   (rt_to_old_set)
   (princ)
)

(defun c:dimcham2_old(/ ent entdata enttype 10data 11data p1_1 p1_2 grp1
               grp2 p2_1 p2_2 chent1 chent1_0data entt
               interp dist1 p2 chent2 chent2_0data data10 data11
               p1dist1 dist2  chent1_10data ang scal asz a1 ang1 txtp
               p1dist2 p1 dist chent1_11data
               p2dist1 dimtype  chent2_10data
               p2dist2 txt    chent2_11data)
   (mem_curset)
   (setvar "osmode" 512)
   (setq cecol (getvar "cecolor"))
   (setq ent (entsel "\n選取倒角: "))
   (setvar "osmode" 0)
   (if ent
     (progn
        (setq entdata (entget (car ent)))
        (setq enttype (cdr (assoc 0 entdata)))
        (if (/= "LINE" enttype)
          (princ "\n您選的圖元不是 LINE !")
          (progn
             (setq 10data (cdr (assoc 10 entdata)))
             (setq 11data (cdr (assoc 11 entdata)))
             (setq p1_1 (polar 10data (* pi 0.25) 0.5))
             (setq p1_2 (polar 10data (+ pi (* pi 0.25)) 0.5))
             (setq grp1 (ssget "c" p1_1 p1_2 ))
                  (setq p2_1 (polar 11data (* pi 0.25) 0.5))
                  (setq p2_2 (polar 11data (+ pi (* pi 0.25)) 0.5))
                  (setq grp2 (ssget "c" p2_1 p2_2 ))

             (if (and (>= (sslength grp1) 2)(>= (sslength grp2) 2))
               (progn
                  (setq grp1 (ssdel (car ent) grp1))
                  (setq chent1 (ssname grp1 0))
                  (setq chent1_0data (cdr (assoc 0 (entget chent1))))
                  (setq grp2 (ssdel (car ent) grp2))
                  (setq chent2 (ssname grp2 0))
                  (setq chent2_0data (cdr (assoc 0 (entget chent2))))
                  (if (and (= "LINE" chent1_0data) (= "LINE" chent2_0data))
                    (progn
                      (setq chent1_10data (cdr (assoc 10 (entget chent1))))
                      (setq chent1_11data (cdr (assoc 11 (entget chent1))))
                      (setq chent2_10data (cdr (assoc 10 (entget chent2))))
                      (setq chent2_11data (cdr (assoc 11 (entget chent2))))
                      (setq interp (inters chent1_10data chent1_11data chent2_10data chent2_11data nil)
                            p1dist1 (distance interp chent1_10data)
                            p1dist2 (distance interp chent1_11data)
                            p2dist1 (distance interp chent2_10data)
                            p2dist2 (distance interp chent2_11data))
                      (if (> p1dist1 p1dist2)(setq dist1 p1dist2)(setq dist1 p1dist1))
                      (if (> p2dist1 p2dist2)(setq dist2 p2dist2)(setq dist2 p2dist1))
                      (setq dist1 (atof (rtos dist1 2 2)))
                      (setq dist2 (atof (rtos dist2 2 2)))
                      (if (= dist1 dist2)
                        (progn
                          (setq p1 (nth 1 ent))
                          (if (= dist1 (fix dist1))(setq dist (rtos dist1 2 0))(setq dist (rtos dist1 2 2)))
                          (initget "1 2")
                          (setq dimtype (getkword (strcat "\n選取標註模式(1) C" dist " (2) " dist "x45度 <1>: ")))
                          (if (null dimtype)(setq dimtype "1"))
                          (if (= "1" dimtype)(setq txt (strcat "C" dist))
                                             (setq txt (strcat dist "x45%%d")))
;;;=============================================================================
    (setq p1 (nth 1 ent))
    (setq p2 (getpoint p1 "\n下一點: "))
    (while (null p2)
       (princ "\n未點選下一點,請再點選一次! ")
       (setq p1 (getpoint p1 "\n下一點: "))
    )
    (command "line" p2 (osnap p1 "per") "")
    (setq entt (entlast))
    (setq data10 (cdr (assoc 10 (entget entt))))
    (setq data11 (cdr (assoc 11 (entget entt))))
    (entdel entt)
    (if (= 0 (distance p2 data10))
      (setq ang (angle data11 p2) p1 data11)
      (setq ang (angle data10 p2) p1 data10)
    )
    (setq scal (getvar "dimscale")
          asz  (getvar "dimasz"))
    (setq a1 (polar p1 ang (* scal asz)))
    (c:&d&)
    (command "pline" p1 "w" "0" scal a1 "w" "0" "0" p2 "")
    (change_color_autolead "dimclrd")
    (setq ang1 (angle p1 p2))
    (setq txtp (polar p2 (+ (* pi 0.5) ang1) (* scal (getvar "dimgap"))))
    (if (or (and (> ang1  (* pi 1.5)) (< ang1  (* pi 2)))(and (>= ang1  0)(<= ang1  (* pi 0.5))))
             (command "text" "R" (polar p2 (+ (* pi 0.5) ang1) (* scal (getvar "dimgap"))) (* scal (getvar "dimtxt")) (rtd (angle p1 p2)) txt)
             (command "text" (polar p2 (- ang1 (* pi 0.5)) (* scal (getvar "dimgap"))) (* scal (getvar "dimtxt")) (rtd (angle p2 p1)) txt)
    );if
    (change_color_autolead "dimclrt")
    (rt_to_old_set)
;;;=============================================================================
                        )
                        (princ "\n不是 45度 倒角!")
                      )
                    );progn
                    (princ "\n倒角兩邊的圖元不是 LINE, 無法計算其交點資料 !")
                  );if
               );progn
               (princ "\n不是 45度 倒角,不于處理!")
             );if
          );progn
        );if
     );progn
   )
   (rt_to_old_set)
   (princ)
)

;;;╭════════════════════════════════════════════╮
;;;║設計日期: 2000.9.19                                                                     ║
;;;║更新日期:                                                                               ║
;;;║設 計 者: 佘宗紋                                                                        ║
;;;║功能說明: 使用者自定公差標註                                                            ║
;;;║相關檔案:                                                                               ║
;;;║相關副程式                                                                              ║
;;;╰════════════════════════════════════════════╯
;(defun c:toldim(/ notelist uplist downlist index data note up down )
(defun c:toldim(/ notelist uplist downlist index data note)
       (setq notelist '() uplist '() downlist '() index nil)
       (setvar "cmdecho" 1)


;;;===================取出 tolerance.dat 各組公差==================
       (setq ff (open (strcat POWDESIGN_data_path "tolerance.dat") "r"))
       (setq data (read-line ff))
       (while (/= nil data)
                     (setq data (read data))
                     (setq note (nth 0 data))
                     (setq up (nth 1 data))
                     (setq down (nth 2 data))
                     (setq notelist (cons note notelist))
                     (setq uplist   (cons up uplist))
                     (setq downlist (cons down downlist))
                     (setq data (read-line ff))
       );
       (close ff)
       (setq notelist(reverse notelist))
       (setq uplist(reverse uplist))
       (setq downlist(reverse downlist))


       (actdcl (strcat POWDESIGN_dcl_path "auxdim") "toldim")

       (set_tile "use" "1")
       (setq use "1")

       (mode_tile "add" 1)
       (mode_tile "edit" 1)
       (mode_tile "del" 1)

       (action_tile "use" "(setq use $VALUE)(exe_use_toldim)")

       (action_tile "note" "(setq index $VALUE)(set_tile \"up\" index)(set_tile \"down\" index)(exe_note_up_down index)")
       (action_tile "up" "(setq index $VALUE)(set_tile \"note\" index)(set_tile \"down\" index)(exe_note_up_down index)")
       (action_tile "down" "(setq index $VALUE)(set_tile \"note\" index)(set_tile \"up\" index)(exe_note_up_down index)")

       (action_tile "add" "(modify_item_toldim \"新增\")")
       (action_tile "edit" "(modify_item_toldim \"編輯\")")
       (action_tile "del" "(del_item_toldim)")


       (act_pop_list notelist "note")
       (act_pop_list uplist "up")
       (act_pop_list downlist "down")



       (action_tile "accept" "(setq action_func T)(toldim_ok)")
       (action_tile "cancel" "(setq action_func nil)(done_dialog)")

       (start_dialog)

       (if action_func
           (progn
             (if (= "1" use)
                 (usertol up down)
                 (progn     ;;;公差組變更
                         (setq i 0)
                         (setq ff (open (strcat POWDESIGN_data_path "tolerance.dat") "w"))
                         (repeat (length notelist)
                                (write-line (strcat "(\"" (nth i notelist) "\" \"" (nth i uplist) "\" \"" (nth i downlist) "\")") ff)
                                (setq i (+ i 1))
                         );
                         (close ff)
                 )
             );if
           );progn
       );if
       (princ)
)


(defun toldim_ok(/ i pwid pwid_err)
       (cond
              ((and (= use "1")(null index))(set_tile "error" "未選取公差值 !")
              )
              (t
                      (if (= use "1")(setq up (nth (atoi index) uplist) down (nth (atoi index) downlist)))
                      (done_dialog)
              );t
       )
)




(defun exe_use_toldim()
       (if (= use "0")
                   (mode_tile "add" 0)
                   (progn
                          (mode_tile "add" 1)
                          (mode_tile "edit" 1)
                          (mode_tile "del" 1)
                   )
       );if
       (if (and index (= use "0"))
                   (progn
                          (mode_tile "edit" 0)
                          (mode_tile "del" 0)
                   )
       );if
)


(defun exe_note_up_down(id)
       (if (= use "0")
           (progn
                (mode_tile "edit" 0)
                (mode_tile "del" 0)
           );progn
       );if
)



;;;===========新增;編輯============
(defun modify_item_toldim(title / bom wid pbom)
       (if index
               (progn
                   (setq note (nth (atoi index) notelist))
                   (setq up   (nth (atoi index) uplist))
                   (setq down (nth (atoi index) downlist))
               )
       );if
       (actdcl (strcat POWDESIGN_dcl_path "auxdim") "modify")

       (set_tile "title" title)
       (if index
               (progn
                   (set_tile "note" note)
                   (set_tile "up" up)
                   (set_tile "down" down)
               )
       );if

       (action_tile "accept" "(modify_item_toldim_ok title)")
       (action_tile "cancel" "(done_dialog)")
       (start_dialog)


)

(defun modify_item_toldim_ok(typ / note up down i up_err down_err)
       (setq note (get_tile "note"))
       (setq up   (get_tile "up"))
       (setq down (get_tile "down"))
       (setq i 1 up_err nil)
       (repeat (strlen up)
               (if (and (or (< (ascii (substr up i 1)) 48) (> (ascii (substr up i 1)) 57)) (/= (ascii (substr up i 1)) 43)(/= (ascii (substr up i 1)) 45)(/= (ascii (substr up i 1)) 46))
                   (setq up_err T)
               );if
               (if (and (> i 2) (or (= (ascii (substr up i 1)) 45)(= (ascii (substr up i 1)) 43)))
                   (setq up_err T)
               );if
               (setq i (+ i 1))
       );repeat
       (if (or (= (ascii (substr up 1 1)) 46) (and (= (ascii (substr up 2 1)) 46) (or (= (ascii (substr up 1 1)) 43)(= (ascii (substr up 1 1)) 45))))
           (setq up_err T)
       );if
       (setq i 1 down_err nil)
       (repeat (strlen down)
               (if (and (or (< (ascii (substr down i 1)) 48) (> (ascii (substr down i 1)) 57)) (/= (ascii (substr down i 1)) 43)(/= (ascii (substr down i 1)) 45)(/= (ascii (substr down i 1)) 46))
                   (setq down_err T)
               );if
               (if (and (> i 2) (or (= (ascii (substr down i 1)) 45)(= (ascii (substr down i 1)) 43)))
                   (setq down_err T)
               );if
               (setq i (+ i 1))
       );repeat
       (if (or (= (ascii (substr down 1 1)) 46) (and (= (ascii (substr down 2 1)) 46) (or (= (ascii (substr down 1 1)) 43)(= (ascii (substr down 1 1)) 45))))
           (setq down_err T)
       );if
       (cond
             ((= note "")(set_tile "error" "說明未輸入 !"))
             ((and (member note notelist)(= typ "新增"))(set_tile "error" "說明已存在 !"))
             ((and (member note notelist)(= typ "編輯")(/= index (get_sublist_num notelist note)))(set_tile "error" "說明已存在 !"))
             ((= up "")(set_tile "error" "上公差未輸入 !"))
             (up_err   (set_tile "error" "上公差輸入錯誤 !"))
             ((= down "")(set_tile "error" "下公差未輸入 !"))
             (down_err (set_tile "error" "下公差寬輸入錯誤 !"))
             (t
                 (cond
                     ((= typ "新增")
                            (setq notelist(reverse(cons note(reverse notelist))))
                            (setq uplist(reverse(cons up (reverse uplist))))
                            (setq downlist(reverse(cons down (reverse downlist))))
                            (setq index (itoa (- (length notelist) 1)))
                     )
                     ((= typ "編輯")
                            (setq notelist (replace_list_toldim notelist note))
                            (setq uplist (replace_list_toldim uplist up))
                            (setq downlist (replace_list_toldim downlist down))
                     )
                 );cond
                 (done_dialog)
                 (if (= typ "新增") (progn(mode_tile "edit" 0)(mode_tile "del" 0)))
                 (act_pop_list notelist "note")
                 (act_pop_list uplist "up")
                 (act_pop_list downlist "down")
                 (set_tile "note" index)
                 (set_tile "up" index)
                 (set_tile "down" index)

             )
       );cond
)

(defun replace_list_toldim(listname val / i)
       (setq new_list '() i 0)
       (foreach XX listname
                (if (= index (itoa i))
                    (setq new_list (cons val new_list))
                    (setq new_list (cons XX new_list))
                );if
                (setq i (+ i 1))
       )
       (reverse new_list)
);defun
;;;===========刪除============
(defun del_item_toldim()
       (setq notelist (del_list_toldim notelist))
       (setq uplist (del_list_toldim uplist))
       (setq downlist (del_list_toldim downlist))
       (if (= "0" index)
           (setq index "0")
           (setq index(itoa (- (atoi index) 1)))
       );if
       (if (null notelist)
               (progn
                     (setq index nil)
                     (mode_tile "edit" 1) (mode_tile "del" 1)
               );

       );if
       (act_pop_list notelist "note")
       (act_pop_list uplist "up")
       (act_pop_list downlist "down")
       (if (/= nil index)
           (progn
                (set_tile "note" index)
                (set_tile "up" index)
                (set_tile "down" index)
           );progn
       );if
)
(defun del_list_toldim(listname / i)
       (setq new_list '() i 0)
       (foreach XX listname
                (if (/= index (itoa i))
                    (setq new_list (cons XX new_list))
                );if
                (setq i (+ i 1))
       )
       (reverse new_list)
);defun

(defun usertol(utol dtol / ort p1 dimsca tolp tolm texth 2tolp 2tolm 3tolp 3tolm tolang dtol)
  (setq re-att (getvar "attdia"))
  (setvar "cmdecho" 0)(setvar "attdia" 0)
  (setq ort (getvar "orthomode"))
  (setq p1 (getpoint "\n選擇插入點: "))
  (setq dimsca (getvar "dimscale"))
  (setq tolp utol
        tolm dtol
        texth (* dimsca 0.8)
        3tolp (substr tolp 1 1)
        3tolm (substr tolm 1 1))
  (if (= 3tolp "0")
    (progn
      (if (> (strlen tolp) 1)
        (setq tolp (strcat "+" tolp))
        (setq tolp (strcat " " tolp))
      );if
    );progn
  );if
  (if (= 3tolm "0")
    (progn
      (if (> (strlen tolm) 1)
        (setq tolm (strcat "+" tolm))
        (setq tolm (strcat " " tolm))
      );if
    );progn
  );if

  (setq 2tolp (substr tolp 2)
        2tolm (substr tolm 2))
  (setq tolang (getangle p1 "\n旋轉角度 <0>: "))
   (if (or (= tolang 0) (= tolang nil)) (setq tolang 0))
  (setq  tolang (/ (* tolang 180) pi))
  (if (= 2tolp 2tolm) (command "insert" (strcat POWDESIGN_dwg_path "si-tol") p1 texth texth tolang (strcat "%%p" 2tolp))
     (command "insert" (strcat POWDESIGN_dwg_path "dou-tol") p1 texth texth tolang tolm tolp))
     (setq dtol (entlast))
     (setvar "orthomode" 0)
     (princ "\n選擇放置點: ")
     (command "move" dtol "" p1 pause)
  (setvar "orthomode" ort)
  (setvar "attdia" re-att)(setvar "cmdecho" 1)
   (princ)
)


