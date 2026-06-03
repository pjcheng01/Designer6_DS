;;;
;╭════════════════════╮
;║設計日期: 1996. 03.31   V2.0            ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 符號庫使用主程式              ║
;║                                        ║
;║關聯檔案:pub-lisp(adxdata)              ║
;╰════════════════════╯
;;typ=0 一般block管理 , typ=1 銘版圖庫管理
(defun defbom_type()
  (cond
    ((= 0 typ)
         (regapp "BLKBOM")
         (setq entname (entlast))
         (setq oldentdata (entget entname))
         (setq d10 (cons 1000 data10)
               d20 (cons 1000 data20)
               d30 (cons 1000 data30)
               d40 (cons 1000 data40)
               d50 (cons 1000 data50)
               d60 (cons 1000 data60))
         (setq dd (list "BLKBOM" d10 d20 d30 d40 d50 d60)
               newdata (append (list -3 dd)))
         (setq newent (append oldentdata (list newdata)))
         (entmod newent))
    ((= 1 typ)
         (regapp "LABELBOM")
         (setq entname (entlast))
         (setq oldentdata (entget entname))
         (setq d10 (cons 1000 data10)
               d20 (cons 1000 data20)
               d30 (cons 1000 data30)
               d40 (cons 1000 data40)
               d50 (cons 1000 data50)
               d60 (cons 1000 data60))
         (setq dd (list "LABELBOM" d10 d20 d30 d40 d50 d60)
               newdata (append (list -3 dd)))
         (setq newent (append oldentdata (list newdata)))
         (entmod newent))
    (T (princ))
  )
)



(defun userblku(dclfilename dialogname itemname sldname typ)
 ;; 已移除加密狗判斷(progn ;; DraftSight: 移除加密狗 WHILE 迴圈
 (setvar "cmdecho" 0)
 (setq blk_name nil)
 (setq blockuse_id nil)
 (if (null block_system) (progn (load "userblkm") (c:get_block_set)))
 (actdcl dclfilename dialogname)

    (setq key_list '("sld11" "sld12" "sld13" "sld14" "sld15" "sld16" "sld17" "sld18"
                     "sld21" "sld22" "sld23" "sld24" "sld25" "sld26" "sld27" "sld28"
                     "sld31" "sld32" "sld33" "sld34" "sld35" "sld36" "sld37" "sld38"
                     "sld41" "sld42" "sld43" "sld44" "sld45" "sld46" "sld47" "sld48"))

  ; (setq txt_list '("txt11" "txt12" "txt13" "txt14" "txt15" "txt16" "txt17" "txt18"
  ;                  "txt21" "txt22" "txt23" "txt24" "txt25" "txt26" "txt27" "txt28"
  ;                  "txt31" "txt32" "txt33" "txt34" "txt35" "txt36" "txt37" "txt38"
  ;                  "txt41" "txt42" "txt43" "txt44" "txt45" "txt46" "txt47" "txt48"))

   (set_tile "item_path" "符號資料正在讀取中! 請稍候!!")
   (ublock_get_item_page_data)
;  (show_sld "powersoft" sldname)

   (setq item_data_list (assoc itemname (nth 1 BLOCK_SYSTEM)))  ;item_data_lista 模組系統索引串列
   (setq ipath (cadr item_data_list))                          ;ipath 模組系統路目錄

;顯示資料在畫面

  (ublock_show_data_on_blockuse)
  (defun reload_block_data()
     (setq aaa_page_data_list page_data_list)
     (foreach mm aaa_page_data_list
       (progn
          (setq num (substr (nth 0 mm) 7 2))
            (set_tile (strcat "txt" num) (nth 1 (nth block_dataset_id (cdr mm))))
       );progn
     );foreach
  );defun
  (reload_block_data)

  (action_tile "zoom_block" "(zoom_block)")
; (action_tile "total_page_memo" "(tpage_memo)")

  (action_tile "accept" "(ook)")
  (action_tile "cancel" "(setq blk_name nil)(done_dialog)")

  (start_dialog)
 (if blockuse_id (blockuse_ok))
 (prin1)
  (SETQ FFF nil))
  (princ)
)

(defun ook()
 (if blk_name
     (setq ex_yesno (get_tile "explod") bom_yesno (get_tile "add_bom")
                    blockuse_id t)
 )
 (done_dialog)
)


