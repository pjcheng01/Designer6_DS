;;;====================================================================
;;; 2026-09-14：DraftSight 重新移植（手冊 §7.3）
;;;
;;; 原本三個出圖函式在 DraftSight 2025 上有三處不成立：
;;;   1. 指令是 -PRINT，提示序列與 AutoCAD 的 .plot 不同
;;;   2. 寫死的 HP LaserJet 5100 / HP DesignJet 500 都已不存在
;;;   3. acad.ctb 在 DraftSight 沒有這個檔
;;;
;;; 裝置、紙張與列印樣式一律改從 System.ini 讀，不再寫死在程式裡——
;;; 這次會壞掉，正是因為 2003 年寫死的機種早就退役了。換機器只要改 ini。
;;;
;;; System.ini 需要的 key（值必須與 -PRINT 按 ? 列出的字串逐字相同）：
;;;   PRINT_PRINTER      印表機（雷射）裝置名稱
;;;   PRINT_PLOTTER      繪圖機裝置名稱
;;;   PRINT_STYLE        列印樣式表，例如 monochrome.ctb
;;;   PRINTER_PAPER_A1..A4   圖框尺寸 -> 印表機的紙張名稱
;;;   PLOTTER_PAPER_A1..A4   圖框尺寸 -> 繪圖機的紙張名稱
;;;====================================================================

;; 讀一個 System.ini 的 key，讀不到或空字串都回 nil。
;; 用 getfile_val + getrealstr2 + strip_cr，與 SYSTEM.lsp 讀 DWG_MANAGE_PATH
;; 同一套。刻意不用 sys_getstring——它會在第一個空白處截斷，而印表機名稱
;; 含空白（"...TASKalfa 3212i(RDPS3-1)"）。
(defun hpk_ini (key / v)
   (if (and POWdesign_path (findfile (strcat POWdesign_path "system.ini")))
      (setq v (getfile_val (strcat POWdesign_path "system.ini") key))
   )
   (if v (setq v (strip_cr (getrealstr2 v))))
   (if (= "" v) (setq v nil))
   v
)

;; 同上，但讀不到時明講是哪個 key 少了。不要無聲失敗（手冊 §5.18）。
(defun hpk_need (key / v)
   (setq v (hpk_ini key))
   (if (null v)
      (princ (strcat "\n[出圖] System.ini 缺少設定 " key "，請補上這一行後重試。"))
   )
   v
)

;; 找圖框 block，回傳 1..7；找不到回 nil。
;; A1tzt..A4tzt = 1..4（零件圖），ASMA1tzt..ASMA3tzt = 5..7（組合圖）
(defun hpk_frame ( / )
   (cond ((ssget "X" (list (cons 0 "INSERT") (cons 2 "A1tzt")))    1)
         ((ssget "X" (list (cons 0 "INSERT") (cons 2 "A2tzt")))    2)
         ((ssget "X" (list (cons 0 "INSERT") (cons 2 "A3tzt")))    3)
         ((ssget "X" (list (cons 0 "INSERT") (cons 2 "A4tzt")))    4)
         ((ssget "X" (list (cons 0 "INSERT") (cons 2 "ASMA1tzt"))) 5)
         ((ssget "X" (list (cons 0 "INSERT") (cons 2 "ASMA2tzt"))) 6)
         ((ssget "X" (list (cons 0 "INSERT") (cons 2 "ASMA3tzt"))) 7)
         (t (princ (strcat "\n" (getvar "DWGNAME") " 找不到圖框! 無法列印"))
            nil)
   )
)

;; 1..7 -> 圖框尺寸標籤。5,6,7 是組合圖的 A1,A2,A3，紙張與零件圖同尺寸。
(defun hpk_label (n)
   (nth (1- n) (list "A1" "A2" "A3" "A4" "A1" "A2" "A3"))
)

;; 出圖比例。原版是 (/ 1.0 (* ltscale 1))：拿 ltscale 當比例。
;; ltscale 為 0 時原版會除以零，這裡退回 1:1。
(defun hpk_scale ( / ls)
   (setq ls (getvar "ltscale"))
   (if (or (null ls) (<= ls 0)) (setq ls 1.0))
   (/ 1.0 ls)
)

