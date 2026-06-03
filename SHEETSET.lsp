;;;
;;;╭════════════════════════════════════════════╮
;;;║設計日期: 2001. 2. 09                                                                   ║
;;;║更新日期:                                                                               ║
;;;║設 計 者: 佘宗紋                                                                        ║
;;;║功能說明: 設定符合機械設計家之圖框                                                      ║
;;;║執行方式:                                                                               ║
;;;║相關檔案:pub-lisp.lsp  wordlib1.lsp command.lsp                                         ║
;;;║注意事項:適用於圖框與屬性位於同一張圖面上且屬性為非 BLOCK 之情況下                      ║
;;;╰════════════════════════════════════════════╯
(defun c:sheetset(/ flag attflag i id attgrp logo_list txt_list lib_list code_list total_list shty name size hwid vwid filename)
       (setvar "cmdecho" 0)
       ;; 已移除加密狗判斷
       (progn ;; DraftSight: 移除加密狗 WHILE 迴圈
              (alert "請先確認圖框檔案(包含圖框與屬性)已開啟 ! 且屬性為非 BLOCK")
              (setq attflag "0" flag "start" i 0 logo_list '() txt_list '() id nil lib_list '() code_list '() logo_maxlen 0 txt_maxlen 0 total_list '())
              (setq tcode_list (list "" "檔名(F)" "日期(D)" "比例(S)"))
              (setq filename (curdwgname))
              (setq attgrp (ssget "x" '((0 . "ATTDEF"))))
              (if attgrp
                  (repeat (sslength attgrp)
                          (setq logo_list (cons (setq logo(cdr (assoc 2 (entget (ssname attgrp i))))) logo_list))
                          (setq txt_list (cons (setq txt(cdr (assoc 3 (entget (ssname attgrp i))))) txt_list))
                          (setq lib_list (cons "" lib_list))
                          (setq code_list (cons "" code_list))
                          (setq total_list(cons (strcat logo (col_tab (- 14 (strlen logo))) txt (col_tab (- 26 (strlen txt)))) total_list))
           ;               (if (> (strlen logo) logo_maxlen)(setq logo_maxlen (strlen logo)))
           ;               (if (> (strlen txt) txt_maxlen)(setq txt_maxlen (strlen txt)))
                          (setq i (+ i 1))
                  );repeat
              );if
              (setq logo_list(reverse logo_list))
              (setq txt_list(reverse txt_list))
              (setq total_list(reverse total_list))

              (read_shdata_sheetset)

              (get_totallib_sheetset)

              (sheetset_main)

              (SETQ FFF nil)
      );while
      (princ)
);defun

;;取出詞庫分類
(defun get_totallib_sheetset( / ff data)
              (setq  tlib_list (list ""))
              (setq ff (open (strcat word1_data_path "wordlib.dat") "r"))
              (setq data(read-line ff))
              (while (/= nil data)
                     (setq tlib_list(cons (nth 0 (read data)) tlib_list))
                     (setq data (read-line ff))
              );while
              (close ff)
              (setq tlib_list(reverse tlib_list))
);defun

;;主程式  flag="start" 程式啟動時  flag="sel_wid" 點取水平垂直鈕回覆時
(defun sheetset_main( / p1 p2 dist sel_flag lib_id num nameflag filenameflag shtyflag)

              (setq p1 nil p2 nil dist nil sel_flag nil lib_id nil nameflag nil filenameflag nil shtyflag nil func T)

              (actdcl (strcat powdesign_dcl_path "sheetset") "sheetset")

              (set_tile "path" (strcat powdesign_path "SHEET\\"))
              (set_tile "filename" filename)


              (mode_tile "e_logo" 1)(mode_tile "mod" 1)
              (mode_tile "up" 1)(mode_tile "down" 1)
              (mode_tile "path" 1)

              (act_pop_list total_list "tolist")
              (act_pop_list tlib_list "e_lib")
              (act_pop_list tcode_list "e_code")

              (if (= flag "sel_wid")
                  (progn
                        (set_tile "shty" shty)
                        (set_tile "name" name)
                        (set_tile "size" size)
                        (set_tile "hwid" hwid)
                        (set_tile "vwid" vwid)
                        (set_tile "nonatt" attflag)
                        (set_tile "tolist" id)
                        (if (/= "" id) (action_count_sheetset id))      ;(上)此兩行順序不可對調
                        (if (= "1" attflag) (action_nonatt_sheetset))   ;(下)此兩行順序不可對調
                  );progn
              );if

           ;   (act_pop_list logo_list "logo")
           ;   (act_pop_list txt_list "txt")
           ;   (act_pop_list lib_list "lib")
           ;   (act_pop_list code_list "code")

              (action_tile "shty"  "(setq lib_id 1)")
              (action_tile "name"  "(setq lib_id 2)")
              (action_tile "size"  "(setq lib_id 3)")
              (action_tile "e_txt" "(setq lib_id 4)")

              (action_tile "nonatt" "(setq attflag $value)(action_nonatt_sheetset)")

              (action_tile "tolist" "(setq id $value)(action_count_sheetset id)")
           ;   (action_tile "logo" "(setq id $value)(action_count_sheetset id \"logo\")")
           ;   (action_tile "txt"  "(setq id $value)(action_count_sheetset id \"txt\")")
           ;   (action_tile "lib"  "(setq id $value)(action_count_sheetset id \"lib\")")
           ;   (action_tile "code" "(setq id $value)(action_count_sheetset id \"code\")")

              (action_tile "sel_shty"  "(action_sel_shty_sheetset)")
              (action_tile "cal_hwid"  "(setq flag \"sel_wid\" sel_flag \"h\")(action_cal_hwid_vwid_sheetset)")
              (action_tile "cal_vwid"  "(setq flag \"sel_wid\" sel_flag \"v\")(action_cal_hwid_vwid_sheetset)")

              (action_tile "mod"  "(action_mod_sheetset id)")
              (action_tile "up"   "(action_up_down_sheetset (- (atoi id) 1) (atoi id) (- (atoi id) 1))")
              (action_tile "down" "(action_up_down_sheetset (atoi id) (+ (atoi id) 1) (+ (atoi id) 1))")

              (action_tile "creatlib"  "(action_creatlib_sheetset)")
              (action_tile "uselib"  "(action_uselib_sheetset)")

              (action_tile "accept" "(setq func T flag \"start\")(action_accept_sheetset)")

              (action_tile "cancel" "(setq func nil flag nil)(done_dialog)")
              (start_dialog)

              (cond
                    ((and func (= flag "sel_wid"))
                               (while (null p1)
                                      (setq p1(getpoint "\n第一點 : "))
                               );while
                               (while (null p2)
                                      (setq p2(getpoint p1 "\n第二點 : "))
                               );while
                               (setq dist(distance p1 p2))
                               (cond
                                     ((= "h" sel_flag)(setq hwid (rtos dist 2 0)))
                                     ((= "v" sel_flag)(setq vwid (rtos dist 2 0)))
                               );cond
                               (sheetset_main)
                    )
                    ((and func (= flag "start") (member shty sheet_type))
                               (setq num 1 name_list '() shtyflag T)
                               (setq shdata_list(assoc shty sheet_typelist))
                               (repeat (- (length shdata_list) 1)
                                       (setq name_list(cons (strcase(nth 0 (nth num shdata_list))) name_list))
                                       (setq num (+ num 1))
                               );repeat
                               (if (member (strcase name) name_list)
                                   (progn
                                        (setq nameflag (show_message_sheetset "AutoCAD 訊息" "圖紙名稱已存在 , 是否覆蓋 ? 若要覆蓋請按<確定> , 若不要覆蓋請按<取消>"))
                                        (if (null nameflag)
                                            (sheetset_main)
                                            (if (findfile (strcat powdesign_path "SHEET\\" filename ".dwg"))
                                                (progn
                                                     (setq filenameflag (show_message_sheetset "AutoCAD 訊息" "圖檔已存在 , 是否覆蓋 ? 若要覆蓋請按<確定> , 若不要覆蓋請按<取消>"))
                                                     (if (null filenameflag)
                                                         (sheetset_main)
                                                         (rewrite_inidata_sheetset 2 2)
                                                     );if
                                                );progn
                                                (rewrite_inidata_sheetset 2 1)
                                            );if
                                        ):if
                                   );progn
                                   (if (findfile (strcat powdesign_path "SHEET\\" filename ".dwg"))
                                       (progn
                                             (setq filenameflag (show_message_sheetset "AutoCAD 訊息" "圖檔已存在 , 是否覆蓋 ? 若要覆蓋請按<確定> , 若不要覆蓋請按<取消>"))
                                             (if (null filenameflag)
                                                 (sheetset_main)
                                                 (rewrite_inidata_sheetset 1 2)
                                             ):if
                                       );progn
                                       (rewrite_inidata_sheetset 1 1)
                                   );if
                               );if
                    )
                    ((and func (= flag "start") (findfile (strcat powdesign_path "SHEET\\" filename ".dwg")))
                               (setq filenameflag (show_message_sheetset "AutoCAD 訊息" "圖檔已存在 , 是否覆蓋 ? 若要覆蓋請按<確定> , 若不要覆蓋請按<取消>"))
                               (if (null filenameflag)
                                   (sheetset_main)
                                   (rewrite_inidata_sheetset 3 2)
                               ):if
                    )
                    ((null func)
                     (princ)
                    )
                    (t
                               (rewrite_inidata_sheetset 3 1)
                    );t
              );cond

);defun

;;;重寫 shscal.ini   ty1=1 ;圖框種類已存在但名稱未存在   ty1=2 ;圖框種類名稱已存在加以覆蓋
;;;                  ty1=3 ;圖框種類未存在
;;;                  ty2=1 ;檔案未存在   ty1=2 ;檔案已存在加以覆蓋

(defun rewrite_inidata_sheetset(ty1 ty2 / ff gg txt count $path i shfg)
              (setq i 1 $path "" shfg nil)
              (repeat (strlen path)
                      (setq $path(strcat $path (substr path i 1)))
                      (if (= "\\" (substr path i 1))(setq $path(strcat $path "\\")))
                      (setq i (+ i 1))
              );repeat
              (if (= "1" attflag)
                  (setq txt(strcat "(\"" name "\" \"" size "\" \"" $path filename "\" (" hwid " " vwid ") \"\" \"\")"))
                  (progn
                        (setq txt(strcat "(\"" name "\" \"" size "\" \"" $path filename "\" (" hwid " " vwid ") (" ))
                        (setq count 0)
                        (repeat (length total_list)

                                (setq txt(strcat txt "(\"" (nth count logo_list) "\" \"" (nth count txt_list) "\""))
                                (if (/= "" (nth count lib_list))
                                    (setq txt (strcat txt " \"" (nth count lib_list) "\""))
                                    (setq txt (strcat txt " \"\""))
                                );if
                                (if (/= "" (nth count code_list))
                                    (setq txt (strcat txt " \"" (substr (nth count code_list) (- (strlen (nth count code_list)) 1) 1) "\""))
                                );if
                                (setq txt(strcat txt ")"))
                                (setq count (+ count 1))
                        );repeat
                        (setq txt(strcat txt ") \"" (itoa (length total_list)) "\" \"SCALE\")"))
                  );progn
              );if
              (setq ff (open (strcat powdesign_path "shscal.ini") "r"))
              (setq gg (open (strcat powdesign_path "$shscal.ini") "w"))
              (setq ffdata(read-line ff))
              (while ffdata
                     (write-line ffdata gg)
                     (setq ffdata(read-line ff))
              );while
              (close ff)
              (close gg)
              (cond
                   ((= ty1 1)
                        (setq ff (open (strcat powdesign_path "$shscal.ini") "r"))
                        (setq gg (open (strcat powdesign_path "shscal.ini") "w"))
                        (setq ffdata(read-line ff))
                        (while ffdata
                               (write-line ffdata gg)
                               (if (=  ffdata (strcat "**" shty))(write-line txt gg))
                               (setq ffdata(read-line ff))
                        );while
                        (close ff)
                        (close gg)
                   )
                   ((= ty1 2)
                        (setq ff (open (strcat powdesign_path "$shscal.ini") "r"))
                        (setq gg (open (strcat powdesign_path "shscal.ini") "w"))
                        (setq ffdata(read-line ff))
                        (while ffdata
                               (if (= shfg 1)
                                   (if (= (strcase (nth 0 (read ffdata))) (strcase name1))
                                       (progn(write-line txt gg)(setq shfg nil))
                                       (write-line ffdata gg)
                                   );if
                                   (write-line ffdata gg)
                               );if
                               (if (=  ffdata (strcat "**" shty))(setq shfg 1))
                               (setq ffdata(read-line ff))
                        );while
                        (close ff)
                        (close gg)
                   )
                   (t
                        (setq ff (open (strcat powdesign_path "$shscal.ini") "r"))
                        (setq gg (open (strcat powdesign_path "shscal.ini") "w"))
                        (setq ffdata(read-line ff))
                        (while ffdata
                               (setq ffdata1 ffdata)
                               (write-line ffdata gg)
                               (setq ffdata(read-line ff))
                               (if (and (= "" ffdata1) (= "" ffdata))(setq ffdata nil))
                        );while
                        (close ff)
                               (write-line (strcat "**" shty) gg)
                               (write-line txt gg)
                               (write-line "" gg)
                        (close gg)
                   )
              );cond
              (cond
                   ((= ty2 1)
                        (command "purge" "a" "*" "n")
                        (while (null p1)(setq p1 (getpoint "\n基準點 :")))
                        (if (/= "1" attflag)
                            (if (findfile (strcat path filename "tzt.dwg"))
                                (command "wblock" (strcat path filename "tzt.dwg") "y" "" p1 attgrp "")
                                (command "wblock" (strcat path filename "tzt.dwg") "" p1 attgrp "")
                            );if
                        );if
                        (command "purge" "a" "*" "n")
                        (command "wblock" (strcat path filename) "" p1 "all" "")
                   )
                   ((= ty2 2)
                        (command "purge" "a" "*" "n")
                        (while (null p1)(setq p1 (getpoint "\n基準點 :")))
                        (if (/= "1" attflag)
                            (if (findfile (strcat path filename "tzt.dwg"))
                                (command "wblock" (strcat path filename "tzt") "y" "" p1 attgrp "")
                                (command "wblock" (strcat path filename "tzt") "" p1 attgrp "")
                            );if
                        );if
                        (command "purge" "a" "*" "n")
                        (command "wblock" (strcat path filename) "y" "" p1 "all" "")

                   )
                   (t (princ))
              );cond
);defun


(defun show_message_sheetset(title txt / funct)
              (setq funct nil)
              (actdcl (strcat powdesign_dcl_path "sheetset") "message")
              (set_tile "title" title)
              (set_tile "txt" txt)
              (action_tile "accept" "(setq funct T)(done_dialog)")
              (action_tile "cancel" "(setq funct nil)(done_dialog)")

              (start_dialog)

              (if (null funct)
                  (setq flag "sel_wid")
              );if
              funct
);

;;點取圖框種類鈕 (button)
(defun action_sel_shty_sheetset(/ funct selsh)
              (setq funct nil)
              (actdcl (strcat powdesign_dcl_path "sheetset") "shty")

              (act_pop_list sheet_type "shty")

              (action_tile "accept" "(setq funct T)(get_shty_action_sel_shty)")
              (action_tile "cancel" "(setq funct nil)(done_dialog)")

              (start_dialog)

              (if funct
                  (set_tile "shty" selsh)
              );if
);defun
(defun get_shty_action_sel_shty(/ shid)

           (setq shid(get_tile "shty") selsh nil)
           (if (= "" shid)
               (set_tile "error" "圖框種類未選取 !")
               (progn
                     (setq selsh(nth (atoi shid) sheet_type))
                     (done_dialog)
               );progn
           );if
);defun

;;點取圖框無屬性 (toggle)
(defun action_nonatt_sheetset()
       (if (= attflag "0")
           (progn
               ; (mode_tile "logo" 0)(mode_tile "txt" 0)(mode_tile "lib" 0)(mode_tile "code" 0)
                (mode_tile "tolist" 0)
                (mode_tile "up" 0)(mode_tile "down" 0)
                (mode_tile "e_txt" 0)(mode_tile "e_lib" 0)(mode_tile "e_code" 0)(mode_tile "mod" 0)
           );progn
           (progn
               ; (mode_tile "logo" 1)(mode_tile "txt" 1)(mode_tile "lib" 1)(mode_tile "code" 1)
                (mode_tile "tolist" 1)
                (mode_tile "up" 1)(mode_tile "down" 1)
                (mode_tile "e_txt" 1)(mode_tile "e_lib" 1)(mode_tile "e_code" 1)(mode_tile "mod" 1)
           );progn
       );if
);defun action_nonatt

;;點取標籤 提示文字 對應詞庫 特殊識別碼 (list_box)  listid=>字串
(defun action_count_sheetset(listid / k)
       (setq k nil)
       (mode_tile "mod" 0)
       (cond
           ((= 0 (atoi listid)) (mode_tile "up" 1)(mode_tile "down" 0))
           ((= (length total_list) (+ 1 (atoi listid))) (mode_tile "up" 0)(mode_tile "down" 1))
           (t (mode_tile "up" 0)(mode_tile "down" 0))
       )
       (set_tile "e_logo" (nth (atoi listid) logo_list))
       (set_tile "e_txt"  (nth (atoi listid) txt_list))

       (setq k (list_id (nth (atoi listid) lib_list) tlib_list))
       (if (null k)(setq k 0) (setq k (- k 1)))
       (set_tile "e_lib"  (itoa k)) ;list_id =>pub-lisp.lsp
       (setq k (list_id (nth (atoi listid) code_list) tcode_list))
       (if (null k)(setq k 0) (setq k (- k 1)))
       (set_tile "e_code" (itoa k))
      ; (cond
      ;     ((= key "logo")(set_tile "txt" listid) (set_tile "lib" listid)(set_tile "code" listid))
      ;     ((= key "txt") (set_tile "logo" listid)(set_tile "lib" listid)(set_tile "code" listid))
      ;     ((= key "lib") (set_tile "logo" listid)(set_tile "txt" listid)(set_tile "code" listid))
      ;     ((= key "code")(set_tile "logo" listid)(set_tile "txt" listid)(set_tile "lib" listid))
      ; );cond
);defun action_count

;;點取修改鈕 (button)
(defun action_mod_sheetset(listid / e_logo e_txt e_lib e_code)
       (setq e_logo(get_tile "e_logo"))
       (setq e_txt (get_tile "e_txt"))
       (setq e_lib (nth (atoi (get_tile "e_lib")) tlib_list))
       (setq e_code(nth (atoi (get_tile "e_code")) tcode_list))
       (if (= "" e_txt)
           (set_tile "error" "提示文字未輸入 !")
           (progn
                (setq e_total (strcat e_logo (col_tab (- 14 (strlen e_logo))) e_txt (col_tab (- 26 (strlen e_txt))) e_lib (col_tab (- 18 (strlen e_lib))) e_code))
                (resetlist_sheetset listid e_total e_logo e_txt e_lib e_code)
                (set_tile "tolist" listid)
           );progn
       );if
);defun

;;點取上(下)移鈕 (button) listid1,listid2,listid3=>整數
(defun action_up_down_sheetset(listid1 listid2 listid3 / e_logo1 e_txt1 e_lib1 e_code1 e_logo2 e_txt2 e_lib2 e_code2 e_total1 e_total2)
       (setq e_logo1(nth listid1 logo_list) e_logo2(nth listid2 logo_list))
       (setq e_txt1 (nth listid1 txt_list)  e_txt2 (nth listid2 txt_list) )
       (setq e_lib1 (nth listid1 lib_list)  e_lib2 (nth listid2 lib_list) )
       (setq e_code1(nth listid1 code_list) e_code2(nth listid2 code_list))
       (setq e_total1 (strcat e_logo1 (col_tab (- 14 (strlen e_logo1))) e_txt1 (col_tab (- 26 (strlen e_txt1))) e_lib1 (col_tab (- 18 (strlen e_lib1))) e_code1))
       (setq e_total2 (strcat e_logo2 (col_tab (- 14 (strlen e_logo2))) e_txt2 (col_tab (- 26 (strlen e_txt2))) e_lib2 (col_tab (- 18 (strlen e_lib2))) e_code2))

       (resetlist_sheetset (itoa listid1) e_total2 e_logo2 e_txt2 e_lib2 e_code2)
       (resetlist_sheetset (itoa listid2) e_total1 e_logo1 e_txt1 e_lib1 e_code1)

       (set_tile "tolist" (itoa listid3))
       (setq id (get_tile "tolist"))
       (cond
           ((= 0 (atoi id)) (mode_tile "up" 1)(mode_tile "down" 0))
           ((= (length total_list) (+ 1 (atoi id))) (mode_tile "up" 0)(mode_tile "down" 1))
           (t (mode_tile "up" 0)(mode_tile "down" 0))
       )
);defun

;;重新設定 標籤 提示文字 對應詞庫 特殊識別碼 串列 listid=>字串
(defun resetlist_sheetset(listid n_total n_logo n_txt n_lib n_code / $logo_list $total_list $txt_list $lib_list $code_list j)
       (setq $total_list '() $logo_list '() $txt_list '() $lib_list '() $code_list '() j 0)
       (repeat (length total_list)
               (if (= j (atoi listid))
                   (progn
                        (setq $total_list(cons n_total $total_list))
                        (setq $logo_list (cons n_logo $logo_list))
                        (setq $txt_list  (cons n_txt $txt_list))
                        (setq $lib_list  (cons n_lib $lib_list))
                        (setq $code_list (cons n_code $code_list))
                   );progn
                   (progn
                        (setq $total_list(cons (nth j total_list) $total_list))
                        (setq $logo_list (cons (nth j logo_list) $logo_list))
                        (setq $txt_list  (cons (nth j txt_list) $txt_list))
                        (setq $lib_list  (cons (nth j lib_list) $lib_list))
                        (setq $code_list (cons (nth j code_list) $code_list))
                   );progn
               );if
               (setq j (+ j 1))
       );repeat
       (setq total_list(reverse $total_list))
       (setq logo_list (reverse $logo_list))
       (setq txt_list  (reverse $txt_list))
       (setq lib_list  (reverse $lib_list))
       (setq code_list (reverse $code_list))
       (act_pop_list total_list "tolist")
);defun


;;點取水平垂直鈕 (button)
(defun action_cal_hwid_vwid_sheetset()
       (setq shty     (get_tile "shty"))     ;圖框種類
       (setq name     (get_tile "name"))     ;圖紙名稱
       (setq size     (get_tile "size"))     ;圖紙尺寸
       (setq filename (get_tile "filename")) ;圖檔檔名
       (setq hwid     (get_tile "hwid"))     ;水平寬度
       (setq vwid     (get_tile "vwid"))     ;垂直寬度
       (setq attflag  (get_tile "nonatt"))   ;圖框無屬性
       (setq id       (get_tile "tolist"))
       (done_dialog)
);defun

;;點取確定鈕 (button)
(defun action_accept_sheetset()
       (setq shty     (get_tile "shty"))     ;圖框種類
       (setq name     (get_tile "name"))     ;圖紙名稱
       (setq name1 name)
       (setq size     (get_tile "size"))     ;圖紙尺寸
       (setq filename (get_tile "filename")) ;圖檔檔名
       (setq hwid     (get_tile "hwid"))     ;水平寬度
       (setq vwid     (get_tile "vwid"))     ;垂直寬度
       (setq attflag  (get_tile "nonatt"))   ;圖框無屬性
       (setq id       (get_tile "tolist"))
       (setq path     (get_tile "path"))
       (cond
            ((= "" shty)(set_tile "error" "圖框種類未輸入 !"))
            ((= "" name)(set_tile "error" "圖框名稱未輸入 !"))
            ((= "" size)(set_tile "error" "圖框尺寸未輸入 !"))
            ((= "" filename)(set_tile "error" "圖框檔名未輸入 !"))
            ((<= (atof hwid) 0)(set_tile "error" "水平寬度輸入錯誤 !"))
            ((<= (atof vwid) 0)(set_tile "error" "垂直寬度輸入錯誤 !"))
            (t (done_dialog))
       );cond
);defun

;;點取建立詞庫鈕 (button)
(defun action_creatlib_sheetset(/ k e_lib)
       (setq e_lib(nth (atoi(get_tile "e_lib")) tlib_list))
       (c:&creatword)             ;;參考command.lsp之建立詞庫
       (get_totallib_sheetset)
       (act_pop_list tlib_list "e_lib")

       (setq k (list_id e_lib tlib_list))
       (if (null k)(setq k 0) (setq k (- k 1)))
       (set_tile "e_lib"  (itoa k)) ;list_id =>pub-lisp.lsp

);defun


;;點取使用詞庫鈕 (button)
(defun action_uselib_sheetset( / libtxt)
  (if (null useword) (load "wordlib1"))  ;;參考wordlib1.lsp之使用詞庫
  (setq libtxt  (useword 1 1))
  (if (/= nil libtxt)
    (progn
      (cond
        ((= lib_id 1)   (set_tile "shty" libtxt))
        ((= lib_id 2)   (set_tile "name" libtxt))
        ((= lib_id 3)   (set_tile "size" libtxt))
        ((= lib_id 4)   (set_tile "e_txt" libtxt))
      )
      (setq lib_id nil)
    );progn
  )
  (setvar "cmdecho" 0)
);defun


;;取出所有已設定圖框資料 from shscal.ini
(defun read_shdata_sheetset(/ ff data fg rdlist ddata)
       (setq ff (open (strcat powdesign_path "shscal.ini") "r"))
       (setq sheet_type '())

       (if ff
           (progn
             (setq data (read-line ff))
             (while data
                    (setq fg (substr data 1 2))
                    (cond
                      ((= fg ">>")(princ))
                      ((= fg "$$")(setq edms_sheetatt (read (substr data (1+ (get_word data "="))))))
                 ;    ((= fg "##")(setq edms_sheetdata_path (read (substr data (1+ (get_word data "="))))))
                      ((= fg "**") (setq sheet_type (cons (substr data 3) sheet_type))) ;圖框種類
                    )
                    (setq data (read-line ff))
             );while
           );progn
       );if
       (close ff)
       (setq sheet_type (reverse sheet_type))

       (setq sheet_typelist '() rdlist '())
       (foreach nn sheet_type
            (setq ff (open (strcat powdesign_path "shscal.ini") "r"))
            (setq data (read-line ff))
            (while data
                   (setq fg (substr data 3))
                   (if (= nn fg)
                       (progn
                            (setq rdlist (cons nn rdlist))
                            (setq ddata (read-line ff))
                            (while (and (/= nil ddata) (/= "**" (substr ddata 1 2)))
                                   (setq rdlist (cons (read ddata) rdlist))
                                   (setq ddata (read-line ff))
                            );while
                            (close ff)
                            (setq data nil)
                       );progn
                       (setq data (read-line ff))
                   );if
            );while
            (setq sheet_typelist (cons (reverse (cdr rdlist)) sheet_typelist))
            (setq rdlist '())
       );foreach
       (setq sheet_typelist (reverse sheet_typelist))
)


;;;
;;;╭════════════════════════════════════════════╮
;;;║設計日期: 2001. 2. 15                                                                   ║
;;;║更新日期:                                                                               ║
;;;║設 計 者: 佘宗紋                                                                        ║
;;;║功能說明: 修改已設定完成之圖框                                                          ║
;;;║執行方式:                                                                               ║
;;;║相關檔案:pub-lisp.lsp  wordlib1.lsp command.lsp                                         ║
;;;║注意事項:                                                                               ║
;;;╰════════════════════════════════════════════╯
(defun c:modsheetset( / flag attflag i id attgrp logo_list txt_list lib_list code_list total_list shty name size hwid vwid filename name_type sheet_type sheet_typelist)
       (setvar "cmdecho" 0)
       ;; 已移除加密狗判斷
       (progn ;; DraftSight: 移除加密狗 WHILE 迴圈
              (setq attflag "0" flag "start" sh_id "0" logo_list '() txt_list '() id nil lib_list '() code_list '() total_list '() name_type '())
              (setq tcode_list (list "" "檔名(F)" "日期(D)" "比例(S)"))

              (read_shdata_sheetset)

              (get_totallib_sheetset)

              (modsheetset_main)

              (SETQ FFF nil)
      );while
      (princ)
);defun

(defun modsheetset_main( / func p1 p2)

              (setq p1 nil p2 nil dist nil sel_flag nil lib_id nil shtyflag nil func T)
              (actdcl (strcat powdesign_dcl_path "sheetset") "modsheetset")
              (mode_tile "e_logo" 1)(mode_tile "mod" 1)
              (mode_tile "up" 1)(mode_tile "down" 1)
              (mode_tile "filename" 1)


              (act_pop_list sheet_type "shty")
              (act_pop_list tlib_list "e_lib")
              (act_pop_list tcode_list "e_code")

              (if (= flag "sel_wid")
                  (progn
                        (act_pop_list total_list "tolist")
                        (act_pop_list name_type "name")
                        (set_tile "shty" shty)
                        (set_tile "name" name_id)
                        (set_tile "name1" name)
                        (set_tile "size" size)
                        (set_tile "filename" filename)
                        (set_tile "hwid" hwid)
                        (set_tile "vwid" vwid)
                        (set_tile "path" path)
                        (set_tile "nonatt" attflag)
                        (set_tile "tolist" id)
                        (if (/= "" id) (action_count_sheetset id))      ;(上)此兩行順序不可對調
                        (if (= "1" attflag) (action_nonatt_sheetset))   ;(下)此兩行順序不可對調
                  );progn
                  (set_selected_value_modsheetset "0" "0")
              );if

              (action_tile "shty"  "(setq sh_id $value)(set_selected_value_modsheetset sh_id  \"0\")")
              (action_tile "name"  "(setq na_id $value)(set_selected_value_modsheetset sh_id na_id)")
              (action_tile "size"  "(setq lib_id 3)")
              (action_tile "e_txt" "(setq lib_id 4)")

              (action_tile "nonatt" "(setq attflag $value)(action_nonatt_sheetset)")

              (action_tile "tolist" "(setq id $value)(action_count_sheetset id)")

              (action_tile "sel_shty"  "(action_sel_shty_sheetset)")
              (action_tile "cal_hwid"  "(setq flag \"sel_wid\" sel_flag \"h\")(action_cal_hwid_vwid_modsheetset)")
              (action_tile "cal_vwid"  "(setq flag \"sel_wid\" sel_flag \"v\")(action_cal_hwid_vwid_modsheetset)")

              (action_tile "mod"  "(action_mod_sheetset id)")
              (action_tile "up"   "(action_up_down_sheetset (- (atoi id) 1) (atoi id) (- (atoi id) 1))")
              (action_tile "down" "(action_up_down_sheetset (atoi id) (+ (atoi id) 1) (+ (atoi id) 1))")

              (action_tile "creatlib"  "(action_creatlib_sheetset)")
              (action_tile "uselib"  "(action_uselib_sheetset)")

              (action_tile "accept" "(setq func T flag \"start\")(action_accept_modsheetset)")

              (action_tile "cancel" "(setq func nil flag nil)(done_dialog)")
              (start_dialog)

              (cond
                    ((and func (= flag "sel_wid"))
                               (setq p1 nil p2 nil)
                               (while (null p1)
                                      (setq p1(getpoint "\n第一點 : "))
                               );while
                               (while (null p2)
                                      (setq p2(getpoint p1 "\n第二點 : "))
                               );while
                               (setq dist(distance p1 p2))
                               (cond
                                     ((= "h" sel_flag)(setq hwid (rtos dist 2 0)))
                                     ((= "v" sel_flag)(setq vwid (rtos dist 2 0)))
                               );cond
                               (modsheetset_main)
                    )
                    ((null func)(princ))
                    (t
                       (rewrite_inidata_sheetset 2 3)
                    )
              );cond

);defun

;;;選擇圖框種類與圖紙名稱後秀出不同之資料 id1=>圖框種類  id2=>圖紙名稱
(defun set_selected_value_modsheetset(id1 id2 / i o_code filepathname)
       (setq i 1 logo_list '() txt_list '() lib_list '() code_list '() total_list '() name_type '() filename "")
       (setq shtydata   (assoc (nth (atoi id1) sheet_type) sheet_typelist))
       (repeat (- (length shtydata) 1)
               (setq name_type(cons (nth 0 (nth i shtydata)) name_type))
               (setq i (+ i 1))
       );repeat
       (setq name_type(reverse name_type))

       (act_pop_list name_type "name")
       (set_tile "name" id2)
       (set_tile "name1" (nth (atoi id2) name_type))
       (setq shnamedata (nth (+ 1 (atoi id2)) shtydata))
       (set_tile "size" (nth 1 shnamedata))
       (setq filepathname (strcase(nth 2 shnamedata)))

       (setq j (strlen filepathname))
       (while (/= "\\" (substr filepathname j 1))
              (setq filename(strcat (substr filepathname j 1) filename))
              (setq j (- j 1))
       );while

       (set_tile "filename" filename)
       (set_tile "path" (substr filepathname 1 j))
       (set_tile "hwid" (rtos (nth 0 (nth 3 shnamedata)) 2))
       (set_tile "vwid" (rtos (nth 1 (nth 3 shnamedata)) 2))
       (if (and (= "" (nth 4 shnamedata))(= "" (nth 5 shnamedata)))
           (progn
                (setq attflag "1")
                (setq logo_list '() txt_list '() lib_list '() code_list '() total_list '())
                (action_nonatt_sheetset)
                (set_tile "nonatt" attflag)
                (act_pop_list total_list "tolist")
           );progn
           (progn
                (setq attflag "0")
                (action_nonatt_sheetset)
                (set_tile "nonatt" attflag)
                (foreach XX (nth 4 shnamedata)
                       (setq logo_list (cons (nth 0 XX) logo_list))
                       (setq txt_list (cons (nth 1 XX) txt_list))
                       (setq lib_list (cons (nth 2 XX) lib_list))
                       (cond
                           ((null (nth 3 XX))(setq code_list  (cons "" code_list) o_code ""))
                           ((= "F" (nth 3 XX))(setq code_list (cons "檔名(F)" code_list) o_code "檔名(F)"))
                           ((= "D" (nth 3 XX))(setq code_list (cons "日期(D)" code_list) o_code "日期(D)"))
                           ((= "S" (nth 3 XX))(setq code_list (cons "比例(S)" code_list) o_code "比例(S)"))
                       )
                       (setq total_list (cons (strcat (nth 0 XX) (col_tab (- 14 (strlen (nth 0 XX)))) (nth 1 XX) (col_tab (- 26 (strlen (nth 1 XX)))) (nth 2 XX) (col_tab (- 18 (strlen (nth 2 XX)))) o_code) total_list))
                );foreach
                (setq logo_list (reverse logo_list))
                (setq txt_list  (reverse txt_list))
                (setq lib_list  (reverse lib_list))
                (setq code_list (reverse code_list))
                (setq total_list(reverse total_list))

                (act_pop_list total_list "tolist")
           );progn
       );if
)

;;點取確定鈕 (button)
(defun action_accept_modsheetset()
       (setq shty     (nth (atoi (get_tile "shty")) sheet_type))     ;圖框種類
       (setq name1    (nth (atoi (get_tile "name")) name_type))    ;圖紙名稱
       (setq name     (get_tile "name1"))    ;圖紙名稱
       (setq size     (get_tile "size"))     ;圖紙尺寸
       (setq filename (get_tile "filename")) ;圖檔檔名
       (setq hwid     (get_tile "hwid"))     ;水平寬度
       (setq vwid     (get_tile "vwid"))     ;垂直寬度
       (setq attflag  (get_tile "nonatt"))   ;圖框無屬性
       (setq id       (get_tile "tolist"))
       (setq path     (get_tile "path"))
       (cond
            ((= "" shty)(set_tile "error" "圖框種類未輸入 !"))
            ((= "" name)(set_tile "error" "圖框名稱未輸入 !"))
            ((= "" size)(set_tile "error" "圖框尺寸未輸入 !"))
            ((= "" filename)(set_tile "error" "圖框檔名未輸入 !"))
            ((= "" path)(set_tile "error" "圖檔路徑未輸入 !"))
            ((and (/= name name1) (member (strcase name) name_type))(set_tile "error" "圖紙名稱重複 !"))
            ((<= (atof hwid) 0)(set_tile "error" "水平寬度輸入錯誤 !"))
            ((<= (atof vwid) 0)(set_tile "error" "垂直寬度輸入錯誤 !"))
            (t (done_dialog))
       );cond
);defun

(defun action_cal_hwid_vwid_modsheetset()
       (setq shty     (get_tile "shty"))     ;圖框種類
       (setq name_id  (get_tile "name"))     ;圖紙名稱
       (setq name     (get_tile "name1"))    ;圖紙名稱
       (setq size     (get_tile "size"))     ;圖紙尺寸
       (setq filename (get_tile "filename")) ;圖檔檔名
       (setq path     (get_tile "path"))     ;圖檔路徑
       (setq hwid     (get_tile "hwid"))     ;水平寬度
       (setq vwid     (get_tile "vwid"))     ;垂直寬度
       (setq attflag  (get_tile "nonatt"))   ;圖框無屬性
       (setq id       (get_tile "tolist"))
       (done_dialog)
);defun
