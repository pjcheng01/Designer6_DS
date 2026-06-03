;;;
;;;建立公用 BLOCK
;;;轉檔到 dwg.db
;;;以圖管開圖
;;;以圖管插入圖形
;;;typ=1 建立新圖層與資訊點
;;;typ=0 圖層已存在,只建立資訊點
;;;typ=2 取出零件圖中之文字層資訊點
;;;編輯資訊點
;;;移動資訊點
;;;打開所有資訊點 on_bomlayer
;;;關閉所有資訊點 off_bomlayer
;;;改變零件圖層顏色
;;;產生結構樹
;;;建立 BMP (影像) 檔的圖形
;;;物料結構顯示欄位順序
;;;取圖框屬性自動建立資訊點
;;;自動建立資訊點
;;;物料結構顯示欄位順序
;;;材料清單欄位順序
;;;產生圖面材料清單
;;;管理物料資料庫


;(setq nobomp_list (list "BORDER" "PROJ" "0" "DIM" "TEXT" "$PARTREF_BOM" "SHEET" "BALLBOM")) ;;定義不建立資訊點的圖層
  
;=======================================================================================================================
;管理物料資料庫
(defun c:mana_database(/ database_list)
      (actdcl (strcat POWdesign_dcl_path "manapart") "mana_database")
      (setq database_list (creat_databae_list) ) 
      (act_pop_list database_list "data")
      (setq gbol_flag 1)
      (set_tile "error" (strcat "共 " (rtos (length database_list) 2 0) " 筆資料!"))
      (mode_tile "mod" 1)
      (mode_tile "del" 1)
      (set_lab_val)
      (sift_popup_list)
      (action_tile "data" "(set_tile \"error\" \"\")(exe_data_func)")
      (action_tile "add" "(add_mana_database)")
      (action_tile "del" "(del_mana_database)")
      (action_tile "mod" "(mod_mana_database)")
      (action_tile "seek" "(seek_mana_database)");;搜尋
      (action_tile "sift" "(sift_mana_database)");;篩選
      (action_tile "pass" "(pass_mana_database)");;全部顯示
  
      (action_tile "accept" "(mana_database_ok)")
      (action_tile "cancel" "(done_dialog)")
      (start_dialog)
)
;;--------------------2003.09.02 SAM 搜尋&篩選-------------------------
;; 篩選後資料 gbol_flag = 0 串列變數 database_sift
;; 全部資料   gbol_flag = 1 串列變數 database_list
(defun seek_mana_database(/ str_liao str_expect lst_expect int_index int_id)
        (setq str_liao (strcase (get_tile "data1")))
        (setq int_index 0)
        (cond ((= 0 gbol_flag)
               (repeat (length database_sift)
                       (setq str_expect (nth int_index database_sift))
                       (setq lst_expect (TXT_TRAN_LIST str_expect))
                       (if (= str_liao (nth 0 lst_expect))(setq int_id int_index))
                       (setq int_index (1+ int_index))
               ))
              ((= 1 gbol_flag)
               (repeat (length database_list)
                       (setq str_expect (nth int_index database_list))
                       (setq lst_expect (TXT_TRAN_LIST str_expect))
                       (if (= str_liao (nth 0 lst_expect))(setq int_id int_index))
                       (setq int_index (1+ int_index))
               ))
        )
        (if int_id
            (progn (set_tile "data" (itoa int_id))
                   (exe_data_func))
            (progn (set_tile "data2" "")(set_tile "data3" "")(set_tile "data4" "")(set_tile "data5" "")
                   (set_tile "data6" "")(set_tile "data7" "")(set_tile "data8" "")(set_tile "data9" "")
                   (set_tile "data10" "")(set_tile "data11" "")(set_tile "data12" "")(set_tile "data13" "")
                   (set_tile "data14" "")(set_tile "data15" ""))
        )
)
(defun sift_mana_database(/ str_sift int_sift lst_sift int_index int_bit int_idd int_num
                            lst_field field_id str_field str_pair)
        (setq field_id (atoi (get_tile "sift_com")))
        (setq str_sift (strcase (get_tile "sift_val")))
        (setq int_sift (strlen str_sift))
        (setq int_index 0)
        (repeat (length database_list)
                (setq lst_field (TXT_TRAN_LIST (nth int_index database_list)))
                (setq str_field (strcase (nth field_id lst_field)))
                (setq int_bit 1)
                (setq int_idd nil)
                (repeat (setq int_num (+ 1 (- (strlen str_field) (strlen str_sift))))
                        (if (> int_num 0)(progn
                            (setq str_pair (substr str_field int_bit int_sift))
                            (if (= str_pair str_sift)(setq int_idd int_index))
                        ))
                        (setq int_bit (1+ int_bit))
                )
                (if int_idd (setq lst_sift (cons (nth int_idd database_list) lst_sift)))
                (setq int_index (1+ int_index))
        )
        (setq database_sift (reverse lst_sift))
        (act_pop_list database_sift "data")
        (mode_tile "mod" 1)(mode_tile "del" 1)
        (set_tile "error" (strcat "篩選共 " (itoa (length database_sift)) " 筆資料!"))
        (setq gbol_flag 0)

        ;;(setq str_sift (strcase (get_tile "sift_val")))
        ;;(setq int_sift (strlen str_sift))
        ;;(setq int_index 0)
        ;;(repeat (length database_list)
        ;;      (setq str_expect (nth int_index database_list))
        ;;      (setq str_expt (substr str_expect 1 int_sift))
        ;;      (if (= str_sift str_expt)(setq lst_expect (cons str_expect lst_expect)))
        ;;      (setq int_index (1+ int_index))
        ;;)
        ;;(setq database_sift (reverse lst_expect))
        ;;(act_pop_list database_sift "data")
        ;;(mode_tile "mod" 1)(mode_tile "del" 1)
        ;;(set_tile "error" (strcat "篩選共 " (itoa (length database_sift)) " 筆資料!"))
        ;;(setq gbol_flag 0)
)
(defun pass_mana_database()
        (act_pop_list database_list "data")
        (mode_tile "mod" 1)(mode_tile "del" 1)
        (set_tile "error" (strcat "共 " (itoa (length database_list)) " 筆資料!"))
        (setq gbol_flag 1)
)
(defun sift_popup_list(/ totallist collist i tab_name mat_name)
        (if (null get_defpart) (load "dfsystem"))
        (setq totallist (nth 1 (get_defpart)))
        (setq collist (TXT_TRAN_LIST aadata))
        (setq i 1)
        (repeat (- (length collist) 1)
                (setq tab_name (nth i collist))
                (setq mat_name (nth 1 (assoc tab_name totallist)))
                (setq collist  (subst mat_name tab_name collist))
                (setq i (1+ i))
        )
        (setq glst_collist collist)             ;;Ex:("料號" "品名" "材質")
        (act_pop_list glst_collist "sift_com")
)
;;----------------------------------------------------------------------
(defun mana_database_ok()
  (setq ff (open (strcat powdesign_path "database.txt") "w"))
  (write-line aadata ff)
  (foreach nn database_list
     (progn
        (write-line nn ff)
     );progn  
  );foreach
  (close ff)
  (done_dialog)
);defun

(defun get_data_val(/ outtxt)
  (setq data1 (get_tile "data1"))
  (if (/= "" data1)
    (progn
      (setq outtxt data1)
      (if (> end_num 1) (setq outtxt (strcat outtxt ";" (get_tile "data2"))))
      (if (> end_num 2) (setq outtxt (strcat outtxt ";" (get_tile "data3"))))
      (if (> end_num 3) (setq outtxt (strcat outtxt ";" (get_tile "data4"))))
      (if (> end_num 4) (setq outtxt (strcat outtxt ";" (get_tile "data5"))))
      (if (> end_num 5) (setq outtxt (strcat outtxt ";" (get_tile "data6"))))
      (if (> end_num 6) (setq outtxt (strcat outtxt ";" (get_tile "data7"))))
      (if (> end_num 7) (setq outtxt (strcat outtxt ";" (get_tile "data8"))))
      (if (> end_num 8) (setq outtxt (strcat outtxt ";" (get_tile "data9"))))
      (if (> end_num 9) (setq outtxt (strcat outtxt ";" (get_tile "data10"))))
      (if (> end_num 10) (setq outtxt (strcat outtxt ";" (get_tile "data11"))))
      (if (> end_num 11) (setq outtxt (strcat outtxt ";" (get_tile "data12"))))
      (if (> end_num 12) (setq outtxt (strcat outtxt ";" (get_tile "data13"))))
      (if (> end_num 13) (setq outtxt (strcat outtxt ";" (get_tile "data14"))))
      (if (= end_num 15) (setq outtxt (strcat outtxt ";" (get_tile "data15"))))
    );progn
    (set_tile "error" "料號未輸入!")
  );if
  outtxt
)
(defun add_mana_database()
  (setq wr_txt (get_data_val))
  (if (member data1 mnum_list)
    (set_tile "error" "料號重複! 無法寫入資料庫! ")
    (progn
      (setq database_list (cons wr_txt (reverse database_list)))
      (setq database_list (reverse database_list))
      (act_pop_list database_list "data")
      (mode_tile "mod" 1)(mode_tile "del" 1)
      (setq gbol_flag 1)
      (setq mnum_list (cons data1 mnum_list))
      (set_tile "error" (strcat data1 "新增完成!")) 
    );progn
  );if
  (princ)
)

(defun del_mana_database(/ txtid str_expect lst_expect dataitem)
  (setq txtid (atoi (get_tile "data")))
  (if (= 0 gbol_flag)(progn
      (setq str_expect (nth txtid database_sift))
      (setq lst_expect (member str_expect database_list))
      (if lst_expect (setq txtid (- (length database_list)(length lst_expect))))
      (setq gbol_flag 1)
  ));;SAM 轉換txtid
  (setq dataitem (nth txtid database_list))
  (setq database_list  (removelist dataitem database_list))
  (act_pop_list database_list "data")
  (mode_tile "mod" 1)
  (mode_tile "del" 1)
  (princ)
)
(defun mod_mana_database(/ txtid str_expect lst_expect)
  (setq txtid (atoi (get_tile "data")))
  (if (= 0 gbol_flag)(progn
      (setq str_expect (nth txtid database_sift))
      (setq lst_expect (member str_expect database_list))
      (if lst_expect (setq txtid (- (length database_list)(length lst_expect))))
      (setq gbol_flag 1)
  ));;SAM 轉換txtid
  (cond
    ((= "" (get_tile "data1")) (set_tile "error" "料號未輸入!"))
    ((= (strcase (get_tile "data1")) (strcase partnum))
      (setq wr_txt (get_data_val))
      (setq f_list (getfrontelist txtid database_list))
      (setq b_list (getbacklist txtid database_list))
      (setq newlist (cons wr_txt (reverse f_list)))
      (foreach nn b_list
         (progn
            (setq newlist (cons nn newlist))
         );progn
      );foreach 
      (setq database_list (reverse newlist))
      (act_pop_list database_list "data")
      (mode_tile "mod" 1)(mode_tile "del" 1)
    )   
    ((/= nil (member (get_tile "data1") mnum_list))
        (set_tile "error" "料號重複! 無法寫入資料庫! ")
    )
    ((null (member (get_tile "data1") mnum_list))
      (setq wr_txt (get_data_val))
      (setq f_list (getfrontelist txtid database_list))
      (setq b_list (getbacklist txtid database_list))
      (setq newlist (cons wr_txt (reverse f_list)))
      (foreach nn b_list
         (progn
            (setq newlist (cons nn newlist))
         );progn
      );foreach 
      (setq database_list (reverse newlist))
      (setq mnum_list (cons (get_tile "data1") mnum_list))
      (act_pop_list database_list "data")
      (mode_tile "mod" 1)(mode_tile "del" 1)
    );cond
  );cond
  (princ)
)

(defun exe_data_func(/ data_id detail_data collist coun )
  (mode_tile "mod" 0)
  (mode_tile "del" 0)
  (setq data_id (get_tile "data"))

  (cond ((= 0 gbol_flag)(setq detail_data (nth (atoi data_id) database_sift)))
        ((= 1 gbol_flag)(setq detail_data (nth (atoi data_id) database_list))));;SAM
  
  (setq collist (TXT_TRAN_LIST detail_data))
  (setq coun 1)
  (foreach nn collist
    (progn
      (set_tile (strcat "data" (rtos coun 2 0)) nn)
      (setq coun (1+ coun)) 
    );progn
  );foreach
  (setq partnum (get_tile "data1"))
)

(defun set_lab_val(/ collist coun)
 (setq collist (cdr (TXT_TRAN_LIST aadata)))
  (set_tile "lab1" "料號")
  (setq coun 2) 
  (if (null get_defpart) (load "dfsystem"))
  (setq totallist (nth 1 (get_defpart)))
  (foreach nn collist
    (progn
     (setq lab (nth 1 (assoc nn totallist)))

     (set_tile (strcat "lab" (rtos coun 2 0)) lab)
     (setq coun (1+ coun))
    );progn
  );foreach
  (setq end_num (- coun 1))
  (repeat (- 16 coun)
    (mode_tile (strcat "lab" (rtos coun 2 0)) 1)
    (mode_tile (strcat "data" (rtos coun 2 0)) 1)
    (setq coun (1+ coun))
  )
)

(defun creat_databae_list(/ dblist)
  (setq ff (open (strcat powdesign_path "database.txt") "r"))
  (setq db_list '() mnum_list '())
  (setq aadata (read-line ff))  

  (setq data (read-line ff))
  (princ "資料讀取中..")
  (while data 
    (setq num (nth 0 (TXT_TRAN_LIST data)))
    (setq mnum_list (cons num mnum_list))     ;;mnum_list 料號串列
    (setq db_list (cons data db_list))
    (princ ".")
    (setq data (read-line ff))
  );while 
  (close ff)
  (reverse db_list)
)