;; 送一張圖到 -PRINT。
;;   device 裝置名稱  paper 紙張名稱  label 圖框尺寸（只用於訊息）
;;   scale  比例數值，或 "F" 表示擬合紙張
;;
;; 這是「進階列印選項 = 是」、在 Model 頁籤、裝置是系統印表機那條路徑，
;; 共 17 個回答。完整的提示對照表在手冊 §7.3。
;;
;; ⚠ 序列裡有條件式提示（蔭影模式只在 Model 頁籤問、「是否列印至檔案」
;;   只在裝置是系統印表機時問）。(command) 餵的是固定長度的參數列，
;;   只要少問一項，後面整串就會錯位。所以這裡刻意把 cmdecho 打開，
;;   出問題時看得到卡在哪一問；確認穩定之後可以把 hpk_echo 設成 0。
(defun hpk_print (device paper label scale / ctb oldecho)
   (setq ctb (hpk_need "PRINT_STYLE"))
   (if (and device paper ctb)
      (progn
         (setq oldecho (getvar "cmdecho"))
         (if (null hpk_echo) (setq hpk_echo 1))
         (setvar "cmdecho" hpk_echo)
         (command "zoom" "e")
         (command "_-PRINT"
            "Y"        ;  1 進階列印選項?
            "Model"    ;  2 指定圖頁名稱
            device     ;  3 指定印表機名稱
            paper      ;  4 指定紙張大小
            "M"        ;  5 指定單位：毫米
            "L"        ;  6 指定方向：橫向
            "N"        ;  7 是否上下顛倒列印?
            "A"        ;  8 指定列印範圍：所有幾何（等同 AutoCAD 的 Extents）
            scale      ;  9 指定列印比例
            "C"        ; 10 指定列印 X、Y 位移：中心
            "Y"        ; 11 使用列印樣式表格嗎?
            ctb        ; 12 列印樣式名稱
            "Y"        ; 13 使用指定的線寬嗎?
            "D"        ; 14 蔭影模式：如顯示的
            "N"        ; 15 列印至檔案?
            "N"        ; 16 套用列印設定至圖頁?
            "Y"        ; 17 現在列印嗎?
         )
         (setvar "cmdecho" oldecho)
         (prompt (strcat "<<<<   " label "  出圖完成    >>>>"))
         (command "zoom" "P")
      )
   )
   (princ)
)

;;;--------------------------------------------------------------------
;;; 印表機出圖（選單 1.1.10）
;;; 原版行為：A1/A2 的圖縮印到 A3（擬合），A3/A4 照 ltscale 原比例。
;;;--------------------------------------------------------------------
(defun c:hp ( / n label device paper scale)
   (setq n (hpk_frame))
   (if n
      (progn
         (setq label  (hpk_label n))
         (setq device (hpk_need "PRINT_PRINTER"))
         (setq paper  (hpk_need (strcat "PRINTER_PAPER_" label)))
         (setq scale  (if (or (= "A3" label) (= "A4" label))
                         (hpk_scale)
                         "F"))
         (hpk_print device paper label scale)
      )
   )
   (princ)
)

;;;--------------------------------------------------------------------
;;; 繪圖機出圖（選單 1.1.11）
;;; 原版行為：一律照 ltscale 原比例，紙張跟著圖框尺寸走。
;;;--------------------------------------------------------------------
(defun c:hp2 ( / n label device paper)
   (setq n (hpk_frame))
   (if n
      (progn
         (setq label  (hpk_label n))
         (setq device (hpk_need "PRINT_PLOTTER"))
         (setq paper  (hpk_need (strcat "PLOTTER_PAPER_" label)))
         (hpk_print device paper label (hpk_scale))
      )
   )
   (princ)
)

;;;--------------------------------------------------------------------
;;; 混合出圖（批次出圖走這支）
;;; 原版行為：A1/A2 走繪圖機，A3/A4 走印表機，一律原比例。
;;;--------------------------------------------------------------------
(defun c:hp3 ( / n label device paper)
   (setq n (hpk_frame))
   (if n
      (progn
         (setq label (hpk_label n))
         (if (or (= "A1" label) (= "A2" label))
            (setq device (hpk_need "PRINT_PLOTTER")
                  paper  (hpk_need (strcat "PLOTTER_PAPER_" label)))
            (setq device (hpk_need "PRINT_PRINTER")
                  paper  (hpk_need (strcat "PRINTER_PAPER_" label)))
         )
         (hpk_print device paper label (hpk_scale))
      )
   )
   (princ)
)
;;;┌────────────────────────────────┐
;;;│  程  式 : 批次出圖			                     │
;;;│  主程式 : hp-k.lsp                                             │
;;;│  日  期 : 2003/11/12                                           │
;;;│  姓  名 : SAM                                                  │
;;;│  對話框 : 	                                             │
;;;│  方  法 : batch_plot                                           │
;;;│  相關檔案:                                                     │
;;;└────────────────────────────────┘
;;;====================================================================

