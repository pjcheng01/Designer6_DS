
;;帶入pdm屬性資料進入圖框
;;開啟舊圖
;;插入舊圖
;==========================================================================================================================
;;;用於與 圖文管理系統聯結
(defun c:&pdmopen()(cond ((null C:&CHECK&)(load "PDM&CAD")) (T  (c:pdmopen))))         ;開啟舊圖
(defun c:&pdminsdwg()(cond ((null C:&CHECK&)(load "PDM&CAD"))(T (c:pdminsdwg))))    ;插入舊圖
;(defun c:&CHECKTXT()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:checktxt))))   ;插入舊圖
;(defun c:&CHECKDWG()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:checkdwg))))    ;叫出來審圖
;(defun c:&PDMSAVE()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:pdmsave))))    ;審後存圖
;(defun c:&REDLINE_IN()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:redline_in))))    ;叫出批注檔
;(defun c:&autosign()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:autosign))))    ;叫出批注檔
;(defun c:&callcalc() (startapp "calc"))

;(defun c:&useword() (cond ((null c:useword)(load "wordlib1"))(t (princ)))(c:useword)) ;使用辭庫
;(defun c:&creatword() (cond ((null c:creatword)(load "wordlib1"))(t (princ)))(c:creatword)) ;辭庫建立

;(defun c:&del_redline()(cond ((null C:&CHECK&)(load "POWERPDM"))(T (c:del_redline)))) ;[建立辭庫]

