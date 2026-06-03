;;;
;;;┌────────────────────────────────┐
;;;│  程  式 :desinger版                                            │
;;;│  主程式 :creatblk                                              │
;;;│  日  期 :89.2.6                                                │
;;;│  姓  名 :jacky                                                 │
;;;│  對話框 :                                                      │
;;;│  方  法 :                                                      │
;;;│  相關檔案:sub numList                                          │
;;;└────────────────────────────────┘
(defun c:creatblk(/ bname bly abc yesno insp ent )
    (setq cmdecho_v (getvar "cmdecho"))
    (setvar "cmdecho" 0)
    (setq bname nil)
    ;(setq bname (getstring "\n輸入圖塊名稱: "))
    (inputdata)
    (if (/= bname nil)
        (progn 
           (setq bly (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcase bname)))))
           (if (/= nil bly)
	      (progn 
                 (princ (strcat "\n圖面上已存在" bname " 圖塊, 因此不准建立! "))
	      );progn  
              (progn
                 (setq abc (tblsearch "BLOCK" bname))
                 (if (/= nil abc)
                    (progn
                       (initget "Yes No")
                       (setq yesno (getkword (strcat "\n圖塊 " bname "已經存在. 是否重新定義? [是(Y)/否(N)] <N>:")))
                       (if (= "Yes" yesno)
                          (progn
	                     ;(setq insp (getpoint "\n指定插入基準點: "))
			     (setq insp '(0 0 0))
                             (princ "\n選取物件: ")
                             (setq ent (ssget  '((-4 . "<NOT")(0 . "INSERT")(-4 . "NOT>"))))
			     (if (/= ent nil)
			         (progn
                                      (command "block"　bname "y" insp ent "" )
                                      (command "insert" bname insp "1" "1" "0")
                                      (princ (strcat "\n圖塊 " bname " 建立完成! "))
				 );progn
			         (progn
				      (alert (strcat "\n未建立 " bname "圖塊!"))
				 );progn  
			     );if  
                          );progn
                       );if
                    );progn
                    (progn
                       ;(setq insp (getpoint "\n指定插入基準點: "))
		       (setq insp '(0 0 0))
                       (princ "\n選取物件: ")
                       ;(setq ent (ssget))
		       (setq ent (ssget  '((-4 . "<NOT")(0 . "INSERT")(-4 . "NOT>"))))  
		       (if (/= ent nil)
			   (progn
			        (command "block"　bname insp ent "" )
                                (command "insert" bname insp "1" "1" "0")
                                (princ (strcat "\n圖塊 " bname " 建立完成! "))
			   );progn
			   (progn
				(alert (strcat "\n未建立 " bname "圖塊!"))
			   );progn
		       );if	 
                    );progn
                  );if
               );progn
            );if
      );progn
    );if
    (princ)
    (setvar "cmdecho" cmdecho_v)
    (princ)
);defun


;;舊block加入新圖元
(defun c:addent(/ newent lastent blk entdata typ bname insp oldgrp)
     (princ "\n選取物件: ")
     (setq newent (ssget))
     (setq lastent (entlast))
     (setq blk (entsel "\n選取舊block:"))
     (while (null blk)
       (princ "\n未選到圖元! 請再選取一次!!")
       (setq blk (entsel "\n選取舊block:"))
     );while
     (setq entdata (entget (car blk)))
     (setq typ (cdr (assoc 0 entdata)))
     (if (= "INSERT" (cdr (assoc 0 entdata)))
        (progn
          (setq bname (cdr (assoc 2 entdata)))
          (setq insp (cdr (assoc 10 entdata)))
          (setq oldgrp (colblkent (car blk)))
          (command "block" bname "y" insp oldgrp newent "")
          (command "insert" bname insp "1" "1" "0")
          (princ (strcat "\n新圖塊 " bname " 建立完成! "))
        );progn
        (princ "\n您選的圖元不是 block!")
     );if
)

(defun colblkent(blkname / newgrp ent)
   (setq newgrp (ssadd))
   (command "explode" blkname)
   (setq ent (entnext lastent))
   (while ent
     (setq newgrp (ssadd ent newgrp))
     (setq ent (entnext ent))
   );while
   newgrp
)


(defun inputdata(/ partname pview aview ans partname_i partname_char sepcode)
     
     (setq partname "")
     (setq pview nil)
     (setq aview nil)
     (setq partname (getstring "\n輸入零件名稱: "))
     (setq sepcode (vgetfile_val&crblock (strcat powdesign_PATH "system.ini") "分隔碼 (零件名稱與視圖代號間)"))
     (if (and  (/= sepcode nil)
	       (/= (read sepcode) nil)
	 );and      
         (progn
             (setq sepcode   (car (read sepcode)))
	 );progn
         (progn
	      (alert "\n 不合理分隔碼 (零件名稱與視圖代號間)")
	      (exit)
	 );progn
     );if
     
     ;(setq sepcode (getstring "\n輸入分隔碼 (零件名稱與視圖代號間): "))
     (setq partname_i 1)
     (setq partname_char "")
     (while (and (/= partname nil)
                 (/= (setq partname_char (substr partname partname_i 1)) "")
            );and
            (if (= partname_char sepcode)
	        (progn
	             (setq partname nil)
		     (alert (strcat "\n零件名稱不可含 \"" sepcode "\" 字元!!"))
		);progn  
	    );if
            (setq partname_i (1+ partname_i))
     );while   
     (if (/= partname "")
         (progn
              (initget "Yes No")
              (setq ans (getkword "\n是否為輔助視圖(Y/N)? (預設值為 N)"))
              (if (= "Yes" ans)
                  (progn
		      (initget  1 "U D F B L R")
                      (setq pview    (getkword "\n此圖塊為那一視圖之輔助視圖? 上視圖(U)\\下視圖(D)\\前視圖(F)\\後視圖(B)\\左視圖(L)\\右視圖(R): "))
	              (setq aview    (getstring "\n輸入輔助視圖代號?"))
	              (setq bname    (strcat partname sepcode pview  aview))
		      (setq bname    (strcase bname))
		    
	          );progn  
                  (progn
		      (initget  1 "U D F B L R") 
                      (setq pview    (getkword "\n此圖塊為 上視圖(U)\\下視圖(D)\\前視圖(F)\\後視圖(B)\\左視圖(L)\\右視圖(R):  "))
	              (setq bname    (strcat partname sepcode pview))
		      (setq bname    (strcase bname))
	          );progn
              );if
	  );progn
          (progn
	       (alert "\n零件名稱未輸入或錯誤!!")
	  );progn  
     );if  
);defun  
  
(defun vgetfile_val&crblock(fname initxt / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "system.ini檔案不存在")
                (exit)
           ) ;progn
    
       );if
       (setq #textdef initxt)
       (setq needdata nil)
       (setq #downdata nil)
 
 (while (setq data (read-line ff))
    
    (setq #downdata (cons data #downdata))
    (if (/= nil (setq txtid (get_word data "=")))
      (progn
        (setq objdata (strcase (substr data 1 (- txtid 1))))
        (if (= objdata initxt)
            (progn
                 (setq dd data needdata (substr data (1+ txtid)) data nil)
                 (setq #downdata (cdr #downdata))
                 (setq #upperdata (reverse #downdata))
                 (setq #downdata nil)
            )  
           
        );if
      );progn
     
    );if
  );while
  (setq #downdata (reverse #downdata))
  (close ff)
  (setq a (list needdata))
  needdata
  
);defun  