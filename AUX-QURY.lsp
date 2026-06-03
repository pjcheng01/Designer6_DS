;;;
;比例查詢
;==============================================================================================
;; ((= 1 type) (set_tile "title" "各種貨櫃內外徑尺寸")
;; ((= 2 type) (set_tile "title" "方(扁)管規格")
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 1. 1527                                                                 ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明:                                                                               ║
;║                                                                                        ║
;║執行方式:                                                                               ║
;║相關檔案:pub-lisp.lsp                                                                   ║
;╰════════════════════════════════════════════╯
(defun carqury(type)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setvar "cmdecho" 1)
 (actdcl (strcat powdesign_dcl_path "aux-qury") "carqury")
 (cond
   ((= 1 type) (set_tile "title" "各種貨櫃內外徑尺寸")
               (setq text1_list (list
               "  ┌──────┬──────────────┬──────────────┐ "
               "  │            │     外           徑        │      內           徑       │ "
               "  │            ├────┬────┬────┼────┬────┬────┤ "
               "  │            │   長   │   寬   │   高   │   長   │   寬   │   高   │ "
               "  ├──────┼────┼────┼────┼────┼────┼────┤ "
               "  │ 20' 普通櫃 │ 6.06 M │ 2.44 M │ 2.59 M │ 5.90 M │ 2.35 M │ 2.39 M │ "
               "  ├──────┼────┼────┼────┼────┼────┼────┤ "
               "  │ 40' 普通櫃 │12.19 M │ 2.44 M │ 2.59 M │12.03 M │ 2.35 M │ 2.38 M │ "
               "  ├──────┼────┼────┼────┼────┼────┼────┤ "
               "  │ 40' 超高櫃 │12.19 M │ 2.44 M │ 2.90 M │12.03 M │ 2.35 M │ 2.69 M │ "
               "  ├──────┼────┼────┼────┼────┼────┼────┤ "
               "  │ 20' 平板櫃 │ 6.05 M │ 2.43 M │ 2.59 M │ 5.91 M │ 2.19 M │ 2.08 M │ "
               "  ├──────┼────┼────┼────┼────┼────┼────┤ "
               "  │ 20' 開頂櫃 │ 6.05 M │ 2.43 M │ 2.59 M │ 5.90 M │ 2.35 M │ 2.34 M │ "
               "  ├──────┼────┼────┼────┼────┼────┼────┤ "
               "  │ 40' 平板櫃 │12.19 M │ 2.44 M │ 2.59 M │11.71 M │ 2.18 M │ 1.98 M │ "
               "  ├──────┼────┼────┼────┼────┼────┼────┤ "
               "  │ 40' 開頂櫃 │12.19 M │ 2.44 M │ 2.59 M │12.03 M │ 2.35 M │ 2.33 M │ "
               "  └──────┴────┴────┴────┴────┴────┴────┘ ")))
   ((= 2 type) (set_tile "title" "方(扁)管規格")
               (setq text1_list (list
               "  ┌─────┬─────────────────────────────┐ "
               "  │          │           厚                             度              │ "
               "  │          ├──┬──┬──┬──┬──┬──┬──┬──┬──┬──┤ "
               "  │尺   寸   │1.2 │1.5 │2.0 │ 2.3│ 2.8│3.0 │3.2 │ 4.0│4.5 │6.0 │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │3/4 x 3/4 │ ○ │ ○ │    │    │    │    │    │    │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 25 x 12  │ ○ │ ○ │    │    │    │    │    │    │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 35 x 25  │ ○ │ ○ │ ○ │    │    │    │    │    │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 32 x 32  │ ○ │ ○ │ ○ │    │    │    │    │    │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 38 x 15  │ ○ │ ○ │ ○ │    │    │    │    │    │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 38 x 38  │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │    │    │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 40 x 20  │ ○ │ ○ │ ○ │    │    │    │    │    │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 50 x 25  │ ○ │ ○ │ ○ │ ○ │    │    │    │    │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 50 x 50  │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 60 x 30  │    │    │ ○ │ ○ │ ○ │ ○ │    │    │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 60 x 60  │    │    │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 75 x 75  │    │    │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 80 x 40  │    │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │ 80 x 80  │    │    │    │    │    │ ○ │ ○ │ ○ │    │    │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │100 x 50  │    │    │    │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │100 x 100 │    │    │    │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │ ○ │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │125 x 75  │    │    │    │    │    │    │ ○ │ ○ │ ○ │ ○ │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │125 x 125 │    │    │    │    │    │    │ ○ │ ○ │ ○ │ ○ │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │150 x 75  │    │    │    │    │    │    │ ○ │ ○ │ ○ │ ○ │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │150 x 150 │    │    │    │    │    │    │ ○ │ ○ │ ○ │ ○ │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │200 x 100 │    │    │    │    │    │    │ ○ │ ○ │ ○ │ ○ │ "
               "  ├─────┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤ "
               "  │200 x 200 │    │    │    │    │    │    │ ○ │ ○ │ ○ │ ○ │ "
               "  └─────┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘ ")))
   );;cond
 (act_pop_list text1_list "text1")

 (action_tile "accept" "(done_dialog)")
 (start_dialog)

 (setvar "cmdecho" 1)
   (SETQ FFF nil))
 (prin1)
)


