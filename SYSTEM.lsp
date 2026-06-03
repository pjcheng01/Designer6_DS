;;;
;;系統公用變數忘

; autocad_ver     : "14" or "12"
; deflayer_list   : (("圖紙層" "BORDER" "BYBLOCK") ("尺寸標註層" "DIM" "2") ("文字註解層"　"TEXT"　"4")("指標圓球層"　"BALLBOM" "2")("材料清單層"　"MATLIST" "2")("投影線層" "PROJ" "143"))
; defltype_list   : (("粗連續線" "CONTINUOUS" "7")("細連續線" "CONTINUOUS" "4")("虛線" "DASHED" "3")("標準中心線(長度20)" "CENTER" "1")("短中心線(長度10)" "CENTER1" "1")("假想線" "PHANTOM" "5")("剖面線" "CONTINUOUS" "6")("假想線" "PHANTOM" "5")("投影線" "CONTINUOUS" "143"))
; defbomlist_list : (("件號" "15")("品名" "20")("材質" "10")("料號" "10")("數量" "10")("備註" "30"))
; defbomqty_id    : "數量位置"    例如: "5"

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
       (exit)
     )
     (nth 1 (assoc txtid language_total_list))
   )
)

;格式:      ("圓球有無" "圓球直徑" "圓點有無" "圓點直徑" "字高")
;指標球定義=("1" "10" "0" "0" "6")
(defun get_bomdef()
  (setq defball_list (list "1" "8" "1" "1" "3"))
  (setq sys_ball_yesno     (nth 0 defball_list)
        sys_ball_dia        (nth 1 defball_list)
        sys_ballpoint_type  (nth 2 defball_list)
        sys_ballpoint_size  (nth 3 defball_list)
        sys_balltxt_hei     (nth 4 defball_list))
)

;材料清單欄位定義=(("件號" "10") ("品名" "20")("材質" "10") ("料號" "10") ("數量" "10") ("材質" "16") ("備註" "20"))
(defun get_bomlistdef()
  (setq defbomlist_list (list (list "No." "15") (list "Part Name" "20") (list "Material" "10") (list "Qty" "10") (list "Remark" "16")))
  (setq defbomqty_id "5")
)


;;圖框屬性=(("機種" "機種" "TYPE")("圖名" "圖名" "DWGNAME")("材質" "材質" "MATERIAL")("圖號" "" "DWGNO")("數量" "" "QTY"))
;(defun get_sheetatt()            ;圖框相關定義
;   (setq defsheetatt_list (read (getval "圖框屬性")))
;)



;;=============================================================================================

;圖層定義=(("圖紙層" "BORDER" "BYBLOCK") ("尺寸標註層" "DIM" "2") ("文字註解層"　"TEXT"　"4")("指標圓球層"　"BALLBOM" "2")("材料清單層"　"MATLIST" "2")("投影線層" "PROJ" "143"))
(defun get_layerdef()
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
)


(setq system_dwg_libpath "") ;; default

;線型定義=(("粗連續線" "CONTINUOUS" 7)("細連續線" "CONTINUOUS" 4)("虛線" "DASHED" 3)("標準中心線(長度20)" "CENTER" 1)("短中心線(長度10)" "CENTER1" 1)("假想線" "PHANTOM" 5)("剖面線" "CONTINUOUS" 6)("假想線" "PHANTOM" 5)("投影線" "CONTINUOUS" 143 "PROJ"))
(defun get_ltypedef()
  (redefine_ltype)
  ;; DraftSight: linetype loading
  (if (findfile (strcat powdesign_path "acad.lin"))
    (progn
      (setq count 0)
      (repeat (length defltype_list)
        (setq beload_ltype (strcase (nth 1 (nth count defltype_list))))
        (if (tblsearch "LTYPE" beload_ltype)
          (command "linetype" "l" beload_ltype (strcat powdesign_path "acad.lin") "y" "")
          (command "linetype" "l" beload_ltype (strcat powdesign_path "acad.lin") "")
        )
        (setq count (1+ count))
      )
    )
  )
);defun

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

;(defun c:#setting()       ;; AUTOCAD R14 (WIN95,98,     OLD KEYPRO)
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
;      (princ "\n錯誤訊息 !! POWER DESIGN 機械設計家安裝不正確 !!!")
;      (PRINC "\n請檢查安裝程序. 若需要服務,請電: (04)230-7650 藝祥資訊 客服部")
;    )
;  )
;  (setvar "cmdecho" 1)
;  (princ)
;)

(defun c:#setting()    ;; AUTOCAD 2000 (WINNT,   NEW KEYPRO)
  ;; removed: loadsys
  ;; removed: check_which_app

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
      (prompt "\n              本系統由藝祥資訊工程有限公司   陳冠達 發展完成.")
      (prompt "\n                   TEL:(04)230-7650   FAX:(04)231-4708")
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

  (princ "\n藝祥資訊 POWER系列機械設計系統載入 ! 請稍待...")
  (princ "\n系統發展: 藝祥資訊工程有限公司    TEL:04-2307650   FAX:04-2314708")

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

  (C:#SETTING)

;    );progn
;    (princ "\n很抱歉! POWER DESIGN 機械設計家試用期已過, 請電洽 04-2307650 藝祥資訊")
;  );IF


   (setvar "cmdecho" 1)
   (princ)
   )'()
)
)