(defun blockuse_ok()
; (setq bsca (getdist "\n比例係數<1>:"))
  (if (null bsca) (setq bsca 1))
  (if blockuse_id
    (progn
;    (setq insp (getpoint "\n選擇符號插入位置:"))
     (setq flag t)
     (while flag
        (PRINC "\n選擇符號插入位置:")
;       (setq bang (getdist "\n旋轉角<0>:"))
;       (if (null bang) (setq bang 0))
        (setq block_file_name (strcat bmanager_item_path (nth 1 item_data_list) "\\" blk_name))

;       (setq la (tblsearch "layer" "bom_ball"))
;       (if (= la nil) (command "layer" "n" "bom_ball" "c" "7" "bom_ball" ""))
        (setq oldattdia (getvar "attdia"))
        (setvar "attdia" 1)
        (if (= ex_yesno "0")
          (progn
             (command "insert" block_file_name pause bsca "" "0")          ;不爆炸
             (defbom_type)                           ;加入xdata資料
          );progn
           (command "insert" (strcat "*" block_file_name) pause bsca "0") ;爆炸
        )
        (setvar "attdia" oldattdia)
;       (setq insp (getpoint "\n按Enter鍵結束指令執行/<選擇符號插入位置>:"))
        (initget "Yes No")
        (setq cont_yesno (getkword "\n繼續插入相同符號<Yes>: "))
        (if (= "No" cont_yesno)
;          (PRINC "\n選擇符號插入位置:")
           (setq flag nil)
        )
     )
   );progn
 );if
        (initget "Yes No")
        (setq cont_yesno (getkword "\n繼續選用其它符號<Yes>: "))
        (if (/= "No" cont_yesno)
           (userblku dclfilename dialogname itemname sldname typ)
        )
 (princ)
)



(defun zoom_block()
  (if blk_name
    (progn
      (actdcl "userblku" "zoomblock")
      (setq sldn (strcat headname (substr blk_name 7 2)))
      (show_sld "sld_name" sldn)
      (action_tile "accept" "(done_dialog)")
      (start_dialog)
    )
    (set_tile "message" "您尚未選取任何符號圖形!!")
  )
)