;╭════════════════════╮
;║程式名稱:                               ║
;║設計日期: 1998.02.22                    ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明: 計算弧長                      ║
;║                                        ║
;║相關檔案:                               ║
;╰════════════════════╯
(defun c:arclen()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
   (setq selent (entsel "\n選擇 圓弧 :"))

   (if selent
     (progn
        (setq ent_data (entget (car selent))
              ent_type (cdr (assoc 0 ent_data)))
     )
   );
   (if (= "ARC" ent_type)
     (progn
         (setq sang (cdr (assoc 50 ent_data))
               eang (cdr (assoc 51 ent_data))
               arcr (cdr (assoc 40 ent_data)))
         (if (< sang eang)
           (setq arclen (* 0.01745 arcr (rtd (- eang sang))))
           (setq arclen (- (* 2 pi arcr) (* 0.01745 arcr (rtd (abs (- sang eang))))))
         );if
         (princ (strcat "\n您選擇的圓弧弧長是 " (rtos arclen 2 4)))
     );progn
     (progn
        (princ "\n抱歉! 您選擇的不是圓弧, 請再選一遍 !!")
        (c:arclen)
     );progn
   );if
   (SETQ FFF nil))
   (princ)
)

;;;鐵材規格

;╭════════════════════════════════════════════╮
;║設計日期: 1998. 1. 1527                                                                 ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明:                                                                               ║
;║                                                                                        ║
;║執行方式:                                                                               ║
;║相關檔案:pub-lisp.lsp                                                                   ║
;║                                                                                        ║
;║                                                                                        ║
;╰════════════════════════════════════════════╯
(defun ironsize(type)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setvar "cmdecho" 0)
 (actdcl (strcat powdesign_dcl_path "aux-qury") "ironsize")
 (cond
   ((= 1 type) (set_tile "title" "丸鐵規格表")
               (setq text1_list (list
               "  ┌────┬────┬────┬────┐ "
               "  │ 直 徑  │ kg / m │ 直 徑  │ kg / m │ "
               "  ├────┼────┼────┼────┤ "
               "  │   5    │  0.153 │   50   │  15.4  │ "
               "  ├────┼────┼────┼────┤ "
               "  │   6    │  0.222 │   55   │  18.7  │ "
               "  ├────┼────┼────┼────┤ "
               "  │   7    │  0.302 │   60   │  22.2  │ "
               "  ├────┼────┼────┼────┤ "
               "  │   8    │  0.395 │   65   │  26    │ "
               "  ├────┼────┼────┼────┤ "
               "  │   9    │  0.499 │   70   │  30.2  │ "
               "  ├────┼────┼────┼────┤ "
               "  │  10    │  0.617 │   75   │  34.7  │ "
               "  ├────┼────┼────┼────┤ "
               "  │  12    │  0.888 │   80   │  39.5  │ "
               "  ├────┼────┼────┼────┤ "
               "  │  15    │  1.39  │   85   │  44.5  │ "
               "  ├────┼────┼────┼────┤ "
               "  │  16    │  1.58  │   90   │  49.9  │ "
               "  ├────┼────┼────┼────┤ "
               "  │  18    │  2.00  │   95   │  55.6  │ "
               "  ├────┼────┼────┼────┤ "
               "  │  19    │  2.23  │  100   │  61.7  │ "
               "  ├────┼────┼────┼────┤ "
               "  │  20    │  2.47  │  110   │  74.6  │ "
               "  ├────┼────┼────┼────┤ "
               "  │  22    │  2.98  │  120   │  88.8  │ "
               "  ├────┼────┼────┼────┤ "
               "  │  25    │  3.85  │  130   │ 104    │ "
               "  ├────┼────┼────┼────┤ "
               "  │  28    │  4.83  │  140   │ 121    │ "
               "  ├────┼────┼────┼────┤ "
               "  │  30    │  5.55  │  150   │ 139    │ "
               "  ├────┼────┼────┼────┤ "
               "  │  32    │  6.31  │  160   │ 158    │ "
               "  ├────┼────┼────┼────┤ "
               "  │  35    │  7.55  │  170   │ 179    │ "
               "  ├────┼────┼────┼────┤ "
               "  │  38    │  8.9   │  180   │ 200    │ "
               "  ├────┼────┼────┼────┤ "
               "  │  40    │  9.87  │  190   │ 223    │ "
               "  ├────┼────┼────┼────┤ "
               "  │  45    │ 12.485 │  200   │ 247    │ "
               "  └────┴────┴────┴────┘ ")))
   ((= 2 type) (set_tile "title" "平鐵規格表")
               (setq text1_list (list
               "  ┌────┬────┬────┬────┐ "
               "  │規格    │ kg / m │ 直 徑  │ kg / m │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 3 x 16 │  0.153 │ 6 x 75 │  3.53  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 3 x 19 │  0.222 │ 6 x 90 │  4.24  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 3 x 25 │  0.302 │ 6 x 100│  4.71  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 3 x 32 │  0.395 │ 9 x 25 │  1.77  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 3 x 38 │  0.499 │ 9 x 32 │  2.26  │ "
               "  ├────┼────┼────┼────┤ "
               "  │4.5x 19 │  0.617 │ 9 x 38 │  2.68  │ "
               "  ├────┼────┼────┼────┤ "
               "  │4.5x 25 │  0.883 │ 9 x 50 │  3.53  │ "
               "  ├────┼────┼────┼────┤ "
               "  │4.5x 32 │  1.39  │ 9 x 65 │  4.59  │ "
               "  ├────┼────┼────┼────┤ "
               "  │4.5x 38 │  1.13  │ 9 x 75 │  5.3   │ "
               "  ├────┼────┼────┼────┤ "
               "  │4.5x 45 │  1.34  │ 9 x 90 │  6.36  │ "
               "  ├────┼────┼────┼────┤ "
               "  │4.5x 50 │  1.56  │ 9 x 100│  7.06  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 6 x 19 │  1.77  │12 x 32 │  3.01  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 6 x 25 │  0.895 │12 x 38 │  3.58  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 6 x 32 │  1.51  │12 x 50 │  4.71  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 6 x 38 │  1.79  │12 x 65 │  6.12  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 6 x 45 │  2.08  │12 x 75 │  7.06  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 6 x 50 │  2.36  │12 x 90 │  8.48  │ "
               "  ├────┼────┼────┼────┤ "
               "  │ 6 x 65 │  3.06  │12 x 100│  9.42  │ "
               "  └────┴────┴────┴────┘ ")))
   ((= 3 type) (set_tile "title" "BSA-1黑白鋼管規格")
               (setq text1_list (list
               "┌────┬────┬──┬─────────┐"
               "│稱呼尺寸│最大外徑│壁厚│  計  算  重  量  │"
               "├────┼────┼──┼─────────┤"
               "│        │        │    │    公 斤 /呎     │"
               "│   吋   │ 公 厘  │公厘├────┬────┤"
               "│        │        │    │ 黑 b1  │白 gal  │"
               "├────┼────┼──┼────┼────┤"
               "│  1/2   │  21.4  │1.90│ 0.275  │ 0.294  │"
               "├────┼────┼──┼────┼────┤"
               "│  3/4   │  26.9  │2.10│ 0.387  │ 0.414  │"
               "├────┼────┼──┼────┼────┤"
               "│   1    │  33.8  │2.45│ 0.572  │ 0.612  │"
               "├────┼────┼──┼────┼────┤"
               "│ 1-1/4  │  42.5  │2.45│ 0.730  │ 0.781  │"
               "├────┼────┼──┼────┼────┤"
               "│ 1-1/2  │  48.4  │2.60│ 0.889  │ 0.951  │"
               "├────┼────┼──┼────┼────┤"
               "│   2    │  60.2  │2.60│ 1.120  │ 1.198  │"
               "├────┼────┼──┼────┼────┤"
               "│ 2-1/2  │  76.0  │3.00│ 1.637  │ 1.725  │"
               "├────┼────┼──┼────┼────┤"
               "│   3    │  88.7  │3.00│ 1.923  │ 2.058  │"
               "├────┼────┼──┼────┼────┤"
               "│ 3-1/2  │ 101.2  │3.25│ 2.381  │ 2.548  │"
               "├────┼────┼──┼────┼────┤"
               "│   4    │ 113.9  │3.25│ 2.690  │ 2.878  │"
               "├────┼────┼──┼────┼────┤"
               "│   5    │ 140.6  │3.60│ 3.710  │ 3.931  │"
               "├────┼────┼──┼────┼────┤"
               "│   6    │ 166.1  │3.60│ 4.398  │ 4.660  │"
               "├────┼────┼──┼────┼────┤"
               "│   8    │ 219.1  │4.50│ 7.117  │ 7.473  │"
               "├────┼────┼──┼────┼────┤"
               "│  10    │ 273.0  │4.50│ 8.843  │ 9.285  │"
               "├────┼────┼──┼────┼────┤"
               "│  12    │ 323.8  │4.50│10.560  │11.088  │"
               "└────┴────┴──┴────┴────┘")))
   ((= 4 type) (set_tile "title" "BS-B黑白鋼管規格")
               (setq text1_list (list
                "┌────┬────┬──┬─────────┐"
                "│稱呼尺寸│最大外徑│壁厚│  計  算  重  量  │"
                "├────┼────┼──┼─────────┤"
                "│        │        │    │    公 斤 /呎     │"
                "│   吋   │ 公 厘  │公厘├────┬────┤"
                "│        │        │    │ 黑 b1  │白 gal  │"
                "├────┼────┼──┼────┼────┤"
                "│  1/2   │  21.8  │2.6 │ 0.374  │ 0.396  │"
                "├────┼────┼──┼────┼────┤"
                "│  3/4   │  27.3  │2.9 │ 0.532  │ 0.564  │"
                "├────┼────┼──┼────┼────┤"
                "│   1    │  34.2  │3.2 │ 0.749  │ 0.794  │"
                "├────┼────┼──┼────┼────┤"
                "│ 1-1/4  │  42.9  │3.6 │ 1.070  │ 1.134  │"
                "├────┼────┼──┼────┼────┤"
                "│ 1-1/2  │  48.8  │4.1 │ 1.360  │ 1.442  │"
                "├────┼────┼──┼────┼────┤"
                "│   2    │  60.8  │4.1 │ 1.720  │ 1.823  │"
                "├────┼────┼──┼────┼────┤"
                "│ 2-1/2  │  76.6  │4.5 │ 2.400  │ 2.544  │"
                "├────┼────┼──┼────┼────┤"
                "│   3    │  89.5  │4.5 │ 2.830  │ 3.000  │"
                "├────┼────┼──┼────┼────┤"
                "│ 3-1/2  │ 102.1  │4.5 │ 3.250  │ 3.445  │"
                "├────┼────┼──┼────┼────┤"
                "│   4    │ 115.0  │4.5 │ 3.680  │ 3.901  │"
                "├────┼────┼──┼────┼────┤"
                "│   5    │ 140.6  │4.5 │ 4.539  │ 4.811  │"
                "├────┼────┼──┼────┼────┤"
                "│   6    │ 166.1  │4.5 │ 5.394  │ 5.718  │"
                "├────┼────┼──┼────┼────┤"
                "│   8    │ 219.1  │6.0 │ 9.490  │ 9.965  │"
                "├────┼────┼──┼────┼────┤"
                "│  10    │ 273.0  │6.0 │11.790  │12.350  │"
                "├────┼────┼──┼────┼────┤"
                "│  12    │ 323.8  │6.0 │14.080  │14.784  │"
                "├────┼────┼──┼────┼────┤"
                "│  14    │ 355.6  │6.0 │15.770  │16.559  │"
                "├────┼────┼──┼────┼────┤"
                "│  16    │ 406.4  │6.0 │18.060  │18.963  │"
                "└────┴────┴──┴────┴────┘")))
   ((= 5 type) (set_tile "title" "花紋鋼板規格")
               (setq text1_list (list
                "   ┌────┬────┬────┐   "
                "   │厚 度 mm│4' x 8' │ 5'x 10'│   "
                "   ├────┼────┼────┤   "
                "   │  2.3   │  58.7  │   --   │   "
                "   ├────┼────┼────┤   "
                "   │  3     │  72.5  │ 113.5  │   "
                "   ├────┼────┼────┤   "
                "   │  3.2   │  79.5  │ 124.5  │   "
                "   ├────┼────┼────┤   "
                "   │  4.5   │ 110    │ 172    │   "
                "   ├────┼────┼────┤   "
                "   │  6     │ 145    │ 227    │   "
                "   ├────┼────┼────┤   "
                "   │  8     │ 192    │ 299    │   "
                "   ├────┼────┼────┤   "
                "   │  9     │ 215    │ 336    │   "
                "   └────┴────┴────┘   ")))
   ((= 6 type) (set_tile "title" "等邊三角鐵規格")
               (setq text1_list (list
                "   ┌──────────┬─────┐   "
                "   │    規        格    │    Kg/m  │   "
                "   ├──────────┼─────┤   "
                "   │  25 x  25 x  2.5   │   0.946  │   "
                "   ├──────────┼─────┤   "
                "   │  25 x  25 x  3     │   1.12   │   "
                "   ├──────────┼─────┤   "
                "   │  30 x  30 x  2.5   │   1.14   │   "
                "   ├──────────┼─────┤   "
                "   │  30 x  30 x  3     │   1.36   │   "
                "   ├──────────┼─────┤   "
                "   │  30 x  30 x  4     │   1.76   │   "
                "   ├──────────┼─────┤   "
                "   │  38 x  38 x  2.5   │   1.46   │   "
                "   ├──────────┼─────┤   "
                "   │  38 x  38 x  3     │   1.74   │   "
                "   ├──────────┼─────┤   "
                "   │  38 x  38 x  4     │   2.26   │   "
                "   ├──────────┼─────┤   "
                "   │  38 x  38 x  5     │   2.79   │   "
                "   ├──────────┼─────┤   "
                "   │  40 x  40 x  3     │   1.83   │   "
                "   ├──────────┼─────┤   "
                "   │  40 x  40 x  4     │   2.39   │   "
                "   ├──────────┼─────┤   "
                "   │  40 x  40 x  5     │   2.95   │   "
                "   ├──────────┼─────┤   "
                "   │  50 x  50 x  4     │   3.06   │   "
                "   ├──────────┼─────┤   "
                "   │  50 x  50 x  5     │   3.77   │   "
                "   ├──────────┼─────┤   "
                "   │  50 x  50 x  6     │   4.43   │   "
                "   ├──────────┼─────┤   "
                "   │  65 x  65 x  6     │   5.91   │   "
                "   ├──────────┼─────┤   "
                "   │  65 x  65 x  8     │   7.66   │   "
                "   ├──────────┼─────┤   "
                "   │  75 x  75 x  6     │   6.85   │   "
                "   ├──────────┼─────┤   "
                "   │  75 x  75 x  9     │   9.96   │   "
                "   ├──────────┼─────┤   "
                "   │  90 x  90 x  7     │   9.59   │   "
                "   ├──────────┼─────┤   "
                "   │  90 x  90 x 10     │  13.3    │   "
                "   ├──────────┼─────┤   "
                "   │  90 x  90 x 13     │  17.0    │   "
                "   ├──────────┼─────┤   "
                "   │ 100 x 100 x  7     │  10.7    │   "
                "   ├──────────┼─────┤   "
                "   │ 100 x 100 x 10     │  14.9    │   "
                "   ├──────────┼─────┤   "
                "   │ 100 x 100 x 13     │  19.1    │   "
                "   ├──────────┼─────┤   "
                "   │ 130 x 130 x  9     │  17.9    │   "
                "   ├──────────┼─────┤   "
                "   │ 130 x 130 x 12     │  23.4    │   "
                "   ├──────────┼─────┤   "
                "   │ 130 x 130 x 15     │  28.8    │   "
                "   ├──────────┼─────┤   "
                "   │ 150 x 150 x 12     │  27.3    │   "
                "   ├──────────┼─────┤   "
                "   │ 150 x 150 x 15     │  33.6    │   "
                "   ├──────────┼─────┤   "
                "   │ 150 x 150 x 19     │  41.9    │   "
                "   ├──────────┼─────┤   "
                "   │ 200 x 200 x 15     │  45.3    │   "
                "   ├──────────┼─────┤   "
                "   │ 200 x 200 x 20     │  49.7    │   "
                "   ├──────────┼─────┤   "
                "   │ 200 x 200 x 25     │  73.6    │   "
                "   └──────────┴─────┘   ")))
   ((= 7 type) (set_tile "title" "不等邊三角鐵規格")
               (setq text1_list (list
                "   ┌──────────┬─────┐   "
                "   │    規        格    │    Kg/m  │   "
                "   ├──────────┼─────┤   "
                "   │ 100 x  75 x   7    │   9.32   │   "
                "   ├──────────┼─────┤   "
                "   │ 100 x  75 x  10    │  13.00   │   "
                "   ├──────────┼─────┤   "
                "   │ 125 x  75 x   7    │  10.7    │   "
                "   ├──────────┼─────┤   "
                "   │ 125 x  75 x   9    │  13.5    │   "
                "   ├──────────┼─────┤   "
                "   │ 125 x  75 x  10    │  14.9    │   "
                "   ├──────────┼─────┤   "
                "   │ 150 x  90 x   9    │  16.4    │   "
                "   ├──────────┼─────┤   "
                "   │ 150 x  90 x  12    │  21.5    │   "
                "   ├──────────┼─────┤   "
                "   │ 200 x  90 x  11    │  24.2    │   "
                "   └──────────┴─────┘   ")))

 )



 (act_pop_list text1_list "text1")

 (action_tile "accept" "(done_dialog)")
 (start_dialog)

 (setvar "cmdecho" 1)
   (SETQ FFF nil))
 (prin1)
)

