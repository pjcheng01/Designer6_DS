;;;審核通過時自動簽名
;;;與 POWERPDM 連結開圖
;;;與 POWERPDM 連結插圖
;;;引線標注帶辭庫
;;;審核存圖
;;;審核叫出 xref 檔
;;;叫出批注檔


;;;與圖文管理系統相關之程式
;;; partout.exe    自動拆圖時使用(bom.lsp)
;;; topdmatt.exe   將拆圖後資料寫入圖文管理系統
;;; senttitle.exe  將圖文管理系統內圖框屬性寫出

;;; 程式名稱       用途說明                    產生檔案及所在目錄
;;;============================================================================================
;;; partout.exe    自動拆圖時使用(bom.lsp)     partout.txt (圖文管理系統目錄內)
;; 內容: ("BA1B1" "002" "自動夾緊機" "護罩" "2D 零件圖")  ->  (檔號  目前可用流水號 總類名稱 子類名稱 細類名稱)
;;       3                                                ->  流水號位數
;;;--------------------------------------------------------------------------------------------
;;;                連續出圖                    plot.txt (圖文管理系統個人工作區內)
;; 內容: D:\POWERPDM\WRK\000\BA1B1001.DWG
;;       D:\POWERPDM\WRK\000\BA1B0001.DWG
;;;--------------------------------------------------------------------------------------------
;;; topdmatt.exe   將拆圖後資料寫入圖文管理系統 topdmatt.txt(圖文管理系統目錄內)
;; 內容:1          1-> 指屬性一
;;      02A012  A120024     馬達板                                          陳冠達                        F20C1234567890ABCDEFGHIJKLMNOPQRSTUVWXY
;;;--------------------------------------------------------------------------------------------
;;; senttitle.exe  將圖文管理系統內圖框屬性寫出 pdmcad.txt(圖文管理系統目錄內)
;; 內容: ("屬性一AA" "FD_01" "8" "檔名" "FILENO" "0")
;;       ("屬性一AA" "FD_02" "30" "圖類名稱" "FILENAME" "0")
;;                    .
;;                    .
;;       ("屬性二BB" "FD_01" "8" "檔名" "FILENO" "0")
;;       ("屬性二BB" "FD_03" "15" "圖號" "BMPNO" "0")

;;;=======================================================================================================================
(defun ch_lt_c (lty col)
  (setq aa col)
  (if (= 0 (atoi col))
    (command "linetype" "s" lty "" "color" col)
    (command "linetype" "s" lty "" "color" (atoi col))
  )
    (princ)
)

;;;用於與 圖文管理系統聯結
(defun c:&pdmopen()(cond ((null C:&CHECK&)(load "POWERPDM")) (T  (c:pdmopen))))         ;開啟舊圖
;(defun c:&pdminsdwg()(cond ((null C:&CHECK&)(load "POWERPDM"))(T (c:pdminsdwg))))    ;插入舊圖
(defun c:&pdminsdwg()(pdminto-dwg 0))  ;插入舊圖
(defun c:&CHECKTXT()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:checktxt))))   ;插入舊圖
(defun c:&CHECKDWG()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:checkdwg))))    ;叫出來審圖
(defun c:&PDMSAVE()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:pdmsave))))    ;審後存圖
(defun c:&REDLINE_IN()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:redline_in))))    ;叫出批注檔
(defun c:&autosign()(cond ((null C:&CHECK&)(load "POWERPDM"))(T  (c:autosign))))    ;叫出批注檔
(defun c:&callcalc() (startapp "calc"))

(defun c:&useword() (cond ((null c:useword)(load "wordlib1"))(t (princ)))(c:useword)) ;使用辭庫
(defun c:&creatword() (cond ((null c:creatword)(load "wordlib1"))(t (princ)))(c:creatword)) ;辭庫建立

(defun c:&del_redline()(cond ((null C:&CHECK&)(load "POWERPDM"))(T (c:del_redline)))) ;[建立辭庫]

