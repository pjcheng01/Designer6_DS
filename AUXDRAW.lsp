;;;
;;鑽孔攻牙(不通孔)thrill
;;鑽孔攻牙(通孔)
;;鑽通孔 drill4
;;鑽孔 drill5
;;沉窩螺絲孔
;;推拔螺絲孔
;;鈑金截斷線
;==============================================================================
;;鑽孔 drill5
(defun c:drill5(/ p1 d h1 ang ltp p2 p3 p4 p5 p6 oldvar)
  (setvar "cmdecho" 0)
  (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype" )
          oldlos (getvar "osmode"))

    (setq olderr *error*)
    (defun *error* (msg)
      (princ msg)
      (setvar "osmode" oldos)
      (setvar "cecolor" oldcol)
      (setvar "celtype" oldlty)
    )


  (setq p1 (getpoint "\n插入點: "))
  (if p1 (progn
  (setq d (getdist P1 "\n孔徑:") )
  (while (null d)
    (princ "\n未輸入孔徑, 請再輸入一次!")
  (setq d (getdist P1 "\n孔徑:") )
  )
  (setq h1 (getdist P1 "\n深度: "))
  (while (null h1)
    (princ "\n未輸入深度, 請再輸入一次!")
  (setq h1 (getdist P1 "\n深度: "))
  )
  (setq ang (getangle p1 "\n旋轉角度<0>:") )
   (cenline_yesno)
  (if (or (= ang nil) (= ang 0)) (setq ang 0))
  (setq oldcol (getvar "cecolor")
        oldlty (getvar "celtype"))
  (initget "SL DL")
  (setq ltp (getkword "\n線型:SL 實線/ DL 虛線<SL>:"))
  (if (or (null ltp) (= "SL" ltp)) (c:&sl&) (c:&dl&))
  (setq oldos (getvar "osmode"))
  (setvar "osmode" 0)
  (setq p2 (polar p1 (+ (- (* pi 0.5)) ANG) (* d 0.5))
        p3 (polar p2 ang h1)
        p4 (polar p1 ang (+ h1 (/ (* (sqrt 3) d) 6.00)))
        p6 (polar p1 (+ (* pi 0.5) ang) (* d 0.5))
        p5 (polar p3 (+ (* pi 0.5) ang) d))
    (setq ZZ nil)
  (setq ZZ (ssadd))
  (command "pline" p2 "w" "0" "0" p3 p4 p5 p6 "")
  (setq ZZ(ssadd (entlast) ZZ))
  (command "line" p3 p5 "")
  (setq ZZ(ssadd (entlast) ZZ))
    (draw_cenline p1 p4)
  (setq ZZ(ssadd (entlast) ZZ))

    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "cmdecho" 1)
    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)
    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))

  ))
   (setq *error* olderr)
  (setvar "cmdecho" 1)
  (SETQ FFF nil))
  (princ)
)

;;鑽孔
(defun c:drill4()
  (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype" )
          oldlos (getvar "osmode"))

    (setq olderr *error*)
    (defun *error* (msg)
      (princ msg)
      (setvar "osmode" oldos)
      (setvar "cecolor" oldcol)
      (setvar "celtype" oldlty)
    )

    (setq p1 (getpoint "\n插入點: "))
  (if p1 (progn
  (setq d (getdist P1 "\n孔徑:") )
  (while (null d)
    (princ "\n未輸入孔徑, 請再輸入一次!")
  (setq d (getdist P1 "\n孔徑:") )
  )
  (setq h1 (getdist P1 "\n深度: "))
  (while (null h1)
    (princ "\n未輸入深度, 請再輸入一次!")
    (setq h1 (getdist P1 "\n深度: "))
  )
  (setq ang (getangle p1 "\n旋轉角度<0>:") )
    (cenline_yesno)
  (if (or (= ang nil) (= ang 0)) (setq ang 0))
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype"))
  (initget "SL DL")
  (setq ltp (getkword "\n線型:SL 實線/ DL 虛線<SL>:"))
  (if (or (null ltp) (= "SL" ltp)) (c:&sl&) (c:&dl&))
(setq oldos (getvar "osmode"))
(setvar "osmode" 0)
  (setq p2 (polar p1 (+ (- (* pi 0.5)) ANG) (* d 0.5))
        p3 (polar p2 ang h1)
        p6 (polar p1 ang h1)
        p5 (polar p1 (+ (* pi 0.5) ang) (* d 0.5))
        p4 (polar p5 ang h1))
  (setq zz (ssadd))
  (command "line" p2 p3 "")
  (setq ZZ(ssadd (entlast) ZZ))
  (command "line" p5 p4 "")
  (setq ZZ(ssadd (entlast) ZZ))
    (draw_cenline p1 p6)
  (setq ZZ(ssadd (entlast) ZZ))

    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)
    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))

  ))
   (setq *error* olderr)
  (SETQ FFF nil))
  (setvar "cmdecho" 1)
  (princ)
)



;;┌────────────────────────────────┐
;;│ 程  式 : 繪製鍵槽                                              │
;;│ 主程式 : keyway_1，keyway_2                                    │
;;│ 日  期 : 88:01:18                                              │
;;│ 姓  名 : 塗俊欽                                                │
;;│ 資料庫 : KEYWAY.DAT                                            │
;;│ 方  法 : keyway_1，選擇圓、開槽位置自動繪出                    │
;;│          keyway_2，給予圓心、直徑及位置將自動繪出鍵槽(座)      │
;;└────────────────────────────────┘
;;鎖點模式常駐問題已解決  89.11.1
(defun c:keyway_2()
    (setq olderr *error*)
    (defun *error* (msg)
      (princ msg)
      (setq keyway_2_fg nil)
      (setvar "osmode" oldos)
      (setq oldos nil)
    )
    (setq oldos (getvar "osmode"))
    (setq keyway_2_fg nil)
    (setq name2 "CIRCLE")                                    ;一定是圓，不會有弧
    (setq erase_ss (ssadd))
    (setq cir1 (getpoint "\n請選擇圓心位置:"))
    (setq enter_dia (getdist "\n請輸入軸徑或孔徑(不可為負值):"))
    (while (<= enter_dia 0)
     (setq enter_dia (getdist "\n請輸入軸徑或孔徑(不可為負值):"))
    );while
    (command "circle" cir1 (* 0.5 enter_dia))
    (setq keyway_2_fg t)
   (c:keyway_1)
   (setq *error* olderr)
   (princ)
 );defun

;;鎖點模式常駐問題已解決  89.11.1
(defun c:keyway_1()
    (setq olderr *error*)
    (defun *error* (msg)
      (princ msg)
      (setq keyway_2_fg nil)
      (setvar "osmode" oldos)
      (setq oldos nil)
    )
  (setq path_name (strcat powdesign_data_path "keyway.dat"))         ;;路徑
  (keyway_main)                                 ;;詢問為鍵槽或鍵座
  (if (null oldos) (setq oldos (getvar "osmode")))
  (initget "U S")
  (setq in_type (getkword "\n圖形產生的方式 [使用者自定尺寸(U)/系統自定(S)]<S>:"))
  (if (or (= "S" in_type) (null in_type))
    (progn
      (if (/= type_a "")
        (progn
          (select_object)                              ;;選擇物體並判斷
          (setvar "osmode" 0)
          (g_data_max_min)                             ;;副程式開啟資料庫 並求得資料庫最大值及最小值
          (setq dia (* rad1 2))                        ;;dia  直徑
          (if (or (> dia data_max) (< dia data_min))   ;;先判斷資料庫中有無此資料
             (prompt " 資料庫無此資料 ")
             (progn
               (g_data)                        ;;副程式開啟資料庫 並求得所需值
               (if (= type_a "A") (get_point 0) (get_point pi))   ;;求所需之各點及繪出圖形
             );progn
          );if
        );progn
      );if
      (setvar_end)                   ;;變數歸零
    );progn
    (progn
      (if (= type_a "A")
        (user_keyin 1)  ;鍵槽
        (user_keyin 2)  ;鍵座
      );if
    );progn
  );if
 (setvar "osmode" oldos)
 (setq oldos nil)
   (setq *error* olderr)
) ;end

 (defun user_keyin(typ)
   (actdcl (strcat powdesign_dcl_path "drawmech") "keyway")
   (if (= typ 1)
     (progn
       (set_tile "keytype" "輸入鍵槽尺寸")
       (show_sld "sld" (strcat powdesign_sld_path "keyway1"))
     );progn
     (progn
       (set_tile "keytype" "輸入鍵座尺寸")
       (show_sld "sld" (strcat powdesign_sld_path "keyway2"))
     );progn
   )
   (action_tile "accept" "(user_keyin_ok)")
   (action_tile "cancel" "(done_dialog)")

   (start_dialog)
   (if user_keyin_fg
     (progn
       (if (= type_a "A")
         (exe_user_keyin 0)
         (exe_user_keyin pi)
       )
     );progn
   );if

 );defun


