;;;
;;畫環形圓
;;設定新圓點
;;寫出座標(x,y),寫出座標(x/y)
;;X-Y 圓
;;距離-角度 圓
;;等角度畫圓
;;矩行 3e
;;矩行 srect
;;矩行 srect1
;;矩行 crect
;;矩行 mrect
;;連續截斷交差點 mbrl
;;圓形被前景遮住 cirhi
;;線段被前景遮住 1hid
;;延伸線段 ext
;;圓角輔助標註圖形 co
;;連續原點截斷 mbreak
;;軸外形 sha
;;軸外形 ho
;;軸剖面 ho2
;;軸剖面 ho1
;;詳圖指標 sec4
;;詳圖文字 sec3
;;剖面文字 sec2
;;剖面     sec1
;;連續剖面 sec5
;;詳圖指標( ? 矢視圖 )sec6
;;同心圓 MCIR
;;輔助畫三視圖
;;圓中心線
;;軸中心線
;;精準孔符號
;;============================================================================================

(defun c:holemark(/ curcolor curltype ent e la r cenp)
   (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (getoldvar)
   (setq curcolor (getvar "cecolor"))
   (setq curltype (getvar "celtype"))
   (setq ent (entsel "\n選擇精準孔:"))

   (if (= (setq wucs (getvar "worlducs")) 0)
       (progn
            (setq ucsorg (getvar "ucsorg"))
            (command "ucs" "w")
      );progn
   );if

   (while ent
      (setq e (entget (car ent)))
      (setq ent (cdr (assoc 0 e)))
      (if (/= "CIRCLE" ent)
        (princ "\n您選的圖元不是 CIRCLE !")
        (progn
          (setq la (cdr (assoc 8 e)))
          (setq r (cdr (assoc 40 e)))
          (setq cenp  (cdr (assoc 10 e)))
          (setvar "osmode" 0)
          (command "layer" "s" la "")
          (command "insert" (strcat POWDESIGN_dwg_path "holemark") cenp (* 2 r) (* 2 r) "0")
          (cond
            ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
            ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
            (T (command "color" (atoi curcolor)))
          );cond
        );progn
      );if
      (setq ent (entsel "\n選擇精準孔:"))
   );while
   (retoldvar)
   (if (= wucs 0)
       (command "ucs" "n" ucsorg)
   );if  
   (SETQ FFF nil))
   (setvar "cmdecho" 1)
   (princ)
)

;;軸中心線
(defun c:cen1(/ ppss_v selmode oker ORTHOMODE_v)
   (setvar "cmdecho" 0)
   (setq ppss_v nil)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (getoldvar)
   (setq curcolor (getvar "cecolor"))
   (setq curltype (getvar "celtype"))
   (setq ent (entsel "請選擇要畫中心線的圖元:"))
   (if (/= nil ent)
     (progn
          (setq la (cdr (assoc 8 (entget (car ent)))))
          (setq p1 (getpoint "\n第一點 :")
                p2 (getpoint p1 "\n第二點 :"))

          (if (null exts)
             (setq ext (* 3 (getvar "dimscale")))
             (setq ext exts))
          (setq selmode 0)
          (setq oker  0)                                                     
          (actdcl (strcat Powdesign_DCL_PATH "cen2") "cen2")
          (action_tile "gin"      "(setq selmode 0)")
          (action_tile "sch"      "(setq selmode 1)")
          (action_tile "accept"   "(setq oker 1)(done_dialog)")
          (action_tile "cancel"   "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
          (start_dialog)
          (if (= oker 0)
              (exit)
          );if  
          (if (and (= oker 1)
                   (= selmode 0) 
              );and
              (setq exts (getdist (strcat "延伸距離<"(rtos ext 2 2)">: ")))
         );if
         (if (and (= oker 1)
                  (= selmode 1) 
             );and
            (progn
                 (setq ORTHOMODE_v (getvar "ORTHOMODE"))
                 (setvar "ORTHOMODE" 1)
                 (setq exts (getdist p2  "拉伸距離"))
                 (setvar "ORTHOMODE" ORTHOMODE_v)
                 
            );progn      
         );if
         ;(setq exts (getdist (strcat "延伸距離<"(rtos ext 2 2)">: ")))
         (if (= exts nil) (setq exts ext))
         (if (= ppss nil)
             (progn
                  (setq ppss_v ppss)
                  (setq ppss 0)
             );progn
         );if  
         (setq ang (angle p1 p2)
               p3  (polar p1 (+ pi ang ppss) exts)
               p4  (polar p2 ang exts))
         (setq osmod (getvar "osmode"))
         (c:&cl&)
         (setvar "osmode" 0)

         (command "layer" "s" la "")
         (command "line" p3 p4 "")
         (command "linetype" "s" curltype "")
;        (if (= curcolor "BYLAYER") (command "color" curcolor) (command "color" (atoi curcolor)))

         (cond
           ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
           ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
           (T (command "color" (atoi curcolor)))
         )
        (setvar "osmode" osmod)
        (retoldvar)
     )
     (princ "\n未選到任何圖元!")
   )
   (SETQ FFF nil))
   (setvar "cmdecho" 1)
   (setq  ppss ppss_v)
   (princ)
)

;;圓中心線
(defun getoldvar() (setq oldosvar (getvar "osmode")
                         oldcovar (getvar "cecolor")
                         oldlavar (getvar "clayer")))
(defun retoldvar() (setvar "osmode" oldosvar)(setvar "cecolor" oldcovar)
                                             (setvar "clayer" oldlavar))
(defun c:cen2(/ selmode oker cp1 c_rad *error*)
   (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
	(defun *error*(msg);
	  	(retoldvar);
	  	(princ msg);2002.05.30 SAM
	)		   ;
   (getoldvar)
   (setq curcolor (getvar "cecolor"))
   (setq curltype (getvar "celtype"))
   (setq cen (getvar "dimcen"))
   (setq ent (entsel "\n選擇圓或弧 :"))

   (if (null exts)
      (setq ext (* 3 (getvar "dimscale")))
      (setq ext exts))
   (setq selmode 0)
   (setq oker  0)                                                    
   (actdcl (strcat Powdesign_DCL_PATH "cen2") "cen2")
   (action_tile "gin"      "(setq selmode 0)")
   (action_tile "sch"      "(setq selmode 1)")
   (action_tile "accept"   "(setq oker 1)(done_dialog)")
   (action_tile "cancel"   "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
   (start_dialog)
   (if (or (= oker 0)
           (= ent nil)
       )
       (exit)
   );if  
   (if (and (= oker 1)
            (= selmode 0) 
       );and
       (setq exts (getdist (strcat "延伸距離<"(rtos ext 2 2)">: ")))
   );if
   (if (and (= oker 1)
            (= selmode 1) 
       );and
       (progn
            (setq cp1 (cdr (assoc 10 (entget (car ent)))))
            (setq c_rad (cdr (assoc 40 (entget (car ent)))))
            (setq exts (getdist cp1  "拉伸距離"))
            (setq exts (- exts c_rad))
        );progn  
   );if
   (if (= exts nil) (setq exts ext))
   (if (= (setq wucs (getvar "worlducs")) 0)
       (progn
            (setq ucsorg (getvar "ucsorg"))
            (command "ucs" "w")
      );progn
   );if  

(c:&cl&)
(setvar "osmode" 0)						    
(while (/= nil ent)
       (setq e (entget (car ent)))
       (setq la (cdr (assoc 8 e)))
       (setq r (cdr (assoc 40 e))) 
       (setq p1 (cdr (assoc 10 e)))
       (setq pu (polar p1 (* pi 0.5) (+ r exts))
             pd (polar p1 (- (* pi 0.5)) (+ r exts))
             pl (polar p1 pi (+ r exts))
             pr (polar p1 0 (+ r exts))
       )
       (command "layer" "s" la "") 
       (command "line" pl pr "")
       (command "line" pu pd "")
       (setq ent (entsel "\n選擇圓或弧 :"))
);while SAM 2003.04.30
   (command "linetype" "s" curltype "")
   (cond
     ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
     ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
     (T (command "color" (atoi curcolor)))
   )

   (SETQ FFF nil))(retoldvar)
   (if (= wucs 0)
       (command "ucs" "n" ucsorg)
   );if  
   (setvar "cmdecho" 1)
   (princ)
)

;;輔助畫三視圖
(defun c:stock(/ a b c d p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16 p17)
(setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
(command "vslide" (strcat POWDESIGN_sld_path "stocksld"))
(setq A(getdist "\n輸入長度值: "))
(setq B(getdist "\n輸入寬度值: "))
(setq C(getdist "\n輸入厚度值: "))
(setq D(getdist "\n輸入間距值: "))
(redraw)
(setq P1(getpoint "\n選擇中心點: "))
(setq oldosmode (getvar "osmode"))
(setvar "osmode" 0)
(setq P2(list (- (car p1) (/ a 2)) (- (cadr p1) (/ b 2))))
(setq P3(list (+ (car p2) a) (cadr p2)))
(setq P4(list (car p3) (+ (cadr p2) b)))
(setq P5(list (+ (car p3) d) (cadr p2)))
(setq P6(list (+ (car p5) c) (cadr p5)))
(setq P7(list (car p6) (cadr p4)))
(setq P8(list (car p5) (cadr p4)))
(setq P9(list (car p2) (- (cadr p2) d)))
(setq P10(list (car p9) (- (cadr p9) c)))
(setq P11(list (car p3) (cadr p10)))
(setq P12(list (car p11) (cadr p9)))
(setq P13(list (car p2) (cadr p4)))
(setq p14 (polar p12 0 d))
(setq p15 (polar p11 0 d))
(setq p16 (polar p14 0 b))
(setq p17 (polar p15 0 b))

(command "line" p2 p3 p4 p13 "c")
(command "line" p5 p6 p7 p8 "c")
(command "line" p9 p10 p11 p12 "c")
(command "line" p14 p15 p17 p16 "c")
(setvar "osmode" oldosmode)
(setvar "cmdecho" 1)
(SETQ FFF nil))
(princ)
)

;;同心圓 MCIR
(defun c:mcir(/ y p p1 p2 p3 p4 p5 p102 p103 p104 p105 flag d lt)
  (setvar "cmdecho" 0)
  (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (setq Y (getvar "viewsize"))
  (setq p1 (getpoint "\n選擇中心點: "))
  (setq p3 (polar p1 (* pi 0.25) (/ Y 22))
        p2 (polar p1 (+ (* pi 0.25) pi) (/ Y 22))
        p4 (polar p1 (* pi 0.75) (/ Y 22))
        p5 (polar p1 (- (* pi 0.25)) (/ Y 22))
  )
  (setq flag t)
  (while flag
     (setq flag1 t)
     (C:&SL&)
     (setq d (getdist P1 "\n輸入半徑: " ))
     (if d
       (progn
         (setq d (* 2 d))
         (if (= d nil)
            (progn
               (setq flag nil)
               (setq flag1 nil)
            )
         )
         (while flag1
            (prompt "\n******* 線型  ==> SL(連續線),DL(虛線),CL(中心線) or SS(選取圖元線型) ******* ")
            (setq LT (strcase (getstring "\n輸入線型 <SL>: ")))
            (if (or (= LT "SL") (= LT ""))
              (c:&sl&)
              (progn
                 (cond
                   ((= LT "DL") (c:&dl&))
                   ((= LT "CL") (c:&cl&))
                   ((= LT "SS")
                    (setq selent nil)
                    (while (null selent)
                           (setq selent(entsel "\n選取圖元 : "))
                    );while
                    (if (assoc 6 (entget (car selent)))
                        (setq curlinetype (cdr(assoc 6 (entget (car selent)))) curlinecolor (cdr(assoc 62 (entget (car selent)))))
                        (setq curlinetype "bylayer" curlinecolor (cdr(assoc 62 (entget (car selent)))))
                    );if
                    (ch_lt_c curlinetype curlinecolor)
                   )
                 )
              )
            )
            (command "circle" p1 "d" D)
            (setq flag1 nil)
         )
       );progn
       (setq flag nil)
     );if
  )
  (setvar "cmdecho" 1)
  (SETQ FFF nil))
  (princ)
)

;;連續剖面 sec5
(defun diff()
  (setq sscc (getvar "dimscale"))
  (setq c2 (* sscc 2)
        c4 (* sscc 4)
        c6 (* sscc 6)
        c8 (* sscc 0.8)
        c1 (* sscc 8));setq
              (setq a1 (polar sm1 (+ ang1 (* pi 0.5)) c4)
                    a2 (polar sm1 (+ ang1 (* pi 0.5)) c1)
                    t2 (polar a2 (+ ang1 (* pi 0.5)) c4))
              (command "pline" sm1 "w" "0" c2 a1 "w" c8 c8 a2 "")(setq ent1 (entlast))
              (command "chprop" (entlast) "" "c" "bylayer" "")
              (c:&d&)
              (command "text" "m"  t2 (* sscc 4.5) "0" name)(setq ent2 (entlast))
              (princ "\n箭頭在哪一邊 ? ")
              (command "mirror" ent1 ent2 "" sm1 pause "y")
)
(defun c:sec5(/ y min max minl maxr name p p1 p2 pp1 pp2 pp3 pp4 pp5 ang1 ang2  ent1 ent2 ent3 ent4
                sp1 sp2 lin1 flag pp 2c 4c 5c 6c 7c 8c 1c *error*)
  (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setq olderr *error*)
   (defun *error* (msg)
      (princ msg)
      (setvar "osmode" os)
      (setvar "orthomode" oldorthomode)
      (setvar "mirrtext" mit)
      (c:&sl&)
      (redraw)
      (setq *error* olderr)
     (setvar "clayer" oldlayer)
   )
    (setq os (getvar "osmode"))
    (setq oldlayer (getvar "clayer"))
    (setq oldorthomode (getvar "orthomode"))
    (setq mit (getvar "mirrtext"))
    (setvar "osmode" 0)
    (setvar "orthomode" 1)
    (setvar "mirrtext" 0)
  (setq Y (getvar "viewsize"))
  (setq sscc (getvar "dimscale"))
  (setq 2c (* sscc 2)
        4c (* sscc 4)
        5c (* sscc 5)
        6c (* sscc 6)
        7c (* sscc 7)
        8c (* sscc 0.8)
        1c (* sscc 10));setq
  (setq min (getvar "limmin")
        max (getvar "limmax")
        minl (polar min 0 10)
        maxr (polar max pi 10))
  (setq name (strcase (getstring "\n輸入剖面名稱: ")))
  (setq p (getpoint "\n從哪一點 ? "))
  (setq p2 (getpoint p "\n到哪一點 ? "))
  (setq ang1 (angle p p2))
  (setq p1 (polar p (+ ang1 (- pi)) 4c))
  (setq sp1 (polar p1 (+ ang1 (- pi)) sscc))
  (setq sp2 (polar sp1 (+ ang1 (- pi)) 5c))
  (setq sm1 (polar sp1 (+ ang1 (- pi)) (* 2.5 sscc)))
  (C:&D&)
  (c:&sl&)
  (command "pline" sp2 "w" 8c 8c sp1 "")
  (command "chprop" (entlast) "" "c" "bylayer" "")
  (c:&pl&)
  (command "line" p1 p2 "")
  (setq lin1 (entlast))
  (c:&sl&)
  (diff)
  (setq flag t)
  (while flag
     (setq pp (getpoint p2 "\n到哪一點 ? "))
     (if (= pp nil)
        (progn
           (setq pp5 (polar p2 ang1 4c))
           (entdel lin1)
           (c:&pl&)
           (command "line" pp4 pp5 "")
           (setq sp1 (polar pp5 ang1 sscc))
           (setq sp2 (polar pp5 ang1 6c))
           (setq sm1 (polar pp5 ang1 (* 3.5 sscc)))
           (c:&sl&)
           (command "pline" sp2 "w" 8c 8c sp1 "")
           (command "chprop" (entlast) "" "c" "bylayer" "")
           (diff)
           (setq flag nil)
        )
        (progn
           (entdel lin1)
           (setq pp1 (polar p2 (+ ang1 (- pi)) (* 4 sscc))
                 pp2 (polar p2 (+ ang1 (- pi)) (* 3 sscc))
                 ang2 (angle p2 pp))
           (setq pp3 (polar p2 ang2 (* 3 sscc)))
           (setq pp4 (polar p2 ang2  (* 4 sscc)))
           (c:&pl&)
           (command "line" p1 pp1 "")
           (c:&sl&)
           (command "pline" pp2 "w" 8c 8c p2 pp3 "")
           (command "chprop" (entlast) "" "c" "bylayer" "")
           (c:&pl&)
           (command "line" pp4 pp "")
           (setq p2 pp)
           (setq ang1 ang2)
           (setq p1 pp4)
           (setq lin1 (entlast))
           (setq flag T) 
       ))
  )
  (setq *error* olderr)
  (SETQ FFF nil))
     (setvar "osmode" os)
     (setvar "cmdecho" 1)
     (setvar "plinewid" 0)
     (setvar "mirrtext" mit)
     (setvar "clayer" oldlayer)
  (princ)
)



