;;;
;;;    ┌───────────┐
;;;    │ 屬性處理函數         │
;;;    └───────────┘
;; 1) 取某特定屬性詳細資料                    (getatt ent code attword) ;;例: (getatt selent 2 "NUMBER")  回應該屬性詳細資料
                                                                        ;; selent 是該屬性之圖元編號 ,無資料則回應 nil
;; 2) 將 ent 內所有屬性資料與標簽取出         (getent_allatt ent)

;;;    ┌───────────┐
;;;    │ INPUT 功能函數       │
;;;    └───────────┘
;; 1) 請使用者輸入檔名                        (keyin_newfile mess path filetype rtkey)

;;;    ┌───────────┐
;;;    │ 圖元內部資料處理函數 │
;;;    └───────────┘
;; 1) 選取某一項特定圖元資料之圖元             (ssget1 8 "PROJ")
;; 2) 選取某二項特定圖元資料之圖元             (ssget2 8 "PROJ" 0 "DIM")
;; 3) 取出某圖元選集中, 特定代碼內容之集合     (selgrp_datalist grp code)
;; 4) 取文字對角兩點,長度與高度                (txt_data txtent)

;;;    ┌───────────┐
;;;    │ 輔助繪圖與編輯       │
;;;    └───────────┘
;; 1)  自由格式畫表單                          (free_list tdata_list label_list 180 270  8 "M" 4)
;; 2)  改變目前之顏色與線型                    (ch_lt_c  lty col)
;; 3)  圖元改變到另一圖層                      (chlayer layname)
;; 4)  插入BLOCK,並旋轉角度                    (xins blkname)
;; 5)  尺寸爆炸回dim層                         c:dimexp()
;; 6)  畫線號框                                txtbox(txttype txtp)
;; 7)  插入block(但在 block 名稱前加入一字串dirt) (insb dirt bname)
;; 8)  是否畫中心線                            (cenline_yesno)     備註: 本程式與 (draw_cline p1 p2)合用
;; 9)  畫軸中心線公用裎式                      (draw_cenline p1 p2) 備註: 本程式與 (cenline_yesno) 合用
;; 10) 畫圓中心線公用裎式                      (drawcircle_cenline ent) 備註: 本程式與 (cenline_yesno) 合用

;;;    ┌───────────┐
;;;    │ 計算,計數功能        │
;;;    └───────────┘
;; 1) 計算弧長                               arc_len(ename)
;; 2) 計算直線長度                           line_len(ename)
;; 3) 計算直線圓周長                         cir_len(ename)
;; 4) (DTR) 度度量轉成弳度量 (RTD) 弳度量轉成度度量
;; 5) 計算選擇集 grp 內, ? code 碼, ? val 值的圖元有幾個   (ent_totallnum grp code val)

;;;    ┌───────────────┐
;;;    │ AUTOCAD 系統變數處理函數     │
;;;    └───────────────┘
;; 1) 記憶目前之     clayer,celtype,cecolor,osmode                  (mem_curset)
;; 2) 還原剛才記憶之 clayer,celtype,cecolor,osmode                  (rt_to_old_set)
;; 3) 記憶目前之 OSMODE,SNAPMODE,APERTURE,PICKBOX 系統變數原值      (MEM_SYS)
;; 4) 還原剛才記憶之 OSMODE,SNAPMODE,APERTURE,PICKBOX 系統變數原值  (RT_SYS)
;; 5) 改變MODEMACRO變數值                                           (china_name name)
;; 6) 取得目前字型固定字高,並且將固定字高設為0                      (ffont_height_get)
;; 7) 設定目前字型固定字高					    (ffont_height_set 字高)

;;;    ┌───────────┐
;;;    │ 文字檔檔案處理函數   │
;;;    └───────────┘
;; 1)  CALLword(fname)    呼叫文字檔(不能modify)
;; 2)  在某檔案內特定列之下加入一列                    (insline_tofile 目標檔案 暫存檔案 目標行 加入之文字 0)
;;     在某檔案內特定列之上加入一列                    (insline_tofile 目標檔案 暫存檔案 目標行 加入之文字 1)
;; 3)  取目前圖檔名 (curdwgname)
;; 4)  取出含路徑path與延伸檔名之字串fn的檔名newfn     (get_pathfname fn path)
;; 5)  編輯文字檔                                      (editword fname)
;; 6)  選擇要編輯的文字檔名                            (c:edword)
;; 7)  新列取代舊列(用於系統資料定義)                  (update_filedata filepath oldfile newfile labl flagtxt outdata)
;; 8)  刪除檔案中某一列資料(del_filedata filepath oldfile newfile labl flagtxt outdata)
;; 9)  刪除某檔案內特定列                              (modify_file 目標檔案 暫存檔案 list_box點選的回應值 "" 1)
;;     修改某檔案內特定列                              (modify_file 目標檔案 暫存檔案 list_box點選的回應值 修改後文字 2)
;; 10) 將某檔案資料讀出,並回應成串列資料               (readfile_tolist "檔名")
;; 11) 讀取某檔案之內部資料                            (getfile_val filename "零件定義資料")
;; 例: 零件定義資料=(("品名" "PARTNAME") ("材質" "MATERIAL") ("#料號" "PNUM"))




;;;    ┌───────────┐
;;;    │ 字串處理函數         │
;;;    └───────────┘
;; 1)  去除字串後面所有空格 "123    " ==> "123"      (getrealstr 字串)
;; 2)  去除文字串前面所有空格 "    123" ==> "123"    (getrealstr2 字串)
;; 3)  去除文字串前後面所有空格 "    123 qwer   " ==> "123 qwer"    (getrealstr4 字串)
;; 4)  計算字串中某特定字元之位置數目                (get_word 字串 特定字元)
;; 5)  集合 num 個空格為一個字串                     (col_tab num)
;; 6)  檢驗字串內是否有英文字, 若有則回應位置值, 否則回應 nil   (check_engtxt txtstring)
;; 7)  輸入之字串有 " 字元時自動轉成 \"              (txt_tran 字串)
;; 8)  將字串 "c:\\aa\\cc.txt" 轉成 "c:/aa/cc.txt    (trans_pathtxt 字串)
;; 9)  將含有路徑的檔名字串(不含延伸檔名),取出檔名部份     (例: "c:/abc/wer") 取出檔名 "wer") (get_filename txt "/")
;; 10)  將含有路徑的檔名字串(不含延伸檔名),取出路徑部份     (例: "c:/abc/wer") 取出檔名 "c:/abc") (get_filepath txt "/")
;; 11) 將字串 "A;B;C;D;E;F" 轉成("A" "B" "C" "D" "E" "F") (TXT_TRAN_LIST 字串)

;;;    ┌───────────┐
;;;    │ 串列處理函數         │
;;;    └───────────┘
;; 1)  建立空格串列                           (col_tab 數目) Ex:(col_tab 4)  --> "    "
;; 2)  將整數文字串列排序                      (int_list_sort typ num_list)
;;     typ = 0 : 將重覆號碼排除     ("43" "67" "4" "2" "43" "67")==> ("2" "4" "43" "67")
;;     typ = 1 : 不排除重覆號碼     ("43" "67" "4" "2" "43" "67")==> ("2" "4" "43" "43" "67" "67")
;; 3)  將舊oldlist串列(有重覆元素),過濾出new_list(無重覆元素)        (newlist oldlist)
;; 4)  尋找某串列中特定子串列的第n個元素      gettxt(txtlist get_sublist get_txt)
;; 5)  計算某元素在串列中的位置               (get_sublist_num 串列 某元素)  Ex:(get_sublist_num '(a b c d) c) --> "2"
;; 6)  計算某元素在串列中的位置               (list_id  某元素 串列)         Ex:(list_id c '(a b c d)) --> 3
;; 7)  移除串列(li) 中某一元素(obj), 並回應移除後的串列 (removelist obj li)
;; 8)  取出某串列(li) 中某一元素代號(list_id)之前的所有串列 (getfrontelist list_id li)   Ex:(getfrontelist 2 '(a b c d e)) --> '(a b)
;; 9)  取出某串列(li) 中某一元素代號(list_id)之後的所有串列 (getbacklist list_id li) Ex:(getbacklist 2 '(a b c d e)) --> '(d e)

;;;    ┌───────────┐
;;;    │ DCL 對話框工具程式   │
;;;    └───────────┘
;; 1) 啟動 DCL                               actdcl(filename gg)
;; 2) show_sld(key sld)
;; 3) show_sld_key(key sld color)
;; 4) 顯示幻燈片於DCL, 並自定底色            show_sld_col(key sld col)
;; 5) 警示框在 elecr4.dcl (allert)
;; 6) act_pop_list (data_list key_name)

;;;    ┌───────────┐
;;;    │ 圖層控制工具程式     │
;;;    └───────────┘
;; 1) 建立某新層                             creat_layer(laname lacolor)
;; 2) MAKE 建立新CURRENT層                   clauc (lay col lty)
;; 3) chlayer(layname)
;; 4) 改變圖形到某層                         change_lay(laname)
;; 5) 建立某特定線型的新layer                creat_lt_layer(laname lacolor ltname)
;; 6) 收集所有圖層                           coll_layer()
;; 7) 收集所有block                          coll_block()

;;;    ┌───────────┐
;;;    │ 延伸資料庫 XDATA     │
;;;    └───────────┘
;; 1) 將延伸資料加入(entlast)圖元            adxdata(xdata_flag)
;;                                           ad1xdata(entname xdata_flag xdata)
;; 2) 將延伸資料加入handle圖元               add_newxdata_to_handle(handle xdata_flag)
;; 3) 將延伸資料extdata 加入(entlast)圖元,延伸資料識別名稱xdata_flag變數
;; 4) (add_new_xdata 延伸資料識別變數extdata)
;; 5) 取出延伸資料                           gtxdata()
;; 6) 自圖元ENT取出延伸資料                  getxdata(ent xdata_flag)



;;;    ┌───────────┐
;;;    │ 圖形性質處理         │
;;;    └───────────┘
;; 1) 換線形,顏色                              (chltype ltyname col)
;; 2) 換圖層, 線形,顏色                        (ch_to_lty_la_col layname ltype col)
;; 3) 換圖層                                   (ch_lay_to laname)
;; 4) 換顏色                                   (chcolor colname)

;;;
;;;    ┌───────────┐
;;;    │ 其他                 │
;;;    └───────────┘
;; 1) 取出目前日期                             (getsys_date typ)
;; 2) 取出圖元資料                             c:ee
;; 3) 軟體版權宣告                             c:piec

;;;============================================================================================
;;;    ┌───────────┐
;;;    │ 其他                 │
;;;    └───────────┘


;; 取出圖元資料
;;(defun c:ee() (setq a (entget (car (entsel)))) (textscr) (princ a)(princ))

;; 軟體版權宣告
(defun c:piec()
   (princ "\n此檔案程式系統由 藝祥資訊工程有限公司 陳冠達 所發展")
)

;;取出目前日期
;;(0)  1998.11.2    (1)  1998/11/2       (2)  87.11.2           (3) 87/11/2
;;(4) 19981102      (5)  1998年11月2日   (6)  87年11月2日       (7) JAN.28.1998
;;                                       (8) 1998.JAN.28        (9) 1998/JAN/28
;;                                                              (10) JAN.28.1998
;;(11) JAN.2.98        (12) JAN/2/98
(defun getsys_date(typ)
   (setq nowdate (rtos (getvar "cdate") 2 0))    ;cyear 西元 1998   cyesr1 民國  cyear2 西元 98
   (setq cyear (substr nowdate 1 4)
         cyear1 (rtos (- (atoi cyear) 1911) 2 0)
         cyear2 (substr nowdate 3 2)
         cmonth (rtos (atoi (substr nowdate 5 2)) 2 0)
         cday   (rtos (atoi (substr nowdate 7 2)) 2 0))
   (if (= 1 (strlen cmonth))(setq cmonth (strcat "0" cmonth)))
   (if (= 1 (strlen cday))(setq cday (strcat "0" cday)))
   (if (or (= 7 typ) (= 8 typ) (= 9 typ)(= 10 typ)(= 11 typ)(= 12 typ))
     (progn
         (cond
           ((= "01" cmonth)  (setq emonth "JAN"))
           ((= "02" cmonth)  (setq emonth "FEB"))
           ((= "03" cmonth)  (setq emonth "MAR"))
           ((= "04" cmonth)  (setq emonth "APR"))
           ((= "05" cmonth)  (setq emonth "MAY"))
           ((= "06" cmonth)  (setq emonth "JUN"))
           ((= "07" cmonth)  (setq emonth "JUL"))
           ((= "08" cmonth)  (setq emonth "AUG"))
           ((= "09" cmonth)  (setq emonth "SEP"))
           ((= "10" cmonth)  (setq emonth "OCT"))
           ((= "11" cmonth)  (setq emonth "NOV"))
           (T        (setq emonth "DEC"))
         );cond
       );progn
    );if
   (cond
     ((= 0 typ) (setq sysdate (strcat cyear "." cmonth "." cday)))
     ((= 1 typ) (setq sysdate (strcat cyear "/" cmonth "/" cday)))
     ((= 2 typ) (setq sysdate (strcat cyear1 "." cmonth "." cday)))
     ((= 3 typ) (setq sysdate (strcat cyear1 "/" cmonth "/" cday)))
     ((= 4 typ) (if (= 1 (strlen cmonth)) (setq cmonth (strcat "0" cmonth)))
                (if (= 1 (strlen cday)) (setq cday (strcat "0" cday)))
                (setq sysdate (strcat cyear cmonth cday)))
     ((= 5  typ)(setq sysdate (strcat cyear "年" cmonth "月" cday "日")))
     ((= 6  typ)(setq sysdate (strcat cyear1 "年" cmonth "月" cday "日")))
     ((= 7  typ)(setq sysdate (strcat emonth "." cday "." cyear)))
     ((= 10 typ)(setq sysdate (strcat emonth "/" cday "/" cyear)))
     ((= 8  typ)(setq sysdate (strcat cyear "." emonth "." cday )))
     ((= 9  typ)(setq sysdate (strcat cyear "/" emonth "/" cday )))
     ((= 11 typ)(setq sysdate (strcat emonth "." cday "." cyear2)))
     ((= 12 typ)(setq sysdate (strcat emonth "/" cday "/" cyear2)))
     ((= 13 typ)(setq sysdate (strcat cyear "-" cmonth "-" cday)))
   );cond
   sysdate
)