(defun user_keyin_ok()
  (setq w (get_tile "w"))
  (setq d (get_tile "d"))
  (cond
    ((= "" w) (set_tile "error" "寬度 W 未輸入!"))
    ((= "" d) (set_tile "error" "深度 D 未輸入!"))
    (T (done_dialog)(setq w (atof w) d (atof d) user_keyin_fg t))
  );cond
)

(defun exe_user_keyin(ang_A_B)
 (select_object)
 (setvar "osmode" 0)
 (setq cen cir1)
 (setq rad rad1)
 (setq c w)
 (setq t1 d)
 (setq t2 d)
 (setq h (- (* 4 (expt rad 2.0)) (expt c 2.0)))
 (setq h (- rad (* (sqrt h) 0.5)))
 (if (= type_a "A")
  (progn
  (setq high t2)                                   ;鍵座時 high = t2
  (setq sum_high (+ high h))                       ;鍵座的實際高度(p3 到p5 的距離)
  );progn
  (progn
  (setq high t1)                                   ;鍵槽時 high = t2
  (setq sum_high (- high h))                       ;鍵槽的實際高度(p3 到p5 的距離)
 ));if
 (setq ang (angle cen p1))
 (setq p2 (polar cen ang (- rad h)))
 (setq p3 (polar p2 (+ ang (* pi 0.5)) (* c 0.5)))
 (setq p4 (polar p2 (- ang (* pi 0.5)) (* c 0.5)))
 (setq p5 (polar p3  (+ ang ang_A_B) sum_high))
 (setq p6 (polar p4  (+ ang ang_A_B) sum_high))
 (if (= name2 "CIRCLE")                           ;;所選擇之圖元為circle 時
   (progn
     (if (= acad_ver "GENIUS")
        (command ".erase" erase_ss "")
        (command "erase" erase_ss "")
     )
     (command "arc" "c" cen p3 p4 )
     (command "line" p3 p5 p6 p4 "")
   );progn
   (progn                                           ;;所選擇之圖元為arc時
    (setq start_p1 (polar cen arc_ang1 rad1))
    (setq end_p1 (polar cen arc_ang2 rad1))
    (setq arc_length (/ (* (* (* 0.01745 arc_angle) rad) 180) 3.14159))  ;;弧長
        (if (= acad_ver "GENIUS")
          (command ".erase" erase_ss "")
          (command "erase" erase_ss "")
        )
        (command "arc" "c" cen  start_p1 p4)
        (command "arc" "c" cen  p3 end_p1)
        (command "line" p3 p5 p6 p4 "")
 ));if
);;end get_point




(defun keyway_main()
  (initget "A B")
  (setq type_a (getkword "\n 請輸入型式[鍵槽(A)/鍵座(B)]<A> : "))
  (if (or (= "A" type_a)(null type_a)) (setq type_a "A")(setq type_a "B"))
);end keyway_main


  ;;┌────────────────────┐
  ;;│程式:抓圓的副程式                       │
  ;;│結果:求得圓心及半徑                     │
  ;;└────────────────────┘

 (defun select_object()
   (if (null keyway_2_fg)
    (progn
      (setq ss (entsel "\n 請選擇圓或弧"))
       (while (= ss nil) (setq ss (entsel "\n 請選擇圓或弧")))
        (setq name1 (cdr (assoc 0 (entget (car ss)))))
       (if (OR (= name1 "CIRCLE")(= name1 "ARC")) (setq circle_arc 1)(setq circle_arc 0))
       (while (or (= ss nil)(= circle_arc 0))
         (setq ss (entsel "\n 請選擇圓或弧"))
         (while (= ss nil) (setq ss (entsel "\n 請選擇圓或弧")))
         (setq name1 (cdr (assoc 0 (entget (car ss)))))
       ) ;end while
       (setq erase_ss ss)                               ;將要刪除的圖元放入erase_ss選集中
      (setq ssa (car ss))
     )
     (progn
       (setq ss (entlast))
       (setq ssa (entlast))
       (setq erase_ss (entlast))                        ;將要刪除的圖元放入erase_ss選集中
       (setq name1 (cdr (assoc 0 (entget ssa))))
        (if (OR (= name1 "CIRCLE")(= name1 "ARC")) (setq circle_arc 1)(setq circle_arc 0))
     );progn
    );if
    (setq keyway_2_fg nil)
    (setq cir1 (cdr (assoc 10 (entget ssa))))   ;;圓心位置
    (setq cir1_x (car cir1))
    (setq cir1_y (cadr cir1))
    (setq rad1 (cdr (assoc 40 (entget ssa))))   ;;圓半徑
    (setq s1 ssa)
    (setq name2 (cdr (assoc 0 (entget s1))))
    (if (or (= name2 "CIRCLE")(= name2 "ARC"))
    (progn
     (setq cir2 (cdr (assoc 10 (entget ssa))))  ;;圓心位置
          (setq cir2_x (car cir2))
          (setq cir2_y (cadr cir2))
     (setq rad2 (cdr (assoc 40 (entget ssa))))   ;;圓半徑
    ));if
 ; ;---------------------------------------------判斷所選之位置是否為原來圖元上
    (while (or (= ss nil)(/= name1 name2)(/= cir1_x cir2_X)(/= cir1_y cir2_y)(/= rad1 rad2))
       (setq s1 ssa)
       (setq name2 (cdr (assoc 0 (entget s1))))
       (if (OR (= name2 "CIRCLE")(= name2 "ARC"))
         (progn
           (setq cir2 (cdr (assoc 10 (entget ssa))))  ;;圓心位置
           (setq cir2_x (car cir2))
           (setq cir2_y (cadr cir2))
           (setq rad2 (cdr (assoc 40 (entget ssa))))   ;;圓半徑
       ));if
     );while
     (if (= name2 "ARC")
       (progn
         (setq arc_ang1 (cdr (assoc 50 (entget ssa))))   ;;弧起始角度
         (setq arc_ang2 (cdr (assoc 51 (entget ssa))))   ;;弧終止角度
         (setq arc_angle (abs (- arc_ang1 arc_ang2)))         ;;弧全部長度
     ));if end
 ; ;----------------------------------------------

     (setq p1 (getpoint "\n請在圓或弧上選開槽位置:"))
     (setq ll2 (rtos (distance p1 cir2) 2 2))
     (while (/= (rtos rad2 2 2) ll2)
        (princ "\n您點選的點不在圖元上!!")
        (setq p1 (getpoint "\n請再選擇圓或弧上開槽位置:")) ;;求得 開槽位置 p1 點
        (setq ll2 (rtos (distance p1 cir2) 2 2))
     );while
 ) ;;end select_object