;;剖面
;(defun c:sec1(/ y min max min1 maxr name p1 p2 ang1 sp1 sp2 sm1 p103 dis ent1 ent2 ent3 ent4
;p102 p104 p105 p106 p107 ep1 ep2 em1 p111 p112 p113 p108 p109 p110 1c 5c 7c
;int1 int2 angint angp a1 a2 a3 a4 t2 t4 a4 a6 a7 a8 t6 t8 os sscc 2c 4c 6c 8c)
(defun c:sec1()

   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)

    (setq olderr *error*)
  (defun *error* (msg)
     (setvar "clayer" oldlayer)
     (setvar "osmode" os)
     (setvar "mirrtext" mit)
     (c:&sl&)
     (REDRAW)
     (setq *error* olderr)
     (prin1)
  )
  (setvar "cmdecho" 0)
  (setq min (getvar "limmin")
        max (getvar "limmax")
        minl (polar min 0 10)
        maxr (polar max pi 10))
  (setq oldlayer (getvar "clayer"))
  (setq os (getvar "osmode"))
  (setq mit (getvar "mirrtext"))
  (setq sscc (getvar "dimscale"))
  (setq oldorthomode (getvar "orthomode"))
  (setvar "orthomode" 1)
  (setq 2c (* sscc 2)
        4c (* sscc 4)
        5c (* sscc 5)
        6c (* sscc 6)
        7c (* sscc 7)
        8c (* sscc 0.8)
        c8 (* sscc 8)
        1c (* sscc 8));setq
  (setq name (strcase (getstring "\n輸入剖面名稱: ")))
  (setq p1 (getpoint "\n從哪一點 ? "))
  (setq p2 (getpoint p1 "\n到哪一點 ? "))
  (setvar "osmode" 0)
  (setvar "mirrtext" 0)
  (if (> (car p1) (car p2)) (setq angt (angtos(angle p2 p1) 0 4))(setq angt (angtos(angle p1 p2) 0 4)))
  (if (> (cadr p1) (cadr p2)) (setq ori p1 p1 p2 p2 ori))
  (setq ang1 (angle p1 p2))
  (setq sp1 (polar p1 (+ ang1 (- pi)) sscc))
  (setq sp2 (polar sp1 (+ ang1 (- pi)) 5c))

  (setq sm1 (polar sp1 (+ ang1 (- pi)) (* sscc 2.5)))

  (setq ep1 (polar p2 ang1 sscc))
  (setq ep2 (polar EP1 ang1 5c))

  (setq dis (distance sp1 sp2)
        dis (/ dis 2))
  (setq em1 (polar ep1 ang1 dis))
  (c:&d&)
  (c:&sl&)
  (command "pline" sp2 "w" 8c 8c sp1 "")
  (command "chprop" (entlast) "" "c" "bylayer" "")
  (c:&pl&)
  (command "line" p1 p2 "")
  (c:&sl&)
  (command "pline" ep2 "w" 8c 8c ep1 "")
  (command "chprop" (entlast) "" "c" "bylayer" "")
  (if (or (= ang1 0) (= ang1 pi))
     (progn
        (if (> (cadr sm1) (cadr p1))
           (progn
              (setq a1 (polar sm1 (+ ang1 (* pi 0.5)) 4c)
                    a3 (polar em1 (+ ang1 (* pi 0.5)) 4c)
                    a2 (polar sm1 (+ ang1 (* pi 0.5)) 1c)
                    a4 (polar em1 (+ ang1 (* pi 0.5)) 1c)
                    t2 (polar a2 (+ ang1 (* pi 0.5)) 4c)
                    t4 (polar a4 (+ ang1 (* pi 0.5)) 4c))
              (command "pline" sm1 "w" "0" 2c a1 "w" 8c 8c a2 "")(setq ent3 (entlast))
              (command "pline" em1 "w" "0" 2c a3 "w" 8c 8c a4 "")(setq ent4 (entlast))
              (command "chprop" ent3 ent4 "" "c" "bylayer" "")
              (c:&d&)
              (command "text" "m" t2 4c "0" name)(setq ent1 (entlast))
              (command "text" "m" t4 4c "0" name)       (setq ent2 (entlast))
           )
           (progn
              (setq a5 (polar sm1 (+ ang1 (- (* pi 0.5))) 4c)
                    a7 (polar em1 (+ ang1 (- (* pi 0.5))) 4c)
                    a6 (polar sm1 (+ ang1 (- (* pi 0.5))) 1c)
                    a8 (polar em1 (+ ang1 (- (* pi 0.5))) 1c)
                    t6 (polar a6 (+ ang1 (- (* pi 0.5))) 4c)
                    t8 (polar a8 (+ ang1 (- (* pi 0.5))) 4c))
              (command "pline" sm1 "w" "0" 2c a5 "w" 8c 8c a6 "")(setq ent3 (entlast))
              (command "pline" em1 "w" "0" 2c a7 "w" 8c 8c a8 "")(setq ent4 (entlast))
              (command "chprop" ent3 ent4 "" "c" "bylayer" "")
              (c:&d&)
              (command "text" "m" t6 4c "0" name)(setq ent1 (entlast))
              (command "text" "m" t8 4c "0" name)       (setq ent2 (entlast))
           )
        )
     )
     (progn
        (princ 2)
        (setq int1 (inters p1 p2 min minl nil)
              int2 (inters p1 p2 max maxr nil)
              angint (angle int1 int2)
              angp (angle int1 sm1))
        (if (and (> angp angint) (/= angint nil))
          (progn
            (setq a5 (polar sm1 (+ ang1 (* pi 0.5)) 4c)
                  a7 (polar em1 (+ ang1 (* pi 0.5)) 4c)
                  a6 (polar sm1 (+ ang1 (* pi 0.5)) 1c)
                  a8 (polar em1 (+ ang1 (* pi 0.5)) 1c)
                  t6 (polar a6 (+ ang1 (* pi 0.5)) 4c)
                  t8 (polar a8 (+ ang1 (* pi 0.5)) 4c))
            (command "pline" sm1 "w" "0" 2c a5 "w" 8c 8c a6 "")(setq ent3 (entlast))
            (command "pline" em1 "w" "0" 2c a7 "w" 8c 8c a8 "")(setq ent4 (entlast))
            (command "chprop" ent3 ent4 "" "c" "bylayer" "")
            (c:&d&)
            (command "text" "m" t6 4c "0" name)(setq ent1 (entlast))
            (command "text" "m" t8 4c "0" name)       (setq ent2 (entlast))
         ;   (command "exit" "text" "m" t6 4c angt name)(setq ent1 (entlast))
         ;   (command "text" "m" t8 4c angt name)       (setq ent2 (entlast))
          )
          (progn
            (setq a1 (polar sm1 (+ ang1 (- (* pi 0.5))) 4c)
                  a3 (polar em1 (+ ang1 (- (* pi 0.5))) 4c)
                  a2 (polar sm1 (+ ang1 (- (* pi 0.5))) 1c)
                  a4 (polar em1 (+ ang1 (- (* pi 0.5))) 1c)
                  t2 (polar a2 (+ ang1 (- (* pi 0.5))) 4c)
                  t4 (polar a4 (+ ang1 (- (* pi 0.5))) 4c))
            (command "pline" sm1 "w" "0" 2c a1 "w" 8c 8c a2 "") (setq ent3 (entlast))
            (command "pline" em1 "w" "0" 2c a3 "w" 8c 8c a4 "") (setq ent4 (entlast))
            (command "chprop" ent3 ent4 "" "c" "bylayer" "")
            (c:&d&)
            (command "text" "m" t2 4c "0" name)        (setq ent1 (entlast))
            (command "text" "m" t4 4c "0" name)               (setq ent2 (entlast))
        ;    (command "exit" "text" "m" t2 4c angt name)        (setq ent1 (entlast))
        ;    (command "text" "m" t4 4c angt name)               (setq ent2 (entlast))
          )
        )
     )
  )
  (princ "\n箭頭在哪一邊 ? ")
  (command "mirror" ent1 ent2 ent3 ent4 "" (polar p1 (angle p1 p2) (* 0.5 (distance p1 p2))) pause "y")
;  (command "mirror" ent1 ent2 ent3 ent4 "" sm1 pause "y")
  (setq *error* olderr)
  (SETQ FFF nil))
  (setvar "clayer" oldlayer)
  (setvar "osmode" os)
  (setvar "plinewid" 0)
  (setvar "mirrtext" mit)
  (setvar "cmdecho" 1)
  (princ)
)

;;剖面文字 sec2
(defun c:sec2(/ name p1)
  (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (setq sss (getvar "dimscale"))
  (setvar "attdia" 0)
  (setq name (strcase (getstring "\n輸入剖面名稱: ")))
  (setq p1 (getpoint "\n選擇插入點: "))
  (if (= acad_ver "GENIUS")
      (command ".insert" (strcat POWDESIGN_dwg_path "a-asec") p1 sss sss "0" name name)
      (command "insert" (strcat POWDESIGN_dwg_path "a-asec") p1 sss sss "0" name name)
  )
  (setvar "attdia" 1)
  (setvar "cmdecho" 1)
  (SETQ FFF nil))
  (princ)
)


;;詳圖文字
(defun c:sec3(/ name p1)
  (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (setq sss (getvar "dimscale"))
  (setvar "attdia" 0)
  (setq name (strcase (getstring "\n輸入剖面名稱: ")))
  (setq p1 (getpoint "\n選擇插入點: "))
  (if (= acad_ver "GENIUS")
      (command ".insert" (strcat POWDESIGN_dwg_path "sec3") p1 sss sss "0" name)
      (command "insert" (strcat POWDESIGN_dwg_path "sec3") p1 sss sss "0" name)
  )
  (setvar "attdia" 1)
  (SETQ FFF nil))
  (setvar "cmdecho" 1)
  (princ)
)

;詳圖指標
(defun c:sec4(/ ssc name y p1 p102 p103 p104 p105 ang wb wh wbb whh ph ww)
  (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (setq ssc (getvar "dimscale"))
  (setq name (strcase (getstring "\n輸入英文名稱: ")))
; (setq Y (getvar "viewsize"))
  (setq p1 (getpoint "\n輸入插入點: "))
; (setq p103 (polar p1 (* pi 0.25) (/ Y 22))
;       p102 (polar p1 (+ (* pi 0.25) pi) (/ Y 22))
;       p104 (polar p1 (* pi 0.75) (/ Y 22))
;       p105 (polar p1 (- (* pi 0.25)) (/ Y 22))
; )
; (grdraw p102 p103 12)
; (grdraw p104 p105 12)
  (setq ang (getangle p1 "\n輸入旋轉角度 <0>: "))
  (if (or (= ang nil) (= ang 0)) (setq ang 0))
  (setq wb (* ssc 2)
        wh (* ssc 6)
        wbb (* ssc 0.6)
        whh (* ssc 10)
        ph (* ssc 15)
        ww (* ssc 5));setq
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
; (command "pline" p1 "w" "0" wb (polar p1 ang 6) "w" wbb "" (polar p1 ang 10) "")
  (command "pline" p1 "w" "0" wb (polar p1 ang wh ) "w" wbb "" (polar p1 ang whh) "")
; (command "text" "m" (polar p1 ang 15) "5" 0 name)
  (command "text" "m" (polar p1 ang ph) ww 0 name)
  (setvar "osmode" oldosmode)
; (grdraw p102 p103 0)
; (grdraw p104 p105 0)
   (SETQ FFF nil))
  (setvar "cmdecho" 1)
  (setvar "plinewid" 0)
  (princ)
)


