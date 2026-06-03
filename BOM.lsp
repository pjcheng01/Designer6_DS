;;;
;;;  連續編號指標球    (autobom btype)
;;;  不連續編號指標球  (keyin_bom btype)
;;;  產生材料清單圖形  (drawbom_list)
;;;  刪除材料清單圖形  (delbom_list)
;;;  編輯指標球        c:addbomtxt_xdata
;;; 產生材料清單文字檔
;; 拆零件
;; 零件組合

;;;==========================================================================================
;╭════════════════════════════════════════════╮
;║設計日期: 1999. 8. 29                                                                   ║
;║更新日期: 2000. 8. 18                                                                   ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 拆零件                                                                        ║
;║相關檔案: bom.dcl,pub-lisp.lsp                                                          ║
;╰════════════════════════════════════════════╯
(defun c:out(/ out_flag)
  (setvar "cmdecho" 0)
; (startapp (strcat designer2000_path  "makesubdir"))
; (startapp (strcat powerpdm_path "topdmatt"))         ;執行建立資料進入 powerpdm統
; (startapp (strcat powerpdm_path "partout"))
    (setq yyesno nil)
    (connect_powerpdm)
    (actdcl (strcat powdesign_dcl_path "bom") "out")
    (setq outlalist (acad_strlsort (coll_layer)) nolalist '())
    (setq no_outla (read (getfile_val (strcat POWdesign_path "system.ini") "自動拆圖時不拆之圖層")))
    (foreach nn no_outla
       (setq outlalist (removelist nn outlalist))
    );progn
    (act_pop_list outlalist "outlalist")
    (mode_tile "subpath" 1)
    (mode_tile "out" 1)
    (mode_tile "noout" 1)
    (set_tile "partpath" (getvar "dwgprefix"))
    (action_tile "subassem" "(actsubassem)")
    (action_tile "part"  "(actpart)")


    (action_tile "auto" "(mode_tile \"code\" 0)(mode_tile \"exe\" 0)(mode_tile \"nolalist\" 0)(mode_tile \"outlalist\" 0)       ")
    (action_tile "onebyone"  "(mode_tile \"code\" 1)(mode_tile \"exe\" 1)(mode_tile \"nolalist\" 1)(mode_tile \"outlalist\" 1)       ")

    (action_tile "outlalist" "(set_tile \"error\" \"\")(mode_tile \"noout\" 0)(mode_tile \"out\" 1)")
    (action_tile "nolalist" "(set_tile \"error\" \"\")(mode_tile \"out\" 0)(mode_tile \"noout\" 1)")
    (action_tile "noout" "(set_tile \"error\" \"\")(creat_nooutlist)")
    (action_tile "out" "(set_tile \"error\" \"\")(creat_outlist)")
    (action_tile "exe" "(set_tile \"error\" \"\")(exenooutgrp)")

    (if (= "Yes" yyesno) (pdm_ctl_dcl_status))

    (action_tile "accept" "(out_ok)")
    (action_tile "cancel" "(done_dialog)")

    (start_dialog)
    (if out_flag (exeout))
    (setvar "cmdecho" 1)
    (PRINC)
)

;;若與 pdm 聯結,則淡化部分功能
(defun pdm_ctl_dcl_status()
   (mode_tile "subassem" 1)
   (mode_tile "onebyone" 1)
   (mode_tile "oldlay" 1)
   (mode_tile "partpath" 1)
   (mode_tile "fcode" 1)
   (mode_tile "bcode" 1)
)


(defun connect_powerpdm()
    (if (and (/= nil powerpdm_path)(/= nil $pdm_dwgname))
      (progn
;        (if (findfile (strcat powerpdm_attribdata_path (curdwgname) ".txt"))   ;;判斷此圖是否經由圖文管理系統領號
         (if (= (strcase $pdm_dwgname) (strcase (curdwgname)))   ;;判斷此圖是否經由圖文管理系統領號  powerpdm 2001   ;;;BUG
          (progn
            (initget "Yes No")                                                             
            (setq yyesno (getkword "\n拆圖功能是否與 POWERPDM 圖文管理系統結合<YES>:"))
            (if (null yyesno) (setq yyesno "Yes"))
            (if (= yyesno "Yes") (setq sel_sheet_list (pdm_sel_sheet)))
           );progn
           (setq yyesno "No")
        );if
      );progn
    );if
);defun

;;相關檔案 shscal.lsp, bom.dcl
(defun pdm_sel_sheet(/ sel_sheet_list)
    (setq check_flag nil sel_sheet_list nil)
    (if (null ATOshscal)(load "shscal"))
    (actdcl (strcat powdesign_dcl_path "bom") "pdm_selsheet")

    (read_autoshscal_data) ;;得到  sheet_type ("標準屬性圖框" "組立圖框" "無屬性圖框")
    (act_pop_list sheet_type "type")
    (set_tile "type" "0")
    (action_tile "type" "(reset_sheettype)(set_tile \"size\" (rtos (- (length sheetsize_list) 1) 2 0))")

    (reset_sheettype)   ;;得到  sheetsize_list ("A0" "A1" "A2" "A3" "A4")
    (set_tile "size" (rtos (- (length sheetsize_list) 1) 2 0))
    (action_tile "accept" "(setq sel_sheet_list (pdm_sel_sheet_ok))")   ;;sel_sheet_list ("標準屬性圖框" "A2")
    (action_tile "cancel" "(done_dialog)(setq check_flag nil)")
    (start_dialog)
    sel_sheet_list   ;;("藝祥圖框" "藝祥 A4")
)

(defun pdm_sel_sheet_ok(/ typ_id size_id sh_type sh_size)
  (setq typ_id  (get_tile "type"))
; (setq size_id (get_tile "size"))
  (setq sh_type (nth (atoi (get_tile "type")) sheet_type))
; (setq sh_size (nth (atoi (get_tile "size")) sheetsize_list))
  (done_dialog)(setq check_flag T)
; (list sh_type sh_size)
  sh_type
);defun

(defun actsubassem()
    (set_tile "error" "")
    (set_tile "part" "0")
    (mode_tile "subpath" 0)
    (mode_tile "auto" 1)
    (mode_tile "onebyone" 1)
    (set_tile "subpath" (getvar "dwgprefix"))
    (set_tile "partpath" "")
    (mode_tile "partpath" 1)
    (mode_tile "oldlay" 1)
    (mode_tile "lay0" 1)
    (mode_tile "fcode" 1)
    (mode_tile "bcode" 1)
    (mode_tile "out" 1)
    (mode_tile "noout" 1)
    (mode_tile "code" 1)
    (mode_tile "exe" 1)
    (mode_tile "nolalist" 1)
    (mode_tile "outlalist" 1)
)
(defun actpart()
    (set_tile "error" "")
    (set_tile "subassem" "0")
    (mode_tile "subpath" 1)
    (mode_tile "auto" 0)
    (mode_tile "onebyone" 0)
    (set_tile "subpath" "")
    (set_tile "partpath" (getvar "dwgprefix"))
    (mode_tile "partpath" 0)
    (mode_tile "oldlay" 0)
    (mode_tile "lay0" 0)
    (mode_tile "fcode" 0)
    (mode_tile "bcode" 0)
    (mode_tile "code" 0)
    (mode_tile "exe" 0)
    (mode_tile "nolalist" 0)
    (mode_tile "outlalist" 0)
)

;;計算花費幾分幾秒 st:起時cdate  et: 終時cdate
(defun howtime(st et / st stt sthour stmin stsec et ett ethour etmin etsec ttime)
 (setq st (rtos st 2 10)
       stt (substr st (1+ (get_word st ".")))
       sthour (* 60 60 (atoi (substr stt 1 2)))
       stmin (* 60 (atoi (substr stt 3 2)))
       stsec (atoi (substr stt 5 2)))
 (setq et (rtos et 2 10)
       ett (substr et (1+ (get_word et ".")))
       ethour (* 60 60 (atoi (substr ett 1 2)))
       etmin (* 60 (atoi (substr ett 3 2)))
       etsec (atoi (substr ett 5 2)))
 (setq ttime (- (+ ethour etmin etsec) (+ sthour stmin stsec)))
 ttime
)


;;============================================================================================
(defun act_outlist(/ rtf data wr_outlist)
;     (setq rtf (open (strcat POWdesign_data_path "dwgdata.txt") "r"))
     (setq rtf (open (strcat POWdesign_path "dwgdata.txt") "r"))
     (setq data (read-line rtf))
     (setq wr_outlist '())
     (while data
        (setq wr_outlist (cons (substr data (1+ (get_word data ";"))) wr_outlist)      )
        (setq data (read-line rtf))
     );while
     (close rtf)
     (reverse wr_outlist)   ; ("料號" "品名" "機種" "#圖號" "製圖" "規格" "數量" "英文品名" "表面處理" "材質 " "說明")
)

;;;
(defun pdm_get_curset(/ yy data1 ffcod cnum water_num bbcod)
;("BA1B1" "002" "自動夾緊機" "護罩" "2D 零件圖")
;3
   (if (= yyesno "Yes")
     (progn
 ;      (startapp (strcat POWERPDM_path "partout.exe"))
 ;      (setq yy (open (strcat POWERPDM_path "partout.txt") "r"))
 ;      (setq data1 (read (read-line yy)))
 ;      (setq ffcod (nth 0 data1)
 ;            cnum (nth 1 data1))
 ;     (setq water_num (read-line yy))
 ;     (close yy)

        (startapp (strcat powerpdm_path "\\autocad\\ACADpartout\\partout.exe"))
        (setq yy (open (strcat POWERPDM_path "\\temp\\partout.txt") "r")) 
        (setq data1 (read (read-line yy)))
        (setq data2 (read (read-line yy)))
        (setq data3 (read (read-line yy)))
        (close yy)
        (setq ffcod (nth 0 data1))
        (setq cnum (nth 1 data1))
        (setq bbcod (nth 2 data1))
        (setq water_num (rtos (strlen cnum) 2 0))    ;;流水號幾位數
     );progn
   );progn
;   (list ffcod cnum water_num)
   (list ffcod cnum water_num bbcod)

)

(defun get_att_data_list(/ tt_list att qq TAG# dda)
;(defun get_att_data_list()
 (ccctest)
  (setq tt_list '())
  (foreach qq partdata
     (setq att (nth 1 qq))
     (if (/= "" att)
       (progn
         (setq TAG# (nth 2 qq))
         (setq dda (nth 1 (assoc TAG# attdata)))
         (setq tt_list (cons (list att dda) tt_list))
       );progn
     );if
  );foreach
;; tt_list --> (("TYPE" "") ("SURFACE" "") ("QTY" "") ("DRAWER" "") ("DWGNO" "") (" MATERIAL" "") ("DWGNAME" "軸承蓋"))
;;  sel_sheet_list   ;;("藝祥圖框" "藝祥 A4")
   (setq aaa (read (getfile_val (strcat POWDESIGN_path "shscal.ini") "POWERPDM圖框屬性與CAD圖框對應")))
;;; aaa -> (("屬性一" "藝祥圖框" "atttemp1.txt")("屬性二" "標準屬性圖框" "atttemp2.txt"))
  ;(setq att_name (nth 0 sel_sheet_list))
   (setq att_name sel_sheet_list)
   (foreach qq aaa
     (progn
;      (if (= (nth 1 qq) att_name) (setq sh_type (nth 0 qq) tmpfile (nth 2 qq)))    ;;sh_type -> "屬性一"
       (if (= (nth 1 qq) att_name) (setq sh_type (nth 0 qq)))  ;;sh_type -> "屬性一"
     );progn
   );foreach

   (setq datatxt "")
   (foreach ee attlist
      (progn
                           ; ee -> ("屬性一" "FD_12" "8" "設變單號" "DWGNO_C" "0")
                           ; tt_list --> (("TYPE" "") ("SURFACE" "") ("QTY" "") ("DRAWER" "") ("DWGNO" "") (" MATERIAL" "") ("DWGNAME" "軸承蓋"))
         (setq TAG (nth 4 ee)
               num (nth 2 ee))
         (setq txt_list (assoc TAG tt_list))
         (if (= (nth 1 ee) "FD_01")
           (progn
              (setq txt ddwgname)
           ;  (setq txt (strcat ffcod txt0 cnum))
              (setq newtxt (col_tab (- (atoi num) (strlen txt))))
              (setq datatxt (strcat datatxt txt newtxt))
           );progn
           (progn
              (if (/= nil txt_list)
                (progn
                  (setq txt (nth 1 txt_list))
                  (setq newtxt (col_tab (- (atoi num) (strlen txt))))
                  (setq datatxt (strcat datatxt txt newtxt))
                );progn
                (progn
                  (setq newtxt (col_tab (atoi num)))
                  (setq datatxt (strcat datatxt newtxt))
                );progn
              );if
           );progn
         );if
      );progn
   );foreach
)

(defun ccctest()
    (setq qq (open (strcat powerpdm_path "\\temp\\pdmcad.txt") "r"))
    (setq data (read-line qq) attlist '())
    (while data
      (setq datalist (read data))
      (if (= (nth 0 datalist) sh_type)(setq attlist (cons datalist attlist)))
      (setq data (read-line qq))
    );while
    (close qq)
    (setq attlist (reverse attlist))
)

;;trans_datatx ==> powerpdm 20001
(defun trans_datatxt(ffdata)

  (if (null powerpdm_sheet_att_def)(load "shscal"))
 ; pdm_sheetatt (("CADNO" "8")("DWGNO" "12")("DWGNAME" "36")("TYPE" "12")("DRAWER" "8")("DATE1" "8")("SCALE" "6")("DATE2" "8")("MATERIAL" "12")("QTY" "4")("DATE_C" "8")("DRAWING_C" "8")("DWGNO_C" "8"))

  (setq countt 1 txtcount 1 ootxt "")

  (setq edms_sheetatt (powerpdm_sheet_att_def "1"))  ;POWERPDM 2001  未完成

  (foreach nn edms_sheetatt
    (progn
       (setq attdata (substr ffdata txtcount (atoi (nth 1 nn))))
;;檢查 attdata 是否是 "    ";若是則將 attdata 變成 "",否則去除 attdata 前後之空格       PDM2001
       (if (/= 0 (setq num (strlen attdata)))                                        ;PDM2001
         (progn                                                                      ;PDM2001
            (setq txt_flag nil acount 1)                                             ;PDM2001
            (repeat num                                                              ;PDM2001
              (if (/= " " (substr attdata acount 1))(setq txt_flag t))              ;PDM2001
              (setq acount (1+ acount))                                             ;PDM2001
            );repeat                                                                 ;PDM2001
            (if (null txt_flag) (setq attdata "")                                    ;PDM2001
              (progn                                                                 ;PDM2001
                 (setq attdata (getrealstr4 attdata)) ;;去除文字串前後面所有空格      ;PDM2001
              );progn                                                                ;PDM2001
            );if                                                                     ;PDM2001
          );progn                                                                     ;PDM2001
       );if 
                                                                            ;PDM2001
       (if (/= "" attdata) (setq ootxt (strcat ootxt ";" attdata))
                           (setq ootxt (strcat ootxt ";nil")))
;       (princ ootxt)
       (setq txtcount (+ txtcount (atoi (nth 1 nn))) countt (1+ countt))
    );progn
  );foreach

  (substr ootxt 2)

  
)

;(defun exeout(/ pdmdata ffcod cnum water_num qq data datalist)
(defun exeout()
 (if (= "Yes" yyesno)
   (progn
     (setq pdmdata (pdm_get_curset))
     (setq ffcod (nth 0 pdmdata)           ;; ffcode 前置碼
           bbcod (nth 3 pdmdata)           ;; bbcode 後置碼
           cnum (nth 1 pdmdata)            ;; cnum  目前拆圖可用起始編號
           water_num (nth 2 pdmdata))      ;; 流水號位數

 ;   (startapp (strcat powerpdm_path "sendtitle.exe"))   ;;產生 pdmcad.txt 所有圖框類型屬性於 powerpdm 目錄內

    (ccctest)
   );progn
 );if

 (setq attlist_bak attlist)
 (initget "Yes No")
 (princ "\n拆圖後不保留原圖所花費的時間, 會減少 50% ....")
 (setq undoyesno (getkword "\n拆圖後是否 OOPS 保留原圖<NO>: "))
 (if (or (null undoyesno) (= "No" undoyesno))(setq undoyesno "No")(setq undoyesno "Yes"))
 (setq stime (getvar "cdate"))
 (cond
    ((and (= "1" part) (= "1" auto))
     (head)
     (setq lalst outlalist)

     (setq ddwg (substr (getvar "dwgname") 1 (- (get_word (getvar "dwgname") ".") 1)))
     (if (/= "Yes" yyesno) (setq doc_file (open (strcat dwg_path ddwg ".doc") "w")))

     (setq manadwg_transfile (open  (strcat POWdesign_path "data.txt") "w"))

     (setq acount 1)
     (setq partdata (read (getfile_val (strcat POWdesign_path "system.ini") "零件定義資料")))
     (setq chk_list (act_outlist))  ; ("料號" "品名" "機種" "#圖號" "製圖" "規格" "數量" "英文品名" "表面處理" "材質 " "說明")
   
     (if (= "Yes" yyesno)
       (progn
         (setq ii (open (strcat powerpdm_path "temp\\topdmatt.txt") "w")) 
         (write-line (getvar "dwgprefix") ii)                                  ;;powerpdm 2001
         (write-line $pdm_user ii)                                             ;;powerpdm 2001
         (write-line $pdm_case_type ii)                                        ;;powerpdm 2001
         (write-line $pdm_tree_id ii)                                          ;;powerpdm 2001
         (write-line $pdm_water_id ii)                                         ;;powerpdm 2001
         (write-line "1" ii)                                                   ;;;未完成  ;;powerpdm 2001
         (close ii)
       );progn
     );progn
     
     (command "layer" "s" (nth 0 lalst) "")
     
     (foreach nn lalst
       (progn
         (if (null findbomp_ent)(load "manapart")) 
         (setq infp (findbomp_ent nn))
         (if (/= nil infp)
           (progn
             (setq attdata (get_bomdata infp))    ;取出 infp 資訊點的屬性串列 (("TAG1" "aaa") ("TAG2" "bbb") ("TAG3" "ccc")...)

             (setq otxt nn) ;;圖層即料號
             (foreach qq (cdr chk_list)
               (progn

            ;     (if (/= qq "未定")
             ;      (progn
                      (setq ad1 (assoc qq partdata))           ;;ad1 ("品名" "PARTNAME"  "TAG3" "A_02")

                  (if (/= nil ad1)
                    (progn
                      (setq ad1_id (nth 2 ad1))                ;;ad1_id  "TAG3"
                      (setq tt (nth 1 (assoc ad1_id attdata)))  ;;tt      "ccc"
                      (if (= "" tt)(setq tt "nil"))

                      (setq otxt (strcat otxt ";" tt))
           ;         );progn
           ;      );if
                    );progn
                  );if 
               );progn
             );foreach
             (write-line otxt manadwg_transfile)
           );progn
        );if
        (setq ent_la nn
              layname_doc ent_la
              lay_na ent_la)

   ;   (command "layer" "s" nn "")
   ;   (command "layer" "f" "*" "t" nn "")
   ;   (command "zoom" "e")

        (process)
        (if (and (/= nil datatxt)(/= nil infp))
          (progn
;            (write-line datatxt ii)
           
            (setq ii (open (strcat powerpdm_path "temp\\topdmatt.txt") "a")) 

            (setq aapp (trans_datatxt datatxt))

            (write-line aapp ii)

            (close ii)

            (setq yy (open (strcat powerpdm_attribdata_path ddwgname  ".txt") "w"))
            (write-line datatxt yy) 
            (write-line "1" yy)                         ;;未完成
            (write-line out_dwgname yy)
            (close yy)  ;;yy -> 屬性萃取資料檔
          );progn
        );if

    ;  (command "layer" "t" "*" "")


       );progn
     );foreach

   (command "layer" "t" "*" "")
   (command "zoom" "e")

     (if (= "Yes" yyesno) (progn (close ii)(startapp (strcat powerpdm_path "\\autocad\\acadpartout\\topdmatt.exe"))))
     (close manadwg_transfile)

     (if (/= "Yes" yyesno) (close doc_file))
     (princ "\n======================================================")
     (setq acount nil)
     (princ (strcat "\n   拆零件完成,並已產生 " (strcase (strcat dwg_path ddwg ".doc"))))
     (setq etime (getvar "cdate"))
     (setq tsec (howtime stime etime))
     (setq tmin (/ tsec 60))
     (setq tsec (- tsec (* tmin 60)))
     (princ (strcat "\n自動拆出 " (rtos (length lalst) 2 0) " 個零件共費時 " (rtos tmin 2 0) " 分" (rtos tsec 2 0) " 秒!"))
     (setq tsec (* 50 (length lalst)))
     (setq min_v (/ tsec 60))
     (setq sec (- tsec (* min_v 60)))
     (princ (strcat "\n傳統手動拆一個零件約需 50 秒," (rtos (length lalst) 2 0) " 個零件共需費時 " (rtos min_v 2 0)
                  " 分" (rtos sec 2 0) " 秒!"))
    )
    ((and (= "1" part) (= "1" onebyone))
      (setq acount 1)
      (setq ddwg (substr (getvar "dwgname") 1 (- (get_word (getvar "dwgname") ".") 1)))
      (head)
;      (if (/= "Yes" yyesno) (setq doc_file (open (strcat (getvar "dwgname") ".doc") "w")))
      (if (/= "Yes" yyesno) (setq doc_file (open (strcat dwg_path ddwg ".doc") "w")))
      (setq entdata (entsel "\n選取欲拆出的零件:"))
      (while entdata
             (setq sel_la (cdr (assoc 8 (entget (car entdata)))))
             (setq lay_na sel_la ent_la sel_la
                   layname_doc ent_la)
             (process)
             (command "zoom" "e")
             (setq entdata (entsel "\n選取欲拆出的零件:"))
             (if (= entdata nil)
                 (progn
                      (if (/= "Yes" yyesno) (close doc_file))
                      (princ "\n======================================================")
                     ; (princ (strcat "\n   拆零件完成,並已產生 " (getvar "dwgname") ".DOC"))
                      (princ (strcat "\n   拆零件完成,並已產生 " dwg_path ddwg ".DOC"))
                      (princ)
                 )
             );if
      );while
    )
    ((= "1" subassem)
       (setq group (car (entsel "\n選取欲拆出的零件層: ")))
       (princ "\n選取欲拆出的零件層/ <或按 ENTER 鍵以結束指令之執行>: ")
       (setq group (cdr (assoc 8 (entget group))) gro-name (list group))
       (princ group)
       (setq group (car (entsel "")))
       (while group
              (setq group (cdr (assoc 8 (entget group))) gro-name (cons group gro-name)
                    group (car (entsel (strcat "," group)))
              )
       )
       (setq count 1)
       (setq pout-gro (ssget "x" (list (cons 8 (nth 0 gro-name)))))
       (repeat (- (length gro-name) 1)
               (SETQ ADD (ssget "x" (list (cons 8 (nth count gro-name)))))
               (SETQ ACOUN 0)
               (REPEAT (SSLENGTH ADD)
                       (SETQ POUT-GRO (SSADD (SSNAME ADD ACOUN) POUT-GRO)
                            ACOUN (1+ ACOUN))
               )
               (setq count (1+ count))
       )
       (setq outent POUT-GRO)
      ;(setq out_dwgname nil)
       (setq out_dwgname (getstring "\n檔名: ")
             out_dwgname (strcase (strcat subpath out_dwgname)))
       (princ (strcat "\n拆出次組合圖 " out_dwgname ".DWG ............"))
       (if (findfile (strcat out_dwgname ".dwg"))
           (progn
                (princ (strcat out_dwgname ".DWG 已經存在 !!"))
                (setq yesno (strcase (getstring "\n是否要將該檔覆蓋<Y>: ")))
                (if (or (= yesno "") (= yesno "Y"))
                    (progn
                         (setq insp (getpoint "\n插入點: "))
                         (command "wblock" out_dwgname "y" "" insp outent "")
                    );progn
                );if
           );progn
           (progn
                (setq insp (getpoint "\n插入點: "))
                (command "wblock" out_dwgname "" insp outent "")
                (princ "    完成!")
           );progn
       );if

       (if (= undoyesno "Yes") (command "oops"))
     );end of (= "1" subassem)
  );cond
  (princ)
)

(defun head()
     (setq dwg_path partpath)
     (if (= "Yes" yyesno)
       (setq insp (list 0 0 0 ))
       (setq insp (getpoint "\n零件插入點: "))
     )
)
(defun process()
        (if (ssget "x" (list (cons 8 lay_na)))
          (progn

                 (command "layer" "s" lay_na "") 
              ;  (command "layer" "f" "*" "t" (strcat lay_na ",0,$partref_bom") "")
                 (command "layer" "f" "*" "t" (strcat lay_na ",0") "")
                 (command "zoom" "e")
                 
                 (setq lay_na ent_la)
                 (setq ent_laa ent_la)
                 (str_dwgname)
                 (lay_doc) 

                 (command "layer" "t" "*" "")
             ;   (command "zoom" "e")

          );progn
       );if
)
(defun lay_doc()
  (setq lay_data (tblsearch "LAYER" ent_la))
  (setq 1txt (strcat out_dwgname " "))
  (setq 2txt (strcat layname_doc " "))
  (setq 3txt (rtos (cdr (assoc 62 lay_data)) 2 0))
  (if (/= "Yes" yyesno) (write-line (strcat 1txt 2txt 3txt) doc_file))
)
(defun chg##()
;;;POWERPDM
;    (setq ffcod (nth 0 pdmdata)
;          cnum (nth 1 pdmdata)
;          water_num (nth 2 pdmdata))
   (if (= "Yes" yyesno)
       (progn

            (setq cnum (rtos (atoi cnum) 2))

            (setq len (strlen cnum))

            (setq txt0 "")

            (repeat (- (atoi water_num) len)

               (setq txt0 (strcat txt0 "0"))
            )

            (setq ddwgname (strcat ffcod txt0 cnum bbcod))            ;;powerpdm 2001
            (setq out_dwgname (strcat partpath ffcod txt0 cnum bbcod))
            (setq cnum (rtos (1+ (atoi cnum)) 2 0))
            (setq datatxt (get_att_data_list))   ;;寫出轉入 powerpdm 的資料 topdmatt.txt
       );progn
   );if
;;----------------
   (if (= "1" onebyone) ;;一個一個拆
       (princ (strcat "\n零件拆出成 " (strcase out_dwgname) ".DWG............"))
   );if
   (if (= "1" auto) ;;自動拆
       (princ (strcat "\n零件拆出成 " (strcase out_dwgname) ".DWG............" (rtos acount 2 0) "/" (rtos (length lalst) 2 0)))
   );if
   (setq list-num 0)
   (repeat (length ltcolo)
       (setq ent-lt-c (nth list-num ltcolo))
       (if (ssget "x" (list (cons 8 lay_na) (cons 6 (car ent-lt-c))))
         (progn
           (if (= "2" outlay)
             (command "chprop" "p" "" "c" (cadr ent-lt-c) "la" "0" "")
             (command "chprop" "p" "" "c" (cadr ent-lt-c) "")
           );if
         );progn
       );if
       (setq list-num (1+ list-num))
   );repeat
   (if (= "2" outlay)
       (progn
            (if (ssget "x" (list (cons 8 lay_na)))
                (command "chprop" "p" "" "c" "7" "la" "0" "")
            );if
           (setq outent (ssget "x" (list (cons 8 "0"))))
       );progn
       (setq outent (ssget "x" (list (cons 8 lay_na))))
   );if
   (if (null findbomp_ent)(load "manapart"))

   (if (= "Yes" yyesno)
       (progn
            (if (findfile (strcat out_dwgname ".dwg"))
                (progn
                     (princ (strcat out_dwgname ".DWG 已經存在 !!"))
                     (initget "Y N")
                     (setq yesno (getkword "\n是否要將該檔覆蓋<Y>: "))
                     (if (null yesno) (setq yesno "Y"))
                );progn
            );if
       );progn
   );if
   (if (or (= yesno "") (= yesno "Y"))
       (progn
            (command "wblock" out_dwgname "y" "" insp outent "")
       )
       (progn
            (command "wblock" out_dwgname "" insp outent "")
       )
   )

   (if (= undoyesno "Yes")
       (progn
            (command "oops")
            (if (and (= "1" part) (= "1" onebyone)) ;;一個一個拆
                (command "chprop" outent "" "p" "la" lay_na "c" "BYLAYER" "")
                (command "chprop" outent "" "p" "la" nn "c" "BYLAYER" "")
            );if
       );progn
   );if
 ; (if (= "2" outlay)
 ;   (progn
 ;     (command "chprop" outent "" "p" "la" nn "c" "BYLAYER" "")
 ;   );progn
 ; );if
   (setq yesno nil)
   (princ "    完成拆零件動作.")
)
(defun str_dwgname()
     (if (= dwg_path "")
         (setq out_dwgname (strcat (getvar "dwgprefix") fcode ent_laa bcode))
         (setq out_dwgname (strcat dwg_path fcode ent_laa bcode))
     )
;    (PRINC OUT_DWGNAME)
     (if (findfile (strcat out_dwgname ".dwg"))
         (progn
              (princ (strcat (strcase out_dwgname) ".DWG 已經存在 !!"))
              (setq yesno (strcase (getstring "\n是否要將該檔覆蓋<Y>: ")))
              (if (or (= yesno "") (= yesno "Y"))
                  (progn
                  (if (ssget "x" (list (cons 8 lay_na)))
                      (progn
                           (chg##)
                           (setq acount (1+ acount))
                      )
                  );if
                  )
              )
         )
         (progn
              (chg##)
              (setq acount (1+ acount))
         );progn
      )
)



;;============================================================================================
(defun exenooutgrp()
  (setq fcode (strcase (get_tile "code")))
  (if (= "" fcode) (set_tile "error" "不拆出之零件圖層群組前置碼未輸入! ")
    (progn
    ; (setq grplist '())
      (setq len (strlen fcode))
      (foreach nn outlalist
         (progn
            (setq chkstr (substr nn 1 len))
            (if (= chkstr fcode)
              (progn
            ;   (setq nolalist (reverse nolalist))
                (setq nolalist (reverse (cons nn (reverse nolalist))))
             ;  (setq nolalist (reverse nolalist))
                (act_pop_list nolalist "nolalist")
                (setq outlalist (removelist nn outlalist))
                (act_pop_list outlalist "outlalist")
              );progn
            );if
         );progn
      )
    );progn
  )
  (set_tile "code" "")
)


(defun creat_nooutlist()
  (setq noout_id (read (strcat "(" (get_tile "outlalist") ")")))
  (setq nolalist (reverse nolalist))
  (foreach xx noout_id
       (setq nolalist (cons (nth xx outlalist) nolalist))
  )
  (setq nolalist (reverse nolalist))
  (act_pop_list nolalist "nolalist")

  (foreach xx nolalist
       (setq outlalist (removelist xx outlalist))
  )
  (act_pop_list outlalist "outlalist")

;  (if (= 0 (length outlalist)) (progn (mode_tile "out" 1)(mode_tile "noout" 1)))
  (mode_tile "out" 1)(mode_tile "noout" 1)
)

(defun creat_outlist()
      (setq out_id (read (strcat "(" (get_tile "nolalist") ")")))
      (setq outlalist (reverse outlalist))
      (foreach xx out_id
           (setq outlalist (cons (nth xx nolalist) outlalist))
      )
      (setq outlalist (reverse outlalist))
      (act_pop_list outlalist "outlalist")

      (setq nolalist_1 nolalist)
      (foreach xx out_id
           (setq nolalist (removelist (nth xx nolalist_1) nolalist))
      )
      (act_pop_list nolalist "nolalist")
;  (if (= 0 (length nolalist)) (progn (mode_tile "out" 1)(mode_tile "noout" 1)))
      (mode_tile "out" 1)(mode_tile "noout" 1)

)

;;pdm_out_ok   powerpdm 2001
(defun pdm_out_ok(/ part_out_qty otxt1 pdmoutff)                               ;;powerpdm 2001
    (setq part_out_qty (rtos (length outlalist) 2 0))                          ;;powerpdm 2001
    (if (= "" $pdm_bcode) (setq otxt1 (strcat $pdm_fcode ";nil"))              ;;powerpdm 2001
                          (setq otxt1 (strcat $pdm_fcode ";" $pdm_bcode)))     ;;powerpdm 2001
    (setq pdmoutff (open (strcat powerpdm_path "temp\\partnum.txt") "w"))      ;;powerpdm 2001
    (write-line otxt1 pdmoutff)                                                ;;powerpdm 2001
    (write-line $pdm_case_type pdmoutff)                                       ;;powerpdm 2001
    (write-line $pdm_tree_id pdmoutff)                                         ;;powerpdm 2001
    (write-line $pdm_water_id pdmoutff)                                        ;;powerpdm 2001
    (write-line part_out_qty pdmoutff)                                         ;;powerpdm 2001
    (close pdmoutff)
   ; (pdm_get_curset)
)
;(defun out_ok()
;  (pdm_out_ok)
;(setq out_flag nil)
;)
(defun out_ok()
  (if (and (/= nil powerpdm_path)(/= nil $pdm_dwgname)) (pdm_out_ok))  ;;powerpdm 2001
  (setq oldlay (get_tile "oldlay"))
  (setq subassem (get_tile "subassem"))
  (setq part (get_tile "part"))
  (setq auto (get_tile "auto"))
  (setq onebyone (get_tile "onebyone"))
  (setq subpath (get_tile "subpath"))
  (if (/= "" subpath)
    (progn
      (setq len (strlen subpath))
      (if (/= "\\" (substr subpath len 1))
        (setq subpath (strcat subpath "\\"))
      );if
    );progn
  );if
  (setq lay0 (get_tile "lay0"))
  (if (= "1" lay0) (setq outlay "2")(setq outlay nil))
  (setq partpath (get_tile "partpath"))
  (if (/= "" partpath)
    (progn
      (setq len (strlen partpath))
      (if (/= "\\" (substr partpath len 1))
        (setq partpath (strcat partpath "\\"))
      );if
    );progn
  );if
  (setq fcode (get_tile "fcode"))
  (setq bcode (get_tile "bcode"))
  (cond
    ((and (= "1" part)(= "" partpath)) (set_tile "error" "零件圖存放路徑未輸入! "))
    ((and (= "1" subassem) (= "" subpath)) (set_tile "error" "次組合圖存檔路徑未輸入! "))
    (T (setq out_flag t)(done_dialog))
  )
)

;╭════════════════════════════════════════════╮
;║設計日期: 1998. 6. 26                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 零件組合                                                                      ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:in(/ op part papt lay1 lay col ff fl ptxt fg data prts col_list)
 (setvar "cmdecho" 0)
   ;; DraftSight: 移除加密狗 WHILE 迴圈

;(setq partindel_layer '("DIM" "BORDER" "SHEET" "TEMP" "PROJ" "TEXT"))  ; part in 時自動刪除之圖層
 (setq partindel_layer (read (getfile_val (strcat powdesign_path "system.ini") "零件組合時刪除之圖層")))
 (setq partindel_block (read (getfile_val (strcat powdesign_path "system.ini") "零件組合時刪除之圖塊")))

 (initget "Auto Text Sel")
;(setq op (getkword "\n自選檔案 S/參考文字檔自動組零件 A/ 參考文字檔手動組合零件 T/ <手動一件一件組合>: "))
 (setq op (getkword "\n自選檔案 S/參考文字檔手動組合零件 T/ <手動一件一件組合>: "))
  (cond
  ((= op "Sel")
   ; (if (findfile (strcat powdesign_path "trans\\filelist.txt"))
   ;   (command "sh" (strcat "del" powdesign_path "trans\\filelist.txt"))
   ; )
     (startapp (strcat powdesign_path "selfile"))
     (getpoint "\n請選取檔案後按 Enter 鍵!")
     (if (findfile (strcat powdesign_path "trans\\filelist.txt"))
         (selfile_partin)
;      (princ "\nNo file!")
     );if
  );
  ((null op)
   (while (/= (setq part (strcase (getstring "\n輸入圖檔名/<或按 ENTER 鍵以結束指令之執行>: ") )) "")
    (if (setq fg (open (strcat part ".dwg") "r"))
     (progn
      (close fg)
      (setq lay (strcase (getstring "\n輸入層名/<或按 ENTER 鍵選取圖素>: ") ))
      (if (= lay "")
       (if (setq lay (car (entsel "\n選擇欲輸入的圖層圖素: ")))
        (setq lay (cdr (assoc 8 (entget lay))))
        (setq lay "")
       )
       (if (null (tblsearch "LAYER" lay))
        (progn
         (initget 7)
         (setq col (itoa (getint "\n圖層顏色號碼<紅=1 黃=2 綠=3 青=4 藍=5 紫=6 白=7>: ")))
         (setvar "regenmode" 0)
         (command "layer" "n" lay "c" col lay "")
         (setvar "regenmode" 1)
        )
       )
      )
      (if (/= lay "")
       (progn
        (if (null parin?)
         (setq parin? (list 0.0 0.0))
        )
        (setq papt parin?
              parin? (getpoint (strcat "\n零件 " part " 插入基準點 <"
              (rtos (car parin?)) "," (rtos (cadr parin?)) ">: "))
        )
        (if (null parin?)
         (setq parin? papt)
        )
        (prtin# part parin? lay T)
       )
      )
     )
     (princ (strcat "\n圖檔 " part ".DWG 不存在. 請再試一次 !"))
    )
   )
  )
  ((eq op "Text")
   (setq ff T)
   (while ff
    (while (= (setq ptxt (strcase (getstring "\n輸入參考文字檔名: "))) ""))
    (if (setq fl (open ptxt "r"))
     (setq ff nil)
     (princ (strcat "\n文字檔" ptxt " 不存在. 請再試一次 !"))
    )
   )
   (while (setq data (read-line fl))
    (setq data (strcase data) prts (prlst# data))
    (if (>= (length prts) 3)
     (progn
      (setq part (car prts) lay (cadr prts) col (itoa (atoi (caddr prts))))
      (if (= col "0") (setq col "7"))
      (if (setq fg (open (strcat part ".dwg") "r"))
       (progn
        (close fg)
        (if (null (tblsearch "LAYER" lay))
         (progn
          (setvar "regenmode" 0)
          (command "layer" "n" lay "c" col lay "")
          (setvar "regenmode" 1)
         )
        )
        (if (null parin?)
         (setq parin? (list 0.0 0.0))
        )
        (setq papt parin?
              parin? (getpoint (strcat "\n零件 " part " 插入基準點 <"
              (rtos (car parin?)) "," (rtos (cadr parin?)) ">: "))
        )
        (if (null parin?)
         (setq parin? papt)
        )
        (prtin# part parin? lay T)
       )
     (princ (strcat "\n圖檔 " part ".DWG 不存在. 請再試一次 !"))
      )
     )
    )
   )
   (close fl)
  )
  ((eq op "Auto")
;  (setq ff T)
;  (while ff
;   (while (= (setq ptxt (strcase (getstring "\n輸入參考文字檔名: "))) ""))
;   (if (setq fl (open ptxt "r"))
;    (setq ff nil)
;    (princ (strcat "\n文字檔" ptxt " 不存在. 請再試一次 !"))
;   )
;  )
   (setq ptxt (getfiled "選擇參考文字檔名" "" "doc" 8))
   (setq fl (open ptxt "r"))
   (if (null parin?)
    (progn
     (initget 1)
     (setq parin? (getpoint "\n零件插入點: "))
    )
    (progn
     (setq papt parin?)
     (setq parin? (getpoint (strcat "\n零件插入點 <"
                    (rtos (car parin?)) "," (rtos (cadr parin?)) ">: "))
     )
     (if (null parin?)
      (setq parin? papt)
     )
    )
   )
 (setq stime (getvar "cdate"))
   (setq acount 1)
   (while (setq data (read-line fl))
    (setq data (strcase data) prts (prlst# data))
    (if (>= (length prts) 3)
     (progn
      (setq part (car prts) lay (cadr prts) col (itoa (atoi (caddr prts))))
      (if (= col "0") (setq col "7"))
      (if (setq fg (open (strcat part ".dwg") "r"))
       (progn
        (close fg)
        (if (null (tblsearch "LAYER" lay))
         (progn
          (setvar "regenmode" 0)
          (command "layer" "n" lay "c" col lay "")
          (setvar "regenmode" 1)
         )
        )
        (prtin# part parin? lay nil)
       )
     (princ (strcat "\n圖檔 " part ".DWG 不存在. 請再試一次 !"))
      )
     )
    )
   (setq acount (1+ acount))
   )
   (close fl)
   (setq etime (getvar "cdate"))
     (setq tsec (howtime stime etime))
     (setq tmin (/ tsec 60))
     (setq tsec (- tsec (* tmin 60)))
     (princ (strcat "\n自動組合 " (rtos acount 2 0) " 個零件共費時 " (rtos tmin 2 0) " 分" (rtos tsec 2 0) " 秒!"))
     (setq tsec (* 80 acount))
     (setq min_v (/ tsec 60))
     (setq sec (- tsec (* min_v 60)))
     (princ (strcat "\n傳統手動組合一個零件約需 1 分 20 秒(含建層,換層及刪除不必要圖元)," (rtos acount 2 0) " 個零件共需費時 " (rtos min_v 2 0)
                  " 分" (rtos sec 2 0) " 秒!"))
  )
 )
 ;; removed FFF
 (princ)
)

(defun selfile_partin(/ ffq)
   (setq ffq (open (strcat powdesign_path "trans\\filelist.txt") "r"))
   (setq col_list (read (getfile_val (strcat powdesign_path "system.ini") "零件組合時預設之顏色")))
   (setq parin? (getpoint "\n零件插入點<0,0,0>: "))
   (if (null parin?) (setq parin? (list 0 0 0)))

   (setq stime (getvar "cdate"))
   (setq acount 1)
   (setq data (read-line ffq)) (setq col_id 0  col_idqty (length col_list))
   (while data
      (setq dwgname (get_filename data "\\"))
      (setq lay (substr dwgname 1 (- (get_word dwgname ".") 1)))    ;;層名
      (if (= col_idqty (1+ col_id)) (setq col_id 0))
      (setq col (rtos (nth col_id col_list) 2 0))                   ;; 顏色
      (setq col_id (1+ col_id))
      (setq part data)                                              ;; 圖名
      (if (null (tblsearch "LAYER" lay))
         (progn
          (setvar "regenmode" 0)
          (command "layer" "n" lay "c" col lay "")
          (setvar "regenmode" 1)
         )
      )
      (prtin# part parin? lay nil)
      (setq acount (1+ acount))
      (setq data (read-line ffq))
   );while
   (close ffq)
   (setq etime (getvar "cdate"))
   (setq tsec (howtime stime etime))
   (setq tmin (/ tsec 60))
   (setq tsec (- tsec (* tmin 60)))
   (princ (strcat "\n自動組合 " (rtos acount 2 0) " 個零件共費時 " (rtos tmin 2 0) " 分" (rtos tsec 2 0) " 秒!"))
   (setq tsec (* 80 acount))
   (setq min_v (/ tsec 60))
   (setq sec (- tsec (* min_v 60)))
   (princ (strcat "\n傳統手動組合一個零件約需 1 分 20 秒(含建層,換層及刪除不必要圖元)," (rtos acount 2 0) " 個零件共需費時 " (rtos min_v 2 0)
                  " 分" (rtos sec 2 0) " 秒!"))

)




(defun prlst# (data / prts sera pt space ch tx1)
 (setq prts nil sera 1 pt 1 space nil)
 (while (/= (setq ch (substr data pt 1)) "")
  (if (and (= ch " ") (null space))
   (setq tx1 (substr data sera (- pt sera))
         prts (append prts (list tx1))
         space T
   )
  )
  (if (and (/= ch " ") space)
   (setq space nil sera pt)
  )
  (setq pt (1+ pt))
 )
 (if (and (null space) (> pt sera))
  (setq tx1 (substr data sera (- pt sera))
        prts (append prts (list tx1))
  )
 )
 prts
)
(defun prtin# (par pt layr ck / e0 en s0 papt)
;(defun prtin# (par pt layr ck)
 (if (entnext)
  (progn
   (setq e0 (entlast))
   (while (setq en (entnext e0))
    (setq e0 en)
   )
  )
  (setq e0 nil)
 )
 (princ (strcat "\n零件 " par " 插入中..."))
 (command "zoom" "e")
 (if (= acad_ver "GENIUS")
     (command ".insert" (strcat "*" par) pt "1" "0")
     (command "insert" (strcat "*" par) pt "1" "0")
 )
 (setq s0 (ssadd))
 (if (null e0)
  (progn
   (setq e0 (entnext))
   (ssadd e0 s0)
   (while (entnext e0)
    (ssadd (setq e0 (entnext e0)) s0)
   )
  )
  (while (entnext e0)
   (ssadd (setq e0 (entnext e0)) s0)
  )
 )
 (if (null pub_bom_sheet) (load "manapart"))
;(setq aaaa s0 bbbb layr)
 (setq sheet_have nil)
 (setq sheet_have (pub_bom_sheet s0 layr))   ; sheet_have 有值: 有圖框屬性
                                             ;             nil: 無圖框屬性
 (foreach nn partindel_layer
   (progn
     (setq selg (ssget "x" (list (cons 8 nn))))
     (if selg
         (progn
           (if (= acad_ver "GENIUS")
               (command ".erase" selg "")
               (command "erase" selg "")
           )
         )
     )
     (princ ".")
   );progn
 )
;(if (/= sheet_have nil) (entdel bom_ballent))     ;;bom_ballent 由 manapart.lsp (get_sheetatt) 程式產生


 (setq bom_ballent nil)
 (foreach nn partindel_block
   (progn
     (setq selg (ssget "x" (list (cons 2 nn))))
     (if selg (command "erase" selg ""))
     (princ ".")
   );progn
 )

;(setq s0 (ssadd))
;(if (null e0)
; (progn
;  (setq e0 (entnext))
;  (ssadd e0 s0)
;  (while (entnext e0)
;   (ssadd (setq e0 (entnext e0)) s0)
;  )
; )
; (while (entnext e0)
;  (ssadd (setq e0 (entnext e0)) s0)
; )
;)
 (setq bomb (ssget "x" (list (cons 0 "INSERT") (cons 8 "0") (cons 2 "PARTREF"))))
 (if (/= nil bomb)
    (command "chprop" s0 bomb "" "la" layr "c" "bylayer" "")
    (command "chprop" s0 "" "la" layr "c" "bylayer" "")
 )
 (if ck
  (progn
   (command "move" s0 "" pt)
   (princ (strcat "\n零件 " par " 插入點 --> ["
                 (rtos (car parin?)) "," (rtos (cadr parin?)) "]: "))
   (command pause "rotate" s0 "" "@")
   (princ "\n旋轉角度: ")
   (command pause)
  )
 )
)
;;╭════════════════════════════════════════════╮
;;║設計日期: 1998.04.30                                                                    ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 連續編號指標球                                                                ║
;;║執行方式: (autobom btype)                                                               ║
;;║相關檔案: system.lsp(deflayer)                                                          ║
;;╰════════════════════════════════════════════╯
;
;;自由拉出(連續編號)        (AUTObom 1)
;;向上定距指標球(連續編號)  (AUTObom 90)
;;向下定距指標球(連續編號)  (AUTObom 270)
;;向左定距指標球(連續編號)  (AUTObom 0)
;;向右定距指標球(連續編號)  (AUTObom 180)
(defun autoBOM(btype)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
   (setvar "cmdecho" 0)
   (defun *error* (msg)
      (princ msg)
      (command "clayer" old_layer "cecolor" old_color)
      (setvar "cmdecho" 1)
   )
   (bomdata_yesno)
;  (make_layer sys_ball_layer sys_ball_layercol)
   (cond
     ((= btype 0)   (setq ballang 0))
     ((= btype 30)  (setq ballang (/ pi 6)))            ;FOR ISO
     ((= btype 90)  (setq ballang (* pi 0.5)))
     ((= btype 150) (setq ballang (* pi (/ 5 6.0))))    ;FOR ISO
     ((= btype 180) (setq ballang pi))
     ((= btype 210) (setq ballang (* pi (/ 7 6.0))))    ;FOR ISO
     ((= btype 270) (setq ballang (* pi 1.5)))
     ((= btype 330) (setq ballang (* pi (/ 11 6.0))))   ;FOR ISO
     (T (princ))
   )
   (setq old_osmode (getvar "osmode"))
   (setq old_layer (getvar "clayer"))
   (setq old_color (getvar "cecolor"))
   (setq scal (getvar "dimscale"))

   (setq firsttxt (getstring "\n按 ENTER 鍵略過/<輸入件號前置文字>: "))

   (if (null bomnum) (setq bomnum (getint "\n輸入起始件號: "))
      (progn
        (setq num (getint (strcat "\n輸入件號:< " (rtos bomnum 2 0) ">:")))
        (if (null num) (setq bomnum bomnum num t) (setq bomnum num))
      );progn
   )
   (setq bomtxt (strcat firsttxt (rtos bomnum 2 0)))
;  (setq bomtxt (rtos bomnum 2 0))
   (setq p1 (getpoint (strcat "\n選擇件號 " bomtxt " 起始點: ")))
   (if (/= btype 1)
     (progn
        (setq bomtxtp (getpoint p1 "\n件號位置:  "))
        (setq balldist (getdist bomtxtp "\n件號間距: "))
     )
   );if
   (while p1
     ;(setq bomtxt (rtos bomnum 2 0))
      (setq bomtxt (strcat firsttxt (rtos bomnum 2 0)))
      (if (= btype 1) (setq bomtxtp (getpoint p1 "\n件號位置:  ")))
      (setq ang (angle bomtxtp p1))

;;;球形為6角形
       (defun get_sixball_intp()
          (setq lent (entlast))
          (command "polygon" "6" bomtxtp "c" (* 0.5 scal (atof sys_ball_dia)))
          (command "explode" "l")
          (setq s1 (entnext lent)
                s2 (entnext s1)
                s3 (entnext s2)
                s4 (entnext s3)
                s5 (entnext s4)
                s6 (entnext s5)
                s1data (entget s1)
                s1data10 (cdr (assoc 10 s1data))
                s1data11 (cdr (assoc 11 s1data))
                s2data (entget s2)
                s2data10 (cdr (assoc 10 s2data))
                s2data11 (cdr (assoc 11 s2data))
                s3data (entget s3)
                s3data10 (cdr (assoc 10 s3data))
                s3data11 (cdr (assoc 11 s3data))
                s4data (entget s4)
                s4data10 (cdr (assoc 10 s4data))
                s4data11 (cdr (assoc 11 s4data))
                s5data (entget s5)
                s5data10 (cdr (assoc 10 s5data))
                s5data11 (cdr (assoc 11 s5data))
                s6data (entget s6)
                s6data10 (cdr (assoc 10 s6data))
                s6data11 (cdr (assoc 11 s6data)))
           (command "u")
           (cond
             ((/= nil (setq po_intp (inters p1 bomtxtp s1data10 s1data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s2data10 s2data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s3data10 s3data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s4data10 s4data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s5data10 s5data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s6data10 s6data11))))
           )
           po_intp
      );defun
      (cond
        ((= "1" sys_ball_yesno) (setq p2 (polar bomtxtp ang (* 0.5 scal (atof sys_ball_dia)))))
        ((= "0" sys_ball_yesno) (setq p2 (polar bomtxtp ang (* 0.9 scal (atof sys_balltxt_hei)))))
        ((= "2" sys_ball_yesno) (setq p2 (get_sixball_intp)))
      )
      (make_layer sys_ball_layer sys_ball_layercol)

      (if (> (distance bomtxtp p1) (distance bomtxtp p2))
        (progn
         (setq bomline_yes t)
         (command "line" p1 p2 "")
        )
         (setq bomline_yes nil)
      )   ;;;;;;;;;;;
      (cond
        ((and (= sys_ballpoint_type "1") bomline_yes) (command "donut" 0 (* scal (atof sys_ballpoint_size)) p1 ""))
        ((= sys_ballpoint_type "2")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat POWDESIGN_dwg_path "arror") p1 (* scal (getvar "dimasz")) "" (rtd (angle p1 bomtxtp)))
             (command "insert" (strcat POWDESIGN_dwg_path "arror") p1 (* scal (getvar "dimasz")) "" (rtd (angle p1 bomtxtp)))
         )
        )
        (T (princ))
      );cond

      (cond
        ((= "1" sys_ball_yesno) (command "circle" bomtxtp "d" (* scal (atof sys_ball_dia))))
        ((= "0" sys_ball_yesno) (princ))
        ((= "2" sys_ball_yesno) (princ))
      )
 ;    (if bomline_yes (command "line" p1 p2 ""))
      (command "text" "m" bomtxtp (* scal (atof sys_balltxt_hei)) "0" bomtxt)

      (if (= "Yes" bomdata_flag) (add_bomball_xdata (entlast) bomtxt))

      (command "clayer" old_layer "cecolor" old_color)
      (setq p1chk p1 p2chk p2 )
      (setq bomline_yes nil)
      (setq p1 (getpoint "\n選擇起始點: "))
      (if (and (/= btype 1) p1) (setq bomtxtp (polar bomtxtp ballang balldist)))
      (setq bomnum (1+ bomnum))
   );while
   (setvar "cmdecho" 1)
   ;; removed FFF
   (princ)
)


(defun bomdata_yesno()
  (initget "Yes No")
  (setq bomdata_flag (getkword "\n要不要輸入材料清單資料<Y> :"))
  (if (null bomdata_flag) (setq bomdata_flag "Yes"))
)



;;;==========================================================================================
;╭════════════════════════════════════════════╮
;║設計日期: 1998.04.30                                                                    ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 不連續編號指標球                                                              ║
;║執行方式: (keyin_bom btype)                                                             ║
;║相關檔案: system.lsp(deflayer)                                                          ║
;╰════════════════════════════════════════════╯

;自由拉出(不連續編號)        (keyin_bom 1)
;向上定距指標球(不連續編號)  (keyin_bom 90)
;向下定距指標球(不連續編號)  (keyin_bom 270)
;向左定距指標球(不連續編號)  (keyin_bom 0)
;向右定距指標球(不連續編號)  (keyin_bom 180)

(defun keyin_BOM(btype)
   (setvar "cmdecho" 0)
   (bomdata_yesno)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
   (make_layer sys_ball_layer sys_ball_layercol)
   (cond
     ((= btype 0)   (setq ballang 0))
     ((= btype 30)  (setq ballang (/ pi 6)))            ;FOR ISO
     ((= btype 90)  (setq ballang (* pi 0.5)))
     ((= btype 150) (setq ballang (* pi (/ 5 6.0))))    ;FOR ISO
     ((= btype 180) (setq ballang pi))
     ((= btype 210) (setq ballang (* pi (/ 7 6.0))))    ;FOR ISO
     ((= btype 270) (setq ballang (* pi 1.5)))
     ((= btype 330) (setq ballang (* pi (/ 11 6.0))))   ;FOR ISO
     (T (princ))
   )
   (setq old_osmode (getvar "osmode"))
   (setq old_layer (getvar "clayer"))
   (setq old_color (getvar "cecolor"))
   (setq scal (getvar "dimscale"))
   (setq firsttxt (getstring "\n按 ENTER 鍵略過/<輸入件號前置文字>: "))

   (if (null bomnum) (setq bomnum (getint "\n輸入件號: "))
      (progn
        (setq num (getint (strcat "\n輸入件號:< " (rtos bomnum 2 0) ">:")))
        (if (null num) (setq bomnum bomnum num t) (setq bomnum num))
      );progn
   )
   (setq bomtxt (strcat firsttxt (rtos bomnum 2 0)))
;  (setq bomtxt (rtos bomnum 2 0))
   (setq p1 (getpoint (strcat "\n選擇件號 " bomtxt " 起始點: ")))
   (if (/= btype 1)
     (progn
        (setq bomtxtp (getpoint p1 "\n件號位置:  "))
        (setq balldist (getdist bomtxtp "\n件號間距: "))
     )
   );if
    (if (= btype 1) (setq bomtxtp (getpoint p1 "\n件號位置:  ")))
   (while p1
;     (setq bomtxt (rtos bomnum 2 0))
   (setq bomtxt (strcat firsttxt (rtos bomnum 2 0)))
      (setq ang (angle bomtxtp p1))
      (cond
        ((= "1" sys_ball_yesno) (setq p2 (polar bomtxtp ang (* 0.5 scal (atof sys_ball_dia)))))
        ((= "0" sys_ball_yesno) (setq p2 (polar bomtxtp ang (* 0.9 scal (atof sys_balltxt_hei)))))
        ((= "2" sys_ball_yesno) (setq p2 (get_sixball_intp)))
      )
      (make_layer sys_ball_layer sys_ball_layercol)
      (cond
        ((= sys_ballpoint_type "1") (command "donut" 0 (* scal (atof sys_ballpoint_size)) p1 ""))
        ((= sys_ballpoint_type "2")
         (if (= acad_ver "GENIUS")
             (command ".insert" (strcat POWDESIGN_dwg_path "arror") p1 (* scal (getvar "dimasz")) "" (rtd (angle p1 bomtxtp)))
             (command "insert" (strcat POWDESIGN_dwg_path "arror") p1 (* scal (getvar "dimasz")) "" (rtd (angle p1 bomtxtp)))
         )
        )
        (T (princ))
      );cond
      (cond
        ((= "1" sys_ball_yesno) (command "circle" bomtxtp "d" (* scal (atof sys_ball_dia))))
        ((= "0" sys_ball_yesno) (princ))
        ((= "2" sys_ball_yesno) (princ))
      )
      (command "line" p1 p2 "")
      (command "text" "m" bomtxtp (* scal (atof sys_balltxt_hei)) "0" bomtxt)

      (if (= "Yes" bomdata_flag) (add_bomball_xdata (entlast) bomtxt))
      (command "clayer" old_layer "cecolor" old_color)

      (setq p1 (getpoint "\n選擇起始點: "))
      (if (and p1 (= btype 1)) (setq bomtxtp (getpoint p1 "\n件號位置:  ")))
      (if p1 (setq bomnum (getint (strcat "\n輸入件號:" firsttxt))))
      (if (and (/= btype 1) p1) (setq bomtxtp (polar bomtxtp ballang balldist)))
   );while
   ;; removed FFF
   (setvar "cmdecho" 1)
   (princ)
)

;;=============================================================================================
; 指標球 加入 xdata
;╭═════════════════════════════════════════════╮
;║設計日期: 1997.12. 9                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明: 將清單資料加入圖元                                                              ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: wordlib.lsp (pub_useword)                                                       ║
;╰═════════════════════════════════════════════╯
(defun add_bomball_xdata(ent partnum / flag)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
  (actdcl (strcat POWDESIGN_dcl_path "bom") "bomball_xdata")
  (setq count 1)
  (foreach nn defbomlist_list
     (progn
       (set_tile (strcat "label" (rtos count 2 0)) (nth 0 nn))
       (setq count (1+ count))
     )
  )
  (while (< count 21)
    (mode_tile (strcat "xdata" (rtos count 2 0)) 1)
    (setq count (1+ count))
  )

 (if (/= "14" autocad_ver) (mode_tile "lib" 1))
 (set_tile "xdata1" partnum)
 (action_tile "xdata1"  "(setq useword_keyname \"xdata1\")")
 (action_tile "xdata2"  "(setq useword_keyname \"xdata2\")")
 (action_tile "xdata3"  "(setq useword_keyname \"xdata3\")")
 (action_tile "xdata4"  "(setq useword_keyname \"xdata4\")")
 (action_tile "xdata5"  "(setq useword_keyname \"xdata5\")")
 (action_tile "xdata6"  "(setq useword_keyname \"xdata6\")")
 (action_tile "xdata7"  "(setq useword_keyname \"xdata7\")")
 (action_tile "xdata8"  "(setq useword_keyname \"xdata8\")")
 (action_tile "xdata9"  "(setq useword_keyname \"xdata9\")")
 (action_tile "xdata10" "(setq useword_keyname \"xdata10\")")
 (action_tile "xdata11" "(setq useword_keyname \"xdata11\")")
 (action_tile "xdata12" "(setq useword_keyname \"xdata12\")")
 (action_tile "xdata13" "(setq useword_keyname \"xdata13\")")
 (action_tile "xdata14" "(setq useword_keyname \"xdata14\")")
 (action_tile "xdata15" "(setq useword_keyname \"xdata15\")")
 (action_tile "xdata16" "(setq useword_keyname \"xdata16\")")
 (action_tile "xdata17" "(setq useword_keyname \"xdata17\")")
 (action_tile "xdata18" "(setq useword_keyname \"xdata18\")")
 (action_tile "xdata19" "(setq useword_keyname \"xdata19\")")
 (action_tile "xdata20" "(setq useword_keyname \"xdata20\")")

 (action_tile "lib" "(pub_useword (get_tile useword_keyname) useword_keyname)")
 (action_tile "accept" "(add_bomball_xdata_ok)(setq flag t)")
 (action_tile "cancel" "(done_dialog)(setq flag nil)")

 (start_dialog)

 (if flag (ad1xdata ent "BOMLIST_DATA" xdata))
   ;; removed FFF
 (prin1)
)

;;=============================================================================================
;╭═════════════════════════════════════════════╮
;║設計日期: 1998. 5. 7                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明: 修改圖元內清單資料                                                              ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: wordlib.lsp (pub_useword)                                                       ║
;╰═════════════════════════════════════════════╯
(defun mod_bomball_xdata(ent XXDATA / flag)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
  (actdcl (strcat POWDESIGN_dcl_path "bom") "bomball_xdata")
  (setq count 1)
  (foreach nn defbomlist_list
     (progn
       (set_tile (strcat "label" (rtos count 2 0)) (nth 0 nn))
       (setq count (1+ count))
     )
  )
  (while (< count 21)
    (mode_tile (strcat "xdata" (rtos count 2 0)) 1)
    (setq count (1+ count))
  )

 (if (/= "14" autocad_ver) (mode_tile "lib" 1))

 (setq count 0 cou 1)
 (repeat (length defbomlist_list)
;   (setq aa (cdr (cadr (assoc -3 XXDATA))))
    (setq xxd (cdr (cadr (assoc -3 XXDATA))))
    (set_tile (strcat "xdata" (rtos cou 2 0)) (cdr (nth count xxd)))
    (setq cou (1+ cou) count (1+ count))
 )

 (action_tile "xdata1"  "(setq useword_keyname \"xdata1\")")
 (action_tile "xdata2"  "(setq useword_keyname \"xdata2\")")
 (action_tile "xdata3"  "(setq useword_keyname \"xdata3\")")
 (action_tile "xdata4"  "(setq useword_keyname \"xdata4\")")
 (action_tile "xdata5"  "(setq useword_keyname \"xdata5\")")
 (action_tile "xdata6"  "(setq useword_keyname \"xdata6\")")
 (action_tile "xdata7"  "(setq useword_keyname \"xdata7\")")
 (action_tile "xdata8"  "(setq useword_keyname \"xdata8\")")
 (action_tile "xdata9"  "(setq useword_keyname \"xdata9\")")
 (action_tile "xdata10" "(setq useword_keyname \"xdata10\")")
 (action_tile "xdata11" "(setq useword_keyname \"xdata11\")")
 (action_tile "xdata12" "(setq useword_keyname \"xdata12\")")
 (action_tile "xdata13" "(setq useword_keyname \"xdata13\")")
 (action_tile "xdata14" "(setq useword_keyname \"xdata14\")")
 (action_tile "xdata15" "(setq useword_keyname \"xdata15\")")
 (action_tile "xdata16" "(setq useword_keyname \"xdata16\")")
 (action_tile "xdata17" "(setq useword_keyname \"xdata17\")")
 (action_tile "xdata18" "(setq useword_keyname \"xdata18\")")
 (action_tile "xdata19" "(setq useword_keyname \"xdata19\")")
 (action_tile "xdata20" "(setq useword_keyname \"xdata20\")")

 (action_tile "lib" "(pub_useword (get_tile useword_keyname) useword_keyname)")
 (action_tile "accept" "(add_bomball_xdata_ok)(setq flag t)")
 (action_tile "cancel" "(done_dialog)(setq flag nil)")

 (start_dialog)

  (if flag
    (progn
      (ad1xdata ent "BOMLIST_DATA" xdata)
      (setq newdata (cons 1 (cdr xdata1)))
      (setq newent (subst newdata (assoc 1 newent) newent))
      (entmod newent)

    )
  )
   ;; removed FFF
 (prin1)
)

(defun add_bomball_xdata_ok()
   (setq xdata1  (cons 1000 (get_tile  "xdata1")))
   (setq xdata2  (cons 1000 (get_tile  "xdata2")))
   (setq xdata3  (cons 1000 (get_tile  "xdata3")))
   (setq xdata4  (cons 1000 (get_tile  "xdata4")))
   (setq xdata5  (cons 1000 (get_tile  "xdata5")))
   (setq xdata6  (cons 1000 (get_tile  "xdata6")))
   (setq xdata7  (cons 1000 (get_tile  "xdata7")))
   (setq xdata8  (cons 1000 (get_tile  "xdata8")))
   (setq xdata9  (cons 1000 (get_tile  "xdata9")))
   (setq xdata10 (cons 1000 (get_tile "xdata10")))
   (setq xdata11 (cons 1000 (get_tile "xdata11")))
   (setq xdata12 (cons 1000 (get_tile "xdata12")))
   (setq xdata13 (cons 1000 (get_tile "xdata13")))
   (setq xdata14 (cons 1000 (get_tile "xdata14")))
   (setq xdata15 (cons 1000 (get_tile "xdata15")))
   (setq xdata16 (cons 1000 (get_tile "xdata16")))
   (setq xdata17 (cons 1000 (get_tile "xdata17")))
   (setq xdata18 (cons 1000 (get_tile "xdata18")))
   (setq xdata19 (cons 1000 (get_tile "xdata19")))
   (setq xdata20 (cons 1000 (get_tile "xdata20")))
   (setq xdata (list "BOMLIST_DATA" xdata1 xdata2 xdata3 xdata4 xdata5 xdata6 xdata7 xdata8 xdata9 xdata10
                                    xdata11 xdata12 xdata13 xdata14 xdata15 xdata16 xdata17 xdata18 xdata19 xdata20))
   (done_dialog)
  (princ)
)

;;=============================================================================================
;;;  產生材料清單圖形  (drawbom_list)
;╭════════════════════════════════════════════╮
;║設計日期: 1998.04.30                                                                    ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 產生材料清單圖形                                                              ║
;║執行方式: drawbom_list                                                                  ║
;║相關檔案: bom.dcl, system.lsp(deflayer)                                                 ║
;╰════════════════════════════════════════════╯
(defun c:drawbom_list(/ flag bomtype)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
 (setvar "cmdecho" 0)

; (setq firsttxt (getstring "\n按 ENTER 鍵略過/<輸入件號前置文字>: "))

  (actdcl (strcat POWDESIGN_dcl_path "bom") "drawbom_list")

  (mode_bomsld 253 -2 -2 -2)
  (setq bomtype 1)

  (if (null colh) (set_tile "colh" "8") (set_tile "colh" (rtos colh 2)))
  (if (null txth) (set_tile "txth" "4") (set_tile "txth" (rtos txth 2)))


  (action_tile "list1" "(mode_bomsld 253 -2 -2 -2)(setq bomtype 1)")
  (action_tile "list2" "(mode_bomsld -2 253 -2 -2)(setq bomtype 2)")
  (action_tile "list3" "(mode_bomsld -2 -2 253 -2)(setq bomtype 3)")
  (action_tile "list4" "(mode_bomsld -2 -2 -2 253)(setq bomtype 4)")


 (action_tile "accept" "(bomget_tile_val)")
 (action_tile "cancel" "(done_dialog)(setq flag nil)")

 (start_dialog)

 (if flag (drawbom_list_ok))

 (setvar "cmdecho" 1)
   ;; removed FFF
 (prin1)

)

(defun bomget_tile_val()
; (setq firsttxt (get_tile "firsttxt")
  (setq txth (atof (get_tile "txth"))
        colh (atof (get_tile "colh")))
  (cond
     ((= txth 0) (set_tile "error" "字高輸入錯誤<或空值>!"))
     ((= colh 0) (set_tile "error" "欄高輸入錯誤<或空值>!"))
     (T (done_dialog)(setq flag t))
  )
)


(defun mode_bomsld(col1 col2 col3 col4)
  (show_sld_col "list1" (strcat powdesign_sld_path "l-dnbom") col1)
  (show_sld_col "list2" (strcat powdesign_sld_path "r-dnbom") col2)
  (show_sld_col "list3" (strcat powdesign_sld_path "l-upbom") col3)
  (show_sld_col "list4" (strcat powdesign_sld_path "r-upbom") col4)
)


(defun drawbom_list_ok()
;(setq label_list '(("件號" "10") ("品名" "20")("材質" "30")("件號" "10") ("品名" "20")("材質" "30")("件號" "10") ("品名" "20")("材質" "30")))
;(setq tdata_list '(("1" "電源1" "ss412" "1" "電源1" "ss412" "1" "電源1" "ss412" )("1" "電源1" "ss412" "1" "電源1" "ss412" "2" "電源2" "ss414")("1" "電源1" "ss412" "1" "電源1" "ss412" "3" "電源3" "ss416")
;                   ("1" "電源1" "ss412" "1" "電源1" "ss412" "4" "電源4" "ss413")("1" "電源1" "ss412" "1" "電源1" "ss412" "5" "電源5" "ss415")("1" "電源1" "ss412" "1" "電源1" "ss412" "6" "電源6" "ss417")
;                  ))

   (getbomtxt_list)
   (setq old_osmode (getvar "osmode"))
   (setq old_layer (getvar "clayer"))
   (setq old_color (getvar "cecolor"))
   (setvar "osmode" 0)
   (make_layer sys_bomlist_layer sys_bomlist_layercol)
     (cond
      ((= bomtype 1) (free_list tdata_list defbomlist_list 0   270 colh "M" txth))
      ((= bomtype 2) (free_list tdata_list defbomlist_list 180 270 colh "M" txth))
      ((= bomtype 3) (free_list tdata_list defbomlist_list 0   90  colh "M" txth))
      ((= bomtype 4) (free_list tdata_list defbomlist_list 180 90  colh "M" txth))
     )
   (command "clayer" old_layer "cecolor" old_color)
   (setvar "osmode" old_osmode)
   (setvar "cmdecho" 1)
   (princ)

)


;;=============================================================================================
;; 取得指標數字之 xdata 串列
(defun getbomtxt_list()
   ;; DraftSight: 移除加密狗 WHILE 迴圈
  (setq insert_grp (ssget "x" (list (cons 8 sys_ball_layer)(cons 0 "TEXT"))))
  (if insert_grp
    (progn
     (princ "\n資料統計中 !!請稍候 !")
     (setq bomtxt_num (sslength insert_grp))
     (setq bomtxt_list '(""))
     (setq count 0)
     (repeat bomtxt_num
       (setq ent (ssname insert_grp count))
       (setq entdata (entget ent (list "BOMLIST_DATA")))
       (setq aa (assoc -3 entdata))
       (if (/= nil aa)
         (progn
             (setq 1data (cdr (assoc -1 entdata)))
             (setq bomtxt_list (cons 1data bomtxt_list))
         )
       )
       (setq count (1+ count))
     )
     (setq bomtxt_list (cdr (reverse bomtxt_list)))
     (setq tdata_list '())
     (foreach nn bomtxt_list
        (progn
          (princ ".")
          (setq ent_data (cdr (cadr (assoc -3 (getxdata nn "BOMLIST_DATA")))))
          (setq data_list '() count 0)
          (repeat (length defbomlist_list)
             (setq data (cdr (nth count ent_data))
                   data_list (cons data data_list)
                   count (1+ count))
          )
          (setq data_list (reverse data_list))
          (setq tdata_list (cons data_list tdata_list))
       );progn
     );foreach
     (setq tdata_list (reverse tdata_list))

  ;;;====== 數量加總
     (setq num_list '())
     (foreach nn tdata_list
       (progn
          (setq num (nth 0 nn))
          (setq num_list (cons num num_list))
       )
     )

     (setq num_list (int_list_sort 0 (reverse num_list)))     ;pub-lisp.lsp (int_list_sort)
  ; 數量加總
     (setq ssget_list '())
     (foreach nn num_list
         (progn
          (princ ".")
            (setq grp (ssget "x" (list (cons 8 sys_ball_layer)(cons 0 "TEXT")(cons 1 nn))))
            (setq ssget_list (cons grp ssget_list))
         )
     )(setq ssget_list (reverse ssget_list))
     (setq tdata_list '())
     (foreach nn ssget_list
       (progn
          (princ ".")
          (setq ent (ssname nn 0))
          (setq ent_data (cdr (cadr (assoc -3 (getxdata ent "BOMLIST_DATA")))))

          (setq data_list '() count 0)
          (repeat (length defbomlist_list)
             (setq data (cdr (nth count ent_data))
                   data_list (cons data data_list)
                   count (1+ count))
          );repeat
          (setq data_list (reverse data_list))
          (setq count 0 tqty 0)
  ;;當同件號圖元不只一件時,將數量加總
          (if (> (sslength nn) 1)
            (progn
               (repeat (sslength nn)
                 (progn
                    (setq ent_data (cdr (cadr (assoc -3 (getxdata (ssname nn count) "BOMLIST_DATA")))))
                    (setq qty (atoi (cdr (nth (- (atoi defbomqty_id) 1) ent_data))))
                    (setq tqty (+ qty tqty))
                 );progn
               );repeat
               (setq data1 (nth 0 data_list)
                     other_data (cdr data_list))
               (setq other_data (subst (rtos tqty 2 0) (nth (- (atoi defbomqty_id) 2) other_data) other_data))
               (setq data_list (cons data1 other_data))
            );progn
          );if
          (setq tdata_list (cons data_list tdata_list))
       );progn
     );foreach
     (setq tdata_list (reverse tdata_list))
    );progn
    (progn
      (setq tdata_list nil)
      (princ "\n   找不到件號球!!")
    );progn
  );if
   ;; removed FFF
   (princ)
)



;;=============================================================================================
;;;  刪除材料清單圖形
;╭════════════════════════════════════════════╮
;║設計日期: 1998.04.30                                                                    ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 刪除材料清單圖形                                                              ║
;║執行方式: delbom_list                                                                   ║
;║相關檔案: system.lsp(deflayer)                                                          ║
;╰════════════════════════════════════════════╯
(defun c:delbom_list()
   ;; DraftSight: 移除加密狗 WHILE 迴圈
  (setvar "cmdecho" 0)
  (if (setq bomgroup (ssget "x" (list (cons 8 sys_bomlist_layer))))
    (progn
      (initget "Yes No")
      (setq yesno (getkword "\n原清單圖形將被刪除<Y>: "))
      (if (or (null yesno) (= yesno "Yes"))
        (progn
           (if (= acad_ver "GENIUS")
               (command ".erase" bomgroup "")
               (command "erase" bomgroup "")
           )
           (princ "\n材料清單圖形已被刪除!")
        )
      )
    );progn
    (princ "\n沒有材料清單圖形!")

  );if
  (setvar "cmdecho" 1)
   ;; removed FFF
  (princ)
)



;;;編輯指標球
;;=============================================================================================
(defun c:addbomtxt_xdata(/ ent_data bomtxt partnum)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
   (setq bomtxt (car (entsel "\n選擇件號文字: ")))
   (if bomtxt
      (setq ent_data (cdr (cadr (assoc -3 (getxdata bomtxt "BOMLIST_DATA")))))
   )
   (if ent_data
     (progn
        (setq bomtxt_data (getxdata bomtxt "BOMLIST_DATA"))
        (if bomtxt_data
           (progn
              (setq partnum (cdr (assoc 1 bomtxt_data)))
              (mod_bomball_xdata BOMTXT bomtxt_data)
           )
           (progn
              (setq partnum (cdr (assoc 1 (entget bomtxt))))
              (add_bomball_xdata bomtxt partnum)
           )
        );if
     );progn
     (princ "\n您選擇的不是件號文字!!")
   );progn
   ;; removed FFF
   (princ)
)

(defun c:az()
   (gtxdata "BOMLIST_DATA")
)

;;=============================================================================================
;;; 產生材料清單文字檔
;╭════════════════════════════════════════════╮
;║設計日期: 1998.05. 9                                                                    ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 產生材料清單文字檔                                                            ║
;║執行方式:                                                                               ║
;║相關檔案: bom.dcl, system.lsp(deflayer)                                                 ║
;╰════════════════════════════════════════════╯
; defbomlist_list : (("件號" "15")("品名" "20")("材質" "10")("料號" "10")("數量" "10")("備註" "30"))
(defun c:bomlist_txt()
   ;; DraftSight: 移除加密狗 WHILE 迴圈

   (getbomtxt_list)
   (if tdata_list
     (progn
        (setq fname (getstring  "\n材料清單文字檔名: "))
        (while (= "" fname)
           (princ "\n未輸入檔名! 請再輸入一次 !!")
           (setq fname (getstring  "\n材料清單文字檔名: "))
        )

        (setq ff (open fname "w"))

        (foreach aa tdata_list
          (progn
            (setq count 0 outtxt "" data nil)
            (while (setq data (nth count aa))  ; data= "1"
               (setq qty (atoi (cadr (nth count defbomlist_list))))
               (setq coltab (col_tab (- qty (strlen data))))
               (if (= count 0)
                   (setq outtxt (strcat coltab data))
                   (setq outtxt (strcat outtxt coltab data))
               )
               (setq count (1+ count))
            );while
            (write-line outtxt ff)
          );progn
        );foreach

        (close ff)
        (cond ((null editword)(load "editword"))(t (princ)))
        (editword fname)
     );progn
   );if
   ;; removed FFF
   (princ)
)
