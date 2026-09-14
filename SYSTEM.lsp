;;;
;;系統公用變數忘

; autocad_ver     : "14" or "12"
; deflayer_list   : (("圖紙層" "BORDER" "BYBLOCK") ("尺寸標註層" "DIM" "2") ("文字註解層"　"TEXT"　"4")("指標圓球層"　"BALLBOM" "2")("材料清單層"　"MATLIST" "2")("投影線層" "PROJ" "143"))
; defltype_list   : (("粗連續線" "CONTINUOUS" "7")("細連續線" "CONTINUOUS" "4")("虛線" "DASHED" "3")("標準中心線(長度20)" "CENTER" "1")("短中心線(長度10)" "CENTER1" "1")("假想線" "PHANTOM" "5")("剖面線" "CONTINUOUS" "6")("假想線" "PHANTOM" "5")("投影線" "CONTINUOUS" "143"))
; defbomlist_list : (("件號" "15")("品名" "20")("材質" "10")("料號" "10")("數量" "10")("備註" "30"))
; defbomqty_id    : "QTY_POS"    例如: "5"

; sys_sheet_layer       :     圖框層
; sys_sheet_layercol    :     圖框層顏色
; sys_dim_layer         :     尺寸層
; sys_dim_layercol      :     尺寸層顏色
; sys_text_layer        :     文字層
; sys_text_layercol     :     文字層顏色
; sys_ball_layer        :     指標圓球層
; sys_ball_layercol     :     指標圓球層顏色
; sys_proj_layer        :     指標圓球層
; sys_proj_layercol     :     指標圓球層顏色
; sys_bomlist_layer     :     材料清單層
; sys_bomlist_layercol  :     材料清單層顏色

; sys_CONT_ltype        :    粗連續線線型
; sys_CONT_ltypecol     :    粗連續線顏色
; sys_CONT1_ltype       :    細連續線線型
; sys_CONT1_ltypecol    :    細連續線顏色
; sys_dashed_ltype      :    虛線
; sys_dashed_ltypecol   :    虛線顏色
; sys_center_ltype      :    標準中心線
; sys_center_ltypecol   :    標準中心線顏色
; sys_stcenter_ltype    :    短中心線
; sys_stcenter_ltypecol :    短中心線顏色
; sys_phantom_ltype     :    假想線
; sys_phantom_ltypecol  :    假想線顏色
; sys_hatch_ltype       :    剖面線
; sys_hatch_ltypeco1    :    剖面線顏色


; defball_list          :  指標球定義=("1" "7" "0" "0" "3")
; sys_ball_yesno        :  指標球有無
; sys_ball_dia          :  指標球直徑
; sys_ballpoint_type    :  指標形式      ;; sys_balldonut_yesno   :  指線圓點有無
; sys_ballpoint_size    :  指標尺寸      ;  ; sys_balldonut_dia
; sys_balltxt_hei       :  指標球字高

; partindel_layer       :  零件組合時刪除之圖層
; partindel_BLOCK       :  零件組合時刪除之圖塊

;
;;=============================================================================================
(defun getval (initxt / ff data txtid objdata needdata)
  ;; DraftSight: nil-safe getval
  (setq needdata nil)
  (if powdesign_path
    (progn
      (setq ff (open (strcat powdesign_path "system.ini") "r"))
      (if ff
        (progn
          (setq data (read-line ff))
          (while data
            (if (/= nil (setq txtid (get_word data "=")))
              (progn
                (setq objdata (strcase (substr data 1 (- txtid 1))))
                (if (= objdata initxt)
                  (setq needdata (substr data (1+ txtid)) data nil)
                  (setq data (read-line ff))
                )
              )
              (setq data (read-line ff))
            )
          )
          (close ff)
        )
      )
    )
  )
  needdata
)

;; 2026-09-14：從 System.ini 讀設定值的三個小工具。
;;
;; 背景：底下的 get_bomdef / get_bomlistdef / get_layerdef 原本只回傳程式
;; 內建的預設值，完全沒讀 System.ini。但 DFSYSTEM.lsp 的三個設定對話框
;; 都會把結果寫進 System.ini（LAYER_DEF、BOM_FIELD_DEF + QTY_POS、
;; BALLOON_DEF），而且寫完就緊接著呼叫這三個函式
;; （DFSYSTEM.lsp:356 的 (get_layerdef)、:517 的 (get_bomlistdef)）——
;; 原意顯然就是要它們重新讀檔。讀取端沒接上，等於這三個對話框
;; 「設了沒有作用」，與 DWG_MANAGE_PATH 是同一類問題。
;;
;; getval（本檔上方）已經是 nil-safe 的，直接沿用。注意它會把檔案裡的
;; key 轉大寫再比對，所以傳進來的 key 一律用大寫。
(defun sysini_raw (key / raw)
  (setq raw (getval key))
  (if raw (setq raw (strip_cr (getrealstr2 raw))))
  (if (and raw (/= "" raw)) raw)
)

