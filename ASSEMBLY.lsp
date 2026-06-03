;;;
;移動零件                 c:moveparts
;複製零件                 c:copyparts
;刪除零件                 c:delparts
;旋轉零件                 c:rotparts
;選擇整圖圖形               selallparts
;選擇局部圖形               selsome


;刪除零件
(defun c:delparts(/ alllent beselent beselent_def player set_partdef set_partref bol_partref bol_partdef ent_partref
		    ent_obj pnt_base pnt_move int_num)
        ;; 已移除加密狗判斷
        (progn ;; DraftSight: 移除加密狗 WHILE 迴圈
               (setvar "cmdecho" 0)
               (initget "S A P")
               (setq sora (getkword "刪除零件: 前次所選圖元(P)/單一範圍(S)/所有圖元<A>"))
               (cond
                  ((or (= "A" sora) (null sora)) (setq alllent (selallparts)))
                  ((= "S" sora) (setq alllent (selsome)))
                  (T (setq alllent (ssget "p")))
               )
	       ;;=============================================================
	(foreach player glst_lay (progn
	       (setq set_add (ssadd))
	       (setq set_lay (ssget "x" (list (cons 8 player))))
	       (setq int_i 0)
	       (repeat (sslength set_lay)
		       (setq ent_obj (ssname set_lay int_i))
		       (if ent_obj (if (ssmemb ent_obj alllent)(setq set_add (ssadd ent_obj set_add))))
		       (setq int_i (1+ int_i))
	       )
	       (setq beselent set_add)
	       (setq beselent_def beselent)
	       (setq bol_partref nil)
	       (setq bol_partdef nil)
	       ;;=================先排除所有真假資訊點========================
	       (if beselent (progn
		    (setq set_partdef (ssget "x" (list (cons 8 player)(cons 2 "partdef"))))
	            (setq set_partref (ssget "x" (list (cons 8 player)(cons 2 "partref"))))
		    (if set_partref (progn
		    	    (setq int_i 0)
			    (repeat (sslength set_partref)
			            (if (ssmemb (ssname set_partref int_i) beselent)(progn
			      	        (setq beselent (ssdel (ssname set_partref int_i) beselent))
					(setq ent_partref (ssname set_partref int_i))
					(setq bol_partref T)
				    ))
			      	    (setq int_i (1+ int_i))
			    )
	            ))
		    (if set_partdef (progn
			    (setq int_i 0)
			    (repeat (sslength set_partdef)
			            (if (ssmemb (ssname set_partdef int_i) beselent)(progn
			                ;;(setq beselent (ssdel (ssname set_partdef int_i) beselent))
					(setq bol_partdef T)
				    ))
			      	    (setq int_i (1+ int_i))
			    )
		    ))
	       ))
	       ;;=============================================================
	       (if bol_partref
		   (progn
               	      (command "erase" beselent "")
		      (setq set_partdef (ssget "x" (list (cons 8 player)(cons 2 "partdef"))))
		      (if set_partdef
		          (progn
			  	(setq ent_tmp1 (ssname set_partdef 0))
			    	(setq pnt_base (cdr (assoc 10 (entget ent_partref))))
			    	(setq pnt_move (cdr (assoc 10 (entget ent_tmp1))))
			    	(command "erase" ent_tmp1 "")
			    	(command "move" ent_partref "" pnt_base pnt_move)
			  )
		 	  (command "erase" ent_partref "")
		     )
		  )
		  (progn
		     (command "erase" beselent_def "")
		  )
	       )
	       ;;=============================================================
	       (setq #part_field_number "TAG7")
	       (if (or (null get_bomdata)(null addatt_tobomball))(load "manapart"))
	       (setq set_partref (ssget "x" (list (cons 8 player)(cons 2 "partref"))))
  	       (setq set_partdef (ssget "x" (list (cons 8 player)(cons 2 "partdef"))))
	       (if set_partdef   (setq int_num (+ 1 (sslength set_partdef)))(setq int_num 1))
  	       (if set_partref   (progn
			(setq ent_obj (ssname set_partref 0))
	     		(setq attdata_list (get_bomdata ent_obj))
  	     		(setq attdata_list (subst (list #part_field_number (itoa int_num))
	       		        	   (assoc #part_field_number attdata_list) attdata_list))
	     		(addatt_tobomball ent_obj attdata_list)
	       ))
	       ;;=============================================================
       ))
               (SETQ FFF nil)
       );while

)

;移動零件
(defun c:moveparts(/ allent beselent oldpt newpt)
        ;; 已移除加密狗判斷
        (progn ;; DraftSight: 移除加密狗 WHILE 迴圈
               (setvar "cmdecho" 0)
               (initget "S A P")
               (setq sora (getkword "移動零件: 前次所選圖元(P)/單一範圍(S)/所有圖元<A>"))
               (cond
                  ((or (= "A" sora) (null sora)) (setq beselent (selallparts)))
                  ((= "S" sora) (setq beselent (selsome)))
                  (T (setq beselent (ssget "p")))
               )
               (command "move" beselent "")
               (SETQ FFF nil)
       );while
)


;旋轉零件
(defun c:roteparts(/ allent beselent)
        ;; 已移除加密狗判斷
        (progn ;; DraftSight: 移除加密狗 WHILE 迴圈
               (setvar "cmdecho" 0)
               (initget "S A P")
               (setq sora (getkword "旋轉零件: 前次所選圖元(P)/單一範圍(S)/所有圖元<A>"))
               (cond
                  ((or (= "A" sora) (null sora)) (setq beselent (selallparts)))
                  ((= "S" sora) (setq beselent (selsome)))
                  (T (setq beselent (ssget "p")))
               )
               (command "rotate" beselent "")
               (SETQ FFF nil)
       );while
)

;複製零件
(defun c:copyparts(/ allent beselent player set_partdef set_partref pnt_bomp flt_bompx flt_bompy
		     alllent ent_obj set_lay pnt_base pnt_move)
        ;; 已移除加密狗判斷
        (progn ;; DraftSight: 移除加密狗 WHILE 迴圈
               (setvar "cmdecho" 0)
               (initget "S A P")
               (setq sora (getkword "複製零件: 前次所選圖元(P)/單一範圍(S)/所有圖元<A>"))
               (cond
                  ((or (= "A" sora) (null sora)) (setq alllent (selallparts)))
                  ((= "S" sora) (setq alllent (selsome)))
                  (T (setq alllent (ssget "p")))
               )
	(foreach player glst_lay (progn
	       (setq set_add (ssadd))
	       (setq set_lay (ssget "x" (list (cons 8 player))))
	       (setq int_i 0)
	       (repeat (sslength set_lay)
		       (setq ent_obj (ssname set_lay int_i))
		       (if ent_obj (if (ssmemb ent_obj alllent)(setq set_add (ssadd ent_obj set_add))))
		       (setq int_i (1+ int_i))
	       )
	       (setq beselent set_add)
	       ;;============先排除所有真假資訊點==================
	       (if beselent (progn
		    (setq set_partdef (ssget "x" (list (cons 8 player)(cons 2 "partdef"))))
	            (setq set_partref (ssget "x" (list (cons 8 player)(cons 2 "partref"))))
		    (if set_partref (progn
		    	    (setq int_i 0)
			    (repeat (sslength set_partref)
			            (if (ssmemb (ssname set_partref int_i) beselent)
			      	        (setq beselent (ssdel (ssname set_partref int_i) beselent))
				    )
			      	    (setq int_i (1+ int_i))
			    )
	            ))
		    (if set_partdef (progn
			    (setq int_i 0)
			    (repeat (sslength set_partdef)
			            (if (ssmemb (ssname set_partdef int_i) beselent)
			                (setq beselent (ssdel (ssname set_partdef int_i) beselent))
				    )
			      	    (setq int_i (1+ int_i))
			    )
		    ))
	       ))
	       ;;=================複製零件========================
	       (if (null pnt_base)
		   (progn
	           	(setq pnt_base (getpoint "\n指定基準點: "))
	           	(princ "\n指定位移的第二點: ")
		     	(command "copy" beselent "" pnt_base pause)
		     	(setq pnt_move (getvar "lastpoint"))
		   )
		   (progn
		        (command "copy" beselent "" pnt_base pnt_move)
		   )
	       )
	       ;;===============補上假資訊點======================
	       (if set_partref (progn
		    (setq ent_bomp (ssname set_partref 0))
		    (setq pnt_bomp (cdr (assoc 10 (entget ent_bomp))))
		    (setq flt_bompx (- (nth 0 pnt_bomp) (nth 0 pnt_base)))
		    (setq flt_bompy (- (nth 1 pnt_bomp) (nth 1 pnt_base)))
	            (setq pnt_move (getvar "lastpoint"))
		    (setq pnt_bomp (list (+ (nth 0 pnt_move) flt_bompx) (+ (nth 1 pnt_move) flt_bompy)))
	            (add_false_bomp_assembly ent_bomp pnt_bomp)
	       ))
       ))
       	       (command "regen")
               (SETQ FFF nil)
       );while
)
(defun add_false_bomp_assembly(ent_obj pnt_blk / blk_scal set_partdef)
  	(setq #part_field_number "TAG7");;資訊點的TAG7定義為數量;;SAM 2003.12.16
	(if (or (null get_bomdata)(null addatt_tobomball))(load "manapart"))
  	(setq curlayer (getvar "clayer"))
     	(setq curcolor (getvar "cecolor"))
     	(setq curltype (getvar "celtype"))
  	(setq player (cdr (assoc 8  (entget ent_obj))))
  	(setq col    (cdr (assoc 62 (tblsearch "LAYER" player))))
	(command "layer" "m" player "c" col player "")
  
  	(setq blk_scal (* (atof sys_ballpoint_size) (getvar "dimscale")))
  	(command "insert" (strcat powdesign_dwg_path "partdef") pnt_blk blk_scal blk_scal "0")
  	(setq set_partdef (ssget "x" (list (cons 8 player)(cons 2 "partdef"))));;假資訊點選集
  	(if set_partdef (progn
	     (setq int_num (+ 1 (sslength set_partdef)))
	     (setq attdata_list (get_bomdata ent_obj))
  	     (setq attdata_list (subst (list #part_field_number (itoa int_num))
	       		        (assoc #part_field_number attdata_list) attdata_list))
	     (addatt_tobomball ent_obj attdata_list)
	))
     	(command "color" curcolor)
    	(command "linetype" "s" curltyle "")
     	(command "layer" "s" curlayer "")
)
;鏡射零件
(defun c:mirparts(/ allent beselent player set_partdef set_partref pnt_bomp flt_bompx flt_bompy
		    alllent ent_obj set_lay pnt_base pnt_move str_rt)
        ;; 已移除加密狗判斷
        (progn ;; DraftSight: 移除加密狗 WHILE 迴圈
               (setvar "cmdecho" 0)
               (initget "S A P")
               (setq sora (getkword "鏡射零件: 前次所選圖元(P)/單一範圍(S)/所有圖元<A>"))
               (cond
                  ((or (= "A" sora) (null sora)) (setq alllent (selallparts)))
                  ((= "S" sora) (setq alllent (selsome)))
                  (T (setq alllent (ssget "p")))
               )
	       (initget "Yes No")
	       (setq str_rt (getkword "刪除來源零件[是(Y)/否(N)]:<N> "))
	       (if (null str_rt)(setq str_rt "No"))
	       ;;==================================
	(foreach player glst_lay (progn
	       (setq set_add (ssadd))
	       (setq set_lay (ssget "x" (list (cons 8 player))))
	       (setq int_i 0)
	       (repeat (sslength set_lay)
		       (setq ent_obj (ssname set_lay int_i))
		       (if ent_obj (if (ssmemb ent_obj alllent)(setq set_add (ssadd ent_obj set_add))))
		       (setq int_i (1+ int_i))
	       )
	       (setq beselent set_add)
	       ;;==================================
	       (if (and (= "No" str_rt) beselent) (progn
		    (setq set_partdef (ssget "x" (list (cons 8 player)(cons 2 "partdef"))))
	            (setq set_partref (ssget "x" (list (cons 8 player)(cons 2 "partref"))))
		    (if set_partref (progn
		    	    (setq int_i 0)
			    (repeat (sslength set_partref)
			            (if (ssmemb (ssname set_partref int_i) beselent)
			      	        (setq beselent (ssdel (ssname set_partref int_i) beselent))
				    )
			      	    (setq int_i (1+ int_i))
			    )
	            ))
		    (if set_partdef (progn
			    (setq int_i 0)
			    (repeat (sslength set_partdef)
			            (if (ssmemb (ssname set_partdef int_i) beselent)
			                (setq beselent (ssdel (ssname set_partdef int_i) beselent))
				    )
			      	    (setq int_i (1+ int_i))
			    )
		    ))
	       ))
	       ;;==================================
	       (if (null pnt_base)
		   (progn
	       		(setq pnt_base (getpoint "\n指定鏡射線的第一點:: "))
	       		(princ "\n指定鏡射線的第二點: ")
	       		(command "mirror" beselent "" pnt_base pause str_rt)
		     	(setq pnt_move (getvar "lastpoint"))
		   )
		   (progn
		        (command "mirror" beselent "" pnt_base pnt_move str_rt)
		   )
	       )
	       ;;==============================
	       (if set_partref (progn
		    (setq ent_bomp (ssname set_partref 0))
		    (setq pnt_bomp (cdr (assoc 10 (entget ent_bomp))))
		    (setq flt_dist (distance pnt_base pnt_bomp))
		    (setq flt_ang1 (+ (* 2 (- (angle pnt_base pnt_move)(angle pnt_base pnt_bomp))) (angle pnt_base pnt_bomp)))
		    (setq pnt_bomp (polar pnt_base flt_ang1 flt_dist))
		    
	            ;(setq pnt_tmp1 (inters pnt_bomp (polar pnt_bomp (* pi 0.0) 1) pnt_base pnt_move nil))
		    ;(setq flt_ang1 (angle pnt_tmp1 pnt_base))
		    ;(if (> flt_ang1 (* 0.5 pi))(setq flt_ang1 (- pi flt_ang1)))
		    ;(setq flt_ang2 (- pi flt_ang1 (* 0.5 pi)))
		    ;(setq pnt_tmp2 (inters pnt_bomp (polar pnt_bomp flt_ang2 1) pnt_base pnt_move nil))
		    ;(setq pnt_bomp (polar pnt_tmp2 flt_ang2 (distance pnt_tmp2 pnt_bomp)))
	            (add_false_bomp_assembly ent_bomp pnt_bomp)
	       ))
       ))
       	       (command "regen")
               (SETQ FFF nil)
       );while
)

;選擇整圖圖形
(defun selallparts(/ showlay besel set_sel showlay_list)
    (setq showlay (entsel "\n選擇圖形: "))
    (setq showlay (car showlay))
    (princ "\n或按 Enter 鍵結束/<選擇欲移動的零件層>: ")
    (setq showlay (cdr (assoc 8 (entget showlay))) aaa showlay)
    (if (not (member showlay showlay_list)) 
        (setq showlay_list (cons showlay showlay_list))
    )
    (setq set_sel (ssget "x" (list (cons 8 showlay))))
    (command "select" set_sel "")
    (setq besel (ssget "p"))
;    (setq ccc showlay)
    (princ showlay)
    (setq showlay (car (entsel "")))
    (while showlay
       (setq showlay (cdr (assoc 8 (entget showlay))) aaa (strcat aaa "," showlay))
       (if (not (member showlay showlay_list)) 
           (setq showlay_list (cons showlay showlay_list))
       )
       (command "select" "p" (ssget "x" (list (cons 8 showlay))) "")
       (setq showlay (car (entsel (strcat "," showlay))))
    )
    (setq glst_lay (reverse showlay_list))
    (ssget "p")
)

;選擇局部圖形
(defun selsome(/ besel allent sora p1 p2 liment count local_ent ent allent aaa showlay_list set_sel lst_lay)
    (setq showlay_list '())
    (setq showlay (entsel "\n選擇圖形: "))
    (setq showlay (car showlay))
    (princ "\n或按 Enter 鍵結束/<選擇欲移動的零件層>: ")
    (setq showlay (cdr (assoc 8 (entget showlay))) aaa showlay)
    (if (not (member showlay showlay_list)) 
        (setq showlay_list (cons showlay showlay_list))
    )
    (setq set_sel (ssget "x" (list (cons 8 showlay))))
    (command "select" set_sel "")
    (setq besel (ssget "p"))
    (princ showlay)
    (setq showlay (car (entsel "")))
    (while showlay
       (setq showlay (cdr (assoc 8 (entget showlay))) aaa (strcat aaa "," showlay))
       (if (not (member showlay showlay_list)) 
           (setq showlay_list (cons showlay showlay_list))
       )
       (command "select" "p" (ssget "x" (list (cons 8 showlay))) "")
       (setq showlay (car (entsel (strcat "," showlay))))
    )
    (setq allent (ssget "p"))
    (setq p1 (getpoint "\n指定範圍第一角點:")
          p2 (getcorner p1 "\n指定範圍對角點:"))
    (setq liment (ssget "c" p1 p2))
    (setq count 0)
    (setq local_ent (ssadd))
    (repeat (sslength liment)
       (setq ent (ssname liment count))
       (if (ssmemb ent allent) (setq local_ent (ssadd ent local_ent)))
       (setq count (1+ count))
    )
    (setq glst_lay (reverse showlay_list))
     local_ent
)

(defun c:crb()
   ;收集所有block name
   (princ)


);defun

; sys_ball_layer        :     指標圓球層
; defball_list          :  指標球定義=("1" "7" "0" "0" "3")
; sys_ball_yesno        :  指標球有無
; sys_ball_dia          :  指標球直徑
; sys_ballpoint_type    :  指標形式      ;; sys_balldonut_yesno   :  指線圓點有無
; sys_ballpoint_size    :  指標尺寸      ;  ; sys_balldonut_dia
; sys_balltxt_hei       :  指標球字高
(defun c:mb()
  (setq selent (entsel "\nball: "))
  (setq selent_data (entget (car selent)))
  (setq data_0 (cdr (assoc 0 selent_data)))
  (setq data_8 (cdr (assoc 8 selent_data)))
  (setq data_2 (cdr (assoc 2 selent_data)))
  (setq scal (getvar "dimscale"))
  (cond
    ((and (= "CIRCLE" data_0) (= data_8 sys_ball_layer))
       (princ "CIRCLE")
       (setq cir_ent (cdr (assoc -1 selent_data))                          ;;指標球
             circen (cdr (assoc 10 selent_data)))
       (setq txtp1  (polar circen 0 (* scal 0.4 (atof sys_ball_dia)))
             txtp2  (polar circen pi (* scal 0.4 (atof sys_ball_dia))))
       (setq txtgrp (ssget "c" txtp1 txtp2))
       (setq txt_ent (ssname txtgrp 0))                                    ;;箭號文字

       (setq linegrp (ssget "cp" (get_cir16pt ball_ent)))
       (setq line_ent (ssname linegrp 0))                                  ;;指標引線
    )
    ((and (= "TEXT" data_0) (= data_8 sys_ball_layer))        (princ "TEXT"))
    ((and (= "LINE" data_0) (= data_8 sys_ball_layer))        (princ "LINE"))
    ((and (= "INSERT" data_0) (= "PARTREF" (strcase data_2))) (princ "REFPT"))
    (T (princ "It is not"))


  );cond

);defun

(defun get_cir16pt(ent)
; (setq selent (entsel "\nball: ")
;       selent_data (entget (car selent))
  (setq selent_data (entget ent)
        ball_ent (cdr (assoc -1 selent_data))
        circen (cdr (assoc 10 selent_data))
        cirrad (cdr (assoc 40 selent_data))
        cp1 (polar circen 0 (+ 1 cirrad))
       cp2 (polar circen (/ pi 6) (+ 1 cirrad))
        cp3 (polar circen (* pi 0.25) (+ 1 cirrad))
       cp4 (polar circen (* (/ pi 6) 2)(+ 1 cirrad))
        cp5 (polar circen (* pi 0.5) (+ 1 cirrad))
       cp6 (polar circen (* (/ pi 6) 4) (+ 1 cirrad))
        cp7 (polar circen (* pi 0.75) (+ 1 cirrad))
       cp8 (polar circen (* (/ pi 6) 5) (+ 1 cirrad))
        cp9 (polar circen pi (+ 1 cirrad))
       cp10 (polar circen (* (/ pi 6) 7) (+ 1 cirrad))
        cp11 (polar circen (* pi 1.25) (+ 1 cirrad))
       cp12 (polar circen (* (/ pi 6) 8) (+ 1 cirrad))
        cp13 (polar circen (* pi 1.5) (+ 1 cirrad))
       cp14 (polar circen (* (/ pi 6) 10) (+ 1 cirrad))
        cp15 (polar circen (* pi 1.75) (+ 1 cirrad))
       cp16 (polar circen (* (/ pi 6) 11) (+ 1 cirrad)))
;  (command "pline" cp1 cp2 cp3 cp4 cp5 cp6 cp7 cp8 cp9 cp10 cp11 cp12 cp13 cp14 cp15 cp16 "c")
   (list cp1 cp2 cp3 cp4 cp5 cp6 cp7 cp8 cp9 cp10 cp11 cp12 cp13 cp14 cp15 cp16 cp1)

)