; ;-----------------------------         ;;求所需之各點
(defun get_point(ang_A_B)
  (setq cen cir1)
  (setq rad rad1)
  (setq c data_b2)
  (setq t1 data_t1)
  (setq t2 data_t2)
  (setq h (- (* 4 (expt rad 2.0)) (expt c 2.0)))
  (setq h (- rad (* (sqrt h) 0.5)))
  (if (= type_a "A")
  (progn
  (setq high t2)                                   ;鍵座時 high = t2
  (setq sum_high (+ high h))                       ;鍵座的實際高度(p3 到p5 的距離)
  );progn
  (progn
  (setq high t1)                                   ;鍵槽時 high = t2
  (setq sum_high (- high h))                       ;鍵槽的實際高度(p3 到p5 的距離)
 ));if
 (setq ang (angle cen p1))
 (setq p2 (polar cen ang (- rad h)))
 (setq p3 (polar p2 (+ ang (* pi 0.5)) (* c 0.5)))
 (setq p4 (polar p2 (- ang (* pi 0.5)) (* c 0.5)))
 (setq p5 (polar p3  (+ ang ang_A_B) sum_high))
 (setq p6 (polar p4  (+ ang ang_A_B) sum_high))
 (if (= name2 "CIRCLE")                           ;;所選擇之圖元為circle 時
 (progn
  (if (= acad_ver "GENIUS")
     (command ".erase" erase_ss "")
     (command "erase" erase_ss "")
  )
  (command "arc" "c" cen p3 p4 )
  (command "line" p3 p5 p6 p4 "")
 );progn
 (progn                                           ;;所選擇之圖元為arc時
  (setq start_p1 (polar cen arc_ang1 rad1))
  (setq end_p1 (polar cen arc_ang2 rad1))
  (setq arc_length (/ (* (* (* 0.01745 arc_angle) rad) 180) 3.14159))  ;;弧長
  (if (> arc_length (distance p5 p6))
  (progn
   (if (= acad_ver "GENIUS")
       (command ".erase" erase_ss "")
       (command "erase" erase_ss "")
   )
   (command "arc" "c" cen  start_p1 p4)
   (command "arc" "c" cen  p3 end_p1)
   (command "line" p3 p5 p6 p4 "")
   );progn
   (prompt " 無法繪出圖形 ")
   );if
 ));if
 (setvar "osmode" oldos)
);;end get_point

 ;;;-------------------------------副程式開啟資料庫
 (defun g_data_max_min()
   (setq opfile nil)
   (setq opfile (open path_name "r"))
   (setq readdata (read-line opfile))
   (setq readdata (read-line opfile))
   (setq min_rad (atof (nth 0 (read readdata))))            ;;抓資料庫中軸徑最小值
   (setq max_rad (atof (nth 1 (read readdata))))            ;;抓資料庫中軸徑最大值
   (setq data_max max_rad)
   (setq data_min min_rad)
   (setq readdata (read-line opfile))
   (while (/= readdata nil)
    (setq min_rad (atof (nth 0 (read readdata))))
    (setq max_rad (atof (nth 1 (read readdata))))
    (if (<= data_max max_rad) (setq data_max max_rad))
    (if (>= data_min min_rad) (setq data_min min_rad))
    (setq readdata (read-line opfile))
   );while
   (close opfile)
 );end g_data_max_min

 ;;;-------------------------------副程式開啟資料庫
 (defun g_data()
   (setq opfile nil)
   (setq dia (* rad1 2))
   (setq opfile (open path_name "r"))
   (setq readdata (read-line opfile))
   (setq readdata (read-line opfile))
   (setq min_rad (atof (nth 0 (read readdata))))            ;;抓資料庫中軸徑最小值
   (setq max_rad (atof (nth 1 (read readdata))))            ;;抓資料庫中軸徑最大值

    ;;-----------------------            比較所選之圓適用哪一筆資料
    (while (or (<= dia min_rad) (> dia max_rad))
     (setq readdata (read-line opfile))
     (setq min_rad (atof(nth 0 (read readdata))))            ;;抓資料庫中軸徑最小值
     (setq max_rad (atof(nth 1 (read readdata))))            ;;抓資料庫中軸徑最大值
    );while end
   (close opfile)
   (setq data_b2 (atof (nth 2 (read readdata))))             ;;抓資料庫中b2
   (setq data_t1 (atof (nth 3 (read readdata))))             ;;抓資料庫中t1
   (setq data_t2 (atof (nth 4 (read readdata))))             ;;抓資料庫中t2

 ) ;end g_data(number)

 (defun setvar_end()                       ;;將程式所用到的變數變成nil
 (setq cir1 nil rad nil rad1 nil p1 nil p2 nil p3 nil p4 nil p5 nil)
 (setq cir2 nil rad2 nil t1 nil t2 nil h nil high nil name1 nil name2 nil)
 (setq w nil d nil)
  (setq no_data nil)
 )

;==============================================================================
;;鑽孔攻牙(通孔)
;╭════════════════════════════════════════════╮
;║設計日期: 1998.02.22                                                                    ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 鑽孔攻牙(不通孔)                                                              ║
;║執行方式: thrill                                                                        ║
;║相關檔案: THRILL-I.DAT,THRILL-M.DAT,PUB-LIST,ACAD.LSP,thrillc4.SLD,thrill1d.SLD         ║
;║相關檔案: thrillc1.SLD,,thrillc2.SLD,,thrillc3.SLD,AUXDRAW.DCL                          ║
;╰════════════════════════════════════════════╯
(defun c:thrill(/ zz)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setvar "cmdecho" 0)
  (setq drsize nil thh nil drh nil drawfg nil matfg nil)
 (actdcl (strcat powdesign_dcl_path "auxdraw") "thrill")

; (setq msize_list (list "M3" "M3.5" "M4" "M4.5" "M5" "M6" "M7" "M8" "M9"
;                        "M10" "M12" "M14" "M16" "M18" "M20" "M22" "M24" "M27"
;                        "M30" "M33" "M36" "M39" "M42" "M45" "M48"))
; (setq isize_list (list " No 1_64UNC" " No 2_56UNC" " No 3_48UNC" " No 4_40UNC" " No 5_40UNC"
;                        " No 6_32UNC" " No 8_32UNC" " No10_24UNC" " 3/16_24UNC" " 1/ 4_20UNC" " 5/16_18UNC"
;                        " 3/ 8_16UNC" " 7/16_14UNC" " 1/ 2_13UNC" " 9/16_12UNC" " 5/ 8_11UNC" " 3/ 4_10UNC"
;                        " 7/ 8_ 9UNC" " 1   _ 8UNC" "1-1/8_12UNC" "1-1/4_ 7UNC" "1-3/8_ 7UNC" "1-1/2_ 7UNC"
;                        "1-3/4_ 7UNC"))
  (setq msize_list '())
  (setq ff (open (strcat powdesign_data_path "THRILL-M.DAT") "r"))
  (setq ffdata(read-line ff))
  (while ffdata
         (setq msize_list(append msize_list (list (nth 0 (read ffdata)))))
         (setq ffdata(read-line ff))
  )
  (close ff)
  (setq isize_list '())
  (setq ff (open (strcat powdesign_data_path "THRILL-I.DAT") "r"))
  (setq ffdata(read-line ff))
  (while ffdata
         (setq isize_list(append isize_list (list (nth 0 (read ffdata)))))
         (setq ffdata(read-line ff))
  )
  (close ff)



 (data_tile_mode 1)
 (mode_tile "drillsize" 1)
 (mode_tile "thrillsize" 1)
 (mode_tile "drillh" 1)
 (mode_tile "thrillh" 1)


 (act_pop_list msize_list "size_list")
 (act_pop_list mat_list "material")

 (show_sld_col "viewd" (strcat  powdesign_sld_path "thrill1d") -2)
 (show_sld_col "viewf" (strcat  powdesign_sld_path "thrillc1") -2)
 (show_sld_col "views" (strcat  powdesign_sld_path "thrillc2") -2)

 (show_sld_col "hviewf" (strcat  powdesign_sld_path "thrillc3") -2)
 (show_sld_col "hviews" (strcat  powdesign_sld_path "thrillc4") -2)

 (action_tile "thrill-m" "(data_tile_mode 1)(act_pop_list msize_list \"size_list\")")
 (action_tile "thrill-i" "(data_tile_mode 1)(act_pop_list isize_list \"size_list\")")
 (action_tile "ss" "(action_ss)")
 (setq vfsld "thrillc1" vssld "thrillc2" hvfsld "thrillc3" hvssld "thrillc4"
             vscol -2 vfcol -2 hvscol -2 hvfcol -2)

 (action_tile "viewf" "(show_image_mode 1)(setq vfcol 166 vscol -2 hvfcol -2 hvscol -2)")
 (action_tile "views" "(show_image_mode 2)(setq vfcol -2 vscol 166 hvfcol -2 hvscol -2)")
 (action_tile "hviewf" "(show_image_mode 3)(setq vfcol -2 vscol -2 hvfcol 166 hvscol -2)")
 (action_tile "hviews" "(show_image_mode 4)(setq vfcol -2 vscol -2 hvfcol -2 hvscol 166)")
 (action_tile "size_list" "(set_tile \"error\" \"\")(size_list_check)")

 (action_tile "mat1" "(mat_check_data 1)")
 (action_tile "mat2" "(mat_check_data 2)")
 (action_tile "mat3" "(mat_check_data 3)")
 (action_tile "mat4" "(mat_check_data 4)")
 (action_tile "mat5" "(mat_check_data 5)")
 (mode_tile "mat1" 1)
 (mode_tile "mat2" 1)
 (mode_tile "mat3" 1)
 (mode_tile "mat4" 1)
 (mode_tile "mat5" 1)


 (action_tile "cenl" "(show_thrill_sld 1)")
 (action_tile "nocenl" "(show_thrill_sld 2)")

 (action_tile "cancel" "(setq drawfg nil)(done_dialog)")
 (action_tile "accept" "(thrill_ok)")

 (start_dialog)

 (setvar "cmdecho" 1)
 (if drawfg
  (progn
   (if (= "" cendist) (setq cendist 3) (setq cendist (atof cendist)))
   (cond
     ((= vfcol 166) (c:thrill_s 1) )
     ((= vscol 166)  (c:thrill_f 1))
     ((= hvfcol 166) (c:thrill_s 0))
     ((= hvscol 166) (c:thrill_f 0))
   );cond
   (command "script" (strcat powdesign_path "autocopy"))
  );progn
 );if
    (setq zz nil)

   (SETQ FFF nil))
 (prin1)
)