;詳圖指標( ? 矢視圖 )
(defun c:sec6(/ ssc name y p1 p102 p103 p104 p105 ang wb wh wbb whh ph ww)
  (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (setq ssc (getvar "dimscale"))
  (setq name (strcase (getstring "\n輸入英文名稱: ")))
  (setq p1 (getpoint "\n輸入插入點: "))
  (setq ang (getangle p1 "\n輸入旋轉角度 <0>: "))
  (if (>= ang (* 2.0 pi))(setq ang (- ang pi pi)))
  (if (or (= ang nil) (= ang 0)) (setq ang 0))
  (setq wb (* ssc 2)
        wh (* ssc 6)
        wbb (* ssc 0.6)
        whh (* ssc 10)
        ph (* ssc 15)
        ww (* ssc 5));setq
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
  (command "pline" p1 "w" "0" wb (polar p1 ang wh ) "w" wbb "" (polar p1 ang whh) "")
  (if (and (> ang (* 0.5 pi)) (< ang (* 1.5 pi)))
      (command "text" "mr" (polar p1 ang ph) ww (+ 180.0 (* 180.0 (/ ang pi))) (strcat name "矢視圖"))
      (command "text" "ml" (polar p1 ang ph) ww (* 180.0 (/ ang pi)) (strcat name "矢視圖"))
  );if
  (setvar "osmode" oldosmode)
   (SETQ FFF nil))
  (setvar "cmdecho" 1)
  (setvar "plinewid" 0)
  (princ)
)

(defun te_err_ho(msg)
   (if (/= msg "Function cancelled")(princ (strcat "\nError: " msg)))
   (if oerr (setq *error* oerr))
   (setvar "cecolor" ccolor)
   (setvar "celtype" cltype)
   (setvar "osmode" oldosmode)
   (princ)
)

;;軸剖面 ho1
(defun c:ho1(/ y p p1 p2 p3 p4 p5 p102 p103 p104 p105 ang l ds de2 1st_flag cens cene $p $p4 $p5 $p102 $p103 $p104 $p105)
   (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))
   (WHILE (/= FFF nil)
          (setq ppss sspp
                ccolor (getvar "cecolor")
                cltype (getvar "celtype")
                $p4 nil $p5 nil $p102 nil $p103 nil $p104 nil $p105 nil $p nil
          );setq
          (setq oerr *error* *error* te_err_ho)
          (initget 0  "Yes No")
          (setq yesno (getkword "\n自動加入中心線<Yes>:"))
          (if (or (null yesno) (= yesno "Yes"))
              (progn
; ;;;;;;;      (if (null extdist) (setq indist (* 3 (getvar "dimscale"))))
               (setq indist (* 3 (getvar "dimscale")))
               (setq extdist (getdist (strcat "\n中心線突出於物體外緣<" (rtos indist 2 2) ">:")))
               (if (null extdist) (setq extdist indist)(setq indist extdist))
               (setq yesnofg t)
              )
              (setq yesnofg nil)
          )

          (setq Y (getvar "viewsize"))
          (setq p (getpoint "\n選擇階級孔起始點: ") cen1 p)
          (while (null p) (setq p (getpoint "\n資料未輸入! 請再選擇階孔桿起始點: ")))
          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                p104 (polar p (* pi 0.75) (/ Y 22))
                p105 (polar p (- (* pi 0.25)) (/ Y 22))
          )
          (grdraw p102 p103 12)
          (grdraw p104 p105 12)
          (setq ang (getangle p "\n輸入旋轉角度 <0>: "))
          (if (or (= ang nil) (= ang 0)) (setq ang 0))
          (setq L (getdist p "\n輸入階級孔第一段長度: "))
          (while (null L) (setq L (getdist "\n資料未輸入! 請再輸入階級孔第一段長度: ")))
          (setq DS (getdist "\n輸入階級孔第一段起始端直徑: "))
          (while (null DS) (setq DS (getdist "\n資料未輸入! 請再輸入階級孔第一段起始端直徑: ")))
          (initget "T") 
          (setq DE2 (getdist (strcat "\n輸入錐度 (按 T) \\ 階級孔第一段終止端直徑 <"(rtos DS 2 2)">:   ")))
     
          (if (= de2 "T")
              (setq de2 (trap_dir ds L))
          );if
     
          (setq linegrp (ssadd) DE DE2)
          (if (= DE2 nil) (setq DE2 DS))
          (setq oldosmode (getvar "osmode"))
          (setvar "osmode" 0)
          (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0))
                p1 (polar p ang L)
                p4 (polar p1 (+ (* pi 0.5) ang) (/ DE2 2.0))
                p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE2 2.0))
          )
          (command "line" p2 p4 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (command "line" p3 p5 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (setvar "osmode" oldosmode)
          (grdraw p102 p103 0)
          (grdraw p104 p105 0)

          (setq $p p p p1 $p102 p102 $p103 p103 $p104 p104 $p105 p105 1st_flag 1)
          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                p104 (polar p (* pi 0.75) (/ Y 22))
                p105 (polar p (- (* pi 0.25)) (/ Y 22))
          )
          (grdraw p102 p103 12)
          (grdraw p104 p105 12)
; ;;;;;;;  (setq L (getdist p "\n輸入階級孔長度: "))
          (while L

                (setq $DE2 DE2 $L L $DS DS $DE DE redo_flag 0);rex

                (initget "Undo")
                (setq L (getdist p "\n或輸入U消除上一段階級孔/輸入階級孔長度: "))
                (if (= "Undo" L)
                    (progn
                          (command "erase" linegrp "")
                          (grdraw p102 p103 0)
                          (grdraw p104 p105 0)
                          (setq $rp4 p4 $rp5 p5 $rp p $rde2 de2 $rp102 p102 $rp103 p103 $rp104 p104 $rp105 p105)
                          (setq p $p p4 $p4 p5 $p5 DE2 $de2 p102 $p102 p103 $p103 p104 $p104 p105 $p105)
                          (grdraw p102 p103 12)
                          (grdraw p104 p105 12)
                          (initget "Redo")
                          (setq L (getdist p "\n或輸入R救回上一段階級孔/輸入階級孔長度: "))
                          (if (= "Redo" L)
                              (progn
                                   (grdraw p102 p103 0)
                                   (grdraw p104 p105 0)
                                   (setq L $L DS $DS DE $DE DE2 $RDE2 redo_flag 1)
                              );progn
                              (setq redo_flag 0)
                          );if
                    );progn
                );if
                (if (and (/= "Undo" L) (/= "Redo" L) (/= nil L) (= 0 redo_flag))
                    (progn
                          (setq DS (getdist "\n輸入階級孔起始端直徑: "))
                          (while (null DS) (setq DS (getdist "\n資料未輸入! 請再輸入階級孔起始端直徑: ")))
                          (initget "T")
                          (setq DE (getdist (strcat "\n輸入錐度 (按 T) \\ 階級孔終止端直徑 <"(rtos DS 2 2)">: ")))
                          (if (= de "T")
                              (setq de (trap_dir ds L))
                          );if
                    );progn
                );if
                (if (and (/= "Undo" L) (/= nil L))
                    (progn
                          (setq linegrp (ssadd))
                          (if (= DE nil) (setq DE DS))
                          (if (< DS DE2)
                              (progn
                                 (setq oldosmode (getvar "osmode"))
                                 (setvar "osmode" 0)
                                 (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                                       p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0)))
                                 (if (and (/= p2 p4) (/= nil p4))
                                     (progn
                                         (command "line" p2 p4 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     )
                                 )
                                 (if (and (/= p3 p5) (/= nil p5))
                                     (progn
                                         (command "line" p3 p5 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     )
                                 );if
                                 (setq $p p $p4 p4 $p5 p5)
                                 (setq p1 (polar p ang L)
                                       p4 (polar p1 (+ (* pi 0.5) ang) (/ DE 2.0))
                                       p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE 2.0))
                                 )
                                 (command "line" p2 p4 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (command "line" p3 p5 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (setvar "osmode" oldosmode)
                              );progn
                          );if
                          (if (or (> DS DE2) (= DS DE2))
                              (progn
                                 (setq oldosmode (getvar "osmode"))
                                 (setvar "osmode" 0)
                                 (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                                       p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0)))
                                 (if (and (/= p2 p4) (/= nil p4))
                                     (progn
                                         (command "line" p2 p4 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     )
                                 )
                                 (if (and (/= p3 p5) (/= nil p5))
                                     (progn
                                         (command "line" p3 p5 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     )
                                 );if
                                 (setq $p p $p4 p4 $p5 p5)
                                 (setq p1 (polar p ang L)
                                       p4 (polar p1 (+ (* pi 0.5) ang) (/ DE 2.0))
                                       p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE 2.0))
                                 )
                                 (command "line" p2 p4 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (command "line" p3 p5 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (setvar "osmode" oldosmode)
                              );progn
                          );if
                        ;  (grdraw p102 p103 0)
                        ;  (grdraw p104 p105 0)
                          (redraw)

                          (setq p p1 $p102 p102 $p103 p103 $p104 p104 $p105 p105)

                          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                                p104 (polar p (* pi 0.75) (/ Y 22))
                                p105 (polar p (- (* pi 0.25)) (/ Y 22))
                          )
                          (grdraw p102 p103 12)
                          (grdraw p104 p105 12)
                          (setq DE2 DE)
                    );progn
                );if

; ;;;;;;;        (setq L (getdist p "\n輸入階級孔長度: "))
          );while
          (grdraw p102 p103 0)
          (grdraw p104 p105 0)

          (if yesnofg
              (progn
                  (c:&cl&)
                  (setvar "osmode" 0)
                  (setq cen2 (polar p4 (angle p4 p5) (* 0.5 (distance p4 p5))))
                  (setq cens (polar cen1 (angle cen2 cen1) extdist))
                  (setq cene (polar cen2 (angle cen1 cen2) extdist))
                  (command "line" cens cene "")
                  (setvar "cecolor" ccolor)
                  (setvar "celtype" cltype)
                  (setvar "osmode" oldosmode)
              )
          )
          (setvar "cmdecho" 1)
          (SETQ FFF nil)
   )
   (princ)
)