;;=============================================================================================

;;集合 num 個空格為一個字串
(defun col_tab(num)
  (setq ttab "")
  (repeat num
    (setq ttab (strcat ttab " "))
  )
  ttab
)




;;; 計算某元素在串列中的位置  (get_sublist_num 串列 某元素)  Ex:(get_sublist_num '(a b c d) c) --> "2"
(defun get_sublist_num(be_searched_list object)
   (setq count 0)
   (while (/= (setq sear_data (nth count be_searched_list)) object)
       (setq count (1+ count))
   )
;  (if (= sear_data object) (rtos count 2 0))
   (rtos count 2 0)
)


;;; (DTR) 度度量轉成弳度量 (RTD) 弳度量轉成度度量
;╭════════════════════╮
;║程式名稱:                               ║
;║設計日期: 1996.03.04                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: (DTR) 度度量轉成弳度量        ║
;║          (RTD) 弳度量轉成度度量        ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun dtr(d) (/ (* pi d) 180.0))
(defun rtd(r) (/ (* 180.0 r) pi))


(defun mem_sys()
  (setq oldosmode (getvar "osmode"))
  (setq oldsnapmode   (getvar "snapmode"))
  (setq oldaperture   (getvar "aperture"))
  (setq oldpickbox    (getvar "pickbox"))
  (princ)
)

(defun rt_sys()
  (setvar "osmode" oldosmode)
  (setvar "snapmode" oldsnapmode)
  (setvar "aperture" oldaperture)
  (setvar "pickbox" oldpickbox)
  (princ)
)

;;檢驗字串內是否有英文字, 若有則回應位置值, 否則回應 nil
(defun check_engtxt (txtstring)
   (setq count 1 chktxt (substr txtstring count 1) knum nil flag t)
   (while (and (/= "" chktxt) flag)
      (setq txtnum (ascii chktxt))
      (if (or (and (>=  txtnum 65)(<= txtnum 90))(and (>= txtnum 97)(<= txtnum 122)))
        (progn
        (setq knum count flag nil)(princ knum)
        );progn
        (setq count (1+ count) chktxt (substr txtstring count 1))
      );if
   );while
   knum
)

(defun get_word(word kw)
    (setq check word)
    (if (= 0 (strlen word)) (setq aa nil)
     (progn
       (setq w_count 1)
       (setq word (strcase word))
       (setq kw (strcase kw))
       (setq w_length (strlen word))
       (setq flag t)
       (while flag
         (setq g_word (substr word w_count 1))
         (if (= kw g_word)
           (setq flag nil k_num w_count)
           (setq w_count (+ w_count 1))
         );if
         (if (> w_count (strlen word)) (setq flag nil))
       );while
     );progn
   );if
   (if (> w_count (strlen word)) (setq flag nil) w_count)
)

;啟動 DCL
(defun actdcl(filename gg)
 (setq dcl_pt '(-1 -1))
 (setq dcl_id (load_dialog filename))
 (new_dialog gg dcl_id)
 (if (< dcl_id 0) (exit))
)


;╭═══════════════════════╮
;║設計日期: 1995.10.14                          ║
;║更新日期:                                     ║
;║設 計 者: 陳冠達                              ║
;║功能說明: 尋找某串列中特定子串列的第n個元素   ║
;║                                              ║
;║執行方式:(gettxt 主串列 子串列位置 元素位置)  ║
;║相關檔案:                                     ║
;╰═══════════════════════╯
(defun gettxt(txtlist get_sublist get_txt)
  (setq wtxt (nth (- get_txt 1) (nth (- get_sublist 1) txtlist)))
)
;╭═══════════════════════╮
;║設計日期: 1995.10.18                          ║
;║更新日期:                                     ║
;║設 計 者: 陳冠達                              ║
;║功能說明: 顯示幻燈片於DCL                     ║
;║                                              ║
;║執行方式:( show_sld key串列 幻燈片串列)       ║
;║相關檔案:                                     ║
;╰═══════════════════════╯
(defun show_sld(key sld)
   (setq x (dimx_tile key))
   (setq y (dimy_tile key))
   (start_image key)
   (fill_image 0 0 x y -2)
   (slide_image 0 0 x y sld)
   (end_image)
)

(defun show_sld_key(key sld color)
   (setq x (dimx_tile key))
   (setq y (dimy_tile key))
   (start_image key)
   (fill_image 0 0 x y color)
   (slide_image 0 0 x y sld)
   (end_image)
)


;╭═══════════════════════╮
;║設計日期: 1997.04.24                          ║
;║更新日期:                                     ║
;║設 計 者: 陳冠達                              ║
;║功能說明: 顯示幻燈片於DCL, 並自定底色         ║
;║                                              ║
;║執行方式:(show_sld key串列 幻燈片串列)        ║
;║相關檔案:                                     ║
;╰═══════════════════════╯
(defun show_sld_col(key sld col)
   (setq x (dimx_tile key))
   (setq y (dimy_tile key))
   (start_image key)
   (fill_image 0 0 x y col)
   (slide_image 0 0 x y sld)
   (end_image)
)

;╭════════════════════╮
;║設計日期:1995.10.20                     ║
;║更新日期:                               ║
;║設計者:陳冠達                           ║
;║功能說明:警示框                         ║
;╰════════════════════╯
; 警示框在 elecr4.dcl (allert)
(defun allert(subdclname subdialog msg)
   (actdcl subdclname subdialog)
   (set_tile "ms_allert" msg)
   (start_dialog)
)

;╭════════════════════╮
;║設 計 者: 陳冠達                        ║
;║功能說明: 建立某新層                    ║
;║相關檔案: setsyste.lsp                  ║
;╰════════════════════╯
(defun creat_layer(laname lacolor)
    (setq la (tblsearch "layer" laname))
    (if (= la nil) (command "layer" "n" laname "c" lacolor laname ""))
)
;╭════════════════════╮
;║設 計 者: 陳冠達                        ║
;║功能說明: MAKE 建立新CURRENT層          ║
;║相關檔案: setsyste.lsp                  ║
;╰════════════════════╯
(defun make_layer(laname lacolor)
    (setq la (tblsearch "layer" laname))
    (if (= la nil)
         (command "layer" "m" laname "c" lacolor laname "")
         (command "layer" "s" laname "")
    )
    (command "color" lacolor)
)

;╭════════════════════╮
;║設 計 者: 陳冠達                        ║
;║功能說明: 建立某特定線型的新layer       ║
;║相關檔案: setsyste.lsp                  ║
;╰════════════════════╯
(defun creat_lt_layer(laname lacolor ltname)
    (setvar "cmdecho" 0)
    (setq la (tblsearch "layer" laname))
    (if (= la nil)
       (command "layer" "n" laname "c" lacolor laname "l" ltname laname ""))
    (command "layer" "s" laname "")
    (command "color" "bylayer")
    (command "linetype" "s" "bylayer" "" "color" "bylayer")
    (setvar "cmdecho" 1)(princ)
)


;╭══════════════════════════════╮
;║設 計 者: 陳冠達                                            ║
;║功能說明: 計算元素check_data是在串列lst 中的位置coun值      ║
;║相關檔案: mblock.lsp                                        ║
;╰══════════════════════════════╯
(defun list_id(check_data lst / flag)
  (setq coun 0)
  (if (setq flg (member check_data lst))
   (progn
     (setq data (nth coun lst))
     (while (/= check_data data)
         (setq coun (1+ coun))
         (setq data (nth coun lst))
     )
     (1+ coun)
   );progn
  );if
  (if flg (1+ coun) flg)
)


;╭══════════════════════════════╮
;║設 計 者: 陳冠達                                            ║
;║功能說明: 取出某串列(li) 中某一元素代號(list_id)之前的所有串列
;║相關檔案: mblock.lsp                                        ║
;╰══════════════════════════════╯
(defun getfrontelist(list_id dlist / count newlist)
   (setq count 0 newlist '())
   (if (<= (1+ list_id) (length dlist))
     (progn
       (while (/= count list_id)
          (setq newlist (cons (nth count dlist) newlist))
          (setq count (1+ count))
       );while
       (setq newlist (reverse newlist))
     );progn
   )
   newlist
)
;╭══════════════════════════════╮
;║設 計 者: 陳冠達                                            ║
;║功能說明: 取出某串列(li) 中某一元素代號(list_id)之後的所有串列
;║相關檔案: mblock.lsp                                        ║
;╰══════════════════════════════╯
(defun getbacklist(list_id dlist)
   (setq count 0 newlist '())
   (if (<= (1+ list_id) (length dlist))
     (progn
       (repeat (1+ list_id)
          (setq newlist (cdr dlist))
          (setq dlist newlist)
       )
     );progn
   );if
   newlist
)





;;make 新圖層
(defun clauc (lay col lty)
  (setvar "cmdecho" 0)
  (if (null (tblsearch "LAYER" lay))
    (progn
      (setvar "regenmode" 0)
      (command "layer" "n" lay "c" col lay "lt" lty lay "")
      (setvar "regenmode" 1)
    )
  )
  (command "layer" "s" lay "")
  (princ)
)
(defun ch_lt_c (lty col)
  (setvar "cmdecho" 0)
  (command "linetype" "s" lty "" "color" col) (princ)
)


(defun chlayer(layname)
  (setvar "cmdecho" 0)
  (princ "\n請選擇圖元...")
  (setq ch_ent (ssget))
  (command "change" "p" "" "p" "la" layname "")
  (princ (strcat "\n圖元已改變到" layname "層了!!"))
  (setvar "cmdecho" 1)
  (princ)
)

(defun chcolor(colname)
  (setvar "cmdecho" 0)
  (initget 0 "1 2")
  (setq seltype (getkword "\n(1)Ssw / (2)按 Enter 鍵自由選取 <2>: "))
  (if (null seltype)
    (progn
       (princ "\n請選擇圖元...")
       (setq ch_ent (ssget))
       (command "change" "p" "" "p" "c" colname "")
       (princ (strcat "\n圖元已改變成" (RTOS COLName 2 0) "號顏色了!!"))
    )
    (command "change" (ssw) "" "p" "c" colname "")
  )
  (setvar "cmdecho" 1)
  (princ)
)
(defun chltype(ltyname col)
  (setvar "cmdecho" 0)
  (if (and ltyname col)
      (progn
          (princ "\n請選擇圖元...")
          (setq ch_ent (ssget))
          (command "change" "p" "" "p" "lt" ltyname "c" col "")
          (princ (strcat "\n圖元已改變到" ltyname "線型了!!"))
      )
      (progn
          (princ "\n線型未設定")
      )
  )
  (setvar "cmdecho" 1)
  (princ)
)
;╭════════════════════╮
;║設計日期: 1996.02.24                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 將延伸資料加入(entlast)圖元   ║
;║          延伸資料識別名稱xdata_flag變數║
;║執行方式: (adxdata 延伸資料識別變數)    ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun adxdata(xdata_flag)
   (regapp xdata_flag)
   (setq entname (entlast))
   (setq oldentdata (entget entname))
;  (setq d10 (cons 1000 data10)
;        d20 (cons 1000 data20)
;        d30 (cons 1000 data30)
;        d40 (cons 1000 data40)
;        d60 (cons 1000 data60)
;        d70 (cons 1000 data70)
;        d80 (cons 1000 data80)
;        d90 (cons 1000 data90))
   (setq dd (list xdata_flag d10 d20 d30 d40 d60 d70 d80 d90)
         newdata (append (list -3 dd)))
   (setq newent (append oldentdata (list newdata)))
   (entmod newent)
 (princ)
)
;╭════════════════════╮
;║設計日期: 1998.05.06                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 將延伸資料加入(entlast)圖元   ║
;║          延伸資料識別名稱xdata_flag變數║
;║執行方式: (ad1xdata 延伸資料識別變數)   ║
;║相關檔案:                               ║
;╰════════════════════╯
;  (setq xdata (list xdata_flag d10 d20 d30 d40 d60 d70 d80 d90)
(defun ad1xdata(entname xdata_flag xdata)
   (regapp xdata_flag)
;  (setq entname (entlast))
   (setq oldentdata (entget entname))
;  (setq d10 (cons 1000 data10)
;        d20 (cons 1000 data20)
;        d30 (cons 1000 data30)
;        d40 (cons 1000 data40)
;        d60 (cons 1000 data60)
;        d70 (cons 1000 data70)
;        d80 (cons 1000 data80)
;        d90 (cons 1000 data90))
;  (setq xdata (list xdata_flag d10 d20 d30 d40 d60 d70 d80 d90)
   (setq newdata (append (list -3 xdata)))
   (setq newent (append oldentdata (list newdata)))
   (entmod newent)
 (princ)
)
;╭════════════════════╮
;║設計日期: 1997.12. 9                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 將延伸資料加入special  圖元   ║
;║          延伸資料識別名稱xdata_flag變數║
;║執行方式: (adxdata 延伸資料識別變數)    ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun add_newxdata_to_handle(handle xdata_flag xdata_code xdata)
   (regapp xdata_flag)
   (setq oldentdata (entget (handent handle)))
   (setq entdata (entget (handent handle) (list xdata_flag)))

   (if (null (assoc -3 entdata))
      (setq app_list (list xdata_flag (cons xdata_code xdata)))
     (progn
      (setq old_xdata (cadr (assoc -3 (handdata "PAGEMEMO" (handent pagememo_hand))))
            app_list (append old_xdata (list (cons xdata_code xdata))))
     );progn
   );if
   (setq ndata (append (list -3 app_list))
         nent (append oldentdata (list ndata)))
   (entmod nent)

 (princ)
)

;╭════════════════════╮
;║設計日期: 1996.02.24                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 取出延伸資料                  ║
;║                                        ║
;║執行方式: (gtxdata 延伸資料識別變數)    ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun gtxdata(flag)
       (setq ent (car (entsel)))
;      (setq entdata (entget ent '("BOM")))
       (setq entdata (entget ent (list flag)))
       (if (assoc -3 entdata)
             (setq data (cdr (cadr (cadr (assoc -3 entdata)))))
       );if
       entdata
)

;╭════════════════════╮
;║設計日期: 1997.04.09                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 自圖元ENT取出延伸資料         ║
;║                                        ║
;║執行方式: (gEtxdata 延伸資料識別變數)   ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun getxdata(ent flag)
       (setq entdata (entget ent (list flag)))
       (if (assoc -3 entdata)
          (progn
             (setq data (cdr (cadr (cadr (assoc -3 entdata)))))
             entdata
          )
          nil
       );if
)


;╭════════════════════╮
;║設計日期: 1996.02.24                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 將舊oldlist串列(有重覆元素)   ║
;║          過濾出new_list(無重覆元素)    ║
;║                                        ║
;║執行方式: (newlist 舊串列)              ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun newlist(oldlist)
  (setq new_list (list (car oldlist)))
  (foreach YY oldlist
       (progn
          (setq flag nil)
          (foreach ZZ new_list (if (= YY ZZ) (setq flag T)))
          (if (null flag) (setq new_list (cons YY new_list)))
       );progn
  )
  new_list
)

;╭════════════════════╮
;║設計日期: 1996.03.03                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 插入BLOCK,並旋轉角度          ║
;║                                        ║
;║執行方式:                               ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun xins(blkname)
   (setvar "cmdecho" 0)
   (princ "\n選擇圖形插入點...(或按Ctrl-C中斷指令執行)")
   (if (= acad_ver "GENIUS")
       (command ".insert" blkname pause "1" "1" "0")
       (command "insert" blkname pause "1" "1" "0")
   )
   (command "rotate" "l" "" "@")
   (setvar "cmdecho" 1)(princ)
)

;╭════════════════════╮
;║設計日期: 1996.03.03                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 改變MODEMACRO變數值           ║
;║                                        ║
;║執行方式:                               ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun china_name(name)
        (setvar "cmdecho" 0)
        (if (= name 0)
           (setvar "modemacro"
             (strcat (getvar "clayer") "層"
                     " $(if,$(getvar,orthomode),O)"
                     " $(if,$(getvar,snapmode),S)"
                     "<$(getvar,dwgname).dwg>"
                     " $(edtime,$(getvar,date),HH:MM)"
             );strcat
           );setvar
           (setvar "modemacro"
             (strcat name " $(if,$(getvar,orthomode),0)"
                          " $(if,$(getvar,snapmode),S)"
                          "<$(getvar,dwgname).dwg>"
;                         " $(edtime,$(getvar,date),'YY M/D HH:MM)"
                          " $(edtime,$(getvar,date),HH:MM)"
             );strcat
           );setvar
        );if
        (setvar "cmdecho" 1)(princ)
)