(defun c:funcc()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setvar "cmdecho" 0)
 (actdcl (strcat powdesign_dcl_path "aux-qury") "function")
  (set_tile "title" "鐵板重量計算法")
  (set_tile "func1" "公式: 寬(尺)x長(尺)x厚(m/m)x 0.73 = 重量")
  (set_tile "func2" "公式: 寬(M)x長(M)x厚(m/m)x 7.854 = 實量")
  (action_tile "accept" "(done_dialog)")
 (start_dialog)
 (setvar "cmdecho" 1)
   (SETQ FFF nil))
 (princ)
)

;比例查詢
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 8. 30                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 比例查詢                                                                      ║
;║執行方式:                                                                               ║
;║相關檔案:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:scal()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (setvar "cmdecho" 0)
  (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
  (actdcl "pub-dcl" "allert")

   (setq tttxth (getvar "dimscale"))
  (cond
     ((< tttxth 1)
      (setq scl (rtos (fix (/ 1 tttxth)) 2 0)
            scl (strcat " " scl " : " "1"))
      (set_tile "ms_allert" (strcat "本圖目前比例 " scl))
     )
     ((> tttxth 1)
      (setq scl (rtos (fix tttxth) 2 0)
            scl (strcat " 1" " : " scl))
      (set_tile "ms_allert" (strcat "本圖目前比例 " scl))
     )
     (T (set_tile "ms_allert" (strcat "本圖目前比例 1: 1")) )
  )

 (action_tile "accept" "(done_dialog)")
 (start_dialog)


 (SETQ FFF nil))
   (SETQ FFF nil))
 (setvar "cmdecho" 1)
 (princ)
)