(defun thrill_ok()
    (setq drsize (get_tile "drillsize")
          thsize (get_tile "thrillsize")
          drh    (get_tile "drillh")
          thh    (get_tile "thrillh")
          cenyesno (get_tile "cenl")
          cenl (get_tile "cenl")
          cendist (get_tile "cline"))

    (cond
      ((or (= "" drsize) (= 0 (atof drsize)))
         (set_tile "error" "鑽孔尺寸未輸入或輸入錯誤!"))

      ((and (> (atof drsize) 0) (> (atof drsize) (atof thsize)))
         (set_tile "error" "要小心哦! 鑽孔尺寸不可大於攻牙尺寸!")

      )
      ((or (= "" drsize) (= "" drh) (= "" thh) (and (= vfcol -2) (= vscol -2) (= hvfcol -2) (= hvscol -2)))
         (set_tile "error" "資料輸入不完整或未選擇視圖方向!!"))
      ((or (> (atof thh) (atof drh)))
            (set_tile "error" "哦!機械設計要重修了, 因為 攻牙深度不可大於鑽孔深度 , 請修正輸入值!!"))
      (T (done_dialog)(setq drawfg t))
    )
)

(defun data_tile_mode(fg)
 (mode_tile "drillsize" fg)
 (mode_tile "thrillsize" fg)
 (mode_tile "drillh" fg)
 (mode_tile "thrillh" fg)
 (set_tile "drillsize" "")
 (set_tile "thrillsize" "")
 (set_tile "drillh" "")
 (set_tile "thrillh" "")

)



(defun mat_check_data(fg)
  (setq tilefg (get_tile "size_list"))
  (if (/= "" tilefg)
    (progn
      (cond
        ((= 1 fg)(setq thh (nth 0 (nth 2 data)) drh (nth 1 (nth 2 data))))
        ((= 2 fg)(setq thh (nth 0 (nth 3 data)) drh (nth 1 (nth 3 data))))
        ((= 3 fg)(setq thh (nth 0 (nth 4 data)) drh (nth 1 (nth 4 data))))
        ((= 4 fg)(setq thh (nth 0 (nth 5 data)) drh (nth 1 (nth 5 data))))
      )
      (if (= fg 5)
         (progn
           (mode_tile "ss" 0)
           (set_tile "thrillh" "")
           (set_tile "drillh" "")
         );progn
         (progn
           (mode_tile "ss" 1)(set_tile "ss" "")
           (set_tile "thrillh" thh)
           (set_tile "drillh" drh)
         );progn
      );if
      (set_tile "drillsize" drsize)
      (set_tile "thrillsize" thsize)
      ;(set_tile "drillh" drh)
      ;(set_tile "thrillh" thh)
    );progn
    (princ)
  )
)




(defun size_list_check()
  (mode_tile "mat1" 0) (mode_tile "mat2" 0) (mode_tile "mat3" 0) (mode_tile "mat4" 0) (mode_tile "mat5" 0)
  (setq mat1 (get_tile "mat1"))
  (setq mat2 (get_tile "mat2"))
  (setq mat3 (get_tile "mat3"))
  (setq mat4 (get_tile "mat4"))
  (setq mat5 (get_tile "mat5"))
  (setq thrill-m (get_tile "thrill-m"))
  (setq sel_id (atoi (get_tile "size_list")))

  (data_tile_mode 0)

  (if (= "1" thrill-m)
      (setq ff (open (strcat powdesign_data_path "THRILL-M.DAT") "r"))
      (setq ff (open (strcat powdesign_data_path "THRILL-I.DAT") "r"))
  );if
      (repeat (1+ sel_id)
         (setq data (read-line ff))
      )(setq data (read data))(close ff)
      (setq data(cdr data))
      (setq thsize (nth 0 data)
            drsize (nth 1 data))
      (cond
        ((= "1" mat1)(setq thh (nth 0 (nth 2 data)) drh (nth 1 (nth 2 data))))
        ((= "1" mat2)(setq thh (nth 0 (nth 3 data)) drh (nth 1 (nth 3 data))))
        ((= "1" mat3)(setq thh (nth 0 (nth 4 data)) drh (nth 1 (nth 4 data))))
        ((= "1" mat4)(setq thh (nth 0 (nth 5 data)) drh (nth 1 (nth 5 data))))
      )
      (set_tile "drillsize" drsize)
      (set_tile "thrillsize" thsize)
      (set_tile "drillh" drh)
      (set_tile "thrillh" thh)

      (if (= "1" (get_tile "mat5"))  (action_ss) );if

);defun

(defun action_ss()
   (setq ddd (nth 0 data))
   (setq ss (get_tile "ss"))
   (if (=  0 (atof ss))
     (set_tile "error" "倍數輸入錯誤!")
     (progn
       (setq ss (atof ss))
       (setq ddd (atof ddd))
       (setq drh (rtos (+ (* ss ddd) (fix (* 0.4 ddd))) 2 0))
       (setq thh (rtos (* ss ddd) 2 0))
       (set_tile "drillh"  drh)
       (set_tile "thrillh" thh)
     );progn
   );if

)

(defun show_image_mode(fg)
  (cond
    ((= 1 fg)
         (show_sld_col "viewf" (strcat powdesign_sld_path vfsld) 166)
         (show_sld_col "views" (strcat  powdesign_sld_path vssld) -2)
         (show_sld_col "hviewf" (strcat powdesign_sld_path hvfsld) -2)
         (show_sld_col "hviews" (strcat  powdesign_sld_path hvssld) -2)
    )
    ((= 2 fg)
        (show_sld_col "views" (strcat powdesign_sld_path vssld) 166)
        (show_sld_col "viewf" (strcat  powdesign_sld_path vfsld) -2)
        (show_sld_col "hviewf" (strcat powdesign_sld_path hvfsld) -2)
        (show_sld_col "hviews" (strcat  powdesign_sld_path hvssld) -2)
    )
    ((= 3 fg)
        (show_sld_col "views" (strcat powdesign_sld_path vssld) -2)
        (show_sld_col "viewf" (strcat  powdesign_sld_path vfsld) -2)
        (show_sld_col "hviews" (strcat powdesign_sld_path hvssld) -2)
        (show_sld_col "hviewf" (strcat  powdesign_sld_path hvfsld) 166)
    )
    ((= 4 fg)
        (show_sld_col "views" (strcat powdesign_sld_path vssld) -2)
        (show_sld_col "viewf" (strcat  powdesign_sld_path vfsld) -2)
        (show_sld_col "hviews" (strcat powdesign_sld_path hvssld) 166)
        (show_sld_col "hviewf" (strcat  powdesign_sld_path hvfsld) -2 )
    )
  )
)