;;軸剖面
(defun c:ho2(/ y p p1 p2 p3 p4 p5 p102 p103 p104 p105 ang l ds de2 1st_flag cens cene $p $p4 $p5 $p102 $p103 $p104 $p105)
   (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))
   (WHILE (/= FFF nil)
          (setq ppss sspp
                ccolor (getvar "cecolor")
                cltype (getvar "celtype")
                $p4 nil $p5 nil $p102 nil $p103 nil $p104 nil $p105 nil $p nil 1st_flag 1
          );setq
          (setq oerr *error* *error* te_err_ho)

          (initget 0  "Yes No")
          (setq yesno (getkword "\n自動加入中心線<Yes>:"))
          (if (or (null yesno) (= yesno "Yes"))
            (progn
;            (if (null extdist) (setq indist (* 3 (getvar "dimscale"))))
             (setq indist (* 3 (getvar "dimscale")))
             (setq extdist (getdist (strcat "\n中心線突出於物體外緣<" (rtos indist 2 2) ">:")))
             (if (null extdist) (setq extdist indist)(setq indist extdist))
             (setq yesnofg t)
            )
             (setq yesnofg nil)
          )


          (setq Y (getvar "viewsize"))
          (setq p (getpoint "\n選擇階級孔起始點: ") cen1 p)
          (while (null p) (setq p (getpoint "\n資料未輸入! 請再選擇階級孔起始點: ")))
          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                p104 (polar p (* pi 0.75) (/ Y 22))
                p105 (polar p (- (* pi 0.25)) (/ Y 22))
          )
          (grdraw p102 p103 12)
          (grdraw p104 p105 12)
          (setq ang (getangle p "\n輸入旋轉角度 <0>: "))
          (if (or (= ang nil) (= ang 0)) (setq ang 0))
          (setq L (getdist p "\n輸入階級孔第一段長度: "))
          (while (null L) (setq L (getdist "\n資料未輸入! 請再輸入階級孔第一段長度: ")))
          (setq DS (getdist "\n輸入階級孔第一段起始端直徑: "))
          (while (null DS) (setq DS (getdist "\n資料未輸入! 請再輸入階級孔第一段起始端直徑: ")))
          (initget "T")
          (setq DE2 (getdist (strcat "\n輸入錐度 (按 T) \\ 階級孔第一段終止端直徑 <"(rtos DS 2 2)">: ")))
          (if (= de2 "T")
              (setq de2 (trap_dir ds L))
          );if
          (setq linegrp (ssadd) DE DE2)
          (if (= DE2 nil) (setq DE2 DS))
          (setq oldosmode (getvar "osmode"))
          (setvar "osmode" 0)
          (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0))
                p1 (polar p ang L)
                p4 (polar p1 (+ (* pi 0.5) ang) (/ DE2 2.0))
                p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE2 2.0))
          )
          (command "line" p2 p3 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (command "line" p2 p4 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (command "line" p3 p5 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (setvar "osmode" oldosmode)
          (grdraw p102 p103 0)
          (grdraw p104 p105 0)
          (setq $p p p p1 $p102 p102 $p103 p103 $p104 p104 $p105 p105 1st_flag 1)
          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                p104 (polar p (* pi 0.75) (/ Y 22))
                p105 (polar p (- (* pi 0.25)) (/ Y 22))
          )
          (grdraw p102 p103 12)
          (grdraw p104 p105 12)
;          (setq L (getdist p "\n輸入階級孔長度: "))
          (while L
                (setq $DE2 DE2 $L L $DS DS $DE DE redo_flag 0);rex

                (initget "Undo")
                (setq L (getdist p "\n或輸入U消除上一段階級孔/輸入階級孔長度: "))
                (if (= "Undo" L)
                    (progn
                          (command "erase" linegrp "")
                          (grdraw p102 p103 0)
                          (grdraw p104 p105 0)
                          (setq $rp4 p4 $rp5 p5 $rp p $rde2 de2 $rp102 p102 $rp103 p103 $rp104 p104 $rp105 p105)
                          (setq p $p p4 $p4 p5 $p5 DE2 $de2 p102 $p102 p103 $p103 p104 $p104 p105 $p105 1st_flag (- 1st_flag 1))
                          (grdraw p102 p103 12)
                          (grdraw p104 p105 12)
                          (initget "Redo")
                          (setq L (getdist p "\n或輸入R救回上一段階級孔/輸入階級孔長度: "))
                          (if (= "Redo" L)
                              (progn
                                   (grdraw p102 p103 0)
                                   (grdraw p104 p105 0)
                                   (setq L $L DS $DS DE $DE DE2 $RDE2 redo_flag 1 1st_flag (+ 1st_flag 1))
                              );progn
                              (setq redo_flag 0)
                          );if
                    );progn
                );if
                (if (and (/= "Undo" L) (/= "Redo" L) (/= nil L) (= 0 redo_flag))
                    (progn
                          (setq 1st_flag (+ 1st_flag 1))
                          (setq DS (getdist "\n輸入階級孔起始端直徑: "))
                          (while (null DS) (setq DS (getdist "\n資料未輸入! 請再輸入階級孔起始端直徑: ")))
                          (initget "T")
                          (setq DE (getdist (strcat "\n輸入錐度 (按 T) \\ 階級孔終止端直徑 <"(rtos DS 2 2)">: ")))
                      
                          (if (= de "T")
                              (setq de (trap_dir ds L))
                          );if
                    );progn
                );if
                (if (and (/= "Undo" L) (/= nil L))
                    (progn
                          (setq linegrp (ssadd))
                          (if (= DE nil) (setq DE DS))
                          (if (< DS DE2)
                            (progn
                                 (setq oldosmode (getvar "osmode"))
                                 (setvar "osmode" 0)
                                 (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                                       p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0)))
                                 (if (and (/= p2 p4) (/= nil p4))
                                     (progn
                                         (command "line" p2 p4 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     )
                                 )
                                 (if (and (/= p3 p5) (/= nil p5))
                                     (progn
                                         (command "line" p3 p5 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     )
                                 );if

                                 (if (= 1st_flag 1)
                                     (progn
                                         (command "line" p2 p3 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     );progn
                                 );if

                                 (setq $p p $p4 p4 $p5 p5)
                                 (setq p1 (polar p ang L)
                                       p4 (polar p1 (+ (* pi 0.5) ang) (/ DE 2.0))
                                       p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE 2.0))
                                 )
                                 (command "line" p2 p4 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (command "line" p3 p5 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (setvar "osmode" oldosmode)
                            );progn
                        )
                        (if (or (> DS DE2) (= DS DE2))
                            (progn
                                 (setq oldosmode (getvar "osmode"))
                                 (setvar "osmode" 0)
                                 (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                                       p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0)))
                                 (if (and (/= p2 p4) (/= nil p4))
                                     (progn
                                         (command "line" p2 p4 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     )
                                 )
                                 (if (and (/= p3 p5) (/= nil p5))
                                     (progn
                                         (command "line" p3 p5 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     )
                                 );if
                                 (if (= 1st_flag 1)
                                     (progn
                                         (command "line" p2 p3 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     );progn
                                 );if
                                 (setq $p p $p4 p4 $p5 p5)
                                 (setq p1 (polar p ang L)
                                       p4 (polar p1 (+ (* pi 0.5) ang) (/ DE 2.0))
                                       p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE 2.0))
                                 )
                                 (command "line" p2 p4 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (command "line" p3 p5 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (setvar "osmode" oldosmode)
                            );progn
                        );if
                       ; (grdraw p102 p103 0)
                       ; (grdraw p104 p105 0)
                        (redraw)

                        (setq p p1 $p102 p102 $p103 p103 $p104 p104 $p105 p105)

                        (setq p p1)
                        (setq p103 (polar p (* pi 0.25) (/ Y 22))
                              p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                              p104 (polar p (* pi 0.75) (/ Y 22))
                              p105 (polar p (- (* pi 0.25)) (/ Y 22))
                        )
                        (grdraw p102 p103 12)
                        (grdraw p104 p105 12)
                        (setq DE2 DE)
                    );progn
                );if
;                        (setq L (getdist p "\n輸入階級孔長度: "))
          )
          (command "line" p4 p5 "")
          (grdraw p102 p103 0)
          (grdraw p104 p105 0)

          (if yesnofg
            (progn
              (setvar "osmode" 0)
              (c:&cl&)
              (setq cen2 (polar p4 (angle p4 p5) (* 0.5 (distance p4 p5))))
              (setq cens (polar cen1 (angle cen2 cen1) extdist))
              (setq cene (polar cen2 (angle cen1 cen2) extdist))
              (command "line" cens cene "")
              (setvar "cecolor" ccolor)
              (setvar "celtype" cltype)
              (setvar "osmode" oldosmode)
            )
          )

          (SETQ FFF nil)
   );while
;   (setvar "cmdecho" 1)
   (princ)
)

;;軸外形
(defun c:ho(/ y p p1 p2 p3 p4 p5 p102 p103 p104 p105 ang l ds de2 1st_flag cens cene $p $p4 $p5 $p102 $p103 $p104 $p105)
   (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))
   (WHILE (/= FFF nil)
          (setq ppss sspp
                ccolor (getvar "cecolor")
                cltype (getvar "celtype")
                $p4 nil $p5 nil $p102 nil $p103 nil $p104 nil $p105 nil $p nil 1st_flag 1
          );setq
          (setq oerr *error* *error* te_err_ho)

          (initget 0  "Yes No")
          (setq yesno (getkword "\n自動加入中心線<Yes>:"))
          (if (or (null yesno) (= yesno "Yes"))
            (progn
;            (if (null extdist) (setq indist (* 3 (getvar "dimscale"))))
             (setq indist (* 3 (getvar "dimscale")))
             (setq extdist (getdist (strcat "\n中心線突出於物體外緣<" (rtos indist 2 2) ">:")))
             (if (null extdist) (setq extdist indist)(setq indist extdist))
             (setq yesnofg t)
            )
             (setq yesnofg nil)
          )


          (setq Y (getvar "viewsize"))
          (setq p (getpoint "\n選擇階級桿起始點: ") cen1 p)
          (while (null p) (setq p (getpoint "\n資料未輸入! 請再選擇階級桿起始點: ")))

          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                p104 (polar p (* pi 0.75) (/ Y 22))
                p105 (polar p (- (* pi 0.25)) (/ Y 22))
          )
          (grdraw p102 p103 12)
          (grdraw p104 p105 12)
          (setq ang (getangle p "\n輸入旋轉角度 <0>: "))
          (if (or (= ang nil) (= ang 0)) (setq ang 0))
          (setq L (getdist p "\n輸入階級桿第一段長度: "))
          (while (null L) (setq L (getdist "\n資料未輸入! 請再輸入階級桿第一段長度: ")))
          (setq DS (getdist "\n輸入階級桿第一段起始端直徑: "))
          (while (null DS) (setq DS (getdist "\n資料未輸入! 請再輸入階級桿第一段起始端直徑: ")))
          (initget "T")
          (setq DE2 (getdist (strcat "\n輸入錐度 (按 T) \\ 階級桿第一段終止端直徑 <"(rtos DS 2 2)">: ")))
          (if (= de2 "T")
              (setq de2 (trap_dir ds L))
          );if
          (setq linegrp (ssadd) DE DE2) ;rex
          (if (= DE2 nil) (setq DE2 DS))
          (setq oldosmode (getvar "osmode"))
          (setvar "osmode" 0)
          (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0))
                p1 (polar p ang L)
                p4 (polar p1 (+ (* pi 0.5) ang) (/ DE2 2.0))
                p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE2 2.0))
          )
          (command "line" p2 p4 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (command "line" p3 p5 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (setvar "osmode" oldosmode)
          (grdraw p102 p103 0)
          (grdraw p104 p105 0)

          (setq $p p p p1 $p102 p102 $p103 p103 $p104 p104 $p105 p105 1st_flag 1 $DE2 DE2)
          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                p104 (polar p (* pi 0.75) (/ Y 22))
                p105 (polar p (- (* pi 0.25)) (/ Y 22))
          )
          (grdraw p102 p103 12)
          (grdraw p104 p105 12)
;;          (setq L (getdist p "\n輸入階級桿長度: "))
          (while L
                (setq $L L $DS DS $DE DE redo_flag 0);rex

                (initget "Undo")
                (setq L (getdist p "\n或輸入U消除上一段階級孔/輸入階級孔長度: "))
                (if (= "Undo" L)
                    (progn
                          (command "erase" linegrp "")
                          (grdraw p102 p103 0)
                          (grdraw p104 p105 0)
                          (setq $rp4 p4 $rp5 p5 $rp p $rde2 de2 $rp102 p102 $rp103 p103 $rp104 p104 $rp105 p105)
                          (setq p $p p4 $p4 p5 $p5 DE2 $de2 p102 $p102 p103 $p103 p104 $p104 p105 $p105 1st_flag (- 1st_flag 1))
                          (grdraw p102 p103 12)
                          (grdraw p104 p105 12)
                          (initget "Redo")
                          (setq L (getdist p "\n或輸入R救回上一段階級孔/輸入階級孔長度: "))
                          (if (= "Redo" L)
                              (progn
                                   (grdraw p102 p103 0)
                                   (grdraw p104 p105 0)
                                   (setq L $L DS $DS DE $DE DE2 $DE2 redo_flag 1 1st_flag (+ 1st_flag 1))
                              );progn
                              (setq redo_flag 0)
                          );if
                    );progn
                );if
                (if (and (/= "Undo" L) (/= "Redo" L) (/= nil L) (= 0 redo_flag))
                    (progn
                          (setq 1st_flag (+ 1st_flag 1))
                          (setq DS (getdist "\n輸入階級孔起始端直徑: "))
                          (while (null DS) (setq DS (getdist "\n資料未輸入! 請再輸入階級孔起始端直徑: ")))
                          (initget "T")
                          (setq DE (getdist (strcat "\n輸入錐度 (按 T) \\ 階級孔終止端直徑 <"(rtos DS 2 2)">: ")))
                          (if (= de2 "T")
                              (setq de2 (trap_dir ds L))
                          );if
                    );progn
                );if
                (if (and (/= "Undo" L) (/= nil L))
                    (progn
                          (setq linegrp (ssadd))
                          (if (= DE nil) (setq DE DS))
                          (if (< DS DE2)
                              (progn
                                 (setq oldosmode (getvar "osmode"))
                                 (setvar "osmode" 0)
                                 (if (/= 1st_flag 1)
                                     (progn
                                         (command "line" p4 p5 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     );progn
                                 );if
                                 (setq $p p $p4 p4 $p5 p5)
                                 (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                                       p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0))
                                       p1 (polar p ang L)
                                       p4 (polar p1 (+ (* pi 0.5) ang) (/ DE 2.0))
                                       p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE 2.0))
                                 )
                                 (command "line" p2 p4 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (command "line" p3 p5 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (setvar "osmode" oldosmode)
                              );progn
                          );if
                          (if (or (> DS DE2) (= DS DE2))
                              (progn
                                 (setq oldosmode (getvar "osmode"))
                                 (setvar "osmode" 0)
                                 (setq $p p $p4 p4 $p5 p5)
                                 (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                                       p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0))
                                       p1 (polar p ang L)
                                       p4 (polar p1 (+ (* pi 0.5) ang) (/ DE 2.0))
                                       p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE 2.0))
                                 )
                                 (if (/= 1st_flag 1)
                                     (progn
                                         (command "line" p2 p3 "")
                                         (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                     );progn
                                 );if
                                 (command "line" p2 p4 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (command "line" p3 p5 "")
                                 (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                 (setvar "osmode" oldosmode)
                              );progn
                          );if
                         ; (grdraw p102 p103 0)
                         ; (grdraw p104 p105 0)
                          (redraw)
                          (setq p p1 $p102 p102 $p103 p103 $p104 p104 $p105 p105)

                          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                                p104 (polar p (* pi 0.75) (/ Y 22))
                                p105 (polar p (- (* pi 0.25)) (/ Y 22))
                          )
                          (grdraw p102 p103 12)
                          (grdraw p104 p105 12)

                          (setq $DE2 DE2 DE2 DE)
                    );progn
                );if
;;                          (setq L (getdist p "\n輸入階級桿長度: "))
          )
          (grdraw p102 p103 0)
          (grdraw p104 p105 0)


          (if yesnofg
            (progn
              (c:&cl&)
              (setvar "osmode" 0)
              (setq cen2 (polar p4 (angle p4 p5) (* 0.5 (distance p4 p5))))
              (setq cens (polar cen1 (angle cen2 cen1) extdist))
              (setq cene (polar cen2 (angle cen1 cen2) extdist))
              (command "line" cens cene "")
              (setvar "cecolor" ccolor)
              (setvar "celtype" cltype)
              (setvar "osmode" oldosmode)
            )
          )

          (setvar "cmdecho" 1)
          (SETQ FFF nil)
   )
   (princ)
)

