;;;
;保留一邊導角
;保留一邊圓角
;變換線性
;拷貝,旋轉換線性
;拷貝,旋轉換圖層
;拷貝並縮放比例
;;OFFSET 變換線型
;;OFFSET 變換圖層
;;截斷軸 bshaft
;;鈑金件蕉形孔 c-slot
;;功能說明: Power Offset 變換線型
;;扣環槽(孔用) 2003.06.12 SAM
;;扣環槽(軸用) 2003.06.12 SAM
;;=============================================================================================
;;鈑金件蕉形孔
;(defun c:c-slot(/ p1 p2 p3 p4 p5 p6 p7 p12 p13 cr r ang s-ang oldosmode)
(defun c:c-slot()
  (setvar "cmdecho" 0)
   (progn(setq ppss sspp)

    (defun *error* (msg)
     (princ msg)
     (redraw)
     (princ)
    )

  (setq p1 (getpoint "\n選擇中心點: "))
  (while (null p1)
    (princ "未選擇中心點!!")
    (setq p1 (getpoint "\n選擇中心點: "))
  )
  (command "vslide" (strcat POWDESIGN_sld_path "c-slot"))
  (setq CR (getdist "\n輸入R1值: "))
  (while (null cr)
    (princ "R1 值未輸入!!")
    (setq CR (getdist "\n輸入R1值: "))
  )
  (setq R (getdist "\n輸入R2值: "))
  (while (null r)
    (princ "R2 值未輸入!!")
    (setq R (getdist "\n輸入R2值: "))
  )
  (while (and (/= nil r) (>= r cr))
     (princ "\nR2 值不可大於或等於 R1 值 !! 請再輸入一次 !!")
     (setq R (getdist "\n輸入R2值: "))
  );while
  (setq ang (getangle "\n輸入弧型角度: "))
  (while (null ang)
    (princ "弧型角度 值未輸入!!")
    (setq ang (getangle "\n輸入弧型角度: "))
  )
  (setq s-ang (getangle "\n輸入起始角度: "))
  (while (null s-ang)
    (princ "起始角度 值未輸入!!")
    (setq s-ang (getangle "\n輸入起始角度: "))
  )
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
  (setq p2 (polar p1 s-ang CR)
        p3 (polar p1 (+ ang s-ang) CR)
        p4 (polar p1 s-ang (- CR r))
        p5 (polar p1 s-ang (+ CR R))
        p6 (polar p1 (+ ang s-ang) (- CR R))
        p7 (polar p1 (+ ang s-ang) (+ CR R))
        p12 (polar p1 (+ ang s-ang) (+ cr r 3))
        p13 (polar p1 s-ang (+ cr r 3))
     ;  cang (/ (+ cr (* 4 (getvar "dimscale"))) (* 0.01745 r))
        cang (dtr (/ (* 57.296 (+ r (* 4 (getvar "dimscale")))) cr))
        cp1 (polar p1 (- s-ang cang) cr)
        cp2 (polar p1 (+ ang s-ang cang) cr)
  )
  (redraw)
  (c:&sl&)
  (command "arc" "c" p2 p4 p5)
  (command "arc" "c" p1 p5 p7)
  (command "arc" "c" p3 p7 p6)
  (command "arc" "c" p1 p4 p6)
  (c:&cl&)
  (command "line" p12 p1 "")
  (command "line" p13 p1 "")
; (command "arc" "c" p1 cp1 cp2)
  (c:&sl&)
  (setvar "osmode" oldosmode))
  (setvar "cmdecho" 1)
  (princ)
)

;;截斷軸
(defun c:bshaft(/ oldcolor os oldltype oldbli e1 e2 r p1 p2 p3 p4 p5 p6 en1
                  en2 oldosmode ang ent1 ent1data 10data 11data)
;(defun c:bshaft()
   (progn(setq ppss sspp)
   (setq olderr *error*)

   (defun *error* (msg)
      (princ msg)
      (setvar "osmode" os)
      (setq *error* olderr)
      (prin1)
   )
  (setvar "cmdecho" 0)
  (setq oldcolor (getvar "cecolor")
        os (getvar "osmode")
        oldltype (getvar "celtype"))
  (setvar "osmode" 512)
  (setq e1 (getpoint "\n選擇軸之上斷線點(左或上方): "))
  (if (null (ssget e1)) (princ "\n您沒有選到上斷線! ")
   (progn
      (setq ent1data (entget (ssname (ssget e1) 0)))
      (setq 10data (cdr (assoc 10 ent1data))
            11data (cdr (assoc 11 ent1data))
            ang (angle 10data 11data))
      (if (= (* pi 1.5) ang) (setq ang (* pi 0.5)))
      (if (= pi ang) (setq ang 0))
      (setvar "osmode" 128)
      (setq e2 (getpoint e1 "\n選擇軸之下斷線點(右或下方): "))
      (if (null (ssget e2)) (princ "\n您沒有選到下斷線! ")
        (progn
             (setq ent2data (entget (ssname (ssget e2) 0)))
             (if (= (cdr(assoc 5 ent1data)) (cdr(assoc 5 ent2data)))
                 (princ "\n您選擇的為同一線: ")
                 (progn
                      (setq ang2 (angle e1 e2))
                      (setq   r  (/ (distance e1 e2) 2.)
                              p3 (polar e1 ang (* 0.25 r))
                              p1 (polar e1 (+ ang pi) (* 0.25 r))
                              p2 (polar p1 ang2 (* r 2))
                              p5 (polar p1 ang2 r)
                              p4 (polar p3 ang2 (* r 2))
                              p6 (polar p3 ang2 r))
                      (setvar "osmode" 0)
                      (command "break" p1 p3)
                      (command "break" p2 p4)
                      (command "arc" p1 "e" p5 "r" r)
                      (setq en1 (entlast))
                      (command "arc" p2 "e" p5 "r" r)
                      (command "arc" p5 "e" p1 "r" r)
                      (setq en4 (entlast))
                      (command "arc" p3 "e" p6 "r" r)
                      (command "arc" p4 "e" p6 "r" r)
                      (setq en2 (entlast))
                      (command "arc" p6 "e" p4 "r" r)
                      (setq en6 (entlast))
                 );progn
             );if
        );progn
      );if
    );progn
  );if
; (c:&hl&)
; (command "hatch" "u" "45" "3" "n"  en1 en4 en2 en6 "")
; (command "linetype" "s" oldltype "")
  (if (= oldcolor "BYLAYER") (command "color" oldcolor) (command "color" (atoi oldcolor)))
  (setvar "cmdecho" 1)
  (setvar "osmode" os)
  (setq *error* olderr))(princ)
)

;;OFFSET 變換線型
;╭════════════════════════════════════════════╮
;║設計日期: 1998.03.10                                                                    ║
;║更新日期: 2002.1.16                                                                     ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 改良型 OFFSET                                                                 ║
;║執行方式:                                                                               ║
;║相關檔案:                                                                               ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:aoff(/ aoff_fg)
   (progn(setq ppss sspp)
 (setvar "cmdecho" 0)

 (actdcl (strcat POWDESIGN_dcl_path "auxdraw") "aoff")

 (setq ltype_list (list "粗連續線" "細連續線" "虛線" "標準中心線" "短中心線" "假想線"))
 (act_pop_list ltype_list "ltype")

 (set_tile "ltype" "2")
 (action_tile "accept" "(aoff_ok)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (unload_dialog dcl_id)
 (if aoff_fg (draw_aoff))

 (setvar "cmdecho" 1))
 (prin1)
)

(defun draw_aoff(/ offent ent1 data0 offent10 p1 entnum set_ent)
  (setq set_ent (ssget))
   ;(while (null offent)
   ;       (setq offent (entsel "\n選擇要偏移複製的物件:"))
   ;)
;   (if (/= offent nil)
;     (progn
;       (setq ent1 (entget (car offent)))
;       (setq data0 (cdr (assoc 0 ent1)))
;       (if (and (/= data0 "POLYLINE") (/= data0 "LWPOLYLINE"))
;           (command "pedit" (car offent) "Y" "J" offent "" "")
;           (command "pedit" (car offent) "J" offent "" "")
;       )
;       (setq offent10 (cdr (assoc 10 (entget (entlast)))))
;       (setq offent (list (entlast) offent10))
;     );progn
;   );if
  (if (= ofdist "")
      (setq p1 (getpoint "\n通過點: "))
      (setq p1 (getpoint "\n在哪一側做偏移複製: "))
  );if
  (setq int_i 0)
  (repeat (sslength set_ent)
    (setq offent (ssname set_ent int_i))
    (if (= ofdist "")
        (command "offset" "t" offent p1 "")
        (command "offset" (atof ofdist) offent p1 "")
    );if
    (cond
    	((= oftype "0") (command "change" "l" "" "p" "c" sys_CONT_ltypecol "lt" sys_CONT_ltype ""))
    	((= oftype "1") (command "change" "L" "" "p" "c" sys_CONT1_ltypecol "lt" sys_CONT1_ltype ""))
    	((= oftype "2") (command "change" "l" "" "p" "c" sys_dashed_ltypecol "lt" sys_dashed_ltype ""))
    	((= oftype "3") (command "change" "l" "" "p" "c" sys_center_ltypecol "lt" sys_center_ltype ""))
    	((= oftype "4") (command "change" "l" "" "p" "c" sys_stcenter_ltypecol "lt" sys_stcenter_ltype ""))
    	((= oftype "5") (command "change" "l" "" "p" "c" sys_phantom_ltypecol "lt" sys_phantom_ltype ""))
    )
    (if (and entnum (/= (sslength entnum) 1))
        (progn
            (command "explode" (entlast))
            (command "explode" offent)
        );progn
    );if
    (setq entnum nil)
    (setq int_i (1+ int_i))
  )
  (princ)
)


(defun aoff_ok()
   (setq ofdist (get_tile "dist")
         oftype (get_tile "ltype"))
   (if (and (/= "" ofdist) (= (atof ofdist) 0)) (set_tile "error" "偏移距離輸入錯誤!!")
     (progn
      (setq aoff_fg T)(done_dialog)
     )
   );if
)


;;OFFSET 變換圖層
(defun c:offl(/ ent bl name8 color62 d p1 last8 last62 last)
   (setvar "cmdecho" 0)
   (progn(setq ppss sspp)
   (setq BL (entsel "\n選擇新層圖素: "))
   (setq BL (entget (car BL)) name8 (assoc 8 BL) color62 (assoc 62 BL))
   (setq ent (entsel "\n選擇平移圖素: "))
   (setq d (getdist "\n輸入平移距離: ")
         p1 (getpoint "\n選擇平移方向: ")
   )
   (command "offset" d ent p1 "")
   (setq last8 (assoc 8 (entget (entlast)))
         last62 (assoc 62 (entget (entlast)))
         last (entget (entlast))
         last (subst name8 last8 last)
         last (subst color62 last62 last)
   )
   (entmod last)
   (setvar "cmdecho" 1))
   (princ)
)


;;;
(defun c:c&r&la(/ sel bpnt laname ta ty type)
 (setvar "cmdecho" 0)
   (progn(setq ppss sspp)
 (setq sel (ssget))
 (setq bpnt (getpoint "\n選擇拷貝基準點: "))
 (if sel
  (progn
   (if (= acad_ver "GENIUS")
       (command ".copy" "p" "" bpnt bpnt)
       (command "copy" "p" "" bpnt bpnt)
   )
   (prompt "\n拷貝到哪 ? ")
   (command "move" "p" "" bpnt pause)
   (redraw)
   (prompt "\n旋轉角度: ")
   (command "rotate" "p" "" (getvar "lastpoint") pause)
   (setq laname (getstring "\n或按 Enter 鍵選擇新層/<輸入欲改變新層名稱>: "))
   (if (/= laname nil) (command "change" "p" "" "p" "la" laname ""))
   (if (= laname "")
   (progn (setq ta (entsel))
          (setq ty (entget (car ta)))
          (setq type (cdr (assoc 8 ty)))
          (command "change" "p" "" "p" "la" type "")))
  )
 )
 (setvar "cmdecho" 1))
 (princ)
)
;;;
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 拷貝,旋轉換線性                                                               ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:c&r&lt(/ sel bpnt ta tt ty type)
   (if (or (= jin "#$%")(= #### 85))(setq FFF t))(progn(setq ppss sspp)
 (setvar "cmdecho" 0)
 (setq sel (ssget))
 (setq bpnt (getpoint "\n選擇拷貝基準點: "))
 (if sel
  (progn
   (prompt "\n旋轉角度: ")
   (if (= acad_ver "GENIUS")
       (command ".copy" "p" "" bpnt bpnt)
       (command "copy" "p" "" bpnt bpnt)
   )
   (prompt "\n拷貝到哪 ? ")
   (command "move" "p" "" bpnt pause)
   (redraw)
   (prompt "\n旋轉角度: ")
   (command "rotate" "p" "" (getvar "lastpoint") pause)
   (setq ta (getstring "\n或按 Enter 鍵選擇線型/<輸入欲改變線型名稱>: "))
   (if (/= ta nil) (command "change" "p" "" "p" "lt" ta ""))
   (if (= ta "")
   (progn (setq tt (entsel))
          (setq ty (entget (car tt)))
          (setq ttype (cdr (assoc 6 ty)))
          (command "change" "p" "" "p" "lt" ttype ""))))
 )
 (setvar "cmdecho" 1))
 (princ)
)
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 拷貝並縮放比例                                                                ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:c&s (/ sel bpnt)
 (setvar "cmdecho" 0)
   (progn(setq ppss sspp)
 (setq sel (ssget))
 (setq bpnt (getpoint "\n選擇拷貝基準點: "))
 (if sel
  (progn
   (if (= acad_ver "GENIUS")
       (command ".copy" "p" "" bpnt bpnt)
       (command "copy" "p" "" bpnt bpnt)
   )
   (prompt "\n搬移到哪 ? ")
   (command "move" "p" "" bpnt pause)
   (redraw)
   (prompt "\n輸入縮放比例: ")
   (command "scale" "p" "" (getvar "lastpoint") pause)
  )
 ))
 (setvar "cmdecho" 1)
 (princ)
)

;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 變換線性                                                                      ║
;║相關檔案: pub-lisp.lsp(chltype)                                                             ║
;╰════════════════════════════════════════════╯
(defun c:chtobyl() (CHLTYPE "bylayer" "bylayer"))
(defun c:chtobylk() (CHLTYPE "byblock" "byblock"))
(defun c:chtosl()   (CHLTYPE sys_CONT_ltype sys_CONT_ltypecol))
(defun c:chtocl()   (CHLTYPE sys_center_ltype sys_center_ltypecol))
(defun c:chtocl2()   (CHLTYPE sys_stcenter_ltype sys_stcenter_ltypecol))
(defun c:chtotl()   (CHLTYPE sys_CONT1_ltype sys_CONT1_ltypecol))
(defun c:chtodl()   (CHLTYPE sys_dashed_ltype sys_dashed_ltypecol))
(defun c:chtopl()   (CHLTYPE sys_phantom_ltype sys_phantom_ltypecol))
(defun c:chtohl()   (CHLTYPE sys_hatch_ltype sys_hatch_ltypecol))
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 保留一邊導角                                                                  ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
;(defun c:1cham(/ ent1 cham1 ent2 cham2 ent1-data st-ent1 end-ent1 lay-ent1
;         col-ent1 lty-ent1 ent-data st-ent2 end-ent2 lay-ent2 col-ent2
;         c-layer c-color c-linetype)
(defun c:1cham()
(progn(setq ppss sspp)
  (setvar "cmdecho" 0)

  (setq old_osmode (getvar "osmode"))
  (setvar "osmode" 0)
  (defun *error* (msg)
         (princ msg)
         (setvar "osmode" old_osmode)
  )

  (setq ent1 (entsel "\n選取基準線: "))
  (setq cham1 (getdist (strcat "\n輸入第一個倒角長度 <"(rtos (getvar
                                         "chamfera") 2)">: ")))
  (if (= cham1 nil) (setq cham1 (getvar "chamfera")))
  (setq ent2 (entsel "\n請選擇另一條線: "))
  (setq cham2 (getdist (strcat "\n輸入第二個倒角長度 <"(rtos (getvar
                                         "chamferb") 2)">: ")))
  (if (= cham1 nil) (setq cham1 (getvar "chamferb")))

; get data
  (setq ent1-data (entget (car ent1))
        st-ent1 (cdr (assoc 10 ent1-data))
        end-ent1 (cdr (assoc 11 ent1-data))
        lay-ent1 (cdr (assoc 8 ent1-data))
        col-ent1 (cdr (assoc 62 ent1-data))
        lty-ent1 (cdr (assoc 6 ent1-data)))
  (if (= lty-ent1 nil) (setq lty-ent1 "BYLAYER"))
  (if (= col-ent1 nil) (setq col-ent1 "BYLAYER"))
  (setq ent2-data (entget (car ent2))
        st-ent2 (cdr (assoc 10 ent2-data))
        end-ent2 (cdr (assoc 11 ent2-data))
        end-ent2 (cdr (assoc 11 ent2-data))
        lay-ent2 (cdr (assoc 8 ent2-data))
        col-ent2 (cdr (assoc 62 ent2-data))
        lty-ent2 (cdr (assoc 6 ent2-data)))
  (if (= lty-ent2 nil) (setq lty-ent2 "BYLAYER"))
  (if (= col-ent2 nil) (setq col-ent2 "BYLAYER"))
  (if (= col-ent2 0) (setq col-ent2 "BYBLOCK"))
 (if (= col-ent1 0) (setq col-ent1 "BYBLOCK"))
;remember current LAYER, LINETYPE, COLOR
  (setq c-layer (getvar "clayer")
        c-color (getvar "cecolor")
        c-linetype (getvar "celtype"))

;change LAYER, LINETYPE, COLOR and CHAMFER
  (command "color" col-ent2)
  (command "linetype" "s" lty-ent2 "")
  (command "layer" "s" lay-ent2 "")
  (command "chamfer" "d" cham1 cham2)
  (command "chamfer" ent1 ent2)

;change ENT1
  (command "color" col-ent1)
  (command "linetype" "s" lty-ent1 "")
  (command "layer" "s" lay-ent1 "")
  (entdel (car ent1))
  (command "line" st-ent1 end-ent1 "")

;return LAYER, LINETYPE, COLOR
  (command "color" c-color)
  (command "linetype" "s" c-linetype "")
  (command "layer" "s" c-layer "")
  (setvar "osmode" old_osmode))
  (setvar "cmdecho" 1)(princ)
)
;;=============================================================================================
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明:  保留一邊圓角                                                                 ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:1fill(/ col typ aye fiivr frea1 sfes1 sfes11 sfes2 sfcar srss6 srss8 srss62)
   (setvar "cmdecho" 1)
   (progn(setq ppss sspp)
   (setq col (getvar "cecolor") typ (getvar "celtype") aye (getvar "clayer"))
   (setq fiivr (getvar "filletrad"))
   (setq old_osmode (getvar "osmode"))
   (setvar "osmode" 0)
   (defun *error* (msg)
          (princ msg)
          (setvar "osmode" old_osmode)
   )
   (setq frea1 (getreal (strcat "\n圓角半徑<"(rtos fiivr 2 4)">: ")))
   (if (= frea1 nil)
     (setq frea1 fiivr)
   );if
   (setq sfes1 (entsel "\n選不圓角線: "))
   (while (/= sfes1 nil)
     (setq sfes11 (entget (car sfes1)))
     (setq sfes2 (entsel "\n選圓角線: ")
           sfcar (entget (car sfes2))
           srss6 (cdr (assoc 6 sfcar))
           srss8 (cdr (assoc 8 sfcar))
           srss62 (cdr (assoc 62 sfcar)))
     (command "layer" "s" srss8 "")
     (if (= srss6 nil) (setq srss6 "BYLAYER"))

     (command "linetype" "s" srss6 "")
     (if (= srss62 nil) (setq srss62 "BYLAYER"))
     (if (= srss62 0) (setq srss62 "BYBLOCK"))

     (command "color" srss62)

     (command "fillet" "r" frea1)
     (command "fillet" sfes1 sfes2)
     (entmod sfes11)
     (command "layer" "s" aye "")
     (command "linetype" "s" typ "")

   (cond
     ((= col "BYBLOCK") (command "color" "BYBLOCK"))
     ((= col "BYLAYER") (command "color" "BYLAYER"))
     (T (command "color" (atoi col)))
   )

     (princ "\n請繼續使用...")
     (setq sfes1 (entsel "\n選不圓角線: "))
   );while
   (setvar "cmdecho" 1)
   (setvar "osmode" old_osmode))
   (princ)
)

;;========================================================================================================================
;;功能說明: Power Offset 變換線型
(defun aoff_to_which_ltype(newltype newcolor / offent ent1 data0 offent10 p1 entnum)
;   (progn(setq ppss sspp)
   (setvar "cmdecho" 1)
   (cond
     ((or (= "T" ofdist)(null ofdist))
       (initget "T")
       (setq ofdist (getdist "\n指定 Offset 距離[通過(T)]<通過>:"))
       (if (null ofdist) (setq ofdist "T"))
     )
     (T
       (if (/= (type ofdist) (type "abc")) (setq olddist ofdist) (setq olddist 1 ofdist 1))
       (initget "T")
       (setq ofdist (getdist (strcat "\n指定 Offset 距離[通過(T)]<" (rtos ofdist 2 4) ">:")))
       (if (null ofdist) (setq ofdist olddist))
     );
   );
   (setq offent (entsel "\n選擇要偏移複製的物件或 <結束>:"))
   (while (/= offent nil)
         (if (= ofdist "T")
           (progn
             (setq p1 (getpoint "\n通過點: "))
             (command "offset" "t" (car offent) p1 "")
           )
           (progn
             (setq p1 (getpoint "\n指定要在那一側偏移複製: "))
             (command "offset" ofdist (car offent) p1 "")
           )
         );if
         (command "change" "l" "" "p" "c" newcolor "lt" newltype "")
         (if (and entnum (/= (sslength entnum) 1))
           (progn
                 (command "explode" (entlast))
                 (command "explode" offent)
           );progn
         );if
         (setq entnum nil)
         (setq offent (entsel "\n選擇要偏移複製的物件或 <結束>:"))
   );if
   (setvar "cmdecho" 1)
;  (SETQ FFF nil))
   (princ)
)

(defun ch_to_objlayer(objlayer)
   (princ (strcat "\n選擇要變換到 " objlayer " 層的圖形: "))
   (setq selent (ssget))
   (while (/= nil selent)
     (setq oldlayer (getvar "clayer"))
     (if (and (= objlayer sys_dim_layer)(null (tblsearch "layer" objlayer))) (C:&D&))
     (if (and (= objlayer sys_text_layer)(null (tblsearch "layer" objlayer))) (C:&t&))
     (command "change" "p" "" "p" "la" objlayer "")
     (setvar "clayer" oldlayer)
     (princ (strcat "\n選擇要變換到 " objlayer " 層的圖形: "))
     (setq selent (ssget))
   )
   (princ (strcat "\n所選擇的圖形已經變換到 " objlayer " 層!" ))
   (princ)
)

;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 扣環槽(孔用)                                         │
;;;│  主程式 : hkring1.lsp                                          │
;;;│  日  期 : 2003.06.12                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 : hkring.dcl                                           │
;;;│  方  法 : c:hkring1                                            │
;;;│  相關檔案: pub-lisp.lsp hkring01.sld hkring02.sld              │
;;;└────────────────────────────────┘
;;;
(defun c:hkring1( / flt_dist i int_flag int_index int_inter1 int_inter2)
  	(setvar "cmdecho" 0)
  	(setq osmode  (getvar "osmode"))
  	(setq clayer  (getvar "clayer"))
  	(setq cecolor (getvar "cecolor"))
  	(setq celtype (getvar "celtype"))

	(defun *error*(msg)
  		(setvar "osmode" osmode)
  		(setvar "clayer" clayer)
  		(setvar "cecolor" cecolor)
  		(setvar "celtype" celtype)
  		(setvar "cmdecho" 1)
  		(princ)
	)	
	;(setq powdesign_path      "c:\\hkring\\")
	;(setq powdesign_dcl_path  "c:\\hkring\\")
	;(setq powdesign_sld_path  "c:\\hkring\\")
	;(setq powdesign_data_path "c:\\hkring\\")

	(setq gflt_D1 nil)
	(setq gflt_L1 nil)
	(setq gflt_D2 nil)
	(setq gflt_M1 nil)
  	(setq gint_image nil)
	(defun stdfile_data_hkring1(fname / fil_fs str_list lst_stdlist)
  		(setq fil_fs (open (strcat powdesign_data_path fname) "r"))
  		;(setq fil_fs (open (strcat "c:\\designer6\\database\\" fname) "r"))
  		(read-line fil_fs)
  		(setq str_list (read-line fil_fs))
  		(while str_list
	  		(setq lst_stdlist (cons (read str_list) lst_stdlist))
	  		(setq str_list (read-line fil_fs))
		)
  		(close fil_fs)
  		(setq lst_stdlist (reverse lst_stdlist))
  		lst_stdlist
	)

  	(setq flt_dist (getdist "\n孔徑: "))
  	(actdcl (strcat powdesign_dcl_path "hkring.dcl") "hkring1")
	(if (not (null flt_dist))
	    (progn (set_tile "D1" (rtos flt_dist 2 2))
	           (setq lst_stdlist (stdfile_data_hkring1 "DRINGDIM.DOC"))
	      	   
	      	   (setq i 0)
	           (repeat (- (length lst_stdlist) 1)
		     	   (setq int_inter1 (atoi (nth 0 (nth i lst_stdlist))))
		     	   (setq int_inter2 (atoi (nth 0 (nth (+ i 1) lst_stdlist))))
		     	   (if (and (>= flt_dist int_inter1)(<= flt_dist int_inter2))
		     	       (setq int_index i)
			   )
		     	   (setq i (1+ i))
		   )
	      	   (if (not (null int_index))(progn
	      	       (set_tile "C1" (nth 0 (nth int_index lst_stdlist)))
	      	       (set_tile "D2" (nth 5 (nth int_index lst_stdlist)))
	      	       (set_tile "M1" (nth 6 (nth int_index lst_stdlist)))
		   ))
	))
	
  	(show_sld "type1" (strcat powdesign_sld_path "hkring01.sld"))
  	(show_sld "type2" (strcat powdesign_sld_path "hkring02.sld"))(hkring_slide1 0)
  	(action_tile "type1" "(hkring_slide1 0)")
  	(action_tile "type2" "(hkring_slide1 1)")
  	(action_tile "accept" "(setq int_flag 1)(getval_hkring1)(errmsg_hkring1)")
  	(action_tile "cancel" "(setq int_flag 0)(done_dialog)")
  	(start_dialog)
   (unload_dialog dcl_id)

   (unload_dialog dcl_id)
  	(cond ((= 0 int_flag)
	       (princ "取消"))
	      ((= 1 int_flag)
	       (drawing_hkring1))
	)
  	(setvar "osmode" osmode)
  	(setvar "clayer" clayer)
  	(setvar "cecolor" cecolor)
  	(setvar "celtype" celtype)
  	(setvar "cmdecho" 1)
  	(princ)
)
(defun errmsg_hkring1()
	(cond ((= 0 gflt_D1)(alert "未輸入孔徑(D1)"))
	      ((= 0 gflt_L1)(alert "未輸入扣環槽距離(L1)"))
	      ((= 0 gflt_D2)(alert "未輸入(D2)"))
	      ((= 0 gflt_M1)(alert "未輸入(M1)"))
	      (t (done_dialog))
	)
)
(defun getval_hkring1()
  	(setq gflt_D1 (atof (get_tile "D1")))
  	(setq gflt_L1 (atof (get_tile "L1")))
  	(setq gflt_D2 (atof (get_tile "D2")))
  	(setq gflt_M1 (atof (get_tile "M1")))
)
(defun hkring_slide1(int_image)
   (setq gint_image int_image)
   (cond ((= 0 int_image)
          (show_sld_col "type1" (strcat powdesign_sld_path "hkring01.sld") 166)
	  (show_sld_col "type2" (strcat powdesign_sld_path "hkring02.sld") -2))
         ((= 1 int_image)
          (show_sld_col "type1" (strcat powdesign_sld_path "hkring01.sld") -2)
          (show_sld_col "type2" (strcat powdesign_sld_path "hkring02.sld") 166))
   )
)
(defun drawing_hkring1(/ pnt_p01 pnt_p02 pnt_p03 pnt_p04 pnt_p05 pnt_p06 pnt_p07 pnt_p08 pnt_p09
		         pnt_p10 pnt_p11 pnt_p12 pnt_p05i pnt_p06i ent_selpnt1 ent_selpnt2 ent_e1
		         ent_e2 lst_pntent1 lst_pntent2 flt_ang)
	(setq pnt_p01 (getpoint "\n基準點: "))
  	(setq flt_ang (getangle pnt_p01 "\n方向或角度: "))
  	(if (= nil flt_ang)(setq flt_ang 0))
  	(setvar "osmode" 0)

  	(cond ((= 0 gint_image)
  	       (setq pnt_p02 (polar pnt_p01 (+ flt_ang (* pi 0.0)) gflt_L1)))
	      ((= 1 gint_image)
	       (setq pnt_p02 (polar pnt_p01 (+ flt_ang (* pi 0.0)) (+ gflt_L1 gflt_M1))))
	)
  	(setq pnt_p03 (polar pnt_p02 (+ flt_ang (* pi 0.5)) (/ gflt_D2 2)))
  	(setq pnt_p04 (polar pnt_p02 (+ flt_ang (* pi 1.5)) (/ gflt_D2 2)))
  	(setq pnt_p05 (polar pnt_p03 (+ flt_ang (* pi 1.0)) gflt_M1))
  	(setq pnt_p06 (polar pnt_p04 (+ flt_ang (* pi 1.0)) gflt_M1))

  	(setq pnt_p05i (polar pnt_p03 (+ flt_ang (* pi 1.0)) (/ gflt_M1 2)))
  	(setq pnt_p06i (polar pnt_p04 (+ flt_ang (* pi 1.0)) (/ gflt_M1 2)))
  	(setq pnt_p07 (polar pnt_p02 (+ flt_ang (* pi 0.5)) (/ gflt_D1 2)))
  	(setq pnt_p08 (polar pnt_p07 (+ flt_ang (* pi 1.0)) gflt_M1))
  	(setq pnt_p09 (inters pnt_p07 pnt_p08 pnt_p05i pnt_p06i nil))
  	
  	(setq pnt_p10 (polar pnt_p02 (+ flt_ang (* pi 1.5)) (/ gflt_D1 2)))
  	(setq pnt_p11 (polar pnt_p10 (+ flt_ang (* pi 1.0)) gflt_M1))
  	(setq pnt_p12 (inters pnt_p10 pnt_p11 pnt_p05i pnt_p06i nil))
	(setq ent_selpnt1 (ssget pnt_p09))  	
	(setq ent_selpnt2 (ssget pnt_p12))
  	(command "LINE" pnt_p03 pnt_p04 "")(setq ent_e1 (entlast))
  	(command "LINE" pnt_p05 pnt_p06 "")(setq ent_e2 (entlast))
  	(command "LINE" pnt_p03 pnt_p05 "")
  	(command "LINE" pnt_p04 pnt_p06 "")
  	(if ent_selpnt1 (progn
		(setq lst_pntent (list (ssname ent_selpnt1 0) pnt_p09))
		(command "TRIM" ent_e1 ent_e2 "" lst_pntent ""))
	)
	(if ent_selpnt2 (progn
		(setq lst_pntent (list (ssname ent_selpnt2 0) pnt_p12))
		(command "TRIM" ent_e1 ent_e2 "" lst_pntent ""))
	)
  	
)
;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 扣環槽(軸用)                                         │
;;;│  主程式 : hkring2.lsp                                          │
;;;│  日  期 : 2003.06.12                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 : hkring.dcl                                           │
;;;│  方  法 : c:hkring2                                            │
;;;│  相關檔案: pub-lisp.lsp hkring03.sld hkring04.sld              │
;;;└────────────────────────────────┘
;;;
(defun c:hkring2( / i int_flag)
  	(setvar "cmdecho" 0)
  	(setq osmode  (getvar "osmode"))
  	(setq clayer  (getvar "clayer"))
  	(setq cecolor (getvar "cecolor"))
  	(setq celtype (getvar "celtype"))
	
	(defun *error*(msg)
  		(setvar "osmode" osmode)
  		(setvar "clayer" clayer)
  		(setvar "cecolor" cecolor)
  		(setvar "celtype" celtype)
  		(setvar "cmdecho" 1)
  		(princ)
	)
	;(setq powdesign_path      "c:\\hkring\\")
	;(setq powdesign_dcl_path  "c:\\hkring\\")
	;(setq powdesign_sld_path  "c:\\hkring\\")
	;(setq powdesign_data_path "c:\\hkring\\")

	(setq gflt_dist nil)
	(setq gflt_D1 nil)
	(setq gflt_L1 nil)
	(setq gflt_D2 nil)
	(setq gflt_M1 nil)
  	(setq gint_image nil)
  	(defun stdfile_data_hkring2(fname / fil_fs str_list lst_stdlist)
  		(setq fil_fs (open (strcat powdesign_data_path fname) "r"))
  		;(setq fil_fs (open (strcat "c:\\designer6\\database\\" fname) "r"))
  		(read-line fil_fs)
  		(setq str_list (read-line fil_fs))
  		(while str_list
	  		(setq lst_stdlist (cons (read str_list) lst_stdlist))
	  		(setq str_list (read-line fil_fs))
		)
  		(close fil_fs)
  		(setq lst_stdlist (reverse lst_stdlist))
  		lst_stdlist
	)
	(defun style_hkring2(int_style / lst_stdlist int_inter1 int_inter2 int_index)
		(if (not (null gflt_dist))
	    	    (progn (set_tile "D1" (rtos gflt_dist 2 2))
	      	  	   (cond ((= 0 int_style)
	           	 	  (setq lst_stdlist (stdfile_data_hkring2 "CRINGDIM.DOC")))
			 	 ((= 1 int_style)
			  	  (setq lst_stdlist (stdfile_data_hkring2 "ERINGDIM.DOC")))
			 	 ((= 2 int_style)
			  	  (setq lst_stdlist (stdfile_data_hkring2 "SRINGDIM.DOC")))
	      	   	   )
	      	   	   (setq i 0)
	           	   (repeat (- (length lst_stdlist) 1)
		     	   	   (setq int_inter1 (atoi (nth 0 (nth i lst_stdlist))))
		     	   	   (setq int_inter2 (atoi (nth 0 (nth (+ i 1) lst_stdlist))))
		     	   	   (if (and (>= gflt_dist int_inter1)(<= gflt_dist int_inter2))
		     	       	       (setq int_index i)
			   	   )
		     	   	   (setq i (1+ i))
		   	   )
	      	   	   (if (not (null int_index))(progn
	      	       	           (set_tile "C1" (nth 0 (nth int_index lst_stdlist)))
	      	       		   (set_tile "D2" (nth 5 (nth int_index lst_stdlist)))
	      	       		   (set_tile "M1" (nth 6 (nth int_index lst_stdlist)))
		   	   ))
		   ))
	)
  	(setq gflt_dist (getdist "\n軸徑: "))
  	(actdcl (strcat powdesign_dcl_path "hkring.dcl") "hkring2")
	(style_hkring2 0)
	
  	(show_sld "type1" (strcat powdesign_sld_path "hkring03.sld"))
  	(show_sld "type2" (strcat powdesign_sld_path "hkring04.sld"))(hkring_slide2 0)
  	(action_tile "type1" "(hkring_slide2 0)")
  	(action_tile "type2" "(hkring_slide2 1)")
  	(action_tile "CC"  "(style_hkring2 0)")
  	(action_tile "EC"  "(style_hkring2 1)")
  	(action_tile "CS"  "(style_hkring2 2)")
  	(action_tile "accept" "(setq int_flag 1)(getval_hkring2)(errmsg_hkring2)")
  	(action_tile "cancel" "(setq int_flag 0)(done_dialog)")
  	(start_dialog)
   (unload_dialog dcl_id)

   (unload_dialog dcl_id)
  	(cond ((= 0 int_flag)
	       (princ "取消"))
	      ((= 1 int_flag)
	       (drawing_hkring2))
	)
  	(setvar "osmode" osmode)
  	(setvar "clayer" clayer)
  	(setvar "cecolor" cecolor)
  	(setvar "celtype" celtype)
  	(setvar "cmdecho" 1)
  	(princ)
)
(defun errmsg_hkring2()
	(cond ((= 0 gflt_D1)(alert "未輸入軸徑(D1)"))
	      ((= 0 gflt_L1)(alert "未輸入扣環槽距離(L1)"))
	      ((= 0 gflt_D2)(alert "未輸入(D2)"))
	      ((= 0 gflt_M1)(alert "未輸入(M1)"))
	      (t (done_dialog))
	)
)
(defun getval_hkring2()
  	(setq gflt_D1 (atof (get_tile "D1")))
  	(setq gflt_L1 (atof (get_tile "L1")))
  	(setq gflt_D2 (atof (get_tile "D2")))
  	(setq gflt_M1 (atof (get_tile "M1")))
)
(defun hkring_slide2(int_image)
   (setq gint_image int_image)
   (cond ((= 0 int_image)
          (show_sld_col "type1" (strcat powdesign_sld_path "hkring03.sld") 166)
	  (show_sld_col "type2" (strcat powdesign_sld_path "hkring04.sld") -2))
         ((= 1 int_image)
          (show_sld_col "type1" (strcat powdesign_sld_path "hkring03.sld") -2)
          (show_sld_col "type2" (strcat powdesign_sld_path "hkring04.sld") 166))
   )
);defun
(defun drawing_hkring2(/ pnt_p01 pnt_p02 pnt_p03 pnt_p04 pnt_p05 pnt_p06 pnt_p07 pnt_p08 pnt_p09
		         pnt_p10 pnt_p11 pnt_p12 pnt_p13 ent_selpnt1 ent_selpnt2 ent_e1 ent_e2
		       	 lst_pntent1 lst_pntent2 flt_ang)
	(setq pnt_p01 (getpoint "\n基準點: "))
  	(setq flt_ang (getangle pnt_p01 "\n方向或角度: "))
  	(if (= nil flt_ang)(setq flt_ang 0))
  	(setvar "osmode" 0)

  	(cond ((= 0 gint_image)
	       (setq pnt_p02 (polar pnt_p01 (+ flt_ang (* pi 0.0)) (- gflt_L1 gflt_M1))))
	      ((= 1 gint_image)
	       (setq pnt_p02 (polar pnt_p01 (+ flt_ang (* pi 0.0)) gflt_L1)))
	)
  	(setq pnt_p03 (polar pnt_p02 (+ flt_ang (* pi 0.0)) gflt_M1))
  	(setq pnt_p04 (polar pnt_p02 (+ flt_ang (* pi 0.5)) (/ gflt_D2 2)))
  	(setq pnt_p05 (polar pnt_p02 (+ flt_ang (* pi 1.5)) (/ gflt_D2 2)))
  	(setq pnt_p06 (polar pnt_p03 (+ flt_ang (* pi 0.5)) (/ gflt_D2 2)))
  	(setq pnt_p07 (polar pnt_p03 (+ flt_ang (* pi 1.5)) (/ gflt_D2 2)))
  	(setq pnt_p08 (polar pnt_p02 (+ flt_ang (* pi 0.5)) (/ gflt_dist 2)))
  	(setq pnt_p09 (polar pnt_p02 (+ flt_ang (* pi 1.5)) (/ gflt_dist 2)))
  	(setq pnt_p10 (polar pnt_p03 (+ flt_ang (* pi 0.5)) (/ gflt_dist 2)))
  	(setq pnt_p11 (polar pnt_p03 (+ flt_ang (* pi 1.5)) (/ gflt_dist 2)))
	(setq pnt_p12 (polar pnt_p08 (+ flt_ang (* pi 0.0)) (/ gflt_M1 2)))
  	(setq pnt_p13 (polar pnt_p09 (+ flt_ang (* pi 0.0)) (/ gflt_M1 2)))
  	(setq ent_selpnt1 (ssget pnt_p12))
  	(setq ent_selpnt2 (ssget pnt_p13))
  	(command "LINE" pnt_p04 pnt_p06 "")
  	(command "LINE" pnt_p05 pnt_p07 "")
  	(command "LINE" pnt_p08 pnt_p09 "")(setq ent_e1 (entlast))
  	(command "LINE" pnt_p10 pnt_p11 "")(setq ent_e2 (entlast))
    	(if ent_selpnt1 (progn
	    (setq lst_pntent (list (ssname ent_selpnt1 0) pnt_p12))
	    (command "TRIM" ent_e1 ent_e2 "" lst_pntent ""))
	)
  	(if ent_selpnt2 (progn
	    (setq lst_pntent (list (ssname ent_selpnt2 0) pnt_p13))
	    (command "TRIM" ent_e1 ent_e2 "" lst_pntent ""))
	)
)
