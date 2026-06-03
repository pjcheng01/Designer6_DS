;;;
;;;
;;;
(defun c:laytoblk(/  bb_set flag laydata_list layname #all_lay_list pview pview_set mm  ent i entdata ment cLtype cClr obj)
     (setq bb_set (ssget "x"  (list (cons 0 "INSERT")(cons 2 "PARTREF"))))
     (command "erase" bb_set "")
     (command "explode" "all" )
     (setq attr_set (ssget "x"  (list (cons 0 "ATTDEF"))))
     (command "erase" ATTR_set "")          
     (setq flag t)
     (setq #all_lay_list nil)
     (while (setq laydata_list (tblnext "layer" flag))
          (setq flag nil)
          (setq layname (cdr (assoc 2 laydata_list)))
          (setq #all_lay_list (append #all_lay_list (list layname)))
     );while
     
     (initget  1 "U D F B L R")
     (setq pview    (getkword "\n此圖塊為那一視圖? 上視圖(U)\\下視圖(D)\\前視圖(F)\\後視圖(B)\\左視圖(L)\\右視圖(R): "))
     (princ "\n選擇視圖範圍:")
     ;(setq pview_set (ssget))
     (setq p1 (getpoint "\ninput first point:"))
     (setq p2 (getcorner p1 "\ninput second point:"))
     (command "-layer" "m" "DrawLayer" "")  
     (foreach mm #all_lay_list
           (command "-layer" "s" mm "")
           (setq obj (tblobjname "layer" mm))
           (setq obj (entget obj))  
           (setq cLtype (cdr (assoc 6 obj)))
           (setq cClr (cdr (assoc 62 obj)))
           (if (or (/= (strcase mm) "DRAWLAYER")
                   (/= (strcase mm) "$PARTREF_BOM")
               );or        
               (progn
                   (setq pview_set (ssget "c"  p1 p2 (list (cons -4 "<AND")
                                                                (cons -4 "<NOT")
                                                                    (cons 0 "INSERT")
                                                                (cons -4 "NOT>")
                                                                (cons 8 mm)
                                                           (cons -4 "AND>"))))
                   (setq i 0)
       
                   (while (and (/= pview_set nil)
                             (/= (setq ent (ssname pview_set i)) nil)
                          );and     
                          (setq entdata (entget ent))
                
                          (setq ment (subst (cons 8 "DrawLayer") (cons 8 mm) entdata))
                          (if (= (assoc 6 ment) nil)
                              (setq ment (cons (cons 6 cLtype)  ment))
                              (setq ment (subst (cons 6 cLtype) (assoc 6 ment) ment))
                          );if
                          (if (= (assoc 62 ment) nil)
                              (setq ment (cons (cons 62 cclr)  ment))
                              (setq ment (subst (cons 62 cclr) (assoc 62 ment) ment))
                          );if  
                          (entmod ment)
                          ;(entupd ment)
                          (setq i (1+ i))
                   );while  
                 
                   (if (/= pview_set nil)
                       (progn
                          (command "-layer" "s" "DrawLayer" "")
                          (command "-block"  (strcat mm "%^"  pview) '(0 0 0) pview_set "")
                          (command "-insert" (strcat mm "%^"  pview) '(0 0 0) 1 1 "")
                       );progn
                   );if
              );progn
          );if    
     );foreach
     
     (command "purge" "A" "*" "N")
 );defun 
            
  