;;軸外形
(defun c:sha(/ y p p1 p2 p3 p4 p5 p102 p103 p104 p105 ang l ds de2 1st_flag cens cene $p $p4 $p5 $p102 $p103 $p104 $p105)
   (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))
   (WHILE (/= FFF nil)
          (setq ppss sspp
                ccolor (getvar "cecolor")
                cltype (getvar "celtype")
                $p4 nil $p5 nil $p102 nil $p103 nil $p104 nil $p105 nil $p nil 1st_flag 1
          );setq
          (setq oerr *error* *error* te_err_ho)

          (initget 0  "Yes No")
          (setq yesno (getkword "\n自動加入中心線<Yes>:"))
          (if (or (null yesno) (= yesno "Yes"))
            (progn
;            (if (null extdist) (setq indist (* 3 (getvar "dimscale"))))
             (setq indist (* 3 (getvar "dimscale")))
             (setq extdist (getdist (strcat "\n中心線突出於物體外緣<" (rtos indist 2 2) ">:")))
             (if (null extdist) (setq extdist indist)(setq indist extdist))
             (setq yesnofg t)
            )
             (setq yesnofg nil)
          )

          (setq Y (getvar "viewsize"))
          (setq p (getpoint "\n選擇階級桿起始點: ") cen1 p)
          (while (null p) (setq p (getpoint "\n資料未輸入! 請再選擇階級桿起始點: ")))
          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                p104 (polar p (* pi 0.75) (/ Y 22))
                p105 (polar p (- (* pi 0.25)) (/ Y 22))
          )
          (grdraw p102 p103 12)
          (grdraw p104 p105 12)
          (setq ang (getangle p "\n輸入旋轉角度 <0>: "))
          (if (or (= ang nil) (= ang 0)) (setq ang 0))
          (setq L (getdist p "\n輸入階級桿第一段長度: "))
          (while (null L) (setq L (getdist "\n資料未輸入! 請再輸入階級桿第一段長度: ")))
          (setq DS (getdist "\n輸入階級桿第一段起始端直徑: "))
          (while (null DS) (setq DS (getdist "\n資料未輸入! 請再輸入階級桿第一段起始端直徑: ")))
          (initget "T")
          (setq DE2 (getdist (strcat "\n輸入錐度 (按 T) \\ 階級桿第一段終止端直徑  <"(rtos DS 2 2)">: ")))
          (if (= de2 "T")
              (setq de2 (trap_dir ds L))
          );if
          (setq linegrp (ssadd) DE DE2) ;rex
          (if (= DE2 nil) (setq DE2 DS))
          (setq oldosmode (getvar "osmode"))
          (setvar "osmode" 0)
          (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0))
                p1 (polar p ang L)
                p4 (polar p1 (+ (* pi 0.5) ang) (/ DE2 2.0))
                p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE2 2.0))
          )
          (command "line" p2 p3 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (command "line" p2 p4 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (command "line" p3 p5 "")
          (setq linegrp (ssadd (entlast) linegrp))     ;rex
          (setvar "osmode" oldosmode)
          (grdraw p102 p103 0)
          (grdraw p104 p105 0)

          (setq $p p p p1 $p102 p102 $p103 p103 $p104 p104 $p105 p105 1st_flag 1 $DE2 DE2)
          (setq p103 (polar p (* pi 0.25) (/ Y 22))
                p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                p104 (polar p (* pi 0.75) (/ Y 22))
                p105 (polar p (- (* pi 0.25)) (/ Y 22))
          )
          (grdraw p102 p103 12)
          (grdraw p104 p105 12)
;          (setq L (getdist p "\n輸入階級桿長度: "))
          (while L
                (setq $L L $DS DS $DE DE redo_flag 0);rex

                (initget "Undo")
                (setq L (getdist p "\n或輸入U消除上一段階級孔/輸入階級孔長度: "))
                (if (= "Undo" L)
                    (progn
                          (command "erase" linegrp "")
                          (grdraw p102 p103 0)
                          (grdraw p104 p105 0)
                          (setq $rp4 p4 $rp5 p5 $rp p $rde2 de2 $rp102 p102 $rp103 p103 $rp104 p104 $rp105 p105)
                          (setq p $p p4 $p4 p5 $p5 DE2 $de2 p102 $p102 p103 $p103 p104 $p104 p105 $p105 1st_flag (- 1st_flag 1))
                          (grdraw p102 p103 12)
                          (grdraw p104 p105 12)
                          (initget "Redo")
                          (setq L (getdist p "\n或輸入R救回上一段階級孔/輸入階級孔長度: "))
                          (if (= "Redo" L)
                              (progn
                                   (grdraw p102 p103 0)
                                   (grdraw p104 p105 0)
                                   (setq L $L DS $DS DE $DE DE2 $DE2 redo_flag 1 1st_flag (+ 1st_flag 1))
                              );progn
                              (setq redo_flag 0)
                          );if
                    );progn
                );if
                (if (and (/= "Undo" L) (/= "Redo" L) (/= nil L) (= 0 redo_flag))
                    (progn
                          (setq 1st_flag (+ 1st_flag 1))
                          (setq DS (getdist "\n輸入階級孔起始端直徑: "))
                          (while (null DS) (setq DS (getdist "\n資料未輸入! 請再輸入階級孔起始端直徑: ")))
                          (initget "T")
                          (setq DE (getdist (strcat "\n輸入錐度 (按 T) \\ 階級孔終止端直徑 <"(rtos DS 2 2)">: ")))
                          (if (= de "T")
                              (setq de (trap_dir ds L))
                          );if
                    );progn
                );if
                (if (and (/= "Undo" L) (/= nil L))
                    (progn
                        (setq linegrp (ssadd))
                        (if (= DE nil) (setq DE DS))
                        (if (< DS DE2)
                           (progn
                              (setq oldosmode (getvar "osmode"))
                              (setvar "osmode" 0)
                              (if (/= 1st_flag 1)
                                  (progn
                                      (command "line" p4 p5 "")
                                      (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                  );progn
                              );if
                              (setq $p p $p4 p4 $p5 p5)
                              (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                                    p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0))
                                    p1 (polar p ang L)
                                    p4 (polar p1 (+ (* pi 0.5) ang) (/ DE 2.0))
                                    p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE 2.0))
                              )
                              (if (= 1st_flag 1)
                                  (progn
                                      (command "line" p2 p3 "")
                                      (setq linegrp (ssadd (entlast) linegrp))     ;rex
                                  );progn
                              );if
                              (command "line" p2 p4 "")
                              (setq linegrp (ssadd (entlast) linegrp))     ;rex
                              (command "line" p3 p5 "")
                              (setq linegrp (ssadd (entlast) linegrp))     ;rex
                              (setvar "osmode" oldosmode)
                           )
                        )
                        (if (or (> DS DE2) (= DS DE2))
                           (progn
                              (setq oldosmode (getvar "osmode"))
                              (setvar "osmode" 0)
                              (setq $p p $p4 p4 $p5 p5)
                              (setq p2 (polar p (+ (* pi 0.5) ang) (/ DS 2.0))
                                    p3 (polar p (+ (- (* pi 0.5)) ang) (/ DS 2.0))
                                    p1 (polar p ang L)
                                    p4 (polar p1 (+ (* pi 0.5) ang) (/ DE 2.0))
                                    p5 (polar p1 (+ (- (* pi 0.5)) ang) (/ DE 2.0))
                              )
                              (command "line" p2 p3 "")
                              (setq linegrp (ssadd (entlast) linegrp))     ;rex
                              (command "line" p2 p4 "")
                              (setq linegrp (ssadd (entlast) linegrp))     ;rex
                              (command "line" p3 p5 "")
                              (setq linegrp (ssadd (entlast) linegrp))     ;rex
                              (setvar "osmode" oldosmode)
                           )
                        )
                    ;    (grdraw p102 p103 0)
                    ;    (grdraw p104 p105 0)
                        (redraw)
                        (setq p p1 $p102 p102 $p103 p103 $p104 p104 $p105 p105)

                        (setq p103 (polar p (* pi 0.25) (/ Y 22))
                              p102 (polar p (+ (* pi 0.25) pi) (/ Y 22))
                              p104 (polar p (* pi 0.75) (/ Y 22))
                              p105 (polar p (- (* pi 0.25)) (/ Y 22))
                        )
                        (grdraw p102 p103 12)
                        (grdraw p104 p105 12)
                        (setq $DE2 DE2 DE2 DE)
                    );progn
                );if
;                        (setq L (getdist p "\n輸入階級桿長度: "))
          )
          (command "line" p4 p5 "")
          (grdraw p102 p103 0)
          (grdraw p104 p105 0)

          (if yesnofg
            (progn
              (c:&cl&)
              (setvar "osmode" 0)
              (setq cen2 (polar p4 (angle p4 p5) (* 0.5 (distance p4 p5))))
              (setq cens (polar cen1 (angle cen2 cen1) extdist))
              (setq cene (polar cen2 (angle cen1 cen2) extdist))
              (command "line" cens cene "")
              (setvar "cecolor" ccolor)
              (setvar "celtype" cltype)
              (setvar "osmode" oldosmode)
            )
          )

          (SETQ FFF nil)
   )
   (setvar "cmdecho" 1)
   (princ)
)

;圓角輔助標註圖形
(defun c:codim(/ curlayer curcolor curltype ent1 ent2 d 10ent1 11ent1 10ent2
         11ent2 inter d1s d1e d2s d2e p3 p4 ent1data ent2data)
   (setvar "cmdecho" 0)
   (setq curlayer (getvar "clayer"))
   (setq curcolor (getvar "cecolor"))
   (setq curltype (getvar "celtype"))
   (setq oldosmode (getvar "osmode"))
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setq olderr *error*)
   (defun *error* (msg)
      (princ msg)
      (redraw)
      (setq *error* olderr)
   )
   (setq ent1 (entsel "\n選擇第一條直線(不可選擇弧,POLYLINE): "))
   (while (null ent1)
     (princ "\n沒有選到圖元! 請再選一次!!")
     (setq ent1 (entsel "\n選擇第一條直線(不可選擇弧,POLYLINE): "))
   )
   (setq ent1 (entget (car ent1)))
   (setq ent1data (cdr (assoc 0 ent1)))
   (setq ent2 (entsel "\n選擇第二條直線: "))
   (while (null ent2)
     (princ "\n沒有選到圖元! 請再選一次!!")
     (setq ent2 (entsel "\n選擇第二條直線(不可選擇弧,POLYLINE): "))
   )
   (setq ent2 (entget (car ent2)))
   (setq ent2data (cdr (assoc 0 ent2)))
   (if (and (= "LINE" ent1data) (= "LINE" ent2data))
      (progn
         (command "vslide" "co")
         (setvar "osmode" 0)
         (setq 10ent1 (cdr (assoc 10 ent1))
               11ent1 (cdr (assoc 11 ent1))
               10ent2 (cdr (assoc 10 ent2))
               11ent2 (cdr (assoc 11 ent2))
               inter (inters 10ent1 11ent1 10ent2 11ent2 nil)
               d1s (distance inter 10ent1)
               d1e (distance inter 11ent1)
               d2s (distance inter 10ent2)
               d2e (distance inter 11ent2)
         )
         (if (> d1s d1e) (setq p1 11ent1) (setq p1 10ent1))
         (if (> d2s d2e) (setq p2 11ent2) (setq p2 10ent2))
         (setq d (getdist (strcat "\n線的端點與交角總長為 "
                                  (rtos (distance p1 inter) 2 2) ", 請輸入D值: ")))
         (setq p3 (polar p1 (angle p1 inter) d)
               p4 (polar p2 (angle p2 inter) d)
         )
         (while (or (> d (distance p1 inter)) (> d (distance p2 inter)))
            (princ (strcat "\n您輸入的 D 值不可大於" (rtos (distance p1 inter) 2 2) ", 請再輸入一次 !!"))
            (setq d (getdist "\n輸入D值: "))
            (setq p3 (polar p1 (angle p1 inter) d)
                  p4 (polar p2 (angle p2 inter) d))
         )
         (redraw)
         (c:&tl&)
         (command "line" p3 inter p4 "")
         (command "layer" "s" curlayer "")
         (command "linetype" "s" curltype "")
      );progn
      (princ "\n您選的兩個圖元不全是直線(LINE),所以無法執行!!")
   );if
   (setvar "osmode" oldosmode)
 ; (if (= curcolor "BYLAYER") (command "color" "") (command "color" (atoi curcolor)))
   (cond
     ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
     ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
     (T (command "color" (atoi curcolor)))
   )
   (setvar "cmdecho" 1)
   (setq *error* olderr)
   (SETQ FFF nil))
   (princ)
)

;---------------------------------2003.03.10 SAM------------------------------------
;圓角輔助標註圖形(固定型)
(defun c:codim1(/ curlayer curcolor curltype ent1 ent2 d 10ent1 11ent1 10ent2
         11ent2 inter d1s d1e d2s d2e p3 p4 ent1data ent2data)
   (setvar "cmdecho" 0)
   (setq curlayer (getvar "clayer"))
   (setq curcolor (getvar "cecolor"))
   (setq curltype (getvar "celtype"))
   (setq oldosmode (getvar "osmode"))
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setq olderr *error*)
   (defun *error* (msg)
      (princ msg)
      (redraw)
      (setq *error* olderr)
   )
						    
   (setq ent1 (entsel "\n選擇第一條直線(不可選擇弧,POLYLINE): "))
   (while (null ent1)
     (princ "\n沒有選到圖元! 請再選一次!!")
     (setq ent1 (entsel "\n選擇第一條直線(不可選擇弧,POLYLINE): "))
   )
   (setq ent1 (entget (car ent1)))
   (setq ent1data (cdr (assoc 0 ent1)))
   (setq ent2 (entsel "\n選擇第二條直線: "))
   (while (null ent2)
     (princ "\n沒有選到圖元! 請再選一次!!")
     (setq ent2 (entsel "\n選擇第二條直線(不可選擇弧,POLYLINE): "))
   )
   (setq ent2 (entget (car ent2)))
   (setq ent2data (cdr (assoc 0 ent2)))
   (if (and (= "LINE" ent1data) (= "LINE" ent2data))
      (progn
         ;(command "vslide" "co")
         (setvar "osmode" 0)
         (setq 10ent1 (cdr (assoc 10 ent1))
               11ent1 (cdr (assoc 11 ent1))
               10ent2 (cdr (assoc 10 ent2))
               11ent2 (cdr (assoc 11 ent2))
               inter (inters 10ent1 11ent1 10ent2 11ent2 nil)
               d1s (distance inter 10ent1)
               d1e (distance inter 11ent1)
               d2s (distance inter 10ent2)
               d2e (distance inter 11ent2)
         )
         (if (> d1s d1e) (setq p1 11ent1) (setq p1 10ent1))
         (if (> d2s d2e) (setq p2 11ent2) (setq p2 10ent2))
         (setq d (/ (distance p1 inter) 3))
         (setq p3 (polar p1 (angle p1 inter) d)
               p4 (polar p2 (angle p2 inter) d)
         )
         (redraw)
         (c:&tl&)
         (command "line" p3 inter p4 "")
         (command "layer" "s" curlayer "")
         (command "linetype" "s" curltype "")
      );progn
      (princ "\n您選的兩個圖元不全是直線(LINE),所以無法執行!!")
   );if
   (setvar "osmode" oldosmode)
 ; (if (= curcolor "BYLAYER") (command "color" "") (command "color" (atoi curcolor)))
   (cond
     ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
     ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
     (T (command "color" (atoi curcolor)))
   )
   (setvar "cmdecho" 1)
   (setq *error* olderr)
   (SETQ FFF nil))
   (princ)
);-------------------------------------------------------------------------------
;連續原點截斷
(defun c:mbreak(/ ent p1 os)
   (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setq olderr *error*)
   (defun *error* (msg)
      (princ msg)
      (setvar "osmode" os)
      (setvar "orthomode" oldorthomode)
      (redraw)
      (setq *error* olderr)
   )
   (setq os (getvar "osmode"))
   (setvar "osmode" 32)
   (while (setq ent (car (entsel "\n選擇圖素: ")))
      (setq p1 (getpoint "\n選擇截斷點: "))
      (command "break" ent p1 p1)
   )
   (setvar "cmdecho" 1)
   (setvar "osmode" os)
   (setq *error* olderr)
   (SETQ FFF nil))
   (princ)
)