(defun show_thrill_sld(fg)
   (cond
     ((= 1 fg)(mode_tile "cline" 0)
              (show_sld_col "viewf" (strcat  powdesign_sld_path "thrillc1") vfcol)
              (show_sld_col "views" (strcat  powdesign_sld_path "thrillc2") vscol)
              (show_sld_col "hviewf" (strcat  powdesign_sld_path "thrillc3") hvfcol)
              (show_sld_col "hviews" (strcat  powdesign_sld_path "thrillc4") hvscol)
              (setq vfsld "thrillc1" vssld "thrillc2" hvfsld "thrillc3" hvssld "thrillc4"))
     ((= 2 fg)(mode_tile "cline" 1)
              (show_sld_col "viewf" (strcat  powdesign_sld_path "thrill1") vfcol)
              (show_sld_col "views" (strcat  powdesign_sld_path "thrill2") vscol)
              (show_sld_col "hviewf" (strcat  powdesign_sld_path "thrill3") hvfcol)
              (show_sld_col "hviews" (strcat  powdesign_sld_path "thrill4") hvscol)
              (setq vfsld "thrill1" vssld "thrill2" hvfsld "thrill3" hvssld "thrill4"))
   )
)
;;;t1
(defun c:thrill_f(fg)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype"))
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1)
      (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: "))
    )
    (setq p6 (polar p1 (- (* pi 1.5) (/ pi 12)) (+ (* (atof thsize) 0.5))))
    (setq ZZ nil)
  (setq ZZ (ssadd))
    (if (= fg 1)
      (progn
        (C:&TL&)
        (setq oldos (getvar "osmode"))
        (setvar "osmode" 0)
        (command "ARC" "C" P1 P6 "A" "300")
      (setq ZZ(ssadd (entlast) ZZ))
        (C:&SL&)
        (command "circle" p1 "d" (atof drsize))
      (setq ZZ(ssadd (entlast) ZZ))
        (setvar "osmode" oldos)
      )
      (progn
        (C:&dL&)
        (setq oldos (getvar "osmode"))
        (setvar "osmode" 0)
        (command "circle" p1 "d" (atof thsize))
      (setq ZZ(ssadd (entlast) ZZ))
        (command "circle" p1 "d" (atof drsize))
      (setq ZZ(ssadd (entlast) ZZ))
        (setvar "osmode" oldos)
      )
    );cond

    (if (= "1" cenl)
      (progn
        (setq thsize (atof thsize))
        (setvar "osmode" 0)
        (setq p2 (polar p1 pi (+ cendist (* thsize 0.5)))
              p3 (polar p1 (* 0.5 pi) (+ cendist (* thsize 0.5)))
              p4 (polar p1 0 (+ cendist (* thsize 0.5)))
              p5 (polar p1 (* pi 1.5) (+ cendist (* thsize 0.5))))
        (c:&cl&)
        (command "line" p2 p4 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (command "line" p3 p5 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (setvar "osmode" oldos)
      )
    )
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)
    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setq zz nil)
    (princ)
)
;;;t3
(defun c:thrill_s(fg)
    (setq th (atof thh)
          dh (atof drh)
         tt (atof thsize)
          d (atof drsize))
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1)
      (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: "))
    )
    (setq ang (getangle p1 "\n旋轉角度<0>:") )
    (if (or (= ang nil) (= ang 0)) (setq ang 0))
    (setq p6 (polar p1 (+ (- (* pi 0.5)) ang) (* tt 0.5)))
    (setq p8 (polar p1 (+ (- (* pi 0.5)) ang) (* d 0.5)))
    (setq p9 (polar p8 ang DH))
    (setq p12 (polar p1 (+ (* pi 0.5) ang) (* tt 0.5)))
    (setq p10 (polar p1 (+ (* pi 0.5) ang) (* d 0.5)))
    (setq p11 (polar p10 ang DH))
    (setq p14 (polar p6 ang TH))
    (setq p15 (polar p12 ang TH))
    (setq p16 (polar p1 ang (+ DH (/ (* (sqrt 3) tt) 6.00))))
    (setq ZZ nil)
  (setq ZZ (ssadd))
