;;;

;自動出圖
AUTOPLOT 程式共有以下檔案:
   1. AUTOPLOT.LSP  主程式
   2. AUTOPLOT.DCL  對話框
   3. AUTOPLOT.INI  客戶印表機出圖流程腳本

(defun c:autoplot_right()
; (princ "\n自動連續出圖程式, 版權所有歸屬 藝祥資訊工程有限公司!")
; (princ "\n任何未經授權使用,複製,藝祥資訊將保留法律追訴權!")
  (princ (get_language 10001108))
  (princ (get_language 10001109))
  (PRINC)
)

;╭════════════════════════════════════════════╮
;║設計日期: 1998. 2. 7                                                                    ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明:                                                                               ║
;║                                                                                        ║
;║執行方式:                                                                               ║
;║相關檔案:autoplot.dcl, autoplot.scr                                                     ║
;║                                                                                        ║
;║                                                                                        ║
;╰════════════════════════════════════════════╯
(defun c:autoplot(/ autoplot_list)
;(defun c:autoplot()
   ;; DraftSight: 移除加密狗 WHILE 迴圈
 (setvar "cmdecho" 0)
; (princ "\nAUTOPLOT 連續自動出圖  Ver:1.0      系統設計:藝祥資訊 04-4372371")
 (princ (get_language 10001110))

 (setq qq (open (strcat autoplot_filepath "autoplot.set") "r"))
 (read-line qq)
 (setq ploter_list (read(read-line qq)))
 (setq papersize_list (read(read-line qq)))
 (setq paper_list (read(read-line qq)))
 (close qq)

 (actdcl (strcat autoplot_filepath "autoplot") "autoplot")
 (set_tile "dwgpath" autoplot_DWGpath)
; (set_tile "title" "連續自動出圖  Ver:1.0                                   系統設計:藝祥資訊 04-22307650")
 (set_tile "title" (get_language ))

 (act_pop_list ploter_list "ploter")
 (act_pop_list papersize_list "papersize")
 (set_tile "ploter" "0")
 (set_tile "papersize" "0")

 (setq autoplot_list nil)

 (mode_tile "removefile" 1)
 (mode_tile "allremove" 1)

 (action_tile "txtfile" "(txtfile)")
 (action_tile "plotfile" "(mode_tile \"removefile\" 0)")
 (action_tile "addfile" "(mode_tile \"allremove\" 0)(sel_autoplot_file)")
 (action_tile "removefile" "(removefile)(mode_tile \"removefile\" 1)")
 (action_tile "allremove" "(mode_tile \"allremove\" 1)(setq autoplot_list nil)(act_pop_list autoplot_list \"plotfile\")")
 (action_tile "allselect" "(selall)")

 (action_tile "accept" "(setq ploter (nth (atoi(get_tile \"ploter\")) ploter_list) papersize (nth (atoi(get_tile \"papersize\")) paper_list))(done_dialog)")
 (action_tile "cancel" "(setq autoplot_list nil)(done_dialog)")

 (start_dialog)

 (if (/= nil autoplot_list) (exe_autoplot))

 (setvar "cmdecho" 1)
   ;; removed FFF
 (prin1)
)



(defun selall()
  (setq aa (length bblist) count 0)
  (repeat aa
    (set_tile "plotfile" (rtos count 2 0))
    (setq count (1+ count))
  )
)

(defun exe_autoplot()
    (command "point" "0,0")
    (if (= acad_ver "GENIUS")
        (command ".erase" "l" "")
        (command "erase" "l" "")
    )
    (SETQ QQQQ AUTOPLOT_LIST)
    (initget 1 "Yes No")
;    (setq yesno (getkword "\n是否儲存目前圖檔<Y>?"))
    (setq yesno (getkword (get_language 10000820)))

    (setq ff (open (strcat autoplot_filepath "autoplot.scr") "w"))

    (if (= yesno "No")
          (write-line "close y" ff)
          (write-line "close n" ff)
    );if
    (setq count t)
    (setq dwt_path (strcat powdesign_path "powtech"))
    (write-line (strcat "new " dwt_path) ff)
    (foreach n autoplot_list
       (progn
         ;      (write-line (strcat "open " n) ff)
         ;      (write-line "zoom e" ff)
         ;  ;   (write-line "(load \"plotset\")" ff)
         ;  ;    (write-line (strcat "(c:plot1 " print_id " " paper_id ")") ff)
         ;  ;    (write-line "(c:draw_autoplot)" ff)
         ;   (write-line "&draw_autoplot" ff)
         ;      (write-line "close y" ff)
             (write-line (strcat "insert " n " 0,0 1 1 0") ff)
             (write-line "zoom e" ff)
             (write-line "plot" ff)
             (write-line "y" ff)                 ;詳細出圖規劃? [是(Y)/否(N)] <否>:
             (write-line "" ff)                  ;輸入配置名稱或 [列示(?)] <Model>:
             (write-line ploter ff)              ;輸入輸出設備名稱或 [列示(?)] <\\ADSL\HP>:
             (write-line papersize ff)           ;輸入圖紙尺寸或 [列示(?)] <210 x 297 公釐>:
             (write-line "m" ff)                 ;輸入圖紙單位 [英吋(I)/公釐(M)] <公釐>: m
             (write-line "l" ff)                 ;輸入圖面方位 [直式(P)/橫式(L)] <橫式>: l
             (write-line "n" ff)                 ;上下顛倒出圖? [是(Y)/否(N)] <否>: n
             (write-line "E" ff)                 ;輸入出圖區域 [顯示(D)/實際範圍(E)/圖面範圍(L)/視景(V)/視窗(W)] <實際範圍>:
             (write-line "fit" ff)               ;輸入出圖比例 (出圖 公釐=圖面單位) 或 [佈滿(F)] <Fit>: f
;             (write-line "中心點" ff)            ;輸入出圖偏移 (x,y) 或 [中心點(C)] <置中>:
             (write-line (get_language 10000903) ff)            ;輸入出圖偏移 (x,y) 或 [中心點(C)] <置中>:
             (write-line "y" ff)                 ;以出圖型式出圖? [是(Y)/否(N)] <是>: y
             (write-line "aclt.ctb" ff)          ;輸入出圖型式表名稱或 [列示(?)] (輸入 . 代表無) <aclt.ctb>: aclt.ctb
             (write-line "y" ff)                 ;以線寬出圖? [是(Y)/否(N)] <是>: y
             (write-line "n" ff)                 ;移除隱藏線.? [是(Y)/否(N)] <否>: n
             (write-line "n" ff)                 ;將出圖寫入檔案 [是(Y)/否(N)] <N>: n
             (write-line "n" ff)                 ;儲存變更到模型標籤 [是(Y)/否(N)]? <N> n
             (write-line "y" ff)                 ;繼續出圖 [是(Y)/否(N)] <Y>: y
             (write-line "erase" ff)
             (write-line "all" ff)
             (write-line "" ff)
             (write-line "purge" ff)
             (write-line "a" ff)
             (write-line "*" ff)
             (write-line "n" ff)
       );progn
    );foreach
;    (setq dwt_path (strcat powdesign_path "powtech"))
;    (write-line (strcat "new " dwt_path) ff)

    (close ff)


    (command "script" (strcat autoplot_filepath "autoplot.scr"))
)



(defun removefile()
    (setq selfile (get_tile "plotfile"))
;    (if (= "" selfile) (set_tile "error" "您沒有選擇要移除的檔名!!")
    (if (= "" selfile) (set_tile "error" (get_language 10001112))
      (progn
        (setq count 0 aalist '(""))
        (foreach n autoplot_list
          (progn
            (if (/= (rtos count 2 0) selfile)
               (setq aalist (cons (nth count autoplot_list) aalist)
                     count (1+ count))
               (setq count (1+ count))
            );if
          );progn
        );foreach
        (setq autoplot_list (cdr (reverse aalist)))
        (act_pop_list autoplot_list "plotfile")
      );progn
    );if

)


(defun txtfile()
  (setq dwgpath (get_tile "dwgpath"))
;  (setq ff (getfiled "選擇圖檔名" (strcat dwgpath "\\") "TXT" 2))
  (setq ff (getfiled (get_language 10001113) (strcat dwgpath "\\") "TXT" 2))
  (if ff
    (progn
      (setq bblist '(""))
      (setq refile (open ff "r"))
      (while (setq data (read-line refile))
        (setq bblist (cons data bblist))
      )
      (close refile)(setq autoplot_list (cdr (reverse bblist)))
      (act_pop_list autoplot_list "plotfile")
      (mode_tile "allremove" 0)
    );progn
  );if
)

(defun sel_autoplot_file()
  (setq dwgpath (get_tile "dwgpath"))
;  (setq ff (getfiled "選擇圖檔名" (strcat dwgpath "\\") "DWG" 2))
  (setq ff (getfiled (get_language 10001113) (strcat dwgpath "\\") "DWG" 2))
  (while ff
     (setq autoplot_list (reverse (cons ff (reverse autoplot_list))))
     (act_pop_list autoplot_list "plotfile")
;     (setq ff (getfiled "選擇圖檔名" (strcat dwgpath "\\") "DWG" 2))
     (setq ff (getfiled (get_language 10001113) (strcat dwgpath "\\") "DWG" 2))
  )
)

;start any pop_list
(defun act_pop_list (data_list key_name)
       (start_list key_name)
       (mapcar 'add_list data_list )
       (end_list)
)


;啟動 DCL
(defun actdcl(filename gg)
 (setq dcl_pt '(-1 -1))
 (setq dcl_id (load_dialog filename))
 (new_dialog gg dcl_id)
 (if (< dcl_id 0) (exit))
)