;查詢兩點公英制距離
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 8. 30                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 查詢兩點公英制距離                                                            ║
;║執行方式:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:d-2p(/ p1 d in mm-txt in-txt word)
 (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)
 (prompt "\n======= 請選擇任意兩點以查詢其英制距離 !! =======")
 (setq p1 (getpoint "\n第一點 :")
       d (getdist p1 "\n第二點 :")
       in (/ d 25.4)
       mm-txt (rtos d 2 2)
       in-txt (rtos in 2 2)
       word (strcat "總長是 " in-txt " 英吋   => " mm-txt " mm"))

  (actdcl "pub-dcl" "allert")

  (set_tile "ms_allert" word)

 (action_tile "accept" "(done_dialog)")
 (start_dialog)
   (SETQ FFF nil))
 (princ)
)

;查詢線段公英制長度
;╭════════════════════════════════════════════╮
;║設計日期: 1998. 8. 30                                                                   ║
;║更新日期:                                                                               ║
;║設 計 者: 陳冠達                                                                        ║
;║功能說明: 查詢線段公英制長度                                                            ║
;║執行方式:                                                                               ║
;╰════════════════════════════════════════════╯
(defun c:e-len(/ ent sp ep d in dtxt intxt word)
 (setvar "cmdecho" 0)
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
 (prompt "\n======= 選擇一條直線,以計算這條直線之英制距離 !! =======")
 (setq ent (entget (car (entsel "\n選擇欲計算的直線: ")))
       sp (cdr (assoc 10 ent))
       ep (cdr (assoc 11 ent))
       d (+ (distance sp ep) ppss)
       in (/ d 25.4)
       dtxt (rtos d 2 2)
       intxt (rtos in 2 2)
       word (strcat "線段長度是 " intxt " 英吋 " "==> " dtxt " 公厘"))

  (actdcl "pub-dcl" "allert")

  (set_tile "ms_allert" word)

 (action_tile "accept" "(done_dialog)")
 (start_dialog)

 (SETQ FFF nil))
 (setvar "cmdecho" 1)
 (princ)
)