; (setq lastent (entlast))
; (setq aa (entlast))
; (if (null lastent) (progn (command "point" "0,0")(setq lastent (entlast))))
    (if (= 1 fg)
      (progn
        (setq oldcol (getvar "cecolor")
              oldlty (getvar "celtype"))
        (c:&Tl&)
        (setq oldos (getvar "osmode"))
        (setvar "osmode" 0)
        (command "line" p6 p14 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (command "line" p12 p15 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (c:&sl&)
        (command "Pline" p8 "w" "0" "0" p9 p16 p11 p10 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (command "line" p9 p11 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (command "line" p14 p15 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (setvar "osmode" oldos)
        (setvar "cecolor" oldcol)
        (setvar "celtype" oldlty)
      );progn
      (progn
        (setq oldcol (getvar "cecolor")
              oldlty (getvar "celtype"))
        (c:&dl&)
        (setq oldos (getvar "osmode"))
        (setvar "osmode" 0)
        (princ "I")
        (command "line" p6 p14 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (command "line" p12 p15 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (command "Pline" p8 "w" "0" "0" p9 p16 p11 p10 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (command "line" p9 p11 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (command "line" p14 p15 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (setvar "osmode" oldos)
        (setvar "cecolor" oldcol)
        (setvar "celtype" oldlty)
      )
    )
    (if (= "1" cenl)
      (progn
        (setq oldcol (getvar "cecolor")
              oldlty (getvar "celtype"))
        (setq oldos (getvar "osmode"))
        (setvar "osmode" 0)
        (setq cp1 (polar p1 (+ ang pi) cendist)
              cp2 (polar p16 ang cendist))
        (c:&cl&)
        (command "line" cp1 cp2 "")
      (setq ZZ(ssadd (entlast) ZZ))
        (setvar "osmode" oldos)
        (setvar "cecolor" oldcol)
        (setvar "celtype" oldlty)
      )
    )
    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setq zz nil)
    (princ)
)

;;;thrill2
;╭════════════════════════════════════════════╮
;║設計日期: 1998.08.31                                                                    ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 鑽孔攻牙(通孔)                                                                ║
;║執行方式: thrill                                                                        ║
;║相關檔案: mmsize.dat, inchsize.dat                                                      ║
;╰════════════════════════════════════════════╯
(defun c:thrill2(/ flag ltype)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
    (setvar "cmdecho" 0)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype")
          oldos  (getvar "osmode"))

    (setq olderr *error*)
    (defun *error* (msg)
      (princ msg)
      (setvar "osmode" oldos)
      (setvar "cecolor" oldcol)
      (setvar "celtype" oldlty)
    )

    (thrill2_creat_sizelist 1)
    (actdcl (strcat POWDESIGN_dcl_path "auxdraw") "thrill2")

    (act_pop_list lablist "size_list")

    (action_tile "accept" "(thrill2_ok)")
    (action_tile "cancel" "(done_dialog)")

    (action_tile "mm" "(thrill2_creat_sizelist 1)(act_pop_list lablist \"size_list\")")
    (action_tile "inch" "(thrill2_creat_sizelist 2)(act_pop_list lablist \"size_list\")")

    (start_dialog)
    (if flag (thrill2_exe ltype))
    (setvar "cmdecho" 1)
   (setq *error* olderr)
   (SETQ FFF nil))
    (PRINC)
)

(defun thrill2_ok(/ txt_id ltype_id)
   (setq txt_id (get_tile "size_list"))
   (setq ltype_id (get_tile "sl"))
   (cond
     ((= "" txt_id) (set_tile "error" "您沒有選擇螺紋尺寸!"))
     (t (setq sizedata (nth (atoi txt_id) size_list))
        (setq flag t)
        (if (= "1" ltype_id) (setq ltype 1) (setq ltype 0))
        (done_dialog))
   )
)

(defun thrill2_exe(typ / d tt l ang p1 p6 p7 p8 p9 p10 p11 p12 p13 oldos)
    (setq d (nth 0 (nth 1 sizedata)) tt (nth 1 (nth 1 sizedata)))
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1)
      (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: "))
    )
    (setq L (getdist p1 "\n板厚: "))
    (while (null L)
      (setq L (getdist p1 "\n沒輸入板厚,請再輸入一次: "))
    )
    (setq ang (getangle p1 "\n旋轉角度<0>:") )
    (cenline_yesno)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype"))
    (if (or (= ang nil) (= ang 0)) (setq ang 0))
    (setq p2 (polar p1 ang L))
    (setq p6 (polar p1 (+ (- (* pi 0.5)) ang) (* d 0.5)))
    (setq p7 (polar p6 ang L))
    (setq p8 (polar p1 (+ (- (* pi 0.5)) ang) (* tt 0.5)))
    (setq p9 (polar p8 ang L))
    (setq p10 (polar p1 (+ (* pi 0.5) ang) (* tt 0.5)))
    (setq p11 (polar p10 ang L))
    (setq p12 (polar p1 (+ (* pi 0.5) ang) (* d 0.5)))
    (setq p13 (polar p12 ang L))
    (if (= typ 1) (c:&tl&) (c:&dl&))
    (setq oldos (getvar "osmode"))
    (setvar "osmode" 0)
    (setq zz (ssadd))
    (command "line" p8 p9 "")
    (setq zz (ssadd (entlast) zz))
    (command "line" p10 p11 "")
    (setq zz (ssadd (entlast) zz))
    (if (= typ 1) (c:&sl&) (c:&dl&))
    (command "line" p6 p7 "")
    (setq zz (ssadd (entlast) zz))
    (command "line" p12 p13 "")
    (setq zz (ssadd (entlast) zz))
    (draw_cenline p1 p2)
    (setq zz (ssadd (entlast) zz))

    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "cmdecho" 1)(setq aaa typ)
    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)
    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))
)


;typ=1 (mm), typ=2 (inch)  typ=3 (推拔尺寸)
(defun thrill2_creat_sizelist(typ)
  (setq size_list '() lablist '())
  (cond
    ((= 1 typ) (setq ff (open (strcat POWDESIGN_DATA_path "mmsize.dat") "r")))
    ((= 2 typ) (setq ff (open (strcat POWDESIGN_DATA_path "inchsize.dat") "r")))
    ((= 3 typ) (setq ff (open (strcat POWDESIGN_DATA_path "tapmsize.dat") "r")))
  );cond

  (setq data (read-line ff)
        data (read-line ff))

  (while data
      (setq size_list (cons (read data) size_list) data (read-line ff))
  )(close ff)

  (setq size_list (reverse size_list))
  (foreach nn size_list
     (progn
        (setq lablist (cons (nth 0 nn) lablist))
     );progn
  );foreach
  (setq lablist (reverse lablist))
)

;;;沉窩螺絲孔
;╭════════════════════════════════════════════╮
;║設計日期: 1998.08.31                                                                    ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 沉窩螺絲孔                                                                    ║
;║執行方式: thrill                                                                        ║
;║相關檔案: mmsize.dat, inchsize.dat                                                      ║
;╰════════════════════════════════════════════╯
(defun c:thrill3(/ flag ltype view_id wucs)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
    (setvar "cmdecho" 0)
    (setq wucs nil
          oldcol (getvar "cecolor")
          oldlty (getvar "celtype")
          oldos  (getvar "osmode"))


    (setq olderr *error*)
    (defun *error* (msg)
      (princ msg)
      (setvar "osmode" oldos)
      (setvar "cecolor" oldcol)
      (setvar "celtype" oldlty)
      (if (= wucs 0) (command "ucs" "n" ucsorg));if
    )


    (thrill2_creat_sizelist 1)
    (actdcl (strcat POWDESIGN_dcl_path "auxdraw") "thrill3")

    (act_pop_list lablist "size_list")

    (thrill3_sldmode "thrill3t" -2 "thrill3s" 5)
    (action_tile "top"  "(thrill3_sldmode \"thrill3t\" 5 \"thrill3s\" -2)")
    (action_tile "side" "(thrill3_sldmode \"thrill3t\" -2 \"thrill3s\" 5)")

    (action_tile "mm" "(thrill2_creat_sizelist 1)(act_pop_list lablist \"size_list\")")
    (action_tile "inch" "(thrill2_creat_sizelist 2)(act_pop_list lablist \"size_list\")")

    (action_tile "accept" "(thrill3_ok)")
    (action_tile "cancel" "(done_dialog)")

    (start_dialog)
    (if flag
      (progn
 ;       (if (= (setq wucs (getvar "worlducs")) 0)
 ;           (progn
 ;                (setq ucsorg (getvar "ucsorg"))
 ;                (command "ucs" "w")
;            );progn
;        );if
        (if (= view_id 1)
           (thrill3s_exe ltype)
           (thrill3t_exe ltype)
        )
      );progn
    );if
;    (if (= wucs 0) (command "ucs" "n" ucsorg));if
    (setvar "cmdecho" 1)
    (SETQ FFF nil))
    (setq *error* olderr)
    (PRINC)
)
(defun thrill3t_exe(typ)
    (setvar "cmdecho" 0)
    (setq di (nth 0 (nth 2 sizedata)) do (nth 1 (nth 2 sizedata)) h (nth 2 (nth 2 sizedata)))
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1)
      (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: "))
    )
    (cenline_yesno)
    ;(if (= typ 1) (c:&sl&) (c:&dl&));2003.04.07 SAM
    (setq oldos (getvar "osmode"))
    (setvar "osmode" 0)
    (setq zz (ssadd))
    (command "circle" p1 "d" di)
    (setq zz (ssadd (entlast) zz))

    (if (= typ 1) (c:&sl&) (c:&dl&));2003.04.07 SAM
    (command "circle" p1 "d" do)
    (setq zz (ssadd (entlast) zz))
    (drawcircle_cenline (entlast))
    (setq zz (ssadd (entlast) zz))

    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "cmdecho" 1)
    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)


    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))


)

(defun thrill3s_exe(typ)
    (setvar "cmdecho" 0)
  (setq di (nth 0 (nth 2 sizedata)) do (nth 1 (nth 2 sizedata)) h (nth 2 (nth 2 sizedata)))
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1)
      (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: "))
    )
    (setq L (getdist p1 "\n板厚: "))
    (while (null L)
      (setq L (getdist p1 "\n沒輸入板厚,請再輸入一次: "))
    )
    (setq ang (getangle p1 "\n旋轉角度<0>:") )
    (cenline_yesno)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype"))
    (if (or (= ang nil) (= ang 0)) (setq ang 0))
    (setq p15 (polar p1 ang h)
          p6 (polar p1 (+ (- (* pi 0.5)) ang ) (* do 0.5))
          p7 (polar p6 ang h)
          p8 (polar p15 (+ (- (* pi 0.5)) ang ) (* di 0.5))
          p9 (polar p15 (+ (* pi 0.5) ang) (* di 0.5))
          p11 (polar p1 (+ (* pi 0.5) ang) (* do 0.5))
          p10 (polar p11 ang h)
          p13 (polar p9 ang (- L h))
          p12 (polar p8 ang (- L h))
          p14 (polar p1 ang L)
    )
    (if (= typ 1) (c:&sl&) (c:&dl&))
    (setq oldos (getvar "osmode"))
    (setvar "osmode" 0)
    (setq zz (ssadd))
    (command "pline" p6 "w" "0" "0" p7 p10 p11 "")
    (setq zz (ssadd (entlast) zz))
    (command "line" p9 p13 "")
    (setq zz (ssadd (entlast) zz))
    (command "line" p8 P12 "")
    (setq zz (ssadd (entlast) zz))
    (draw_cenline p1 p14)
    (setq zz (ssadd (entlast) zz))
    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "cmdecho" 1)
    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)
    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))
    (princ)
)

(defun thrill3_sldmode(sld1 col1 sld2 col2)
    (show_sld_col "top" (strcat powdesign_sld_path sld1) col1)
    (show_sld_col "side" (strcat powdesign_sld_path sld2) col2)
    (if (= col1 5) (setq view_id 0) (setq view_id 1))
)

(defun thrill3_ok(/ txt_id ltype_id)
   (setq txt_id (get_tile "size_list"))
   (setq ltype_id (get_tile "sl"))
   (cond
     ((= "" txt_id) (set_tile "error" "您沒有選擇螺紋尺寸!"))
     (t (setq sizedata (nth (atoi txt_id) size_list))
        (setq flag t)
        (if (= "1" ltype_id) (setq ltype 1) (setq ltype 0))
        (done_dialog))
   )
)

