;;;
(defun c:drawline()
   (setq Y (getvar "viewsize"))
   (setq p103 (polar dp (* pi 0.25) (/ Y 22))
         p102 (polar dp (+ (* pi 0.25) pi) (/ Y 22))
         p104 (polar dp (* pi 0.75) (/ Y 22))
         p105 (polar dp (- (* pi 0.25)) (/ Y 22))
   )
   (grdraw p102 p103 12)
   (grdraw p104 p105 12)
)
(defun c:f-i()
   (setq ans (strcase (getstring "\n改變小數位數? <NO>/YES: ")))
   (if (or (= ans "Y") (= ans "YES"))
     (progn
        (setq txtsel (entlast)
              txtdata (entget txtsel)
              40txt (cdr (assoc 40 txtdata))
              1txt (cdr (assoc 1 txtdata))
              50txt (cdr (assoc 50 txtdata))
              72txt (cdr (assoc 72 txtdata))
              10txt (cdr (assoc 10 txtdata))
              11txt (cdr (assoc 11 txtdata))
              hi-txt (rtos 40txt 2 3)
              ang-txt (rtos (/ (* 50txt 180) pi) 2 3)
        )
        (prompt "\n      ")
        (prompt "\n小數幾位: 0.(0)/1.(0.0)/2.(0.00)/3.(0.000)....!!")
        (setq choose (getint "\n0/ 1/ 2/ 3: "))
     (if (= choose nil) (setq choose remem))
     (prompt "\n      ")
     (setq check (ascii 1txt))
     (cond
       ((= check 37)
         (setq 1txt (substr 1txt 4))
         (cond
           ((= choose 0) (setq new-txt (strcat "%%c" (rtos (atof 1txt) 2 0))))
           ((= choose 1) (setq new-txt (strcat "%%c" (rtos (atof 1txt) 2 1))))
           ((= choose 2) (setq new-txt (strcat "%%c" (rtos (atof 1txt) 2 2))))
           ((= choose 3) (setq new-txt (strcat "%%c" (rtos (atof 1txt) 2 3))))
         );cond
       )
       ((or (= check 114) (= check 82))
          (setq 1txt (substr 1txt 2))
          (cond
            ((= choose 0) (setq new-txt (strcat "R" (rtos (atof 1txt) 2 0))))
            ((= choose 1) (setq new-txt (strcat "R" (rtos (atof 1txt) 2 1))))
            ((= choose 2) (setq new-txt (strcat "R" (rtos (atof 1txt) 2 2))))
            ((= choose 3) (setq new-txt (strcat "R" (rtos (atof 1txt) 2 3))))
          );cond
       )
       (T
          (setq txt-num (strlen 1txt)
                check2 (substr 1txt txt-num))
          (if (or (= check2 "d") (= check2 "D"))
           (progn
             (setq 1txt (substr 1txt 1 (- txt-num 3)))
             (cond
               ((= choose 0) (setq new-txt (strcat (rtos (atof 1txt) 2 0) "%%d")))
               ((= choose 1) (setq new-txt (strcat (rtos (atof 1txt) 2 1) "%%d")))
               ((= choose 2) (setq new-txt (strcat (rtos (atof 1txt) 2 2) "%%d")))
               ((= choose 3) (setq new-txt (strcat (rtos (atof 1txt) 2 3) "%%d")))
             );cond
           );progn
           (progn
             (cond
               ((= choose 0) (setq new-txt (rtos (atof 1txt) 2 0)))
               ((= choose 1) (setq new-txt (rtos (atof 1txt) 2 1)))
               ((= choose 2) (setq new-txt (rtos (atof 1txt) 2 2)))
               ((= choose 3) (setq new-txt (rtos (atof 1txt) 2 3)))
             );cond
           );progn
          );if
       )
     );cond
        (entdel txtsel)
        (if (= 72txt 2)
              (command "text" "r" 11txt hi-txt ang-txt new-txt)
              (command "text" 10txt hi-txt ang-txt new-txt)
        );if
     );progn
   );if
   (princ)
)
(defun c:setorg()
   ;; DraftSight: 移除加密狗 WHILE 迴圈
  (prompt "\n原點..")
  (setq $$$org (getpoint ": "))
  (setq org1 (strcat "(" (rtos (car $$$org)) "," (rtos (cadr $$$org)) ")"))
  (princ org1)
  (setvar "orthomode" 1)
  (setq basep $$$org)
  (setq $$DP (getpoint basep "\n尺寸位置: "))
  (setq $$ang (angle basep $$DP)
        pend $$DP
  )
  (cond
    ((= $$ang 0)
     (setq YR-$$$org $$$org
           YR-pend $$DP
           pend nil
           YR-dtxt-pc (polar YR-pend $$ang scale)
           YR-dtxt-p (polar $$DP (* pi 0.5) scale))
     (command "text" "r" YR-dtxt-p (* 3 scale) "0" "0")
     (command "line" (polar basep $$ang (getvar "dimscale")) YR-pend "")
    )
    ((= $$ang (* pi 0.5))
     (setq XU-$$$org $$$org
           XU-pend $$DP
           pend nil
           XU-dtxt-pc (polar XU-pend $$ang scale)
           XU-dtxt-p (polar $$DP pi scale))
     (command "text" "r" XU-dtxt-p (* 3 scale) "90" "0")
     (command "line" (polar basep $$ang (getvar "dimscale")) XU-pend "")
    )
    ((= $$ang pi)
     (setq YL-$$$org $$$org
           YL-pend pend
           pend nil
           YL-dtxt-pc (polar YL-pend $$ang scale)
           YL-dtxt-p (polar $$DP (* pi 0.5) scale))
     (command "text" YL-dtxt-p (* 3 scale) "0" "0")
     (command "line" (polar basep $$ang (getvar "dimscale")) YL-pend "")
    )
    (T
     (setq XD-$$$org $$$org
           XD-pend pend
           pend nil
           XD-dtxt-pc (polar XD-pend $$ang scale)
           XD-dtxt-p (polar $$DP pi scale))
     (command "text" XD-dtxt-p (* 3 scale) "90" "0")
     (command "line" (polar basep $$ang (getvar "dimscale")) XD-pend "")
    )
  );cond
   ;; removed FFF
)
(defun c:reorg()
  (setq entity (car (entsel "\n選擇新尺寸線: "))
        entdata (entget entity)
        10ent (cdr (assoc 10 entdata))
        11ent (cdr (assoc 11 entdata))
        $$ang (angle 10ent 11ent)
  )
  (cond
     ((= $$ang 0) (setq $$$org YR-$$$org pend YR-pend))
     ((= $$ang pi) (setq $$$org YL-$$$org pend YL-pend))
     ((= $$ang (* pi 0.5)) (setq $$$org XU-$$$org pend XU-pend))
     (T (setq $$$org XD-$$$org pend XD-pend))
  )
)
(defun c:tr-pend()
   (cond
      ((= $$ang 0) (setq pend YR-pend))
      ((= $$ang (* pi 0.5)) (setq pend XU-pend))
      ((= $$ang pi) (setq pend YL-pend))
      ((= $$ang (* pi 1.5)) (setq pend XD-pend))
   )
)
(defun c:mdim()
;(PRINC "\nSYSTEM DEVOLPED: POWERTECH INFORMATION ENGINEERING CORP")
   ;; DraftSight: 移除加密狗 WHILE 迴圈
 (setvar "attdia" 0)
 (setq scale (getvar "dimscale"))
 (setq old-unit (getvar "luprec"))
 (setvar "luprec" 3)
 (setq txt-height (* scale 3))
 (setvar "cmdecho" 0)
 (initget 1 "Continuous New Origin")
 (setq ans (strcase (getstring "\nC 繼續剛才方向/O 設定原點/<N 新尺寸方向>: ")))
 (if (= ans "O") (c:setorg))
 (if (or (= ans "N") (= ans "")) (c:reorg))
 (if (= ans "C") (prompt "\n繼續剛才方向......"))
 (setq bp (getpoint "\n尺寸基準點: "))
 (setvar "orthomode" 1)
;******* Y DIMENSION *********
 (while (and (or (= $$ang 0) (= $$ang pi)) (/= bp nil))
    (setq dp bp)
    (c:drawline)
    (initget 1 "Auto Free")
    (setq A&F (strcase (getstring "\n繪製尺寸線方式 ==> F 使用者自定 / <A 自動>: ")))
    (if (or (= A&F "F")(= A&F "FREE"))
      (progn
        (c:tr-pend)
        (setq bp-y (cadr bp)
              $$$org-y (cadr $$$org)
              dime (abs (- bp-y $$$org-y)))
        (setq dimtxt (getdist (strcat "\n尺寸文字 <" (rtos dime 2 3) ">: ")))
        (if (= dimtxt nil) (setq dimtxt dime))
        (if (= (fix dimtxt) dimtxt) (setq dimtxt (rtos (fix dimtxt) 2 0)) (setq dimtxt (rtos dimtxt 2 3)))
        (setq p1 bp)
        (setq p2 (getpoint p1 "\n到那一點: "))
        (command "line" (polar p1 (angle p1 p2) (getvar "dimscale")) p2 "")
        (while p2
           (setq p1 p2)
           (setq p2 (getpoint p1 "\n到那一點: "))
           (if (= p2 nil)
             (progn
                (setq pend (list (car pend) (cadr p1)))
                (command "line" p1 pend "")
                (if (= $$ang 0)
                   (progn
                     (setq dtxt-pc pend
                           dtxt-p (polar dtxt-pc (* pi 0.5) scale))
                      (command "text" "r" dtxt-p txt-height "0" dimtxt)
                      (c:f-I)
                   );progn
                   (progn
                      (setq dtxt-pc pend
                            dtxt-p (polar dtxt-pc (* pi 0.5) scale))
                      (command "text" dtxt-p txt-height "0" dimtxt)
                      (c:f-I)
                   );progn
                );if
             );progn
           (command "line" p1 p2 "")
           );if
        );while
      );progn
    );if
    (if (or (= A&F "") (= A&F "A") (= A&F "AUTO"))
      (progn
         (c:tr-pend)
         (setq pend (list (car pend) (cadr bp)))
         (setq bp-y (cadr bp)
               $$$org-y (cadr $$$org)
               dime (abs (- bp-y $$$org-y)))
         (setq dimtxt (getdist (strcat "\n尺寸文字 <" (rtos dime 2 3) ">: ")))
         (if (= dimtxt nil) (setq dimtxt dime))
         (if (= (fix dimtxt) dimtxt) (setq dimtxt (rtos (fix dimtxt) 2 0)) (setq dimtxt (rtos dimtxt 2 3)))
         (if (= $$ang 0)
            (progn
              (setq dtxt-pc pend
                    dtxt-p (polar dtxt-pc (* pi 0.5) scale))
              (command "line" (polar bp (angle bp pend) (getvar "dimscale")) pend "")
              (command "text" "r" dtxt-p txt-height "0" dimtxt)
              (c:f-I)
            );progn
            (progn
               (setq dtxt-pc pend
                     dtxt-p (polar dtxt-pc (* pi 0.5) scale))
               (command "line" (polar bp (angle bp pend) (getvar "dimscale")) pend "")
               (command "text" dtxt-p txt-height "0" dimtxt)
               (c:f-I)
            );progn
         );if
      );progn
    );if
    (setq bp (getpoint "\n尺寸基準點: "))
   (grdraw p102 p103 0)
   (grdraw p104 p105 0)
 );while
;******* X DIMENSION *********
 (while (and (or (= $$ang (* pi 0.5)) (= $$ang (* pi 1.5))) (/= bp nil))
    (setq dp bp)
    (c:drawline)
    (initget 1 "Auto Free")
    (setq A&F (strcase (getstring "\n繪製尺寸線方式 ==> F 使用者自定 / <A 自動>: ")))
    (if (or (= A&F "F")(= A&F "FREE"))
      (progn
        (c:tr-pend)
        (setq bp-x (car bp)
              $$$org-x (car $$$org)
              dime (abs (- bp-x $$$org-x)))
        (setq dimtxt (getdist (strcat "\n尺寸文字 <" (rtos dime 2 3) ">: ")))
        (if (= dimtxt nil) (setq dimtxt dime))
        (if (= (fix dimtxt) dimtxt) (setq dimtxt (rtos (fix dimtxt) 2 0)) (setq dimtxt (rtos dimtxt 2 3)))
        (setq p1 bp)
        (setq p2 (getpoint p1 "\nTo point: "))
        (command "line" (polar p1 (angle p1 p2) (getvar "dimscale")) p2 "")
        (while p2
           (setq p1 p2)
           (setq p2 (getpoint p1 "\n到那一點: "))
           (if (= p2 nil)
             (progn
                (setq pend (list (car p1) (cadr pend)))
                (command "line" p1 pend "")
                (if (= $$ang (* pi 0.5))
                   (progn
                     (setq dtxt-pc pend
                           dtxt-p (polar dtxt-pc pi scale))
                     (command "text" "r" dtxt-p txt-height "90" dimtxt)
                      (c:f-I)
                   );progn
                   (progn
                      (setq dtxt-pc pend
                            dtxt-p (polar dtxt-pc pi scale))
                      (command "text" dtxt-p txt-height "90" dimtxt)
                      (c:f-I)
                   );progn
                );if
             );progn
           (command "line" p1 p2 "")
           );if
        );while
      );progn
    );if
    (if (or (= A&F "") (= A&F "A") (= A&F "AUTO"))
      (progn
        (c:tr-pend)
         (setq pend (list (car bp) (cadr pend)))
         (setq bp-x (car bp)
               $$$org-x (car $$$org)
               dime (abs (- bp-x $$$org-x)))
         (setq dimtxt (getdist (strcat "\n尺寸文字 <" (rtos dime 2 3) ">: ")))
         (if (= dimtxt nil) (setq dimtxt dime))
         (if (= (fix dimtxt) dimtxt) (setq dimtxt (rtos (fix dimtxt) 2 0)) (setq dimtxt (rtos dimtxt 2 3)))
         (if (= $$ang (* pi 0.5))
            (progn
              (setq dtxt-pc pend
                    dtxt-p (polar dtxt-pc pi scale))
              (command "line" (polar bp (angle bp pend) (getvar "dimscale")) pend "")
              (command "text" "r" dtxt-p txt-height "90" dimtxt)
              (c:f-I)
            );progn
            (progn
               (setq dtxt-pc pend
                     dtxt-p (polar dtxt-pc pi scale))
               (command "line" (polar bp (angle bp pend) (getvar "dimscale")) pend "")
               (command "text" dtxt-p txt-height "90" dimtxt)
               (c:f-I)
            );progn
         );if
      );progn
    );if
    (setq bp (getpoint "\n尺寸基準點: "))
   (grdraw p102 p103 0)
   (grdraw p104 p105 0)
 );while
 (setvar "cmdecho" 1)
 (setvar "luprec" old-unit)
 (setvar "attdia" 1)
 (princ)
   ;; removed FFF
);defun