;;延伸線段 ext
(defun c:ext(/ oldltype oldcolor curlayer ent entity data 6ent 8ent 10ent
         10ent 11ent 62ent dist dist1 dist2 len p1 p2)
  (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (setq oldltype (getvar "celtype"))
  (setq oldcolor (getvar "cecolor"))
   (setq curlayer (getvar "clayer"))
  (setq ent (entsel "\n選擇一條線作延伸: "))
  (if ent
    (progn
      (setq p1 (cadr ent))
      (setq entity (car ent))
      (setq data (entget (car ent)))
      (setq 10ent (cdr (assoc 10 data))
            11ent (cdr (assoc 11 data))
            8ent (cdr (assoc 8 data))
            6ent (cdr (assoc 6 data))
            62ent (cdr (assoc 62 data))
            dist (distance 10ent 11ent)
            dist1 (distance 10ent p1)
            dist2 (distance 11ent p1))
      (if (> dist1 dist2) (setq pp 11ent) (setq pp 10ent))
      (setq len (getdist pp (strcat "\n輸入延伸長度或任選一點: ")))
      (command "linetype" "s" 6ent "")
      (command "color" 62ent)
      (command "layer" "s" 8ent "")
      (if (> dist1 dist2)
          (progn
             (setq ang (angle 10ent 11ent))
             (setq p2 (polar 10ent ang (+ dist len)))
             (entdel entity)
             (command "line" 10ent p2 "")
          )
          (progn
             (setq ang (angle 11ent 10ent))
             (setq p2 (polar 11ent ang (+ dist len)))
             (entdel entity)
             (command "line" 11ent p2 "")
          )
      )
      (command "linetype" "s" oldltype "")
      (command "layer" "s" curlayer "")
;     (if (= oldcolor "BYLAYER") (command "color" oldcolor) (command "color" (atoi oldcolor)))
      (cond
        ((= oldcolor "BYBLOCK") (command "color" "BYBLOCK"))
        ((= oldcolor "BYLAYER") (command "color" "BYLAYER"))
        (T (command "color" (atoi oldcolor)))
      )
    );progn
  );if
  (setvar "cmdecho" 1)
   (SETQ FFF nil))
  (princ)
)

;;線段被前景遮住

 ;;;┌────────────────────────────────┐
 ;;;│ 程  式 :R14版                                                  │
 ;;;│ 主程式 :1hid                                                   │
 ;;;│ 日  期 :89.3.8                                                 │
 ;;;│ 姓  名 :洪國鈞                                                 │
 ;;;│ 對話框 :                                                       │
 ;;;│ 方  法 : break  entmod                                         │
 ;;;│ 相關檔案:judge_attr, swap                                      │
 ;;;└────────────────────────────────┘


;;虛線

(defun c:1hid(/ c-layer c-color c-linetype ent1 10ent1 11ent1 ent2 10ent2 10ent2 ent3 10ent3 11ent3 lay-ent3
                int1 int2 p1 p2 os)

   (setvar "cmdecho"   0)
   (setq    os        (getvar "osmode"))
   (setq    olderr    *error*)

   (defun *error* (msg)

          (princ msg)
          (redraw)
          (setvar "osmode" os)
          (setq   *error*  olderr)
          (prin1)
   )

;REMEMBER CURRENT LAYER, LINETYPE, COLOR
   (setq
         c-layer    (getvar "clayer")
         c-color    (getvar "cecolor")
         c-linetype (getvar "celtype")
   )


   (setq ent3  nil)
   (setq brkp1 nil)
   (setq brkp2 nil)

   (while (= ent3 nil)
          (setq
                ent3 (car (entsel "\n選擇將改變為虛線的直線<Esc 取消>:"))
          )
   )

;;; brkp1==> break p1, brkp2 ==> break p2

   (redraw ent3 3)

   (while (= brkp1 nil)
          (setq brkp1 (getpoint        "\n虛線第一點:"))
   )
   (while (= brkp2 nil)
          (setq brkp2 (getpoint  brkp1 "\n虛線第二點:"))
   )

   (redraw ent3 4)
   (c:&dl&)

;;; judge_attr: 針對 Line SpLine PloyLine 的 "虛線第一點"
;;;             必須與  "改變為虛線的直線第一點" 相鄰 .
;;;             Arc 之 break 情形不一樣 及 entity之起始點
;;;             不一樣,故另外處理.

   (if (/= (cdr (assoc 0 (entget ent3))) "ARC")
       (judge_attr)
   )

   (setvar "osmode" 0)

   (if     (/= ent3 nil)
           (progn
                 (setvar "cmdecho" 0)

                ; (if (= (cdr (assoc 0 (entget ent3))) "ARC")
                 (cond
                      ((= (cdr (assoc 0 (entget ent3))) "ARC")


                          (setq ent3_entity     (entget ent3))

                          (setq ang1            (cdr   (assoc 50 ent3_entity)))
                          (setq ang4            (cdr   (assoc 51 ent3_entity)))
                          (setq rad             (cdr   (assoc 40 ent3_entity)))
                          (setq cir_centerp     (cdr   (assoc 10 ent3_entity)))

                          (setq ang4_p          (polar cir_centerp ang4 rad))

                          (setq ang2            (angle cir_centerp brkp1))
                          (setq ang3            (angle cir_centerp brkp2))

                          (if (< ang1 ang4)
                              (progn
                                   (if (> ang2 ang3)
                                       (progn
                                            (setq anglist  (swap ang2 ang3))
                                            (setq ang2     (car anglist))
                                            (setq ang3     (cadr anglist))
                                            (setq brkpList (swap brkp1 brkp2))
                                            (setq brkp1    (car brkpList))
                                            (setq brkp2    (cadr brkpList))
                                       )
                                   );if
                              );progn
                              (progn ;else
                                  (setq diff_360   (- (* pi 2)    ang1    ))
                                  (setq ang2_temp  (+    ang2     diff_360))
                                  (setq ang3_temp  (+    ang3     diff_360))
                                  (if (> ang2_temp (* pi 2))
                                      (setq ang2_temp (- ang2_temp (* pi 2)))
                                  )
                                  (if (> ang3_temp (* pi 2))
                                      (setq ang3_temp (- ang3_temp (* pi 2)))
                                  )


                                 ;(setq ang2 ang2_temp)
                                 ;(setq ang3 ang3_temp)


                                  (if (> ang2_temp  ang3_temp)
                                      (progn
                                           (setq anglist  (swap ang2 ang3))
                                           (setq ang2     (car anglist))
                                           (setq ang3     (cadr anglist))
                                           (setq brkpList (swap brkp1 brkp2))
                                           (setq brkp1    (car brkpList))
                                           (setq brkp2    (cadr brkpList))
                                      )
                                  );if

                              );progn_else
                           );progn_glob
                           (setq ent3_entity
                                 (subst  (cons  51    ang2)
                                         (assoc 51    ent3_entity)
                                         ent3_entity
                                 )
                            )
                            (entmod ent3_entity)

                            (command "arc" "c"  cir_centerp brkp1 brkp2)
                            (setq brk_ent3 (entlast))
                            (command "layer" "s" lay-ent3 "")
                            (command "change" brk_ent3 "" "P" "Lt" "dashed" "C" "3" "")

                            (command "arc" "c" cir_centerp brkp2 ang4_p)
                            (setq   Last_ent3 (entlast))
                            (command "change" Last_ent3 "" "P" "LA" c-layer "Lt"  c-Linetype "C" c-color "")

                     );progn
                     ((= (cdr (assoc 0 (entget ent3))) "LINE")
                      (command "break" ent3  brkp1 brkp2)
                      (command "line" brkp1 brkp2 "")
                      (command "chprop" (entlast) "" "la" (cdr(assoc 8 (entget ent3))) "")
                     )
                     (t
                           (setq   ent3_temp (assoc  0 (entget ent3)))
                         ; (setq a 1)
                            (command "break" ent3 brkp1 brkp1)
                            (setq brk_ent3 (entlast))
                          ; (setq a 2)
                            (command "break" brk_ent3  brkp2 brkp2)
                            (command "layer" "s" lay-ent3 "")
                          ; (setq a 3)
                           (if (= (cdr ent3_temp) "POLYLINE")
                               (setq brk_ent3 (entnext brk_ent3))
                           )

                            (command "change" brk_ent3 "" "P" "Lt" "dashed" "C" "3" "")
                     )
                );cond
           );progn
   );if

;return LAYER, LINETYPE, COLOR

  (command "color"     c-color )

  (command "linetype"  "s"     c-linetype "")
  (command "layer"     "s"     c-layer    "")

  (setvar  "cmdecho"   1)
  (setvar  "osmode"    os)
  (setq    *error*     olderr)
  (princ)
)


(defun judge_attr()

           (cond (
                   (= (cdr (assoc 0 (entget ent3))) "LINE")
                   (progn
                          (setq endp1 (cdr (assoc 10 (entget ent3))))
                          (setq endp2 (cdr (assoc 11 (entget ent3))))
                   );progn
                 )

                 (
                   (= (cdr (assoc 0 (entget ent3))) "SPLINE")
                   (progn
                          (setq endp1 (cdr (assoc 10 (entget ent3))))
                          (setq endp2 (cdr (assoc 11 (reverse (entget ent3)  )  )))
                   )
                 )


                 (
                   (= (cdr (assoc 0 (entget ent3))) "POLYLINE")
                   (progn

                          (setq vx1_name      (entnext ent3))
                          (setq endp1         (cdr (assoc 10 (entget vx1_name))))
                          (setq ent_next_name (entnext vx1_name))

                          (while (/= (cdr (assoc 0 (entget ent_next_name))) "SEQEND")

                                 (setq ent_next_nametemp  ent_next_name)
                                 (setq ent_next_name      (entnext ent_next_name))

                          );while

                          (setq endp2         (cdr (assoc 10 (entget ent_next_nametemp))))

                   );progn
                 )


                 (
                   (= (cdr (assoc 0 (entget ent3))) "LWPOLYLINE")
                   (progn

                          (setq endp1         (cdr (assoc 10 (entget ent3))))
                          (setq endp2         (cdr (assoc 10 (reverse (entget ent3)))))
                         

                   );progn
                 )


           );cond


         ; (setq endp1 (cdr (assoc 10 (entget ent3))) )
         ; (setq endp2 (cdr (assoc 11 (entget ent3))) )

           (setq  return_dir  (judge_dir endp1 endp2 brkp1 brkp2))
           (cond
                (
                 ;(or
                 ;  (= (cdr (assoc 0 (entget ent3))) "LINE")
                 ; (= (cdr (assoc 0 (entget ent3))) "POLYLINE")
                 ;  (= (cdr (assoc 0 (entget ent3))) "SPLINE")
                 ;)
                  (= return_dir 0)

                    (progn
                      ;(setq endp1 (cdr (assoc 10 (entget ent3))) )
                         (if (> (distance endp1 brkp1) (distance endp1 brkp2))
                             (progn
                               ; (setq temp (entget ent3))
                                 (setq swapList (swap brkp1 brkp2))
                                 (setq brkp1 (car swapList))
                                 (setq brkp2 (cadr swapList))
                             );progn

                         );if
                    );progn


                )
                (
                  (< return_dir 0)

                    (progn
                      ;(setq endp1 (cdr (assoc 10 (entget ent3))) )
                      ;  (if (> (distance endp1 brkp1) (distance endp1 brkp2))
                      ;      (progn
                              ;  (setq temp (entget ent3))
                                 (setq swapList (swap brkp1 brkp2))
                                 (setq brkp1 (car swapList))
                                 (setq brkp2 (cadr swapList))
                     ;       );progn

                     ;   );if
                    );progn                                                                 )
               )

           );cond





);judge

(defun judge_dir ( judge_bj1_p1 bj1_p2  judge_bj2_p1 bj2_p2)

        (setq bj1_p1x    (car  judge_bj1_p1))
        (setq bj1_p1y    (cadr judge_bj1_p1))
        (setq bj1_p2x    (car  bj1_p2))
        (setq bj1_p2y    (cadr bj1_p2))



        (setq bj2_p1x    (car  judge_bj2_p1))
        (setq bj2_p1y    (cadr judge_bj2_p1))
        (setq bj2_p2x    (car  bj2_p2      ))
        (setq bj2_p2y    (cadr bj2_p2      ))


        (setq bj1_p1p2x  (/ (+ bj1_p1x bj1_p2x) 2))
        (setq bj1_p1p2y  (/ (+ bj1_p1y bj1_p2y) 2))
        (setq bj2_p1p2x  (/ (+ bj2_p1x bj2_p2x) 2))
        (setq bj2_p1p2y  (/ (+ bj2_p1y bj2_p2y) 2))

        (setq y1_y2      (- bj1_p1p2y bj2_p1p2y))
        (setq x1_x2      (- bj1_p1p2x bj2_p1p2x))


        (setq bjmid1_p    (list bj1_p1p2x bj1_p1p2y 0))
        (setq bjmid2_p    (list bj2_p1p2x bj2_p1p2y 0))
        (setq bjmid_ang   (angle bjmid1_p bjmid2_p)   )

        (setq c1_c2       (- (* (sin bjmid_ang) bj1_p1p2x  ) (* (cos bjmid_ang) bj1_p1p2y  )))
        (setq bj1_c1_c2   (- (* (sin bjmid_ang) bj1_p1x) (* (cos bjmid_ang) bj1_p1y)))
        (setq bj2_c1_c2   (- (* (sin bjmid_ang) bj2_p1x) (* (cos bjmid_ang) bj2_p1y)))

        (setq prec_c1_c2      (atof (rtos c1_c2 2 2)))
        (setq prec_bj1_c1_c2  (atof (rtos bj1_c1_c2 2 2)))
        (setq prec_bj2_c1_c2  (atof (rtos bj2_c1_c2 2 2)))


        (cond
             ( (> (* (- prec_bj1_c1_c2  prec_c1_c2) (- prec_bj2_c1_c2 prec_c1_c2)) 0)

               (setq returnvalue 1)
             )


             ( (= (* (- prec_bj1_c1_c2  prec_c1_c2) (- prec_bj2_c1_c2 prec_c1_c2)) 0)

               (setq returnvalue 0)
             )

             ( (< (* (- prec_bj1_c1_c2  prec_c1_c2) (- prec_bj2_c1_c2 prec_c1_c2)) 0)

               (setq returnvalue -1)
             )

         );cond

)

(defun swap(a b)
      (setq temp a)
      (setq a b)
      (setq b temp)
      (setq returnvalue (list a b))

)


(defun c:m1hid(/ c-layer c-color c-linetype ent1 10ent1 11ent1 ent2 10ent2 10ent2 ent3 10ent3 11ent3 lay-ent3
                int1 int2 p1 p2 os)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "cmdecho" 0)
   (setq os (getvar "osmode"))
   (setq olderr *error*)
   (defun *error* (msg)
      (princ msg)
      (redraw)
      (setvar "osmode" os)
      (setq *error* olderr)
      (prin1)
   )