;;推拔螺絲孔
;╭════════════════════════════════════════════╮
;║設計日期: 1998.08.31                                                                    ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 推拔螺絲孔                                                                    ║
;║執行方式:                                                                               ║
;║相關檔案: mmsize.dat, inchsize.dat                                                      ║
;╰════════════════════════════════════════════╯
(defun c:thrill4(/ flag ltype view_id)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
    (setvar "cmdecho" 0)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype" )
          oldlos (getvar "osmode"))

    (setq olderr *error*)
    (defun *error* (msg)
      (princ msg)
      (setvar "osmode" oldos)
      (setvar "cecolor" oldcol)
      (setvar "celtype" oldlty)
    )
    (thrill2_creat_sizelist 3)
    (actdcl (strcat POWDESIGN_dcl_path "auxdraw") "thrill4")

    (act_pop_list lablist "size_list")

    (thrill3_sldmode "thrill4t" -2 "thrill4s" 5)
    (action_tile "top"  "(thrill3_sldmode \"thrill4t\" 5 \"thrill4s\" -2)")
    (action_tile "side" "(thrill3_sldmode \"thrill4t\" -2 \"thrill4s\" 5)")

    (action_tile "accept" "(thrill3_ok)")
    (action_tile "cancel" "(done_dialog)")

    (start_dialog)
    (if flag
      (progn
        (if (= view_id 1)
           (thrill4s_exe ltype)
           (thrill4t_exe ltype)
        )
      )
    )
    (setvar "cmdecho" 1)
   (SETQ FFF nil))
   (setq *error* olderr)
    (PRINC)
)

(defun thrill4t_exe (typ)
    (setvar "cmdecho" 0)
    (setq d (nth 0 (nth 1 sizedata)) h (nth 1 (nth 1 sizedata)))
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1)
      (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: "))
    )
    (if (= typ 1) (c:&sl&) (c:&dl&))
    (setq p2 (polar p1 0 h)
          p5 (polar p2 (* pi 0.5) (* d 0.5))
          p6 (polar p5 (- (* pi 0.5)) d)
          p7 (polar p5 (* pi 0.75) (* (sqrt 2) h))
          p8 (polar p6 (- (* pi 0.75)) (* (sqrt 2) h))
    )
    (cenline_yesno)
    (setq oldos (getvar "osmode"))
    (setvar "osmode" 0)
    (setq zz (ssadd))
    (command "circle" p1 (* d 0.5))
    (setq zz (ssadd (entlast) zz))
    (command "circle" p1 (* (distance p7 p8) 0.5))
    (setq zz (ssadd (entlast) zz))
    (drawcircle_cenline (entlast))
    (setq zz (ssadd (entlast) zz))
    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "cmdecho" 1)
    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)
    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))
)

(defun thrill4s_exe (typ)
    (setvar "cmdecho" 0)
    (setq d (nth 0 (nth 1 sizedata)) h (nth 1 (nth 1 sizedata)))
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1)
      (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: "))
    )
    (setq thick (getdist p1 "\n板厚 :"))
    (while (null thick)
      (setq thick (getdist p1 "\n沒輸入板厚,請再輸入一次: "))
    )
    (setq ang (getangle p1 "\n旋轉角度<0>:"))
    (cenline_yesno)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype"))
    (if (= typ 1) (c:&sl&) (c:&dl&))
    (if (or (= ang nil) (= ang 0)) (setq ang 0))
    (setq p2 (polar p1 ang thick)
          p3 (polar p2 (+ (* pi 0.5) ang) (* d 0.5))
          p4 (polar p3 (+ (- (* pi 0.5)) ang) d)
          p5 (polar p3 (+ pi ang) (- thick h))
          p6 (polar p4 (+ pi ang) (- thick h))
          p7 (polar p5 (+ (* pi 0.75) ang) (* (sqrt 2) h))
          p8 (polar p1 (+ (* pi 1.5) ang) (distance p7 p1))
     )
     (setq oldos (getvar "osmode"))
     (setvar "osmode" 0)
    (setq zz (ssadd))
     (command "pline" p7 "w" "0" "0" p5 p3 "")
    (setq zz (ssadd (entlast) zz))
     (command "pline" p8 "w" "0" "0" p6 p4 "")
    (setq zz (ssadd (entlast) zz))
     (command "pline" p5 "w" "0" "0" p6 "" )
    (setq zz (ssadd (entlast) zz))
     (draw_cenline p1 p2)
    (setq zz (ssadd (entlast) zz))
    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "cmdecho" 1)
    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)
    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))

)

;;鈑金截斷線
(defun c:sheetbrk(/ ent1 ent2 p1 p2 p3 ext_length clineang cp1 cp2
                 ap1 ap2 p1_1 p1_2 ang1 ang2 midp1
                 midp1_1 midp1_2 midp1_3 midp1_4
                 midp2_1 midp2_2 midp2_3 midp2_4)
  (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (setvar "cmdecho" 0)
  (mem_curset)
  (setvar "osmode" 512)
  (princ "\n畫板金截斷線...")
  (setq p1 (getpoint "\n第一條線的位置: "))
  (setq ent1 (ssget p1))
  (setq p2 (getpoint p1 "\n第二條線的位置: "))
  (setq ent2 (ssget p2))
  (setq p3 (getpoint p1 "\n斷線位置: "))
  (setq d1 (distance p1 p3))
  (setq ext_length (getdist p1 "\n斷線延伸距離: "))
  (setvar "osmode" 0)
  (setq clineang (angle p1 p2))
  (if (or (and (>= clineang 0)(< clineang (* pi 0.5)))
          (and (>= (* 1.5 pi) clineang) (< clineang (* pi 2)))
       );or
      (progn
         (setq cp1 (polar p1 (+ pi clineang) ext_length))
         (setq cp2 (polar p2 clineang ext_length))
      );progn
      (progn
         (setq cp1 (polar p1 (+ pi clineang) ext_length))
         (setq cp2 (polar p2 clineang ext_length))
      );progn
  );if
  (setq ap1 (polar p1 (angle p1 p3) d1))
  (setq ap2 (polar p2 (angle p1 p3) d1))
  (setq p1_1 (polar cp1 (angle p1 p3) d1))
  (setq p1_2 (polar cp2 (angle p1 p3) d1))
  (setq ang1 (angle p1 p2))
  (setq ang2 (angle p2 p1))
  (setq midp1 (polar p1 ang1 (* 0.5 (distance p1 p2))))
  (setq midp1_1 (polar midp1 ang2 (* 3 (sqrt 2))))
  (setq midp1_2 (polar midp1_1 (+ ang1 (* 10 (/ pi 6))) 3))
  (setq midp1_4 (polar midp1 ang1 (* 3 (sqrt 2))))
  (setq midp1_3 (polar midp1_4 (+ ang1 (* 4 (/ pi 6))) 3))

  (setq midp2_1 (polar midp1_1 (angle p1 p3) d1))
  (setq midp2_2 (polar midp1_2 (angle p1 p3) d1))
  (setq midp2_3 (polar midp1_3 (angle p1 p3) d1))
  (setq midp2_4 (polar midp1_4 (angle p1 p3) d1))
  (command "break" ent1 p1 ap1)
  (command "break" ent2 p2 ap2)
  (c:&pl&)
  (command "pline" cp1 "w" "0" "0" midp1_1 midp1_2 midp1_3 midp1_4 cp2 "")
  (command "pline" p1_1 "w" "0" "0" midp2_1 midp2_2 midp2_3 midp2_4 p1_2 "")
  (rt_to_old_set)
  (setvar "cmdecho" 1)
   (SETQ FFF nil))
   (princ)
)

