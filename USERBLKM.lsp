;;;;
  ;╭════════════════════╮
  ;║設計日期: 1996. 10.07   V1.0            ║
  ;║更新日期:                               ║
  ;║設 計 者: 陳冠達                        ║
  ;║功能說明: 符號庫管理主程式              ║
  ;║                                        ║
  ;║關聯檔案:pub-lisp(adxdata,Binilist)     ║
  ;╰════════════════════╯
(defun setlabel()
  (cond
    ((= 0 typ) (set_tile "label1" (strcat label1 ":"))(set_tile "label2" (strcat label2 ":"))
                (set_tile "label3" (strcat label3 ":"))(set_tile "label4" (strcat label4 ":"))
                (set_tile "label5" (strcat label5 ":"))(set_tile "memo" "圖形資料庫"))
    ((= 1 typ) (set_tile "label1" sys_label_def1)(set_tile "label2" sys_label_def2)
                (set_tile "label3" sys_label_def3)(set_tile "label4" sys_label_def4)
                (set_tile "label5" sys_label_def5)(set_tile "memo" "文字說明輸入格式: 中文 $ 英文 "))
    (T (princ))
  )
)

;; block_dataset : ("1" "品名；"廠牌" "規格" "料號" "材質")
;; block_dataset_id : (atoi "1") - 1 = 0
;; label1 : "品名"
;; label2 : "廠牌"
;; label3 : "規格"
;; label4 : "料號"
;; label5 : "材質"
;;typ=0 一般block管理 , typ=1 銘版圖庫管理
;(defun userblkm(dclfilename dialogname itemname sldname typ)
(defun userblkm(dclfilename dialogname itemname sldname typ / it readfile outfile nnname key_list
                item_data_list ipath dd addflag block_name yesno openfile blk_data headname)
;; 已移除加密狗判斷(progn ;; DraftSight: 移除加密狗 WHILE 迴圈
      (setvar "cmdecho" 0)
      (if (null block_system)  (c:get_block_set))
      (if readfile (setq readfile nil))
      (if it (setq it nil))
      (if outfile (setq outfile nil))
      ;(setq blank_list '((10 "")(20 "")(30 "")(40 "")(50 "")(60 "")(70 "")(80 "")(90 "")(100 "")(110 "")(120 "")(130 "")(140 "")(150 "")))                                              
      (setq nnname itemname)
      (setq block_file_name nil blk_name nil)
      (setq key_list '("sld11" "sld12" "sld13" "sld14" "sld15" "sld16" "sld17" "sld18"
                       "sld21" "sld22" "sld23" "sld24" "sld25" "sld26" "sld27" "sld28"
                       "sld31" "sld32" "sld33" "sld34" "sld35" "sld36" "sld37" "sld38"
                       "sld41" "sld42" "sld43" "sld44" "sld45" "sld46" "sld47" "sld48"))

     (set_tile "item_path" "符號資料正在讀取中! 請稍候!!")

;   (COUNT_PAGE)   ; 計算頁數

    (GET_ITEM_DATA)  ;取模組各圖檔詳細資料 (同USEBLOCK.LSP(UBLOCK_GET_ITEM_PAGE_DATA))

    (setq item_data_list (assoc itemname (nth 1 BLOCK_SYSTEM)))  ;item_data_lista 模組系統索引串列
    (setq ipath (cadr item_data_list))                          ;ipath 模組系統路目錄

     (show_blockm_dcl)
;    (if (null userblku)(load "userblku"))

   (defun reload_block_data()
      (setq aaa_page_data_list page_data_list)
      (foreach mm aaa_page_data_list
        (progn
         ; (setq num (substr (nth 0 mm) 7 2))
         ; (set_tile (strcat "txt" num) (nth 1 (nth 2 (cdr mm))))
           (setq num (substr (nth 0 mm) 7 2))
           (set_tile (strcat "txt" num) (nth 1 (nth block_dataset_id (cdr mm))))
        );progn
      );foreach
   );defun

     (reload_block_data)

     (setq dd (start_dialog))
     (dd_action)
     (unload_dialog dcl_id)
     (if addflag (progn (setq addflag nil)(userblkm "userblkm" "userblkm" nnname sldname typ)))
   (SETQ FFF nil))

    (setq it nil readfile nil outfile nil nnname nil key_list nil item_data_list nil ipath nil dd nil addflag nil block_name nil yesno nil
          openfile nil blk_data nil item_list nil page_now nil ff nil)
   (setq page_data_list nil dd nil nn nil creat_entity nil x nil y nil pgnum nil data1 nil
         data2 nil curlayer nil curcolor nil ins_point nil oosnape nil len nil p1 nil p2 nil
         p3 nil p4 nil l1 nil l2 nil ii nil it_pagelist nil itpagename nil itemdir nil headname nil
         sld_list nil ff nil block_system nil)
;;;將定義含數設為空值
   (setq setlabel nil userblkm nil show_blockm_dcl nil blockm_use_sld nil dd_action nil del_yesno nil modblock nil
         delblock nil moddata nil subok1 nil data_trans nil ndata nil subok nil deldata nil addblock nil
         get_item_data nil PAGE_DATA nil showpage nil mb_SHOW_POP nil blockm_show_data_on_dcl nil addpage nil )
         wfile pagenote c:get_block_set Binilist
   (setvar "cmdecho" 1)
     (princ)

 )

 (defun show_blockm_dcl()
     (actdcl dclfilename dialogname)

     (blockm_show_data_on_dcl)

     (mb_show_pop)
;     (action_tile "page" "(showpage $value)")
    (action_tile "page" "(showpage $value)(reload_block_data)")

     (action_tile "add_block" "(done_dialog 2)")
     (action_tile "mod_block" "(done_dialog 3)")
     (action_tile "del_block" "(done_dialog 4)")
     (action_tile "mod_data"  "(moddata)")

     (action_tile "page_data"  "(pagenote)")
     (action_tile "add_page" "(addpage)")
     (action_tile "accept" "(done_dialog)")

   (defun blockm_use_sld(key sld_code / sldkey x y)
      (if blk_name
        (progn
          (setq sldkey (strcat "sld" (substr blk_name 7 2)))
          (setq x (dimx_tile sldkey))
          (setq y (dimy_tile sldkey))
          (start_image sldkey)
          (fill_image 0 0 x y -2)
          (slide_image 0 0 x y (strcat headname (substr blk_name 7 2)))
          (end_image)
       ))

          (setq blk_name (strcase (strcat itemcode itpagename sld_code)))
          (setq x (dimx_tile key))
          (setq y (dimy_tile key))
          (start_image key)
          (fill_image 0 0 x y 8)
          (slide_image 0 0 x y (strcat headname sld_code))
          (end_image)

     (set_tile "block_note" (strcat "檔名:" blk_name ))

         (mode_tile "mod_block" 0)
         (mode_tile "add_block" 0)
         (mode_tile "del_block" 0)
         (mode_tile "mod_data" 0)
   )

   (action_tile "sld11" "(blockm_use_sld \"sld11\" \"11\")")
   (action_tile "sld12" "(blockm_use_sld \"sld12\" \"12\")")
   (action_tile "sld13" "(blockm_use_sld \"sld13\" \"13\")")
   (action_tile "sld14" "(blockm_use_sld \"sld14\" \"14\")")
   (action_tile "sld15" "(blockm_use_sld \"sld15\" \"15\")")
   (action_tile "sld16" "(blockm_use_sld \"sld16\" \"16\")")
   (action_tile "sld17" "(blockm_use_sld \"sld17\" \"17\")")
   (action_tile "sld18" "(blockm_use_sld \"sld18\" \"18\")")

   (action_tile "sld21" "(blockm_use_sld \"sld21\" \"21\")")
   (action_tile "sld22" "(blockm_use_sld \"sld22\" \"22\")")
   (action_tile "sld23" "(blockm_use_sld \"sld23\" \"23\")")
   (action_tile "sld24" "(blockm_use_sld \"sld24\" \"24\")")
   (action_tile "sld25" "(blockm_use_sld \"sld25\" \"25\")")
   (action_tile "sld26" "(blockm_use_sld \"sld26\" \"26\")")
   (action_tile "sld27" "(blockm_use_sld \"sld27\" \"27\")")
   (action_tile "sld28" "(blockm_use_sld \"sld28\" \"28\")")

   (action_tile "sld31" "(blockm_use_sld \"sld31\" \"31\")")
   (action_tile "sld32" "(blockm_use_sld \"sld32\" \"32\")")
   (action_tile "sld33" "(blockm_use_sld \"sld33\" \"33\")")
   (action_tile "sld34" "(blockm_use_sld \"sld34\" \"34\")")
   (action_tile "sld35" "(blockm_use_sld \"sld35\" \"35\")")
   (action_tile "sld36" "(blockm_use_sld \"sld36\" \"36\")")
   (action_tile "sld37" "(blockm_use_sld \"sld37\" \"37\")")
   (action_tile "sld38" "(blockm_use_sld \"sld38\" \"38\")")

   (action_tile "sld41" "(blockm_use_sld \"sld41\" \"41\")")
   (action_tile "sld42" "(blockm_use_sld \"sld42\" \"42\")")
   (action_tile "sld43" "(blockm_use_sld \"sld43\" \"43\")")
   (action_tile "sld44" "(blockm_use_sld \"sld44\" \"44\")")
   (action_tile "sld45" "(blockm_use_sld \"sld45\" \"45\")")
   (action_tile "sld46" "(blockm_use_sld \"sld46\" \"46\")")
   (action_tile "sld47" "(blockm_use_sld \"sld47\" \"47\")")
   (action_tile "sld48" "(blockm_use_sld \"sld48\" \"48\")")

 )


 (defun dd_action()
   (cond
     ((= dd 2) (addblock)(done_dialog)(setq addflag t))
     ((= dd 3) (modblock))
     ((= dd 4) (del_yesno))
   )
 )

 (defun del_yesno()
     (actdcl "userblkm" "del_yesno")

     (action_tile "accept" "(done_dialog)(setq dd_flag t)")
     (action_tile "cancel" "(done_dialog)")

     (start_dialog)

     (if dd_flag (delblock))
 )

 (defun modblock()
     (setq yesno (getstring "\n是否儲存目前圖檔<Y>?"))
     (if (or (= yesno "Y") (= yesno "YES") (= yesno ""))
       (progn
        (if (= acad_ver "GENIUS")
          (command ".save" (getvar "dwgname"))
          (command "save" (getvar "dwgname"))
        );if
       );progn
     )
     (command "point" '(0 0 0))
     (if (= acad_ver "GENIUS")
         (command ".erase" "l" "")
         (command "erase" "l" "")
     )
     (if (setq openfile (findfile (strcat bmanager_path ipath "\\" blk_name ".dwg")))
         (progn
             (if (/= "14" (substr (getvar "acadver") 1 2))
                 (progn
                     (setq sldfp (open (setq sldfppath (strcat bmanager_path ipath "\\" "openfile.scr")) "w"))
                     (write-line "open" sldfp)
                     (write-line openfile sldfp)
                     (close sldfp)
                 );progn
                 (progn     ;;;AutoCAD R14
                     (setq sldfp (open (setq sldfppath (strcat bmanager_path ipath "\\" "openfile.scr")) "w"))
                     (write-line "open" sldfp)
                     (write-line "y" sldfp)
                     (write-line openfile sldfp)
                     (close sldfp)
                 );progn
             );if
              ;(command "script" "openfile")
              (command "script" sldfppath)
         );progn  
         
         (progn
              (userblkm "userblkm" "userblkm" nnname sldname typ)
         )
     );if

     ;(if  (findfile (setq openfile (strcat bmanager_path ipath "\\" blk_name ".dwg")))
     ;    (progn
     ;         (command "script" "openfile")
     ;   );progn  
     ;    (progn
     ;         (userblkm "userblkm" "userblkm" nnname sldname typ)
     ;    );progn
     ;)
     (princ)
 )
 (defun delblock()
;   (command "files" "3" (strcat bmanager_path ipath "\\" blk_name ".dwg") ""
;                    "3" (strcat bmanager_path ipath "\\" blk_name ".sld") ""
;                    "0")
    (command "del" (strcat bmanager_path ipath "\\" blk_name ".dwg"))
    (command "del" (strcat bmanager_path ipath "\\" blk_name ".sld"))
    ;(setq page_data_list (subst (cons blk_name blank_list) (assoc blk_name page_data_list) page_data_list))
    (del_write)
    (userblkm "userblkm" "userblkm" nnname sldname typ)
    (setq dd_flag nil)
     (princ)
 )

 (defun moddata()
    ;***************************************** Load dcl file
    (new_dialog "mod_data" dcl_id)
    ;***************************************** Setting value to tile
    (setlabel)
    (setq blk_data (assoc blk_name page_DATA_list))
    (show_sld "mod_sld_name" (strcat bmanager_item_path itemdir "\\" blk_name))
    (set_tile "file_name" (strcat "檔名:" blk_name))       ;取檔名
    (set_tile "data1"     (cadr (assoc 10 (cdr blk_data))))       ;取品名
    (set_tile "data2"     (cadr (assoc 20 (cdr blk_data))))       ;取廠牌
    (set_tile "data3"     (cadr (assoc 30 (cdr blk_data))))       ;取規格
    (set_tile "data4"     (cadr (assoc 40 (cdr blk_data))))         ;取料號
    (set_tile "data5"  (cadr (assoc 50 (cdr blk_data))))

    (set_tile "blocknote" (cadr (assoc 60 (cdr blk_data))))       ;取備註

    (action_tile "accept" "(subok1)(done_dialog)")
    (start_dialog)
 )

 (defun subok1(/ out_data1 out_data10 out_data20 out_data30 out_data40 out_data50 out_data60 change_data change_data_id ffile tfile)
 ;("I0100111" (10 "直徑22平頭按鈕")(20 "廠牌")(30 "規格")(40 "日規")(50 "NO")(60 "備註")(70 "進價")(80 "售價")
 ;            (90 "")(100 "")(110 "")(120 "")(130 "")(140 "")(150 ""))
    (setq out_data1 blk_name)                        ;取檔名
    (setq out_data10 (txt_tran (get_tile "data1")))              ;取品名
    (setq out_data20 (txt_tran (get_tile "data2")))         ;取廠牌
    (setq out_data30 (txt_tran (get_tile "data3")))         ;取規格
    (setq out_data40 (txt_tran (get_tile "data4")))           ;取料號
    (setq out_data50 (txt_tran (get_tile "data5")))           ;取材質
    (setq out_data60 (txt_tran (get_tile "blocknote")))                    ;取備註

    (data_trans (STRCAT bmanager_item_path ITEMDIR "/ITEMP" PAGE_NOW ".DOC")
                (STRCAT bmanager_path "OUT.DOC"))


 ;("I0100111" (10 "直徑22平頭按鈕")(20 "廠牌")(30 "規格")(40 "料號")(50 "材質")(60 "備註")(70 "")(80 "")
 ;            (90 "")(100 "")(110 "")(120 "")(130 "")(140 "")(150 ""))

    (setq change_data
       (strcat "(" "\"" out_data1 "\" "
             "(10 " "\"" out_data10 "\")" "(20 " "\"" out_data20 "\")"
             "(30 " "\"" out_data30 "\")" "(40 " "\"" out_data40 "\")"
             "(50 " "\"" out_data50 "\")" "(60 " "\"" out_data60 "\")"
             "(70 " "\"\")" "(80 " "\"\")"
             "(90 " "\"\")" "(100 " "\"\")" "(110 " "\"\")" "(120 " "\"\")"
             "(130 " "\"\")" "(140 " "\"\")" "(150 " "\"\"))"
       );strcat
    );setq
    (setq change_data_id (list_id blk_data page_DATA_list))
    (setq ffile (STRCAT bmanager_path "OUT.DOC"))
    (setq tfile (STRCAT bmanager_item_path ITEMDIR "/ITEMP" PAGE_NOW ".DOC"))
    (ndata ffile tfile)

 )

 ;資料轉置
 (defun data_trans(fromfile tofile / data readfile outfile)
    (setq readfile (open fromfile "r"))
    (setq outfile (open tofile "w"))       ;資料轉置
    (while (setq data (read-line readfile))
      (write-line data outfile)
    )(close readfile)(close outfile)(setq readfile nil outfile nil)
 )

 ;新檔案寫出
 (defun ndata(ffile tfile / readfile outfile data)
    (setq readfile (open ffile "r"))
    (setq outfile (open tfile "w"))
    (repeat (- change_data_id 1)
        (setq data (read-line readfile))
        (write-line data outfile)
    )
    (write-line change_data outfile)
    (read-line readfile)
    (while (setq data (read-line readfile))
       (write-line data outfile)
    )(close readfile)(close outfile)(setq readfile nil outfile nil)
    (get_item_data)      ;重新產生 page_DATA_LIST IT_PAGELIST
 )

(defun subok(/ olddata newdata change_data changedata_id)
;(defun subok(/ change_data changedata_id)

    (data_trans (STRCAT bmanager_item_path ITEMDIR "/ITEMPAGE.DOC")
                (STRCAT bmanager_path "OUT.DOC"))

   (setq out_data (get_tile "pagenote"))
   (setq change_data (strcat "(" page_now " "  "\"" out_data "\"" ")"))
   (setq change_data_id (1+ (atoi page_now)))

    (ndata (STRCAT bmanager_path "OUT.DOC")
             (STRCAT bmanager_item_path ITEMDIR "/ITEMPAGE.DOC"))

    (setq pgnum '(""))
    (foreach nn it_pagelist
      (progn
        (setq data1 (nth 0 nn)
              data2 (nth 1 nn))
        (setq pgnum (cons (strcat (rtos data1 2 0) ":" data2) pgnum))
      );progn
    );foreach

    (setq pgnum (cdr (reverse pgnum)))
 ;  (act_pop_list pgnum "page")

 ;  (setq olddata (assoc (atoi page_now) it_pagelist))
 ;  (data_trans (STRCAT bmanager_item_path ITEMDIR "/ITEMPAGE.DOC")
 ;              (STRCAT bmanager_path "OUT.DOC"))
 ;
 ;  (setq out_data (get_tile "pagenote"))
 ;  (setq change_data (strcat "(" page_now " "  "\"" out_data "\"" ")"))
 ;  (setq change_data_id (1+ (atoi page_now)))
 ;
 ;  (ndata (STRCAT bmanager_path "OUT.DOC")
 ;           (STRCAT bmanager_item_path ITEMDIR "/ITEMPAGE.DOC"))
 ;  (setq newdata (cons (atoi page_now) out_data))
 ;  (setq it_pagelist (subst newdata olddata it_pagelist))
  ; (get_item_data)

  ; (mb_SHOW_POP)
  ; (act_pop_list pgnum "page")

 )


 (defun deldata()
          (userblkm "userblkm" "userblkm" nnname sldname typ)
     (princ)
 )

 ;===========================建立 BLOCK
 (defun addblock()
     (setvar "cmdecho" 0)
     (setq curlayer (getvar "clayer"))
     (setq curcolor (getvar "cecolor"))
     (command "view" "s" "ov")
     (princ "\n請選擇要建立符號的圖形: ")
     (setq creat_entity (ssget))
     (setq ins_point (getpoint "\n請選擇符號插入點: "))

     (if (findfile (strcat bmanager_path ipath "\\" blk_name ".dwg"))
        (progn
          (if (= acad_ver "GENIUS")
             (command ".wblock" (strcat bmanager_path ipath "\\" blk_name) "y"
                             "" ins_point creat_entity "")
             (command "wblock" (strcat bmanager_path ipath "\\" blk_name) "y"
                             "" ins_point creat_entity "")
          )
        )
        (progn
          (if (= acad_ver "GENIUS")
             (command ".wblock" (strcat bmanager_path ipath "\\" blk_name)
                             "" ins_point creat_entity "")
             (command "wblock" (strcat bmanager_path ipath "\\" blk_name)
                             "" ins_point creat_entity "")
          )
        )
     )
     (if (= acad_ver "GENIUS")
         (command ".oops")
         (command "oops")
     )


     (command "copy" creat_entity "" "0,0,0"  "@")
     (setq la (tblsearch "layer" "NEWBLOCK"))
     (if (= la nil) (command "layer" "m" "NEWBLOCK" "c" "2" "NEWBLOCK" "")
                    (command "layer" "s" "NEWBLOCK" ""))
;;;檢查是否有block
     (setq ~i 0 ~block_flag nil)
     (repeat (sslength creat_entity)
             (if (= "INSERT" (cdr (assoc 0 (entget (ssname creat_entity ~i)))))
                 (setq ~block_flag T)
             );if
             (setq ~i(+ ~i 1))
     )
;;;檢查是否有block

     (if ~block_flag
         (progn
               (command "block" "$unselent" "0,0" "all" "r" creat_entity "")
              ; (command "explode" creat_entity)
         );progn

         (progn
              (command "change" creat_entity "" "p" "la" "newblock" "")

;             (command "layer" "f" "*" "")

              (if (= (strcase curlayer) "NEWBLOCK")
                  (command "layer" "off" "*" "n" "")
                  (command "layer" "off" "*" "y" "on" "NEWBLOCK" "")
              )
         );progn
     );if




     (command "color" "1")
     (command "zoom" "e")
     (setq oosnape (getvar "osmode"))
     (setvar "osmode" 0)

     (initget 128 "Yes No")
     (setq yesno (getkword "\n畫面位置滿意嗎?No/ <Yes>:"))
     (if (= "No" yesno)
       (progn
        (setq sp1 (getpoint "\n請選擇幻燈片第一角點: "))
        (while (null sp1)
           (princ "\n未選擇幻燈片第一角點,請再選一次!!")
           (setq sp1 (getpoint "\n請選擇幻燈片第一角點: "))
        );while
        (setq sp2 (getcorner sp1 "\n幻燈片第二角點: "))
        (while (null sp2)
           (princ "\n未選擇幻燈片第二角點,請再選一次!!")
           (setq sp2 (getcorner sp1 "\n幻燈片第二角點: "))
        );while
       );progn
     )
;    (if (or (= yesno "Y") (= yesno "YES") (= yesno "")) (princ)
;      (progn
;         (setq newp (getpoint "\n請重新選擇畫面中央點: "))
;         (while newp
;            (setq vctry (cadr (getvar "viewctr")))
;            (setq newp (list (car newp) vctry))
;            (command "zoom" "c" newp "")
;            (setq yesno (strcase (getstring "\n畫面位置滿意嗎 <Y>:")))
;            (if (or (= yesno "N") (= yesno "NO"))
;               (setq newp (getpoint "\n請重新選擇畫面中央點: "))
;               (setq newp nil)
;            )
;         )
;      )
;    )

     (if (= "No" yesno)
         (COMMAND "ZOOM" sp1 sp2)
         (COMMAND "ZOOM" "C" "" (* 1.2 (GETVAR "VIEWSIZE")))
     )
     (setq len (/ (getvar "viewsize") 8)
           p1 (polar ins_point (* pi 0.25) (/ len 2))
           p2 (polar ins_point (* pi 0.75) (/ len 2))
           p3 (polar ins_point (* pi 1.25) (/ len 2))
           p4 (polar ins_point (* pi 1.75) (/ len 2)))
     (command "line" p1 p3 "") (setq l1 (entlast))
     (command "line" p2 p4 "") (setq l2 (entlast))
     (setvar "osmode" oosnape)

     (command "mslide" (strcat bmanager_path ipath "\\" blk_name))
     (if (= acad_ver "GENIUS")
         (command ".erase" creat_entity "")
         (command "erase" creat_entity "")
     )

;;;檢查是否有block
     (if ~block_flag
         (progn
              (command "insert" "*$unselent" "0,0" "1" "0")
              (command "purge" "b" "$unselent" "n")
         )
     );
;;;檢查是否有block

     (command "layer" "on" "*" "")
;    (command "layer" "t" "*" "")

     (if (= acad_ver "GENIUS")
         (command ".erase" l1 l2 "")
         (command "erase" l1 l2 "")
     )
     (command "view" "r" "ov")


     (command "layer" "s" curlayer "")


;    (if (= curcolor "BYLAYER") (command "color" "") (command "color" (atoi curcolor)))
   (cond
     ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
     ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
     (T (command "color" (atoi curcolor)))
   )

     (moddata)
 )


 ;===========================取該模組各圖檔詳細資料於it_pagelist PAGE_DATA_LIST
 (defun get_item_data()
    (setq item_data_list (assoc itemname (nth 1 BLOCK_SYSTEM)))  ;item_data_lista 模組系統索引串列
    (setq ipath (cadr item_data_list))                          ;ipath 模組系統路目錄

 ;取各頁註解 (it_pagelist -> 各頁註解串列)
     (setq ii (strcat bmanager_item_path ipath "\\" "itempage.doc"))
     (setq it (open ii "r"))
     (setq data (read-line it))
     (setq it_pagelist '(""))
     (while data
        (setq it_pagelist (cons (read data) it_pagelist))
        (setq data (read-line it))
     )(setq it_pagelist (cdr (reverse it_pagelist)))
     (close it)
     (if (null page_now) (setq page_now "0"))
     (if (> (+ (atoi page_now) 1) (length it_pagelist))
        (showpage "0")
     )
     (PAGE_DATA PAGE_NOW)
  )

  (defun PAGE_DATA(page_now)
 ;取各頁資料 (page_data_list -> 各頁註解串列)
     (setq it (open (strcat bmanager_item_path ipath "\\" "itemp" page_now ".doc") "r"))
     (setq data (read-line it))
     (setq page_data_list '(""))
     (while data
        (setq page_data_list (cons (read data) page_data_list))
        (setq data (read-line it))
     )(setq page_data_list (cdr (reverse page_data_list)))
     (close it)
 )



 (defun showpage(value)
     (setq nn (atoi value))
     (setq 0num (strlen value))
     (cond
       ((= 0num 1) (setq itpagename (strcat "00" value)))
       ((= 0num 2) (setq itpagename (strcat "0" value)))
       ((= 0num 3) (setq itpagename value))
     )
 ;("盤面材料" "ITEM1" "I01" "***POP8" 0 "本模組儲存自控盤面材料符號")
     (setq itemdir (nth 1 item_data_list))
     (setq itemcode (nth 2 item_data_list))
     (setq headname (strcat bmanager_item_path itemdir "\\" itemcode itpagename))
     (setq sld_list (list (strcat headname "11") (strcat headname "12")
                      (strcat headname "13") (strcat headname "14")
                      (strcat headname "15") (strcat headname "16")
                      (strcat headname "17") (strcat headname "18")
                      (strcat headname "21") (strcat headname "22")
                      (strcat headname "23") (strcat headname "24")
                      (strcat headname "25") (strcat headname "26")
                      (strcat headname "27") (strcat headname "28")
                      (strcat headname "31") (strcat headname "32")
                      (strcat headname "33") (strcat headname "34")
                      (strcat headname "35") (strcat headname "36")
                      (strcat headname "37") (strcat headname "38")
                      (strcat headname "41") (strcat headname "42")
                      (strcat headname "43") (strcat headname "44")
                      (strcat headname "45") (strcat headname "46")
                      (strcat headname "47") (strcat headname "48")
                      (strcat headname "51") (strcat headname "52")
                      (strcat headname "53") (strcat headname "54")
                      (strcat headname "55") (strcat headname "56")
                      (strcat headname "57") (strcat headname "58")))


     (mapcar 'show_sld key_list sld_list)
     (setq page_now (itoa nn))
     (PAGE_DATA PAGE_NOW)
    (set_tile "item_path" (strcat "本模組路徑:" (strcase bmanager_path) (strcase (nth 1 item_data_list))))
 )


 (defun mb_SHOW_POP()
    (setq pgnum '(""))
    (foreach nn it_pagelist
      (progn
        (setq data1 (nth 0 nn)
              data2 (nth 1 nn))
        (setq pgnum (cons (strcat (rtos data1 2 0) ":" data2) pgnum))
      );progn
    );foreach
    (setq pgnum (cdr (reverse pgnum)))
    (start_list "page")
    (mapcar 'add_list pgnum)
    (end_list)
    (set_tile "page" page_now)
    (showpage page_now)
 )


 (defun blockm_show_data_on_dcl()
    (set_tile "showhead" (strcat "藝祥資訊  " (nth 5 item_data_list)))
    (if (null blk_name)
      (progn
          (mode_tile "add_block" 1)
          (mode_tile "mod_block" 1)
          (mode_tile "del_block" 1)
          (mode_tile "mod_data" 1)
          (mode_tile "add_data" 1)
          (mode_tile "del_data" 1)
      )
    )
 )


 ;╭════════════════════╮
 ;║設計日期: 1995. 10.18   V1.0            ║
 ;║更新日期:                               ║
 ;║設 計 者: 陳冠達                        ║
 ;║功能說明: 增頁                          ║
 ;║                                        ║
 ;║關聯檔案:                               ║
 ;╰════════════════════╯
 (defun addpage()
    (setq lastpage (length it_pagelist)) ;lastpage: 目前到第 ? 頁
    (setq newpage (rtos lastpage 2 0))
    (setq old_page_list pgnum)
    (setq adpage (cons (strcat newpage ":") (reverse old_page_list)))
    (setq new_page_list (reverse adpage))
    (setq pgnum new_page_list)
    (set_tile "adpagemsg" (strcat "<<增加第 " newpage " 頁!>>"))

 ;資料寫出
    (setq tt (open (strcat bmanager_item_path ipath "\\" "itemp" newpage ".doc") "w"))
    (setq sldlist '("11" "12" "13" "14" "15" "16" "17" "18"
                    "21" "22" "23" "24" "25" "26" "27" "28"
                    "31" "32" "33" "34" "35" "36" "37" "38"
                    "41" "42" "43" "44" "45" "46" "47" "48"))

    (cond
       ((= 1 (strlen newpage)) (setq ipage (strcat "00" newpage)))
       ((= 2 (strlen newpage)) (setq ipage (strcat "0" newpage)))
       ((= 3 (strlen newpage)) (setq ipage newpage))
    )
    (setq headtxt (strcat itemcode ipage))

    (defun wfile(aa)
       (write-line (strcat "(\"" headtxt aa "\""
                             " (10 " "\"\")" "(20 " "\"\")"
                             "(30 " "\"\")" "(40" " " "\"\")"
                             "(50 " "\"\")" "(60" " " "\"\")"
                             "(70 " "\"\")" "(80" " " "\"\")"
                             "(90 " "\"\")" "(100 " "\"\")" "(110 " "\"\")"
                             "(120 " "\"\")" "(130 " "\"\")" "(140 " "\"\")"
                             "(150 " "\"\"))"
                             ) tt)
    );defun
    (mapcar 'wfile sldlist)(close tt)
    (act_pop_list new_page_list "page")


    (setq ff (open (STRCAT bmanager_item_path ITEMDIR "/ITEMPAGE.DOC") "a"))

    (write-line (strcat "(" newpage " \"\")") ff)
    (close ff)

    (get_item_data)     ;重新產生 it_pagelist
 )

 (defun pagenote()
    ;***************************************** Load dcl file
    (new_dialog "pagenote" dcl_id)
    ;***************************************** Setting value to tile
    (set_tile "pnote" (strcat "第" page_now "頁註解說明:"))

    (set_tile "pagenote" (nth 1 (nth (atoi page_now) IT_Pagelist)))


    (action_tile "accept" "(subok)(done_dialog)")
    (start_dialog)

    (act_pop_list pgnum "page")
    (set_tile "page" page_now)

 )

;╭══════════════════════════════╮
;║設 計 者: 陳冠達                                            ║
;║功能說明: 取出BMANAGER 所有系統設定                         ║
;║相關檔案:                                                   ║
;╰══════════════════════════════╯
(defun c:get_block_set()
  (get_blkdata_set)
  (setq block_showist (Binilist "-->ITEM_SHOWDATA" "SETITEM.DOC"))
  (setq BLOCK_SYSTEM '(""))
  (setq item_list (Binilist "-->BLOCKPATH" "SETITEM.DOC"))
  (setq BLOCK_SYSTEM (cons item_list BLOCK_SYSTEM))
  (setq item_list (Binilist "-->SETITEM" "SETITEM.DOC"))
  (setq BLOCK_SYSTEM (cons item_list BLOCK_SYSTEM))
  (setq BLOCK_SYSTEM (cdr (reverse BLOCK_SYSTEM)))

)

;╭════════════════════╮
;║設計日期: 1995.10.14                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 尋找某檔案內特定主區,並將資料 ║
;║          變成串列                      ║
;║執行方式:(Binilist "找某字串" "檔名")   ║
;║相關檔案:                               ║
;╰════════════════════╯

(defun Binilist(search_text sfile / openfile data flag)
   (setq openfile (open (strcat BMANAGER_path sfile) "r"))
   (setq data (read-line openfile))
   (setq flag T)
   (while flag
     (if (= data search_text) (setq flag nil)
      (setq data (read-line openfile))
     );if
   );while
   (setq data (read-line openfile))
   (setq data (read-line openfile))
   (setq item_list (list (read data)))
   (setq flag T)
   (while flag
        (setq data (read-line openfile))
        (if (= "(" (substr data 1 1))
         (setq item_list (cons (read data) item_list))
         (setq flag nil)
        )
   );while
   (close openfile)
   (reverse item_list)
)
(princ)

;取 block 資料設定  ("1" "品名；"廠牌" "規格" "料號" "材質")
(defun get_blkdata_set()
   (setq openfile (open (strcat BMANAGER_path "SETITEM.DOC") "r"))
   (setq data (read-line openfile))
   (if (and (/= nil data) (/= "" data)) (setq data (block_getrealstr data)))
   (setq flag T)
   (while flag
     (if (= data "-->ITEM_SHOWDATA")
      (progn
        (setq block_dataset (read (read-line openfile)))
        (setq block_dataset_id (- (atoi (nth 0 block_dataset)) 1))
        (setq label1 (nth 1 block_dataset))
        (setq label2 (nth 2 block_dataset))
        (setq label3 (nth 3 block_dataset))
        (setq label4 (nth 4 block_dataset))
        (setq label5 (nth 5 block_dataset))
        (setq flag nil)
      );progn
      (progn
        (setq data (read-line openfile))
        (if (null data)
          (progn
            (setq flag nil)
            (setq block_dataset_id 1)
            (setq label1 "品名")
            (setq label2 "廠牌")
            (setq label3 "規格")
            (setq label4 "料號")
            (setq label5 "材質")
          );progn
        );if
      );progn
     );if
   );while

   (close openfile)
)



;;去除文字串後面所有空格 "123    " ==> "123"
(defun block_getrealstr(str)
   (setq num (strlen str))
   (cond
     ((= 1 num)  (if (= (substr str 1 1) " ")(setq str "")))
     ((= 0 num) (princ))
     (T
       (while (= " " (substr str (- num 1) 1))
          (setq str (substr str 1 (- num 1)))
          (setq num (strlen str))
       )
       (if (= " " (substr str (strlen str) 1))
         (setq str (substr str 1 (- (strlen str) 1)))
       );if
     ) ;t
   );cond
   str
)


(defun del_write(/ out_data1 out_data10 out_data20 out_data30 out_data40 out_data50 out_data60 change_data change_data_id ffile tfile)
 ;("I0100111" (10 "直徑22平頭按鈕")(20 "廠牌")(30 "規格")(40 "日規")(50 "NO")(60 "備註")(70 "進價")(80 "售價")
 ;            (90 "")(100 "")(110 "")(120 "")(130 "")(140 "")(150 ""))
    (setq out_data1 blk_name)                        ;取檔名
    ;(setq out_data10 (txt_tran (get_tile "data1")))              ;取品名
    ;(setq out_data20 (txt_tran (get_tile "data2")))         ;取廠牌
    ;(setq out_data30 (txt_tran (get_tile "data3")))         ;取規格
    ;(setq out_data40 (txt_tran (get_tile "data4")))           ;取料號
    ;(setq out_data50 (txt_tran (get_tile "data5")))           ;取材質
    ;(setq out_data60 (txt_tran (get_tile "blocknote")))                    ;取備註

    (data_trans (STRCAT bmanager_item_path ITEMDIR "/ITEMP" PAGE_NOW ".DOC")
                (STRCAT bmanager_path "OUT.DOC"))


 ;("I0100111" (10 "直徑22平頭按鈕")(20 "廠牌")(30 "規格")(40 "料號")(50 "材質")(60 "備註")(70 "")(80 "")
 ;            (90 "")(100 "")(110 "")(120 "")(130 "")(140 "")(150 ""))
    (setq change_data
       (strcat "(" "\"" out_data1 "\" "
               "(10 " "\""  "\")" "(20 " "\""  "\")"
               "(30 " "\""  "\")" "(40 " "\""  "\")"
               "(50 " "\""  "\")" "(60 " "\""  "\")"
               "(70 " "\"\")" "(80 " "\"\")"
               "(90 " "\"\")" "(100 " "\"\")" "(110 " "\"\")" "(120 " "\"\")"
               "(130 " "\"\")" "(140 " "\"\")" "(150 " "\"\"))"
       );strcat
    );setq
    (setq ffile (STRCAT bmanager_path "OUT.DOC"))
    (setq tfile (STRCAT bmanager_item_path ITEMDIR "/ITEMP" PAGE_NOW ".DOC"))
    (del_write_ndata change_data out_data1 ffile tfile)

 );defun

(defun del_write_ndata(change_data out_data1 ffile tfile / readfile outfile data data1)
    (setq readfile (open ffile "r"))
    (setq outfile (open tfile "w"))
    
    (while  (setq data (read-line readfile))
            (setq data1 (read data))
            (if (= (strcase (car data1)) (strcase out_data1))
                (write-line change_data outfile)
                (write-line data outfile)
            );if  
            
    );while
    ;(write-line change_data outfile)
    ;(read-line readfile)
    ;(while (setq data (read-line readfile))
    ;   (write-line data outfile)
    ;)
    (close readfile)(close outfile)(setq readfile nil outfile nil)
    (get_item_data)      ;重新產生 page_DATA_LIST IT_PAGELIST
 );defun