(defun ublock_show_data_on_blockuse()
   (ublock_mb_show_pop)
    (action_tile "page" "(showpage $value)(reload_block_data)")
;  (defun reload_block_data()

  (action_tile "sld11" "(use_sld \"sld11\" \"11\")")
  (action_tile "sld12" "(use_sld \"sld12\" \"12\")")
  (action_tile "sld13" "(use_sld \"sld13\" \"13\")")
  (action_tile "sld14" "(use_sld \"sld14\" \"14\")")
  (action_tile "sld15" "(use_sld \"sld15\" \"15\")")
  (action_tile "sld16" "(use_sld \"sld16\" \"16\")")
  (action_tile "sld17" "(use_sld \"sld17\" \"17\")")
  (action_tile "sld18" "(use_sld \"sld18\" \"18\")")

  (action_tile "sld21" "(use_sld \"sld21\" \"21\")")
  (action_tile "sld22" "(use_sld \"sld22\" \"22\")")
  (action_tile "sld23" "(use_sld \"sld23\" \"23\")")
  (action_tile "sld24" "(use_sld \"sld24\" \"24\")")
  (action_tile "sld25" "(use_sld \"sld25\" \"25\")")
  (action_tile "sld26" "(use_sld \"sld26\" \"26\")")
  (action_tile "sld27" "(use_sld \"sld27\" \"27\")")
  (action_tile "sld28" "(use_sld \"sld28\" \"28\")")

  (action_tile "sld31" "(use_sld \"sld31\" \"31\")")
  (action_tile "sld32" "(use_sld \"sld32\" \"32\")")
  (action_tile "sld33" "(use_sld \"sld33\" \"33\")")
  (action_tile "sld34" "(use_sld \"sld34\" \"34\")")
  (action_tile "sld35" "(use_sld \"sld35\" \"35\")")
  (action_tile "sld36" "(use_sld \"sld36\" \"36\")")
  (action_tile "sld37" "(use_sld \"sld37\" \"37\")")
  (action_tile "sld38" "(use_sld \"sld38\" \"38\")")

  (action_tile "sld41" "(use_sld \"sld41\" \"41\")")
  (action_tile "sld42" "(use_sld \"sld42\" \"42\")")
  (action_tile "sld43" "(use_sld \"sld43\" \"43\")")
  (action_tile "sld44" "(use_sld \"sld44\" \"44\")")
  (action_tile "sld45" "(use_sld \"sld45\" \"45\")")
  (action_tile "sld46" "(use_sld \"sld46\" \"46\")")
  (action_tile "sld47" "(use_sld \"sld47\" \"47\")")
  (action_tile "sld48" "(use_sld \"sld48\" \"48\")")

    (set_tile "showhead" (strcat "藝祥資訊 " (nth 5 item_data_list)))
   (set_tile "item_path" (strcat "本模組路徑:" (strcase bmanager_path) (strcase (nth 1 item_data_list))))


)



(defun ublock_get_item_page_data()
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

 (defun page_data(page_now)
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



(defun ublock_count_page()
   (setq lastpage (length it_pagelist)) ;lastpage: 目前到第 ? 頁
    (setq pgnum '("") count 0)
    (repeat lastpage
       (setq pgnum (cons (rtos count 2 0) pgnum))
       (setq count (+ count 1))
    )(setq pgnum (cdr (reverse pgnum)))
)

(defun ublock_mb_show_pop()
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

;  (ublock_count_page)
;  (start_list "page")
;  (mapcar 'add_list pgnum)
;  (end_list)
;      (set_tile "page" page_now)
;      (showpage page_now)
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


(defun tpage_memo()
; (setq pp (length IT_PAGELISTpgnum))
  (setq pp (length it_pagelist))
  (setq pg_memo_list '(""))
  (while (> pp 0)
    (cond
      ((< pp 11) (setq pg_txt (strcat "00" (rtos (- pp 1) 2))))
      ((and (< pp 100) (>= pp 11)) (setq pg_txt (strcat "0" (rtos (- pp 1) 2))))
      (T (setq pg_txt (rtos pp 2)))
    )

    (setq note (strcat pg_txt "" "==> " (nth 1 (assoc (atoi (substr pg_txt 3 1)) it_pagelist))))

    (setq pg_memo_list (cons note pg_memo_list))
    (setq pp (- pp 1))
  )(setq pg_memo_list (reverse (cdr (reverse pg_memo_list))))

  (actdcl "userblku" "pgmemo")
   (start_list "pagememo")
   (mapcar 'add_list pg_memo_list)
   (end_list)

   (action_tile "accept" "(sel_page)(done_dialog)")
   (start_dialog)
   (if (/= sel_pg "")
     (progn
       (set_tile "page" sel_pg)
       (showpage sel_pg)
     )
   )
)

(defun sel_page()
  (setq sel_pg (get_tile "pagememo"))
)


 (defun use_sld(key sld_code)
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
         (fill_image 0 0 x y 15)
         (slide_image 0 0 x y (strcat headname sld_code))
         (end_image)

    (set_tile "block_note" (strcat "檔名:" blk_name))


; (setq brk_yesno (cadr (assoc 50 (cdr (assoc blk_name page_data_list)))));取斷線否
  (setq data10 (cadr (assoc 10 (cdr (assoc blk_name page_data_list)))))
  (setq data20 (cadr (assoc 20 (cdr (assoc blk_name page_data_list)))))
  (setq data30 (cadr (assoc 30 (cdr (assoc blk_name page_data_list)))))
  (setq data40 (cadr (assoc 40 (cdr (assoc blk_name page_data_list)))))
  (setq data50 (cadr (assoc 50 (cdr (assoc blk_name page_data_list)))))
  (setq data60 (cadr (assoc 60 (cdr (assoc blk_name page_data_list)))))

  (cond
    ((= 0 typ)
;       (set_tile "data1" (strcat "品名:" ":" data10))
;       (set_tile "data2" (strcat "廠牌:" ":" data20))
;       (set_tile "data3" (strcat "規格:" ":" data30))
;       (set_tile "data4" (strcat "料號:" ":" data40))
;       (set_tile "data5" (strcat "材質:" ":" data50))
        (set_tile "data1" (strcat label1 ":" data10))
        (set_tile "data2" (strcat label2 ":" data20))
        (set_tile "data3" (strcat label3 ":" data30))
        (set_tile "data4" (strcat label4 ":" data40))
        (set_tile "data5" (strcat label5 ":" data50))
        (set_tile "blocknote" (strcat "備註:" data60))
      ; (set_tile "message" "")
    )
    ((= 1 typ)

        (set_tile "data1" (strcat sys_label_def1 ":" data10))
        (set_tile "data2" (strcat sys_label_def2 ":" data20))
        (set_tile "data3" (strcat sys_label_def3 ":" data30))
        (set_tile "data4" (strcat sys_label_def4 ":" data40))
        (set_tile "data5" (strcat sys_label_def5 ":" data50))
        (set_tile "blocknote" (strcat "備註:" data60))
      ; (set_tile "message" "")
    )
    (T (princ))
  )
)
(princ)
