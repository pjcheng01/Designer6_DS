;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 舊圖轉新圖(設定)                                     │
;;;│  主程式 : transheet.lsp                                        │
;;;│  日  期 : 2003/02/10                                           │
;;;│  姓  名 : 許勝瑜                                               │
;;;│  對話框 : transdwg.dcl                                        │
;;;│  方  法 : transheet                                            │
;;;│  相關檔案: system.ini transdwg.ini                            │
;;;└────────────────────────────────┘
;;;

(defun c:transdwg()
;(setq powdesign_ini_path (strcat powdesign_path "ini\\"))
;(setq powdesign_path "c:\\designer6\\")


(actdcl (strcat powdesign_dcl_path "transdwg.dcl") "transheet")

     ;;初始化
     (read_list 0)              ;;產生 #g_file_list #g_item_list 並(act_pop_list)在下拉選單
     (line_define)              ;;產生 #g_item1 #g_item2
     (setq #g_pop_id 0)         ;;設定 型式 STYLE 在第一筆
     (init_list)                ;;產生 #g_row_dat1 #g_row_dat2 #g_row_dat3 變數
     (str_list #g_pop_id 0)     ;;(act_pop_list "line_list")
     (str_list #g_pop_id 1)     ;;(act_pop_list "font_list")
     (str_list #g_pop_id 2)     ;;(act_pop_list "layer_list")
     (hide_button)              ;;淡化修改與刪除按鈕

(action_tile "ed_style"   "(ed_style)")
(action_tile "pop_style"  "(pop_style)")
(action_tile "line_list"  "(button 0)")
(action_tile "font_list"  "(button 1)")
(action_tile "layer_list" "(button 2)")
(action_tile "add_line"   "(tile_box 3 1)(xxx_xxxx 0 0)")
(action_tile "mod_line"   "(tile_box 4 1)(xxx_xxxx 1 0)")
(action_tile "del_line"   "(tile_box 5 1)(init_list)(str_list #g_pop_id 0)(hide_button)")
(action_tile "add_font"   "(tile_box 3 2)(xxx_xxxx 0 1)")
(action_tile "mod_font"   "(tile_box 4 2)(xxx_xxxx 1 1)")
(action_tile "del_font"   "(tile_box 5 2)(init_list)(str_list #g_pop_id 1)(hide_button)")
(action_tile "add_layer"  "(tile_box 3 3)(xxx_xxxx 0 2)")
(action_tile "mod_layer"  "(tile_box 4 3)(xxx_xxxx 1 2)")
(action_tile "del_layer"  "(tile_box 5 3)(init_list)(str_list #g_pop_id 2)(hide_button)")
(action_tile "accept"     "(done_dialog)")
(action_tile "cancel"     "(done_dialog)")
(start_dialog)
)
;;===============================================================
;; 切換型式 STYLE
(defun pop_style()
 (setq #g_pop_id (atoi (get_tile "pop_style")))
 (str_list #g_pop_id 0)
 (str_list #g_pop_id 1)
 (str_list #g_pop_id 2)
 (hide_button)
);defun
;;===============================================================
(defun hide_button()
 (mode_tile "mod_line" 1)
 (mode_tile "del_line" 1)
 (mode_tile "mod_font" 1)
 (mode_tile "del_font" 1)
 (mode_tile "mod_layer" 1)
 (mode_tile "del_layer" 1)
);defun
;;===============================================================
;;CALL_DCL STYLE
(defun ed_style(/ ~get_lock)
 (setq ~get_lock (get_tile "pop_style"))
 (actdcl (strcat powdesign_dcl_path "transdwg.dcl") "ed_style")
 (read_list 1)
 (st_button 1)
 (action_tile "style_list" "(st_button 0)")
 (action_tile "add_style"  "(tile_box 0 0)(xxx_style 0)")
 (action_tile "mod_style"  "(tile_box 1 0)(xxx_style 1)")
 (action_tile "del_style"  "(tile_box 2 0)(read_list 1)(st_button 1)")
 (action_tile "accept" "(done_dialog)(read_list 0)(set_tile \"pop_style\" ~get_lock)")
 (start_dialog)
)
(defun st_button(~flag)
      (mode_tile "mod_style" ~flag)
      (mode_tile "del_style" ~flag)
)
;=================================================================
(defun button(~id / ~dcl_list ~i ~flag)
   (setq ~dcl_list '("line" "font" "layer"))
        (if (/= 0 ~id)(str_list #g_pop_id 0))
        (if (/= 1 ~id)(str_list #g_pop_id 1))
        (if (/= 2 ~id)(str_list #g_pop_id 2))
   (setq ~i 0)
   (repeat 3
        (if (= ~i ~id)(setq ~flag 0)(setq ~flag 1))
        (mode_tile (strcat "mod_" (nth ~i ~dcl_list)) ~flag)
        (mode_tile (strcat "del_" (nth ~i ~dcl_list)) ~flag)
        (setq ~i (1+ ~i))
   );repeat
);defun
;;================================================================
;;CALL_DCL XXX_XXXX XXX=ADD,MOD  XXXX=LINE,FONT,LAYER
(defun xxx_xxxx(~mode ~prop / ~prop_name ~dialog_name)
    (setq #g_mode ~mode)    ;;判斷按鈕是 新增或修改 0 1
    (setq #g_prop ~prop)    ;;判斷是 線型 字型 圖層 0 1 2

    (setq ~prop_name (nth #g_prop '("LineType" "Font" "Layer")))
    (setq ~dialog_name (nth #g_mode (nth ~prop '(("add_line" "mod_line")("add_font" "mod_font")("add_layer" "mod_layer")))))
    (actdcl (strcat powdesign_dcl_path "transdwg.dcl") ~dialog_name)
    (if (= 0 ~prop) (progn (line_define)(act_pop_list #g_item1 "new_dat")))
    (if (and (= 0 ~prop)(= 1 ~mode)) (setq #g_Init_new (get_sublist_num #g_item2 #g_Init_new)))
    (set_tile "old_dat" #g_Init_old)                         ;;在(xxx_xxxx)之前的(tile_box)會產生 #g_Init_old #g_Init_new
    (set_tile "new_dat" #g_Init_new)                         ;;新增 變數是 "" 修改會 (get_tile)
    (action_tile "accept" "(write_xx ~prop_name)(done_dialog)(init_list)(str_list #g_pop_id ~prop)(hide_button)")
    (start_dialog)
    (if (/= "" gstr_see)(alert gstr_see))
);defun
;;================================================================
;;CALL_DCL ADD_STYLE MOD_STYLE DEL_STYLE
(defun xxx_style(~mode / ~dialog_name)
    (setq #g_mode ~mode)

    (setq ~dialog_name (nth #g_mode '("add_style" "mod_style" "del_style")))
    (actdcl (strcat powdesign_dcl_path "transdwg.dcl") ~dialog_name)
    (set_tile "xxx_st" #g_Init_Tile)
    (action_tile "accept" "(write_st)(done_dialog)(read_list 1)(st_button 1)") ;;有(act_pop_list)函式必須在(done_dialog)之後
    (start_dialog)
);defun
;;================================================================
;;FUNCTION 讀取顯示 STYLE 有哪些型式 或 更新 STYLE LIST 動作
(defun read_list(~ch / ~item ~items ~n ~KS)
    (setq ~items '())
    (setq #g_item_list '())
    (setq #g_file_list '())
    (setq #g_file_list (readfile_tolist (strcat powdesign_ini_path "transdwg.ini")))
    (setq ~n 0)
    (repeat (length #g_file_list)       
            (setq ~item (nth 0 (nth ~n #g_file_list)))
            (setq ~items (cons ~item ~items))
            (setq ~n (1+ ~n))
    );repeat
    (setq ~n 0)
    (repeat (length ~items)
            (setq ~KS (nth ~n ~items))
            (if (= nil (member ~KS #g_item_list))
                (setq #g_item_list (cons ~KS #g_item_list))
            );if
            (setq ~n (1+ ~n))
    );repeat
    (if (= 0 ~ch)
        (act_pop_list #g_item_list "pop_style")
        (act_pop_list #g_item_list "style_list")
    );if
);defun
;;================================================================
;;FUNCTION 檢查資料寫入文字檔 STYLE
(defun write_st(/ ~st_indat ~flag ~source ~row_id)
    (setq ~st_indat (strcase (get_tile "xxx_st")))
    (setq ~flag (check_item #g_file_list ~st_indat))
    (if (= 0 ~flag)
        (progn
            (cond ((= 0 #g_mode)
                   (setq ~source (list (list ~st_indat "LineType")(list ~st_indat "Font")(list ~st_indat "Layer")))
                   (file_dataset ~source nil nil nil 0)
                  )
                  ((= 1 #g_mode)
                   (setq ~row_id (* #g_Init_val 3))
                       (repeat 3
                            (file_dataset ~st_indat ~row_id 0 nil 2)
                            (setq ~row_id (1+ ~row_id))
                       );repeat
                  )
            );cond
        );progn
    );if
);defun
;;================================================================
;;FUNCTION 檢查資料寫入文字檔 LTYPE FONT LAYER
(defun write_xx(~prop_name / ~old_dat ~new_dat ~itm_dat ~row_num ~pop_dat ~flag ~oflag ~nflag)

    (setq ~old_dat (strcase (get_tile "old_dat")))
    (setq ~new_dat (strcase (get_tile "new_dat")))
    (if (= "LineType" ~prop_name)(setq ~new_dat (nth (atoi ~new_dat) #g_item2)))
    (setq ~itm_dat (list ~old_dat ~new_dat))          ;將舊資料項與新資料項合成串列   Ex:("dash" "虛線")
    (setq ~row_num (+ (* #g_pop_id 3) #g_prop))       ;計算修改的項目是在檔案的第幾列
    (setq ~pop_dat (nth #g_pop_id #g_item_list))

    (setq #g_file_list (readfile_tolist (strcat powdesign_ini_path "transdwg.ini")))
    (setq ~flag (check_data #g_file_list ~itm_dat ~pop_dat ~prop_name))
   
    (if (or (= "" ~old_dat)(= "" ~new_dat))(setq ~flag 1))
    (if (= 0 ~flag)
        (progn
            (cond ((= 0 #g_mode)
                   (file_dataset ~itm_dat ~row_num nil nil 5)
                  )
                  ((= 1 #g_mode)
                   (setq ~col_num (+ #g_Init_val 2))
                   (file_dataset ~itm_dat ~row_num ~col_num nil 2)
                  )
            );cond
        );progn
    );if
);defun
;;================================================================
;; FUNCTION LIST_BOX ID 轉字串進對話框(新增,修改) 或 刪除項目
(defun tile_box(~id ~key / ~list_name ~id ~row_num ~col_num)
     (setq ~list_name (nth ~key '("style_list" "line_list" "font_list" "layer_list")))
     (cond ((= 0 ~id)
            (setq #g_Init_Tile "")
           )
           ((= 1 ~id)
            (setq #g_Init_Tile (get_tile ~list_name))
            (setq #g_Init_val (atoi #g_Init_Tile))
            (setq #g_Init_Tile (nth #g_Init_val #g_item_list))
           )
           ((= 2 ~id)
            (setq #g_Init_val (atoi (get_tile ~list_name)))
            (file_dataset nil #g_Init_val nil nil 4)
           )
           ((= 3 ~id)
            (setq #g_Init_old "")
            (setq #g_Init_new "")
           )
           ((= 4 ~id)
            (setq #g_Init_val (atoi (get_tile ~list_name)))
                (if (= "line_list" ~list_name)
                    (progn
                       (setq #g_Init_old (nth 0 (nth #g_Init_val (nth #g_pop_id #g_row_dat1))))
                       (setq #g_Init_new (nth 1 (nth #g_Init_val (nth #g_pop_id #g_row_dat1))))
                    ));progn
                (if (= "font_list" ~list_name)
                    (progn
                       (setq #g_Init_old (nth 0 (nth #g_Init_val (nth #g_pop_id #g_row_dat2))))
                       (setq #g_Init_new (nth 1 (nth #g_Init_val (nth #g_pop_id #g_row_dat2))))
                    ));progn
                (if (= "layer_list" ~list_name)
                    (progn
                       (setq #g_Init_old (nth 0 (nth #g_Init_val (nth #g_pop_id #g_row_dat3))))
                       (setq #g_Init_new (nth 1 (nth #g_Init_val (nth #g_pop_id #g_row_dat3))))
                    ));progn
           )
           ((= 5 ~id)
            (setq ~row_num (+ (* #g_pop_id 3) (- ~key 1)))
            (setq ~col_num (+ (atoi (get_tile ~list_name)) 2))
            (file_dataset nil ~row_num ~col_num nil 6)
           )
     );cond
     (if (= 3 ~id)(setq gint_mode 0))
     (if (= 4 ~id)(setq gint_mode 1))
     (if (= 5 ~id)(setq gint_mode 2))
);defun
;;================================================================
;; FUNCTION INIT_SHOW LIST
(defun init_list(/ ~row_dat1 ~row_dat2 ~row_dat3
                   ~g_file_list ~ns ~value ~row_temp)

    (setq ~g_file_list (readfile_tolist (strcat powdesign_ini_path "transdwg.ini")))
    (setq ~ns 0)
    (repeat (length ~g_file_list)
            (setq ~value (rem ~ns 3)) ;;取餘數 0 = 線型 1 = 字型 2 = 圖層
            (cond ((= 0 ~value)
                   (setq ~row_temp (cdr (cdr (nth ~ns ~g_file_list))))
                   (setq ~row_dat1 (cons ~row_temp ~row_dat1))
                  )
                  ((= 1 ~value)
                   (setq ~row_temp (cdr (cdr (nth ~ns ~g_file_list))))
                   (setq ~row_dat2 (cons ~row_temp ~row_dat2))
                  )
                  ((= 2 ~value)
                   (setq ~row_temp (cdr (cdr (nth ~ns ~g_file_list))))
                   (setq ~row_dat3 (cons ~row_temp ~row_dat3))
                  )
            );cond
            (setq ~ns (1+ ~ns))
    );repeat
    (setq #g_row_dat1 (reverse ~row_dat1))
    (setq #g_row_dat2 (reverse ~row_dat2))
    (setq #g_row_dat3 (reverse ~row_dat3))
);defun
;;================================================================
;; SUB FUNCTION
(defun str_list(~pop ~id / ~row_data ~ns ~row_item ~old_xx ~new_xx
                           ~all_item ~all_list ~dcl_list ~trans_id)
    (if (= 0 ~id)(setq ~row_data #g_row_dat1))
    (if (= 1 ~id)(setq ~row_data #g_row_dat2))
    (if (= 2 ~id)(setq ~row_data #g_row_dat3))
    (setq ~ns 0)
    (repeat (length (nth ~pop ~row_data))
            (setq ~row_item (nth ~ns (nth ~pop ~row_data)))
            (setq ~old_xx   (nth 0 ~row_item))
            (setq ~new_xx   (nth 1 ~row_item))
            (if (= 0 ~id)                                                      ;假如是 line_list
                (progn                                                         ;變數 #g_item1-->中文,#g_item2-->英文
                    (setq trans_id  (atoi (get_sublist_num #g_item2 ~new_xx))) ;將設定值對照英文變數取得ID
                    (setq ~new_xx   (nth trans_id #g_item1))                   ;取出中文變數中的ID項
                );progn
            );if
            (setq ~old_xx   (strcat ~old_xx (col_tab (- 12 (strlen ~old_xx)))))
            (setq ~all_item (strcat (strcat ~old_xx "→  ") ~new_xx))
            (setq ~all_list (cons ~all_item ~all_list))
            (setq ~ns (1+ ~ns))
    );repeat
    (setq ~all_list (reverse ~all_list))
    (setq ~dcl_list '("line_list" "font_list" "layer_list"))
    (act_pop_list ~all_list (nth ~id ~dcl_list))
);defun
;;================================================================
;;
(defun line_define(/ ~line_def ~num ~data1 ~data2 ~item1 ~item2)
(setq ~line_def (read (getfile_val (strcat powdesign_path "system.ini") "線性定義")))
    (setq ~num 0)
    (repeat (length ~line_def)
            (setq ~data1 (nth 0 (nth ~num ~line_def)))
            (setq ~data2 (nth 1 (nth ~num ~line_def)))
            (setq ~item1 (cons ~data1 ~item1))
            (setq ~item2 (cons ~data2 ~item2))
            (setq ~num (+ ~num 1))
    );repeat
    (setq #g_item1 (reverse ~item1))  ;線型中文名稱   Ex:("粗連續線" "標準中心線" "剖面線")
    (setq #g_item2 (reverse ~item2))  ;線型英文名稱   Ex:("Continuous" "CENTER"    "HATCH")
);defun
;;================================================================
;; SUB FUNCTION 檢查輸入資料有無重複
;; check_data() 檢查有無重複 "LineType" "Font" "Layer" 之各個子資料項(不含 "")
;; check_item() 檢查有無重複 型式 "Style" 及 ""
;; ~flag = 0 無重複資料
;; ~flag = 1 有重複資料
;;(defun c:ckfile()
;;   (setq list_aaa '(("AA" "LineType" ("oldlt" "粗連續線")("dash" "標準虛線")("item" "王八線"))
;;                    ("AA" "Font" ("romans" "txt")("isocp" "txt"))
;;                    ("BB" "LineType" ("line" "粗連續線")("cet" "標準中心線"))
;;                    ("BB" "Font" ("txt" "romans")("isocp" "romans"))))
;;   (setq ~value (check_data list_aaa "testt" "AA" "Layer"))
;;   (setq ~value (check_item list_aaa "AA"))
;;   (princ ~value)
;;);TEST FUNCTION
;;
(defun check_data(list_dat itm_dat primary slave / ~flag)
	(setq lst_iold '())
  	(setq lst_inew '())
  
  	(setq int_idx 0)
	(repeat (length list_dat)
	  	(if (= primary (car (nth int_idx list_dat)))
		    (if (= slave (cadr (nth int_idx list_dat)))(setq ~main_list (cdr (cdr (nth int_idx list_dat)))))
		)
	  	(setq int_idx (1+ int_idx))
	)
  	(setq int_idx 0)
  	(if (/= nil ~main_list)(progn
		(repeat (length ~main_list)
		  	(setq str_item1 (nth 0 (nth int_idx ~main_list)))
			(setq str_item2 (nth 1 (nth int_idx ~main_list)))
		  	(setq lst_iold (cons str_item1 lst_iold))
		  	(setq lst_inew (cons str_item2 lst_inew))
		  	(setq int_idx (1+ int_idx)))
		(setq lst_iold (reverse lst_iold))
		(setq lst_inew (reverse lst_inew)))
	)
  	(setq str_chk1 (nth 0 itm_dat))
  	(setq str_chk2 (nth 1 itm_dat))
  	(cond ((and (= "" str_chk1)(= "" str_chk2))(setq ~flag 0))
	      ((and (= "LineType" slave)(= "BYLAYER" str_chk1))(setq gstr_see "無效的設定:BYLAYER"))
	      ((= str_chk1 str_chk2)(setq gstr_see "新舊項目不能一樣")(setq ~flag 1))
	      ((and (= 0 gint_mode)(member str_chk1 lst_iold))(setq gstr_see "舊項目不能重複")(setq ~flag 1))
	      ((and (= 0 gint_mode)(member str_chk1 lst_inew))(setq gstr_see "設定重覆作業,請檢查設定資料")(setq ~flag 1))
	      ((and (= 0 gint_mode)(member str_chk2 lst_iold))(setq gstr_see "設定重覆作業,請檢查設定資料")(setq ~flag 1))
	      ((and (= 1 gint_mode)(member str_chk2 lst_iold))(setq gstr_see "設定重覆作業,請檢查設定資料")(setq ~flag 1))
	      ((and (= 1 gint_mode)(member str_chk1 lst_inew))(setq gstr_see "設定重覆作業,請檢查設定資料")(setq ~flag 1))
	      (t (setq gstr_see "")(setq ~flag 0))
	)
	(eval ~flag)
)

(defun check_item(list_dat primary / ~flag)
         (setq ~flag 0)
         (if (= "" (getrealstr primary))(setq ~flag 1))
         (if (/= nil (assoc primary list_dat))
             (setq ~flag 1)
         );if
         (eval ~flag)
);defun
;;==================================================================
;; SUB FUNCTION 新增,修改,刪除 後寫入文字檔
;; 模式
;; 0 新增   N 列
;; 1 修改第 N 列
;; 2 修改第 N 列,第 N 項
;; 3 修改第 N 列,第 N 項串列的子項
;; 4 刪除第 N 列 -- 三列一筆資料
;; 5 在  第 N 列,新增一項
;; 6 在  第 N 列,刪除一項
;;Ex:(file_dataset "TEXT" 3 2 0 3)
;;   (file_dataset '("TEXT" "BOX") 2 3 nil 2)

(defun file_dataset(new_dat row_num col_num itm_num mode
                    / ~file_pipe ~data_list ~i ~temp ~data_rdat
                    ~data_cdat ~data_temp ~data_sdat ~data_tems ~row_id1 ~row_id2)
    (setq ~data_list '())
    (setq ~data_list (readfile_tolist (strcat powdesign_ini_path "transdwg.ini")))
    (cond ((= 0 mode)
           (setq ~i 0)
           (repeat (length new_dat)
                   (setq ~temp (nth ~i new_dat))
                   (setq ~data_list (reverse ~data_list))
                   (setq ~data_list (cons ~temp ~data_list))
                   (setq ~data_list (reverse ~data_list))
                   (setq ~i (1+ ~i))
           );repeat
          )
          ((= 1 mode)
           (setq ~data_rdat (nth row_num ~data_list))
           (setq ~data_list (subst new_dat ~data_rdat ~data_list))
          )
          ((= 2 mode)
           (setq ~data_rdat (nth row_num ~data_list))
           (setq ~data_cdat (nth col_num ~data_rdat))
           (setq ~data_temp (subst new_dat ~data_cdat ~data_rdat))
           (setq ~data_list (subst ~data_temp ~data_rdat ~data_list))
          )
          ((= 3 mode)
           (setq ~data_rdat (nth row_num ~data_list))
           (setq ~data_cdat (nth col_num ~data_rdat))
           (setq ~data_sdat (nth itm_num ~data_cdat))
           (setq ~data_temp (subst new_dat ~data_sdat ~data_cdat))
           (setq ~data_tems (subst ~data_temp ~data_cdat ~data_rdat))
           (setq ~data_list (subst ~data_tems ~data_rdat ~data_list))
          )
          ((= 4 mode)
           (setq ~row_id1 (* row_num 3))
           (setq ~row_id2 (+ ~row_id1 2))
           (setq ~data_temp (getfrontelist ~row_id1 ~data_list))
           (setq ~data_tems (getbacklist   ~row_id2 ~data_list))
           (setq ~data_list (append ~data_temp ~data_tems))
          )
          ((= 5 mode)
           (setq ~data_rdat (nth row_num ~data_list))
           (setq ~data_temp (reverse ~data_rdat))
           (setq ~data_temp (cons new_dat ~data_temp))
           (setq ~data_cdat (reverse ~data_temp))
           (setq ~data_list (subst ~data_cdat ~data_rdat ~data_list))
          )
          ((= 6 mode)
           (setq ~data_rdat (nth row_num ~data_list))
           (setq ~data_temp (getfrontelist col_num ~data_rdat))
           (setq ~data_tems (getbacklist   col_num ~data_rdat))
           (setq ~data_cdat (append ~data_temp ~data_tems))
           (setq ~data_list (subst ~data_cdat ~data_rdat ~data_list))
          )
    );cond
    ;-----------------------------------------------------
    (setq ~file_pipe (open (strcat powdesign_ini_path "transdwg.ini") "w"))
    (setq ~i 0)
    (repeat (length ~data_list)
        (prin1 (nth ~i ~data_list) ~file_pipe)
        (princ "\n" ~file_pipe)
        (setq ~i (1+ ~i))
    );repeat
    (close ~file_pipe)
);defun

(defun *error*(msg)
	(princ)
)