;;切換到審核批注層
(defun c:&check&()
  (setvar "cmdecho" 0)
  (if (= "CHECKBASE" (substr (strcase dname) 1 9))
    (progn
       (clauc "$CHECKTXT" "1" "CONTINUOUS")
       (ch_lt_c "BYLAYER" "BYLAYER")
       (command "sh" (strcat "del " POWERPDM_CLIENT_PATH "temp\\chkcode.txt"))
    );progn
  );if
 (setvar "cmdecho" 1)
)

;;;刪除圖面上批注檔(沈圖者)
;(defun c:del_redline(/ bname entgrp)
(defun c:del_redline_drawer()
  (setvar "cmdecho" 0)
  (setq entgrp (ssget "x" (list (cons 8 "$CHECKTXT"))))
  (if (/= nil entgrp)
    (progn
      (command "erase" entgrp "")
      ;(command "purge" "b" (strcat "$" (curdwgname)) "n")  ;;purge 審核 block
      (setq redline_in_fg t)
    )
    (progn
      (setq redline_in_fg nil)
      (princ "\n該圖面上沒有任何批注紀錄!")
    );progn
  )
  (setvar "cmdecho" 1)
  (princ)
)

;;;刪除圖面上批注檔
;(defun c:del_redline(/ bname entgrp)
(defun c:del_redline()
  (setvar "cmdecho" 0)
  (setq entgrp (ssget "x" (list (cons 2 (strcase (strcat "$" (curdwgname)))))))
  (if (/= nil entgrp)
    (progn
      (command "erase" entgrp "")
      (command "purge" "b" (strcat "$" (curdwgname)) "n")  ;;purge 審核 block
      (setq redline_in_fg t)
    )
    (progn
      (setq redline_in_fg nil)
      (princ "\n該圖面上沒有任何批注紀錄!")
    );progn
  )
  (setvar "cmdecho" 1)
  (princ)
)

;;;叫出批注檔
(defun c:redline_in()
  (cond
;   ((= "CHECKBASE" (strcase (curdwgname)))     ;;審核者叫出被審圖時

    ;(setq ~curdwgname (strcase (curdwgname)))
    ;(if (> (strlen ~curdwgname) 9)(setq ~curdwgname (substr ~curdwgname 1 9)))

    ;(if (= "CHECKBASE" (substr (strcase (curdwgname)) 1 9))

    ((= "CHECKBASE" (substr (strcase (curdwgname)) 1 9))
        (setq xrefent (ssget "x" (list (cons 8 "0")(cons 0 "INSERT"))))
        (setq ent (ssname xrefent 0))
        (setq insp (cdr (assoc 10 (entget ent))))
        (setq xrefname (cdr (assoc 2 (entget ent))))
        (setq fname (strcat POWERPDM_cad_PATH "checkdwg\\$" xrefname ".dwg"))
        (if (findfile fname)
          (progn
             (setq dd (open (strcat POWERPDM_CAD_PATH "openfile.scr") "w"))
             (c:&check&)
             (write-line "insert" dd)
             (write-line (strcat "*" fname) dd)
             (setq xp (rtos (nth 0 insp) 2 2))
             (setq yp (rtos (nth 1 insp) 2 2))
             (write-line (strcat xp "," yp) dd)
             (write-line "1" dd)
             (write-line "0" dd)
             (write-line "zoom" dd)
             (write-line "e" dd)
             (close dd)
             (command "script" (strcat POWERPDM_CAD_PATH "openfile"))
          );progn
          (princ "\n沒有審核批注!")
        );if
    );end of (= "CHECKBASE" (strcase (curdwgname)))

;;編輯原圖時叫出批注檔
    ((/= nil (findfile (setq fname (strcat POWERPDM_cad_PATH "checkdwg\\$" (getvar "dwgname")))))
       (c:del_redline)  ;;刪除圖面上批注檔
       (setq dd (open (strcat POWERPDM_CAD_PATH "openfile.scr") "w"))
       (c:&check&)
       (write-line "insert" dd)
       (write-line fname dd)
       (setq insp (getvar "insbase"))
       (setq xp (rtos (nth 0 insp) 2 2))
       (setq yp (rtos (nth 1 insp) 2 2))
       (write-line (strcat xp "," yp) dd)
       (write-line "1" dd)
       (write-line "1" dd)
       (write-line "0" dd)
       (write-line "zoom" dd)
       (write-line "e" dd)
       (close dd)
       (command "script" (strcat POWERPDM_CAD_PATH "openfile"))
    );end of
    (T (princ "\n沒有審核批注紀錄!")
       (princ "3333")
    )
  );cond
  (setvar "cmdecho" 1)
  (princ)
)


;;;審核存圖
(defun c:pdmsave(/ entgrp xrefent ent insp xrefname  dd xp yp entgrp)
  (setvar "cmdecho" 0)
  (setq entgrp (ssget "x" (list (cons 8 "$CHECKTXT"))))  ;;取所有審核說明
  (if (/= nil entgrp)
   (progn
     (setq xrefent (ssget "x" (list (cons 8 "0")(cons 0 "INSERT"))))
     (setq ent (ssname xrefent 0))
     (setq insp (cdr (assoc 10 (entget ent))))
     (setq xrefname (cdr (assoc 2 (entget ent))))
     (setq dd (open (strcat POWERPDM_CAD_PATH "openfile.scr") "w"))
     (write-line "wblock" dd)
     (write-line (strcat POWERPDM_cad_PATH "checkdwg\\$" xrefname) dd)
     (if (findfile (strcat POWERPDM_cad_PATH "checkdwg\\$" xrefname ".dwg"))
       (write-line "Y" dd)
     );if
     (write-line "" dd)
     (setq xp (rtos (nth 0 insp) 2 2))
     (setq yp (rtos (nth 1 insp) 2 2))
     (write-line (strcat xp "," yp) dd)
     (setq entgrp (ssget "x" (list (cons 8 "$CHECKTXT"))))  ;;取所有審核說明
     (write-line "p" dd)
     (write-line "" dd)
     (write-line "oops" dd)
     (if (= "15" (substr (getvar "acadver") 1 2))
         (progn
              (write-line "open" dd)
              (write-line (strcat POWERPDM_cad_PATH "checkdwg\\$" xrefname) dd)
              (write-line "saveas" dd)
              (write-line "r14" dd)
              (write-line (strcat POWERPDM_cad_PATH "checkdwg\\$" xrefname) dd)
              (write-line "y" dd)
              (write-line "close" dd)
         );progn
     );if
     (close dd)
     (command "script" (strcat POWERPDM_CAD_PATH "openfile"))
     (princ "\n審圖記錄存檔完成 !")
   );progn
   (princ "\n不存在審圖圖層 $CHECKTXT 圖元 !")
  );if
  (setvar "cmdecho" 1)
);defun


;;;審核叫出 xref 檔
;(defun c:checkdwg(/ ff fname dd name gg data dname)
(defun c:checkdwg()
  
  (setq name (findfile (strcat POWERPDM_CLIENT_PATH "temp\\chkcode.txt")))
 
  (setq dname (getvar "dwgname"))
; (if (null powdesign_path) (command "menuunload" "PDMCHECK")                              ;移除審圖功能表
;     (progn
;       (command "menuunload" "PDMCHECK")                              ;移除審圖功能表
;       (command "toolbar" "圖面審核" "h" "toolbar" "審圖畫面縮放" "h" "toolbar" "審圖修改" "h" "toolbar" "審圖繪圖" "h" "toolbar" "審圖查詢" "h")
;     );progn
; );if
; (if (/= nil name)

  (setq ~dname (strcase (substr dname 1 (- (strlen dname) 4))))
  (if (> (strlen ~dname) 9)(setq ~dname (substr ~dname 1 9))) 
   
  (if (= "CHECKBASE" ~dname)
    (progn
      (setq gg (open name "r"))
      (setq data (read-line gg))
      (if (= "1" data)
        (progn
            (setq fname (read-line gg))
            (close gg)
            (setq hh (open name "w"))
            (write-line "0" hh)
            (write-line "0" hh)
            (close hh)
            (if (/= nil fname)
              (progn
                (setq &&xrefdwg_name fname)    ;; &&xrefdwg_name 通用變數
                (if (findfile fname)
                  (progn
                    
                    (c:&check&)
                    (command "menuunload" "PDMCHECK")  
                    (command "menuload" (STRCAT POWERPDM_CAD_PATH "PDMCHECK"))        ;重新載入審圖功能表
                    (menucmd "P21=+PDMCHECK.pop14")     ;下拉式功能表加入機械設計家

                    (command "toolbar" "圖面審核" "s" "toolbar" "審圖畫面縮放" "s" "toolbar" "審圖修改" "s" "toolbar" "審圖繪圖" "s" "toolbar" "審圖查詢" "s")
                    (setq dd (open (strcat POWERPDM_CAD_PATH "openfile.scr") "w"))
                  ; (write-line "write-code" dd)
                    (write-line "layer" dd)
                    (write-line "S" dd)
                    (write-line "0" dd)
                    (write-line "" dd)
                    (write-line "xref" dd)
                    (write-line "A" dd)
                    (write-line fname dd)
                    (write-line "0,0,0" dd)
                    (write-line "1" dd)
                    (write-line "1" dd)
                    (write-line "0" dd)
                    (write-line "zoom" dd)
                    (write-line "e" dd)
                    (write-line "layer" dd)
                    (write-line "M" dd)
                    (write-line "$CHECKTXT" dd)
                    (write-line "C" dd)
                    (write-line "1" dd)
                    (write-line "" dd)
                    (write-line "" dd)
                    (close dd)
                  ;  (COMMAND "SH" "DEL C:\\CHKCODE.TXT")
                    (command "script" (strcat POWERPDM_CAD_PATH "openfile"))
                  );progn
                  
                );if
              );progn
            );if
        );progn
;       (progn
;         (if (null powdesign_path) (command "menuunload" "PDMCHECK")                              ;移除審圖功能表
;            (progn
        
;              (command "menuunload" "PDMCHECK")                              ;移除審圖功能表
;              (command "toolbar" "圖面審核" "h" "toolbar" "審圖畫面縮放" "h" "toolbar" "審圖修改" "h" "toolbar" "審圖繪圖" "h" "toolbar" "審圖查詢" "h")
;            );progn
;         );if
;       );progn
      );if
    );progn
    (progn
   ;  (if (null powdesign_path) (command "menuunload" "PDMCHECK")                              ;移除審圖功能表
   ;     (progn
           
            (command "menuunload" "PDMCHECK")                              ;移除審圖功能表
            
    ;       (command "toolbar" "圖面審核" "h" "toolbar" "審圖畫面縮放" "h" "toolbar" "審圖修改" "h" "toolbar" "審圖繪圖" "h" "toolbar" "審圖查詢" "h")
    ;    );progn
    ; );if
    );progn
  );if
   (princ)
);defun

;;;建立圖管屬性樣本檔
;(degun c:ctt()
;  (startapp (strcat powerpdm_path "topdmatt.exe"))
;  (setq ff (open  (strcat powerpdm_path "pdmcad.txt") "r"))
;  (setq att_list '())
;  (setq data (read-line ff))
;  (setq data (read data))
;  (setq typ (nth 0 data))
;("屬性一" "FD_14" "8" "設變日" "DATE_C" "0")
;  (while data
;     (setq att_list (cons
;
;
;  )
;)
;


;;;審核通過時自動簽名
(defun c:autosign(/ bordgrp attent count data2 ff data txt sign_list txt_id txt1 data txt2 txt3)
; (setq powerpdm_path "d:\\powerpdm\\")
; (setq POWERPDMBOM_path "g:\\designlt\\pdmbom\\")
; (setq bordergrp (ssget "x" (list (cons 8 sys_sheet_layer) (cons 0 "INSERT"))))
  (setq bordergrp (ssget "x" (list (cons 8 "SHEET") (cons 0 "INSERT"))))
  (setq attent nil)
  (if (/= nil bordergrp)
    (progn
      (setq count 0)
      (repeat (sslength bordergrp)
         (setq data2 (cdr (assoc 2 (entget (ssname bordergrp count)))))
         (if (and (> (strlen data2) 3) (= "TZT" (strcase (substr data2 (- (strlen data2) 2)))))
           (progn
              (setq attent (ssname bordergrp count))
           );progn
         );if
         (setq count (1+ count))
      );repeat
    );progn
  );if
  (if (and (/= nil attent)(/= nil powerpdm_path))
    (progn
;     (if (findfile "c:\\part.txt")
      (if (findfile "c:\\partbak.txt")   ;暫用
        (progn
          (setq ff (open "c:\\partbak.txt" "r")
;         (setq ff (open "c:\\part.txt" "r")
                data (read-line ff)
                txt (substr data (1+ (get_word data ":"))))
       ;  (if (= (strcase txt) (strcase (curdwgname)))
          (if T
            (progn
              (setq data (read-line ff))
              (setq sign_list '())
              (while data
                (setq txt_id (get_word data "="))
                (if (/= nil txt_id)
                  (progn
                    (setq txt1 (substr data 1 (- txt_id 1)))
                    (setq data (substr data (1+ txt_id)))
                    (setq txt_id (get_word data "="))
                    (setq txt2 (substr data 1 (- txt_id 1)))
                    (setq txt3 (substr data (1+ txt_id)))
                    (setq sign_list (cons (list txt1 txt2 txt3) sign_list))
                  );progn
                );if
                (setq data (read-line ff))
              );while
            );progn
          );if
          (close ff)
          (setq sign_list (reverse sign_list))
          (if (/= nil sign_list)
            (progn
              (pdm_ins_signbmp sign_list)
              (command "regen")
            );progn
            (princ "\n本圖尚未通過任何審核者審核!")
          );if
        );progn
      );if
    );progn
  );if
  (princ)
)

(defun pdm_ins_signbmp(slist / attblklist ncode name date attdata bmpf att_check att_checkdate att_check_data att_checkdate_data
                               check_insp date_insp scal bmpgrp oldla)
  (setq attblklist (read (getfile_val (strcat POWERPDM_cad_path "POWERPDM.ini") "審核簽名資料")))
  (foreach nn slist
    (progn
       (setq ncode (nth 0 nn)
             name (nth 1 nn)
             date (nth 2 nn)
             attdata (assoc ncode attblklist))
           (setq bmpf (nth 1 attdata)
                 att_check (nth 2 attdata)
                 att_checkdate (nth 3 attdata))
           (setq att_check_data (getatt attent 2 att_check))
           (setq att_checkdate_data (getatt attent 2 att_checkdate))
           (setq check_insp (cdr (assoc 10 att_check_data)))
           (setq date_insp (cdr (assoc 10 att_checkdate_data)))
           (setq scal (getvar "dimscale"))
           (if (= "" bmpf)
              (progn
                (setq att_check_data (subst (cons 1 name) (assoc 1 att_check_data) att_check_data))
                (entmod att_check_data)
              );progn
              (progn
                 (setq bmpgrp (ssget "x" (list (cons 0 "INSERT") (cons 2 (strcase bmpf)))))  ;;取所有資訊點
                 (if (null bmpgrp)
                   (progn
                      (setq oldla (getvar "clayer"))
                      (command "layer" "s" sys_sheet_layer "")
                      (command "insert" (strcat POWERPDM_cad_path "signbmp\\" bmpf) check_insp scal scal "0")
                      (command "layer" "s" oldla "")
                   );progn
                 );if
              );progn
           );if
           (setq att_checkdate_data (subst (cons 1 date) (assoc 1 att_checkdate_data) att_checkdate_data))
           (entmod att_checkdate_data)
    );progn
  );foreach
);defun


;;;與 POWERPDM 連結開圖
(defun c:pdmopen() (pdminto-dwg 1))

;;;與 POWERPDM 連結插圖
(defun c:pdminsdwg() (pdminto-dwg 0))

(defun pdminto-dwg(typ / ff qf data)
;  (if (findfile (strcat POWERPDM_path "temp\\dwgname.txt"))
;    (progn
       (setq opfile (open (strcat POWERPDM_path "temp\\dwgname.txt") "r"))
       (setq fname (read-line opfile))
       (close opfile)
       (if (findfile fname)
         (progn
            (if (= typ 1)
             (progn
                (princ "B")
               (initget "Yes No")
               (setq yesno (getkword "\n是否儲存目前圖檔<Y>?"))
               (if (or (= "Yes" yseno) (null yesno))
                 (progn
                    (setq name (getfiled "儲存檔案為" (strcat (getvar "dwgprefix")(getvar "dwgname")) "dwg" 8))
                    (if (/= nil name) (comand "qsave") (setq flag t))
                 );progn
               );if
               (if (/= flag t)
                 (progn
                   (if (null datalist) (setq datalist (reverse datalist)))
                   (command "point" "0,0,0")(command "erase" (entlast) "")
                   (setq ff (open (strcat POWERPDM_CAD_PATH "openfile.scr") "w"))
                   (write-line "open" ff)
                   (write-line fname ff)
                   (close ff)
                   (command "script" (strcat POWERPDM_CAD_PATH "openfile"))
                 );progn
               );if
             );progn
             (progn
                (princ "A")
                 (initget "Yes No")
                 (setq yesno (getkword "\n圖塊是否炸開<N>?"))
                 (if (or (= "No" yseno) (null yesno))
                   (progn
                     (setq ff (open (strcat POWERPDM_CAD_PATH "openfile.scr") "w"))
                     (write-line "insert" ff)
                     (write-line fname ff)
                     (close ff)
                   );progn
                   (progn
                     (setq ff (open (strcat POWERPDM_CAD_PATH "openfile.scr") "w"))
                     (write-line "insert" ff)
                     (write-line (strcat "*" fname) ff)
                     (close ff)
                   );progn
                 );if
                 (command "script" (strcat POWERPDM_CAD_PATH "openfile.scr"))
             );progn
           );if
         );progn
       );if
;    );progn
;    (progn
;      (princ "G")
;    (princ (strcat fname " 檔案不存在!"))
;    )
;   )
  (princ)
);defun

;;;;與 POWERPDM 連結插圖
;(defun c:pdminsdwg(/ ff qf data)
;   (setq olderr *error*)
;   (defun *error* (msg)
;      (princ msg)
;      (if (/= nil qf) (close qf))
;      (setq *error* olderr)
;   )
;  (startapp (strcat POWERPDM_path "viewpict"))
;  (getpoint "\n請選取檔案後按 Enter 鍵!")
;  (setq qf (open "c:\\part.txt" "r"))
;  (setq data (read-line qf))
;  (setq data_id (get_word data ":"))
;  (setq fname (substr data (1+ data_id)))
;  (if (= "nil" fname)
;    (princ "未選擇圖形!")
;    (progn
;;     (setq fname (strcat "D:\\PowerPDM\\WRK\\000\\" fname))
;      (setq data (read-line qf))
;      (setq datalist '())
;      (while data
;         (setq data_id (get_word data ":"))
;         (setq data (substr data (1+ data_id)))
;         (setq datalist (cons data datalist))
;         (setq data (read-line qf))
;      );while
;      (close qf)
;         (initget "Yes No")
;         (setq yesno (getkword "\n圖塊是否炸開<N>?"))
;         (if (or (= "No" yseno) (null yesno))
;           (progn
;             (setq ff (open (strcat POWERPDM_CAD_PATH "openfile.scr") "w"))
;             (write-line "insert" ff)
;             (write-line fname ff)
;             (close ff)
;           );progn
;           (progn
;             (setq ff (open (strcat POWERPDM_CAD_PATH "openfile.scr") "w"))
;             (write-line "insert" ff)
;             (write-line (strcat "*" fname) ff)
;             (close ff)
;           );progn
;         );if
;         (command "script" (strcat POWERPDM_CAD_PATH "openfile.scr"))
;    );progn
;  );if
;  (setq *error* olderr)
;  (princ)
;
;);defun

;;相關檔案
;; plot.txt ==> 產生於圖文管理系統個人工作區內
(defun c:pdmautoplot()
  (princ)

)


;;引線標注帶辭庫
(defun c:checktxt()
   ; (if (null height
  (if (null c:useword)(load "wordlib1"))
  (setvar "cmdecho" 0)
 ;(if (null
  (setq p1 (getpoint "\n起點: "))
  (while (null p1)
     (princ "\n未點選起點,請再點選一次! ")
     (setq p1 (getpoint "\n起點: "))
  );while
    (setq p2 (getpoint p1 "\n下一點: "))
    (while (null p2)
       (princ "\n未點選下一點,請再點選一次! ")
       (setq p1 (getpoint p1 "\n下一點: "))
    )
   (setq get_wordlibdata t)
   (setq write_list (reverse (useword 1 2)))
   (setq txt (nth 0 write_list))
   (setvar "cmdecho" 0)
   (setvar "osmode" 0)
   (setq scal (getvar "dimscale")
         asz  (getvar "dimasz"))
   (setq ang (angle p1 p2)
         ang2 (angle p1 (list (nth 0 p2) (nth 1 p1))))
   (c:&check&)
   (if (= 0 ang2)
     (progn
       (setq p3 (polar p2 ang2 scal)
             txtp (polar p3 (* pi 0.5) (* scal (getvar "dimgap"))))
       (command "text" txtp (* scal (getvar "dimtxt")) "0" txt)
       (setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
       (setq height (* scal (getvar "dimtxt")))
       (foreach nn (cdr write_list)
          (progn
            (setq txtp (polar txtp (+ (* 0.5 pi) ang2) (* 1.62 (* scal (getvar "dimtxt")))))
            (command "text" txtp height ang2 nn)
            (setq tl (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
            (if (> tl txtlen)(setq txtlen tl))
            (setq height (cdr (assoc 40 (entget (entlast)))))
          );progn
       );foreach
     );progn
     (progn
       (setq p3 (polar p2 ang2 (* 2 scal)))
       (setq txtp (polar p3 (* pi 0.5) (* scal (getvar "dimgap"))))
       (command "text" "R" txtp (* scal (getvar "dimtxt")) "0" txt)
       (setq txtlen (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
       (setq height (* scal (getvar "dimtxt")))
       (foreach nn (cdr write_list)
         (progn
            (setq txtp (polar txtp (+ (* 1.5 pi) ang2) (* 1.62 (* scal (getvar "dimtxt")))))
            (command "text" "R" txtp (* scal (getvar "dimtxt")) "0" nn)
            (setq tl (nth 0 (nth 1 (textbox (list (assoc 1 (entget (entlast))))))))
            (if (> tl txtlen)(setq txtlen tl))
            (setq height (cdr (assoc 40 (entget (entlast)))))
          );progn
       );foreach

     );progn
   )
  (setvar "cmdecho" 0)
   (setq a1 (polar p1 ang (* scal asz))
         p4 (polar p1 ang (distance p1 p2))
         p5 (polar p4 ang2 (+ (* 2 scal) txtlen)))
  (command "pline" p1 "w" "0" scal a1 "w" "0" "0" p4 p5 "")
  (setvar "cmdecho" 1)
  (princ)
)

(defun c:load-checkmenu()
    (command "menuload" (STRCAT POWERPDM_CAD_PATH "PDMCHECK"))        ;重新載入審圖功能表
    (menucmd "P21=+PDMCHECK.pop14")     ;下拉式功能表加入機械設計家
    (command "toolbar" "圖面審核" "s" "toolbar" "審圖畫面縮放" "s" "toolbar" "審圖修改" "s" "toolbar" "審圖繪圖" "s" "toolbar" "審圖查詢" "s")
)
(defun c:unload-checkmenu()
  (command "menuunload" "PDMCHECK")                              ;移除審圖功能表
)
;==========================================================================================================================
(load "pdm-cad")

(c:checkdwg)   ;;載入審核圖檔