;╭════════════════════╮
;║程式名稱:                               ║
;║設計日期: 1996.03.04                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 計算弧長                      ║
;║                                        ║
;║相關檔案:                               ║
;╰════════════════════╯
;(defun arc_len(ename)
(defun arc_len(ename)
   (setq ent_data (entget ename))
   (setq sang (cdr (assoc 50 ent_data))
         eang (cdr (assoc 51 ent_data))
         arcr (cdr (assoc 40 ent_data)))
;  (if (> sang eang) (setq tran sang sang eang eang tran))
   (if (< sang eang)
     (setq arclen (* 0.01745 arcr (rtd (- eang sang))))
     (setq arclen (- (* 2 pi arcr) (* 0.01745 arcr (rtd (abs (- sang eang))))))
   )
   arclen
)
;╭════════════════════╮
;║程式名稱:                               ║
;║設計日期: 1996.03.04                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 計算直線長度                  ║
;║                                        ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun line_len(ename)
   (setq ent_data (entget ename))
   (setq linelen (distance (cdr (assoc 10 ent_data)) (cdr (assoc 11 ent_data))))
   linelen
)
;╭════════════════════╮
;║程式名稱:                               ║
;║設計日期: 1996.03.04                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 計算直線圓周長                ║
;║                                        ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun cir_len(ename)
   (setq ent_data (entget ename))
   (setq rad (cdr (assoc 40 ent_data)))
   (setq cirlen (* 2 pi rad))
   cirlen
)
;╭════════════════════╮
;║程式名稱:                               ║
;║設計日期: 1996.03.07                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 改變圖形到某層                ║
;║                                        ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun change_lay(laname)
  (setvar "cmdecho" 0)
  (princ "\n請選擇要改變圖層的圖元...")
  (setq ent (ssget))
  (if (tblsearch "LAYER" (strcase laname))
    (progn
       (command "change" "p" "" "p" "la" laname "")
       (princ (strcat "\n圖元已改變到" (strcase laname) "層了!!"))
    )
    (princ (strcat "\n目前圖檔並未建立 " (strcase laname) " 圖層!請先建立!!"))
  )
  (setvar "cmdecho" 1)(princ)
)


;╭════════════════════╮
;║程式名稱:                               ║
;║設計日期: 1996.03.07                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 尺寸爆炸回dim層               ║
;║                                        ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun c:dimexp()
   (setvar "cmdecho" 0)
   (princ "\n請選擇要炸開的尺寸... ")
   (setq seldim (ssget))
   (if (= acad_ver "GENIUS")
       (command ".explode" seldim)
       (command "explode" seldim)
   )
   (command "change" "p" "" "p" "la" "dim" "c" "bylayer" "")
   (setvar "cmdecho" 1)
   (princ)
)

;╭════════════════════╮
;║設 計 者: 陳冠達                        ║
;║功能說明: 畫線號框                      ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun txtbox(txttype txtp)
  (setq sca (getvar "dimscale"))
  (setq txtse (textbox (list (cons 1 txttype))))
  (setq txt1 (car txtse) txt2 (cadr txtse) dist (distance txt1 txt2))
  (setq txtp1 txtp txtp2 (polar txtp1 (angle txt1 txt2) dist))
  (setq txtp3 (list (car txtp2) (cadr txtp1))
        txtp4 (list (car txtp1) (cadr txtp2)))
  (setq ntxtp1 (polar txtp1 (angle txtp2 txtp1) sca)
        ntxtp1 (polar ntxtp1 (* pi 1.5) sca)
        ntxtp2 (polar txtp2 (angle txtp1 txtp2) sca)
        ntxtp2 (polar ntxtp2 (* pi 0.5) sca)
        ntxtp3 (polar txtp3 (angle txtp4 txtp3) sca)
        ntxtp3 (polar ntxtp3 (* pi 1.5) sca)
        ntxtp4 (polar txtp4 (angle txtp3 txtp4) sca)
        ntxtp4 (polar ntxtp4 (* pi 0.5) sca))
  (setq oldos (getvar "osmode"))
  (setvar "osmode" 0)
  (command "pline" ntxtp1 ntxtp3 ntxtp2 ntxtp4 "c")
  (setvar "osmode" oldos)
)


;╭════════════════════════╮
;║設計日期: 1997.04.09                            ║
;║更新日期:                                       ║
;║設 計 者: 陳冠達                                ║
;║功能說明: 將延伸資料extdata 加入(entlast)圖元   ║
;║          延伸資料識別名稱xdata_flag變數        ║
;║執行方式:(add_new_xdata 延伸資料識別變數extdata)║
;║相關檔案:                                       ║
;╰════════════════════════╯
(defun add_new_xdata(xdata_flag extdata)
   (regapp xdata_flag)
   (setq entname (entlast))
   (setq oldentdata (entget entname))
;  (setq alldata (list data10 data20 data30 data40 data60 data70 data80 data90))
;  (setq d10 (cons 1000 data10)
;        d20 (cons 1000 data20)
;        d30 (cons 1000 data30)
;        d40 (cons 1000 data40)
;        d60 (cons 1000 data60)
;        d70 (cons 1000 data70)
;        d80 (cons 1000 data80)
;        d90 (cons 1000 data90))
;  (setq extdata (list xdata_flag d10 d20 d30 d40 d60 d70 d80 d90))
   (setq newdata (append (list -3 extdata)))
   (setq newent (append oldentdata (list newdata)))
   (entmod newent)
 (princ)
)

;; 換圖層, 線形,顏色
(defun ch_to_lty_la_col(layname ltype col)
   (setq curlayer (getvar "clayer"))
   (setq curcolor (getvar "cecolor"))
   (setq curltype (getvar "celtype"))
   (setq la (tblsearch "layer" layname))
   (if (= la nil) (command "layer" "n" layname "c" col layname ""))
   (command "linetype" "s" "bylayer" "" "color" "bylayer" "layer" "s" layname "")
   (command "linetype" "s" ltype "")
)

(defun mem_curset()
 (setq curlayer  (getvar "clayer"))
 (setq curcolor  (getvar "cecolor"))
 (setq curltype  (getvar "celtype"))
 (setq curosmode (getvar "osmode"))
)

(defun rt_to_old_set()
   (if curlayer (setvar "clayer" curlayer))
   (if curcolor (setvar "cecolor" curcolor))
   (if curltype (setvar "celtype" curltype))
   (if curosmode(setvar "osmode" curosmode))
)

;;呼叫文字檔
;╭════════════════════╮
;║設計日期: 1996.  .                      ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明:                               ║
;║                                        ║
;║執行方式:                               ║
;║相關檔案: pub-dcl.dcl(word)             ║
;╰════════════════════╯
(defun CALLword(fname)
  (setvar "cmdecho" 0)
  (actdcl "pub-dcl" "word")

;顯示資料於 list_box 內
  (set_tile "filename" "檔案載入中,請稍後...")
  (act_list fname)

  (set_tile "filename" (strcat "檔案名稱:" (strcase fname)))
  (mode_tile "add_col" 1)
  (mode_tile "up_data" 1)
  (mode_tile "del_data" 1)
; (action_tile "word_list" "(show_txt)")
  (mode_tile "edit_data" 1)

  (action_tile "accept" "(done_dialog)")
  (start_dialog)
  (setvar "cmdecho" 1)
  (princ)
)

;將選上得選項資料,顯示於編輯框上
;(defun show_txt(/ txtnum txt)
;  (setq txtnum (get_tile "word_list")
;        txt (nth (atoi txtnum) data_list))
;  (set_tile "edit_data" txt)
;)

