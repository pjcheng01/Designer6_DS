;;;
(if (null curdwgname) (load "pub-lisp"))
;;假如 (getvar "acadver") 字串字數少於 4 ,表示acad版本為 LT版
;;假如 (getvar "acadver") 字串前二字=14  ,表示acad版本為 R14版
;;                                        其餘為 A2000,M2000 版(不需 UNDEFINE 指令)

;(if (or (= "14" (substr (getvar "acadver") 1 2)) (> (strlen (getvar "acadver")) 4)) (command "undefine" "qsave"))

;;檢查是否有圖框屬性
(defun sheet_yesno(/ sheet_have count ent entdata data2 chktxt havesheet)
  (setq havesheet nil)
  (if (/= nil powdesign_path)
    (progn
      (autoload)
      (setq sheet_have (ssget "x" (list (cons 0 "INSERT")(cons 8 sys_sheet_layer))))
    )
    (setq sheet_have (ssget "x" (list (cons 0 "INSERT")(cons 8 "SHEET"))))
  )
  (if (/= nil sheet_have)
    (progn
      (setq count 0)
      (repeat (sslength sheet_have)
        (setq ent (ssname sheet_have count))
        (setq entdata (entget ent))
        (setq data2 (cdr (assoc 2 entdata)))
        (if (> (strlen data2) 3)
          (progn
             (setq chktxt (substr data2 (- (strlen data2) 2)))
             (if (= "TZT" (strcase chktxt)) (setq havesheet t))
          );progn
        );if
        (setq count (1+ count))
      );repeat
    );progn
  );if
  havesheet
)

(defun c:qsave ()
  (setvar "cmdecho" 0)
  (c:del_redline)  ;;刪除圖面上批注檔
  (get_attemp_file_data)
  (command "purge" "b" (strcat "&" (curdwgname)) "n")  ;;purge 審核 block
  (COMMAND ".qSAVE")
  (if redline_in_fg  (c:redline_in)) ;;再叫出批注檔
   (setvar "cmdecho" 1)
  (princ)
)


;(if (> (strlen (getvar "acadver")) 4) (command "undefine" "save"))
(defun c:save ()
  (setvar "cmdecho" 0)

   (setq cdwgname (strcase (strcat (getvar "dwgprefix") (getvar "dwgname"))))
   (setq fname (GETFILED "儲存圖檔為" (GETVAR "DWGNAME") "DWG"  8))
   (if (/= nil fname)
     (progn
       (c:del_redline)  ;;刪除圖面上批注檔
       (get_attemp_file_data)
       (command "purge" "b" (strcat "&" (curdwgname)) "n")  ;;purge 審核 block
       (COMMAND ".SAVE" fname)
       (if redline_in_fg  (c:redline_in)) ;;再叫出批注檔
     );progn
   )
   (setvar "cmdecho" 1)
  (princ)
 )
;(if (and (> (strlen (getvar "acadver")) 4) (command "undefine" "end"))
(defun c:end ()
  (setvar "cmdecho" 0)
  (c:del_redline)  ;;刪除圖面上批注檔
  (get_attemp_file_data)
  (command "purge" "b" (strcat "&" (curdwgname)) "n")  ;;purge 審核 block
  (COMMAND ".end")
  (setvar "cmdecho" 1)
  (princ)
)
(defun get_attemp_file_data()
  (if (/= nil (sheet_yesno))
    (progn
      (if (findfile (strcat powerpdm_attribdata_path (curdwgname) ".txt"))
        (progn
          (setq ff (open (strcat powerpdm_attribdata_path (curdwgname) ".txt") "r"))
          (read-line ff)
          (setq num_id (substr (read-line ff)) 1 1)
          (close ff)
         (command "attext" "sdf" (strcat POWERPDM_cad_PATH "Attemp" num_id ".txt") (strcat powerpdm_attribdata_path (curdwgname) ".txt"))
         (setq ff (open (strcat powerpdm_attribdata_path (curdwgname) ".txt") "a"))
         (write-line num_id ff)
         (write-line (strcat (getvar "dwgprefix") (getvar "dwgname")) ff)
         (close ff)
        );progn
      );if
    );progn
  );if
;;屬性檔參考
;A0A83               藝祥資訊                                SQSQ                刨花機      陳明    2002/03/23            S45C    2
;0
;D:\圖文管理系統\圖文資料\工作區\陳冠達\A0A83.DWG
)


(princ)