;==========================================================================================================================
;;;帶入pdm屬性資料進入圖框
(defun c:input_pdm_attdata(/ bordergrp coun att_flag ent entdata data2 data2_len name att_flag objent ini_file att_list
                           ff data txt_id data1)
;(defun c:input_pdm_attdata()
      (setq bordergrp (ssget "x" (list (cons 8 sys_sheet_layer) (cons 0 "INSERT"))))
      (if (= nil bordergrp)
        (princ "\n圖面上沒有圖框,不能執行此功能!")
        (progn
          (setq coun 0 att_flag nil)
          (repeat (sslength bordergrp)
            (setq ent (ssname bordergrp coun)
                  entdata (entget ent)
                  data2 (cdr (assoc 2 entdata))
                  data2_len (strlen data2))
            (if (> data2_len 3)
              (progn
                 (setq name (strcase (substr data2 (- data2_len 2))))
                 (if (= "TZT" name)
                   (progn
                     (setq att_flag t objent ent)
                   )
          ;        (princ "\n圖面上沒有合乎機械設計家圖框屬性命名,不能執行此功能!")
                 );if
              );progn
           ;  (princ "\n圖面上沒有圖框屬性,不能執行此功能!")
            );if
            (setq coun (1+ coun))
          );repeat
        );progn
      );if
      (if (null att_flag) (princ "\n圖面上沒有圖框屬性或沒有合乎機械設計家圖框屬性命名,不能執行此功能!"))
         (progn
            (if powerpdm_attribdata_path
                (progn
                     (setq ini_file (strcat powerpdm_attribdata_path (curdwgname) ".txt"))
                      ;(alert ini_file) 
                     (if (findfile ini_file)
                       (progn
                         (if (null get_word) (load "pub-lisp"))
                         (setq att_list '())
                         (setq ff (open ini_file "r"))
                         (read-line ff)
                         (setq data (read-line ff))
                         (while data
                         ; (princ data)
                           (setq txt_id (get_word data " "))
                           (if (/= nil txt_id)
                             (progn
                               (setq data1 (substr data 1 (- txt_id 1))
                                     data2 (substr data (1+ txt_id)))
                               (setq att_list (cons (list data1 data2) att_list))
                             );progn
                             (setq att_list (cons (list data "") att_list))
                           );if
                           (setq data (read-line ff))
                         )
                         (close ff)
                         (setq aaa att_list)
                         (setq scal (getvar "dimscale"))
                         (if (> scal 0) (setq fact1 1 fact2 scal) (setq fact1 (/ 1 scal) fact2 1))
                         (if (null &&scale_tag) (load "shscal"))
                       ; (setq att_list (cons (list "SCALE" (strcat (rtos fact1 2 0) ":" (rtos fact2 2 0))) att_list))
                         (setq att_list (cons (list &&scale_tag (strcat (rtos fact1 2 0) ":" (rtos fact2 2 0))) att_list))

                       ; (input_pdm_attdata_sheetatt objent att_list)
                         (input_pdm objent att_list)
                       )
                      )
                );progn
                (princ "\nPowerPDM 系統并未成功載入!")
            );if
      );if
      (princ)
);defun

;(defun input_pdm_attdata_sheetatt(enttt data_list / ent newdata label data1)
(defun input_pdm(enttt data_list / ent newdata label data1)
   (foreach nn data_list
     (progn
      ; (if (/= "" (nth 1 nn))
      ;   (progn
           (setq new (getrealstr3 (nth 1 nn)))
           (setq label (nth 0 nn))
           (setq data1 (getatt enttt 2 label))
           (setq data1 (subst (cons 1 new) (assoc 1 data1) data1))
           (entmod data1)
      ;   );progn
      ; );if
     );progn
   );foreach
   (command "regen")
)
;==========================================================================================================================
;;;與 POWERPDM 連結插圖
(defun c:pdminsdwg() (pdminto_dwg 0))
(defun c:pdmOPEN() (pdminto_dwg 1))

(defun pdminto_dwg(typ / ff qf data)
   (if (findfile (strcat POWERPDM_client_path "temp\\dwgname.txt"))
     (progn
       (setq opfile (open (strcat POWERPDM_client_path "temp\\dwgname.txt") "r"))
       (setq fname (read-line opfile))
       (close opfile)
       (if (findfile fname)
         (progn
            (if (= typ 1)
             (progn
               (COMMAND "qsave" "")
               (command "fileopen" fname)
             ; (initget "Yes No")
             ; (setq yesno (getkword "\n是否儲存目前圖檔<Y>?"))
             ; (if (or (= "Yes" yseno) (null yesno))
             ;   (progn
             ;      (setq name (getfiled "儲存檔案為" (strcat (getvar "dwgprefix")(getvar "dwgname")) "dwg" 8))
             ;      (if (/= nil name) (comand "qsave") (setq flag t))
             ;   );progn
             ; );if
             ; (if (/= flag t)
             ;   (progn
             ;     (if (null datalist) (setq datalist (reverse datalist)))
             ;     (command "point" "0,0,0")(command "erase" (entlast) "")
             ;     (setq ff (open (strcat POWERPDM_CLIENT_PATH "TEMP\\openfile.scr") "w"))
             ;     (write-line "open" ff)
             ;     (write-line fname ff)
             ;     (close ff)
             ;     (command "script" (strcat POWERPDM_CLIENT_PATH "TEMP\\openfile"))
             ;   );progn
             ; );if
             );progn
             (progn
                 (initget "Yes No")
                 (setq yesno (getkword "\n圖塊是否炸開<N>?"))
                  (if (or (= "No" yseno) (null yesno))
                    (command "insert" fname)
                    (command "insert" (strcat "*" fname))
                  )
               ;  (if (or (= "No" yseno) (null yesno))
               ;    (progn
               ;      (setq ff (open (strcat POWERPDM_CLIENT_PATH "TEMP\\openfile.scr") "w"))
               ;      (write-line "insert" ff)
               ;      (write-line fname ff)
               ;      (close ff)
               ;    );progn
               ;    (progn
               ;      (setq ff (open (strcat POWERPDM_CLIENT_PATH "TEMP\\openfile.scr") "w"))
               ;      (write-line "insert" ff)
               ;      (write-line (strcat "*" fname) ff)
               ;      (close ff)
               ;    );progn
               ;  );if
               ;  (command "script" (strcat POWERPDM_CLIENT_PATH "TEMP\\openfile.scr"))
             );progn
           );if
         );progn
       );if
     );progn
     (princ (strcat fname " 檔案不存在!"))
    )
  (princ)
);defun


;;======================================================================================================================
;;圖框資料寫入PDM
(defun c:cad_to_pdm(/ sheetdata attall_list ff ini_file)
  (if (null ch_sheet) (load "shscal"))
  (setq sheetdata (ch_sheet 2))
  (SETQ AAA SHEETDATA)
  (setq attall_list (getent_allatt attent))
  (setq ff (open (strcat powerpdm_attribdata_path (curdwgname) ".txt") "w"))    ;;POWERPDM 2001
  (write-line (rtos (- (nth 1 sheetdata) 1) 2 0) ff)
  (foreach nn attall_list
    (write-line (strcat (nth 0 nn) " " (nth 1 nn)) ff)
  )
  (close ff)
  (setq ini_file (strcat powerpdm_attribdata_path (curdwgname) ".txt"))    ;;POWERPDM 2001
  (if (findfile ini_file)                                                  ;;POWERPDM 2001
    (progn
        (startapp (strcat "\"" (substr powerpdm_path 1 (- (strlen powerpdm_path) 7)) "CadWriteToPDM\" " (curdwgname)))
    );progn
  );if
  (princ)

)

;;======================================================================================================================