;將文字檔顯示於列示框內
(defun act_list(filename)
  (setq data_list '())
  (setq opfile (open filename "r"))
  (setq data (read-line opfile))
  (while data
     (setq data_list (cons data data_list))
     (setq data (read-line opfile))
  )
  (close opfile)
  (setq data_list (reverse data_list))

;顯示資料於 list_box 內
; (setq data_list (act_list fname))
  (start_list "word_list")
  (mapcar 'add_list data_list)
  (end_list)
)

;將被選上的圖元 change 到另一圖層
(defun ch_lay_to(laname / aaa)
   (setq aaa (ssget))
   (command "change" aaa "" "p" "la" laname "")
   (princ (strcat "\n已經將所選的圖形改變到" (strcase laname) "圖層了!!"))
   (princ)
)

;start any pop_list
(defun act_pop_list (data_list key_name)
       (start_list key_name)
       (mapcar 'add_list data_list )
       (end_list)
)

;=============================================================================
;(defun cc(rownum)
(defun col_list_database(fname rownum)
  (setq data_list '())
  (setq opfile (open fname "r"))
; (setq opfile (open "c:\\pdesign\\database\\bear1.dat" "r"))
  (while (setq readdata (read-line opfile))
     (setq data (nth rownum (read readdata)))
     (setq data_list (cons data data_list))
  )
  (close opfile)
  (setq data_list (reverse data_list))
  data_list
)

(defun get_list_objdata(objtxt fname rownum)
  (setq aa objtxt)
  (setq bb fname)
  (setq cc rownum)
  (setq objtxt objtxt)
  (setq opfile (open fname "r"))
  (setq readdata (read-line opfile))
  (while readdata
    (setq objdata (read readdata))
    (setq data (nth rownum objdata))
    (if (/= data objtxt)
      (setq readdata (read-line opfile))
      (setq obj objdata readdata nil)
    )
  )
  obj
)



;;;收集所有圖層
(defun coll_layer(/ coll_layer_list ladata)
 (setq total_layer_list (list (cdadr (tblnext "layer" t))))
 (setq ladata (tblnext "layer"))
 (while ladata
   (setq total_layer_list (cons (cdadr ladata) total_layer_list))
   (setq ladata (tblnext "layer"))
 )
 total_layer_list
)

;;;收集所有block
(defun coll_block(/ total_block_list bldata)
 (setq total_block_list (list (cdadr (tblnext "BLOCK" t))))
 (setq bldata (tblnext "BLOCK"))
 (while bldata
   (setq total_block_list (cons (cdadr bldata) total_block_list))
   (setq bldata (tblnext "BLOCK"))
 )
 total_block_list
)


;;;存取所需舊系統變數
(defun save_sysvar()
   (setq old_color (getvar "cecolor")
         old_linetype (getvar "celtype")
         old_osmode (getvar "osmode")
         old_highlight (getvar "highlight")
         old_layer (getvar "clayer"))
)

;;;回存舊系統變數
(defun reset_sysvar()
   (setvar "cecolor" old_color)
   (setvar "celtype" old_linetype)
   (setvar "osmode" old_osmode)
   (setvar "highlight" old_highlight)
   (setvar "clayer" old_layer)
)


;;取文字對角兩點,長度與高度
(defun txt_data(txtent)
    (setq txtdata (entget txtent)
          txt2p (textbox (list (assoc 1 txtdata)))
          txtlp (nth 0 txt2p)
          txtrp (nth 1 txt2p)
          txtlen (- (nth 0 txtrp) (nth 0 txtlp))
          txthei (- (nth 1 txtrp) (nth 1 txtlp)))
)


;;按選擇顏色之button, 並取某_edit_box 之 key 值, 選擇完畢, 設定此 key 之新值
;;用於 0~256 色
(defun ddsel_col(key)
   (setq lacol (get_tile key))
   (setq newcol (acad_colordlg (atoi lacol)))
   (cond
      ((= newcol 0) (setq newcol "BYBLOCK"))
      ((= newcol 256) (setq newcol "BYLAYER"))
      ((/= nil newcol) (setq newcol (rtos newcol 2 0)))
   )

   (if (null newcol) (set_tile key lacol) (set_tile key newcol))
)



;;按選擇顏色之button, 並取某_edit_box 之 key 值, 選擇完畢, 設定此 key 之新值
;;用於 1~255 色
(defun ml_ddsel_col(key)
   (setq lacol (get_tile key))
   (if (/= "" lacol)
      (setq newcol (acad_colordlg (atoi lacol)))
      (setq newcol (acad_colordlg 1))
   )
   (while (or (= 0 newcol) (= 256 newcol))
     (princ "\n不可選擇 Bylayer 或 Byblock !")
     (setq lacol (get_tile key))
     (if (/= "" lacol)
        (setq newcol (acad_colordlg (atoi lacol)))
        (setq newcol (acad_colordlg 1))
     )
     (setq newcol (acad_colordlg 1))
   );while
   (if (null newcol) (set_tile key lacol) (set_tile key (rtos newcol 2 0)))
)

;;自由格式畫表單
;;(free_list 資料串列 表頭串列 水平方向 垂直方向 欄高 文字對齊方式 字高)
;; 表頭串列: '(("1" "電源1" "ss412" "1" "電源1" "ss412" "1" "電源1" "ss412" )("1" "電源1" "ss412" "1" "電源1" "ss412" "2" "電源2" "ss414")("1" "電源1" "ss412" "1" "電源1" "ss412" "3" "電源3" "ss416").....
;; 資料串列: '(("件號" "10") ("品名" "20")("材質" "30")("件號" "10") ("品名" "20")("材質" "30")("件號" "10") ("品名" "20")("材質" "30")))
;; 水平方向: 0,   180
;; 垂直方向: 90,  270
;; 文字對齊方式: "M",  "ML"
;; 例如: (free_list tdata_list label_list 180 270  8 "M" 4)


(defun free_list(tdata_list label_list xdir ydir colhei txttype txth /
          xang yang
             p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16 p17 p18 p19 p20 p21 pend
          label1_w label2_w label3_w label4_w label5_w label6_w label7_w label8_w label9_w
          label10_w label11_w label12_w label13_w label14_w label5_w label6_w label7_w
          label18_w label19_w label20_w
          label1 label2 label3 label4 label5 label6 label7 label8 label9 label10 label11
          label12 label13 label14 label5 label6 label7 label18 label19 label20
          p1-1 p2-1 p3-1 p4-1 p5-1 p6-1 p7-1 p8-1 p9-1 p10-1 p11-1 p12-1 p13-1 p14-1 p15-1 p16-1 p17-1 p18-1 p19-1 p20-1
          txt1p txt2p txt3p txt4p txt5p txt6p txt7p txt8p txt9p txt10p txt11p txt12p txt13p txt14p txt15p txt16p txt17p txt81p txt19p txt20p
          )
;(defun free_list(tdata_list label_list xdir ydir colhei txttype txth)
   (setvar "cmdecho" 0)

   (cond
     ((= xdir 0) (setq xang 0))
     ((= xdir 180) (setq xang pi))
   )
   (setq scal (getvar "dimscale"))
   (setq dy (* scal colhei))
   (cond
     ((= ydir 90) (setq yang (* pi 0.5)))
     ((= ydir 270) (setq yang (- (* pi 0.5))))
   )

                           (setq label1  (nth 0 (nth 0  label_list)) label1_w  (atof (nth 1 (nth 0  label_list))))
   (if (nth 1  label_list) (setq label2  (nth 0 (nth 1  label_list)) label2_w  (atof (nth 1 (nth 1  label_list)))) (setq label2_w  0))
   (if (nth 2  label_list) (setq label3  (nth 0 (nth 2  label_list)) label3_w  (atof (nth 1 (nth 2  label_list)))) (setq label3_w  0))
   (if (nth 3  label_list) (setq label4  (nth 0 (nth 3  label_list)) label4_w  (atof (nth 1 (nth 3  label_list)))) (setq label4_w  0))
   (if (nth 4  label_list) (setq label5  (nth 0 (nth 4  label_list)) label5_w  (atof (nth 1 (nth 4  label_list)))) (setq label5_w  0))
   (if (nth 5  label_list) (setq label6  (nth 0 (nth 5  label_list)) label6_w  (atof (nth 1 (nth 5  label_list)))) (setq label6_w  0))
   (if (nth 6  label_list) (setq label7  (nth 0 (nth 6  label_list)) label7_w  (atof (nth 1 (nth 6  label_list)))) (setq label7_w  0))
   (if (nth 7  label_list) (setq label8  (nth 0 (nth 7  label_list)) label8_w  (atof (nth 1 (nth 7  label_list)))) (setq label8_w  0))
   (if (nth 8  label_list) (setq label9  (nth 0 (nth 8  label_list)) label9_w  (atof (nth 1 (nth 8  label_list)))) (setq label9_w  0))
   (if (nth 9  label_list) (setq label10 (nth 0 (nth 9  label_list)) label10_w (atof (nth 1 (nth 9  label_list)))) (setq label10_w 0))
   (if (nth 10 label_list) (setq label11 (nth 0 (nth 10 label_list)) label11_w (atof (nth 1 (nth 10 label_list)))) (setq label11_w 0))
   (if (nth 11 label_list) (setq label12 (nth 0 (nth 11 label_list)) label12_w (atof (nth 1 (nth 11 label_list)))) (setq label12_w 0))
   (if (nth 12 label_list) (setq label13 (nth 0 (nth 12 label_list)) label13_w (atof (nth 1 (nth 12 label_list)))) (setq label13_w 0))
   (if (nth 13 label_list) (setq label14 (nth 0 (nth 13 label_list)) label14_w (atof (nth 1 (nth 13 label_list)))) (setq label14_w 0))
   (if (nth 14 label_list) (setq label15 (nth 0 (nth 14 label_list)) label15_w (atof (nth 1 (nth 14 label_list)))) (setq label15_w 0))
   (if (nth 15 label_list) (setq label16 (nth 0 (nth 15 label_list)) label16_w (atof (nth 1 (nth 15 label_list)))) (setq label16_w 0))
   (if (nth 16 label_list) (setq label17 (nth 0 (nth 16 label_list)) label17_w (atof (nth 1 (nth 16 label_list)))) (setq label17_w 0))
   (if (nth 17 label_list) (setq label18 (nth 0 (nth 17 label_list)) label18_w (atof (nth 1 (nth 17 label_list)))) (setq label18_w 0))
   (if (nth 18 label_list) (setq label19 (nth 0 (nth 18 label_list)) label19_w (atof (nth 1 (nth 18 label_list)))) (setq label19_w 0))
   (if (nth 19 label_list) (setq label20 (nth 0 (nth 20 label_list)) label20_w (atof (nth 1 (nth 19 label_list)))) (setq label20_w 0))

   (setq basep (getpoint "\n表單位置: "))

   (setq oldosmode   (getvar "osmode"))

   (setvar "osmode" 0)

   (cond
     ((= xdir 0) (setq p1 basep))
     ((= xdir 180) (setq p1 (polar basep pi (* scal (+ label1_w label2_w label3_w label4_w label5_w label6_w
                  label7_w label8_w label9_w label10_w label11_w label12_w label13_w label14_w
                  label15_w label16_w label17_w label18_w label19_w label20_w)))))
   );cond

;;draw list
;  (setq label_qty (length label_list))
   (setq p1_top (polar p1 yang (+ (* scal colhei) (* scal colhei (length tdata_list)))))

                        (setq p2 (polar p1 0 (* scal label1_w)) p2_top (polar p1_top 0 (* scal label1_w)))
   (if (/= 0 label2_w)  (progn (setq p3  (polar p2  0 (* scal label2_w))  p3_top  (polar p2_top 0  (* scal label2_w))) (command "line" p2  p2_top  "")))
   (if (/= 0 label3_w)  (progn (setq p4  (polar p3  0 (* scal label3_w))  p4_top  (polar p3_top 0  (* scal label3_w))) (command "line" p3  p3_top  "")))
   (if (/= 0 label4_w)  (progn (setq p5  (polar p4  0 (* scal label4_w))  p5_top  (polar p4_top 0  (* scal label4_w))) (command "line" p4  p4_top  "")))
   (if (/= 0 label5_w)  (progn (setq p6  (polar p5  0 (* scal label5_w))  p6_top  (polar p5_top 0  (* scal label5_w))) (command "line" p5  p5_top  "")))
   (if (/= 0 label6_w)  (progn (setq p7  (polar p6  0 (* scal label6_w))  p7_top  (polar p6_top 0  (* scal label6_w))) (command "line" p6  p6_top  "")))
   (if (/= 0 label7_w)  (progn (setq p8  (polar p7  0 (* scal label7_w))  p8_top  (polar p7_top 0  (* scal label7_w))) (command "line" p7  p7_top  "")))
   (if (/= 0 label8_w)  (progn (setq p9  (polar p8  0 (* scal label8_w))  p9_top  (polar p8_top 0  (* scal label8_w))) (command "line" p8  p8_top  "")))
   (if (/= 0 label9_w)  (progn (setq p10 (polar p9  0 (* scal label9_w))  p10_top (polar p9_top 0  (* scal label9_w))) (command "line" p9  p9_top  "")))
   (if (/= 0 label10_w) (progn (setq p11 (polar p10 0 (* scal label10_w)) p11_top (polar p10_top 0 (* scal label10_w)))(command "line" p10 p10_top "")))
   (if (/= 0 label11_w) (progn (setq p12 (polar p11 0 (* scal label11_w)) p12_top (polar p11_top 0 (* scal label11_w)))(command "line" p11 p11_top "")))
   (if (/= 0 label12_w) (progn (setq p13 (polar p12 0 (* scal label12_w)) p13_top (polar p12_top 0 (* scal label12_w)))(command "line" p12 p12_top "")))
   (if (/= 0 label13_w) (progn (setq p14 (polar p13 0 (* scal label13_w)) p14_top (polar p13_top 0 (* scal label13_w)))(command "line" p13 p13_top "")))
   (if (/= 0 label14_w) (progn (setq p15 (polar p14 0 (* scal label14_w)) p15_top (polar p14_top 0 (* scal label14_w)))(command "line" p14 p14_top "")))
   (if (/= 0 label15_w) (progn (setq p16 (polar p15 0 (* scal label15_w)) p16_top (polar p15_top 0 (* scal label15_w)))(command "line" p15 p15_top "")))
   (if (/= 0 label16_w) (progn (setq p17 (polar p16 0 (* scal label16_w)) p17_top (polar p16_top 0 (* scal label16_w)))(command "line" p16 p16_top "")))
   (if (/= 0 label17_w) (progn (setq p18 (polar p17 0 (* scal label17_w)) p18_top (polar p17_top 0 (* scal label17_w)))(command "line" p17 p17_top "")))
   (if (/= 0 label18_w) (progn (setq p19 (polar p18 0 (* scal label18_w)) p19_top (polar p18_top 0 (* scal label18_w)))(command "line" p18 p18_top "")))
   (if (/= 0 label19_w) (progn (setq p20 (polar p19 0 (* scal label19_w)) p20_top (polar p19_top 0 (* scal label19_w)))(command "line" p19 p19_top "")))
   (if (/= 0 label20_w) (setq pend(polar p20 0 (* scal label20_w))))


   (cond
     ((= 0 label2_w)   (setq pend p2 ))
     ((= 0 label3_w)   (setq pend p3 ))
     ((= 0 label4_w)   (setq pend p4 ))
     ((= 0 label5_w)   (setq pend p5 ))
     ((= 0 label6_w)   (setq pend p6 ))
     ((= 0 label7_w)   (setq pend p7 ))
     ((= 0 label8_w)   (setq pend p8 ))
     ((= 0 label9_w)   (setq pend p9 ))
     ((= 0 label10_w)  (setq pend p10))
     ((= 0 label11_w)  (setq pend p11))
     ((= 0 label12_w)  (setq pend p12))
     ((= 0 label13_w)  (setq pend p13))
     ((= 0 label14_w)  (setq pend p14))
     ((= 0 label15_w)  (setq pend p15))
     ((= 0 label16_w)  (setq pend p16))
     ((= 0 label17_w)  (setq pend p17))
     ((= 0 label18_w)  (setq pend p18))
     ((= 0 label19_w)  (setq pend p19))
     ((= 0 label20_w)  (setq pend p20))
   )

   (setq pend_top (polar pend yang (+ (* scal colhei) (* scal colhei (length tdata_list)))))
   (command "line" p1 pend "")
   (cond
     ((= ydir 90) (if (= acad_ver "GENIUS")
                   (command ".array" (entlast) "" "r"  (1+ (length tdata_list)) "1" dy)
                   (command "array" (entlast) "" "r"  (1+ (length tdata_list)) "1" dy)
                   ))
     ((= ydir 270) (if (= acad_ver "GENIUS")
                   (command ".array" (entlast) "" "r"  (1+ (length tdata_list)) "1" (- dy))
                   (command "array" (entlast) "" "r"  (1+ (length tdata_list)) "1" (- dy))
                   ))
   )


   (command "pline" pend "w" "0" "0" pend_top p1_top p1 "")

   (cond
     ((= "M" txttype) (setq p1-1 (polar p1 0 (* 0.5 scal label1_w)) txt1p (polar p1-1 yang (* 0.5 scal colhei))) (command "text" "m" txt1p  (* scal txth) "0" label1 )
                      (if label2  (progn (setq p2-1  (polar p2  0 (* 0.5 scal label2_w )) txt2p  (polar p2-1  yang (* 0.5 scal colhei))) (command "text" "m" txt2p  (* scal txth) "0" label2 ) ) )
                      (if label3  (progn (setq p3-1  (polar p3  0 (* 0.5 scal label3_w )) txt3p  (polar p3-1  yang (* 0.5 scal colhei))) (command "text" "m" txt3p  (* scal txth) "0" label3 ) ) )
                      (if label4  (progn (setq p4-1  (polar p4  0 (* 0.5 scal label4_w )) txt4p  (polar p4-1  yang (* 0.5 scal colhei))) (command "text" "m" txt4p  (* scal txth) "0" label4 ) ) )
                      (if label5  (progn (setq p5-1  (polar p5  0 (* 0.5 scal label5_w )) txt5p  (polar p5-1  yang (* 0.5 scal colhei))) (command "text" "m" txt5p  (* scal txth) "0" label5 ) ) )
                      (if label6  (progn (setq p6-1  (polar p6  0 (* 0.5 scal label6_w )) txt6p  (polar p6-1  yang (* 0.5 scal colhei))) (command "text" "m" txt6p  (* scal txth) "0" label6 ) ) )
                      (if label7  (progn (setq p7-1  (polar p7  0 (* 0.5 scal label7_w )) txt7p  (polar p7-1  yang (* 0.5 scal colhei))) (command "text" "m" txt7p  (* scal txth) "0" label7 ) ) )
                      (if label8  (progn (setq p8-1  (polar p8  0 (* 0.5 scal label8_w )) txt8p  (polar p8-1  yang (* 0.5 scal colhei))) (command "text" "m" txt8p  (* scal txth) "0" label8 ) ) )
                      (if label9  (progn (setq p9-1  (polar p9  0 (* 0.5 scal label9_w )) txt9p  (polar p9-1  yang (* 0.5 scal colhei))) (command "text" "m" txt9p  (* scal txth) "0" label9 ) ) )
                      (if label10 (progn (setq p10-1 (polar p10 0 (* 0.5 scal label10_w)) txt10p (polar p10-1 yang (* 0.5 scal colhei))) (command "text" "m" txt10p (* scal txth) "0" label10) ) )
                      (if label11 (progn (setq p11-1 (polar p11 0 (* 0.5 scal label11_w)) txt11p (polar p11-1 yang (* 0.5 scal colhei))) (command "text" "m" txt11p (* scal txth) "0" label11) ) )
                      (if label12 (progn (setq p12-1 (polar p12 0 (* 0.5 scal label12_w)) txt12p (polar p12-1 yang (* 0.5 scal colhei))) (command "text" "m" txt12p (* scal txth) "0" label12) ) )
                      (if label13 (progn (setq p13-1 (polar p13 0 (* 0.5 scal label13_w)) txt13p (polar p13-1 yang (* 0.5 scal colhei))) (command "text" "m" txt13p (* scal txth) "0" label13) ) )
                      (if label14 (progn (setq p14-1 (polar p14 0 (* 0.5 scal label14_w)) txt14p (polar p14-1 yang (* 0.5 scal colhei))) (command "text" "m" txt14p (* scal txth) "0" label14) ) )
                      (if label15 (progn (setq p15-1 (polar p15 0 (* 0.5 scal label15_w)) txt15p (polar p15-1 yang (* 0.5 scal colhei))) (command "text" "m" txt15p (* scal txth) "0" label15) ) )
                      (if label16 (progn (setq p16-1 (polar p16 0 (* 0.5 scal label16_w)) txt16p (polar p16-1 yang (* 0.5 scal colhei))) (command "text" "m" txt16p (* scal txth) "0" label16) ) )
                      (if label17 (progn (setq p17-1 (polar p17 0 (* 0.5 scal label17_w)) txt17p (polar p17-1 yang (* 0.5 scal colhei))) (command "text" "m" txt17p (* scal txth) "0" label17) ) )
                      (if label18 (progn (setq p18-1 (polar p18 0 (* 0.5 scal label18_w)) txt18p (polar p18-1 yang (* 0.5 scal colhei))) (command "text" "m" txt18p (* scal txth) "0" label18) ) )
                      (if label19 (progn (setq p19-1 (polar p19 0 (* 0.5 scal label19_w)) txt19p (polar p19-1 yang (* 0.5 scal colhei))) (command "text" "m" txt19p (* scal txth) "0" label19) ) )
                      (if label20 (progn (setq p20-1 (polar p20 0 (* 0.5 scal label20_w)) txt20p (polar p20-1 yang (* 0.5 scal colhei))) (command "text" "m" txt20p (* scal txth) "0" label20) ) )
;(setq tdata_list '(("1" "電源1" "ss412")("2" "電源2" "ss414")("3" "電源3" "ss416")
                      (setq count 0)
                      (foreach nn tdata_list
                        (progn
                          (setq txt1p (polar txt1p yang dy)) (command "text" "m" txt1p  (* scal txth) "0" (nth 0 nn))
                          (if label2 (progn (setq txt2p (polar txt2p yang dy)) (command "text" "m" txt2p  (* scal txth) "0" (nth 1 nn))))
                          (if label3 (progn (setq txt3p (polar txt3p yang dy)) (command "text" "m" txt3p  (* scal txth) "0" (nth 2 nn))))
                          (if label4 (progn (setq txt4p (polar txt4p yang dy)) (command "text" "m" txt4p  (* scal txth) "0" (nth 3 nn))))
                          (if label5 (progn (setq txt5p (polar txt5p yang dy)) (command "text" "m" txt5p  (* scal txth) "0" (nth 4 nn))))
                          (if label6 (progn (setq txt6p (polar txt6p yang dy)) (command "text" "m" txt6p  (* scal txth) "0" (nth 5 nn))))
                          (if label7 (progn (setq txt7p (polar txt7p yang dy)) (command "text" "m" txt7p  (* scal txth) "0" (nth 6 nn))))
                          (if label8 (progn (setq txt8p (polar txt8p yang dy)) (command "text" "m" txt8p  (* scal txth) "0" (nth 7 nn))))
                          (if label9 (progn (setq txt9p (polar txt9p yang dy)) (command "text" "m" txt9p  (* scal txth) "0" (nth 8 nn))))
                          (if label10 (progn (setq txt10p (polar txt10p yang dy)) (command "text" "m" txt10p  (* scal txth) "0" (nth 9  nn))))
                          (if label11 (progn (setq txt11p (polar txt11p yang dy)) (command "text" "m" txt11p  (* scal txth) "0" (nth 10 nn))))
                          (if label12 (progn (setq txt12p (polar txt12p yang dy)) (command "text" "m" txt12p  (* scal txth) "0" (nth 11 nn))))
                          (if label13 (progn (setq txt13p (polar txt13p yang dy)) (command "text" "m" txt13p  (* scal txth) "0" (nth 12 nn))))
                          (if label14 (progn (setq txt14p (polar txt14p yang dy)) (command "text" "m" txt14p  (* scal txth) "0" (nth 13 nn))))
                          (if label15 (progn (setq txt15p (polar txt15p yang dy)) (command "text" "m" txt15p  (* scal txth) "0" (nth 14 nn))))
                          (if label16 (progn (setq txt16p (polar txt16p yang dy)) (command "text" "m" txt16p  (* scal txth) "0" (nth 15 nn))))
                          (if label17 (progn (setq txt17p (polar txt17p yang dy)) (command "text" "m" txt17p  (* scal txth) "0" (nth 16 nn))))
                          (if label18 (progn (setq txt18p (polar txt18p yang dy)) (command "text" "m" txt18p  (* scal txth) "0" (nth 17 nn))))
                          (if label19 (progn (setq txt19p (polar txt19p yang dy)) (command "text" "m" txt19p  (* scal txth) "0" (nth 18 nn))))
                          (if label20 (progn (setq txt20p (polar txt20p yang dy)) (command "text" "m" txt20p  (* scal txth) "0" (nth 19 nn))))
                          (setq count (1+ count))
                        );progn
                      );foreach
     )
   )

   (setvar "osmode" oldosmode)
   (princ)
)

;將整數文字串列排序
;╭════════════════════╮
;║設計日期: 1998. 5. 9                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 將整數文字串列排序            ║
;║執行方式:                               ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun int_list_sort(typ numlist)
   (setq numlist (acad_strlsort numlist))
   (setq max_txtnum (strlen (nth 0 numlist)))
   (foreach nn numlist
      (progn
        (if (> (strlen nn) max_txtnum) (setq max_txtnum (strlen nn)))
      )
   )
   (setq newnum_list '("0") count 1 coun -1)
   (setq lastnum nil)
   (repeat max_txtnum
      (foreach nn numlist
        (progn
          (cond
            ((= 0 typ)
                   (if (and (= count (strlen nn)) (/= nn lastnum))
                     (progn
                       (setq newnum_list (cons nn newnum_list))
                       (setq coun (1+ coun))
                       (setq lastnum (car newnum_list))
                     );progn
                   );if
            )
            (T (if (= count (strlen nn))
                 (progn
                   (setq newnum_list (cons nn newnum_list))
                   (setq coun (1+ coun))
                 );progn
               );if
            )
          );cond
        );progn
      );foreach
      (setq count (1+ count))
   )
   (cdr (reverse newnum_list))
)


;╭═══════════════════════╮
;║設計日期: 2000. 1. 1                          ║
;║更新日期:                                     ║
;║設 計 者: 陳冠達                              ║
;║功能說明: 刪除或修改某檔案內特定列            ║
;║執行方式:                                     ║
;║相關檔案:                                     ║
;╰═══════════════════════╯
; objcol 是 list_box 資料項被點選的回應值
;  type= 1 刪除資料
(defun modify_file(opff wrff objcol newdata typ)
   (setq opf (open opff "r"))
   (setq wrf (open wrff "w"))
   (repeat objcol
     (setq data (read-line opf))
     (write-line data wrf)
   )
   (cond
     ((= typ 1) (read-line opf))
     ((= typ 2) (read-line opf)
                (write-line newdata wrf)
     )
     (T (princ))
   )
   (setq data (read-line opf))
   (while data
     (write-line data wrf)
     (setq data (read-line opf))
   )
   (close opf)(close wrf)

   (setq opf (open wrff "r"))
   (setq wrf (open opff "w"))
   (setq data (read-line opf))
   (setq flag T)
   (while data
     (write-line data wrf)
     (setq data (read-line opf))
   );while
   (close opf)(close wrf)
)



;typ= 0 在某檔案內特定列之下加入一列
;typ= 1 在某檔案內特定列之上加入一列
;typ= 3 修改某檔案內特定列
;╭═══════════════════════╮
;║設計日期: 1998. 5. 9                          ║
;║更新日期: 1999.12.24                          ║
;║設 計 者: 陳冠達                              ║
;║功能說明: 在某檔案內特定列之上或之下加入一列  ║
;║執行方式:                                     ║
;║相關檔案:                                     ║
;╰═══════════════════════╯
;(insline_tofile 目標檔案 暫存檔案 目標行 加入之文字 type)
(defun insline_tofile(opff wrff objcol addcol typ)
   (setq opf (open opff "r"))
   (setq wrf (open wrff "w"))
   (setq data (read-line opf))
   (setq flag T)
   (while data
     (if (= data objcol)
       (progn
          (cond
            ((= typ 0)
               (write-line data wrf)
               (write-line addcol wrf))
            ((= typ 1)
               (write-line addcol wrf)
               (write-line data wrf))
            ((= typ 3) (write-line addcol wrf))
          );cond
       );progn
       (write-line data wrf)


     );if
     (setq data (read-line opf))
   );while
   (close opf)(close wrf)

   (setq opf (open wrff "r"))
   (setq wrf (open opff "w"))
   (setq data (read-line opf))
   (setq flag T)
   (while data
     (write-line data wrf)
     (setq data (read-line opf))
   );while
   (close opf)(close wrf)
)

;;取目前圖檔名
;(defun curdwgname()
;  (setq filename (getvar "dwgname"))
;  (setq txt_id (get_word filename "."))
;  (setq drwname (substr filename 1 (- txt_id 1)))
;  drwname
;)
(defun curdwgname(/ str_file)
	(setq str_file (getvar "dwgname"))
  	(setq str_file (substr str_file 1 (- (strlen str_file) 4)))
  	str_file
)

;;取出含路徑path與延伸檔名之字串fn的檔名newfn
(defun get_pathfname(fn path)
   (setq newfn (substr fn (1+ (strlen path))))
   (setq newfn (strcase (substr newfn 1 (- (strlen newfn) 4))))
   newfn
)


;;去除文字串後面所有空格 "123    " ==> "123"
(defun getrealstr(str / num chkflg coun)
   (setq num (strlen str))
   (setq chkflg nil)
   (repeat num
     (setq coun 1)
     (if (/= " " (substr str coun 1))(setq chkflg t))
     (setq coun (1+ coun))
   )
   (cond
     ((= 1 num)  (if (= (substr str 1 1) " ")(setq str "")))
     ((= 0 num) (princ))
     ((null chkflg) (setq str ""))
     (T
       (while (= " " (substr str (- num 1) 1))
          (setq str (substr str 1 (- num 1)))
          (setq num (strlen str))
       )
       (if (= " " (substr str (strlen str) 1))
         (progn
           (setq str (substr str 1 (- (strlen str) 1)))
         );progn
       );if
     ) ;t
   );cond
   str
)

;;去除文字串前面所有空格 "    123" ==> "123"
(defun getrealstr2(txt)
   (if txt (progn
   (if (> (strlen txt) 0)
     (progn
       (while (= " " (substr txt 1 1))
         (setq txt (substr txt 2))
       );while
     );progn
   );if
   ));2003.08.12 SAM
   txt
)

;;去除文字串前後面所有空格 "    123 qwer   " ==> "123 qwer"
(defun getrealstr4(txtt / count txt ttid)
   (setq count 1 txt "")
   (repeat (strlen txtt)
     (if (/= " " (setq ttid (substr txtt count 1)))
        (setq txt (strcat txt ttid))
     )(setq count (1+ count))
   )
   txt
)

;;去除文字串前後面與中間所有空格 "    123 qwer   " ==> "123qwer"
(defun getrealstr3(txtt / a b)
   (setq a (getrealstr  txtt))
   (setq b (getrealstr2 a))
   b
)


;;;去除文字串前後面所有空格 "    123   " ==> "123"
;;(defun getrealstr3(txtt / count txt ttid)
;(defun getrealstr3(txtt)
;   (setq count 1 txt "" spacetxt "" space_flg nil)
;   (setq txtt (getrealstr2 txtt))  ;去除文字串前面所有空格
;   (repeat (strlen txtt)
;     (if (/= " " (setq ttid (substr txtt count 1)))
;        (progn
;          (if space_flg
;             (setq txt (strcat txt spacetxt ttid) space_flg nil spacetxt "")
;             (setq txt (strcat txt ttid))
;          );if
;        )
;        (setq spacetxt (strcat spacetxt " ") space_flg t)
;     )(setq count (1+ count))
;   )
;   txt
;)


;;選取某一項特定圖元資料之圖元
;;例如: (ssget1 8 "PROJ")
(defun ssget1 (code1 entdata1)
  (setq selent (ssget "x" (list (cons code1 entdata1))))
)

;;選取某二項特定圖元資料之圖元
;;例如: (ssget2 8 "PROJ" 0 "DIM")
(defun ssget2 (code1 entdata1 code2 entdata2)
  (setq selent (ssget "x" (list (cons code1 entdata1)(cons code2 entdata2))))
)

;;取某特定屬性詳細資料
;;例: (getatt selent 2 "NUMBER")  回應該屬性詳細資料,無資料則回應 nil
(defun getatt(ent code attword)
   (setq data (entget (entnext ent)))
   (setq data2 (cdr (assoc 2 data)))
   (setq flag t)
   (while (and (= flag t)(/= data2 attword))
          (if (assoc -1 data)      
              (setq entt (entnext (cdr (assoc -1 data))))
	      (setq entt nil)
          )
          ;(prin1 data)
          (if (null entt)
	      (setq data nil flag nil)
	      (progn
                  (setq data (entget entt))
	          (if (assoc 2 data)(setq data2 (cdr (assoc 2 data))))
	      )
          )
   )
   data 
)
;; 2004.08.05 SAM (LT-PP)
;;(defun getatt(ent code attword)
;;   (setq data (entget (entnext ent)))
;;   (setq data2 (cdr (assoc 2 data)))
;;   (setq flag t)
;;   (while (and (= flag t)(/= data2 attword))
;;      (setq entt (entnext (cdr (assoc -1 data))))
;;      (if (null entt)(setq data nil flag nil)
;;        (setq data (entget entt)
;;              data2 (cdr (assoc 2 data)))
;;      )
;;   )
;;   data
;;)


;;取出某圖元選集中, 特定代碼內容之集合
(defun selgrp_datalist(grp code)
   (setq count 0 beselgrp '())
   (repeat (sslength grp)
     (setq enthandle (cdr (assoc code (entget (ssname grp count)))))
     (setq beselgrp (cons enthandle beselgrp))
     (setq count (1+ count))
   );repeat
   beselgrp
)

;;移除串列(li) 中某一元素(obj), 並回應移除後的串列 (89.12.23)
(defun removelist(obj li / newlist)
   (setq newlist '())
   (foreach nn li
     (progn
        (if (/= nn obj) (setq newlist (cons nn newlist)))
     );progn
   )
   (reverse newlist)
)

;;;請使用者輸入檔名
(defun keyin_newfile(mess path filetype rtkey)
    (setq ff (getfiled mess path filetype 1))
    (if ff  (set_tile rtkey ff))
)

;; 計算選擇集 grp 內, ? code 碼, ? val 值的圖元有幾個
;;ex: (ent_totalnum (ssget) 0 "ATTDEF")
(defun ent_totallnum(grp code val / num data count tolnum)
;  (setq grp (ssget))
   (setq num (sslength grp))
   (setq count 0 tolnum 0)
   (repeat num
     (setq data (ssname grp count))
     (setq data0 (cdr (assoc code (entget data))))
     (if (= val data0) (setq tolnum (1+ tolnum)))
     (setq count (1+ count))
   )
   tolnum
)

;;;
;╭════════════════════╮
;║設計日期:                               ║
;║更新日期: 編輯文字檔                    ║
;║設 計 者: 陳冠達                        ║
;║功能說明:                               ║
;║                                        ║
;║執行方式:                               ║
;║相關檔案: pub-dcl.dcl(word)             ║
;╰════════════════════╯
(defun editword(fname)
  (setvar "cmdecho" 0)
  (actdcl "pub-dcl" "word")

;顯示資料於 list_box 內
  (set_tile "filename" "檔案載入中,請稍後...")
  (act_list fname)

  (set_tile "filename" (strcat "檔案名稱:" (strcase fname)))
  (action_tile "add_col"  "(add_col)")
  (action_tile "up_data"  "(updata (get_tile \"edit_data\"))")
  (action_tile "del_data" "(del_col)")
  (action_tile "word_list" "(show_txt)")

  (action_tile "accept" "(done_dialog)")
  (start_dialog)
  (setvar "cmdecho" 1)
  (princ)
)

(defun updata(value)
  (setq txtnum (get_tile "word_list"))
  (if (= "" txtnum)
     (allert "elecr4" "allert" "請先選擇要修改的選項!!")
     (progn
       (setq count 0)
       (setq opfile (open fname "w"))
       (repeat (length data_list)
         (cond
           ((= txtnum (rtos count 2 0)) (set_tile "edit_data" "")(write-line value opfile))
;          ((= value "del") (setq value nil))
           (t (write-line (nth count data_list) opfile))
         )
         (setq count (1+ count))
       );repeat
       (close opfile)
       (act_list fname)
     );progn
  );if
)

(defun del_1_col()
  (setq txtnum (get_tile "word_list"))
  (set_tile "edit_data" "")
  (setq count 0)
  (setq opfile (open fname "w"))
  (repeat (length data_list)
     (if (/= txtnum (rtos count 2 0))
        (write-line (nth count data_list) opfile)
     )
     (setq count (1+ count))
  );repeat
  (close opfile)
  (act_list fname)
)

(defun add_1_col(id)
  (setq txtnum (get_tile "word_list"))
  (set_tile "edit_data" "")
  (setq count 0)
  (setq opfile (open fname "w"))
  (repeat (length data_list)
     (if (/= txtnum (rtos count 2 0))
        (write-line (nth count data_list) opfile)
        (progn
          (if (= 1 id)
           (progn
              (write-line "" opfile)
              (write-line (nth count data_list) opfile)
           );progn
           (progn
              (write-line (nth count data_list) opfile)
              (write-line "" opfile)
           );progn
          );if
        );progn
     );if
     (setq count (1+ count))
  );repeat
  (close opfile)
  (act_list fname)
)


;將選上得選項資料,顯示於編輯框上
(defun show_txt(/ txtnum txt)
  (setq txtnum (get_tile "word_list")
        txt (nth (atoi txtnum) data_list))
  (set_tile "edit_data" txt)
)

;將文字檔顯示於列示框內
(defun act_list(filename)
  (setq data_list '())
  (setq opfile (open filename "r"))
  (setq data (read-line opfile))
  (while data
     (setq data_list (cons data data_list))
     (setq data (read-line opfile))
  )
  (close opfile)
  (setq data_list (reverse data_list))

;顯示資料於 list_box 內
; (setq data_list (act_list fname))
  (start_list "word_list")
  (mapcar 'add_list data_list)
  (end_list)
)

;加入一列
(defun add_col()
  (setq txtnum (get_tile "word_list"))
  (if (= "" txtnum)
     (allert "elecr4" "allert" "請先選擇要修改的選項!!")
     (progn
        (setvar "cmdecho" 0)
        (actdcl "pub-dcl" "word1")

        (action_tile "accept" "(add_col_ok)(done_dialog)")
        (action_tile "cancel" "(setq u_col nil d_col nil)(done_dialog)")
        (start_dialog)
        (cond
         ((= "1" u_col) (add_1_col 1))
         ((= "1" d_col) (add_1_col 2))
        );cond
        (setvar "cmdecho" 1)
     );progn
  );if
  (princ)
)
(defun add_col_ok()
   (setq u_col (get_tile "u_col"))
   (setq d_col (get_tile "d_col"))
)

;刪除一列
(defun del_col()
  (setq txtnum (get_tile "word_list"))
  (if (= "" txtnum)
     (allert "elecr4" "allert" "請先選擇要修改的選項!!")
     (progn
        (setvar "cmdecho" 0)
        (actdcl "pub-dcl" "word2")

        (action_tile "accept" "(del_col_ok)(done_dialog)")
        (action_tile "cancel" "(SETQ dsave_col nil dall_col nil)(done_dialog)")
        (start_dialog)
        (cond
          ((= dsave_col "1")(updata ""))
          ((= dall_col "1")(del_1_col))    ;刪一整列
        )
        (setvar "cmdecho" 1)
     );progn
  )
  (princ)
)

(defun del_col_ok()
   (setq dall_col (get_tile "dall_col"))
   (setq dsave_col (get_tile "dsave_col"))
)

;;選擇要編輯的文字檔名
(defun c:edword()
  (setq aa (getfiled "請選擇要編輯的檔名" "" "" 2))
  (if aa
    (editword aa)
  )
  (princ)
)


;; 計算三角函數之 Y 值
(defun y_height(aang xval)
    (/ (* xval (sin aang)) (cos aang))
)

;;修改內定值型的尺寸標註
;;fun=1 前置 fun=2 後置  fun=3 前後皆加字 (auto_chgdim 2 "(H8)" "")>> 19 --> 19(H8)
;;                                        (auto_chgdim 1 "□" "")>>   19 --> □19
;;                                        (auto_chgdim 3 "(" ")")>>   19 --> (19)
;;區域變數check OK!!
(defun auto_chgdim(fun newtxt newtxt2 / data1 data0 ent entdata dim_type ang p1 p2 p3p4 old_txt new_txt)
  (setq beselent (entsel "\n選取標註:"))
  (setq ent (car beselent))
  (setq entdata(entget ent))
  (setq data0 (cdr (assoc 0 entdata)))
  (setq data1 (cdr (assoc 1 entdata)))
  (if (and (= data0 "DIMENSION") (= "" data1))
    (progn
      (setq dim_type (cdr(assoc 70 entdata)))
      (cond
          ((= dim_type 32)
           (setq ang (cdr(assoc 50 entdata)))
           (setq p1 (cdr(assoc 13 entdata)))
           (setq p2 (cdr(assoc 14 entdata)))
           (cond ((zerop ang)(setq old_txt (abs (- (car p1) (car p2)))))
                 ((= ang (* pi 0.5))(setq old_txt (abs (- (cadr p1) (cadr p2)))))
           )
           (cond ((= fun 2)(setq new_txt(strcat (rtos old_txt 2) newtxt)))
                 ((= fun 1)(setq new_txt(strcat newtxt (rtos old_txt 2))))
                 ((= fun 3)(setq new_txt(strcat newtxt (rtos old_txt 2) newtxt2)))
           )
          )
          ((= dim_type 33)
           (setq p1 (cdr(assoc 13 entdata)))
           (setq p2 (cdr(assoc 14 entdata)))
           (setq old_txt (distance p1 p2))
           (cond ((= fun 2)(setq new_txt(strcat (rtos old_txt 2) newtxt)))
                 ((= fun 1)(setq new_txt(strcat newtxt (rtos old_txt 2))))
                 ((= fun 3)(setq new_txt(strcat newtxt (rtos old_txt 2) newtxt2)))
           )
          )
          ((= dim_type 34)
           (setq p1 (cdr(assoc 13 entdata)))
           (setq p2 (cdr(assoc 14 entdata)))
           (setq p3 (cdr(assoc 15 entdata)))
           (setq p4 (cdr(assoc 10 entdata)))
           (setq old_txt(* 180 (/ (abs (- (angle p3 p4) (angle p2 p1))) pi)))
           (cond ((= fun 2)(setq new_txt(strcat (rtos old_txt 2) newtxt "%%D")))
                 ((= fun 1)(setq new_txt(strcat newtxt (rtos old_txt 2) "%%D")))
                 ((= fun 3)(setq new_txt(strcat newtxt (rtos old_txt 2) "%%D" newtxt2)))
           )
          )
          ((= dim_type 163);dia
           (setq p1 (cdr(assoc 10 entdata)))
           (setq p2 (cdr(assoc 15 entdata)))
           (setq old_txt(distance p1 p2))
           (cond ((= fun 2)(setq new_txt(strcat "%%C" (rtos old_txt 2) newtxt)))
                 ((= fun 1)(setq new_txt(strcat newtxt "%%C" (rtos old_txt 2))))
                 ((= fun 3)(setq new_txt(strcat newtxt "%%C" (rtos old_txt 2) newtxt2)))
           )
          )
          ((= dim_type 164);rad
           (setq p1 (cdr(assoc 10 entdata)))
           (setq p2 (cdr(assoc 15 entdata)))
           (setq old_txt(distance p1 p2))
           (cond ((= fun 2)(setq new_txt(strcat "R" (rtos old_txt 2) newtxt)))
                 ((= fun 1)(setq new_txt(strcat newtxt "R" (rtos old_txt 2))))
                 ((= fun 3)(setq new_txt(strcat newtxt "R" (rtos old_txt 2) newtxt2)))
           )
          )
          ((= dim_type 37);角度三點
           (setq p1 (cdr(assoc 13 entdata)))
           (setq p2 (cdr(assoc 14 entdata)))
           (setq p3 (cdr(assoc 15 entdata)))
           (setq old_txt(* 180 (/ (abs (- (angle p3 p1) (angle p3 p2))) pi)))
           (cond ((= fun 2)(setq new_txt(strcat (rtos old_txt 2) newtxt "%%D")))
                 ((= fun 1)(setq new_txt(strcat newtxt (rtos old_txt 2) "%%D")))
                 ((= fun 3)(setq new_txt(strcat newtxt (rtos old_txt 2) "%%D" newtxt2)))
           )
          )
          ((= dim_type 38);座標Y
           (setq p1 (cdr(assoc 13 entdata)))
           (setq old_txt(cadr p1))
           (cond ((= fun 2)(setq new_txt(strcat (rtos old_txt 2) newtxt)))
                 ((= fun 1)(setq new_txt(strcat newtxt (rtos old_txt 2))))
                 ((= fun 3)(setq new_txt(strcat newtxt (rtos old_txt 2) newtxt2)))
           )
          )
          ((= dim_type 102);座標X
           (setq p1 (cdr(assoc 13 entdata)))
           (setq old_txt(car p1))
           (cond ((= fun 2)(setq new_txt(strcat (rtos old_txt 2) newtxt)))
                 ((= fun 1)(setq new_txt(strcat newtxt (rtos old_txt 2))))
                 ((= fun 3)(setq new_txt(strcat newtxt (rtos old_txt 2) newtxt2)))
           )
          )
      )
      (command "dim")
      (command "new" new_txt ent "" "e")
    );progn
    (progn
      (cond
        ((= 1 fun) (setq new_txt (strcat newtxt data1)))
        ((= 2 fun) (setq new_txt (strcat data1 newtxt)))
        (T (setq new_txt (strcat newtxt data1 newtxt2)))
      );if
      (command "dim")
      (command "new" new_txt ent "" "e")
    );progn
  );if
);defun



(defun txt_tran(oldstr)
  (setq newstr "")
; (setq oldstr (getstring "\ninput string:"))
  (setq num (get_word oldstr "\""))
  (while num
    (setq newstr (strcat newstr (substr oldstr 1 (- num 1)) "\\" "\""))
    (if (/= nil (substr oldstr (+ num 1)))
      (setq oldstr (substr oldstr (+ num 1)))
    )
    (setq num (get_word oldstr "\""))
  )
  (setq newstr (strcat newstr oldstr))
; (setq ff (open "c:/1.txt" "w"))
; (write-line newstr ff)
; (close ff)
  newstr
)


;;新列取代舊列(用於系統資料定義)
;;(update_filedata   "路徑" "SYSTEM.INI" "SYSTEM.NEW "線型定義" "=")
;                  oldfile       newfile     label   flagtxt
(defun update_filedata(fpath oldfile newfile labl flagtxt outdata)
         (setq oldff (open (strcat fpath oldfile) "r"))
         (setq newff (open (strcat fpath newfile) "w"))
         (setq rd_data (read-line oldff))
      (while rd_data
         (setq flag_id (get_word rd_data "="))
         (if flag_id
           (progn
             (if (= labl (substr rd_data 1 (- flag_id 1)))
                 (write-line outdata newff)
                 (write-line rd_data newff)
             );if
           )
           (write-line rd_data newff)
         );if
         (setq rd_data (read-line oldff))
      )
      (close oldff)
      (close newff)

;;資料重新寫入
      (setq oldff (open (strcat fpath newfile) "r"))
      (setq newff (open (strcat fpath oldfile) "w"))
      (setq rd_data (read-line oldff))
      (while rd_data
         (write-line rd_data newff)
         (setq rd_data (read-line oldff))
      )
      (close oldff)
      (close newff)

)

;;將某檔案資料讀出,並回應成串列資料    (readfile_tolist "檔名")
(defun readfile_tolist(fname)
  (setq filelist '())
  (setq ff (open fname "r"))
  (setq data (read-line ff))
  (while data
     (setq datalist (read data))
     (setq filelist (cons datalist filelist))
     (setq data (read-line ff))
  )
  (close ff)
  (reverse filelist)
)

;將字串 "c:\\aa\\cc.txt" 轉成 "c:/aa/cc.txt
(defun trans_pathtxt(txt)
   (setq len (strlen txt) count 1 newtxt "")
   (repeat len
      (setq word (substr txt count 1))
      (if (= "\\" word)
          (setq newtxt (strcat newtxt "/"))
          (setq newtxt (strcat newtxt word))
      )
     (setq count (1+ count))
   )
   newtxt
)

;; 將字串 txt (例: "c:/abc/wer") 取出檔名 "wer")
(defun get_filename(txt kword)
   (setq id (get_word txt kword))
   (while (/= nil id)
     (setq txt (substr txt (1+ id)))
     (setq id (get_word txt kword))
   )
   txt
)

;; 將含有路徑的檔名字串(不含延伸檔名),取出路徑部份
(defun get_filepath(txt kword)
  (setq ktxt (substr txt (strlen txt) 1))
  (while (/= kword ktxt)
    (setq txt (substr txt 1 (- (strlen txt) 1)))
    (setq ktxt (substr txt (strlen txt) 1))
  )
  txt
)


;; 將字串 "A;B;C;D;E;F" 轉成("A" "B" "C" "D" "E" "F")
(defun TXT_TRAN_LIST(string)
  (setq newlist '())
  (setq txt_id (get_word string ";"))
  (while txt_id
    (setq aaa string)
    (setq txt (substr string 1 (- txt_id 1)))
    (setq string (substr string (1+ txt_id)))
    (setq newlist (cons txt newlist))
    (setq txt_id (get_word string ";"))
  )
  (setq newlist (cons string newlist))
  (setq newlist (reverse newlist))
  newlist
);defun



;;讀取某檔案之內部資料                 (getfile_val filename "零件定義資料")
;;例: 零件定義資料=(("品名" "PARTNAME") ("材質" "MATERIAL") ("#料號" "PNUM"))
(defun getfile_val(fname initxt / needdata dd)
  (setq ff (open fname "r"))
  (setq data (read-line ff))
  (while data
    (if (/= nil (setq txtid (get_word data "=")))
      (progn
        (setq objdata (substr data 1 (- txtid 1)))
        ;;(setq objdata (strcase (substr data 1 (- txtid 1))))
        (if (= objdata initxt)
           (setq dd data needdata (substr data (1+ txtid)) data nil)
           (setq data (read-line ff))
        );if
      );progn
      (setq data (read-line ff))
    );if
  );while
  (close ff)
  needdata
)

;; 是否畫中心線                            cenline_yesno
;; 2000.7.16
;; jackson
;; 備註: 本程式與 (draw_cline p1 p2) 合用
(defun cenline_yesno()
  (initget "Yes No")
  (setq clineyesno (getkword "\n是否畫中心線<Yes>: "))
  (if (or (null clineyesno) (= clineyesno "Yes"))
    (progn
      (setq clineyesno "Yes")
      (setq flt_ext (read (getfile_val (strcat powdesign_path "SYSTEM.ini") "中心線延伸距離")))
      (setq ext_length (getdist (strcat "\n延伸距離<" (rtos (* (getvar "dimscale") flt_ext) 2 2) ">: ")))
      (if (null ext_length) (setq ext_length (* (getvar "dimscale") flt_ext)))
    );progn
  );if
  (princ)
)

;; 畫軸中心線公用裎式                    draw_cline(p1 p2)
;; 2000.7.16
;; jackson
;; 備註: 本程式與 (cenline_yesno) 合用

(defun draw_cenline(p1 p2 / cp1 cp2 oldcol oldltype oldos)
  (if (= "Yes" clineyesno)
    (progn
      (setq clineang (angle p1 p2))
      (if (or (and (>= clineang 0)(< clineang (* pi 0.5)))
              (and (>= (* 1.5 pi) clineang) (< clineang (* pi 2)))
           );or
          (progn
             (setq cp1 (polar p1 (+ pi clineang) ext_length))
             (setq cp2 (polar p2 clineang ext_length))
          );progn
          (progn
             (setq cp1 (polar p1 (+ pi clineang) ext_length))
             (setq cp2 (polar p2 clineang ext_length))
          );progn
      );if
      (setq oldcol   (getvar "cecolor"))
      (setq oldltype (getvar "celtype"))
      (setq oldos    (getvar "osmode"))
      (setvar "osmode" 0)
      (c:&cl&)
      (command "line" cp1 cp2 "")
      (setvar "cecolor" oldcol)
      (setvar "celtype" oldltype)
      (setvar "osmode"  oldos)
      (setq clineyesno nil ext_length nil)
    );progn
    (princ)
  );if
);defun


;;畫圓中心線公用裎式
;; 2000.7.16
;; jackson
;; 備註: 本程式與 (cenline_yesno) 合用

(defun getoldvar() (setq oldosvar (getvar "osmode")
                         oldcovar (getvar "cecolor")
                         oldlavar (getvar "clayer")))
(defun retoldvar()
  	(if oldosvar (setvar "osmode" oldosvar))
  	(if oldcovar (setvar "cecolor" oldcovar))
        (if oldlavar (setvar "clayer" oldlavar))
)
(defun drawcircle_cenline(ent)
  (if (= "Yes" clineyesno)
    (progn
       (getoldvar)
       (setq curcolor (getvar "cecolor"))
       (setq curltype (getvar "celtype"))
       (setq cen (getvar "dimcen"))
       (setq exts ext_length)

       (setq e (entget ent))
       (setq la (cdr (assoc 8 e)))
       (setq r (cdr (assoc 40 e)))
       (c:&cl&)
       (setvar "osmode" 0)
       (setq p1 (cdr (assoc 10 e)))
       (setq p1 (trans p1 0 1))
             (setq pu (polar p1 (* pi 0.5) (+ r exts))
                   pd (polar p1 (- (* pi 0.5)) (+ r exts))
                   pl (polar p1 pi (+ r exts))
                   pr (polar p1 0 (+ r exts))
             )
             (command "layer" "s" la "")


             (command "line" pl pr "")
       (if (/= nil zz) (setq zz (ssadd (entlast) zz)))

             (command "line" pu pd "")
       (command "linetype" "s" curltype "")
       (cond
         ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
         ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
         (T (command "color" (atoi curcolor)))
       )
       (retoldvar)
    );progn
   );if
   (princ)
)
;;====================================================================
;;ent 是一個帶有屬性的圖元, 將 ent 內所有屬性資料與標簽取出
;;(defun getent_allatt(ent / att_list entdata attdata attflag)
;;   (setq att_list '())
;;   (while (setq ent (entnext ent))
;;     (setq entdata (entget ent))
;;     (if (= "ATTRIB" (cdr (assoc 0 entdata)))
;;       (progn
;;         (setq attdata (cdr (assoc 1 entdata)))
;;         (setq attflag (cdr (assoc 2 entdata)))
;;         (setq att_list (cons (list attflag attdata) att_list))
;;       );progn
;;     );if
;;   );while
;;   att_list
;;)
;;
;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 取得圖框屬性串列資料                                 │
;;;│  主程式 : (getent_allatt 屬性BLOCK)                            │
;;;│  日  期 : 2004/08/06                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 :                                                      │
;;;│  說  明 : 傳回如=>(("CHECK" "")("MATRIAL" "S45C")...)          │
;;;└────────────────────────────────┘
;;;
(defun getent_allatt(ent / str_ename ent str_lab1 str_lab2 att_list)
	(setq ent (entnext ent))
	(while ent
		(setq str_ename (cdr (assoc 0 (entget ent))))
	  	(cond ((= "ATTRIB" str_ename)
		       (setq str_lab1 (cdr (assoc 1 (entget ent))))
	  	       (setq str_lab2 (cdr (assoc 2 (entget ent))))
		       (setq att_list  (cons (list str_lab2 str_lab1) att_list))
		       (setq ent (entnext ent)))
		      ((= "SEQEND" str_ename)(setq ent nil))
		      (t (setq ent (entnext ent)))
		)
	)
  	att_list
)
;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 取得目前字型固定字高,並且將固定字高設為0             │
;;;│  主程式 : (ffont_height_get)                                   │
;;;│  日  期 : 2004/08/06                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 :                                                      │
;;;│  說  明 : 改變固定字高會影響功能的使用如: 自動指標球           │
;;;└────────────────────────────────┘
;;;
(defun ffont_height_get(/ str_st lst_obj flt_txt)
	(setq str_st  (getvar "textstyle"))
  	(setq lst_obj (entget (tblobjname "style" str_st)))
  	(setq flt_txt (cdr (assoc 40 lst_obj)))
  	(setq lst_obj (subst (cons 40 0.0)(assoc 40 lst_obj) lst_obj))
  	(entmod lst_obj)
  	flt_txt
)
;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 設定目前字型固定字高                                 │
;;;│  主程式 : (ffont_height_set 3.0)                               │
;;;│  日  期 : 2004/08/06                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 :                                                      │
;;;│  說  明 : 函式帶入參數指定高度                                 │
;;;└────────────────────────────────┘
;;;
(defun ffont_height_set(flt_txt / str_st lst_obj)
  	(setq str_st  (getvar "textstyle"))
  	(setq lst_obj (entget (tblobjname "style" str_st)))
  	(if flt_txt 
  	    (setq lst_obj (subst (cons 40 flt_txt)(assoc 40 lst_obj) lst_obj))
	)
  	(entmod lst_obj)
)
;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 判斷 AutoCAD 版本                                    │
;;;│  主程式 : (get_acadver)                                        │
;;;│  日  期 : 2004/08/06                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 :                                                      │
;;;│  說  明 : 可判斷各種版本如: "ACAD_R14"      => AutoCAD R14     │
;;;│                             "ACAD_2002_MDT" => MDT6	     │
;;;│                             "ACLT_2001"     => AutoCAD LT 2000i│
;;;└────────────────────────────────┘
;;;
(defun get_acadver(/ str_ver str_mnu lst_tmp str_int str_ret symbolstr_list)

	(setq str_ver (getvar "acadver"))
  	(setq str_mnu (getvar "menuname"))
	(defun symbolstr_list(string symbol / i str_unit lst_strs)
		(setq i 1)
		(while  (/= 0 (strlen string))
  			(while  (= symbol (substr string i 1))
		  		(setq str_unit (substr string 1 (- i 1)))
		  		(setq lst_strs (cons str_unit lst_strs))
		  		(setq string   (substr string (+ i 1)))
		  		(setq i 1)
			)
	  		(setq i (1+ i))
	  		(if (> i (strlen string))(progn
				(setq lst_strs (cons (substr string 1) lst_strs))
				(setq string   (substr string (+ i 1)))
			))
		)
  		(setq lst_strs  (reverse lst_strs))
  		lst_strs
	)
  	(if (setq lst_tmp (symbolstr_list str_mnu "\\"))
	    (setq str_mnu (strcase (last lst_tmp)))
	    (setq str_mnu nil)
	)
  	(setq str_int (substr str_ver 1 2))
  	(cond ((= "14" str_int)(setq str_ret "ACAD_R14"))
	      ((= "15" str_int)
	       (cond ((= 0 (atoi (substr str_ver 4 2)))
		           (cond ((= "ACLT"    str_mnu)(setq str_ret "ACLT_2000"))
				 ((= "ACAD"    str_mnu)(setq str_ret "ACAD_2000"))
				 ((= "ACADMPP" str_mnu)(setq str_ret "ACAD_2000_M"))
				 ((= "AMDTPP"  str_mnu)(setq str_ret "ACAD_2000_MDT"))
				 (t (setq str_ret "ACAD_2000"))
			   )
		     )
		     ((= 5 (atoi (substr str_ver 4 2)))
		           (cond ((= "ACLT"    str_mnu)(setq str_ret "ACLT_2001"))
				 ((= "ACAD"    str_mnu)(setq str_ret "ACAD_2001"))
				 ((= "ACADMPP" str_mnu)(setq str_ret "ACAD_2001_M"))
				 ((= "AMDTPP"  str_mnu)(setq str_ret "ACAD_2001_MDT"))
				 (t (setq str_ret "ACAD_2001"))
			   )
		     )
		     ((= 6 (atoi (substr str_ver 4 2)))
		      	   (cond ((= "ACLT"    str_mnu)(setq str_ret "ACLT_2002"))
			         ((= "ACAD"    str_mnu)(setq str_ret "ACAD_2002"))
				 ((= "ACADMPP" str_mnu)(setq str_ret "ACAD_2002_M"))
				 ((= "AMDTPP"  str_mnu)(setq str_ret "ACAD_2002_MDT"))
				 (t (setq str_ret "ACAD_2002"))
			   )
		     )
		     (t    (setq str_ret "ACAD_2000"))
	      ))
	      ((= "16" str_int)
	       (cond ((= 0 (atoi (substr str_ver 4 2)))
	       		   (cond ((= "ACLT"  str_mnu)(setq str_ret "ACLT_2004"))
		     		 ((= "ACAD"  str_mnu)(setq str_ret "ACAD_2004"))
				 ((= "ACADM" str_mnu)(setq str_ret "ACAD_2004_M"))
		     		 (t (setq str_ret "ACAD_2004"))
		           )
		     )
		     ((= 1 (atoi (substr str_ver 4 2)))
	       		   (cond ((= "ACLT"  str_mnu)(setq str_ret "ACLT_2005"))
		     		 ((= "ACAD"  str_mnu)(setq str_ret "ACAD_2005"))
				 ((= "ACADM" str_mnu)(setq str_ret "ACAD_2005_M"))
		     		 (t (setq str_ret "ACAD_2005"))
		           )
		     )
		     ((= 2 (atoi (substr str_ver 4 2)))
	       		   (cond ((= "ACLT"  str_mnu)(setq str_ret "ACLT_2006"))
		     		 ((= "ACAD"  str_mnu)(setq str_ret "ACAD_2006"))
				 ((= "ACADM" str_mnu)(setq str_ret "ACAD_2006_M"))
		     		 (t (setq str_ret "ACAD_2006"))
		           )
		     )
		     (t    (setq str_ret "ACAD_2004"))
	      ))
	)
  	(if (null str_ret)(setq str_ret ""))
  	str_ret
)
;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 圖元紀錄 XDATA 資料                                  │
;;;│  主程式 : (adxmultidata 圖元 APPID 資料串列)                   │
;;;│  日  期 : 2005/03/01                                           │
;;;│  姓  名 :                                                      │
;;;│  對話框 :                                                      │
;;;│  說  明 : (adxmultidata (entlast) "X_HANDLE" '((1000 . "")))   │
;;;└────────────────────────────────┘
;;;
(defun adxmultidata(ent xdata_flag dalist / entname dd newdata newent)
   	(regapp xdata_flag)
   	(setq entname ent)
   	(setq oldentdata (entget entname))
   	(setq dd (append (list xdata_flag) dalist)
   	      newdata (append (list -3 dd)))
   	(setq newent (append oldentdata (list newdata)))
   	(entmod newent)
 	(princ)
)
;;;
;;;┌────────────────────────────────┐
;;;│  程  式 : 檢查是否有特殊符號並加入跳脫字元 "`"                 │
;;;│  主程式 : (match_special_char "244#001")                       │
;;;│  日  期 : 2006/03/31                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 :                                                      │
;;;│  說  明 :                                                      │
;;;└────────────────────────────────┘
;;;
(defun match_special_char(str_tmp / str_ret lst_key str_char)
  	(setq str_ret "")
	(if str_tmp (progn
	    (setq lst_key (list "#" "@"))
	    (setq int_i 1)
	    (repeat (strlen str_tmp)
	      	    (setq str_char (substr str_tmp int_i 1))
	      	    (if (member str_char lst_key)
		        (progn (setq str_ret (strcat str_ret "`" str_char)))
			(progn (setq str_ret (strcat str_ret str_char)))
		    )
		    (setq int_i (1+ int_i))
	    )
	))  str_ret
)