(defun c:batch_plot(/ int_flag glst_plot)
  	(setvar "cmdecho" 0)
  	(actdcl (strcat powdesign_path "btplot") "btplot")   ;; 2026-09-14：actdcl 會自己補 .dcl，這裡再寫一次會變成 xxx.dcl.dcl

     	(set_tile "NUM" "1")
	(mode_tile "DEL" 1)
     	(action_tile "SEL"    "(select_file_btplot)")
     	(action_tile "ADD"    "(addlst_btplot)")
     	(action_tile "DEL"    "(dellst_btplot)")
     	(action_tile "LST"    "(mode_tile \"DEL\" 0)")
  	(action_tile "accept" "(setq int_flag 1)(done_dialog)")
  	(action_tile "cancel" "(setq int_flag 0)(done_dialog)")
  	(start_dialog)
  	(if (= 1 int_flag)(exec_script_btplot))
  	(setvar "cmdecho" 1)
  	(princ)
)
(defun exec_script_btplot(/ fle_plot str_ver int_i lst_item str_fname str_cmd)
  	(if glst_plot (progn
		(setq fle_plot (open (strcat powdesign_path "BTPLOT.SCR") "w"))
		(setq str_ver (substr (getvar "acadver") 1 2))
		(setq int_i 0)
		(repeat (length glst_plot)
		  	(setq lst_item  (nth int_i glst_plot))
		  	(setq str_fname (nth 0 lst_item))
		  	(repeat (atoi (nth 1 lst_item))
		  		(cond ((= "14" str_ver)
			       	       (setq str_cmd (strcat "open " str_fname " &hp3\n"))
				       (princ str_cmd fle_plot))
			      	      ((= "15" str_ver)
			       	       (setq str_cmd (strcat "open " str_fname " Y &hp3 close Y\n"))
				       (princ str_cmd fle_plot))
				)
			)
		  	(setq int_i (1+ int_i))
		)
		(close fle_plot)
		(command "._script" (strcat powdesign_path "btplot.scr"))
		(princ)
	))
)
(defun addlst_btplot(/ str_fle int_num lst_tmp)
	(setq str_fle (get_tile "FLE"))
  	(setq int_num (atoi (get_tile "NUM")))
  	(if (or (= "" (string_space_btplot str_fle))(= 0 int_num))
	    (progn
	    	(if (= 0 int_num)(alert "未輸入張數")
		  		 (alert "未輸入檔案名稱"))
	    )
	    (progn
	        (if (findfile str_fle)
		    (progn
	      	    	(setq lst_tmp (list str_fle (get_tile "NUM")))
	            	(setq glst_plot (cons lst_tmp (reverse glst_plot)))
	      	    	(setq glst_plot (reverse glst_plot))
		    )
		    (alert "找不到檔案")
		)
	    )
	)
  	(act_pop_list (trans_strlist_btplot glst_plot) "LST")
  	(set_tile "FLE" "")
  	(mode_tile "DEL" 1)
)
(defun dellst_btplot(/ int_idx int_i lst_tmp lst_plot)
  	(setq int_idx (atoi (get_tile "LST")))
	(setq int_i 0)
  	(repeat (length glst_plot)
	  	(setq lst_tmp (nth int_i glst_plot))
	  	(if (/= int_i int_idx)(setq lst_plot (cons lst_tmp lst_plot)))
	  	(setq int_i (1+ int_i))
	)
  	(setq glst_plot (reverse lst_plot))
  	(act_pop_list (trans_strlist_btplot glst_plot) "LST")
  	(mode_tile "DEL" 1)
)
(defun select_file_btplot(/ str_fname)
	(setq str_fname (getfiled "選取檔案" "" "DWG" 16))
  	(if str_fname (set_tile "FLE" str_fname))
)
(defun trans_strlist_btplot(lst_plot / int_i str_tmp1 str_tmp2 str_tmp3 lst_tmp)
	(setq int_i 0)
  	(repeat (length lst_plot)
	  	(setq str_tmp1 (nth 0 (nth int_i lst_plot)))
	  	(setq str_tmp2 (nth 1 (nth int_i lst_plot)))
	  	(setq str_tmp3 (strcat "張數: " str_tmp2 (col_tab (- 5 (strlen str_tmp2))) str_tmp1))
	  	(setq lst_tmp  (cons str_tmp3 lst_tmp))
	  	(setq int_i (1+ int_i))
	)
  	(reverse lst_tmp)
)
(defun string_space_btplot(str / i)
	(setq i 1)
  	(while  (= " " (substr str i 1)) 
		(setq str (substr str (+ i 1)))
	)
  	(if (/= 0 (strlen str))(progn
  	(while  (= " " (substr str (strlen str) 1))
	  	(setq str (substr str 1 (- (strlen str) 1)))
	)))
  	str
)
;; 2026-09-14：原本是 (defun *error* (msg) (princ)) —— 收到訊息卻什麼都不做。
;; 這是【頂層】定義，載入這支檔案就會永久換掉全域 *error*，於是整個工作
;; 階段之後的錯誤全部無聲。全專案共 19 處同樣的寫法，分布在 8 支檔案，
;; 而 MANAPART 與 DFSYSTEM 幾乎每個功能都會載入——這是手冊 §5.16 那個
;; 「所有錯誤訊息都被吞掉」的真正源頭。
;; 改為照常顯示，只濾掉使用者主動取消／中斷這類不算錯誤的訊息。
;; 訊息文字用 ASCII："\nError: " 是本專案既有的主流寫法。
(defun *error* (msg)
   (if (and msg
            (/= msg "Function cancelled")
            (/= msg "quit / exit abort")
            (/= msg "console break"))
      (princ (strcat "\nError: " msg))
   )
   (princ)
)