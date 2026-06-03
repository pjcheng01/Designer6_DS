;;;
;╭════════════════════╮
;║設計日期: 1998. 1. 15                   ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明:                               ║
;║                                        ║
;║執行方式:                               ║
;║相關檔案:pub-lisp.lsp, wordlib.dcl      ║
;║         powsql.lsp,wordlib.dbf         ║
;║                                        ║
;╰════════════════════╯

;;;使用到該程式之檔案 sheetset.lsp
(defun c:creatword(/ type_val word_val stm belonw_group type_list word_list belong_group worddata type_id type_name alldata_list )
 (setvar "cmdecho" 0)
 ;; 已移除加密狗判斷(progn ;; DraftSight: 移除加密狗 WHILE 迴圈
 (actdcl "wordlib1" "creat_word")
 (creat_wordlib_list)
 (reset_tile)
 (set_tile "error" "請輸入[辭庫分類]與[分類內容]資料以建立辭庫或點選[辭庫編輯]以編輯辭庫!!")

 (mode_tile "sel_group" 0)
 (mode_tile "belong_group" 0)
 (mode_tile "sel_data" 0)
 (mode_tile "worddata" 0)
 (mode_tile "creat" 0)

 (action_tile "creat_id" "(tilemode1 2)")


 (action_tile "group_list" "(set_tile \"error\" \"\")(show_word_list)")
 (action_tile "word_list" "(set_tile \"error\" \"\")(tilemode1 1)(get_list_data)(set_tile_val)")
 (action_tile "modify_id" "(set_tile \"error\" \"\")(show_group_list)")
 (action_tile "word_data_id" "(tilemode1 0)")
 (action_tile "sel_group"
    "(select_asciilist \"wordlib1\" \"name_list\" \"na_list\" type_list \"belong_group\")")
 (action_tile "sel_data"
    "(creat_alldatalist)(select_asciilist \"wordlib1\" \"name_list\" \"na_list\" alldata_list \"worddata\")")
 (action_tile "creat" "(creatword_exe)")
 (action_tile "del" "(del_data)")
 (action_tile "replace" "(replace_data)")

 (action_tile "accept" "(done_dialog)")
 (start_dialog)
  ;; removed FFF
 (setvar "cmdecho" 1)

 (setq type_val nil word_val nil stm nil belonw_group nil type_list nil word_list nil belong_group nil worddata nil type_id nil type_name nil data_list nil)
 (prin1)
)

(defun creat_alldatalist()
   (setq alldata_list '())
   (foreach nn data_list
     (progn
       (setq alldata_list (append (cdr nn) alldata_list))
     );progn
   );foreach
)

(defun select_asciilist(dclname dialogname dclkey datalst returnkey / flag rtdata)
   (actdcl "wordlib1" "name_list")
   (act_pop_list datalst dclkey)

   (action_tile "accept" "(select_asciilist_ok)")
   (action_tile "cancel" "(setq flag nil)(done_dialog)")
   (start_dialog)
   (if flag (set_tile returnkey rtdata))
   (princ)
)
(defun select_asciilist_ok()
   (setq txt_id (get_tile dclkey))
   (if (= "" txt_id)
     (set_tile "error" "沒有選擇資料!")
     (progn
        (setq rtdata (nth (atoi txt_id) datalst))
        (setq flag t)(done_dialog)
     );progn
   )
)


(defun get_list_data()
   (setq type_val (nth (atoi (get_tile "group_list")) type_list)
         word_val (nth (atoi (get_tile "word_list")) word_list))
)
(defun del_data(/ old_list aalist outdata count opff new_list)
  (get_list_data)
  (setq old_list (cons type_val word_list))
  (setq word_list (removelist word_val word_list))
  (setq new_list (cons type_val word_list))
  (setq aalist (cdr (member old_list data_list)))
  (setq opff (open (strcat word1_data_path "wordlib.dat") "w"))
;;;目標串列old_list 之前的資料寫出
  (setq count 0)
  (repeat (- (length data_list) (+ (length aalist) 1))
    (setq outdata "(")
    (foreach nn (nth count data_list)
      (progn
         (setq outdata (strcat outdata "\"" (txt_tran nn) "\"" " "))
      );progn
    );foreach
    (setq outdata (strcat outdata ")"))
    (write-line outdata opff)
    (setq count (1+ count))
  );repeat
;;;目標串列old_list 資料寫出
  (if (/= 1 (length new_list))
    (progn
      (setq outdata "(")
      (foreach nn new_list
        (progn
           (setq outdata (strcat outdata "\"" (txt_tran nn) "\"" " "))
        );progn
      );foreach
      (setq outdata (strcat outdata ")"))
      (write-line outdata opff)
    );progn
  );if
;;;目標串列old_list 之後的資料寫出
  (setq count 0)
  (foreach mm aalist
    (setq outdata "(")
    (foreach nn mm
      (progn
         (setq outdata (strcat outdata "\"" (txt_tran nn) "\"" " "))
      );progn
    );foreach
    (setq outdata (strcat outdata ")"))
    (write-line outdata opff)
  );repeat

  (close opff)
  (creat_wordlib_list)

  (act_pop_list type_list "group_list")
  (act_pop_list (cdr (assoc type_val data_list)) "word_list")
  (mode_tile "word_list" 1)
  (set_tile "belong_group" "")
  (set_tile "worddata" "")
)

(defun replace_data()
  (setq type_val (nth (atoi (get_tile "group_list")) type_list)
        word_val (nth (atoi (get_tile "word_list")) word_list))
  (setq belong_group  (txt_tran (get_tile "belong_group"))
        worddata      (txt_tran (get_tile "worddata")))
  (cond
    ((= "" belong_group)  (set_tile "error" "未輸入辭庫分類!!"))
    ((= "" worddata)      (set_tile "error" "未輸入分類內容!!"))
    (T
      (setq old_list (cons type_val word_list))
      (setq old_list (nth 0 (member old_list data_list)))
      (setq aalist (cdr (member old_list data_list)))
      (setq new_list (subst worddata word_val old_list))
      (setq opff (open (strcat word1_data_path "wordlib.dat") "w"))
;;;;;;;目標串列old_list 之前的資料寫出
      (setq count 0)
      (repeat (- (length data_list) (+ (length aalist) 1))
        (setq outdata "(")
        (foreach nn (nth count data_list)
          (progn
             (setq outdata (strcat outdata "\""  (txt_tran nn) "\"" " "))
          );progn
        );foreach
        (setq outdata (strcat outdata ")"))
        (write-line outdata opff)
        (setq count (1+ count))
      );repeat
;;;;;;;目標串列old_list 資料寫出
      (if (/= 1 (length new_list))
        (progn
          (setq outdata "(")
          (foreach nn new_list
            (progn
               (if (/= nn worddata)
                   (setq outdata (strcat outdata "\"" (txt_tran nn) "\"" " "))
                   (setq outdata (strcat outdata "\""  nn "\"" " "))
               )
            );progn
          );foreach
          (setq outdata (strcat outdata ")"))
          (write-line outdata opff)
        );progn
      );if
;;;;;;;目標串列old_list 之後的資料寫出
      (setq count 0)
      (foreach mm aalist
        (setq outdata "(")
        (foreach nn mm
          (progn
             (setq outdata (strcat outdata "\"" (txt_tran nn) "\"" " "))
          );progn
        );foreach
        (setq outdata (strcat outdata ")"))
        (write-line outdata opff)
      );repeat
      (close opff)
      (creat_wordlib_list)
    );T
  );cond

  (show_word_list)
  (mode_tile "worddata" 1)
  (mode_tile "sel_data" 1)
  (mode_tile "del" 1)
  (mode_tile "replace" 1)

)
(defun set_tile_val()
   (get_list_data)
   (set_tile "belong_group" type_val)
   (set_tile "worddata" word_val)
)

(defun show_group_list()
 (tilemode1 3)(mode_tile "creat" 1)
 (act_pop_list type_list "group_list")
)

(defun show_word_list()
  (mode_tile "worddata" 1)
  (mode_tile "sel_data" 1)
 (mode_tile "word_list" 0)
 (setq type_id (get_tile "group_list"))
 (setq type_name (nth (atoi type_id) type_list))
 (setq word_list (cdr (assoc type_name data_list)))
 (act_pop_list word_list "word_list")
)

(defun creatword_exe(/ newdata check_id opff outdata)
;(defun creatword_exe()
  (setq belong_group  (txt_tran (get_tile "belong_group"))
        worddata      (txt_tran (get_tile "worddata")))
  (setq check_id (assoc belong_group data_list))
  (if (and (/= "" belong_group) (/= "" worddata) (null check_id))
      (progn
        (setq opff (open (strcat word1_data_path "wordlib.dat") "w"))
        (foreach mm data_list
          (setq outdata "(")
          (foreach nn mm
            (progn
               (setq outdata (strcat outdata "\"" (txt_tran nn) "\"" " "))
            );progn
          );foreach
          (setq outdata (strcat outdata ")"))
          (write-line outdata opff)
          (set_tile "error" "資料建立完成!")
        );repeat
        (setq outdata (strcat "(" "\"" belong_group "\"" " " "\"" worddata "\"" ")"))
        (write-line outdata opff)
        (close opff)
        (creat_wordlib_list)

     );progn
     (progn
       (cond
         ((= "" belong_group)  (set_tile "error" "未輸入辭庫分類!!"))
         ((= "" worddata)      (set_tile "error" "未輸入分類內容!!"))
         (T (if (/= nil (member worddata (cdr check_id)))
              (progn
                (set_tile "error"  "資料重覆!")
                (mode_tile "group_list" 1)
                (mode_tile "word_list" 1)
              );progn
              (progn
               (setq old_list (assoc belong_group data_list))
               (setq aalist (cdr (member old_list data_list)))

               (setq old_list (reverse (cons worddata (reverse old_list))))
               (setq opff (open (strcat word1_data_path "wordlib.dat") "w"))
;;;;;;;;;;;;;;;;目標串列old_list 之前的資料寫出
               (setq count 0)
               (repeat (- (length data_list) (+ (length aalist) 1))
                 (setq outdata "(")
                 (foreach nn (nth count data_list)
                   (progn
                      (setq outdata (strcat outdata "\"" (txt_tran nn) "\"" " "))
                   );progn
                 );foreach
                 (setq outdata (strcat outdata ")"))
                 (write-line outdata opff)
                 (setq count (1+ count))
               );repeat
;;;;;;;;;;;;;;;;目標串列old_list 資料寫出
               (setq new_list old_list)
               (if (/= 1 (length new_list))
                 (progn
                   (setq outdata "(")
                   (foreach nn new_list
                     (progn
                        (if (/= nn worddata)
                            (setq outdata (strcat outdata "\"" (txt_tran nn) "\"" " "))
                            (setq outdata (strcat outdata "\"" nn "\"" " "))
                        );if
                     );progn
                   );foreach
                   (setq outdata (strcat outdata ")"))
                   (write-line outdata opff)
                 );progn
               );if
;;;;;;;;;;;;;;;;目標串列old_list 之後的資料寫出
               (setq count 0)
               (foreach mm aalist
                 (setq outdata "(")
                 (foreach nn mm
                   (progn
                      (setq outdata (strcat outdata "\"" (txt_tran nn) "\"" " "))
                   );progn
                 );foreach
                 (setq outdata (strcat outdata ")"))
                 (write-line outdata opff)
               );repeat

               (close opff)
               (creat_wordlib_list)
               (set_tile "error" "資料建立完成!")
              );progn
            );if
         );t
       );cond
     );progn
  );if
   (act_pop_list type_list "group_list")
)

(defun reset_tile()
 (mode_tile "group_id" 1)
 (mode_tile "word_data_id" 1)
 (mode_tile "group_list" 1)
 (mode_tile "word_list" 1)
 (mode_tile "creat" 1)
 (mode_tile "del" 1)
 (mode_tile "replace" 1)
 (mode_tile "sel_group" 1)
 (mode_tile "belong_group" 1)
 (mode_tile "sel_data" 1)
 (mode_tile "worddata" 1)
 (mode_tile "creat" 1)
)
(defun tilemode1(fg)
  (cond
    ((= 2 fg)
      (mode_tile "group_id" 1)
      (mode_tile "word_data_id" 1)
      (mode_tile "word_list" 1)
      (mode_tile "group_list" 1)
      (mode_tile "creat" 0)
      (mode_tile "del" 1)
      (mode_tile "replace" 1)
      (mode_tile "sel_group" 0)
      (mode_tile "belong_group" 0)
      (mode_tile "sel_data" 0)
      (mode_tile "worddata" 0)
    )
    ((= 3 fg)
      (mode_tile "group_id" 1)
      (mode_tile "word_data_id" 1)
      (mode_tile "group_list" 0)
      (mode_tile "word_list" 1)
      (mode_tile "del" 1)
      (mode_tile "replace" 1)
      (mode_tile "sel_group" 1)
      (mode_tile "belong_group" 1)
      (mode_tile "sel_data" 1)
      (mode_tile "worddata" 1)
      (mode_tile "creat" 1)
    )
    ((= 1 fg)
      (mode_tile "del" 0) (mode_tile "replace" 0)
      (mode_tile "sel_group" 1)
      (mode_tile "sel_data" 0)
      (mode_tile "belong_group" 1)
      (mode_tile "worddata" 0)
    )
    ((= 0 fg)
      (mode_tile "group_list" 1)
      (mode_tile "word_list" 0)
     (set_tile "error" "sel w or input w!!")
    )
  )
)
;==============================================================================
;pub-lisp.lsp(get_word)
;powsql.lsp(show_database_data)

;;當其他程式要使用辭庫時之語法
;;  (setq get_wordlibdata t)
;;  (setq txt (c:useword))
;;  (useword typ col)
;;   typ: 0.使用辭庫  1.被其它程式呼叫)
;;   col: 1. 單行     2.多行
;;  (useword 1

; (defun c:useword(/ action_flag useword_txt_type useword_txth stm type_list obj_list text_style
;                    style_dat p1 p2 txt word_list fg write_data fit_type ang height hor action_flag
;                    type_id type_name old_word word_id input_word no_done data alldata_list write_list
;                    ang
;                 )

(defun c:useword() (useword 0 2))

;;;使用到該程式之檔案 sheetset.lsp manapart.lsp
(defun useword(typ col / action_flag useword_txt_type useword_txth stm type_list obj_list text_style
                         style_dat p1 p2 txt word_list fg write_data fit_type ang height hor action_flag
                         type_id type_name old_word word_id input_word no_done data alldata_list
                         ang  get_wordlibdata write_list
              )
 (setvar "cmdecho" 0)
;; 已移除加密狗判斷(progn ;; DraftSight: 移除加密狗 WHILE 迴圈
 (actdcl "wordlib1" "use_word")
 (setq useword_txt_type (list "左" "中" "右" "對齊" "中央" "定高對齊" "左上" "中上" "右上"
                        "左中" "正中" "右中" "左下" "中下" "右下"))
 (act_pop_list useword_txt_type "fit_type")
 (mode_tile "next" 1) (mode_tile "write_list" 1)
 (if (= 1 typ) (setq get_wordlibdata t))
 (if get_wordlibdata
   (progn
     (mode_tile "fit_type" 1)
     (mode_tile "height" 1)
     (mode_tile "angle" 1)
   );progn
 );if
 (useword_reset_tile)
 (if (null useword_txth) (setq useword_txth (rtos (getvar "textsize") 2 2)))
 (set_tile "height" useword_txth)

  (creat_wordlib_list)
  (act_pop_list type_list "group_list")
 (setq write_list '())

 (action_tile "next" "(creat_writedata_list)(mode_tile \"next\" 1)")
 (action_tile "search_mode" "(search_mode)")

 (action_tile "group_list" "(set_tile \"moddata\" \"\")(set_tile \"error\" \"\")(sel_type_ok)")

;(if get_wordlibdata
 (if (/= 2 col)
   (action_tile "word_list" "(set_tile \"error\" \"\")(sel_word_ok)")
   (progn
     (action_tile "word_list" "(set_tile \"error\" \"\")(mode_tile \"next\" 0)(mode_tile \"write_list\" 0)(sel_word_ok)")
     (action_tile "write_list" "(mode_tile \"del\" 0)
                                (mode_tile \"mod\" 0)
                                (setq wdata (nth (atoi (get_tile \"write_list\")) (reverse write_list)))(set_tile \"moddata\" wdata)")
   );progn
 );if

 (action_tile "del" "(setq write_list (removelist wdata write_list))
                     (act_pop_list (reverse write_list) \"write_list\")
                     (set_tile \"moddata\" \"\")  ")
 (action_tile "mod" "(setq write_list (subst (get_tile \"moddata\") wdata write_list))(act_pop_list (reverse write_list) \"write_list\")")

 (action_tile "usetype" "(useword_usetype)")
 (action_tile "userdef" "(useword_userdef)")
 (action_tile "fit_type" "(fit_type_tile)")
 (action_tile "alldata" "(mode_tile \"write_list\" 0)(show_all_data)")

 (action_tile "accept" "(useword_ok)")
 (action_tile "cancel" "(done_dialog)")
 (start_dialog)
 (if (and (= nil get_wordlibdata) action_flag)
   (progn
     (setq text_style (getvar "textstyle")
           style_dat (cdr (assoc 3 (tblsearch "style" text_style))))
;    (if (= hor "1")
;      (progn
         (cond
           ((= "a" fit_type)
              (setq p1 (getpoint "\n選擇文字行第一點:"))
              (while (null p1)

                (setq p1 (getpoint "\n選擇文字行第一點:"))
              );while
              (setq p2 (getpoint p1 "\n選擇文字行第二點:"))
              (while (null p2)

                (setq p2 (getpoint p1 "\n選擇文字行第二點:"))
              );while
              (command "text" "j" fit_type p1 p2 write_data)
           )
           ((= "f" fit_type)
              (setq p1 (getpoint "\n選擇文字行第一點:"))
              (while (null p1)

                (setq p1 (getpoint "\n選擇文字行第一點:"))
              );while
              (setq p2 (getpoint p1 "\n選擇文字行第一點:"))

              (while (null p2)

                (setq p2 (getpoint p1 "\n選擇文字行第二點:"))
              );while
              (if (null write_list)
                (command "text" "j" fit_type p1 p2 height write_data)
                (progn
                  (setq ang (angle p1 p2))
                  (foreach nn write_list
                     (progn
                       (command "text" "j" fit_type p1 p2 height nn)
                       (setq height (cdr (assoc 40 (entget (entlast)))))
                       (setq p1 (polar p1 (+ (* 1.5 pi) ang) (* 1.62 height)))
                       (setq p2 (polar p2 (+ (* 1.5 pi) ang) (* 1.62 height)))
                     );progn
                  );foreach
                );progn
              )
           )
           (T (setq p1 (getpoint "\n文字書寫起點:"))
              (while (null p1)
                (setq p1 (getpoint "\n文字書寫起點:"))
              );while
              (if (null write_list)
                (progn
                   (if (= fit_type "s") (command "text" p1 height ang write_data)
                                        (command "text" "j" fit_type p1 height ang write_data))
                );progn
                (progn
                  (foreach nn write_list
                     (progn
                       (if (= fit_type "s") (command "text" p1 height ang nn)
                                            (command "text" "j" fit_type p1 height ang nn))
                       (setq height (cdr (assoc 40 (entget (entlast)))))
                       (setq ang (cdr (assoc 50 (entget (entlast)))))
                       (setq p1 (polar p1 (+ (* 1.5 pi) ang) (* 1.62 height)))
                     );progn
                  );foreach
                );progn
              );if
           )
         );cond
;      );progn
;    );if
     (princ)
   );progn
 );if
  ;; removed FFF
 (setvar "cmdecho" 1)
 (if get_wordlibdata
   (progn
     (setq get_wordlibdata nil)
     (cond
       ((= col 1) write_data)
       ((and (null write_list)(= col 2))(setq write_list (cons write_data  write_list)))
       ((= col 2) write_list)
     );cond
   );progn
   (prin1)
 );if
)


(defun creat_writedata_list()
   (setq write_list (cons (get_tile "data") write_list))
   (set_tile "data" "")
   (act_pop_list (reverse write_list) "write_list")
)

(defun search_mode()
 (actdcl "wordlib1" "search_mode")

 (action_tile "accept" "(done_dialog)")
 (start_dialog)
 (prin1)
)


(defun show_all_data()
  (mode_tile "word_list" 0)
  (creat_alldatalist)
  (act_pop_list alldata_list "word_list")
  (setq word_list alldata_list)

)
(defun fit_type_tile()
   (setq fg (get_tile "fit_type"))
   (cond
    ((= "3" fg) (mode_tile "height" 1) (mode_tile "angle" 1))
    ((= "5" fg) (mode_tile "height" 0) (mode_tile "angle" 1))
    (T  (mode_tile "height" 0) (mode_tile "angle" 0))
   )

)
(defun useword_userdef()
   (mode_tile "search_mode" 0)
   (mode_tile "search_kword" 2)
   (mode_tile "group_list" 1)
   (mode_tile "word_list" 1)
   (mode_tile "search_kword" 0)
   (mode_tile "exes" 0)
   (mode_tile "alldata" 0)
)
(defun useword_ok()
  (setq write_data (get_tile "data")
        fit_type   (get_tile "fit_type")
        ang        (get_tile "angle")
        height     (get_tile "height"))
;       column_h    (* 1.62 (atof height)))
;       hor        (get_tile "hor"))
  (cond
    ((= "0" fit_type) (setq fit_type "s"))
    ((= "1" fit_type) (setq fit_type "c"))
    ((= "2" fit_type) (setq fit_type "r"))
    ((= "3" fit_type) (setq fit_type "a"))
    ((= "4" fit_type) (setq fit_type "m"))
    ((= "5" fit_type) (setq fit_type "f"))
    ((= "6" fit_type) (setq fit_type "tl"))
    ((= "7" fit_type) (setq fit_type "tc"))
    ((= "8" fit_type) (setq fit_type "tr"))
    ((= "9" fit_type) (setq fit_type "ml"))
    ((= "10" fit_type) (setq fit_type "mc"))
    ((= "11" fit_type) (setq fit_type "mr"))
    ((= "12" fit_type) (setq fit_type "bl"))
    ((= "13" fit_type) (setq fit_type "bc"))
    ((= "14" fit_type) (setq fit_type "br"))
  )
  (cond
    ((and (null write_list)(or (= "" write_data) (null write_data)))
      (set_tile "error" "沒有選擇 \"分類內容\" 字串資料!!")
    );
    ((and (/= nil write_list) (= fit_type "a"))
      (set_tile "error" "選擇以對齊方式書寫時, 不可以多行書寫!")
    )
    (T
       (if (and (/= nil write_list) (/= "" write_data))
         (setq write_list (reverse (cons write_data write_list)))
         (setq write_list (reverse write_list))
       )
       (setq action_flag T)(done_dialog)
    );T
  );cond

)


(defun useword_usetype()
   (mode_tile "search_mode" 1)
   (mode_tile "group_list" 0)
   (mode_tile "word_list" 1)
   (mode_tile "search_kword" 1)
   (mode_tile "exes" 1)
;  (mode_tile "alldata" 1)

)



(defun sel_type_ok()
 (mode_tile "word_list" 0)
 (setq type_id (get_tile "group_list"))
 (setq type_name (nth (atoi type_id) type_list))
 (setq word_list (cdr (assoc type_name data_list)))
 (act_pop_list word_list "word_list")
 (if (/= nil write_list)(act_pop_list (reverse write_list) "write_list"))
)

(defun sel_word_ok()
 (setq old_word (get_tile "data"))
 (setq word_id (get_tile "word_list"))
 (setq input_word (nth (atoi word_id) word_list))
;(setq input_word (substr input_word 1 (- (get_word input_word " ") 1)))
 (setq input_word (getrealstr input_word))
 (set_tile "data" (strcat old_word input_word))
)



(defun useword_reset_tile()
     (mode_tile "exe_search_word" 1)
     (mode_tile "word_list" 1)
     (mode_tile "search_kword" 1)
     (mode_tile "exes" 1)
;    (mode_tile "alldata" 1)
     (mode_tile "search_mode" 1)
     (mode_tile "del" 1)
     (mode_tile "mod" 1)
)

;==============================================================================
;pub-lisp.lsp(get_word)

(defun pub_useword(old_str useword_keyname / no_done)
      (actdcl "wordlib1" "pub_use_word")
      (useword_reset_tile)
      (if (null useword_txth) (setq useword_txth (rtos (getvar "textsize") 2 2)))
      (set_tile "height" useword_txth)

      (setq type_list obj_list)

      (action_tile "search_mode" "(search_mode)")
      (action_tile "group_list" "(sel_type_ok)")
      (action_tile "word_list" "(sel_word_ok)")
      (action_tile "usetype" "(useword_usetype)")
      (action_tile "userdef" "(useword_userdef)")
      (action_tile "fit_type" "(fit_type_tile)")
      (action_tile "alldata" "(show_all_data)")
      (action_tile "exes" "(exe_search)")

      (action_tile "accept" "(return_word)")
      (action_tile "cancel" "(setq no_done t)(done_dialog)")
      (start_dialog)
      (if (/= no_done t)
        (progn
          (mode_tile useword_keyname 2)
          (set_tile useword_keyname (strcat old_str data))
        )
      )
 (princ)
)
(defun return_word()
  (setq data (get_tile "data"))
  (done_dialog)
)

(defun start_lib(val fg)
; (setq aaa val bbb fg)
  (if (or (= fg 1)(= fg 2))
    (progn
     (mode_tile "lib" 0)
     (set_tile "error" "")
    )
  )
)


(defun creat_wordlib_list(/ ff opff data title tdata)
   (setq ff (findfile (strcat word1_data_path "wordlib.dat")))
   (if ff
     (progn
        (setq type_list '() data_list '())
        (setq opff (open ff "r"))
        (setq data (read-line opff))
        (while data
           (if (/= "" data)
             (progn
               (setq data (read data))
               (setq type_list (cons (nth 0 data) type_list))
               (setq title (nth 0 data)
;                     tdata (acad_strlsort (cdr data)))
                     tdata (cdr data))
               (setq data_list (cons (cons title tdata) data_list))
             );progn
           );if
           (setq data (read-line opff))
        );while
        (close opff)

   ;    (setq data_list (acad_strlsort (reverse data_list)))
        (setq data_list (reverse data_list))
 ;      (setq type_list (acad_strlsort (reverse type_list)))
        (setq type_list (reverse type_list))
     );progn
     (princ (strcat "\n" (strcase word1_data_path "wordlib.dat") " 辭庫檔案不存在!"))
   );if
   (princ)
)