;;建立公用 BLOCK
(defun c:pdmwblk()
  (setq name (getfiled "建立圖檔"  (getvar "dwgprefix") "dwg" 1))
  (if (/= nil name)
    (progn
      (setq insp (getpoint "\n選擇基準點: "))
      (princ "\n選取物件: ")
      (setq entgrp (ssget))
      (if (findfile name)
        (command "wblock" name "y" "" insp entgrp "")
        (command "wblock" name "" insp entgrp "")
      );if
    );progn
  );if
  (initget "Yes No")
  (setq yesno (getkword "\n是否建立物料資訊?<Yes>:"))
  (if (or (null yesno) (= "Yes" yesno))
     (append_to_dwg_db)
  )
  (setq  lib_id nil)
 (princ)
)
(defun append_to_dwg_db()
      (actdcl (strcat POWDESIGN_dcl_path "manapart") "cbomdata")
      (setq lib_id 16)  ;; lib_id 公用變數
      (append_to_dwg_db_show lib_id)
      (action_tile "data1" "(setq lib_id 1)")
      (action_tile "data2" "(setq lib_id 2)")
      (action_tile "data3" "(setq lib_id 3)")
      (action_tile "data4" "(setq lib_id 4)")
      (action_tile "data5" "(setq lib_id 5)")
      (action_tile "data6" "(setq lib_id 6)")
      (action_tile "data7" "(setq lib_id 7)")
      (action_tile "data8" "(setq lib_id 8)")
      (action_tile "data9" "(setq lib_id 9)")
      (action_tile "data10" "(setq lib_id 10)")
      (action_tile "data11" "(setq lib_id 11)")
      (action_tile "data12" "(setq lib_id 12)")
      (action_tile "data13" "(setq lib_id 13)")
      (action_tile "data14" "(setq lib_id 14)")
      (action_tile "data15" "(setq lib_id 15)")

      (action_tile "lib" "(makepart_useword)")

      (action_tile "accept" "(append_to_dwg_db_ok)(done_dialog)")
      (action_tile "cancel" "(done_dialog)")
      (start_dialog)
);defun
(defun append_to_dwg_db_show(l_id)
  (setq lab_list '())
  (setq ff (open (strcat POWdesign_path "dwgdata.txt") "r"))
  (setq data (read-line ff))
  (while data
    (setq data (substr data (1+ (get_word data ";"))))
    (setq lab_list (cons data lab_list))
    (setq data (read-line ff))
  );while
  (close ff)
  (setq count 1)
  (foreach nn (reverse lab_list)
    (set_tile (strcat "lab" (rtos count 2 0)) nn)
    (setq count (1+ count))
  );foreach
  (repeat (- l_id count)
    (mode_tile (strcat "data" (rtos count 2 0)) 1)
    (setq count (1+ count))
  )
)

(defun append_to_dwg_db_ok(/ tdata count data ff)
  (setq tdata (get_tile "data1"))
  (if (= "" tdata) (setq tdata "nil"))
  (setq count 2)
  (repeat (- (length lab_list) 1)
    (setq data (get_tile (strcat "data" (rtos count 2 0))))
    (if (= "" data) (setq data "nil"))
    (setq tdata (strcat tdata ";" data))
    (setq count (1+ count))
  );repeat
  (setq ff (open (strcat POWdesign_path "data.txt") "w"))
  (write-line tdata ff)
  (close ff)
  (trans_data_todwg_db)
  (princ)
);defun




;;轉檔到 dwg.db
;; 以 dwgdata.txt 為輸出格式 , 產生 DATA.TXT
;; 範例 MSA-M6X50;內六角承窩螺絲;夾緊機;MSA-M6X50;js;6mm*50mm*P1.0;1;Screw.SKT.HD CAP;nil;nil;nil
(defun trans_data_todwg_db(/ ff qf data)
  (setq ff (open "c:\\bompath.txt" "w"))
 ; (write-line powdesign_path ff)   ;; 以 dwgdata.txt 為輸出格式 , 產生 DATA.TXT 在 powdesign_path
  (write-line system_dwg_libpath ff) ;; 以 dwgdata.txt 為輸出格式 , 產生 DATA.TXT 在 powdesign_path
  (close ff)
  (startapp (strcat POWdesign_path "change"))
  (princ "\n轉檔完成!")
  (princ)
);defun

;; 以圖管開圖
;;相關檔案 dwgdata.txt : 圖的相關顯示欄位
;          C:\bompath.txt : 起始路徑
;          c:\part.txt    : 選圖後回應值
;          openfile.scr
(defun c:opendwg(/ ff qf data fname datalist data_id yesno name flag)
   (setq olderr *error*)
   (defun *error* (msg)
      (princ msg)
      (if (/= nil qf) (close qf))
      (setq *error* olderr)
   )
  (setq ff (open "c:\\bompath.txt" "w"))
  (write-line system_dwg_libpath ff)
; (write-line (getvar "dwgprefix") ff)
  (close ff)
  (startapp (strcat POWdesign_path "manadwg"))
  (getpoint "\n請選取檔案後按 Enter 鍵!")
  (setq qf (open "c:\\part.txt" "r"))
  (setq data (read-line qf))
  (if (null data)
    (close qf)
    (progn
      (if (findfile data)
        (progn
          (setq fname data)
          (setq data (read-line qf))
          (setq datalist '())
          (while data
             (setq data_id (get_word data ":"))
             (setq data (substr data (1+ data_id)))
             (setq datalist (cons data datalist))
             (setq data (read-line qf))
          );while
          (close qf)
          (initget "Yes No")
         (setq yesno (getkword "\n是否儲存目前圖檔<Y>?"))
         (if (or (= "Yes" yseno) (null yesno))
           (progn
              (setq name (getfiled "儲存檔案為" (strcat (getvar "dwgprefix")(getvar "dwgname")) "dwg" 8))
              (if (/= nil name) (command "qsave") (setq flag t))
           );progn
         );if
         (if (/= flag t)
           (progn
             (if (null datalist) (setq datalist (reverse datalist)))
             (command "point" "0,0,0")(command "erase" (entlast) "")
             (if (/= "14" (substr (getvar "acadver") 1 2))
                 (progn
                    (setq ff (open (strcat POWDESIGN_path "openfile.scr") "w"))
                    (write-line "open" ff)
                    (write-line (strcat "\"" fname "\"") ff)
                    (close ff)
                 );progn
                 (progn     ;;;AutoCAD R14
                    (setq ff (open (strcat POWDESIGN_path "openfile.scr") "w"))
                    (write-line "open" ff)
                    (write-line "y" ff)
                    (write-line (strcat "\"" fname "\"") ff)
                ;    (write-line fname ff)
                    (close ff)
                 );progn
             );if
             (command "script" (strcat POWDESIGN_path "openfile"))
           );progn
         );if
       );progn
     );if
    );progn
  );if
  (setq *error* olderr)
  (princ)
);defun


;; 以圖管插入圖形
;;相關檔案 dwgdata.txt : 圖的相關顯示欄位
;          C:\bompath.txt : 起始路徑
;          c:\part.txt    : 選圖後回應值
;          openfile.scr
;(defun c:insdwg(/ ff qf data fname datalist data_id yesno name flag)
(defun c:insdwg(/ ff qf data fname data_id yesno name flag)
  (setq olderr *error*)
  (defun *error* (msg)
     (princ msg)
     (if (/= nil qf) (close qf))
     (setq *error* olderr)
  )
 (setq ff (open "c:\\bompath.txt" "w"))
 (write-line system_dwg_libpath ff)
 (close ff)
 (startapp (strcat POWdesign_path "manadwg"))
 (getpoint "\n請選取檔案後按 Enter 鍵!")
 (setq qf (open "c:\\part.txt" "r"))
 (setq data (read-line qf))
 (if (null data)
   (close qf)
   (progn
     (if (findfile data)
       (progn
         (setq fname data)
         (setq data (read-line qf))
         (setq datalist '())
         (while data
            (setq data_id (get_word data ":"))
            (setq data (substr data (1+ data_id)))
            (setq datalist (cons data datalist))
            (setq data (read-line qf))
         );while
         (close qf)
         (if (null datalist) (setq datalist (reverse datalist)))
         (initget "Yes No")
         (setq yesno (getkword "\n圖塊是否炸開<N>?"))
         (if (or (= "No" yseno) (null yesno))
           (progn
             (setq ff (open (strcat powdesign_path "openfile.scr") "w"))
             (write-line "insert" ff)
             (write-line (strcat "\"" fname "\"") ff)
          ;   (write-line fname ff)
             (close ff)
           );progn
           (progn
             (setq ff (open (strcat powdesign_path "openfile.scr") "w"))
             (write-line "insert" ff)
           ;  (write-line (strcat "*" fname) ff)
             (write-line (strcat "\"*" fname "\"") ff)
             (close ff)
           );progn
         );if
         (command "script" (strcat powdesign_path "openfile.scr"))
       );progn
     );if
   );progn
 );if
 (setq *error* olderr)
 (princ)
);defun

; sys_ball_layer        :     指標圓球層
; sys_ball_layercol     :     指標圓球層顏色
; sys_bomlist_layer     :     材料清單層
; sys_bomlist_layercol  :     材料清單層顏色
; (setq la (tblsearch "layer" sys_ball_layer))
; (if (= la nil) (command "layer" "n" sys_ball_layer "c" sys_ball_layercol sys_ball_layer ""))

;;全自動排列指標球
(defun c:autob(/ autob_fg p1 p2 p3 p4 scal la SCAL ftxt_len haveno_bomp)
   (setq olderr *error*)
   
   (defun *error* (msg)
     (princ msg)
     (if (= wucs 0)
         (command "ucs" "n" ucsorg)
     );if
     (rt_to_old_set)
     (setq *error* olderr)
   )

   (if (= (setq wucs (getvar "worlducs")) 0)
       (progn
            (setq ucsorg (getvar "ucsorg"))
            (command "ucs" "w")
      );progn
   );if

  (mem_curset)
  (setq scal (getvar "dimscale"))
  (setq la (tblsearch "layer" sys_ball_layer))
  (if (= la nil) (command "layer" "n" sys_ball_layer "c" sys_ball_layercol sys_ball_layer ""))
  (setq partref_grp (ssget "x" (list (cons 0 "INSERT") (cons 2 "PARTREF"))))  ;;取所有資訊點
  (setq partdef_grp (ssget "x" (list (cons 0 "INSERT") (cons 2 "PARTDEF"))))  ;;取所有假資訊點
  (if partdef_grp (progn
        (setq int_i 0)
        (repeat (sslength partdef_grp)
                (setq partref_grp (ssadd (ssname partdef_grp int_i) partref_grp))
                (setq int_i (1+ int_i))
        )
  ))        
  ;;=============2003.07.03 SAM 將資訊點X座標與Y座標值變為唯一性============================
  (setq lst_xpt '())(setq lst_ypt '())
  (if partref_grp (progn
        (setq i 0)
        (repeat (sslength partref_grp)
                (setq ent_prt (entget (ssname partref_grp i)))
                (setq flt_xpt (nth 1 (assoc 10 ent_prt)))
                (setq flt_ypt (nth 2 (assoc 10 ent_prt)))
                (setq flt_zpt (nth 3 (assoc 10 ent_prt)))
                (if (member flt_xpt lst_xpt)(progn
                    ;(setq flt_xpt (+ flt_xpt 0.1))
                    (while (member flt_xpt lst_xpt)
                           (setq flt_xpt (+ flt_xpt 0.1))
                    )
                    (setq ent_prt (subst (cons 10 (list flt_xpt flt_ypt flt_zpt))(assoc 10 ent_prt) ent_prt))
                    (entmod ent_prt)
                ))
                (setq lst_xpt (cons flt_xpt lst_xpt))
                (setq i (1+ i))
        )
        (setq i 0)
        (repeat (sslength partref_grp)
                (setq ent_prt (entget (ssname partref_grp i)))
                (setq flt_xpt (nth 1 (assoc 10 ent_prt)))
                (setq flt_ypt (nth 2 (assoc 10 ent_prt)))
                (setq flt_zpt (nth 3 (assoc 10 ent_prt)))
                (if (member flt_ypt lst_ypt)(progn
                    ;(setq flt_ypt (+ flt_ypt 0.1))
                    (while (member flt_ypt lst_ypt)
                           (setq flt_ypt (+ flt_ypt 0.1))
                    )
                    (setq ent_prt (subst (cons 10 (list flt_xpt flt_ypt flt_zpt))(assoc 10 ent_prt) ent_prt))
                    (entmod ent_prt)
                ))
                (setq lst_ypt (cons flt_ypt lst_ypt))
                (setq i (1+ i))
        )       
  ))
  ;;(setq partref_grp (ssget "x" (list (cons 0 "INSERT") (cons 2 "PARTREF"))))
  ;;============================================================================================
  
  (setq haveno_bomp (tblsearch "BLOCK" "$$partref_bom"))
  (if (null partref_grp)
    (if haveno_bomp
        (alert "資訊點已關閉 , 請先開啟資訊點 !")
        (alert "\n圖面上並無建立資訊點!")
    );if
    (progn
      (actdcl (strcat POWdesign_path "manapart") "autob")
      (setq scal (getvar "dimscale"))
      (if (null di)
        (setq gooddi (* scal (atof sys_ball_dia)))
        (setq di gooddi)
      )
      (if (and (/= nil ftxt)(/= "" ftxt))(set_tile "ftxt" ftxt))
;;=============================================================================
	(setq str_bno1 "")(setq str_bno2 "")
	(setq ssg_balltxt (ssget "x" '((-3 ("BALL_ID")))))
  	(if ssg_balltxt (progn
      	    (setq int_i 0)
      	    (setq lst_bno '())
      	    (repeat (sslength ssg_balltxt)
  	      	    (setq lst_obj (entget (ssname ssg_balltxt int_i) '("BALL_ID")))
  	      	    (setq str_bno (cdr (nth 0 (cdadr (assoc -3 lst_obj)))))
  	      	    (setq lst_bno (cons str_bno lst_bno))
  	      	    (setq int_i (1+ int_i))
      	    )
      	    (setq lst_bno (int_list_sort 0 lst_bno))
	    (if lst_bno (setq str_bno (list_symbolstr lst_bno " "))(progn (setq str_bno1 "")(setq str_bno2 "")))
	    (if (> (strlen str_bno) 36)(progn
                (setq str_bno1 (substr str_bno 1 36))
                (setq str_bno2 (substr str_bno 37))
            )(progn (setq str_bno1 (substr str_bno 1))))
	    (if (null str_bno1)(setq str_bno1 ""))
	    (if (null str_bno2)(setq str_bno2 ""))
	    (set_tile "memo1" (strcat "已標註件號 " str_bno1))
	    (set_tile "memo2" str_bno2)
  	))
;;=============================================================================
      (set_tile "dist" (rtos (* 1.2 (* scal (atof sys_ball_dia))) 2 2))
      (set_tile "error" (strcat "請注意:件號間距不可小於 " (rtos gooddi 2 2)))
      (action_tile "accept" "(autob_ok)")
      (action_tile "cancel" "(done_dialog)")
      (start_dialog)

      (if autob_fg
        (progn
          (setvar "osmode" 0)
          (setq 4plist (autob_get4point))
          (setq p1 (nth 0 4plist))
          (setq p2 (nth 1 4plist))
          (setq p3 (nth 2 4plist))
          (setq p4 (nth 3 4plist))
        ; (setq dist_x (* 0.5 (distance p1 p2)))
        ; (setq dist_y (* 0.5 (distance p2 p3)))
        ; (setq cen_p (polar p1 (angle p1 p3) (* 0.5 (distance p1 p3))))

          (setq l_grp (ssadd) r_grp (ssadd) u_grp (ssadd) b_grp (ssadd))
          (setq count 0)
          ;;此處的 partref_grp 為全部的真假資訊點
          (repeat (sslength partref_grp)
             (setq ent (ssname partref_grp count)
                   entdata (entget ent)
                   insp (cdr (assoc 10 entdata)))
             (if (and (> (nth 0 insp) (nth 0 p1)) (< (nth 0 insp) (nth 0 p2)) (> (nth 1 insp) (nth 1 p1)) (< (nth 1 insp) (nth 1 p3)))
                 (progn
                      (setq li (inters insp (polar insp pi 3) p1 p4 nil)
                            ri (inters insp (polar insp 0 3) p3 p2 nil)
                            ui (inters insp (polar insp (* pi 0.5) 3) p3 p4 nil)
                            bi (inters insp (polar insp (* pi 1.5) 3) p1 p2 nil)
                            di_l (distance insp li)
                            di_r (distance insp ri)
                            di_u (distance insp ui)
                            di_b (distance insp bi))

                      (setq min_v di_l)
                      (setq di_list (list di_r di_u di_b))
                      (foreach nn di_list
                         (progn
                             (if (< nn min_v)(setq min_v nn))
                         );progn
                      );foreach
                      (cond
                        ((= min_v di_l) (setq l_grp (ssadd ent l_grp)))
                        ((= min_v di_r) (setq r_grp (ssadd ent r_grp)))
                        ((= min_v di_u) (setq u_grp (ssadd ent u_grp)))
                        (T              (setq b_grp (ssadd ent b_grp)))
                      );cond
                      (setq count (1+ count))
                 );progn
                 (setq count (1+ count))
             );if
          );repeat
          (setq lst_lay_fno '());;紀錄哪個圖層代表哪個號碼(球號)
          (if (/= 0 (sslength l_grp))
            (progn
             (setq cir_ssg (ssadd) txt_ssg (ssadd))           ;rex
             (setq lst_ent nil)
             (autobom_drawc&l p4 l_grp "L" di)
            );progn
          );if
          (if (/= 0 (sslength r_grp))
            (progn
             (setq cir_ssg (ssadd) txt_ssg (ssadd))           ;rex
             (setq lst_ent nil)
             (autobom_drawc&l p2 r_grp "R" di)
            );progn
          );if
          (if (/= 0 (sslength u_grp))
            (progn
             (setq cir_ssg (ssadd) txt_ssg (ssadd))           ;rex
             (setq lst_ent nil)
             (autobom_drawc&l p3 u_grp "U" di)
            );progn
          );if
          (if (/= 0 (sslength b_grp))
            (progn
             (setq cir_ssg (ssadd) txt_ssg (ssadd))           ;rex
             (setq lst_ent nil)
             (autobom_drawc&l p1 b_grp "B" di)
            );progn
          );if
        );progn
      );if
    );progn
  );if
  (rt_to_old_set)
   (if (= wucs 0)
       (command "ucs" "n" ucsorg)
   );if  
  (redraw)
  (setq *error* olderr)
  (setq partno nil)
  (princ)
)

(defun autob_ok()
  (setq di (get_tile "dist")
        ftxt (get_tile "ftxt")
        fno (get_tile "fno"))
  (if (and (/= nil ftxt)(/= "" ftxt))
          (progn
               (set_tile "ftxt" ftxt)
               (setq ftxt_len (strlen ftxt))
          );progn
          (progn
               (setq ftxt_len 0)
          );progn  
  );if

  (cond
    ((= "" di)(set_tile "error" "未輸入件號間距!"))
    ((= "" fno)(set_tile "error" "未輸入起始件號!"))
    ((= 0 (atoi fno))(set_tile "error" "件號不可為 0 值或文字!"))
    (T (setq autob_fg t fno (atoi fno))(setq di (atof di))(done_dialog))
  );cond
)

;;;>>>> REX lisp
(defun modifyatt_tobomball(ent newid / $data1)
       (setq $data1 (getatt ent 2 "TAG1")
             $data1 (subst (cons 1 newid) (assoc 1 $data1) $data1))
       (entmod $data1)
;  (command "regen")
)

(defun bomline(leadp_list imfp_list pptlist startid / modifyent flag a_h a_t a_a temp_list mm a_temp
                                                      p_temp cc lead_p imf_p ang gg_i gg dd new_id kk1 kk2
                                                      txtent_flag cirent_flag)
     (setq a_h (car leadp_list))
     (setq a_t (car (reverse leadp_list)))
     (setq a_a (angle a_h a_t))
     (if (= a_a (* 1.5 pi)) (setq flag 1))
     (if (/= (length leadp_list) (length imfp_list))(progn
              (princ "泡泡球與資訊點個數不一樣")
              (exit)
     ))
     (setq temp_list nil)
     ;;=============== 資訊點重新排列 ================
     (foreach mm leadp_list
           (setq a_temp 0)
           (setq p_temp nil)
           (setq lead_p mm)
           (foreach cc pptlist
                 (setq imf_p cc)
                 (if (or (>  (setq ang  (ang_tr flag (angle lead_p (nth 0 imf_p))))  a_temp)
                         (and (=  (setq ang  (ang_tr flag (angle lead_p (nth 0 imf_p)))) a_temp)
                              (> (distance lead_p (nth 0 p_temp)) (distance lead_p (nth 0 imf_p)))
                         );and
                     );or
                     (progn
                          (setq a_temp ang)
                          (setq p_temp imf_p)
                     );progn

                 );if
           );foreach
            (setq pptlist (sLs p_temp pptlist))
            (setq temp_list (append temp_list (list p_temp)))
     );foreach
     (setq pptlist temp_list)
     ;;=============== 計算圓球半徑 ================
     (if (= 0 (atof sys_ball_dia))
         (setq dd  (* 1.2 scal (atof sys_balltxt_hei))) 
         (setq dd  (* 0.5 scal (atof sys_ball_dia)))     
     )
     (setq new_id startid aa1 imfp_list aa2 pptlist)
  
     (setq gg_i 0)
     (setq count 0) 
     (foreach gg leadp_list (progn
         (setq ggh gg)
         (setq ang (angle gg (nth 0 (nth gg_i pptlist))))        ;rex
         (setq  gg (polar gg ang dd))                            ;jackson
         (command "Line" gg (nth 0 (nth gg_i pptlist)) "")       ;rex
         ;;=========用文字的點在 pptlist 尋找所屬球號(更換文字值)=========
         (setq str_lay (cdr (assoc 8 (entget (nth 1 (nth gg_i pptlist))))))
	 (setq str_blk (cdr (assoc 2 (entget (nth 1 (nth gg_i pptlist))))));;partref or partdef
         (setq ~idx nil)
         (setq int_i 0)
         (repeat (length pptlist)
                 (setq pnt_tmp (nth 3 (nth int_i pptlist)))
                 (if (equal ggh pnt_tmp)(progn
                     (setq ~idx (nth 2 (nth int_i pptlist)))
		     ;;==============================================
		     ;;(while (member (strcat ftxt (itoa ~idx)) lst_bno)
		     ;;  	    (setq ~idx (+ 1 ~idx))
		     ;;)
		     ;;==============================================
		     (setq str_value (strcat ftxt (itoa ~idx)))
                     (setq lst_obj   (entget (nth 1 (nth int_i lst_ent))));;lst_ent (("圖層" <圖元>)...)
                     (setq lst_obj   (subst (cons 1 str_value)(assoc 1 lst_obj) lst_obj))
                     (entmod lst_obj)
		     ;;============================
		     (if (= "partdef" str_blk)(progn
	     	     	 (setq ssg_partref (ssget "x" (list (cons 8 str_lay)(cons 2 "partref"))))
	     	     	 (setq str_value (getent_attfield (ssname ssg_partref 0) "TAG1"))
	     	     	 (if (/= "" str_value)(progn
		     	     (setq lst_obj (entget (nth 1 (assoc str_lay lst_ent))))
		     	     (setq lst_obj (subst (cons 1 str_value)(assoc 1 lst_obj) lst_obj))
                     	     (entmod lst_obj)
		     	 ))
	 	     ))
		     ;;============================
                     (setq ent_txt (cdr (assoc -1 lst_obj)))
                     (ad1xdata ent_txt str_lay   (list str_lay   (cons 1000 str_lay)))
                     (ad1xdata ent_txt "layer"   (list "layer"   (cons 1000 str_lay)))
		     (ad1xdata ent_txt "BALL_ID" (list "BALL_ID" (cons 1000 str_value)))
                 ))
                 (setq int_i (1+ int_i))
         )
         ;================================================================
         (setq gg_i (1+ gg_i))
     
         (setq ent (entget (nth 1 (nth count pptlist))))                    ;;jackson
         (setq layname (cdr (assoc 8 ent)))                                 ;;jackson
         (ad1xdata (entlast) layname (list layname (cons 1000 layname)))    ;;jackson
         (ad1xdata (entlast) "layer" (list "layer" (cons 1000 layname)))
     
         (if (= "1" sys_ball_yesno)                                                              ;rex
             (progn                                                                              ;rex
                  (setq cirent_flag nil kk1 0)                                                   ;rex
                  (while (null cirent_flag)                                                      ;rex
                         (if (equal ggh (cdr (assoc 10 (entget (ssname cir_ssg kk1)))))          ;rex
                             (setq cir_ent (ssname cir_ssg kk1) cirent_flag T)                   ;rex
                         )                                                                       ;rex
                         (setq kk1 (+ kk1 1))                                                    ;rex
                  )                                                                              ;rex
                  (setq cir_ssg (ssdel cir_ent cir_ssg))                                         ;rex
                  (ad1xdata cir_ent layname (list layname (cons 1000 layname)))                  ;rex
                  (ad1xdata cir_ent "layer" (list "layer" (cons 1000 layname)))
             );progn
         );if
         
         (setq txtent_flag nil kk2 0)                                                   ;rex
         ;(setq ballnum (sslength txt_ssg))                                              ;;jackson
         ;(while (null  txtent_flag)                                                     ;rex
;;
;;         (while (null txtent_flag)
;;         ;(while (and (< kk2 ballnum) (null  txtent_flag))
;;                (setq a_ent (ssname txt_ssg kk2))
;;                (setq b_ent (entget a_ent))
;;                ;(if (= (rtos new_id 2 0) (cdr (assoc 1 b)))
;;                (if (= (rtos new_id 2 0) (substr (cdr (assoc 1 b)) (1+ ftxt_len)))
;;                ;(if (= (rtos new_id 2 0) (cdr (assoc 1 (entget (ssname txt_ssg kk2)))));rex
;;                (setq txt_ent (ssname txt_ssg kk2) txtent_flag T)                       ;rex
;;                )                                                                       ;rex
;;                (setq kk2 (+ kk2 1))                                                    ;rex
;;         )                                                                              ;rex
;;         (setq txt_ssg (ssdel txt_ent txt_ssg))                                         ;rex
;;         (ad1xdata txt_ent layname (list layname (cons 1000 layname)))                  ;rex
;;         (ad1xdata txt_ent "layer" (list "layer" (cons 1000 layname)))
;;
        ; (command "text" (nth 0 (nth (- gg_i 1) pptlist)) "" "" new_id)  ;rex
        ; (setq modifyent nil kki 0)                                                         ;rex
        ; (while (and (null modifyent) (<= kki (length pptlist)))                            ;rex
        ;        (if  (equal (nth (- gg_i 1) imfp_list) (nth 0 (nth kki pptlist)))           ;rex
        ;             (setq modifyent (nth 1 (nth kki pptlist)) kki (+ 1 (length pptlist)))  ;rex
        ;        );if                                                                        ;rex
        ;        (setq kki (+ kki 1))                                                        ;rex
        ; )                                                                                  ;rex
        ; (modifyatt_tobomball modifyent (strcat ftxt (rtos new_id 2 0)));rex

         ;;修改組合件號 TAG1 SAM 拿掉
         ;(modifyatt_tobomball (nth 1 (nth (- gg_i 1) pptlist)) (strcat ftxt (rtos new_id 2 0)));rex
         (setq count (1+ count) new_id (1+ new_id))                                            ;;jackson
     ));foreach
);defun

 (defun *error* (msg)
       (princ)
  ) ;defun


 (defun sLs(obj li / cc alist flag cc_obj  )
      (setq cc 0)
      (setq alist nil)
      (setq flag t)
      (while (/= (setq cc_obj (nth cc li)) nil)
           (if (or (= flag nil)
                   (null (equal cc_obj  obj))
               );or
               (setq alist (append  alist (list cc_obj)))
           );if
           (if (equal cc_obj obj)
               (setq flag nil)
           );if
           (setq cc (1+ cc))
      );while
      alist
 );defun

 (defun ang_tr(flag a_tr)
      (if (= flag 1)
          (progn
               (if (< (- a_tr (* 1.5 pi)) 0)
                   (setq a_tr (+ a_tr (* 0.5 pi)))
                   (setq a_tr (- a_tr (* 1.5 pi)))
               );if

          );progn
      );if
      a_tr
 );defun

;;;<<<< jacky lisp

(defun autob_get4point(/ pp1 pp2 ap1 ap2 ap3 ap4)
  (setq cir_ssg (ssadd) txt_ssg (ssadd))           ;rex
  (setq pp1 (getpoint "\n指標球編號位置第一角點: "))
  (while (null pp1)
    (princ "\n請再點選一次...")
    (setq pp1 (getpoint "\n指標球編號位置第一角點: "))
  )
  (setq pp2 (getcorner pp1 "\n另一角點: "))
  (while (null pp2)
    (princ "\n請再點選一次...")
    (setq pp2 (getcorner pp1 "\n指標球編號位置另一角點: "))
  )

  (cond
    ((and (> (nth 0 pp2) (nth 0 pp1))(> (nth 1 pp1)(nth 1 pp2))) (setq ap4 pp1 ap2 pp2))
    ((and (> (nth 0 pp1) (nth 0 pp2))(> (nth 1 pp2)(nth 1 pp1))) (setq ap4 pp2 ap2 pp1))
    ((and (> (nth 0 pp2) (nth 0 pp1))(> (nth 1 pp2)(nth 1 pp1))) (setq ap1 pp1 ap3 pp2))
    (T (setq ap1 pp2 ap3 pp1))
  );cond

  (if (null ap1)(setq ap1 (list (nth 0 ap4) (nth 1 ap2))))
  (if (null ap2)(setq ap2 (list (nth 0 ap3) (nth 1 ap1))))
  (if (null ap3)(setq ap3 (list (nth 0 ap2) (nth 1 ap4))))
  (if (null ap4)(setq ap4 (list (nth 0 ap1) (nth 1 ap3))))
  (list ap1 ap2 ap3 ap4)
);defun

(defun autobom_drawc&l(basep grp typ ddi / start_id ballgrp xylist plist ballgrp data data10 count
                                           txtgrp sp ang oldlist oldtag1 lay ptlist txtplist lst_ent
                                           lst_tmp1 lst_tmp2 lst_tmp3 lst_tmp4 lst_tmp5)
;; defball_list          :  指標球定義=("1" "7" "0" "0" "3")
;; sys_ball_yesno        :  指標球有無
;; sys_ball_dia          :  指標球直徑
;; sys_ballpoint_type    :  指標形式      ;; sys_balldonut_yesno   :  指線圓點有無
;; sys_ballpoint_size    :  指標尺寸      ;  ; sys_balldonut_dia
;; sys_balltxt_hei       :  指標球字高

   (setq curlayer (getvar "clayer"))
   (setq curcolor (getvar "cecolor"))
   (setq curltype (getvar "celtype"))
   
   (command "linetype" "s" "bylayer" "" "color" "bylayer" "layer" "s" sys_BALL_layer "")
   (command "linetype" "s" "continuous" "")
   (setvar "osmode" 0)

  (setq scal (getvar "dimscale"))
  (setq ballgrp (ssadd) txtgrp (ssadd))
  (setq xylist (comp_xypo grp))
   
  (cond
    ((= "L" typ) (setq ptlist (nth 1 xylist)))
    ((= "R" typ) (setq ptlist (nth 1 xylist)))
    ((= "U" typ) (setq ptlist (nth 0 xylist)))
    ((= "B" typ) (setq ptlist (nth 0 xylist)))
  )
  (setq count 0)

  (if (= "R" typ)(setq ptlist (reverse ptlist)))
  (if (= "B" typ)(setq ptlist (reverse ptlist)))

  (setq start_id fno)
  ;;====================將資訊點球號寫入 ptlist==========================
  (setq int_i 0)
  (setq lst_tmp1 '())
  (setq lst_tmp2 '())
  (repeat (length ptlist)
          (setq lst_tmp1 (nth int_i ptlist))
          (setq ename (nth 1 lst_tmp1))
          (setq lay (strcase (cdr (assoc 8 (entget ename)))))
          (if (null (assoc lay lst_lay_fno))(progn
              (setq lst_lay_fno (cons (list lay fno) lst_lay_fno))
              (setq fno (1+ fno))
          ))
          (setq num_ball (nth 1 (assoc lay lst_lay_fno)))
          (setq lst_tmp2 (cons (append lst_tmp1 (list num_ball)) lst_tmp2))
          (setq int_i (1+ int_i))
  )
  (setq ptlist (reverse lst_tmp2))

  ;;====================================================================
  (foreach nn ptlist

     (setq ename (nth 1 nn))
     (setq lay (strcase (cdr (assoc 8 (entget ename)))))
     
     (if (= "partref"　(cdr (assoc 2 (entget ename))))(progn
         (setq oldlist (get_bomdata ename))  ;舊的資訊點資料串列

         (setq oldtag1 (assoc "TAG1" oldlist))                              ;舊的資訊點 TAG1 資料串列
         (setq newlist (subst (list "TAG1" (strcat ftxt (rtos (nth 2 nn) 2 0))) oldtag1 oldlist));新件號取代舊件號
         (addatt_tobomball ename newlist)                                   ;新資料寫入資訊點
         ;(setq numdata (getatt ename 2 "TAG1"))
     ))

     (command "text" "m" basep (* scal (atof sys_balltxt_hei)) "0" (strcat ftxt (rtos (nth 2 nn) 2 0)))
     (ad1xdata (entlast) "BALL_ID" (list "BALL_ID" (cons 1000 (strcat ftxt (rtos (nth 2 nn) 2 0)))));;sam
     (setq txtgrp (ssadd (entlast) txtgrp))
     (setq txt_ssg (ssadd (entlast) txt_ssg))  ;rex
     (setq lst_ent (cons (list lay (entlast)) lst_ent))   ;sam
   
     (if (= "1" sys_ball_yesno)
       (progn
         (command "circle" basep (* scal 0.5 (atof sys_ball_dia)))
         (setq ballgrp (ssadd (entlast) ballgrp))
         (setq cir_ssg (ssadd (entlast) cir_ssg)) 
       );progn
     );if
     (cond
       ((= "L" typ) (setq basep (polar basep (* 1.5 pi) ddi)))
       ((= "R" typ) (setq basep (polar basep (* 0.5 pi) ddi)))
       ((= "U" typ) (setq basep (polar basep  pi ddi)))
       ((= "B" typ) (setq basep (polar basep 0 ddi)))
     );cond
     (setq count (1+ count))
  );repeat

;;>>>> JACKY
   (command "move" txtgrp ballgrp "" basep pause)
;;<<<< JACKY

  (setq count 0)
  (setq bomplist '())
  (setq txtplist '())
  (foreach nn ptlist
     (setq bomplist (cons (nth 0 nn) bomplist))
     (setq data (entget (ssname txtgrp count)))
     (setq txtplist (cons (cdr (assoc 11 data)) txtplist))
     (setq count (1+ count))
  );foreach

  ;;==================將文字的點加入 ptlist================
  (setq txtplist (reverse txtplist))
  (setq bomplist (reverse bomplist))
  (setq lst_ent (reverse lst_ent))
  (setq lst_tmp5 '())
  (setq int_i 0)
  (repeat (length ptlist)
          (setq lst_tmp3 (nth int_i txtplist))
          (setq lst_tmp4 '())
          (setq lst_tmp4 (nth int_i ptlist))
          (setq lst_tmp4 (append lst_tmp4 (list lst_tmp3)))
          (setq lst_tmp5 (cons lst_tmp4 lst_tmp5))
          (setq int_i (1+ int_i))
  )
  (setq ptlist (reverse lst_tmp5))
  ;;=====================================================
  ;;ptlist = (資訊點 資訊圖元 資訊點編號 文字點)
   (bomline txtplist bomplist ptlist start_id)
     
   (command "layer" "s" curlayer "")   
   (command "linetype" "s" curltype "")
   (cond
     ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
     ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
     (T (command "color" (atoi curcolor)))
   )
     

)

;;垂直排列或水平排列指標球
(defun c:ball(/ grp partref_grp count ent entdata data0 data2 xylist typ p1 d1 ballgrp plist data data10)
    (princ "\n框選圖形...")
    (setq grp (ssget) partref_grp (ssadd) count 0)
    (if grp
      (progn
         (repeat (sslength grp)
            (setq ent (ssname grp count)
                  entdata (entget ent)
                  data0 (cdr (assoc 0 entdata))
                  data2 (cdr (assoc 2 entdata)))
            (if (and (= data0 "INSERT")(= data2 "PARTREF"))
               (setq partref_grp (ssadd ent partref_grp))
            );if
            (setq count (1+ count))
         );repeat
      );progn
    );if
    (if (/= 0 (sslength partref_grp))
      (setq xylist (nth 0 (comp_xypo partref_grp)))
    );if
    (initget 1 "H V")
    (setq typ (getkword "\n垂直排列 V/水平排列<H>: "))
    (setq p1 (getpoint "\n編號位置: "))
    (setq di (getdist "\n間距: "))
    (setq ballgrp (ssadd))
    (if (= "H" typ)
      (progn
        (setq plist (nth 0 xylist))
        (foreach nn plist
           (progn
             (command "circle" p1 "5")
             (setq ballgrp (ssadd (entlast) ballgrp))
             (setq p1 (polar p1 0 di))
           );progn
        );foreach
      );progn
      (progn
        (setq plist (nth 1 xylist))
        (foreach nn plist
           (progn
             (command "circle" p1 "5")
             (setq ballgrp (ssadd (entlast) ballgrp))
             (setq p1 (polar p1 (* 0.5 pi) di))
           );progn
        );foreach
      );progn
    );if
    (command "move" ballgrp "" p1 pause)
    (setq count 0)
    (if (= typ "V")
      (setq plist (reverse plist))
    )
    (repeat (sslength ballgrp)
       (setq data (entget (ssname ballgrp count))
             data10 (cdr (assoc 10 data)))
       (command "line" data10 (car (nth count plist)) "")
       (setq count (1+ count))
    );repeat
);defun

(defun c:test()
    (princ "\n框選圖形...")
    (setq grp (ssget) partref_grp (ssadd) count 0)
    (if grp
      (progn
         (repeat (sslength grp)
            (setq ent (ssname grp count)
                  entdata (entget ent)
                  data0 (cdr (assoc 0 entdata))
                  data2 (cdr (assoc 2 entdata)))
            (if (and (= data0 "INSERT")(= data2 "PARTREF"))
               (setq partref_grp (ssadd ent partref_grp))
            );if
            (setq count (1+ count))
         );repeat
      );progn
    );if
    (setq a (comp_xypo partref_grp))

);defun

;;取出圖群內所有 10 碼座標點資料,並回應 ( 以 x 值為基準,由小到大的座標點資料排列, 以 y 值為基準,由小到大的座標點資料排列)
(defun comp_xypo(entgrp / xlist ylist x&list y&list count ent entdata data10 newxlist newylist x&list_ent y&list_ent xent_list yent_list)
  (setq xlist '() ylist '() x&list '() y&list '() count 0 x&list_ent '() y&list_ent '())
  (repeat (sslength entgrp)
      (setq ent (ssname entgrp count)
            entdata (entget ent)
            data10 (cdr (assoc 10 entdata)))
      (setq xlist (cons (nth 0 data10) xlist)                        ;xlist: (x5 x2 x7 x3 ...)
            ylist (cons (nth 1 data10) ylist)                        ;ylist: (y5 y2 y7 y4 ...)
            x&list_ent (cons (list (nth 0 data10) data10 ent) x&list_ent)   ;x&list_ent:((x5 (x5 y5 z5) 圖元5)(x2 (x2 y2 z2) 圖元2)(x7 (x7 y7 z7) 圖元7)...)
            y&list_ent (cons (list (nth 1 data10) data10 ent) y&list_ent)   ;y&list_ent:((y5 (x5 y5 z5) 圖元5)(y2 (x2 y2 z2) 圖元2)(y7 (x7 y7 z7) 圖元7)...)
            x&list (cons (list (nth 0 data10) data10) x&list)        ;x&list:((x5 (x5 y5 z5))(x2 (x2 y2 z2))...)
            y&list (cons (list (nth 1 data10) data10) y&list))       ;y&list:((y5 (x5 y5 z5))(y2 (x2 y2 z2))...)
      (setq count (1+ count))
  );repeat
  (setq newxlist (compnum_list xlist))                               ;newxlist: (x2 x3 x5 x7 ...)
  (setq newylist (compnum_list ylist))                               ;newylist: (y2 y3 y5 y6 ...)
  (setq xlist '() ylist '() xent_list '() yent_list '())
  (foreach nn newxlist
    (progn
     (setq xent_list (cons (cdr (assoc nn x&list_ent)) xent_list))               ;以 x 值為比較值排列過的圖元總串列
     (setq xlist (cons (cdr (assoc nn x&list)) xlist))               ;以 x 值為比較值排列過的 總串列
    );progn
  );foreach
  (foreach nn newylist
    (progn
     (setq yent_list (cons (cdr (assoc nn y&list_ent)) yent_list))               ;以 x 值為比較值排列過的圖元總串列
     (setq ylist (cons (cdr (assoc nn y&list)) ylist))               ;以 y 值為比較值排列過的 總串列
    );progn
  );foreach
  (setq xlist (reverse xlist))
  (setq ylist (reverse ylist))
; (list (list xlist ylist)(list xent_list yent_list))
  (list xent_list yent_list)
; (list xlist ylist)
)


;;將數字串列由小排到大
(defun compnum_list(nl)
   (setq min_v (nth 0 nl) newl '())
   (while (/= 1 (length nl))
     (foreach nn nl
      (progn
        (if (< nn min_v) (setq min_v nn))
      );progn
     );foreach
     (setq nl (removelist_ball min_v nl)) ;;;2003.06.10 SAM
     (setq newl (cons min_v newl))
     (setq min_v (nth 0 nl))
   );while
   (setq newl (cons (car nl) newl))
   (reverse newl)
);defun

;;;
;;; 2003.06.10 SAM -- 原來 CALL PUB-LISP 中的 removelist
(defun removelist_ball(obj li / lst_mm int_key i nlst itm)
        (setq lst_mm (member obj li))
        (setq int_key (- (length li) (length lst_mm)))
        (setq i 0)
        (repeat (length li)
                (if (/= i int_key)(progn
                    (setq itm (nth i li))
                    (setq nlst (cons itm nlst))
                ))
                (setq i (1+ i))
        )
        (reverse nlst)
)


;;改變零件圖層顏色
(defun c:chlacol(/ ent entdata la lacol newcol)
  (setvar "cmdecho" 0)
  (setq ent (entsel "\n請點選圖形,以改變該零件顏色: "))
  (if ent
     (progn
        (setq entdata (entget (car ent)))
        (setq la (cdr (assoc 8 entdata)))
        (setq lacol (cdr (assoc 62 (tblsearch "layer" la))))
        (setq newcol (acad_colordlg lacol))
        (if (/= nil newcol) (command "layer" "m" la "c" newcol "" ""))
     );progn
  );if
  (setvar "cmdecho" 1)
  (princ)
)


;; 產生結構樹
;; typ = 0  --> 產生結構樹(含詳細資料)
;; typ = 1  --> 匯出檔案到 Excel
;; typ = 2  --> 匯出檔案到
;; typ = 3  --> 產生結構詳細
;;
;(defun bomtree(typ / qq needlayer bomball_grp partdata count balllist num ff fname rf tittxt title_list
(defun bomtree(typ / qq bomball_grp partdata count balllist num ff fname rf tittxt title_list
                     qty ent data8 qf data bomdata outtxt tag txt num outf)
  (if (findfile (strcat POWdesign_path "title.txt"))
    (progn
      (setq qq (open "c:\\bompath.txt" "w"))
      (write-line  POWdesign_path qq)  ;;寫出系統路徑,給manadwg.exe辨認
      (close qq)
      (setq needlayer (coll_all_layer))  ;; 選擇所有圖層,並過濾不建立資訊點的圖層
      (foreach nn needlayer
        (progn
;         (princ (strcat "\n過濾 " nn " 圖層圖元..."))
          (setq ggg (ssget "x" (list (cons 8 nn))))
          (if (null ggg) (setq needlayer (removelist nn needlayer)))
        );progn
      );foreach
      (setq bomball_grp (ssget "x" (list (cons 0 "INSERT") (cons 2 "PARTREF"))))  ;;取所有資訊點
      (setq partdata (read (getfile_val (strcat POWdesign_path "SYSTEM.ini") "零件定義資料")))
      (setq count 0 balllist '() num 1)
      (cond
       ((or (= typ 2)(= typ 0)(= typ 3))(setq ff (open (strcat  POWDESIGN_path "bom.out") "w")))
       ((= typ 1)(setq fname (getstring "\n檔名: ")) (setq ff (open (strcat  fname ".xls") "w")))
      )
      (setq rf (open (strcat  POWDESIGN_path "title.txt") "r"))
      (setq tittxt (read-line rf))                               ;;tittxt 層名;品名;材質;圖號;製圖;說明;數量;表面處理;機種;規格;英文品名
      (close rf)                                                 ;; 寫出本組合圖名
      (write-line tittxt ff)
      (setq title_list (TXT_TRAN_LIST tittxt))                   ;;title_list ("層名" "品名" "材質" ...)
      (if (or (= typ 2)(= typ 0)(= typ 3))(write-line (curdwgname) ff))
      (princ "\n建立結構樹資料庫.")
      (if (/= nil bomball_grp)
        (progn
          (setq qty (sslength bomball_grp))

       ;;;寫出次阻立 REX
          (if (or (= typ 0)(= typ 2)(= typ 3))
              (progn
                     (setq num2 1 count2 0 subdata_list '() sub_list '() subname_list '())
                     (repeat qty
                            (setq ent (ssname bomball_grp count2))
                            (if (/= "" (cdr (assoc 1 (getatt ent 2 "TAG2"))))
                                (progn
                                      (if  (null (member (setq subname (cdr (assoc 1 (getatt ent 2 "TAG2")))) sub_list))
                                           (progn
                                                (setq sub_list(cons subname sub_list))
                                                (setq subtxt (strcat "1;" (rtos (+ qty num2) 2 0) ";0;" subname))

                                                (repeat (- (length title_list) 1)
                                                     (setq subtxt (strcat subtxt ";nil"))
                                                );repeat
                                                (setq kkl title_list)
                                                (write-line subtxt ff)

                                                (setq subdata_list (cons (list count2 (rtos (+ qty num2) 2 0)) subdata_list))
                                                (setq subname_list (cons (list subname (rtos (+ qty num2) 2 0)) subname_list))
                                                (setq num2 (+ num2 1))
                                           );progn
                                           (setq subdata_list (cons (list count2 (nth 1 (assoc subname subname_list))) subdata_list))
                                      );if
                                );progn
                            );if
                            (setq count2(+ count2 1))
                     );repeat
              );progn
          );if
       ;;;寫出次阻立 REX

          (repeat qty
            (setq ent (ssname bomball_grp count))
            (setq data8 (cdr (assoc 8 (entget ent))))
            (if (member data8 needlayer)
                (setq needlayer (removelist data8 needlayer))     ;;needlayer 沒有資訊點的零件圖層
            );if
;;寫出有資訊點的零件圖層
            (setq qf (open (strcat POWDESIGN_path "title.txt") "r"))
            (setq data (read-line qf))(close qf)
            (setq bomdata (reverse (get_bomdata ent)))
;;title_list ("層名" "品名" "材質" "#圖號" "製圖" "數量" "表面處理" "英文品名" "規格" "機種" "說明")
;;bomdata (("TAG3" "內六角承窩螺絲") ("TAG8" "") ("TAG13" "") ("TAG1" "") ("TAG2" "") ("TAG6" "") ("TAG7" "") ("TAG11" "") ("TAG12" "") ("TAG4" "") ("TAG5" "") ("TAG10" "8mm*20mm*P1.25") ("TAG9" "Screw.SKT.HD CAP") ("TAG14" "") ("TAG15" ""))
;;partdata (("組合件號" "" "TAG1") ("次組合名稱" "" "TAG2") ("品名" "PARTNAME" "TAG3") ("材質" "MATERIAL" "TAG4") ("#圖號" "DWGNO" "TAG5") ("製圖" "DRAWER" "TAG6") ("數量" "QTY" "TAG7") ("表面處理" "SURFACE" "TAG8") ("英文品名" "" "TAG9") ("規格" "" "TAG10") ("機種" "ITEM" "TAG11") ("說明" "" "TAG12"))
            (if (or (= typ 0)(= typ 2)(= typ 3))
                (progn
                      (if (assoc count subdata_list)                                     ;rex
                          (setq subid (nth 1 (assoc count subdata_list)))                ;rex
                          (setq subid "")                                                ;rex
                      )                                                                  ;rex
                      (if (/= "" subid)                                                  ;rex
                          (setq outtxt (strcat "1;" (rtos num 2) ";" subid ";" data8))   ;rex
                          (setq outtxt (strcat "1;" (rtos num 2) ";0;" data8))
                      )                                                                  ;rex
                );progn
                (setq outtxt data8)
            )
            (foreach nn (cdr title_list)
              (progn
                (setq tag (nth 2 (assoc nn partdata)))
                (setq txt (nth 1 (assoc tag bomdata)))
                (if (= "" txt)
                  (progn
                    (if(or(= typ 2)(= typ 3) (= typ 0))(setq txt "nil") (setq txt ""))
                  );progn
                );if
                (setq outtxt (strcat outtxt ";" txt))
              );progn
            );foreach
            (write-line outtxt ff)
;           (princ "\n")
;           (princ outtxt)
;           (princ bomdata)
            (setq count (1+ count))
            (setq num (1+ num))
            (princ ".")
          );repeat
        );progn
      );if
    ;;needlayer沒有資訊點的零件圖層資料寫出               ;; outtxt 沒有資訊點的資料 0;5;0;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil
    (if (/= nil needlayer)
        (progn
             (foreach nn needlayer
                (progn
                     (if (or (= typ 0)(= typ 2)(= typ 3))                          ;; 0;5;0;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil
                         (progn                                                    ;; │││ │
                              (setq outtxt (strcat "0;" (rtos num 2 ) ";0;" nn))   ;; │││ └─────  第 4 筆以後: 與 title_list 欄位對應的資料
                              (repeat (- (length title_list) 1)                    ;; ││└─────── 第 3 筆: 父系編號
                              (setq outtxt (strcat outtxt ";nil")))                ;; │└──────── 第 2 筆: 流水號
                         );progn                                                   ;; └───────── 第 1 筆: 0 ->沒資訊點(tree狀不顯示圖示
                         (progn                                                    ;;                               1 ->有資訊點(tree狀顯示圖示)
                              (setq outtxt nn)
                              (repeat (length title_list)
                                    (setq outtxt (strcat outtxt ";"))
                              );repeat
                         );progn
                    );if
                    (setq num (1+ num))
                    (write-line outtxt ff)
                    (princ ".")
               );progn
            );foreach
        );progn
     );if
     (close ff)
     (setq outf (open (strcat POWDESIGN_path "bom.out") "r"))
     (setq data (read-line outf))
     (close outf)
     (if (null data)(princ "\n無物料結構!")
       (progn
         (cond
          ((= 2 typ) (startapp (strcat  POWDESIGN_path "tree1.exe")))
          ((= 0 typ)
           (startapp (strcat  POWDESIGN_path "bom1.exe"))

              (setq cc(getstring "\n按任意鍵更新次組立名稱..."))
              (setq ff (open (strcat POWDESIGN_path "bomup.txt") "r"))
              (setq ffdata(read-line ff))
              (close ff)
              (if (/= "0" ffdata)(c:subassname_into_infopoint))
          )
          ((= 1 typ) (princ (strcat fname ".xls 建立完成 !")))
          (T (princ "\n結構資料重新產生完成!" ))
         );cond
       );progn
     );if
    );progn
    (progn
      (c:sortcol)
      (c:outbom_out)
    );progn
  );if
  (princ)
)



;;;建立 BMP (影像) 檔的圖形
;(defun c:creat_bmpf(/ flag p1 p2 yesno)
;   (setvar "cmdecho" 0)
;    (princ "\n請選擇要見建立 BMP (影像) 檔的圖形...")
;    (setq bmpdwg (ssget))
;   (setq p1 (getpoint "\n選擇畫面範圍第一點: ")
;         p2 (getcorner p1 "\n畫面範圍第二點: "))
;   (setq ffname (getstring (strcat "\n影像檔名:" (strcase des50_bmpdatabase_path))))
;   (if (findfile (strcat des50_bmpdatabase_path ffname ".bmp"))
;      (progn
;         (initget "Yes No")
;         (setq yesno (getkword (strcat "\n" des50_bmpdatabase_path fn ".bmp 已經存在, 是否覆蓋<No>: ")))
;         (if (or (= yesno "No")(= yesno nil))(setq yesno "No" fm nil)(setq yesno "Yes"))
;      );progn
;   );if
;   (if (= yesno "Yes")
;     (progn
;      (command "bmpout" (strcat  des50_bmpdatabase_path fn) bmpdwg "")
;      (princ (strcat "\n影像檔 " (strcase des50_bmpdatabase_path fn) "建立完成!"))
;     )
;     (princ "\n放棄建立 BMP (影像) 檔的圖形!")
;   )
;   (setvar "cmdecho" 1)
;   (princ)
;)

(defun c:on_bomlayer()(bomlayer_onoff 1))
(defun c:off_bomlayer()(bomlayer_onoff 0))
(defun bomlayer_onoff(typ)
  (setq haveno_bomp (tblsearch "BLOCK" "$$partref_bom"))
  (setq partref_grp (ssget "x" (list (cons 0 "INSERT") (cons 2 "partref"))))  ;;取所有資訊點
  (setq oldos (getvar "osmode"))
  (if (= typ 0)
    (progn
      (if (null partref_grp)
        (princ "\n圖面上並無物料資訊點!")
        (progn
          (if (/= nil haveno_bomp)
           (progn
             (setvar "osmode" 0)
             (command "block" "$$partref_bom" "y" "0,0,0" partref_grp "")
             (setvar "osmode" oldos)
           );progn
           (progn
             (setvar "osmode" 0)
             (command "block" "$$partref_bom" "0,0,0" partref_grp "")
             (setvar "osmode" oldos)
           );progn
          );if
        );progn
      );if
    );progn
    (progn
      (if (and (null partref_grp)(/= nil haveno_bomp))
        (progn
           (setvar "osmode" 0)
           (command "insert" "*$$partref_bom" "0,0,0" "1" "0")
           (setvar "osmode" oldos)
        );progn
        (princ "\n圖面上並無物料資訊點!")
      );if
    );progn
  );if
; (setq clay (getvar "clayer"))
; (if (= "$partref_bom" clay) (command "layer" "on" "0" "s" "0" ""))
; (if (= typ 0)
;   (progn
;     (command "layer" "f" "$partref_bom" "")
;     (princ "\n冷凍資訊點圖層!")
;   )
;   (progn
;     (command "layer" "t" "$partref_bom" "")
;     (princ "\n解凍資訊點圖層!")
;   )
; );if
; (princ)
)

;;╭════════════════════════════════════════════╮
;;║設計日期: 2000.8.30                                                                     ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 物料結構顯示欄位順序                                                          ║
;;║相關檔案:                                                                               ║
;;║相關副程式                                                                              ║
;;╰════════════════════════════════════════════╯

(defun c:sortcol(/ title_list noneedlist partdata titletxt_list txt needlist)
;(defun c:sortcol()
  (setq title_list '())
  (setq noneedlist '())
  (setq titlefile (findfile (strcat POWDESIGN_path "title.txt")))
  (if (null titlefile)
     (progn
       (setq partdata (read (getfile_val (strcat POWdesign_path "SYSTEM.ini") "零件定義資料")))
       (setq titletxt_list (cddr partdata) needlist (list "層名"))
       (foreach nn titletxt_list
         (progn
           (setq txt (nth 0 nn))
      ;    (if (= "#" (substr txt 1 1))(setq txt (substr txt 2)))
           (setq needlist (cons txt needlist))
         );progn
       );foreach
       (setq needlist (reverse needlist))
     );progn
     (progn
      (setq ff (open (strcat POWDESIGN_path "title.txt") "r"))
      (setq data (read-line ff))
      (setq data1 (read-line ff))
      (close ff)
      (setq needlist (TXT_TRAN_LIST data))
      (if (/= "" data1) (setq noneedlist (TXT_TRAN_LIST data1)))
      (princ)
     );progn
  );if

  (actdcl (strcat POWDESIGN_dcl_path "manapart") "sortcol")
  (action_tile "accept" "(done_dialog)")
  (mode_tile "up" 1)
  (mode_tile "down" 1)
  (mode_tile "out" 1)
  (mode_tile "in" 1)

  (mode_tile "default" 1)
  (action_tile "need" "(exe_needcol)")
  (action_tile "noneed" "(exe_noneedcol)")
  (action_tile "up" "(exe_up)")
  (action_tile "down" "(exe_down)")
  (action_tile "out" "(exe_out)")
  (action_tile "in" "(exe_in)")
  (setq default_list (list (nth 0 needlist) (nth 1 needlist)))
  (act_pop_list default_list "default")
  (setq needlist (cddr needlist))
  (act_pop_list needlist "need")
  (act_pop_list noneedlist "noneed")
  (action_tile "accept" "(sortcol_ok)")
  (action_tile "cancel" "(done_dialog)")
  (start_dialog)
)

(defun sortcol_ok(/ ff txt txt1 dbcol qf partdata)
   (setq partdata (read (getfile_val (strcat POWDESIGN_path "SYSTEM.ini") "零件定義資料")))
   (setq ff (open (strcat POWDESIGN_path "title.txt") "w"))
   (setq qf (open (strcat POWDESIGN_path "dwgdata.txt") "w"))
   (write-line "A_01;料號" qf)
   (setq needlist (append default_list needlist))
   (setq txt (car needlist))
   (setq needlist (cdr needlist))
   (foreach nn needlist
     (setq txt (strcat txt ";" nn))
     (setq dbcol (nth 3 (assoc nn partdata)))
     (if (/= "" dbcol)
       (progn
         (write-line (strcat dbcol ";" nn) qf)
       );progn
     );if
   );foreach
   (close qf)
   (write-line txt ff)
   (if (/= 0 (length noneedlist))
     (progn
       (setq noneedlist (reverse noneedlist))
       (setq notxt (car noneedlist))
       (setq noneedlist (cdr noneedlist))
       (foreach nn noneedlist
         (setq notxt (strcat notxt ";" nn))
       );foreach
       (write-line notxt ff)
     );progn
     (write-line "" ff)
   );if
   (close ff)
   (done_dialog)
)


(defun exe_up(/ need_id movetxt objtxt flist blist)
  (setq need_id (get_tile "need")
        movetxt (nth (- (atoi need_id) 1) needlist)
        objtxt (nth (atoi need_id) needlist))
  (setq flist (getfrontelist (- (atoi need_id) 1) needlist))
  (setq blist (getbacklist (atoi need_id) needlist))
  (setq blist (cons movetxt blist))
  (setq flist (reverse (cons objtxt (reverse flist))))
  (setq needlist (reverse flist))
  (foreach nn blist
    (progn
      (setq needlist (cons nn needlist))
    );progn
  )
  (setq needlist (reverse needlist))
  (act_pop_list needlist "need")
  (setq new_id (rtos (- (atoi need_id) 1) 2 0))
  (set_tile "need" new_id)
  (if (= "0" new_id)
    (progn
      (mode_tile "up" 1)
      (mode_tile "down" 0)
    );progn
  );if
  (princ)
);defun
(defun exe_down(/ need_id movetxt objtxt flist blist)
  (setq need_id (get_tile "need")
        movetxt (nth (+ (atoi need_id) 1) needlist)
        objtxt (nth (atoi need_id) needlist))
  (setq flist (getfrontelist (atoi need_id) needlist))
  (setq blist (getbacklist (+ (atoi need_id) 1) needlist))
  (setq blist (cons objtxt blist))
  (setq flist (reverse (cons movetxt (reverse flist))))
  (setq needlist (reverse flist))
  (foreach nn blist
    (progn
      (setq needlist (cons nn needlist))
    );progn
  )
  (setq needlist (reverse needlist))
; (princ needlist)
  (act_pop_list needlist "need")
  (setq new_id (rtos (+ (atoi need_id) 1) 2 0))
  (set_tile "need" new_id)
; (princ (1+ (atoi need_id)))
  (if (= (length needlist) (+ 2 (atoi need_id)))
    (progn
      (mode_tile "up" 0)
      (mode_tile "down" 1)
    );progn
  );if
  (princ)
);defun

(defun exe_needcol(/ need_id)
  (setq need_id (get_tile "need"))
  (cond
   ((= "0" need_id)
    (mode_tile "down" 0)
    (mode_tile "out" 0)
    (mode_tile "up" 1)
    (mode_tile "in" 1)
   )
   ((= (length needlist) (+ (atoi need_id) 1))
    (mode_tile "down" 1)
    (mode_tile "out" 0)
    (mode_tile "up" 0)
    (mode_tile "in" 1)
   )
   (T
    (mode_tile "down" 0)
    (mode_tile "out" 0)
    (mode_tile "up" 0)
    (mode_tile "in" 1)
   )
  )
  (princ)
);defun
(defun exe_out(/ abj need_id)
  (setq need_id (get_tile "need"))
  (setq abj (nth (atoi need_id) needlist))
  (setq needlist (removelist abj needlist))
  (act_pop_list needlist "need")
  (setq noneedlist (reverse (cons abj (reverse noneedlist))))
  (act_pop_list noneedlist "noneed")
  (princ)
);defun
(defun exe_noneedcol()
  (mode_tile "out" 1)
  (mode_tile "in" 0)
  (mode_tile "up" 1)
  (mode_tile "down" 1)
  (princ)
);defun
(defun exe_in(/ noneed_id abj)
  (setq noneed_id (get_tile "noneed"))
  (setq abj (nth (atoi noneed_id) noneedlist))
  (setq noneedlist (removelist abj noneedlist))
  (act_pop_list noneedlist "noneed")
  (setq needlist (reverse (cons abj (reverse needlist))))
  (act_pop_list needlist "need")
  (if (= 0 (length noneedlist))(mode_tile "in" 1))
  (princ)
);defun


;;╭════════════════════════════════════════════╮
;;║設計日期: 2000.8.15                                                                     ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 取圖框屬性自動建立資訊點                                                      ║
;;║相關檔案:                                                                               ║
;;║相關副程式                                                                              ║
;;╰════════════════════════════════════════════╯

;(defun c:addbomp_sheet(/ agrp attlist lname insp fg flag)
(defun c:addbomp_sheet(/ agrp attlist insp)
   (princ "\n框選圖框屬性...")
   (setq agrp (ssget))
   (if (/= nil agrp)
     (progn
       (setq attlist (get_sheetatt agrp))
       (if (null attlist) (princ "\n您選擇的圖元中並不存在圖框屬性!")
         (progn
            (setq lname (getstring "\n或按 Enter 鍵選擇圖元圖層/物料資訊點層名:"))
            (if (= "" lname)
              (progn
                 (setq ent (entsel "\n選擇任意圖元: "))
                 (while (null ent)
                   (setq ent (entsel "\n未選到圖元! 請再選一次! "))
                 );while
                 (progn
                    (setq lname (cdr (assoc 8 (entget (car ent)))))
                    (setq flag t)
                 );progn
              );progn
              (progn
                (setq fg (tblsearch "layer" (strcase lname)))
                (if (null fg)
                  (progn
                     (princ (strcat "\n" lname " 圖層並不存在! "))
                  );progn
                  (progn
                    (setq flag t)
                  );progn
                );if
              );progn
            );if
            (if flag
              (progn
                (if (ssget "x" (list (cons 0 "INSERT") (cons 2 "PARTREF")))
                  (progn
                     (princ "\n請注意: 若此圖為零件圖, 則物料資訊點只可存在一個!")
                     (initget "Yes No")
                     (setq yesno (getkword "\n本零件已存在物料資訊點,是否要再建立一次!<N>"))
                     (if (or (null yesno) (= "No" yesno))
                       (princ)
                       (progn
                            (setq oldlay (getvar "clayer"))
                            (command "layer" "s" lname "")
                            (setq blk_scal (* (atof sys_ballpoint_size) (getvar "dimscale")))
                            (command "insert" (strcat POWDESIGN_dwg_path "partref") sheet_insp blk_scal blk_scal "0" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "")
                            (addatt_tobomball (entlast) attlist)
                            (command "layer" "s" oldlay "")
                            (princ "\n物料資訊點位置...")
                            (command "move" (entlast) "" sheet_insp PAUSE)
                       );progn
                     );if
                  );progn
                  (progn
                     (setq oldlay (getvar "clayer"))
                     (command "layer" "s" lname "")
                     (setq blk_scal (* (atof sys_ballpoint_size) (getvar "dimscale")))
                     (command "insert" (strcat POWDESIGN_dwg_path "partref") sheet_insp blk_scal blk_scal "0" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "")
                     (addatt_tobomball (entlast) attlist)
                     (command "layer" "s" oldlay "")
                     (princ "\n物料資訊點位置...")
                     (command "move" (entlast) "" sheet_insp PAUSE)

                  );progn
                );if
              );progn
            );if
         );progn
       );if
     );progn
   );if
   (setq sheet_insp nil)
   (princ)
)

;; 過濾圖群中是否有圖框屬性,若有, 則自動建立資訊點
;; lname 層名
;; insp 資訊點插入點
;; agrp 要過濾之圖群
(defun pub_bom_sheet(agrp lname / attlist pp)
   (setq attlist nil)
   (setq attlist (get_sheetatt agrp))
   (if (null attlist) (princ)
     (progn
        (setq blk_scal (* (atof sys_ballpoint_size) (getvar "dimscale")))
      ; (setq pp (open (strcat powdesign_path "openfile.scr") "w"))
      ; (write-line "insert" pp)
      ; (write-line (strcat powerpdmbom_path "partref") pp)
      ; (write-line "0,0,0" pp)
      ; (write-line (rtos blk_scal 2 2) pp)
      ; (write-line (rtos blk_scal 2 2) pp)
      ; (write-line "0" pp)
      ; (write-line "insert" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (write-line "" pp)
      ; (close pp)
     ;  (command "script" (strcat powdesign_path "openfile"))
        (command "insert" (strcat POWDESIGN_dwg_path "partref") sheet_insp blk_scal blk_scal "0" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "")
        (addatt_tobomball (entlast) attlist)
     );progn
   );if
   (setq sheet_insp nil)
   attlist
);defun


(defun copytxtfile_pubsher(source_file target_file / str_ffdata fle_ff fle_gg)
       (setq fle_ff(open source_file "r"))
       (setq fle_gg(open target_file "w"))
       (setq str_ffdata(read-line fle_ff))
       (while str_ffdata
              (write-line str_ffdata fle_gg)
              (setq str_ffdata(read-line fle_ff))
       );while
       (close fle_ff)
       (close fle_gg)
);defun
;;╭════════════════════════════════════════════╮
;;║設計日期: 2000.8.15                                                                     ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 自動建立資訊點                                                                ║
;;║相關檔案: automakepart.dcl                                                              ║
;;║相關副程式 (makepart_ok)(show_grouplayer)(show_userdef)                                 ║
;;╰════════════════════════════════════════════╯
;;(setq nobomp_list (list "BORDER" "PROJ" "0" "DIM" "TEXT")) ;;定義不建立資訊點的圖層
;;(defun c:automakepart(/ automakepart_fg data1 data2 data3 data4 data5 data6 data7 data8 data9
;                                  data10 data11 data12 data13 data14 data15)
(defun c:automakepart(/ automakepart_fg ntlayer1 tlayer)
  (setvar "cmdecho" 0)

;;*  2013.05.15
;;*  (if POWERPDM_CAD_PATH
;;*      (progn
;;*           (if (findfile (strcat POWERPDM_CAD_PATH "bomtrans.txt"))
;;*               (progn
;;*                    (setq str_sfile (strcat powdesign_path "database.txt"))
;;*                    (setq str_tfile (strcat powdesign_path "~database.txt"))
;;*                    (copytxtfile_pubsher str_sfile str_tfile) ;備份原有之database.txt
;;*  
;;*                    (setq str_sfile (strcat POWERPDM_CAD_PATH "bomtrans.txt"))
;;*                    (setq str_tfile (strcat powdesign_path "database.txt"))
;;*                    (copytxtfile_pubsher str_sfile str_tfile) ;自網路上autocad目錄下複製 bomtrans.txt到單機designer6\database
;;*               );progn
;;*           );if
;;*      );progn
;;*  );if

  (actdcl (strcat POWDESIGN_dcl_path "manapart") "automakepart")
  (setq partdata (read (getfile_val (strcat POWDESIGN_path "SYSTEM.ini") "零件定義資料")))

  (setq datal '(""))
  (setq partdata (cddr partdata) count 3)
; (setq count 1)
  (set_tile "lab1" "件號前置文字")
  (set_tile "lab2" "起始件號")
  (foreach nn partdata
    (progn
      (setq datal (cons (nth 0 nn) datal))
      (set_tile (strcat "lab" (rtos count 2 0)) (nth 0 nn))
      (setq count (1+ count))
    );progn
  );foreach
  (if (< count 15)
    (progn
      (repeat (- 16 count)
        (mode_tile (strcat "data" (rtos count 2 0)) 1)
        (setq count (1+ count))
      );repeat
    );progn
  );if

  (set_tile "error" "正在建立資訊點的圖層資料! 請稍後......")
  (set_tile "mess2" "過濾搜尋以下條件:1.該圖層沒圖元存在  2.該圖層沒有資訊點  3.該圖層不屬於不建立資訊點的圖層")
  (setq ballgrp (ssget "x" (list (cons 0 "INSERT")(cons 2 "PARTREF"))))
   (setq tlayer (coll_layer) ntlayer '() nolayer '() count 1)
   ;;假如 1.該圖層沒有資訊點 2.該圖層沒圖元存在 3.該圖層不屬於不建立資訊點的層
   (nobomp_listp)   ;;2003.08.09 SAM 原來在 Foreach 迴圈內
   (foreach nn tlayer
     (progn
       (setq bomp (findbomp_ent (strcase nn)))

       (if (/= bomp nil) (setq bomp_list (cons bmop bomp_list)))

       (set_tile "error" (strcat "過濾搜尋" nn "的圖層資料..."))
       (set_tile "mess" (strcat (rtos count 2 0) "/" (rtos (length tlayer) 2 0)))
       (setq la (ssget "x" (list (cons 8 nn))))   ;找尋該圖層是否有圖元存在

       (if (and (null bomp)(/= nil la)(null (member nn nobomp_list)))
         (progn
           (setq ntlayer (cons nn ntlayer))
           (act_pop_list ntlayer "yeslayers")
         );progn
       );if
       (setq count (1+ count))
    );progn
  );foreach
  (mode_tile "yes" 1)
  (mode_tile "no" 1)
  (action_tile "yeslayers" "(mode_tile \"no\" 0)(mode_tile \"yes\" 1)")
  (action_tile "nolayer" "(mode_tile \"no\" 1)(mode_tile \"yes\" 0)")

  (action_tile "yes" "(automakepart_yesla)")
  (action_tile "no" "(automakepart_nola)")

  (setq ntlayer (reverse ntlayer))
  (setq datal (reverse datal))
  (set_tile "error" "")
  (set_tile "mess" "")
  (set_tile "mess2" (strcat "排除非零件的圖層與已建立資訊點的零件後,共有" (rtos (length ntlayer) 2 0) "個零件圖層需建立資訊點!"))
  (mode_tile "yes" 1)
  (mode_tile "no" 1)
  (action_tile "yeslayers" "(mode_tile \"no\" 0)(mode_tile \"yes\" 1)")
  (action_tile "nolayer" "(mode_tile \"no\" 1)(mode_tile \"yes\" 0)")

  (action_tile "yes" "(automakepart_yesla)")
  (action_tile "no" "(automakepart_nola)")

  (act_pop_list ntlayer "yeslayers")
  (set_tile "error" "")
  (act_pop_list datal "col")
  (if (null ntlayer)
   (progn
     (done_dialog)
     (actdcl (strcat POWDESIGN_path "pub-dcl") "allert")
     (set_tile "ms_allert" "所有零件資訊點已建立完成!")
     (action_tile "accept" "(done_dialog)")
     (start_dialog)

   );progn
  )

   (action_tile "data3" "(setq lib_id 3)")
   (action_tile "data4" "(setq lib_id 4)")
   (action_tile "data5" "(setq lib_id 5)")
   (action_tile "data6" "(setq lib_id 6)")
   (action_tile "data7" "(setq lib_id 7)")
   (action_tile "data8" "(setq lib_id 8)")
   (action_tile "data9" "(setq lib_id 9)")
   (action_tile "data10" "(setq lib_id 10)")
   (action_tile "data11" "(setq lib_id 11)")
   (action_tile "data12" "(setq lib_id 12)")
   (action_tile "data13" "(setq lib_id 13)")
   (action_tile "data14" "(setq lib_id 14)")
   (action_tile "data15" "(setq lib_id 15)")

  (action_tile "lib" "(makepart_useword)")

  (action_tile "accept" "(automakepart_ok)")
  (action_tile "cancel" "(done_dialog)(setq automakepart_fg nil)")
  (start_dialog)
  (if automakepart_fg (autocreat_bomp));if
  (princ)
);defun


(defun automakepart_ok()
;  (setq ftxt (get_tile "ftxt"))
;  (setq sno (get_tile "sno"))
   (setq qdata1 "")
   (setq qdata2 "")
   (setq qdata3 (get_tile "data3"))
   (setq qdata4 (get_tile "data4"))
   (setq qdata5 (get_tile "data5"))
   (setq qdata6 (get_tile "data6"))
   (setq qdata7 (get_tile "data7"))
   (setq qdata8 (get_tile "data8"))
   (setq qdata9 (get_tile "data9"))
   (setq qdata10(get_tile "data10"))
   (setq qdata11(get_tile "data11"))
   (setq qdata12 (get_tile "data12"))
   (setq qdata13 (get_tile "data13"))
   (setq qdata14 (get_tile "data14"))
   (setq qdata15 (get_tile "data15"))
   (if (= "*" qdata1) (setq qdata1_fg t))
   (if (= "*" qdata2) (setq qdata2_fg t))
   (if (= "*" qdata3) (setq qdata3_fg t))
   (if (= "*" qdata4) (setq qdata4_fg t))
   (if (= "*" qdata5) (setq qdata5_fg t))
   (if (= "*" qdata6) (setq qdata6_fg t))
   (if (= "*" qdata7) (setq qdata7_fg t))
   (if (= "*" qdata8) (setq qdata8_fg t))
   (if (= "*" qdata9) (setq qdata9_fg t))
   (if (= "*" qdata10) (setq qdata10_fg t))
   (if (= "*" qdata11) (setq qdata11_fg t))
   (if (= "*" qdata12) (setq qdata12_fg t))
   (if (= "*" qdata13) (setq qdata13_fg t))
   (if (= "*" qdata14) (setq qdata14_fg t))
   (if (= "*" qdata15) (setq qdata15_fg t))
;  (if (= "" sno)
;    (progn
;       (setq noautono nil)
;       (actdcl (strcat POWDESIGN_path "pub-dcl") "allert2")
;       (set_tile "allert1" "未輸入起始件號,將無法自動建立件號!")
;       (set_tile "allert2" "您確定不要法自動建立件號?")
;       (action_tile "accept" "(done_dialog)(setq noautono t)")
;       (action_tile "cancel" " (done_dialog)")
;       (start_dialog)
;       (if noautono
;        (progn
;          (setq automakepart_fg t)
;          (done_dialog)
;        );progn
;      );if
;    );progn
;    (progn
       (setq automakepart_fg t)
       (done_dialog)
;    );progn
;  );if
)

;(defun autocreat_bomp(/ qdata1 qdata2 qdata3 qdata4 qdata5 qdata6 qdata7 qdata8 qdata9 qdata10 qdata11 qdata12 qdata13
;                         qdata14 qdata15 ff data data database_list count idd)
(defun autocreat_bomp()
  (setq oldos (getvar "osmode"))
  (setvar "osmode" 0)
  (setq count 1)
;; 建立資料索引檔..

   ;;* 2013.05.15
   (setq database_list (campro_getbom_data ntlayer))
   (setq taglist (get_taglist (nth 0 database_list)))
   (setq database_assoc_list '())
   (princ "\n建立資料索引檔..")
   (foreach data database_list (progn
       (setq idd (get_word data ";"))
       (setq ttxt (strcase (substr data 1 (- idd 1))))
       (setq database_assoc_list (cons (list ttxt data) database_assoc_list))
       (princ ".")
   ))
   (princ "\n資料索引檔建立完成!")
   ;;* 2013.05.15
   ;;*(setq ff (open (strcat POWDESIGN_path "database.txt") "r"))
   ;;*(setq data (read-line ff))          ;;data -> 料號;TAG3;TAG9;TAG10
   ;;*(setq taglist (get_taglist data))   ;;taglist ("TAG3" "TAG9" "TAG10")

   ;;*(setq database_assoc_list '())
   ;;*(princ "\n建立資料索引檔..")
   ;;*(while data
   ;;*   (setq database_list (cons data database_list))    ;;database_list  是物料資料庫的所有資料總集
   ;;*   (setq idd (get_word data ";"))
   ;;*   (setq ttxt (strcase (substr data 1 (- idd 1))))
   ;;*   (setq database_assoc_list (cons (list ttxt data) database_assoc_list))
   ;;*   ;;(setq etxt (substr data (1+ (get_word data ";"))))
   ;;*   (princ ".")
   ;;*   (setq data (read-line ff))
   ;;*);while
   ;;*(close ff)
   ;;*(princ "\n資料索引檔建立完成!")

   (if (= (setq wucs (getvar "worlducs")) 0)
       (progn
            (setq ucsorg (getvar "ucsorg"))
            (command "ucs" "w")
      );progn
   );if  

;  (if (/= "" sno) (setq sno (atoi sno)) (setq sno 0))
  (foreach nn ntlayer
    (progn
     (princ (strcat "\n" (rtos count 2 0) "/" (rtos (length ntlayer) 2 0)  " 建立" nn "資訊點.."))

;    (if qdata1_fg (setq data1 nn))
;    (if qdata2_fg (setq data2 nn))
;    (if (/= 0 sno) (setq qdata1 (strcat ftxt (rtos sno 2 0)))
;                          (setq qdata1 ""))
     (setq qdata1 "")
     (setq qdata2 "")

     (if qdata3_fg (setq qdata3 nn))
     (if qdata4_fg (setq qdata4 nn))
     (if qdata5_fg (setq qdata5 nn))
     (if qdata6_fg (setq qdata6 nn))
     (if qdata7_fg (setq qdata7 nn))
     (if qdata8_fg (setq qdata8 nn))
     (if qdata9_fg (setq qdata9 nn))
     (if qdata10_fg (setq qdata10 nn))
     (if qdata11_fg (setq qdata11 nn))
     (if qdata12_fg (setq qdata12 nn))
     (if qdata13_fg (setq qdata13 nn))
     (if qdata14_fg (setq qdata14 nn))
     (if qdata15_fg (setq qdata15 nn))

     (setq attdata_list (list (list "TAG1" qdata1) (list "TAG2" qdata2) (list "TAG3" qdata3)
                              (list "TAG4" qdata4) (list "TAG5" qdata5) (list "TAG6" qdata6)
                              (list "TAG7" qdata7) (list "TAG8" qdata8) (list "TAG9" qdata9)
                              (list "TAG10" qdata10) (list "TAG11" qdata11) (list "TAG12" qdata12)
                              (list "TAG13" qdata13) (list "TAG14" qdata14) (list "TAG15" qdata15)))
     (setq curlayer (getvar "clayer"))
     (setq curcolor (getvar "cecolor"))
     (setq curltype (getvar "celtype"))
     (princ ".")
     (command "layer" "s" nn "")
     (setq oldattdia (getvar "attdia"))
     (setvar "attdia" 0)
     (princ ".")

     (setq attdata_list (get_database&subst nn attdata_list)) ;;;與物料資料庫連結

     (setq insp (cdr (assoc 10 (entget (ssname (ssget "x" (LIST (cons 8 (strcase nn)))) 0)))))
     (setq blk_scal (* (atof sys_ballpoint_size) (getvar "dimscale")))
     (command "insert" (strcat powdesign_dwg_path "partref") insp blk_scal blk_scal "0" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "")
     (princ ".")
;;ent: 資訊點圖元名稱   dlist: 16筆屬性串列 (("TAG1" "aaa") ("TAG2" "bbb") ("TAG3" "ccc")....("LAYER" "ddd"))
     (ad1xdata (entlast) (strcase nn) (list (strcase nn) (cons 1000 nn)))
     (addatt_tobomball (entlast) attdata_list)
     (princ ".")
     (princ "資訊點建立完成!")
     (setvar "attdia" oldattdia)
     (command "color" curcolor)
     (command "linetype" "s" curltyle "")
     (command "layer" "s" curlayer "")
;    (if (/= 0 sno) (setq sno (1+ sno)))
     (setq count (1+ count))
    );progn
  );foreach

  (if (= wucs 0)
      (command "ucs" "n" ucsorg)
  );if

  (command "regen")
  (setvar "osmode" oldos)
  (princ (strcat "\n共建立" (rtos (length ntlayer) 2 0) "筆資訊點資料!" ))
  (setq database_list nil)
  (princ)
);defun
;---------------------2003.06.13 SAM----------------------
(defun automakepart_nola()
  (setq str_ssel (get_tile "yeslayers"))
  (setq lst_id (mulitsel_tolist str_ssel))
  (setq i 0)
  (setq lst_ntlayer ntlayer)
  (setq nolayer (reverse nolayer))
  (repeat (length lst_id)
          (setq no_id (atoi (nth i lst_id)))
          (setq id_data (nth no_id lst_ntlayer))
          (setq ntlayer (removelist id_data ntlayer))
          (setq nolayer (cons id_data nolayer))
          (setq i (1+ i))
  )
  (setq nolayer (reverse nolayer))
  (act_pop_list ntlayer "yeslayers")
  (act_pop_list nolayer "nolayer")
)
(defun automakepart_yesla()
  (setq str_ssel (get_tile "nolayer"))
  (setq lst_id (mulitsel_tolist str_ssel))
  (setq i 0)
  (setq lst_nolayer nolayer)
  (setq ntlayer (reverse ntlayer))
  (repeat (length lst_id)
          (setq no_id (atoi (nth i lst_id)))
          (setq id_data (nth no_id lst_nolayer))
          (setq nolayer (removelist id_data nolayer))
          (setq ntlayer (cons id_data ntlayer))
          (setq i (1+ i))
  )
  (setq ntlayer (reverse ntlayer))
  (act_pop_list ntlayer "yeslayers")
  (act_pop_list nolayer "nolayer")
)
 ;;; "1 2 3 5 6" --> ("1" "2" "3" "5" "6")
(defun mulitsel_tolist (str_select / int_n1 int_n2 str_item lst_item)
  (while (/= 0 (strlen str_select))
     (setq str_item (itoa (read str_select)))
     (setq lst_item (cons str_item lst_item))
     (setq int_n1 (strlen str_select))
     (setq int_n2 (strlen str_item))
     (setq str_select (substr str_select (+ int_n2 2) (- int_n1 (+ int_n2 1))))
  )
  (setq lst_item (reverse lst_item))
  lst_item
)
;---------------------2003.06.13 SAM----------------------

;;╭════════════════════════════════════════════╮
;;║設計日期: 2000.8.15                                                                     ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 製作零件圖層                                                                  ║
;;║相關檔案: manapart.dcl                                                                  ║
;;║相關副程式 (makepart_ok)(show_grouplayer)(show_userdef)                                 ║
;;╰════════════════════════════════════════════╯
(defun c:makepart()(makepart 1))

;;組合圖中建立資訊點
;;╭════════════════════════════════════════════╮
;;║設計日期: 2000.8.15                                                                     ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 建立零件資訊點                                                                ║
;;║相關檔案: manapart.dcl                                                                  ║
;;║相關副程式 (makepart_ok)(show_grouplayer)(show_userdef)                                 ║
;;╰════════════════════════════════════════════╯
(defun c:addbomp(/ datatxt_list ent)
  (setq ent (entsel "\n建立零件資訊點,請先選擇要建立資訊點的圖元: "))
  (setq ent_obj (car ent));;給假資訊點用來取圖層顏色用
  (if ent
    (makepart 0)
  );if
  (setq ent nil)
)
;;零件圖中建立資訊點
(defun c:addbom_olddwg(/ datatxt_list ent)
  (if (null (ssget "x" (list (cons 0 "INSERT") (cons 2 "PARTREF"))))
    (progn
;     (setq txtdatalist (gettxt_grp))
 ;    (if txtdatalist (makepart 2))
      (makepart 2)
    );progn
    (princ "\n資訊點已經存在!")
  );if
  (setq ent nil)
  (princ)
)

;;typ=1 ;建立新圖層與資訊點
;;typ=0 ;圖層已存在,只建立資訊點
;;typ=2 ;取出零件圖中之文字層資訊點
(defun makepart(typ / lib_id bomttt makepart_fg txtdatalist)

  (setvar "cmdecho" 0)
  (if (= typ 2) (setq txtdatalist (gettxt_grp)))
  (actdcl (strcat POWDESIGN_DCL_path "manapart") "makeparts")
  (show_userdef)
; (if (and (= typ 2)(/= nil txtdatalist))
  (if (= typ 2)
   (progn
    (if (null txtdatalist)(set_tile "error" "未選到任何文字!"))
    (act_pop_list txtdatalist "partgroup")
    (set_tile "lab" "過濾出的文字(可直接點選應用在編輯框內)")
    (set_tile "layer" "0")
    (set_tile "col" "7")
    (mode_tile "col" 1)
    (mode_tile "selcol" 1)
   );progn
   (progn
    (set_tile "lab" "零件圖層名稱:零件名稱")
    (setq bom_list (collect_partref_data))
    (if (/= nil bom_list)
    (act_pop_list bom_list "partgroup"))
   );progn
  );if
  (cond
    ((= typ 0)
      (set_tile "label" "建立零件資訊點資料")
      (setq creatlayer_name (cdr (assoc 8 (entget (car ent)))))
      (if (null (findbomp_ent creatlayer_name))
        (progn
          (setq layercol (cdr (assoc 62 (tblsearch "layer" creatlayer_name))))
          (set_tile "layer" creatlayer_name)
          (set_tile "col" (rtos layercol 2 0))
          (set_tile "layer" creatlayer_name)
          (set_tile "data3" creatlayer_name)
          (mode_tile "layer" 1)
          (mode_tile "col" 1)
        );progn
        (progn
          (done_dialog)
          (setq flag_btn (show_error_ms))
          (if (= 1 flag_btn)(add_false_bomp ent_obj));;新增假資訊點,數量欄位加一
          (princ)
        );progn
      );if
    )
    ((= typ 1) (set_tile "label" "建立新零件"))
  );if
   (action_tile "partgroup" "(if (= typ 2)(seltxt_toeditbox txtdatalist))")
   (if (/= 2 typ) (setq lib_id 16)(setq lib_id nil))
   (action_tile "selcol" "(setq lib_id 1)(ml_ddsel_col \"col\")")
   (action_tile "layer" "(setq lib_id 16)")
   (action_tile "col" "(setq lib_id 17)")
   (action_tile "data1" "(setq lib_id 1)")
   (action_tile "data2" "(setq lib_id 2)")
   (action_tile "data3" "(setq lib_id 3)")
   (action_tile "data4" "(setq lib_id 4)")
   (action_tile "data5" "(setq lib_id 5)")
   (action_tile "data6" "(setq lib_id 6)")
   (action_tile "data7" "(setq lib_id 7)")
   (action_tile "data8" "(setq lib_id 8)")
   (action_tile "data9" "(setq lib_id 9)")
   (action_tile "data10" "(setq lib_id 10)")
   (action_tile "data11" "(setq lib_id 11)")
   (action_tile "data12" "(setq lib_id 12)")
   (action_tile "data13" "(setq lib_id 13)")
   (action_tile "data14" "(setq lib_id 14)")
   (action_tile "data15" "(setq lib_id 15)")

  (action_tile "lib" "(makepart_useword)")

  (action_tile "accept" "(makepart_ok)")
  (action_tile "cancel" "(done_dialog)(setq makepart_fg nil)")
  (start_dialog)

 (if makepart_fg
   (progn
     (setq curlayer (getvar "clayer"))
     (setq curcolor (getvar "cecolor"))
     (setq curltype (getvar "celtype"))

     (command "layer" "m" player "c" col player "")
     (setq oldattdia (getvar "attdia"))
     (setvar "attdia" 0)
     (setq insp (getpoint "\n選擇資訊點放置位置:"))
     (if (null insp) (setq insp "0,0,0"))
     (setq blk_scal (* (atof sys_ballpoint_size) (getvar "dimscale")))
     (command "insert" (strcat POWDESIGN_DWG_path "partref") insp blk_scal blk_scal "0" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "")
     (ad1xdata (entlast) (strcase player) (list (strcase player) (cons 1000 player)))
     (setvar "attdia" oldattdia)
     (addatt_tobomball (entlast) attdata_list)
     (command "regen")
     (command "color" curcolor)
     (command "linetype" "s" curltyle "")
     (command "layer" "s" curlayer "")
   ; (cond
   ;   ((= typ 1)(command "script" (strcat powdesign_path "movebomp")))
   ;   ((= typ 0)(command "move" (entlast) "") (c:addbomp))
   ;   ((= 2 typ)(princ))
   ; )
   );progn
 )
  (princ)
);defun
(defun add_false_bomp(ent_obj / int_num)
        (setq #part_field_number "TAG7");;資訊點的TAG7定義為數量;;SAM 2003.12.16
        (setq curlayer (getvar "clayer"))
        (setq curcolor (getvar "cecolor"))
        (setq curltype (getvar "celtype"))
        (setq player (cdr (assoc 8  (entget ent_obj))))
        (setq col    (cdr (assoc 62 (tblsearch "LAYER" player))))
        (command "layer" "m" player "c" col player "")
        (setq insp (getpoint "\n選擇資訊點放置位置:"))
        (if (null insp) (setq insp "0,0,0"))
        (setq blk_scal (* (atof sys_ballpoint_size) (getvar "dimscale")))
        (command "insert" (strcat powdesign_dwg_path "partdef") insp blk_scal blk_scal "0")
        ;;(ad1xdata (entlast) (strcase player) (list (strcase player) (cons 1000 player)))
        (setq set_partdef (ssget "x" (list (cons 8 player)(cons 2 "partdef"))))
        (setq set_partref (ssget "x" (list (cons 8 player)(cons 2 "partref"))))
        (if (and set_partref set_partdef)(progn
            (setq int_num (+ 1 (sslength set_partdef)))
            (setq attdata_list (subst (list #part_field_number (itoa int_num))
                               (assoc #part_field_number attdata_list) attdata_list))
        ))
        (addatt_tobomball (ssname set_partref 0) attdata_list)
        (command "regen")
        (command "color" curcolor)
        (command "linetype" "s" curltyle "")
        (command "layer" "s" curlayer "")
)
(defun seltxt_toeditbox(txtlist)
   (if (null lib_id) (set_tile "error" "您未指定放文字的編輯框,請先指定!")
     (progn
       (setq txt_id (get_tile "partgroup"))
       (setq txt (nth (atoi txt_id) txtlist))
       (cond
        ((= lib_id 1)   (set_tile "data1" txt))
        ((= lib_id 2)   (set_tile "data2" txt))
        ((= lib_id 3)   (set_tile "data3" txt))
        ((= lib_id 4)   (set_tile "data4" txt))
        ((= lib_id 5)   (set_tile "data5" txt))
        ((= lib_id 6)   (set_tile "data6" txt))
        ((= lib_id 7)   (set_tile "data7" txt))
        ((= lib_id 8)   (set_tile "data8" txt))
        ((= lib_id 9)   (set_tile "data9" txt))
        ((= lib_id 10)  (set_tile "data10" txt))
        ((= lib_id 11)  (set_tile "data11" txt))
        ((= lib_id 12)  (set_tile "data12" txt))
        ((= lib_id 13)  (set_tile "data13" txt))
        ((= lib_id 14)  (set_tile "data14" txt))
        ((= lib_id 15)  (set_tile "data15" txt))
       )
     );progn
   );if
)


(defun show_error_ms(/ int_dnum int_rnum set_partdef set_partref flag_btn)
  (if ent_obj (progn
        (setq player (cdr (assoc 8  (entget ent_obj))))
        (setq set_partdef (ssget "x" (list (cons 8 player)(cons 2 "partdef"))))
        (setq set_partref (ssget "x" (list (cons 8 player)(cons 2 "partref")(list -3 (list player)))))
  ))
        (if set_partdef (setq int_dnum (sslength set_partdef))
                        (setq int_dnum 0))
        (if set_partref (setq int_rnum (sslength set_partref))
                        (setq int_rnum 0))
  
  (actdcl (strcat POWDESIGN_path "manapart") "part_alert")
  (set_tile "ms_allert" (strcat (itoa (+ int_dnum int_rnum)) "個零件資訊點已存在!  是否在建立資訊點?"))

  (action_tile "accept" "(setq flag_btn 1)(done_dialog)")
  (action_tile "cancel" "(setq flag_btn 0)(done_dialog)")
  (start_dialog)
  flag_btn
)

(defun makepart_useword(/ libtxt)
  (if (null useword) (load "wordlib1"))
  (setq libtxt  (useword 1 1))
  (if (/= nil libtxt)
    (progn
      (cond
        ((= lib_id 1)   (set_tile "data1" libtxt))
        ((= lib_id 2)   (set_tile "data2" libtxt))
        ((= lib_id 3)   (set_tile "data3" libtxt))
        ((= lib_id 4)   (set_tile "data4" libtxt))
        ((= lib_id 5)   (set_tile "data5" libtxt))
        ((= lib_id 6)   (set_tile "data6" libtxt))
        ((= lib_id 7)   (set_tile "data7" libtxt))
        ((= lib_id 8)   (set_tile "data8" libtxt))
        ((= lib_id 9)   (set_tile "data9" libtxt))
        ((= lib_id 10)  (set_tile "data10" libtxt))
        ((= lib_id 11)  (set_tile "data11" libtxt))
        ((= lib_id 12)  (set_tile "data12" libtxt))
        ((= lib_id 13)  (set_tile "data13" libtxt))
        ((= lib_id 14)  (set_tile "data14" libtxt))
        ((= lib_id 15)  (set_tile "data15" libtxt))
        ((= lib_id 16)  (set_tile "layer" libtxt))
        ((= lib_id 17)  (set_tile "col" libtxt))
      )
      (setq lib_id nil)
    );progn
  )
  (setvar "cmdecho" 0)
);defun

(defun show_userdef()
  (setq part_defdatalist (read (getfile_val (strcat POWDESIGN_path "SYSTEM.ini") "零件定義資料")))
  (setq nlist '())
  (foreach mm part_defdatalist
    (progn
      (setq nlist (cons (nth 0 mm) nlist))
    );progn
  );foreach
  (setq part_defdatalist (reverse nlist) nlist nil)
  (setq count 1)
  (repeat (length part_defdatalist)
     (if (= 3 count)
      (set_tile (strcat "lab" (rtos count 2 0)) (strcat "＊" (nth (- count 1) part_defdatalist)))
      (set_tile (strcat "lab" (rtos count 2 0)) (nth (- count 1) part_defdatalist))
     )
     (setq count (1+ count))
  )
  (repeat (- 15 (length part_defdatalist))
    (mode_tile (strcat "data" (rtos count 2 0)) 1)
    (setq count (1+ count))
  )
)


(defun makepart_ok()
   (set_tile "error" "")
   (setq player (txt_tran (get_tile "layer")))
   (setq col (get_tile "col"))
   (setq data1 (txt_tran (get_tile "data1")))
   (setq data2 (get_tile "data2"))
   (setq data3 (get_tile "data3"))
   (setq data4 (get_tile "data4"))
   (setq data5 (get_tile "data5"))
   (setq data6 (get_tile "data6"))
   (setq data7 (get_tile "data7"))
   (setq data8 (get_tile "data8"))
   (setq data9 (get_tile "data9"))
   (setq data10 (get_tile "data10"))
   (setq data11 (get_tile "data11"))
   (setq data12 (get_tile "data12"))
   (setq data13 (get_tile "data13"))
   (setq data14 (get_tile "data14"))
   (setq data15 (get_tile "data15"))
   ;----------2003.06.12 SAM 加入(if (= "*" data?)...)-------------------------------------
   (if (/= "" data2)(setq data2 (txt_tran data2)))(if (= "*" data2)(setq data2 player))
   (if (/= "" data3)(setq data3 (txt_tran data3)))(if (= "*" data3)(setq data3 player))         
   (if (/= "" data4)(setq data4 (txt_tran data4)))(if (= "*" data4)(setq data4 player)) 
   (if (/= "" data5)(setq data5 (txt_tran data5)))(if (= "*" data5)(setq data5 player)) 
   (if (/= "" data6)(setq data6 (txt_tran data6)))(if (= "*" data6)(setq data6 player)) 
   (if (/= "" data7)(setq data7 (txt_tran data7)))(if (= "*" data7)(setq data7 player)) 
   (if (/= "" data8)(setq data8 (txt_tran data8)))(if (= "*" data8)(setq data8 player))
   (if (/= "" data9)(setq data9 (txt_tran data9)))(if (= "*" data9)(setq data9 player))         
   (if (/= "" data10)(setq data10 (txt_tran data10)))(if (= "*" data10)(setq data10 player))
   (if (/= "" data11)(setq data11 (txt_tran data11)))(if (= "*" data11)(setq data11 player))
   (if (/= "" data12)(setq data12 (txt_tran data12)))(if (= "*" data12)(setq data12 player))
   (if (/= "" data13)(setq data13 (txt_tran data13)))(if (= "*" data13)(setq data13 player))
   (if (/= "" data14)(setq data14 (txt_tran data14)))(if (= "*" data14)(setq data14 player))
   (if (/= "" data15)(setq data15 (txt_tran data15)))(if (= "*" data15)(setq data15 player))
   ;----------------------------------------------------------------------------------------

   (cond
     ((= "" player) (set_tile "error" "未輸入零件圖層名稱"))
     ((= "" data3) (set_tile "error" (strcat "未輸入"  (nth 2 part_defdatalist) "!" )))
     ((= "" col) (set_tile "error" "未輸入零件圖層顏色"))
     ((and (= typ 1)(/= (setq search (tblsearch "layer" player)) nil))
       (set_tile "error" "零件圖層名稱重覆! 請輸入其它名稱 !"))
     (T (setq makepart_fg t)
        (setq attdata_list (list (list "TAG1" data1) (list "TAG2" data2) (list "TAG3" data3)
                                 (list "TAG4" data4) (list "TAG5" data5) (list "TAG6" data6)
                                 (list "TAG7" data7) (list "TAG8" data8) (list "TAG9" data9)
                                 (list "TAG10" data10) (list "TAG11" data11) (list "TAG12" data12)
                                 (list "TAG13" data13) (list "TAG14" data14) (list "TAG15" data15)))
   ;    (command "layer" "m" player "c" col player "")
        (done_dialog))
   );cond
)



;;移動資訊點
;;╭════════════════════════════════════════════╮
;;║設計日期: 2000.8.15                                                                     ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 移動資訊點                                                                    ║
;;║相關檔案:
;;║相關副程式
;;╰════════════════════════════════════════════╯
(defun c:move_bomp()(move_bomp 1))    ;選擇要移動資訊點的圖元
(defun c:move_bomp2()(move_bomp 0))    ;輸入層名
(defun move_bomp(typ / ent check_ent  entlayer_name partref_group count ee data lname pname insp)
  (setvar "cmdecho" 0)
  (setq ent (entsel "\n按 Enter 鍵輸入要移動資訊點的層名/<選擇要移動資訊點的圖元>: "))
   (if (null ent)
     (progn
      (setq lname (getstring "\n輸入要移動資訊點的層名: "))
      (setq ent (findbomp_ent (strcase lname)))
     );progn
   );if
  (if (/= nil ent)
    (progn
      (setq check_ent t)
      (if (null lname)
        (setq entlayer_name (cdr (assoc 8 (entget (car ent)))))
        (setq entlayer_name (strcase lname))
      )
      (setq ee (findbomp_ent entlayer_name))

      (if (null ee) (princ "\n本零件並未建立資訊點圖形!")
        (progn
              (setq data (entget ee))
              (setq pname (cdr (assoc 1 (getatt ee 2 "TAG3"))))
              (setq insp (cdr (assoc 10 (entget ee))))
              (setq check_ent nil)
              (princ (strcat "\n[ " pname " ]的資訊點要移動到何處?"))
              (command "move" ee "" insp)
        );progn
      );if
    );progn
  );if
  (setvar "cmdecho" 1)
  (princ)
);defun

;;編輯資訊點
;;╭════════════════════════════════════════════╮
;;║設計日期: 2000.8.15                                                                     ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 編輯資訊點                                                                    ║
;;║相關檔案:
;;║相關副程式
;;╰════════════════════════════════════════════╯
(defun c:edit_bomp(/ edit_bompflg ee txtent)
  (setq ent (entsel "\n選擇圖元或資訊點>:"))
  (setq txtent nil)
  (if ent
    (progn
      (setq entdata (entget (car ent))
            data0 (cdr (assoc 0 entdata))
            data8 (cdr (assoc 8 entdata))
            data2 (cdr (assoc 2 entdata)))
      (actdcl (strcat POWDESIGN_DCL_path "manapart") "bomdata")
              (cond
                   ((and (= data0 "LINE") (= data8 sys_ball_layer) (getxdata (car ent) "layer"))
                         (setq data8 (cdr(car(cdr(car(cdr (assoc -3 (getxdata (car ent) "layer"))))))))
                         (setq txtgrp (ssget "x" (list (cons 0 "TEXT")(cons 8 sys_ball_layer)(list -3 (list data8)))))
                         (if txtgrp (setq txtent (ssname txtgrp 0)))
                         (setq ee (findbomp_ent data8))
                         (if (/= nil ee) (get_bomdata&show_data ee))
                   )
                   ((and (= data0 "CIRCLE") (= data8 sys_ball_layer) (getxdata (car ent) "layer"))
                         (setq data8 (cdr(car(cdr(car(cdr (assoc -3 (getxdata (car ent) "layer"))))))))
                         (setq txtgrp (ssget "x" (list (cons 0 "TEXT")(cons 8 sys_ball_layer)(list -3 (list data8)))))
                         (if txtgrp (setq txtent (ssname txtgrp 0)))
                         (setq ee (findbomp_ent data8))
                         (if (/= nil ee) (get_bomdata&show_data ee))
                   )
                   ((and (= data0 "TEXT") (= data8 sys_ball_layer) (getxdata (car ent) "layer"))
                         (setq data8 (cdr(car(cdr(car(cdr (assoc -3 (getxdata (car ent) "layer"))))))))
                         (setq txtent (car ent))
                         (setq ee (findbomp_ent data8))
                         (if (/= nil ee) (get_bomdata&show_data ee))
                   )
                   ((and (= data0 "INSERT")(= data2 "PARTREF"))
                         (setq txtgrp (ssget "x" (list (cons 0 "TEXT")(cons 8 sys_ball_layer)(list -3 (list data8)))))
                         (if txtgrp (setq txtent (ssname txtgrp 0)))
                         (get_bomdata&show_data (car ent))
                         (setq ee t)
                   )
                   (t
                         (setq txtgrp (ssget "x" (list (cons 0 "TEXT")(cons 8 sys_ball_layer)(list -3 (list data8)))))
                         (if txtgrp (setq txtent (ssname txtgrp 0)))
                         (setq ee (findbomp_ent data8))
                         (if (/= nil ee) (get_bomdata&show_data ee))
                   )
              );
;      (if (and (= data0 "INSERT")(= data2 "PARTREF"))
;        (progn
;          (get_bomdata&show_data (car ent))
;          (setq ee t)
;        );progn
;        (progn
;    ;     (setq ee (get_bompent data8))
;          (setq ee (findbomp_ent data8))
;          (if (/= nil ee) (get_bomdata&show_data ee))
;        );progn
;      );if
      (if (/= nil ee)
      (progn
      (show_userdef)
      (setq lib_id 16)
      (action_tile "selcol" "(setq lib_id 1)(ml_ddsel_col \"col\")")
      (action_tile "layer" "(setq lib_id 16)")
      (action_tile "col" "(setq lib_id 17)")
      (action_tile "data1" "(setq lib_id 1)")
      (action_tile "data2" "(setq lib_id 2)")
      (action_tile "data3" "(setq lib_id 3)")
      (action_tile "data4" "(setq lib_id 4)")
      (action_tile "data5" "(setq lib_id 5)")
      (action_tile "data6" "(setq lib_id 6)")
      (action_tile "data7" "(setq lib_id 7)")
      (action_tile "data8" "(setq lib_id 8)")
      (action_tile "data9" "(setq lib_id 9)")
      (action_tile "data10" "(setq lib_id 10)")
      (action_tile "data11" "(setq lib_id 11)")
      (action_tile "data12" "(setq lib_id 12)")
      (action_tile "data13" "(setq lib_id 13)")
      (action_tile "data14" "(setq lib_id 14)")
      (action_tile "data15" "(setq lib_id 15)")

      (action_tile "lib" "(makepart_useword)")

      (mode_tile "layer" 1)
      (action_tile "accept" "(edit_bomp_ok)(done_dialog)")
      (action_tile "cancel" "(done_dialog)")
      (start_dialog)
      (if edit_bompflg
;;ent: 資訊點圖元名稱   dlist: 15筆屬性串列 (("TAG1" "aaa") ("TAG2" "bbb") ("TAG3" "ccc")..)
       (progn
            (addatt_tobomball ee attdata_list)
            (if txtent
                (progn
		     (setq int_i 0)
		     (repeat (sslength txtgrp)
		       	     (setq txtent (ssname txtgrp int_i))
                      	     (setq txtentdata(entget txtent))
                             (setq oldtxt(assoc 1 txtentdata))
                             (setq newtxt(cons 1 data1))
                             (setq txtentdata1(subst newtxt oldtxt txtentdata))
                             (entmod txtentdata1)
		     	     (ad1xdata txtent "BALL_ID" (list "BALL_ID"(cons 1000 data1)))
		       	     (setq int_i (1+ int_i))
		     )
                );progn
            );if
       );progn
        (command "regen")
       );progn
      )
      (progn
        (done_dialog)
        (actdcl (strcat POWDESIGN_path "pub-dcl") "allert")
        (set_tile "ms_allert" "本圖元並未建立零件資訊點!")
        (action_tile "accept" "(done_dialog)")
        (start_dialog)
      );progn
      )
    );progn
  );if
  (princ)
);defun

(defun edit_bomp_ok()
   (setq player (get_tile "layer")
         data1  (get_tile "data1")
         data2  (get_tile "data2")
         data3  (get_tile "data3")
         data4  (get_tile "data4")
         data5  (get_tile "data5")
         data6  (get_tile "data6")
         data7  (get_tile "data7")
         data8  (get_tile "data8")
         data9  (get_tile "data9")
         data10 (get_tile "data10")
         data11 (get_tile "data11")
         data12 (get_tile "data12")
         data13 (get_tile "data13")
         data14 (get_tile "data14")
         data15 (get_tile "data15"))
     ;----------2003.06.20 SAM 加入(if (= "*" data?)...)-------------------------------------
     (if (null data1)(setq data1 ""))(if (= "*" data1)(setq data1 player))
     (if (null data2)(setq data2 ""))(if (= "*" data2)(setq data2 player))
     (if (null data3)(setq data3 ""))(if (= "*" data3)(setq data3 player))
     (if (null data4)(setq data4 ""))(if (= "*" data4)(setq data4 player))
     (if (null data5)(setq data5 ""))(if (= "*" data5)(setq data5 player))
     (if (null data6)(setq data6 ""))(if (= "*" data6)(setq data6 player))
     (if (null data7)(setq data7 ""))(if (= "*" data7)(setq data7 player))
     (if (null data8)(setq data8 ""))(if (= "*" data8)(setq data8 player))
     (if (null data9)(setq data9 ""))(if (= "*" data9)(setq data9 player))
     (if (null data10)(setq data10 ""))(if (= "*" data10)(setq data10 player))
     (if (null data11)(setq data11 ""))(if (= "*" data11)(setq data11 player))
     (if (null data12)(setq data12 ""))(if (= "*" data12)(setq data12 player))
     (if (null data13)(setq data13 ""))(if (= "*" data13)(setq data13 player))
     (if (null data14)(setq data14 ""))(if (= "*" data14)(setq data14 player))
     (if (null data15)(setq data15 ""))(if (= "*" data15)(setq data15 player))
     ;---------------------------------------------------------------------------------------
     (setq attdata_list (list (list "TAG1" data1) (list "TAG2" data2) (list "TAG3" data3)
                              (list "TAG4" data4) (list "TAG5" data5) (list "TAG6" data6)
                              (list "TAG7" data7) (list "TAG8" data8) (list "TAG9" data9)
                              (list "TAG10" data10) (list "TAG11" data11) (list "TAG12" data12)
                              (list "TAG13" data13) (list "TAG14" data14) (list "TAG15" data15)))
     (setq edit_bompflg t)
  (princ)
);defun

(defun get_bomdata&show_data(entt)
   (setq attdata (get_bomdata entt))
   (set_tile "layer" (cdr (assoc 8 (entget ENTT))))
   (foreach mm attdata
     (progn
;      (set_tile "layer" (cdr (assoc 8 (entget mm))))
       (cond
         ((= "TAG1" (nth 0 mm))(set_tile "data1" (nth 1 mm)))
         ((= "TAG2" (nth 0 mm))(set_tile "data2" (nth 1 mm)))
         ((= "TAG3" (nth 0 mm))(set_tile "data3" (nth 1 mm)))
         ((= "TAG4" (nth 0 mm))(set_tile "data4" (nth 1 mm)))
         ((= "TAG5" (nth 0 mm))(set_tile "data5" (nth 1 mm)))
         ((= "TAG6" (nth 0 mm))(set_tile "data6" (nth 1 mm)))
         ((= "TAG7" (nth 0 mm))(set_tile "data7" (nth 1 mm)))
         ((= "TAG8" (nth 0 mm))(set_tile "data8" (nth 1 mm)))
         ((= "TAG9" (nth 0 mm))(set_tile "data9" (nth 1 mm)))
         ((= "TAG10" (nth 0 mm))(set_tile "data10" (nth 1 mm)))
         ((= "TAG11" (nth 0 mm))(set_tile "data11" (nth 1 mm)))
         ((= "TAG12" (nth 0 mm))(set_tile "data12" (nth 1 mm)))
         ((= "TAG13" (nth 0 mm))(set_tile "data13" (nth 1 mm)))
         ((= "TAG14" (nth 0 mm))(set_tile "data14" (nth 1 mm)))
         ((= "TAG15" (nth 0 mm))(set_tile "data15" (nth 1 mm)))
       );cond
     );progn
   );foreach
);defun

;;有幾個圖層?
(defun c:layer_how(/ grp ql count ent lname)
  (princ "\n選擇圖形, 並自動算出幾個零件層...")
  (setq grp (ssget) ql '() count 0)
  (setq ent (ssname grp count))
  (nobomp_listp);;2003.09.08 SAM
  (while ent
    (setq lname (cdr (assoc 8 (entget ent))))
    ;;(nobomp_listp);;2003.09.08 SAM
    (if (and (null (member nobomp_list ql))(null (member lname ql)))(setq ql (cons lname ql)))
    (setq count (1+ count))
    (setq ent (ssname grp count))
  )
  (princ (strcat "\n共有 " (rtos (length ql) 2 0) " 個零件層!"))
  (princ)
)

;;;╭════════════════════════════════════════════╮
;;;║設計日期: 2000.9.14                                                                     ║
;;;║更新日期:                                                                               ║
;;;║設 計 者: 佘宗紋                                                                        ║
;;;║功能說明: 產生圖面材料清單                                                              ║
;;;║相關檔案:                                                                               ║
;;;║相關副程式                                                                              ║
;;;╰════════════════════════════════════════════╯
(defun c:bomlist(/ ssg1 haveno_bomp oldblipmode label_list fielddata tdata_list needlist pdmlist attlist partdata bom pdm wid i ent attvalue attvalue_list pno_list newtdata_list os)
       (setq label_list '() pno_list '() tdata_list '() needlist '() pdmlist '() attlist '() newtdata_list '() ssg1 nil)

       (setvar "cmdecho" 0)

       (princ "\n材料清單計算中...")

       (setq ssg1 (ssget "x" (list (cons 0 "INSERT")(cons 2 "PARTREF"))))
       (setq haveno_bomp (tblsearch "BLOCK" "$$partref_bom"))

       (if  (null ssg1)
            (if haveno_bomp
                 (alert "資訊點已關閉 , 請先開啟資訊點 !")
                 (alert "找不到任何資訊點 , 請先建立資訊點與指標球 !")
            );if
            (progn
                     (setq os (getvar "osmode"))
                     (setvar "osmode" 0)
                     (setq oldblipmode (getvar "blipmode"))
                     (setvar "blipmode" 0)
                     (setq oerr *error* *error* te_err_bomlist)
;;;===================取出 SYSTEM.INI 零件定義各欄位名稱==================
                     (setq partdata (read (getfile_val (strcat POWDESIGN_path "SYSTEM.ini") "零件定義資料")))
                     (foreach YY partdata
                         (setq needlist (cons (list (nth 0 YY) (nth 2 YY)) needlist))
                     );foreach
                     (setq needlist (reverse needlist))
;;;===================取出 SYSTEM.INI 材料清單各欄位名稱==================
                     (setq fielddata (read (getfile_val (strcat POWDESIGN_path "system.ini") "材料清單欄位定義")))
                     (foreach XX fielddata
                         (setq bom (nth 0 XX))
                         (setq pdm (nth 2 XX))
                         (setq wid (nth 1 XX))
                         (setq label_list (cons (list bom wid) label_list))
                         (setq pdmlist (cons pdm pdmlist))
                     );foreach
                     (setq label_list(reverse label_list))
                     (setq pdmlist(reverse pdmlist))
                     (foreach XX pdmlist
                             (setq attlist(cons (cdr (assoc XX needlist)) attlist))
                     );foreach
                     (setq attlist (reverse attlist))
                     (setq i 0)
                     (repeat (sslength ssg1)
                             (princ ".")
                             (setq ent (ssname ssg1 i))

                             (setq entlay (cdr(assoc 8 (entget ent))))

                             (if (ssget "x" (list (cons 0 "text") (cons 8  sys_ball_layer) (list -3 (list entlay))))
                                 (progn
                                      (setq j 0 attvalue_list '())
                                      (repeat (length attlist)
                                         (setq attvalue (cdr (assoc 1 (getatt ent 2 (nth 0 (nth j attlist))))))

                         ;                (if (and (= j 0) (= "" attvalue))
                         ;                    (progn
                         ;                       (alert (strcat "圖層 " (cdr(assoc 8 (entget ent))) " 尚無組合件號 , 請先建立指標球 !"))
                         ;                       (exit)
                         ;                    );progn
                         ;                );if
                         ;
                         ;                (setq attvalue_list (cons attvalue attvalue_list))
                         ;                (if (= j 0)(setq pno_list(cons attvalue pno_list)))
                                         (if (= j 0)
                                             (if (= "" attvalue)
                                                 (alert (strcat "圖層 " entlay " 之資訊點尚無組合件號 , 材料清單將忽略 !"))
                                                 (setq attvalue_list (cons attvalue attvalue_list) pno_list (cons attvalue pno_list))
                                             );if
                                             (progn
                                                 (setq attvalue_list (cons attvalue attvalue_list))
                                             );progn
                                         );if

                                         (setq j (+ j 1))
                                      );repeat
                                      (setq attvalue_list (reverse attvalue_list))
                                      (setq tdata_list(cons attvalue_list tdata_list))
                                 );progn
                             );if
                             (setq i (+ i 1))

                     );repeat
                     (setq tdata_list(reverse tdata_list))

                     (if (> (length pno_list) 1)
                         (progn
                                  (setq pno_list (strlsort_bomlist pno_list));;基本上 pno_list 的元素不會重複 ;;sam
                                  (setq i 0)
                                  (repeat (length pno_list)
                                           (setq newtdata_list(cons (assoc (nth i pno_list) tdata_list) newtdata_list))
                                           (setq i (+ i 1))
                                  )
                         );progn
                         (setq newtdata_list tdata_list)
                     );if
                     (if tdata_list
                         (free_list_designer newtdata_list label_list 0 90 6 "M" 3)
                         (alert "尚未建立指標球 , 請先建立指標球 !")
                     );if

                     (setvar "blipmode" oldblipmode)
                     (setvar "osmode" os)
                     (princ)
           );progn
       );if
);defun


(defun strlsort_bomlist(listname / min_str sort_pno_list new_list)
       (setq sort_pno_list '())
       (setq min_str (minstr_bomlist listname))
       (setq sort_pno_list (cons min_str sort_pno_list))
       (setq new_list listname)

       (repeat (- (length listname) 2)
            (setq new_list(removelist min_str new_list))
            (setq min_str (minstr_bomlist new_list))
            (setq sort_pno_list (cons min_str sort_pno_list))
       )
       (setq new_list(removelist min_str new_list))
       (setq sort_pno_list (cons (nth 0 new_list) sort_pno_list))
       sort_pno_list
);defun

(defun minstr_bomlist(listname / i next_str min_str)
       (setq min_str (nth 0 listname))
       (setq i 1)
       (repeat (- (length listname) 1)
               (setq next_str (nth i listname))
               (setq min_str (sortstr_bomlist min_str next_str))
               (setq i (+ i 1))
       );repeat
       min_str
);defun

(defun sortstr_bomlist(str1 str2 / i len1 len2 n newstr)
       (setq len1 (strlen str1))
       (setq len2 (strlen str2))
       (if (> len1 len2)(setq n len1)(setq n len2))
       (setq newstr nil i 1)
       (while (and (null newstr) (<= i n))
              (cond
                   ((< len1 len2)
                    (setq newstr str1)
                   )
                   ((> len1 len2)
                    (setq newstr str2)
                   )
                   ((< (substr str1 i 1)(substr str2 i 1))
                    (setq newstr str1)
                   )
                   ((> (substr str1 i 1)(substr str2 i 1))
                    (setq newstr str2)
                   )
                   ((= (substr str1 i 1)(substr str2 i 1))
                    (setq i (+ i 1))
                   )
              )
       );while
       (if (> i n)(setq newstr str1))
       newstr
)

;;自由格式畫表單
;;(free_list 資料串列 表頭串列 水平方向 垂直方向 欄高 文字對齊方式 字高)
;; 資料串列: '(("1" "電源1" "ss412" "1" "電源1" "ss412" "1" "電源1" "ss412" )("1" "電源1" "ss412" "1" "電源1" "ss412" "2" "電源2" "ss414")("1" "電源1" "ss412" "1" "電源1" "ss412" "3" "電源3" "ss416").....
;; 表頭串列: '(("件號" "10") ("品名" "20")("材質" "30")("件號" "10") ("品名" "20")("材質" "30")("件號" "10") ("品名" "20")("材質" "30")))
;; 水平方向: 0,   180
;; 垂直方向: 90,  270
;; 文字對齊方式: "M",  "ML"
;; 例如: (free_list tdata_list label_list 180 270  8 "M" 4)


(defun free_list_designer(tdata_list label_list xdir ydir colhei txttype txth /
          xang yang i scal dy tfield_wid basep basep1 p_top p1_top ptxt dx entdata oldxscal newxscal dxscal)

           (setq bom_ssg(ssadd))
;================X方向================
           (cond
             ((= xdir 0) (setq xang 0))
             ((= xdir 180) (setq xang pi))
           )
           (setq scal (getvar "dimscale"))
;================欄高================
           (setq dy (* scal colhei))
;================y方向================
           (cond
             ((= ydir 90) (setq yang (* pi 0.5)))
             ((= ydir 270) (setq yang (- (* pi 0.5))))
           )
;================ tfield_wid=>材料表總寬 ================
           (setq tfield_wid 0 i 0)
           (repeat (length label_list)
                   (setq tfield_wid (+ tfield_wid (* scal (atof (nth 1 (nth i label_list))))))
                   (setq i (+ i 1))
           );repeat

           (setq basep (getpoint "\n表單起始位置: "))

  (setq curlayer (getvar "clayer"))
  (setq curcolor (getvar "cecolor"))
  (setq curltype (getvar "celtype"))
  (command "layer" "on" curlayer "")
  (setq la (tblsearch "layer" sys_bomlist_layer))
  (if (= la nil) (command "layer" "n" sys_bomlist_layer "c"  sys_bomlist_layercol sys_bomlist_layer ""))
  (command "linetype" "s" "bylayer" "" "color" "bylayer" "layer" "s" sys_bomlist_layer "")
  (command "linetype" "s" "continuous" "")


           (cond
             ((= xdir 0)   (setq basep1 (polar basep 0  tfield_wid)))
             ((= xdir 180) (setq basep1 (polar basep pi tfield_wid)))
           );cond

           (command "line" basep basep1 "")
           (setq bom_ssg(ssadd (entlast) bom_ssg))

           (setq p_top  (polar basep yang (/ dy 2.0)))
           (setq p1_top (polar basep1 yang (/ dy 2.0)))
;================表頭================
           (setq i 0 field_wid 0)
           (repeat (length label_list)
                   (setq ptxt(polar p_top xang (+ field_wid (* scal (/ (atof (nth 1 (nth i label_list))) 2.0)))))
                   (setq field_wid (+ field_wid (* scal (atof (nth 1 (nth i label_list))))))
                   (command "text" "m" ptxt (* scal txth) "0" (nth 0 (nth i label_list)))
                   (setq bom_ssg(ssadd (entlast) bom_ssg))
                   (setq i (+ i 1))
           )
           (setq p_top  (polar p_top yang (/ dy 2.0)))
           (setq p1_top (polar p1_top yang (/ dy 2.0)))
           (command "line" p_top p1_top "")
           (setq bom_ssg(ssadd (entlast) bom_ssg))

;================資料================
           (foreach XX tdata_list
                   (setq hscal 1 i 0 hhscal 1)
                  ; (repeat (length label_list)
                  ;         (if (> (* 0.7 (strlen (nth 1 XX))) (/ (atof (nth 1 (nth i label_list))) txth))
                  ;             (progn
                  ;                  (if (and (> (strlen (nth i XX)) 0) (> (strlen (nth i XX)) (/ (atof (nth 1 (nth i label_list))) txth)))
                  ;                      (progn
                  ;                            (setq hscal (+ 1 (fix (/ (strlen (nth i XX)) (/ (atof (nth 1 (nth i label_list))) txth )))))
                  ;                            (if (> hscal hhscal)(setq hhscal hscal))
                  ;                      );progn
                  ;                  );if
                  ;             )
                  ;         )
                  ;         (setq i (+ i 1))
                  ; )

                   (setq p_top  (polar p_top yang  (* hscal dy 0.5)))
                   (setq p1_top (polar p1_top yang (* hscal dy 0.5)))

                   (setq i 0 field_wid 0)
                   (repeat (length label_list)
                           (setq ptxt(polar p_top xang (+ field_wid (* scal (/ (atof (nth 1 (nth i label_list))) 2.0)))))
                           (setq field_wid (+ field_wid (* scal (atof (nth 1 (nth i label_list))))))
                           (command "text" "m" ptxt (* scal txth) "0" (nth i XX))
                           (setq bom_ssg(ssadd (entlast) bom_ssg))
;================↓text fit↓================
                           (if (/= "" (nth i XX))
                                 (progn
                                       (setq entdata (entget(entlast)))
                                       (setq dx (abs (- (car (nth 0 (textbox entdata))) (car (nth 1 (textbox entdata))))))
                                       (if (> dx (* scal (- (atof (nth 1 (nth i label_list))) 2)))
                                           (progn
                                                  (setq dxscal (/ (* scal (- (atof (nth 1 (nth i label_list))) 2)) dx))
                                                  (setq oldxscal (assoc 41 entdata))
                                                  (setq newxscal (cons 41 dxscal))
                                                  (setq entdata (subst newxscal oldxscal entdata))
                                                  (entmod entdata)
                                           );progn
                                       );if
                                 );progn
                           );if
;================↑textfit↑================
                           (setq i (+ i 1))
                   )
                   (setq p_top  (polar p_top yang (* hscal dy 0.5)))
                   (setq p1_top (polar p1_top yang (* hscal dy 0.5)))
                   (command "line" p_top p1_top "")
                   (setq bom_ssg(ssadd (entlast) bom_ssg))
           )

           (command "line" basep p_top "")
           (setq bom_ssg(ssadd (entlast) bom_ssg))

           (command "line" basep1 p1_top "")
           (setq bom_ssg(ssadd (entlast) bom_ssg))

;================垂直線================
           (setq i 0)
           (repeat (- (length label_list) 1)
                   (setq basep  (polar basep xang (* scal (atof (nth 1 (nth i label_list))))))
                   (setq p_top  (polar p_top xang (* scal (atof (nth 1 (nth i label_list))))))
                   (command "line" basep p_top "")
                   (setq bom_ssg(ssadd (entlast) bom_ssg))
                   (setq i (+ i 1))
           )

           (setvar "osmode" os)


   (if (minusp (cdr(assoc 62 (tblsearch "layer" curlayer))))
       (command "layer" "s" curlayer "off" curlayer "y" "")
       (command "layer" "s" curlayer "")
   );if
   (command "linetype" "s" curltype "")
   (cond
     ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
     ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
     (T (command "color" (atoi curcolor)))
   )



           (setq basep nil)
           (while (null basep)
                  (setq basep(getpoint "\n表單移動基準點 : "))
           )
           (princ "\n第二點 :")
           (command "move" bom_ssg "" basep pause)
           (princ)
)

(defun te_err_bomlist(msg)
   (if (/= msg "Function cancelled")(princ (strcat "\nError: " msg)))
   (if oerr (setq *error* oerr))

   (setvar "osmode" os)
   (setvar "blipmode" oldblipmode)
   (princ)
)


;;=========================================================================================================================
;;╭════════════════════════════════════════════╮
;;║設計日期: 2000.8.15                                                                     ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 資訊點公用程式                                                                ║
;;║相關檔案:                                                                               ║
;;║相關副程式                                                                              ║
;;╰════════════════════════════════════════════╯
;;
;; 以層名找到對應之資訊點(副程式)
;; 取出 ballname 資訊點的所有屬性資料(副程式)
;; 收集所有資訊點資料
;; 由-3 的旗標, 與圖元的圖層名直接找指標球
;; 資訊點資料寫入
;; 選擇所有圖層,並過濾不建立資訊點的圖層
;; 由圖層名直接找指標球
;; 與物料資料庫連結(未完成!)
;; 取出被選圖元集中所有文字資料
;; 由被選擇之圖群中取出圖框屬性,並結成 16筆屬性串列 (("TAG1" "aaa") ("TAG2" "bbb") ("TAG3" "ccc")....("LAYER" "ddd"))

;;選擇所有圖層,並過濾不建立資訊點的圖層
;(setq nobomp_list (list "BORDER" "PROJ" "0" "DIM" "TEXT" "$PARTREF_BOM")) ;;定義不建立資訊點的圖層
;;選擇所有圖層,並過濾不建立資訊點的圖層
;(setq nobomp_list (list "BORDER" "PROJ" "0" "DIM" "TEXT" "$PARTREF_BOM")) ;;定義不建立資訊點的圖層
(defun coll_all_layer(/ tlayer)
   (setq tlayer (coll_layer))
   (nobomp_listp)
   (foreach nn nobomp_list
     (progn
       (if (/= nil (member nn tlayer)) (setq tlayer (removelist nn TLayer)))
    );progn
  );foreach
  tlayer
)


;; 以層名找到對應之資訊點(副程式)
(defun get_bompent(lname / partref_group ent)
  (setq laname (strcase laname))
  (setq partref_group (ssget "x" (list (cons 8 lname) (cons 0 "INSERT")(cons 2 "PARTREF"))))
  (if PARTREF_GROUP (setq ent (ssname partref_group 0)))
  ent
)

;;ballname :資訊點圖元名稱
;;取出 ballname 資訊點的所有屬性資料(副程式)
(defun get_bomdata(ballname)
   (setq nextent (entnext ballname) datalist '())
   (setq nextent_data (entget nextent))
   (while (= "ATTRIB" (cdr (assoc 0 nextent_data)))
     (setq nextent_data2 (cdr (assoc 2 nextent_data)) )
     (setq nextent_data1 (cdr (assoc 1 nextent_data)) )
     (setq datalist (cons (list nextent_data2 nextent_data1) datalist))
     (setq nextent (entnext nextent))
     (setq nextent_data (entget nextent))
   );while
   datalist
)

;;資訊點資料寫入
;;ent: 資訊點圖元名稱   dlist: 16筆屬性串列 (("TAG1" "aaa") ("TAG2" "bbb") ("TAG3" "ccc")...)
(defun addatt_tobomball(ent dlist / newdata label $data1)
   (foreach mm dlist
     (progn
       (setq newdata (nth 1 mm)
              label (nth 0 mm))
        (setq $data1 (getatt ent 2 label)
              $data1 (subst (cons 1 newdata) (assoc 1 $data1) $data1))
        (entmod $data1)
     );progn
   );foreach
;  (command "regen")
)


;;;收集所有資訊點資料
(defun collect_partref_data(/ partref_group partref_datalist count ent player pname data)
  (setq partref_group (ssget "x" (list (cons 2 "PARTREF") (cons 0 "INSERT"))))
  (if (/= nil partref_group)
    (progn
      (setq partref_datalist '() count 0)
      (repeat (sslength partref_group)
         (setq ent (ssname partref_group count))
         (setq player (strcase (cdr (assoc 8 (entget ent)))))
         (setq pname (strcase (cdr (assoc 1 (getatt ent 2 "TAG3")))))
         (setq data (strcat player " : " pname))
         (setq partref_datalist (cons data partref_datalist))
         (setq count (1+ count))
      );repeat
    );progn
    (setq partref_datalist nil)
  )
  partref_datalist
)

;;;由-3 的旗標, 與圖元的圖層名直接找指標球
;(defun findbomp_ent(lname flg)
;   (setq ssg1 (ssget "x" (list (cons 8 lname)(list -3 (list flg)))))
;   (if ssg1 (setq ssg1 (ssname ssg1 0)))
;   ssg1
;)
;;;由圖層名直接找資訊點
(defun findbomp_ent(lname)
   (setq ssg1 (ssget "x" (list (cons 8 lname)(cons 0 "INSERT")(cons 2 "PARTREF"))))
   (if ssg1 (setq ssg1 (ssname ssg1 0)))
   ssg1
)

(defun get_taglist(txt / txt aalist idt tt)
   (setq aalist '())
   (setq txt (substr txt (1+ (get_word txt ";"))))
   (while (setq idt (get_word txt ";"))
      (setq tt (substr txt 1 (- idt 1)))
      (setq aalist (cons tt aalist))
      (setq txt (substr txt (1+ (get_word txt ";"))))
   );while
   (setq aaalist (cons txt aalist))
   (reverse aaalist)
);defun

(defun get_database&subst(mm data_list / count adata chktxt Adata1 Adata2 Adata3)
;("品名" "PARTNAME" "TAG3")("英文品名" "" "TAG9")("規格" "" "TAG10")
       (nobomp_listp)
       (if (null (member mm nobomp_list))
         (progn
           (if (setq bomdata (assoc (strcase mm) database_assoc_list))
              (progn
                (setq oldbomdata (get_taglist (nth 1 bomdata)))
                (setq cou 0)
                (foreach qq taglist
                  (progn
                    (setq data_list (subst (list qq (nth cou oldbomdata)) (assoc qq data_list) data_list))
                    (setq cou (1+ cou))
                  );progn
                );foreach
              );progn
           );if
         );progn
       );if
      data_list
)

;(defun get_database&subst(mm data_list / count adata chktxt Adata1 Adata2 Adata3)
;;("品名" "PARTNAME" "TAG3")("英文品名" "" "TAG9")("規格" "" "TAG10")
;   ;                                             ;;titledata -> "料號;TAG3;TAG9;TAG10"
;   ;    (setq taglist (get_taglist titledata))   ;;taglist ("TAG3" "TAG9" "TAG10")
;
;       (if (null (member mm nobomp_list))
;         (progn
;           (setq count 0)
;           (setq adata (nth count database_list))
;           (while adata
;              (setq chktxt (substr adata 1 (- (get_word adata ";") 1)))
;              (if (= (strcase chktxt) (strcase mm))
;                (progn
;                   (setq adata (substr adata (+ (get_word adata ";") 1)))
;                   (setq adata1 (substr adata 1 (- (get_word adata ";") 1)))
;                   (if (= "nil" adata1) (setq adata1 ""))
;                   (setq adata (substr adata (+ (get_word adata ";") 1)))
;                   (setq adata2 (substr adata 1 (- (get_word adata ";") 1)))
;                   (if (= "nil" adata2) (setq adata2 ""))
;                   (setq adata3(substr adata (+ (get_word adata ";") 1)))
;                   (if (= "nil" adata3) (setq adata3 ""))
;                   (setq data_list (subst (list "TAG3" adata1) (assoc "TAG3" data_list) data_list))
;                   (setq data_list (subst (list "TAG9" adata2) (assoc "TAG9" data_list) data_list))
;                   (setq data_list (subst (list "TAG10" adata3) (assoc "TAG10" data_list) data_list))
;                   (setq adata nil)
;                );progn
;                (progn
;                   (setq count (1+ count))
;                   (setq adata (nth count database_list))
;                );progn
;              );if
;
;           );while
;         );progn
;      );if
;      data_list
;)

;;取出被選圖元集中所有文字資料
(defun gettxt_grp(/ txtgrp count txtlist data data0)
  (princ "\n選擇要過濾出文字 (TEXT) 資料的圖元...")
  (setq txtgrp (ssget))
  (if (null txtgrp)
    (princ)
    (progn
      (setq count 0 txtlist '())
      (repeat (sslength txtgrp)
        (setq data (entget (ssname txtgrp count))
              data0 (cdr (assoc 0 data)))
       ; (if (= "TEXT" data0) (setq txtlist (cons (cdr (assoc 1 data)) txtlist)))
        (cond
             ((= "TEXT" data0) (setq txtlist (cons (cdr (assoc 1 data)) txtlist)))
             ((= "MTEXT" data0)
              (setq txt "" stid 1)
              (repeat (strlen (cdr (assoc 1 data)))
                      (if (/= "\\" (substr (cdr (assoc 1 data)) stid 1))
                          (setq txt (strcat txt (substr (cdr (assoc 1 data)) stid 1)) stid (+ stid 1))
                          (setq txtlist (cons txt txtlist) txt "" stid (+ stid 2))
                      );if
              );repeat
              (if (/= "" txt)(setq txtlist (cons txt txtlist) txt "" stid (+ stid 2)))
             )
        );cond

        (setq count (1+ count))
      );repeat
    );progn
  );if
  txtlist
);defun


;;由被選擇之圖群中取出圖框屬性,並結成 16筆屬性串列 (("TAG1" "aaa") ("TAG2" "bbb") ("TAG3" "ccc")....("LAYER" "ddd"))
;;grp 被選擇之圖組
(defun get_sheetatt(grp / count dlist attblklist partdata oldattta ent entdata data2 data0 attent newlist attdata d1 d2
                        taglist anewlist)
; (setq grp (ssget))
  (setq count 0 dlist '())

  (setq attblklist (read (getfile_val (strcat POWDESIGN_path "SYSTEM.ini") "舊圖框屬性BLOCK名稱")))
;; attblklist ("a1tzt" "a2tzt" "a3tzt" "a4tzt")

  (setq partdata (read (getfile_val (strcat POWDESIGN_path "SYSTEM.ini") "零件定義資料")))
;;partdata (("組合件號" "" "TAG1")("次組合名稱" "" "TAG2")("品名" "PARTNAME" "TAG3")("材質" "MATERIAL" "TAG4")("#圖號" "DWGNO" "TAG5")("製圖" "DRAWER" "TAG6")("數量" "QTY" "TAG7")("表面處理" "SURFACE" "TAG8")("英文品名" "" "TAG9")("規格" "" "TAG10")("機種" "ITEM" "TAG11")("說明" "" "TAG12"))

  (setq oldattta (read (getfile_val (strcat POWDESIGN_path "SYSTEM.ini") "舊圖框屬性對應資訊點標籤")))
;;oldattta (("PARTNAME" "TAG3")("MATERIAL" "TAG4")("DWGNO" "TAG5")("DRAWER" "TAG6")("QTY" "TAG7")("SURFACE" "TAG8")("ITEM" "TAG11"))

  (foreach nn attblklist (setq dlist (cons (strcase nn) dlist)) )
  (setq ent (ssname grp count))
  (setq bom_ballent nil)
  (while ent
    (setq entdata (entget ent))
    (setq data2 (assoc 2 entdata))
    (if (/= nil data2) (setq data2 (strcase (cdr data2))))
    (setq data0 (cdr (assoc 0 entdata)))
    (if (and (=  data0 "INSERT")(= data2 "PARTREF"))
      (setq bom_ballent ent)  ;假如圖群中有資訊點, 則記錄之
    );if
    (if (and (=  data0 "INSERT")(/= nil (member data2 dlist)))
      (setq attent ent ent  nil)
      (setq count (1+ count) ent (ssname grp count))
    );if
    (setq blkname nil)
  );while
  (if (/= nil attent)
     (progn
        (setq newlist '())
        (foreach nn oldattta
           (progn
             (setq sheet_insp (cdr (assoc 10 (entget attent))))    ;;sheet_insp 屬性圖框插入點, 被(c:addbomp_sheet)與 (pub_bom_sheet) 用到
             (setq attdata (getatt attent 2 (nth 0 nn)))
             (if (/= attdata nil )
               (progn
                 (setq d1 (cdr (assoc 1 attdata)))  ;; d1: 環保濾清機
                 (setq d2 (cdr (assoc 2 attdata)))  ;; d2: ITEM
                 (setq newlist (cons (list (nth 1 nn) d1) newlist))
              ;  (princ (strcat "\n" d2 ":" d1))
              ; 16筆屬性串列 (("TAG1" "aaa") ("TAG2" "bbb") ("TAG3" "ccc")....("LAYER" "ddd"))
               );progn
             );if
           );progn
        );foreach
        (if (/= nil newlist)
          (progn
            (setq taglist '("TAG1" "TAG2" "TAG3" "TAG4" "TAG5" "TAG6" "TAG7" "TAG8" "TAG9" "TAG10"
                            "TAG11" "TAG12" "TAG13" "TAG14" "TAG15"))
            (setq anewlist newlist)
            (foreach nn taglist
               (if (null (assoc nn anewlist)) (setq newlist (cons (list nn "") newlist)))
            );foreach
          );progn
        );if
     );progn
  );if
  newlist
);defun


;;選擇所有圖層,並過濾不建立資訊點的圖層
;(setq nobomp_list (list "BORDER" "PROJ" "0" "DIM" "TEXT" "$PARTREF_BOM")) ;;定義不建立資訊點的圖層
(defun coll_all_layer(/ tlayer)
   (setq tlayer (coll_layer))
   (nobomp_listp)
   (foreach nn nobomp_list
     (progn
;      (PRINC nn)
       (if (/= nil (member nn tlayer)) (setq tlayer (removelist nn TLayer)))
    );progn
  );foreach
  tlayer
)


;;╭════════════════════════════════════════════╮
;;║設計日期: 2000.11.16                                                                    ║
;;║更新日期:                                                                               ║
;;║設 計 者: 佘宗紋                                                                        ║
;;║功能說明: 將由結構樹建立之次組合名稱填入資訊點之次組合屬性欄位                          ║
;;║相關檔案:                                                                               ║
;;║相關副程式                                                                              ║
;;╰════════════════════════════════════════════╯
(defun c:subassname_into_infopoint( / ff data i infopoint_ssg layname infopoint_lay_entname_list subname j)
       (setvar "cmdecho" 0)
       (setq i 0 infopoint_lay_entname_list '())
       (setq infopoint_ssg(ssget "x" '((0 . "INSERT")(2 . "partref"))))
       (repeat (sslength infopoint_ssg)
               (setq layname (cdr (assoc 8 (entget (ssname infopoint_ssg i)))))
               (setq infopoint_lay_entname_list (cons  (list layname (ssname infopoint_ssg i)) infopoint_lay_entname_list))
               (setq i (+ i 1))
       );repeat
     ;  (setq ssg1 infopoint_lay_entname_list)
       (setq ff (open (strcat POWDESIGN_path "bomup.txt") "r"))
       (setq data (read-line ff))
       (setq data (read-line ff))
       (while data
              (setq subname (substr data 1 (- (get_word data ";") 1)))
              (if (= " " subname)(setq subname ""))
              (setq data (substr data (+ (get_word data ";") 1)))
              (setq layname (substr data 1 (- (get_word data ";") 1)))
              (if (assoc layname infopoint_lay_entname_list)
                  (modifyatt_subassname_into_infopoint (cadr (assoc layname infopoint_lay_entname_list)) subname)
              );if
              (setq data (read-line ff))
       );while
       (close ff)
);defun

(defun modifyatt_subassname_into_infopoint(ent newid / $data1)
       (setq $data1 (getatt ent 2 "TAG2")
             $data1 (subst (cons 1 newid) (assoc 1 $data1) $data1))
       (entmod $data1)
;  (command "regen")
);
;*******************************************************
(defun vgetfile_val&manapart(fname initxt / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "system.ini檔案不存在")
                (exit)
           ) ;progn
    
       );if
  ;jacky
       (setq #textdef initxt)
       (setq needdata nil)
       (setq #downdata nil)
  ;jacky
 ; (setq data (read-line ff))
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
  
);defun
(defun nobomp_listp();;定義不建立資訊點的圖層
     (setq nobomp_list (vgetfile_val&manapart (strcat powdesign_PATH "system.ini") "不建立資訊點的圖層"))
     (setq nobomp_list (read nobomp_list))
);defun  

;;========================= SAM's UTILITY FUNCTION ================================
(defun getent_attfield(ent_sht str_tag / str_ename ent_att str_lab1 str_lab2 lst_att str_att str_ret)
	(setq ent_att (entnext ent_sht))
	(while ent_att
		(setq str_ename (cdr (assoc 0 (entget ent_att))))
	  	(cond ((= "ATTRIB" str_ename)
		       (setq str_lab1 (cdr (assoc 1 (entget ent_att))))
	  	       (setq str_lab2 (cdr (assoc 2 (entget ent_att))))
		       (setq lst_att  (cons (list str_lab2 str_lab1) lst_att));;(("標籤" "提示")...)
		       (setq ent_att (entnext ent_att)))
		      ((= "SEQEND" str_ename)(setq ent_att nil))
		      (t (setq ent_att (entnext ent_att)))
		)
	)
  	(setq str_ret (nth 1 (assoc str_tag lst_att)))
)
(defun list_symbolstr(alist symbol / string i catch)
  	(setq string (nth 0 alist))
  	(setq i 1)
  	(while  (setq catch  (nth i alist))
	  	(setq string (strcat string symbol catch))
	  	(setq i (1+ i))
	)
  	string
)