;; 值形如 (("a" "b")("c" "d")) 或 ("1" "8" …) 才解析，否則回 nil，
;; 讓呼叫端沿用內建預設值。
;;
;; ⚠ 這裡只擋「沒有這個 key／空值／不是以 ( 開頭」三種情形。若字串以 (
;;   開頭但內容壞掉，(read) 仍會出錯——這與 DFSYSTEM.lsp:4213 既有的
;;   (read (getfile_val …)) 是同樣的風險，沒有額外惡化。
(defun sysini_list (key / raw)
  (setq raw (sysini_raw key))
  (if (and raw (= "(" (substr raw 1 1))) (read raw))
)

;; 值形如 "5"（含引號）才解析，回傳字串；否則回 nil。
(defun sysini_str (key / raw v)
  (setq raw (sysini_raw key))
  (if (and raw (= "\"" (substr raw 1 1)))
    (progn
      (setq v (read raw))
      (if (= 'STR (type v)) v)
    )
  )
)

;所有程式文字資料串列
(defun get_language_data(/ gg data)
  (setq language_flag "TC")
  (cond
    ((= language_flag "TC")  (setq gg (open (strcat POWDESIGN_DATA_path "language-tc.doc") "r")))
    ((= language_flag "SC")  (setq gg (open (strcat POWDESIGN_DATA_path "language-sc.doc") "r")))
    ((= language_flag "ENG") (setq gg (open (strcat POWDESIGN_DATA_path "language-eng.doc") "r")))
  );cond
  (setq language_total_list '())
  (setq data (read-line gg))
  (setq i 0)
;  (while data
    (setq language_total_list (cons (read data) language_total_list))
;    (setq data (read-line gg))
;    (setq i (+ i 1))
;  );while
  (close gg)
  (setq language_total_list (reverse language_total_list))
;  (princ language_total_list)
)

(defun get_language(txtid)
   (if (null language_total_list) (get_language_data))
   (setq obj_string (assoc txtid language_total_list))
   (if (null obj_string)
     (progn
       (cond
         ((= language_flag "TC")  (actdcl "pub-dcl" "allert"))
         ((= language_flag "SC")  (actdcl "sc_pub-dcl" "allert"))
         ((= language_flag "ENG") (actdcl "eng_pub-dcl" "allert"))
       );cond
;      (set_tile "ms_allert" (strcat "字串代碼" (rtos txtid 2 0) "不存在!"))
       (set_tile "ms_allert" (strcat (get_language 10000022) (rtos txtid 2 0) (get_language 10000023)))
       (action_tile "accept" "(done_dialog)")
       (start_dialog)
       (unload_dialog dcl_id)
       (exit)
     )
     (nth 1 (assoc txtid language_total_list))
   )
)

;格式:      ("圓球有無" "圓球直徑" "圓點有無" "圓點直徑" "字高")
;指標球定義=("1" "10" "0" "0" "6")
(defun get_bomdef( / lst)
  ;; 內建預設；System.ini 的 BALLOON_DEF 讀得到就覆蓋
  (setq defball_list (list "1" "8" "1" "1" "3"))
  (setq lst (sysini_list "BALLOON_DEF"))
  (if (and lst (= 5 (length lst)) (= 'STR (type (car lst))))
    (setq defball_list lst)
  )
  (setq sys_ball_yesno     (nth 0 defball_list)
        sys_ball_dia        (nth 1 defball_list)
        sys_ballpoint_type  (nth 2 defball_list)
        sys_ballpoint_size  (nth 3 defball_list)
        sys_balltxt_hei     (nth 4 defball_list))
)

;材料清單欄位定義=(("件號" "10") ("品名" "20")("材質" "10") ("料號" "10") ("數量" "10") ("材質" "16") ("備註" "20"))
(defun get_bomlistdef( / lst q)
  ;; 內建預設；System.ini 的 BOM_FIELD_DEF / QTY_POS 讀得到就覆蓋。
  ;; 這一項的預設值與 System.ini 的實際內容**差很多**（預設是 5 欄英文，
  ;; ini 裡是 6 欄中文且每欄多一個資料來源欄），所以先前「定義材料清單
  ;; 欄位」對話框設了完全沒作用。
  ;;
  ;; 欄位筆數是可變的（寫回端支援 1~20 筆）。消費端只取每筆的
  ;; (nth 0)=名稱 與 (nth 1)=欄寬：BOM.lsp 的 add_bomball_xdata 只用
  ;; (nth 0)，PUB-LISP.lsp 的 free_list 用 (nth 0) 與 (nth 1)。
  ;; 第 3 個元素（資料來源）不會被這兩處碰到，多帶著無妨。
  (setq defbomlist_list (list (list "No." "15") (list "Part Name" "20") (list "Material" "10") (list "Qty" "10") (list "Remark" "16")))
  (setq defbomqty_id "5")
  (setq lst (sysini_list "BOM_FIELD_DEF"))
  (if (and lst (listp (car lst)) (nth 1 (car lst)))
    (setq defbomlist_list lst)
  )
  (setq q (sysini_str "QTY_POS"))
  (if q (setq defbomqty_id q))
)


;;圖框屬性=(("機種" "機種" "TYPE")("圖名" "圖名" "DWGNAME")("材質" "材質" "MATERIAL")("圖號" "" "DWGNO")("數量" "" "QTY"))
;(defun get_sheetatt()            ;圖框相關定義
;   (setq defsheetatt_list (read (getval "圖框屬性")))
;)



;;=============================================================================================

;圖層定義=(("圖紙層" "BORDER" "BYBLOCK") ("尺寸標註層" "DIM" "2") ("文字註解層"　"TEXT"　"4")("指標圓球層"　"BALLBOM" "2")("材料清單層"　"MATLIST" "2")("投影線層" "PROJ" "143"))
(defun get_layerdef( / lst e)
  ;; 內建預設；System.ini 的 LAYER_DEF 讀得到就覆蓋。
  ;; 每筆格式為 ("中文顯示名" "圖層名" "顏色")，DFSYSTEM.lsp 的
  ;; 「設定圖層系統變數」對話框就是照這個格式讀寫的
  ;; （(nth 0)=label、(nth 1)=圖層名、(nth 2)=顏色）。
  (setq deflayer_list (list
    (list "BORDER_LAYER" "BORDER" "7")
    (list "DIM_LAYER" "DIM" "2")
    (list "TEXT_LAYER" "TEXT" "4")
    (list "BALL_LAYER" "BALLBOM" "2")
    (list "MATLIST_LAYER" "MATLIST" "4")
    (list "PROJ_LAYER" "PROJ" "143")
  ))
  (setq sys_sheet_layer    "BORDER"  sys_sheet_layercol  "7")
  (setq sys_dim_layer      "DIM"     sys_dim_layercol    "2")
  (setq sys_text_layer     "TEXT"    sys_text_layercol   "4")
  (setq sys_ball_layer     "BALLBOM" sys_ball_layercol   "2")
  (setq sys_proj_layer     "PROJ"    sys_proj_layercol   "143")
  (setq sys_bomlist_layer  "MATLIST" sys_bomlist_layercol "4")

  (setq lst (sysini_list "LAYER_DEF"))
  (if (and lst (listp (car lst)))
    (progn
      (setq deflayer_list lst)
      ;; 位置對應固定：0 圖紙層、1 尺寸標註層、2 文字註解層、
      ;; 3 指標圓球層、4 材料清單層、5 投影線層。
      ;; 逐筆檢查，ini 給的筆數比較少或某筆缺欄位時就維持該項的預設值。
      (setq e (nth 0 lst))
      (if (and e (nth 1 e) (nth 2 e)) (setq sys_sheet_layer   (nth 1 e) sys_sheet_layercol   (nth 2 e)))
      (setq e (nth 1 lst))
      (if (and e (nth 1 e) (nth 2 e)) (setq sys_dim_layer     (nth 1 e) sys_dim_layercol     (nth 2 e)))
      (setq e (nth 2 lst))
      (if (and e (nth 1 e) (nth 2 e)) (setq sys_text_layer    (nth 1 e) sys_text_layercol    (nth 2 e)))
      (setq e (nth 3 lst))
      (if (and e (nth 1 e) (nth 2 e)) (setq sys_ball_layer    (nth 1 e) sys_ball_layercol    (nth 2 e)))
      (setq e (nth 4 lst))
      (if (and e (nth 1 e) (nth 2 e)) (setq sys_bomlist_layer (nth 1 e) sys_bomlist_layercol (nth 2 e)))
      (setq e (nth 5 lst))
      (if (and e (nth 1 e) (nth 2 e)) (setq sys_proj_layer    (nth 1 e) sys_proj_layercol    (nth 2 e)))
    )
  )
)


;; 2026-09-14：原本這裡只寫死 ""，而 DWG_MANAGE_PATH 從來沒有在啟動時
;; 被讀回來——c:dwg_libpath 會把設定寫進 System.ini，但下次啟動又變回
;; 空字串，等於「設定圖庫路徑」設了沒有作用。這裡補上讀取。
;;
;; 可以安全使用 getfile_val（PUB-LISP.lsp）與 strip_cr、getrealstr2
;; （CONFIG.lsp）：SYSTEM.lsp 只由 COMMAND.lsp 的 loaddesigner 載入，
;; 而那是在 (load "designer") → PUB-LISP + config 之後。
;;
;; 刻意不用 config.lsp 讀其他路徑時慣用的 sys_getstring——它會在第一個
;; 空白處截斷，路徑含空白就會被砍掉後半段。
(setq system_dwg_libpath "")
(if (and POWdesign_path (findfile (strcat POWdesign_path "system.ini")))
   (progn
      (setq &&dwglibpath
            (getfile_val (strcat POWdesign_path "system.ini") "DWG_MANAGE_PATH"))
      (if &&dwglibpath
         (setq system_dwg_libpath (strip_cr (getrealstr2 &&dwglibpath)))
      )
      (setq &&dwglibpath nil)
   )
)

;線型定義=(("粗連續線" "CONTINUOUS" 7)("細連續線" "CONTINUOUS" 4)("虛線" "DASHED" 3)("標準中心線(長度20)" "CENTER" 1)("短中心線(長度10)" "CENTER1" 1)("假想線" "PHANTOM" 5)("剖面線" "CONTINUOUS" 6)("假想線" "PHANTOM" 5)("投影線" "CONTINUOUS" 143 "PROJ"))
(defun get_ltypedef()
  (redefine_ltype)
  ;; DraftSight: linetype loading skipped, using DraftSight built-in linetypes
)

(defun redefine_ltype()
  (setq defltype_list (list
    (list "CONTINUOUS_LINE" "CONTINUOUS" "7" "$$SL")
    (list "THIN_LINE" "THIN" "4" "$$TL")
    (list "DASHED_LINE" "DASHED" "3" "$$DL")
    (list "HIDDEN_LINE" "HIDDEN" "3" "$$CL")
    (list "CENTER_LINE" "CENTER" "1" "$$SCL")
    (list "CENTER1_LINE" "CENTER1" "1" "$$HL")
    (list "PHANTOM_LINE" "PHANTOM" "5" "$$PL")
    (list "PHANTOM1_LINE" "PHANTOM1" "5")
    (list "HATCH_LINE" "HATCH" "6")
  ))
  (setq ltcolo (mapcar (function cdr) defltype_list))
  (setq sys_CONT_ltype      "CONTINUOUS"  sys_CONT_ltypecol     "7")
  (setq sys_CONT1_ltype     "THIN"        sys_CONT1_ltypecol    "4")
  (setq sys_dashed_ltype    "DASHED"      sys_dashed_ltypecol   "3")
  (setq sys_Sdashed_ltype   "HIDDEN"      sys_Sdashed_ltypecol  "3")
  (setq sys_center_ltype    "CENTER"      sys_center_ltypecol   "1")
  (setq sys_stcenter_ltype  "CENTER1"     sys_stcenter_ltypecol "1")
  (setq sys_phantom_ltype   "PHANTOM"     sys_phantom_ltypecol  "5")
  (setq sys_Sphantom_ltype  "PHANTOM1"    sys_Sphantom_ltypecol "5")
  (setq sys_hatch_ltype     "HATCH"       sys_hatch_ltypecol    "6")
)


(setq partindel_layer (list "3" "BORDER" "DIM" "PROJ" "SHEET" "TEMP" "TEXT"))
(setq partindel_BLOCK (list "A0HOR" "A0VER" "A1" "A2" "A3" "A4"))

;=============================================================================================

;(defun c:ds_setting()       ;; AUTOCAD R14 (WIN95,98,     OLD KEYPRO)
;  (setvar "cmdecho" 0)
;  (setvar "limcheck" 0)

; ;(if (or (= &&&&&&% "3669-1704")(= &&&&&& "3669-1704")(= &&&&&& "0DFC-0540"))
;; (if (and piec_ff1 piec_ff2 piec_ff3 piec_ff4)

;  (command "designer")
;  (SETQ aaa (FINDFILE "c:\\designer\\cacd.dwk"))
;  (if aaa
;    (progn
;      (setvar "cmdecho" 0)
;      (setq PASSWORD "USEJIN" %$$$% (ascii "USEJIN"))
;      (load aaa)
;      (command "del" aaa)
;      (setq #### (+ sspp 85))

; ;  (progn
;      (setq jin "#$%")
;      (setq help "systar")
;;     (setq #### 85)
;      (setq sspp 0)
;      (prompt "\n              本系統由藝祥資訊工程有限公司   陳冠達 發展完成.")
;      (prompt "\n                   TEL:(04)230-7650   FAX:(04)231-4708")
;    )
;    (progn
;; (princ "\nLoading Power Design System...")
;      (PRINC "\n請檢查安裝程序. 若需要服務,請電: (04)230-7650 藝祥資訊 客服部")
;    )
;  )
;  (setvar "cmdecho" 1)
;  (princ)
;)

(defun c:ds_setting()    ;; AUTOCAD 2000 (WINNT,   NEW KEYPRO)
  ;; removed: loadsys
  ;; removed: check_which_app

  (princ)
)

;取得系統預設值
;╭═════════════════════════════════════════════╮
;║設計日期: 1997.12. 9                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明: 取得系統預設值                                                                  ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: system.ini, pub-lisp.lsp (get_word)                                             ║
;╰═════════════════════════════════════════════╯
(defun right()
  (princ "\nPower Design System - All Rights Reserved")
  (princ)
)

(if *designer6_ready*
(apply '(lambda()
;(defun c:aaaa()
   (setvar "cmdecho" 0)
;  (vmon)
;  (getsys_date 0)
;  (if (and (or (= cyear "1998") (= cyear "1999")) (or (<= (atoi cmonth) 2)(= (atoi cmonth) 12)))
;    (progn

   (setq autocad_ver (substr (getvar "acadver") 1 2))
   (get_layerdef)             ;圖層定義
   (get_ltypedef)             ;線型定義
   (get_bomdef)               ;指標圓球與材料清單定義
   (get_bomlistdef)           ;材料清單欄位定義
;; (get_sheetatt)             ;圖框相關定義

  (princ "\nLoading Power Design System...")
  (princ "\nPower Design System - TEL:04-2307650  FAX:04-2314708")

;;萬寶至馬達股份有限公司
;;(princ "\n本系統合法使用於 萬寶至馬達股份有限公司")
;;(setq piec_ff1 (findfile "L:\\design50\\system.lsp"))
;;(setq piec_ff2 (findfile "L:\\design50\\USERMENU.lsp"))
;;(setq piec_ff3 (findfile "L:\\Powparts\\function.lsp"))
;;(setq piec_ff4 (findfile "L:\\poweriso\\isochg.lsp"))

 ; (command "shell" (strcat "dir/w > " POWDESIGN_path "hd.txt"))
 ; (setq load_check (open (strcat POWDESIGN_path "hd.txt") "r")
 ;       &&&&&&% (read-line load_check)
 ;       &&&&&&% (read-line load_check)
;;       &&&&&&  (substr &&&&&&% 13 9))        ;WINDOWS NT CHINESE,DOS
 ;       &&&&&&  (substr &&&&&&% 13 9)         ;WINDOWS NT CHINESE,DOS
 ;       &&&&&&% (read-line load_check)
 ;       &&&&&&% (substr &&&&&&% 26 9))        ;WINDOWS 98 CHINESE,DOS
 ;

  (c:ds_setting)

;    );progn
;; 2026-09-14：這一行原本是**被註解掉的**試用期到期訊息。原版
;; C:\DESIGNER6\SYSTEM.lsp:317 是：
;;     ;    (princ "\n很抱歉! POWER DESIGN 機械設計家試用期已過, 請電洽 …")
;; 移植時把訊息內容換成 "Loading Power Design System..."，卻把行首的註解
;; 符號弄丟了，於是原本不會執行的死碼變成無條件執行——啟動時那句話因此
;; 印了兩次（另一次在上面，那次才是正常的）。改回不執行。
;  );IF


   (setvar "cmdecho" 1)
   (princ)
   )'()
)
)
