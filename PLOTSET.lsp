;;;連續出圖

(defun c:draw_autoplot()

   ;   (setq a1 (ssget "x" (list (cons 2 "SA1"))))
   ;   (setq a1t (ssget "x" (list (cons 2 "SA1TZT"))))

    ;  (setq a2 (ssget "x" (list (cons 2 "SA2"))))
    ;  (setq a2t (ssget "x" (list (cons 2 "SA2TZT"))))

      (setq a3 (ssget "x" (list (cons 2 "A3"))))
      (setq a3t (ssget "x" (list (cons 2 "A3TZT"))))

      (setq a4 (ssget "x" (list (cons 2 "A4"))))
      (setq a4t (ssget "x" (list (cons 2 "A4TZT"))))

     ; (setq a4h (ssget "x" (list (cons 2 "SA4H"))))
     ; (setq a4ht (ssget "x" (list (cons 2 "SA4HTZT"))))

      (cond
       ; ((/= nil a0) (getsh_data a0)(setq tttxth sca))
       ; ((/= nil a0t)(getsh_data a0t)(setq tttxth sca))
       ; ((/= nil a1) (getsh_data a1)(setq tttxth sca))
       ; ((/= nil a1t)(getsh_data a1t)(setq tttxth sca))
       ; ((/= nil a2) (getsh_data a2)(setq tttxth sca))
       ; ((/= nil a2t)(getsh_data a2t)(setq tttxth sca))
        ((/= nil a3) (getsh_data a3)(setq tttxth sca))
        ((/= nil a3t)(getsh_data a3t)(setq tttxth sca))
        ((/= nil a4) (getsh_data a4)(setq tttxth sca))
        ((/= nil a4t)(getsh_data a4t)(setq tttxth sca))
       ; ((/= nil a4h) (getsh_data a4h)(setq tttxth sca))
       ; ((/= nil a4ht)(getsh_data a4ht)(setq tttxth sca))
        (t (setq tttxth (getvar "dimscale")))
      )

   ;   (setq tttxth (getvar "dimscale"))
      
      (cond
         ((< tttxth 1)
         (setq scl (rtos (fix (/ 1 tttxth)) 2 0)
                scl (strcat " " scl ":" "1"))
         )
         ((> tttxth 1)
          (setq scl (rtos (fix tttxth) 2 0))
          (if (>= (atof scl) 20) (setq pt_id 1))
          (setq scl (strcat " 1" ":" scl))

         )
         (T (setq scl "1:1"))
      )
    
      (cond
;         ((or (/= a0 nil) (/= a0t nil))(setq plot_flag 1 plotname "\\\\SAKURA\\PA0" shsize "ISO A0 - 841 x 1189 mm." paperst "L"))
;         ((or (/= a1 nil) (/= a1t nil))(setq plot_flag 1 plotname "\\\\SAKURA\\PA0" shsize "ISO A1 - 594 x 841 mm. (portrait)" paperst "L"))
;         ((or (/= a2 nil) (/= a2t nil))(setq plot_flag 1 plotname "\\\\SAKURA\\PA0" shsize "ISO A2 - 420 x 594 mm. (portrait)" paperst "L"))
         ((or (/= a3 nil) (/= a3t nil))(setq plot_flag 1 plotname "HP DeskJet 1120C Printer" shsize "A3 (297 x 420 公釐)" paperst "L"))
         ((or (/= a4 nil) (/= a4t nil))(setq plot_flag 1 plotname "HP DeskJet 1120C Printer" shsize "A4 (210 x 297 公釐)" paperst "L"))
;         ((or(/= a4h nil) (/= a4ht nil))(setq plot_flag 1 plotname "\\\\SAKURA\\A4" shsize "A4" paperst "L"))
         (t (setq plot_flag 0)(alert "無圖框可供辨識 ! 本圖檔取消出圖"))
      );cond



      (if (= plot_flag  1)                                ;;P => 直式
          (progn   
              (setq pt "a4.ctb")                        ;;L => 橫式
              (command "plot" "y" "" plotname shsize "m" paperst "n" "E" scl "中心點" "y" pt "y" "n" "n" "n" "y")
          )
      );if 

)

(defun getsh_data(grp)
   (setq sca nil
         ent (ssname grp 0)
         entdata (entget ent)
         shinsp (cdr (assoc 10 entdata))
         sca (cdr (assoc 41 entdata)))
)