;REMEMBER CURRENT LAYER, LINETYPE, COLOR
  (setq c-layer (getvar "clayer")
        c-color (getvar "cecolor")
        c-linetype (getvar "celtype"))
   (prompt "**** 請選擇直線 LINE ****")
   (setq ent1 (car (entsel "\n第一條線:")))
   (while (/= (cdr (assoc 0 (entget ent1))) "LINE")
     (prompt "\n這不是直線 LINE, 請再試一次!!")
     (setq ent1 (car (entsel "\n第一條線:")))
   );while
   (setq 10ent1 (cdr (assoc 10 (entget ent1)))
         11ent1 (cdr (assoc 11 (entget ent1))))
   (grdraw 10ent1 11ent1 10)

;SELECT SECOND LINE
   (setq ent2 (car (entsel "\n第二條線:")))
   (while (/= (cdr (assoc 0 (entget ent2))) "LINE")
     (prompt "\n這不是直線 LINE, 請再試一次!!")
     (setq ent2 (car (entsel "\n第二條線:")))
   );while
   (setq 10ent2 (cdr (assoc 10 (entget ent2)))
         11ent2 (cdr (assoc 11 (entget ent2))))
   (grdraw 10ent2 11ent2 11)
   (c:&dl&)
   (prompt "\n選擇將改變為虛線的直線<RETURN 離開>: ")
   (setq ssgline (ssget))
;   (setq ent3 (car (entsel " ")))

;SELECT THIRD LINE
   (setvar "osmode" 0)
   (if(/= ssgline nil)
     (progn
      (setq i 0)
      (repeat (sslength ssgline)
         (if (= (cdr (assoc 0 (entget (setq ent3 (ssname ssgline i))))) "LINE")
             (progn
                (setq 10ent3 (cdr (assoc 10 (entget ent3)))
                      lay-ent3 (cdr (assoc 8 (entget ent3)))
                      11ent3 (cdr (assoc 11 (entget ent3))))
;SELECT 2 INT POINT & BREAK & DRAR DASHED LINE
                (setq int1 (inters 10ent1 11ent1 10ent3 11ent3))
                (if (null int1)
                    (progn
                      (setq intswp (inters 10ent1 11ent1 10ent3 11ent3 nil))
                      (if (< (distance 10ent3 intswp) (distance 11ent3 intswp))
                          (setq int1 10ent3)
                          (setq int1 11ent3)
                      )
                    );progn
                );
                (setq int2 (inters 10ent2 11ent2 10ent3 11ent3))
                (if (null int2)
                    (progn
                      (setq intswp (inters 10ent2 11ent2 10ent3 11ent3 nil))
                      (if (< (distance 10ent3 intswp) (distance 11ent3 intswp))
                          (setq int2 10ent3)
                          (setq int2 11ent3)
                      )
                    );progn
                );

                (setvar "cmdecho" 0)
                (command "break" ent3 int1 int2)
                (command "layer" "s" lay-ent3 "")
                (command "line" int1 int2 "")
             );progn
         );if
         (setq i (+ i 1))
      );repeat
     );progn
   );if
   (redraw)

;return LAYER, LINETYPE, COLOR
  (command "color" c-color)
  (command "linetype" "s" c-linetype "")
  (command "layer" "s" c-layer "")
  (setvar "cmdecho" 1)
  (setvar "osmode" os)
  (setq *error* olderr)
  (SETQ FFF nil))
  (princ)
)


;;圓形被前景遮住
(defun c:cirhi(/ ent entt ep sp cenp oldosmode)
  (setvar "cmdecho" 0)
  (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (setq ent (entsel "\n選擇一個圓: ")
        entt (entget (car ent))
        sp (osnap (getpoint "\n選擇第一點: ") "nea")
        ep (osnap (getpoint "\n選擇第二點: ") "nea")
        cenp (cdr (assoc 10 entt))
  )
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
  (command "break" (car ent) sp ep)
  (c:&dl&)
  (command "arc" "c" cenp sp ep)
  (setvar "osmode" oldosmode)
  (c:&sl&)
  (SETQ FFF nil))
  (setvar "cmdecho" 1)
  (princ)
)

;;連續截斷交差點
(defun c:mbrl(/ p1 p2 p3 p4 objs cont intp)
 (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (prompt "\n選擇截斷目標線: ")
 (while (setq objs (entsel ""))
  (if (= (cdr (assoc 0 (entget (car objs)))) "LINE")
   (progn
    (setq p1  (cdr (assoc 10 (entget (car objs))))
          p2  (cdr (assoc 11 (entget (car objs))))
          objs (ssget "c" p1 p2)
          cont 0
    )
    (repeat (sslength objs)
     (if (= (cdr (assoc 0 (entget (ssname objs cont)))) "LINE")
      (progn
       (setq p3   (cdr (assoc 10 (entget (ssname objs cont))))
             p4   (cdr (assoc 11 (entget (ssname objs cont))))
             intp (inters p1 p2 p3 p4 T)
       )
       (if intp
           (command "break" (ssname objs cont) intp "@")
       )
      )
     )
     (setq cont (1+ cont))
    )
   )
   (progn

(prompt
(strcat "\nEntity is " (cdr (assoc 0 (entget (car objs)))) " not a line ! "))
    (prompt "\n選擇截斷目標線: ")
   )
  )
 )
 (setvar "cmdecho" 1)
 (SETQ FFF nil))
 (princ)
)



;;矩行 mrect
(defun c:mrect(/ y pnt pnt1 os p1 p2 p3 p4 p102 p103 p104 p105 l w ang)
   (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setq Y (getvar "viewsize"))
   (setq pnt1 (getpoint "\n輸入中間點: "))
   (setq p103 (polar pnt1 (* pi 0.25) (/ Y 22))
         p102 (polar pnt1 (+ (* pi 0.25) pi) (/ Y 22))
         p104 (polar pnt1 (* pi 0.75) (/ Y 22))
         p105 (polar pnt1 (- (* pi 0.25)) (/ Y 22))
   )
   (grdraw p102 p103 12)
   (grdraw p104 p105 12)
 (command "vslide" "rect(mrect)")
 (setq l (getdist "\n輸入H值: ") )
 (setq w (getdist "\n輸入W值: ") )
 (redraw)
 (setq ang (getangle pnt1 "\n輸入旋轉角度 <0>: ") )
 (if (or (= ang nil) (= ang 0)) (setq ang 0))
 (setq pnt (polar pnt1 (+ pi ang) (/ w 2.0) ) )
 (setq p1 (polar pnt (+ (- (* pi 0.5)) ang) (/ l 2.0) ) )
 (setq p2 (polar p1 ang w) )
 (setq p3 (polar p2 (+ (/ pi 2) ang) l) )
 (setq p4 (polar p3 (+ (- pi) ang) w) )
 (setq os (getvar "osmode"))
 (setvar "osmode" 0)
 (command "line" p1 p2 p3 p4 "c")
 (setvar "osmode" os)
   (grdraw p102 p103 0)
   (grdraw p104 p105 0)
  (SETQ FFF nil))
  (setvar "cmdecho" 1)
 (princ)
)

;;矩行 crect
(defun c:crect(/ y pnt p1 p2 p3 p4 os p102 p103 p104 p105 w h ang)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "cmdecho" 0)
   (setq Y (getvar "viewsize"))
   (setq pnt (getpoint "\n選擇插入中心點: "))
   (setq p103 (polar pnt (* pi 0.25) (/ Y 22))
         p102 (polar pnt (+ (* pi 0.25) pi) (/ Y 22))
         p104 (polar pnt (* pi 0.75) (/ Y 22))
         p105 (polar pnt (- (* pi 0.25)) (/ Y 22))
   )
   (grdraw p102 p103 12)
   (grdraw p104 p105 12)
 (command "vslide" "rect(crect)")
 (setq w (getdist "\n輸入H值: ") )
 (setq h (getdist "\n輸入W值: ") )
 (redraw)
 (setq ang (getangle pnt "\n輸入旋轉角度 <0>: ") )
 (if (or (= ang nil) (= ang 0)) (setq ang 0))
 (setq p1 (polar pnt (+ (- (* pi 0.5)) ang) (/ w 2.0) ) )
 (setq p2 (polar p1 ang h))
 (setq p3 (polar p2 (+ (* pi 0.5) ang) w) )
 (setq p4 (polar p3 (+ pi ang) h) )
 (setq os (getvar "osmode"))
 (setvar "osmode" 0)
 (command "line" p1 p2 p3 p4 "c")
 (setvar "osmode" os)
   (grdraw p102 p103 0)
   (grdraw p104 p105 0)
   (setvar "cmdecho" 1)
 (SETQ FFF nil))
 (princ)
)


;;矩行 srect1
(defun c:srect1()
 (setvar "cmdecho" 0)(setvar "highlight" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setq Y (getvar "viewsize"))
 (setq p1 (getpoint "\n插入點: "))
 (setq p103 (polar p1 (* pi 0.25) (/ Y 22))
       p102 (polar p1 (+ (* pi 0.25) pi) (/ Y 22))
       p104 (polar p1 (* pi 0.75) (/ Y 22))
       p105 (polar p1 (- (* pi 0.25)) (/ Y 22))
 )
 (grdraw p102 p103 12)
 (grdraw p104 p105 12)
 (command "vslide" "rect(srect1)")
 (setq l (getdist "\n輸入H值: ") )
 (setq w (getdist "\n輸入W值: ") )
 (redraw)
 (setq ang (getangle p1 "\n旋轉角度<0>: "))
 (if (or (= ang nil) (= ang 0)) (setq ang 0))
 (setq p2 (polar p1 ang w) )
 (setq p3 (polar p2 (+ (* pi 0.5) ang) l) )
 (setq p4 (polar p1 (+ (* pi 0.5) ang) l) )
 (setvar "osmode" 0)
 (command "line" p1 p2 p3 p4 "c")
 (grdraw p102 p103 0)
 (grdraw p104 p105 0)
 (setvar "cmdecho" 1)(setvar "highlight" 1)
 (SETQ FFF nil))
)


;;矩行 srect
(defun c:srect(/ y p1 p2 p3 p4 p102 p103 p104 p105 l w ang os)
 (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setq Y (getvar "viewsize"))
 (setq p1 (getpoint "\n選擇插入點: "))
 (setq p103 (polar p1 (* pi 0.25) (/ Y 22))
       p102 (polar p1 (+ (* pi 0.25) pi) (/ Y 22))
       p104 (polar p1 (* pi 0.75) (/ Y 22))
       p105 (polar p1 (- (* pi 0.25)) (/ Y 22))
 )
 (grdraw p102 p103 12)
 (grdraw p104 p105 12)
 (command "vslide" "rect(srect)")
 (setq l (getdist "\n輸入H值: ") )
 (setq w (getdist "\n輸入W值: ") )
 (redraw)
 (setq ang (getangle p1 "\n輸入旋轉角度 <0>: "))
 (if (or (= ang nil) (= ang 0)) (setq ang 0))
 (setq p2 (polar p1 (+ (- (* pi 0.5)) ang) l) )
 (setq p3 (polar p2 ang w))
 (setq p4 (polar p1 ang w) )
 (setq os (getvar "osmode"))
 (setvar "osmode" 0)
 (command "line" p1 p2 p3 p4 "c")
 (setvar "osmode" os)
 (grdraw p102 p103 0)
 (grdraw p104 p105 0)
 (SETQ FFF nil))
 (setvar "cmdecho" 1)
 (princ)
)

;矩行 3e
(defun c:3e(/ y p1 p2 p3 p4 p5 p102 p103 p104 p105 w h ang)
   (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
    (setq Y (getvar "viewsize"))
    (setq p1 (getpoint "\n選擇插入點: "))
    (setq p103 (polar p1 (* pi 0.25) (/ Y 22))
          p102 (polar p1 (+ (* pi 0.25) pi) (/ Y 22))
          p104 (polar p1 (* pi 0.75) (/ Y 22))
          p105 (polar p1 (- (* pi 0.25)) (/ Y 22))
    )
    (grdraw p102 p103 14)
    (grdraw p104 p105 14)
    (command "vslide" "rect(3e)")
  (setq w (getdist "\n輸入H值: ")
        h (getdist "\n輸入W值: "))
  (redraw)
  (SETQ ang (getangle p1 "\n輸入旋轉角度 <0>: "))
  (if (= ang nil) (setq ang 0))
  (setq p2 (polar p1 (+ (- (* pi 0.5)) ang) (/ w 2.0))
        p3 (polar p2 ang h)
        p4 (polar p3 (+ (* pi 0.5) ang) w)
        p5 (polar p4 (+ (- pi) ang) h))
  (setq os (getvar "osmode"))
  (command "osmode" 0)
  (command "line" p2 p3 p4 p5 "")
  (command "osmode" os)
    (grdraw p102 p103 0)
    (grdraw p104 p105 0)
    (SETQ FFF nil))
    (setvar "cmdecho" 1)
  (princ)
)






;;ORIGINAL.DWG,2CIR.SLD
;;畫環形圓
(defun c:mc(/ p1 p2 p3 p4 p102 p103 p104 p105 y d n ang abc lt )
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "cmdecho" 0)
   (setq osmode (getvar "osmode"))             ;;2003.07.08 SAM
   (setq p1 (getpoint "\n選擇中心點: "))
    (setq Y (getvar "viewsize"))
    (setq p103 (polar p1 (* pi 0.25) (/ Y 22))
          p102 (polar p1 (+ (* pi 0.25) pi) (/ Y 22))
          p104 (polar p1 (* pi 0.75) (/ Y 22))
          p105 (polar p1 (- (* pi 0.25)) (/ Y 22))
    )
   (setq d (getdist P1 "\n輸入複製圓直徑: " ))
   (setq n (getint "\n輸入圓複製數目: ")
         d1 (getdist P1 "\n輸入圓中心距離: ")
         ang (getangle p1 "\n輸入第一個圓起始角度: ")
         p2 (polar p1 ang (* d1 0.5))
         p3 (polar p1 ang (- (* d1 0.5) (+ (* d 0.5) 2)))
         p4 (polar p3 ang (+ d 4)))
   (setvar "osmode" 0)
   (C:&SL&)
   (command "circle" p2 "d" d)
   (setq a (entlast))
   (C:&CL&)
   (command "line" p3 p4 "")
   (setq b (entlast))
   (if (= acad_ver "GENIUS")
     (command ".array" a b "" "p" p1 n "" "")
     (command "array" a b "" "p" p1 n "" "")
   )
   (C:&CL&)
   (command "circle" p1 "d" d1)
   (C:&SL&)
   (setvar "osmode" osmode)                   ;;2003.07.08 SAM
   (setvar "cmdecho" 1)
   (SETQ FFF nil))
   (princ)
)

