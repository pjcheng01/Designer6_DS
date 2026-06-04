;;;
;;畫雙圓鍵槽 slot1
;;畫雙圓鍵槽 slot2
;;畫雙圓鍵槽 slot3
;;畫雙圓鍵槽 slot4
;;畫雙圓鍵槽 slot5
;;軸銑雙邊   lc
;;==========================================================================================================
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 軸銑雙邊                                                                      ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:lc()
    (setvar "cmdecho" 0)
    (actdcl (strcat powdesign_dcl_path "drawmech") "lc")
    (setq scal (getvar "dimscale"))
    (set_tile "l" (rtos (* 3 scal) 2 2))
    (show_sld "isosld" (strcat powdesign_sld_path "lc"))
    (show_sld "2dsld" (strcat powdesign_sld_path "lccen1"))
    (action_tile "cenline" "(centerline_yesno)")
    (action_tile "accept" "(lc_ok)")
    (action_tile "cancel" "(done_dialog)")

    (start_dialog)
    (unload_dialog dcl_id)
    (if lc_flag (draw_lc d w))
    (setvar "cmdecho" 1)
    (PRINC)
)
(defun lc_ok()
   (setq w (get_tile "w"))
   (setq d (get_tile "d"))
   (setq l (get_tile "l"))
   (setq typ (get_tile "cenline"))
   (setq cenline (get_tile "cenline"))
   (cond
     ((= "" w) (set_tile "error" "未輸入 W 值!"))
     ((= "" d) (set_tile "error" "未輸入 D 值!"))
     ((and (= "1" typ) (= "" l))(set_tile "error" "未輸入 L 值!"))
     ((> (atof w) (atof d))(set_tile "error" "錯誤: D 值不可大於 W值 !"))
     (T (setq lc_flag t d (atof d) w (atof w))(done_dialog))
   )
)

(defun centerline_yesno()
   (setq typ (get_tile "cenline"))
   (if (= typ "0")
    (progn
      (show_sld "2dsld" (strcat powdesign_sld_path "lccen0"))
       (mode_tile "l" 1)
    )
    (progn
       (show_sld "2dsld" (strcat powdesign_sld_path "lccen1"))
       (mode_tile "l" 0)
    )
   )
)

(defun draw_lc(d w / y p1 p2 p3 p4 p5 p6 p7 p102 p103 p104 p105 h a ang)
  (setvar "cmdecho" 0)
  (setq p1 (getpoint "\n選擇插入點: "))
  (setq h (sqrt (- (expt (* d 0.5) 2) (expt (* w 0.5) 2)))
        a (atan (/ (* h 2) w))
        ang (getangle p1 "\n旋轉角度 <0>: ")

  )
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
  (if (= ang nil) (setq ang 0))
  (setq p5 (polar p1 (+ (+ a (* pi 0.5)) ang) (* d 0.5))
        p2 (polar p5 (+ (- (* pi 0.5)) ang) w)
        p3 (polar p2 ang (* h 2))
        p4 (polar p3 (+ (* pi 0.5) ang) w)
        p6 (polar p1 (+ pi ang) (* d 0.5))
        p7 (polar p6 ang d))
  (command "arc" p5 p6 p2
           "line" p2 p3 ""
           "arc" p3 p7 p4
           "line" p4 p5 "")
  (if (= "1" typ)
    (progn
      (setq l (atof l))
      (setq hc1 (polar p1 ang (+ (* d 0.5) l))
            hc2 (polar p1 (+ pi ang) (+ (* d 0.5) l))
            vc1 (polar p1 (+ (* 0.5 pi) ang) (+ (* d 0.5) l))
            vc2 (polar p1 (+ (* 1.5 pi) ang) (+ (* d 0.5) l)))
      (c:&cl&)
      (command "line" hc1 hc2 "" )
      (command "line" vc1 vc2 "")
      (c:&sl&)
    );progn
  );if
  (setvar "osmode" oldosmode)
  (setvar "cmdecho" 1)
  (princ)
)