(defun c:pipscrew()
  (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "cmdecho" 0)
   (actdcl (strcat powdesign_dcl_path "auxdraw") "pipscrew")
   (setq view_id nil)
   (get_pipscrew_list)
   (act_pop_list size_list "size")
   (show_sld_col "top_sld"  (strcat  powdesign_sld_path "pipscr-t") -2)
   (show_sld_col "side_sld" (strcat  powdesign_sld_path "pipscr-s") -2)
   (show_sld_col "butm_sld" (strcat  powdesign_sld_path "pipscr-b") -2)

   (action_tile  "top_sld"  "(mode_tile \"sl\" 1)(mode_tile \"dl\" 1)(show_pipsld 253 -2 -2)")
   (action_tile  "side_sld" "(mode_tile \"sl\" 0)(mode_tile \"dl\" 0)(show_pipsld -2 253 -2)")
   (action_tile  "butm_sld" "(mode_tile \"sl\" 1)(mode_tile \"dl\" 1)(show_pipsld -2 -2 253)")

   (action_tile "tappip" "(set_tile \"parpip\" \"0\")")
   (action_tile "parpip" "(set_tile \"tappip\" \"0\")")

   (action_tile "size" "(get_size_data)")
   (action_tile "cancel" "(done_dialog)")
   (action_tile "accept" "(pipscrew_ok)")

   (start_dialog)
   (if pipscrew_flag
     (progn
       (cond
         ((= 1 view_id) (exe_pipscrew_top))
         ((= 2 view_id) (exe_pipscrew_side))
         ((= 3 view_id) (exe_pipscrew_butm))
       );cond
     );progn
   );if
   (setvar "cmdecho" 1)
   (SETQ FFF nil))
   (prin1)

);defun
(defun show_pipsld(v1 v2 v3)
   (show_sld_col "top_sld"  (strcat  powdesign_sld_path "pipscr-t") v1)
   (show_sld_col "side_sld"  (strcat  powdesign_sld_path "pipscr-s") v2)
   (show_sld_col "butm_sld"  (strcat  powdesign_sld_path "pipscr-b") v3)
   (cond
    ((= 253 v1)(setq view_id 1))
    ((= 253 v2)(setq view_id 2))
    ((= 253 v3)(setq view_id 3))
   )
)
(defun exe_pipscrew_top()
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1) (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: ")) )
   (setvar "cmdecho" 0)
    (cenline_yesno)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype"))
    (setq oldos (getvar "osmode"))
        (setvar "osmode" 0)
        (setq zz (ssadd))
        (c:&sl&)
        (command "circle" p1 (* (atof di) 0.5))
        (setq zz (ssadd (entlast) zz))
        (c:&tl&)
        (command "arc" "c" p1 (polar p1 (- (* pi 1.5) (/ pi 12)) (* (atof do) 0.5)) "a" "300")
        (setq zz (ssadd (entlast) zz))
        (drawcircle_cenline (entlast))
        (setq zz (ssadd (entlast) zz))
    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "cmdecho" 1)
    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)
    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))

  (princ)
)
(defun exe_pipscrew_butm()
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1) (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: ")) )
    (cenline_yesno)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype"))
    (setq oldos (getvar "osmode"))
    (setvar "osmode" 0)
    (c:&dl&)
    (setvar "cmdecho" 0)
         (setq zz (ssadd))
    (command "circle" p1 (* (atof di) 0.5))
         (setq zz (ssadd (entlast) zz))
    (command "circle" p1 (* (atof do) 0.5))
         (setq zz (ssadd (entlast) zz))
    (drawcircle_cenline (entlast))
         (setq zz (ssadd (entlast) zz))
    (setvar "cmdecho" 1)
    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "cmdecho" 1)
    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)


    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))

    (princ)
)

(defun exe_pipscrew_side()
    (setq p1 (getpoint "\n插入點: "))
    (while (null p1)
      (setq p1 (getpoint "\n沒輸入插入點,請再輸入一次: "))
    )
    (setq thick (getdist p1 "\n板厚 :"))
    (while (null thick)
      (setq thick (getdist p1 "\n沒輸入板厚,請再輸入一次: "))
    )
    (setq ang (getangle p1 "\n旋轉角度<0>:"))
   (setvar "cmdecho" 0)
    (cenline_yesno)
    (setq oldcol (getvar "cecolor")
          oldlty (getvar "celtype"))
    (if (= ltype 1) (c:&sl&) (c:&dl&))
    (if (or (= ang nil) (= ang 0)) (setq ang 0))
    (setq di (atof di)
          do (atof do)
          scr_ang (dtr 1.79))
    (setq oldos (getvar "osmode"))
    (setvar "osmode" 0)
    (setq p2 (polar p1 ang thick)
          p3 (polar p1 (+ (* pi 0.5) ang) (* di 0.5))
          p4 (polar p1 (+ (* pi 0.5) ang) (* do 0.5))
          p5 (polar p1 (+ (* 1.5 pi) ang) (* di 0.5))
          p6 (polar p1 (+ (* 1.5 pi) ang) (* do 0.5))
          p1-1 (polar p1 ang screw_l)
     )
        (setq zz (ssadd))
     (if (= "1" parpip)
      (progn
        (setq p3-1 (polar p3 ang thick)
              p4-1 (polar p4 ang (atof par_l))
              p5-1 (polar p5 ang thick)
              p6-1 (polar p6 ang (atof par_l)))
        (if (= "1" ltype_id)
          (progn
            (c:&tl&)
            (command "line" p3 p3-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p5 p5-1 "")
        (setq zz (ssadd (entlast) zz))
            (c:&sl&)
            (command "line" p4 p4-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p6 p6-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p4-1 p6-1 "")
        (setq zz (ssadd (entlast) zz))
          );progn
          (progn
            (c:&dl&)
            (command "line" p3 p3-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p5 p5-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p4 p4-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p6 p6-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p4-1 p6-1 "")
        (setq zz (ssadd (entlast) zz))
          );progn
        );if
      );progn
      (progn
        (setq p3-1 (polar p3 (+ (- scr_ang) ang) (atof par_l))
              p3-2 (polar p3-1 ang (- thick (atof par_l)))
              p4-1 (polar p4 (+ (- scr_ang) ang) (atof par_l))
              p5-1 (polar p5 (+ scr_ang ang) (atof par_l))
              p5-2 (polar p5-1 ang (- thick (atof par_l)))
              p6-1 (polar p6 (+ scr_ang ang) (atof par_l)))
        (if (= "1" ltype_id)
          (progn
            (c:&tl&)
            (command "line" p4 p4-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p6 p6-1 "")
        (setq zz (ssadd (entlast) zz))
            (c:&sl&)
            (command "line" p3 p3-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p5 p5-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p3-1 p3-2 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p5-1 p5-2 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p4-1 p6-1 "")
        (setq zz (ssadd (entlast) zz))
          );progn
          (progn
            (c:&dl&)
            (command "line" p3 p3-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p5 p5-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p4 p4-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p6 p6-1 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p3-1 p3-2 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p5-1 p5-2 "")
        (setq zz (ssadd (entlast) zz))
            (command "line" p4-1 p6-1 "")
        (setq zz (ssadd (entlast) zz))
          );progn
        );if
      );progn
     );progn
     (draw_cenline p1 p2)
        (setq zz (ssadd (entlast) zz))
    (command "select" zz "")
    (setvar "lastpoint" p1)

    (setvar "osmode" oldos)
    (setvar "cecolor" oldcol)
    (setvar "celtype" oldlty)
    (setq zz nil)

    (command "script" (strcat powdesign_path "autocopy"))

   (setvar "cmdecho" 1)
)

(defun pipscrew_ok()
   (setq size_id (get_tile "size"))
   (setq parpip (get_tile "parpip"))
   (setq ltype_id (get_tile "sl"))
   (cond
     ((= "" size_id) (set_tile "error" "未選擇標稱!"))
     ((null view_id) (set_tile "error" "未選擇視圖!"))
     (T
       (setq sizedata (nth (atoi size_id) data_list))
       (setq do (nth 1 sizedata)
             di (nth 2 sizedata))
       (if (= "1" parpip) (setq screw_l (atof (nth 5 sizedata)))(setq screw_l (atof (nth 4 sizedata))))
       (if (= "1" ltype_id) (setq ltype 1) (setq ltype 0))
       (done_dialog)
       (setq pipscrew_flag t)
     );t
   );cond

);defun

(defun get_size_data()
   (setq size_id (get_tile "size"))
   (setq sizedata (nth (atoi size_id) data_list))
   (setq par_l (nth 5 sizedata))
   (setq tap_l (nth 4 sizedata))
;("標  稱"   "(外)外徑(內)根徑"  "(外)根徑(內)內徑"  "平行有效內螺紋長度" "推拔有效內螺紋長度" "有效外螺紋長度")
   (set_tile "parpip_size" par_l)
   (set_tile "tappip_size" tap_l)
)

(defun get_pipscrew_list()
  (setq data_list '() size_list '())
  (setq ff (open (strcat POWDESIGN_DATA_path "pipscrew.dat") "r"))

  (setq data (read-line ff)
        data (read-line ff))
  (while data
      (setq size_list (cons (nth 0 (read data)) size_list))
      (setq data_list (cons (read data) data_list) data (read-line ff))
  )(close ff)
  (setq size_list (reverse size_list))
  (setq data_list (reverse data_list))
)
