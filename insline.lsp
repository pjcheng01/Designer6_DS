(defun c:insline( / block_sz)
        (setvar "cmdecho" 0)
        (setq block_con nil block_sz nil)
        (cond 
              ((setq block_con (ssget "X" (list (cons 0 "INSERT")(cons 2 "A1tzt"))))
                (setq block_sz 1)
              )  
                ((setq block_con (ssget "X" (list (cons 0 "INSERT")(cons 2 "A2tzt"))))
                (setq block_sz 2)
              )  
                ((setq block_con (ssget "X" (list (cons 0 "INSERT")(cons 2 "A3tzt"))))
                (setq block_sz 3)
              )  
                ((setq block_con (ssget "X" (list (cons 0 "INSERT")(cons 2 "A4tzt"))))
                (setq block_sz 4)
              ) 
              (t   (setq block_sz nil))
        ) 
  	
  
  	
        (cond ((= 1 block_sz)(insdwg "A1L"))
	      ((= 2 block_sz)(insdwg "A2L"))
	      ((= 3 block_sz)(insdwg "A3L"))
	      ((= 4 block_sz)(insdwg "A4L"))
              (t (princ "1"))
        )
  	(setvar "cmdecho" 1)
);defun
(defun insdwg(na)

       (setq pnt_ins(cdr(assoc 10 (entget(ssname block_con 0)))))

       (setq flt_scl(cdr(assoc 41 (entget(ssname block_con 0)))))
       (setq os (getvar "osmode"))
       (setvar "osmode" 0)
       ;;(command ".insert" (strcat "\\\\W2000S2\\POWERTECH\\DESIGNER6\\SHEET\\" na) "s" flt_scl pnt_ins "0")
       (command ".insert" (strcat powdesign_path "SHEET\\" na) "s" flt_scl pnt_ins "0") 
       (command "explode" (entlast))
       (setvar "osmode" os)

);defun