;;╭════════════════════════════════════════════╮
;;║設計日期: 1998. 6. 26                                                                   ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 畫雙圓鍵槽                                                                    ║
;;║相關檔案:                                                                               ║
;;╰════════════════════════════════════════════╯
(defun c:slot5(/ p1 p2 p3 p4 p5 p6 p7 p102 p103 p104 p105 y r d ang)
   (setvar "cmdecho" 0)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
   (setq p1 (getpoint "\n選擇插入點: "))
  (if p1 (progn
    (setq r (getdist "\n輸入半徑: "))
    (while (null r)
      (princ "\n未輸入半徑, 請再輸入一次!")
      (setq r (getdist "\n輸入半徑: "))
    )
    (setq d (getdist p1 "\n輸入鍵總長: "))
    (while (null d)
      (princ "\n未輸入鍵總長, 請再輸入一次!")
      (setq d (getdist p1 "\n輸入鍵總長: "))
    )
   (while (< d (* 2.0 r))
     (princ (strcat "\n資料輸入不正確! 鍵總長不可小於 " (rtos (* r 2) 2 2) " 請再輸入一次 !"))
     (setq d (getdist p1 "\n輸入鍵總長: "))
     (while (null d)
       (princ "\n未輸入鍵總長, 請再輸入一次!")
       (setq d (getdist p1 "\n輸入鍵總長: "))
     )
   )
   (setq ang (getangle p1 "\n輸入旋轉角度 <0>: ") )
   (if (or (= ang nil) (= ang 0)) (setq ang 0))
   (setq oldosmode (getvar "osmode"))
   (setvar "osmode" 0)
   (setq p2 (polar p1 ang r))
   (setq p3 (polar p2 ang (- d (* 2 r))))
   (setq p4 (polar p2 (+ (* pi 0.5) ang ppss) r)
         p5 (polar p2 (+ (- (* pi 0.5)) ang ppss) r)
         p6 (polar p5 ang (- d (* r 2)))
         p7 (polar p4 ang (- d (* r 2))))
   (command "arc" "c" p2 p4 p5)
   (command "line" p5 p6 "")
   (command "arc" "c" p3 p6 p7)
   (command "line" p7 p4 "")
   (setvar "osmode" oldosmode)
   ))
   (setvar "cmdecho" 1)
 ;; removed FFF
   (princ)
)
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 畫雙圓鍵槽                                                                    ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:slot4(/ y p1 p2 p3 p4 p5 p6 p7 p102 p103 p104 p105 r d ang)
   (setvar "cmdecho" 0)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
    (setq p1 (getpoint "\n輸入插入點: "))
  (if p1 (progn
    (setq r (getdist "\n輸入半徑: "))
    (while (null r)
      (princ "\n未輸入半徑, 請再輸入一次!")
      (setq r (getdist "\n輸入半徑: "))
    )
    (setq d (getdist p1 "\n輸入鍵總長: "))
    (while (null d)
      (princ "\n未輸入鍵總長, 請再輸入一次!")
      (setq d (getdist p1 "\n輸入鍵總長: "))
    )
   (while (< d (* 2.0 r))
     (princ (strcat "\n資料輸入不正確! 鍵總長不可小於 " (rtos (* r 2) 2 2) " 請再輸入一次 !"))
     (setq d (getdist p1 "\n輸入鍵總長: "))
     (while (null d)
       (princ "\n未輸入鍵總長, 請再輸入一次!")
       (setq d (getdist p1 "\n輸入鍵總長: "))
     )
   )
   (setq ang (getangle p1 "\n輸入旋轉角度 <0>: ") )
   (if (or (= ang nil) (= ang 0)) (setq ang 0))
   (setq oldosmode (getvar "osmode"))
   (setvar "osmode" 0)
   (setq p2 (polar p1 (+ pi ang) (/ (- d (* 2 r)) 2.0)))
   (setq p3 (polar p1 ang (/ (- d (* 2 r)) 2.0)))
   (setq p4 (polar p2 (+ (* pi 0.5) ang ppss) r)
         p5 (polar p2 (+ (- (* pi 0.5)) ang ppss) r)
         p6 (polar p5 ang (- d (* r 2)))
         p7 (polar p4 ang (- d (* r 2))))
   (command "arc" "c" p2 p4 p5)
   (command "line" p5 p6 "")
   (command "arc" "c" p3 p6 p7)
   (command "line" p7 p4 "")
   (setvar "osmode" oldosmode)
   ))
   (setvar "cmdecho" 1)
 ;; removed FFF
   (princ)
)
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 畫半圓鍵槽                                                                    ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:slot3(/ y p1 p2 p3 p4 p5 p6 p102 p103 p104 p105 r flag d1 d ang)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
   (setvar "cmdecho" 0)
   (setq p1 (getpoint "\n選擇插入點: "))
  (if p1 (progn
    (setq r (getdist "\n輸入半徑: "))
    (while (null r)
      (princ "\n未輸入半徑, 請再輸入一次!")
      (setq r (getdist "\n輸入半徑: "))
    )
   (setq d1 (getdist p1 "\n輸入鍵總長: "))
   (while (null d1)
     (princ "\n未輸入鍵總長, 請再輸入一次!")
     (setq d1 (getdist p1 "\n輸入鍵總長: "))
   )
   (while (< d1 r)
     (princ (strcat "\n資料輸入不正確! 鍵總長不可小於 " (rtos r 2 2) " 請再輸入一次 !"))
     (setq d1 (getdist p1 "\n輸入鍵總長: "))
     (while (null d1)
       (princ "\n未輸入鍵總長, 請再輸入一次!")
       (setq d1 (getdist p1 "\n輸入鍵總長: "))
     )
   )
   (setq d (- d1 r))
   (setq ang (getangle p1 "\n輸入旋轉角度 <0>: ") )
   (if (or (= ang nil) (= ang 0)) (setq ang 0))
   (setq oldosmode (getvar "osmode"))
   (setvar "osmode" 0)
   (setq p2 (polar p1 (+ (* pi 0.5) ang) r)
         p3 (polar p1 (+ (- (* pi 0.5)) ang) r)
         p4 (polar p3 ang d)
         p5 (polar p2 ang d)
         p6 (polar p1 ang d))
   (SETVAR "osmode" 0)
   (command "line" p2 p3 p4 "")
   (command "arc" "c" p6 p4 p5)
   (command "line" p5 p2 "")

   (setvar "osmode" oldosmode)
   ))
   ;; removed FFF
   (setvar "cmdecho" 1)(princ)
)
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 畫雙圓鍵槽                                                                    ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:slot2(/ y p p1 p2 p3 p4 p5 p6 p102 p103 p104 p105 flat r d)
   (setvar "cmdecho" 0)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
   (setq p1 (getpoint "\n輸入插入點: "))
  (if p1 (progn
   (setq r (getdist "\n輸入半徑: "))
   (while (null r)
     (princ "\n未輸入半徑, 請再輸入一次!")
     (setq r (getdist "\n輸入半徑: "))
   )
   (setq d (getdist p1 "\n輸入鍵總長: "))
   (while (null d)
     (princ "\n未輸入鍵總長, 請再輸入一次!")
     (setq d (getdist p1 "\n輸入鍵總長: "))
   )
   (while (< d (* 2.0 r))
     (princ (strcat "\n資料輸入不正確! 鍵總長不可小於 " (rtos (* r 2) 2 2) " 請再輸入一次 !"))
     (setq d (getdist p1 "\n輸入鍵總長: "))
     (while (null d)
       (princ "\n未輸入鍵總長, 請再輸入一次!")
       (setq d (getdist p1 "\n輸入鍵總長: "))
     )
   )
   (setq ang (getangle p1 "\n輸入旋轉角度 <0>: ") )
   (if (or (= ang nil) (= ang 0)) (setq ang 0))
   (setq oldosmode (getvar "osmode"))
   (setvar "osmode" 0)
   (setq p2 (polar p1 (+ (* pi 0.5) ang ppss) r)
         p3 (polar p1 (+ (- (* pi 0.5)) ang ppss) r)
         p4 (polar p3 ang (- d (* 2 r)))
         p5 (polar p2 ang (- d (* 2 r)))
         p6 (polar p1 ang (- d (* 2 r))))
   (SETVAR "osmode" 0)
   (command "arc" "c" p1 p2 p3)
   (command "line" p3 p4"")
   (command "arc" "c" p6 p4 p5)
   (command "line" p5 p2 "")
   (setvar "osmode" oldosmode)
   ))
   ;; removed FFF
   (setvar "cmdecho" 1)
   (princ)
)
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 畫雙圓鍵槽                                                                    ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:slot1()
   (setvar "cmdecho" 0)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
    (setq p1 (getpoint "\n請選擇插入點: "))
  (if p1 (progn
     (setq r (getdist "\n輸入半徑: "))
   (while (null r)
     (princ "\n未輸入半徑, 請再輸入一次!")
     (setq r (getdist "\n輸入半徑: "))
   )
   (setq d (getdist p1 "\n輸入中心距離: "))
   (while (null d)
     (princ "\n未輸入中心距離, 請再輸入一次!")
     (setq d (getdist p1 "\n輸入中心距離: "))
   )
   (setq ang (getangle p1 "\n旋轉角度<0>:") )
   (if (or (= ang nil) (= ang 0)) (setq ang 0))
   (setq oldosmode (getvar "osmode"))
   (setvar "osmode" 0)
   (setq p2 (polar p1 (+ (* pi 0.5) ang ppss) r)
         p3 (polar p1 (+ (- (* pi 0.5)) ang) r)
         p4 (polar p3 ang d)
         p5 (polar p2 ang d)
         p6 (polar p1 ang d))
   (command "arc" "c" p1 p2 p3)
   (command "line" p3 p4"")
   (command "arc" "c" p6 p4 p5)
   (command "line" p5 p2 "")
   (setvar "osmode" oldosmode)
   ))
   ;; removed FFF
   (setvar "cmdecho" 1)
   (princ)
)