;;設定新圓點
(defun c:newmo()
   (setvar "cmdecho" 0)
   (setq $$ori (getpoint "\n選擇原點: "))
   (if (/= nil $$ori)
     (progn
       (setq $$orix (nth 0 $$ori))
       (setq $$oriy (nth 1 $$ori))
       (princ "\n新原點: ")
       (princ $$ori)
       (princ " 設定完成!")
     );progn
     (princ "\n未設定新原點!")
   );
   (princ)
)

;寫出座標(x,y),寫出座標(x/y)
;typ=1 => x,y typ=3 => (x,y)
(defun c:wcood(typ)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "cmdecho" 0)
   (setq txth (* (getvar "dimscale") (getvar "dimtxt")))
   (setq txthh (getdist (strcat "\n輸入字高<" (rtos txth 2 2) ">: ")))
   (if txthh (setq txth txthh))
   (if (null $$ori)
      (progn
         (princ "\n原點還沒有選定!")
         (c:newmo)
      )
   )
   (setq set_po (getpoint "\n選擇要寫出座標的點: "))
   (while set_po
     (setq set_po_x (- (nth 0 set_po) $$orix))
     (setq set_po_y (- (nth 1 set_po) $$oriy))
     (setq xword (rtos set_po_x 2 2))
     (setq yword (rtos set_po_y 2 2))
     (cond
       ((= 1 typ)(command "text" set_po txth "0" (strcat xword "," yword))
                  (princ "\n選擇字的位置....")
                  (command "move" "l" "" set_po pause))
       ((= 3 typ)(command "text" set_po txth "0" (strcat "(" xword "," yword ")"))
                  (princ "\n選擇字的位置....")
                  (command "move" "l" "" set_po pause))
       ((= 2 typ)(command "text" "0,0" txth "0" xword)
           (setq xword_p (caadr (textbox (list (assoc 1 (entget (entlast)))))))
           (entdel (entlast))
           (command "text" "0,0" txth "0" yword)
           (setq yword_p (caadr (textbox (list (assoc 1 (entget (entlast)))))))
           (entdel (entlast))
           (if (> xword_p yword_p)(setq line_len xword_p)(setq line_len yword_p))
           (setq txt_up (polar set_po (* pi 0.5) (* (getvar "dimgap") (getvar "dimscale"))))
           (setq txt_dp (polar set_po (* pi 1.5) (* (getvar "dimgap") (getvar "dimscale"))))
           (setq oldosmode (getvar "osmode"))
           (setvar "osmode" 0)
           (setq lp1 (polar set_po pi (* 0.5 line_len)))
           (setq lp2 (polar set_po 0 (* 0.5 line_len)))
           (command "line" lp1 lp2 "")
           (setq ent1 (entlast))
           (command "text" "bc" txt_up txth "0" xword)
           (setq ent2 (entlast))
           (command "text" "tc" txt_dp txth "0" yword)
           (setvar "osmode" oldosmode)
           (setq ent3 (entlast))
           (princ "\n選擇字的位置....")
           (command "move" ent1 ent2 ent3 "" set_po pause)
       )
     )
     (setq set_po (getpoint "\n選擇要寫出座標的點: "))
   )
   (setvar "cmdecho" 1)
   (SETQ FFF nil))
   (princ)
)

;X-Y 圓
(defun c:xycir(/ oricir cirrad xdist ydist cir_x cir_y)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "cmdecho" 0)
   (setq oricir (getpoint "\n選擇基準點: "))
   (while (null oricir)
     (princ "\n您未選擇基準點, 請再選擇一次...")
     (setq oricir (getpoint "\n選擇基準點: "))
   )
   (setq cirrad (getdist "\n半徑: "))
   (while (null cirrad)
     (princ "\n您未輸入半徑, 請再輸入一次...")
     (setq cirrad (getdist "\n半徑: "))
   )
   (while cirrad
     (setq xdist (getdist "\nX 水平距離(基準點左方為負,右方為正): "))
     (while (null xdist)
       (princ "\n您未輸入X 水平距離, 請再輸入一次...")
       (setq xdist (getdist "\nX 水平距離(基準點左方為負,右方為正): "))
     )
     (setq ydist (getdist "\nY 垂直距離(基準點下方為負,上方為正): "))
     (while (null ydist)
       (princ "\n您未輸入Y 垂直距離, 請再輸入一次...")
       (setq ydist (getdist "\nY 垂直距離(基準點下方為負,上方為正): "))
     )
     (setq cir_x (+ (nth 0 oricir) xdist))
     (setq cir_y (+ (nth 1 oricir) ydist))
     (command "circle" (list cir_x cir_y) cirrad)
     (setq cirrad (getdist "\n半徑: "))
   )
   (setvar "cmdecho" 1)
   (SETQ FFF nil))
   (princ)
)

;距離-角度 圓
(defun c:polcir(/ oricir cirrad aangle dist)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setvar "cmdecho" 0)
   (setq oricir (getpoint "\n選擇基準點: "))
   (while (null oricir)
     (princ "\n您未選擇基準點, 請再選擇一次...")
     (setq oricir (getpoint "\n選擇基準點: "))
   )
   (setq cirrad (getdist "\n半徑: "))
   (while (null cirrad)
     (princ "\n您未輸入半徑, 請再輸入一次...")
     (setq cirrad (getdist "\n半徑: "))
   )
   (while cirrad
     (setq aangle (getangle "\n角度(順時針為負,逆時針為正): "))
     (while (null aangle)
       (princ "\n您未輸入角度, 請再輸入一次...")
       (setq aangle (getangle "\n角度(順時針為負,逆時針為正): "))
     )
     (setq dist (getdist "\n距離: "))
     (while (null dist)
       (princ "\n您未輸入距離, 請再輸入一次...")
       (setq dist (getdist "\n距離: "))
     )
     (command "circle" (polar oricir aangle dist) cirrad)
     (setq cirrad (getdist "\n半徑(或按 Enter 鍵結束執行): "))
   )
   (setvar "cmdecho" 1)
   (SETQ FFF nil))
   (princ)
)
;;等角度畫圓
(defun c:2cir(/ basecir basecir_cen basecir_rad cir2 cir2_cen cirang cirqty cirrad cenline_ang
                s_ang ang_per)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setq oldos(getvar "osmode"))
   (setq olderr *error*)

   (defun *error* (msg)
      (princ msg)
      (setvar "osmode" oldos)
      (redraw)
      (setq *error* olderr)
      (prin1)
   )

   (setq basecir (entsel "\n選擇要分角度的圓: "))
   (while (null basecir)
          (princ "\n您未選到圖元, 請再選擇一次...")
          (setq basecir (entsel "\n選擇要分角度的圓: "))
   )
   (setq basecir_cen (cdr (assoc 10 (entget (car basecir)))))
   (setq basecir_rad (cdr (assoc 40 (entget (car basecir)))))
   (setq cir2 (entsel "\n選擇另一個圓: "))
   (while (null cir2)
          (princ "\n您未選到圖元, 請再選擇一次...")
          (setq cir2 (entsel "\n選擇另一個圓: "))
   )
   (setq cir2_cen (cdr (assoc 10 (entget (car cir2)))))
   (command "vslide" (strcat powdesign_sld_path "2cir"))
   (setq cirang (getangle "\n輸入角度Ａ: "))
   (while (null cirang)
          (princ "\n您未輸入角度, 請再輸入一次...")
          (setq cirang (getangle "\n輸入角度Ａ: "))
   )
   (setq cirqty (getint "\n等分圓的數目: "))
   (while (null cirqty)
          (princ "\n您未輸入數目, 請再輸入一次...")
          (setq cirqty (getint "\n等分圓的數目: "))
   )
   (setq cirrad (getint "\n等分圓的半徑: "))
   (while (null cirrad)
          (princ "\n您未輸入半徑, 請再輸入一次...")
          (setq cirrad (getint "\n等分圓的半徑: "))
   )
   (redraw)
   (setq cenline_ang (angle basecir_cen cir2_cen))
   (setq s_ang (- cenline_ang cirang))
   (setq ang_per (/ (* cirang 2) (- cirqty 1)))
   (setvar "osmode" 0)
   (repeat cirqty
           (command "circle" (polar basecir_cen s_ang basecir_rad) cirrad)
           (setq s_ang (+ s_ang ang_per))
   )
   (setvar "osmode" oldos)
   (setq *error* olderr)
   (SETQ FFF nil))
   (princ)
)



;;trap_dir********************************************************************************************

(defun trap_dir(ds L / cmdecho_v osmode_v #sdtobd_flag #ang oker #readdata DE2 angtemp)
       
       (setq cmdecho_v (getvar "cmdecho"))
       (setq osmode_v (getvar "osmode"))
       (setq aunits_v (getvar "aunits"))
       (setq auprec_v (getvar "auprec"))
       (setvar "osmode" 0)
       (setvar "cmdecho" 0)
       (setvar "aunits" 0)
       (setvar "auprec" 8)
       (setq #sdtobd_flag 1)
       (setq #ang 0)
       (setq oker 0)
       (setq #path_dcl Powdesign_DCL_PATH)
       (if (findfile (strcat powdesign_data_path "trap_dir.dat"))
           (setq #readdata (getfile_value&trap_dir (strcat powdesign_data_path "trap_dir.dat")))
           (alert (strcat (strcat powdesign_data_path "trap_dir.dat") "此檔案不存在!!"))
       );if      
       (all_data&trap_dir #readdata)
       (actdcl (strcat #path_dcl "trap_dir") "trap_dir")
       
       (show_sld&trap_dir "trapsld" "trap_dir2" -2)
       (to_boxdata&trap_dir)
       (action_tile "bdtosd" "(setq #sdtobd_flag 1)(show_sld&trap_dir \"trapsld\" \"trap_dir2\" -2)")
       (action_tile "sdtobd" "(setq #sdtobd_flag 0)(show_sld&trap_dir \"trapsld\" \"trap_dir1\" -2)")
       (action_tile "traplst" "(ltd_edit_link&trap_dir)")  
       (action_tile "accept" "(setq oker 1)(setq #ang (get_tile \"trapang\"))(done_dialog)")
       (action_tile "cancel" "(setq oker 0)(done_dialog)(unload_dialog dcL_id)")
       (start_dialog)
       (if (= oker 1)
           (progn
                (if (= #sdtobd_flag 0)
                    (progn
                         (setq angtemp (/ (/ (*  (atof #ang) 22) 7) 180))
                         (if (< (atof #ang) 90)
                             (progn
                                 
                                  (setq DE2 (+ ds (* (/ (* (sin angtemp) L) (cos angtemp) ) 2)))
                             );progn
                             (progn
                                  (alert "不合理錐度(大於等於90度)!!")
                                  (exit)
                             );progn  
                         );if  
                    );progn
                    (progn
                         (setq angtemp (/ (/ (*  (atof #ang) 22) 7) 180))
                         (if (< (atof #ang) 90)
                             (progn
                                 (setq DE2 (- ds (* (/ (* (sin angtemp) L) (cos angtemp) ) 2)))
                             );progn
                             (progn
                                  (alert "不合理錐度(大於等於90度)!!")
                                  (exit)
                             );progn  
                         );if  
                         (if (< de2 0)
                             (progn
                                  (alert "錯誤!! (直逕小, 錐度太大 ,造成交錯)")
                                  (exit)
                             );progn  
                         );if  
                    );progn
                );if
           );progn
       );if
       (setvar "cmdecho" cmdecho_v)
       (setvar "osmode" osmode_v)
       (setvar "aunits" aunits_v)
       (setvar "auprec" auprec_v)
       (princ)
       de2
  );defun

    
(defun all_data&trap_dir(g_list / all_list  mm g_data all_list1) 
     (setq all_list nil)
     (setq all_list1 nil)
     (if (/= g_list nil)
         (foreach mm g_list
               (setq mm (read mm))
               (setq g_data nil)
               (setq g_data (list (strcat (car mm) "(" (cadr mm) ")") mm))
               (setq all_list (append all_list (list g_data)))
               (setq all_list1 (append all_list1 (list (strcat (car mm) "(" (cadr mm) ")") )))
         );foreach
     );if
     (if (/= all_list1 nil)
         (setq all_list1 (acad_strlsort all_list1))
     );if  
     (setq #group_list all_list1)
     (setq #all_data_group_list all_list)
);defun  
     
       
(defun show_sld&trap_dir(key sldname col / x y lacol newcol col_v)
     
     (setq x (dimx_tile key))
     (setq y (dimy_tile key))
    
     (start_image key)
     (fill_image 0 0 x y  col)
     
     (slide_image 0 0 x y (strcat Powdesign_sld_PATH sldname))
     (end_image)
    
);defun



(defun getfile_value&trap_dir(fname / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert (strcat fname "檔案不存在!!"))
                (exit)
           ) ;progn
    
       );if
       (setq needdata nil)
    
       (while (setq data (read-line ff))
            
            (if (/= (setq data (str_trim_blank&trap_dir data)) "")
                (setq needdata (append needdata (list data)))
            );if  
       );while
       (close ff)
       needdata
  
);defun

(defun to_boxdata&trap_dir(/ mm s_num s_word s_postword)
        (if (/= #group_list "")
            (progn
                 (start_list "traplst" 3)
                 (mapcar 'add_list #group_list)
                 (end_list)
            );progn
        );if  
 );defun

 (defun ltd_edit_link&trap_dir(/ ltd_no ltd_word ang)
         (setq ltd_no (get_tile "traplst"))
         (setq ltd_word (nth (atoi ltd_no) #group_list))
         (setq ang (cadadr (assoc ltd_word #all_data_group_list)))
         (set_tile "trapang" ang)
       
 );defun


 (defun str_trim_blank&trap_dir(str / lprt rprt retstr)
     (setq Lprt 1)
     (setq rprt (strlen str))
     (while (= (substr str Lprt 1) " ")
            (setq Lprt (1+ Lprt))
     );while
     (while (and (> rprt 0)
                 (= (substr str rprt 1) " ")
            );and                
            (setq rprt (1- rprt))
     );while
     (if (> lprt rprt)
         (setq retstr "")
         (setq retstr (substr str Lprt (1+ (- rprt Lprt))))
     );if  
     retstr
);defun

;;**********************************************************************************    

  

          
