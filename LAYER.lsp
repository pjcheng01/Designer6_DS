;;;
;;顯示層 pshow
;;隱藏層 phide
;;顯示 BLOCK bshow
;;
;;冷凍層 pfree
;;解凍層 thraw
;;
;;線色顯示 sltype
;;層色顯示 spart
;;
;;刪除層 DLAY
;;指定目前層  slay
;;改變層 chlay
;;全部顯示 ashow
;;製作層 mlc
;;輸入層名以控制圖層 LCONTROL
;;線型顯示控制 ltcontrol
;;==================================================================================================
;;連續自動建立圖層
(defun c:automlc(/ automlc_ok_fg)
  (setvar "cmdecho" 0)
    (actdcl (strcat POWDESIGN_dcl_path "auxdisp") "automlc")
    (action_tile "accept" "(automlc_ok)")
    (action_tile "cancel" "(done_dialog)")

    (start_dialog)
    (if automlc_ok_fg
     (progn
       (princ "\n圖層建立中,請稍後!")
       (setq snum (atoi snum))
       (setq colnum 1)
       (repeat (atoi eqty)
         (setq layname (strcat fcode (rtos snum 2 0)))
         (princ (strcat "\n圖層 " layname  " 建立完成!"))
         (command "layer" "m" layname "c" colnum layname "")
         (if (> colnum 254)(setq colnum 1)(setq colnum (1+ colnum)))
         (setq snum (1+ snum))
       );repeat
       (princ "\n圖層建立完成!")
     );progn
    );if
  (setvar "cmdecho" 1)
  (PRINC)
)

(defun automlc_ok()
   (setq fcode (get_tile"fcode")
         snum  (get_tile "snum")
         eqty  (get_tile "eqty"))
   (cond
     ((= "" snum)(set_tile "error" "未輸入起始流水號!"))
     ((= 0 (atoi snum))(set_tile "error" "起始流水號不可是 0 或文字!"))
     ((= "" eqty)(set_tile "error" "未輸入圖層數量!"))
     ((= 0 (atoi eqty))(set_tile "error" "圖層數量不可是 0 或文字!"))
    (T (setq automlc_ok_fg t)(done_dialog))
   )
)


;;製作層 mlc
(defun c:mlc(/ y vctr vmax vmin werty x p1 p2 color col)
   (setvar "cmdecho" 0)
   (setq layname (strcase (getstring "\n輸入新層名: ")))
   (princ "\n由螢幕選擇新層顏色!!")
   (setq search (tblsearch "layer" layname))
    (progn(setq ppss sspp)
   (if (/= search nil) (command "layer" "s" layname "")
      (progn
         (setq col (acad_colordlg 1))
         (while (or (= 0 col) (= 256 col))
           (princ "\n不可選擇 Bylayer 或 Byblock !")
           (setq col (acad_colordlg 1))
         );while
         (if (/= nil col)
           (progn
              (command "layer" "m" layname "c" col layname "")
              (princ (strcat layname " 圖層建立成功!"))
           );progn
           (princ "\n圖層建立失敗!"))
      )
   )
   (c:&sl&)
   (setvar "cmdecho" 1))
   (princ)
)

;;全部顯示 ashow
(defun c:ashow ()
   (progn(setq ppss sspp)
 (setvar "cmdecho" 0)
 (command "layer" "on" "*" ""))
 (princ)
)

;;改變層 chlay
(defun c:chlay()
  (initget "X Free Layer")
  (setq ch_sty (getkword "\n圖元選擇模式: 過濾器 ssX / 圖層 Layer / <按 Enter 鍵後任意選取>: "))
  (cond
    ((= ch_sty "Layer")(la_group))
    ((= ch_sty "X") (setq gro-ent (ssx)) (#chla#))
    (T (setq gro-ent (ssget)) (#chla#))
  )
)
(defun ssx_fe (/ x data fltr ent)
  (setq ent (car (entsel "\n選擇物體/<不選擇>: ")))
  (if ent
    (progn
      (setq data (entget ent))
      (foreach x '(0 2 6 7 8 39 62 66 210) ; do not include 38
        (if (assoc x data)
          (setq fltr
            (cons (assoc x data) fltr)
          )
        )
      )
      (reverse fltr)
    )
  )
)
(defun ssx_re (element alist)
  (append
    (reverse (cdr (member element (reverse alist))))
    (cdr (member element alist))
  )
)
;;;
;;; INTERNAL ERROR HANDLER
;;;
(defun ssx_er (s)                     ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
  (if (/= s "程式中斷")
    (princ (strcat "\n錯誤: " s))
  )
  (if olderr (setq *error* olderr))   ; Restore old *error* handler
  (princ)
)
(defun ssx (/ olderr)
  (gc)                                ; close any sel-sets
  (setq olderr *error*
        *error* ssx_er
  )
  (setq fltr (ssx_fe))
  (ssx_gf fltr)
)
(defun ssx_gf (f1 / t1 t2 t3 f1 f2)
  (while
    (progn
      (cond (f1 (prompt "\n過濾器: ") (prin1 f1)))
      (initget
        "Block Color Entity Flag LAyer LType Pick Style Thickness Vector")
      (setq t1 (getkword (strcat
        "\n>>區段名稱 B/顏色 C/圖元 E/旗號 F/"
        "圖層 LA/線型 LT/選取 P/字型 S/厚度 T/向量 V: ")))
    )
    (setq t2
      (cond
        ((eq t1 "Block")      2)   ((eq t1 "Color")     62)
        ((eq t1 "Entity")     0)   ((eq t1 "LAyer")      8)
        ((eq t1 "LType")      6)   ((eq t1 "Style")      7)
        ((eq t1 "Thickness") 39)   ((eq t1 "Flag" )     66)
        ((eq t1 "Vector")   210)
        (T t1)
      )
    )
    (setq t3
      (cond
        ((= t2  2)  (getstring "\n>>輸入欲選取之 Block 名稱/<RETURN to remove>: "))
        ((= t2 62)  (initget 4 "?")
          (cond
            ((or (eq (setq t3 (getint
              "\n>>輸入欲選取之顏色代號/?/<RETURN to remove>: ")) "?")
              (> t3 256))
              (ssx_pc)                ; Print color values.
              nil
            )
            (T
              t3                      ; Return t3.
            )
          )
        )
        ((= t2  0) (getstring "\n>>輸入欲選取之圖元 type/<RETURN to remove>: "))
        ((= t2  8) (getstring "\n>>輸入欲選取之圖層名稱/<RETURN to remove>: "))
        ((= t2  6) (getstring "\n>>輸入欲選取之線型名稱/<RETURN to remove>: "))
        ((= t2  7)
          (getstring "\n>>輸入欲選取之字型名稱 /<RETURN to remove>: ")
        )
        ((= t2 39)  (getreal   "\n>>輸入欲選取之Thickness/<RETURN to remove>: "))
        ((= t2 66)  (if (assoc 66 f1) nil 1))
        ((= t2 210)
          (getpoint  "\n>>輸入欲選取之Extrusion Vector/<RETURN to remove>: ")
        )
        (T          nil)
      )
    )
    (cond
      ((= t2 "Pick") (setq f1 (ssx_fe) t2 nil)) ; get entity
      ((and f1 (assoc t2 f1))         ; already in the list
        (if (and t3 (/= t3 ""))
          ;; Replace with a new value...
          (setq f1 (subst (cons t2 t3) (assoc t2 f1) f1))
          ;; Remove it from filter list...
          (setq f1 (ssx_re (assoc t2 f1) f1))
        )
      )
      ((and t3 (/= t3 ""))
        (setq f1 (cons (cons t2 t3) f1))
      )
      (T nil)
    )
  )
  (if f1 (setq f2 (ssget "x" f1)))
  (setq *error* olderr)
  (if (and f1 f2)
    (progn
      (princ (strcat "\n" (itoa (sslength f2)) " found. "))
      f2
    )
    (progn (princ "\n0 found.") (prin1))
  )
)
;;;
;;; Print the standard color assignments.
;;;
;;;
(defun ssx_pc ()
  (if textpage (textpage) (textscr))
  (princ "\n                                                     ")
  (princ "\n                 Color number   |   Standard meaning ")
  (princ "\n                ________________|____________________")
  (princ "\n                                |                    ")
  (princ "\n                       0        |      <BYBLOCK>     ")
  (princ "\n                       1        |      Red           ")
  (princ "\n                       2        |      Yellow        ")
  (princ "\n                       3        |      Green         ")
  (princ "\n                       4        |      Cyan          ")
  (princ "\n                       5        |      Blue          ")
  (princ "\n                       6        |      Magenta       ")
  (princ "\n                       7        |      White         ")
  (princ "\n                    8...255     |      -Varies-      ")
  (princ "\n                      256       |      <BYLAYER>     ")
  (princ "\n                                               \n\n\n")
)
;================
(defun ch_sel()
      (setq count 1)
      (setq pout-gro (ssget "x" (list (cons 8 (nth 0 gro-name)))))
      (repeat (- (length gro-name) 1)
         (command "select" "p" "a" (ssget "x" (list (cons 8 (nth count gro-name)))) "")
         (setq count (1+ count))
      )
)
(defun #chla#()
       (setq new_la (getstring "\n輸入層名 <按 Enter 鍵後選取圖元圖層>:"))
       (if (= new_la "")
          (setq new_la (cdr (assoc 8 (entget (car (entsel "\n選取圖元圖層: "))))))
          (progn
            (while (null (tblsearch "LAYER" new_la))
              (princ "\n您輸入的圖層並不存在 !! 請再輸入一次 !.")
              (setq new_la (getstring "\n輸入層名:"))
            )
          )
       )
       (command "chprop" "p" "" "la" new_la "")
       (princ (strcat "\n圖元已改變到 " (strcase new_la) " 圖層!!"))(princ)
)
(defun la_group()
       (setq group (car (entsel "\n選取圖元圖層 <按 Enter 鍵後輸入圖層名稱>: ")))
       (if (= group nil)
         (progn
            (setq nname (getstring "\n圖層名稱: "))
            (setq nname_cout (strlen nname) txt1 1 sel2 1)
            (setq word "")
            (setq laword (list word))
            (repeat (strlen nname)
              (setq nw (substr nname txt1 sel2))
              (if (/=  nw ",")
                (setq word (strcat word nw))
                (setq laword (cons word laword) word "")
              )
              (setq txt1 (1+ txt1))
            )
            (setq laword (cons word laword) word "")
            (setq gro-name laword)
            (setq count 0)
            (setq pout-gro (ssget "x" (list (cons 8 (nth 0 gro-name)))))
            (repeat (- (length gro-name) 1)
               (command "select" "p" "a" (ssget "x" (list (cons 8 (nth count gro-name)))) "")
               (setq count (1+ count))
            )
         )
         (progn
          (princ "\n選取圖元圖層<按 Enter 鍵結束>: ")
          (setq group (cdr (assoc 8 (entget group))) gro-name (list group))
          (princ group)
          (setq group (car (entsel "")))
          (while group
            (setq group (cdr (assoc 8 (entget group))) gro-name (cons group gro-name)
                  group (car (entsel (strcat "," group)))
            )
          )
          (ch_sel)
         )
       )
       (#chla#)
)





;;指定目前層  slay
(defun c:slay()
   (progn(setq ppss sspp)
  (prompt "\n選擇欲設定現行工作層的圖素: ")
  (setq a (entsel))
  (setq e (car a))
  (setq b (entget e))
  (setq c (cdr (assoc 8 b)))
  (command "layer" "s" c "")
  (princ))
 (princ)
)

;;刪除層 DLAY
(defun c:dlay(/ entt ent)
(progn(setq ppss sspp)
  (setvar "cmdecho" 0)
  (prompt "\n選擇要刪除層的圖素: ")
  (setq ent (entsel " "))
  (if (null ent)(princ "\n未選到任何圖形!")
    (progn
      (while ent
        (setq entt (assoc 8 (entget (car ent))))
        (command "erase" (ssget "x" (list entt)) "")
        (princ (strcat "...圖層 " (cdr entt) " 的所有圖元已被刪除!"))
        (prompt "\n按 Enter 鍵結束指令/<選擇要刪除層的圖素>: ")
        (setq ent (entsel " "))
      )
    );progn
  );if)
  (setvar "cmdecho" 1)(princ)
)

;;層色顯示 spart
(defun chgla_ent(/ selent lay_na flag)
  (setq selent (entget (car sel)))
  (if selent
   (progn
    (setq lay_na (cdr (assoc 8 selent)))
      (if (ssget "x" (list (cons 8 lay_na)))
        (command "chprop" "p" "" "c" "bylayer" ""))
  )(setq flag nil))
)

(defun c:spart(/ sel flag)
   (setvar "cmdecho" 0)
   (setq sel nil)
   (setq sel (entsel "\n或按Enter鍵全部選取/<選擇圖素>: "))
   (if sel
     (progn
        (chgla_ent)
        (setq flag t)
        (while flag
          (setq sel (entsel "\n選擇圖素: "))
          (if sel (chgla_ent)(setq flag nil))
        )
     )
     (command "chprop" "all" "" "c" "bylayer" "")
   )
   (setvar "cmdecho" 1)(princ)
)

;;線色顯示 sltype
;(defun chg_ent(/ lay_na selent ent-lt-c list-num flag)
(defun chg_ent()
  (setq selent (entget (car sel)))
  (if selent
   (progn
    (setq lay_na (cdr (assoc 8 selent))
          list-num 0)
    (repeat (length ltcolo)
      (setq ent-lt-c (nth list-num ltcolo))
      (if (ssget "x" (list (cons 8 lay_na) (cons 6 (car ent-lt-c))))
        (command "chprop" "p" "" "c" (cadr ent-lt-c) ""))
     (setq list-num (1+ list-num))
   )
  )(setq flag nil))
)

(defun chg_all(/ list-num ent-lt-c)
   (foreach nn ltcolo
     (progn
        (if (ssget "x" (list (cons 6 (nth 0 nn))))
          (command "chprop" "p" "" "c" (nth 1 nn) "")
        )
     );progn
   )
)
(defun c:sltype(/ sel flag)
   (setvar "cmdecho" 0)
   (setq sel nil)
   (setq sel (entsel "\n或按Enter鍵全部選取/<選擇圖素>: "))
   (if sel
     (progn
        (chg_ent)
        (setq flag t)
        (while flag
          (setq sel (entsel "\n或按Enter鍵結束/<選擇圖素>: "))
          (if sel (chg_ent)(setq flag nil))
        )
     )
     (chg_all)
   )
   (setvar "cmdecho" 1)(princ)
)

;;解凍層 thraw
(defun c:thraw()
   (progn(setq ppss sspp)
 (setvar "cmdecho" 0)
 (command "layer" "t" "*" "")
 (setvar "cmdecho" 1))
 (princ)
)

;;冷凍層 pfree
(defun c:pfree(/ showlay showlay)
 (setvar "cmdecho" 0)
   (progn(setq ppss sspp)
 (setq showlay (entsel "\n選擇圖素,以便將該層冷凍: "))
 (setq showlay (car showlay))
 (princ "\n選擇圖素,以便將該層冷凍: ")
 (setq showlay (cdr (assoc 8 (entget showlay))) aaa showlay)
 (princ showlay)
 (setq showlay (car (entsel "")))
 (while showlay
    (setq showlay (cdr (assoc 8 (entget showlay))) aaa (strcat aaa "," showlay)
          showlay (car (entsel (strcat "," showlay))))
 )
 (if (/= aaa "") (command "layer" "f" aaa ""))
 (setvar "cmdecho" 1))
 (princ)
)

;;顯示 BLOCK bshow
(defun c:bshow()
  (setvar "cmdecho" 0)
   (progn(setq ppss sspp)
  (grclear)
  (setq showent (ssget "X" '((0 . "INSERT"))))
  (if (/= nil showent)
     (command "rotate" showent "" "0,0" "0")
  )
  (getint "\n請按任意鍵繼續! ")
  (redraw)
  (setvar "cmdecho" 1))
  (princ)
)

;;隱藏層 phide
(defun c:phide (/ oex lay str)
       
       (progn
              (setq ppss sspp) (setvar "cmdecho" 0)
              (setq oex (getvar "expert"))
              (setvar "expert" 1)

              (initget "S")
              (setq lay (entsel "\nSsget 框選圖形/或按 Enter 鍵輸入層名/<選擇欲隱藏的零件層圖素>: "))
              (cond
                   ((= "S" lay)
                    (xwsel_rep "off"))
                   ((null lay)
                      (setq str (strcase (getstring "\n輸入欲隱藏的零件層名: ")))
                      (if (/= str "") (command "layer" "off" str ""))
                   )
                   (T
                      (princ "\n選擇欲隱藏的零件層圖素: ")
                      (setq lay (cdr (assoc 8 (entget (car lay)))) str lay)
                      (princ lay)
                      (setq lay (car (entsel "")))
                      (while lay
                             (setq lay (cdr (assoc 8 (entget lay))) str (strcat str "," lay)
                                   lay (car (entsel (strcat "," lay))))
                      );while
                      (if (/= str "") (command "layer" "off" str ""))
                   );T
              );cond
	      (if (tblsearch "layer" "defpoints")(command "layer" "off" "defpoints" ""));;sam
              (setvar "expert" oex))
 (princ)
)


;;顯示層 pshow
(defun chg_l_num()
   (setq txt1 0 sel2 1)
   (setq word "" nword "")
   (setq tn (strlen showl))
   (repeat tn
     (setq txt1 (1+ txt1))
     (setq nw (substr showl txt1 sel2))
     (if (=  nw ",")
         (setq nword (strcat nword (nth (atoi word) lalst) ",")
               word "")
         (setq word (strcat word nw))
     )
     (if (= tn txt1) (setq aaa (strcat nword (nth (atoi word) lalst))))
   )
)
(defun exe_shl(grp)
       (setvar "expert" 1)
       (command "layer" "off" "*" "on" grp "")
       (setvar "expert" 0)
)
(defun lay_list()
  (setq lalst (cdr (assoc 2 (tblnext "LAYER" T))))
  (if (/= lalst nil)
   (progn
    (setq lalst (list (cdr (assoc 2 (tblnext "LAYER"))) lalst))
    (while
       (setq ladata (tblnext "LAYER"))
       (setq lalst (cons (cdr (assoc 2 ladata)) lalst ) )
    )
  )
 )
 (setq lay_total (length lalst) count (- lay_total 1))
)
(defun c:pshow(/ ccc aaa showlay yesno txt_id setla shla)
       
       (progn
              (setq ppss sspp) (setvar "cmdecho" 0)
              (setq aaa nil nword nil)
              (setq oex (getvar "expert"))
              (setvar "expert" 1)
              (initget  "Yes No")
              (setq yesno (getkword "\n您所點選的第一個圖元將被設為目前層<Yes>: "))
              (if (null yesno) (setq yesno "Yes"))
              (initget "S")
              (setq showlay (entsel "\nSsget 框選圖形/或按 Enter 鍵由對話框選取/<選擇欲顯示的零件層圖形>: "))
              (cond
                  ((= "S" showlay)
                    (setq shla (xwsel_rep "on"))
                    (if (/= nil shla)
                        (progn
                           ;  (exe_shl shla)
                             (if (= "Yes" yesno)
                                 (progn
                                    ;  (setq txt_id (get_word shla ","))
                                    ;  (setq setla (substr shla 1 (- txt_id 1)))
                                      (setq setla (cdr (assoc 8 (entget (ssname shla 0)))))
                                      (command "layer" "m" setla "")
                                 );progn
                             );if
                        );progn
                    );if
                  )
;                  ((null showlay)(c:lcontrol))
                  ((null showlay)(c:pshow_sellayer))
                  (T
                      (setq showlay (car showlay))
                      (princ "\n或按 Enter 鍵結束/<選擇欲顯示的零件層>: ")
                      (setq showlay (cdr (assoc 8 (entget showlay))) aaa showlay)
                      (setq ccc showlay)
                      (princ showlay)
                      (setq showlay (car (entsel "")))
                      (while showlay
                         (setq showlay (cdr (assoc 8 (entget showlay))) aaa (strcat aaa "," showlay)
                               showlay (car (entsel (strcat "," showlay))))

                      )
                      (if (/= "" aaa) (command "layer" "off" "*" "on" aaa ""));if
                     ; (exe_shl aaa)
                      (if (= "Yes" yesno) (command "layer" "m" ccc ""))
                  );T
              );cond
              (setvar "expert" oex))
       (princ)
)

;;框選圖形,顯示關閉圖層
(defun xwsel_rep(key / entgrp num count data la)
   (setq entgrp (ssget))
   (if (= key "on")(command "layer" "off" "*" ""))
   (setq laygrp "")
   (if entgrp
       (progn
            (setq num (sslength entgrp)
                  count 0
                  laylist '())
            (repeat num
                  (setq data (entget (ssname entgrp count))
                        la (cdr (assoc 8 data)))
                  (if (null (member la laylist))
                      (setq laylist (cons la laylist)
                            laygrp (strcat laygrp la ",")
                      )
                  );if
                  (if (> (strlen laygrp) 100)
                      (progn
                         (command "layer" key laygrp "")
                         (setq laygrp "" laylist '())
                      );progn
                  );if
                  (setq count (1+ count))
           );repeat
           (if (/= "" laygrp)(command "layer" key laygrp ""))
     );progn
   );if
   entgrp
)


;;框選圖形,並回應所有圖層字串(排除重覆)
(defun xwsel(/ entgrp num count data la)
   (setq entgrp (ssget))
   (setq laygrp "")
   (if entgrp
     (progn
         (setq num (sslength entgrp)
               count 0
               laylist '())
         (repeat num
            (setq data (entget (ssname entgrp count))
                  la (cdr (assoc 8 data)))
            (if (null (member la laylist))
              (setq laylist (cons la laylist)
                    laygrp (strcat laygrp "," la))
            )
            (setq count (1+ count))
         );repeat
         (setq laygrp (substr laygrp 2))
     );progn
   );if
   laygrp
)

;;
;╭═════════════════════════════════════════════╮
;║設計日期: 2001.1.19                                                                       ║
;║更新日期:                                                                                 ║
;║設 計 者: 佘宗紋                                                                          ║
;║功能說明: 選取欲顯示之圖層名                                                              ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: auxdisp.dcl,pub-lisp.lsp(coll_layer)                                            ║
;╰═════════════════════════════════════════════╯
(defun c:pshow_sellayer(/ sellayerfg id_list curlay i)
       (setvar "cmdecho" 0)

       (actdcl (strcat POWDESIGN_dcl_path "auxdisp") "pshow")
       (set_tile "error" "請選擇要作用的圖層名!")

       ;(setq tlayer_list (acad_strlsort (coll_layer)))
       (setq tlayer_list (coll_layer))

       (act_pop_list tlayer_list "sellayer")

       (if (= yesno "No")(mode_tile "curlay" 1))
       (mode_tile "accept" 1)

       (action_tile "sellayer" "(disp_curlayer_pshow_sellayer)(mode_tile \"accept\" 0)")

       (action_tile "accept" "(setq sellayerfg T)(pshow_sellayer_ok)")
       (action_tile "cancel" "(setq sellayerfg nil)(done_dialog)")

       (start_dialog)

       (if sellayerfg
           (progn
               ; (command "layer" "off" "*" "y" "")
                (command "layer" "off" "*" "")
                (setq i 0)
                (repeat (length id_list)
                        (command "layer" "on" (nth (nth i id_list) tlayer_list) "")
                        (setq i (+ i 1))
                );repeat
                (if (/= yesno "No")
                    (command "layer" "s" (substr curlay 10) "")
                );if
           );progn
       );if

       (setvar "cmdecho" 1)
       (prin1)
)

(defun pshow_sellayer_ok()
       (setq curlay (get_tile "curlay"))
       (if (= "" (get_tile "sellayer"))(setq sellayerfg nil))
       (setq id_list(read (strcat "(" (get_tile "sellayer") ")")))
       (done_dialog)
);defun

(defun disp_curlayer_pshow_sellayer()
       (if (/= yesno "No")
           (progn
                 (if (= (get_tile "curlay") "目前層 : ")
                     (set_tile "curlay" (strcat "目前層 : " (nth (atoi (get_tile "sellayer")) tlayer_list)))
                 );if
           );progn
       );if
)
;;
;╭═════════════════════════════════════════════╮
;║設計日期: 1997.12. 9                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明: 輸入層名以控制圖層                                                              ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: auxdisp.dcl, pub-lisp.lsp(coll_layer)                                           ║
;╰═════════════════════════════════════════════╯
(defun c:lcontrol(/ lcontrolfg)
   (progn(setq ppss sspp)
 (setvar "cmdecho" 0)

 (actdcl (strcat POWDESIGN_dcl_path "auxdisp") "lcontrol")
 (set_tile "error" "請選擇要作用的圖層名!")

 (setq tlayer_list (coll_layer))

 (act_pop_list tlayer_list "sellayer")

 (action_tile "sellayer" "(mode_tile \"on\" 0) (mode_tile \"off\" 0) (mode_tile \"freeze\" 0) (mode_tile \"thraw\" 0) (mode_tile \"curlayer\" 0)(set_tile \"error\" \"請選擇圖層狀態!\")(besel_la)")
 (action_tile "on" "(set_tile \"error\" \"\")")
 (action_tile "off" "(set_tile \"error\" \"\")")
 (action_tile "freeze" "(set_tile \"error\" \"\")")
 (action_tile "thraw"  "(set_tile \"error\" \"\")")
 (action_tile "curlayer"  "(set_tile \"error\" \"\")")

 (action_tile "accept" "(lcontrol_ok)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)

 (if lcontrolfg (command "layer" act_txt lname ""))

 (setvar "cmdecho" 1))
 (prin1)
)

(defun besel_la()
   (setq lname (get_tile "laname")
         la_id (get_tile "sellayer")
         lae  (nth (atoi la_id) tlayer_list))
   (if (= lname "")
     (setq tlname lae)
     (setq tlname (strcat lname ","  lae))
   )
   (set_tile "laname" tlname)

)
(defun lcontrol_ok()
  (setq la_on       (get_tile "on")
        la_off      (get_tile "off")
        la_freeze   (get_tile "freeze")
        la_thraw    (get_tile "thraw")
        la_curlayer (get_tile "curlayer")
        lname (get_tile "laname"))
  (cond
    ((and (/= nil (get_word lname ",")) (= "1" la_curlayer))
     (set_tile "error" "目前圖層不可有 1 個以上之選擇!"))
    ((= "" lname) (set_tile "error" "層名未輸入!"))
    ((and (= "0" la_on) (= "0" la_off) (= "0" la_freeze) (= "0" la_thraw) (= "0" la_curlayer))
     (set_tile "error" "圖層狀態未選定!"))
    (T
       (cond
         ((= "1" la_on) (setq act_txt "on"))
         ((= "1" la_off) (setq act_txt "off"))
         ((= "1" la_freeze) (setq act_txt "f"))
         ((= "1" la_thraw) (setq act_txt "t"))
         (T (setq act_txt "s"))
       )
       (setq lcontrolfg t)
       (done_dialog)
    );t
  );cond
)

;;
;╭═════════════════════════════════════════════╮
;║設計日期: 1998.12. 13                                                                     ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明: 線型顯示控制                                                                    ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: auxdisp.dcl, pub-lisp.lsp                                                       ║
;╰═════════════════════════════════════════════╯
(defun c:ltcontrol(/ ltcontrolfg ltlist data count lt_on lt_off ltname sellist kw)
;(defun c:ltc(/ ltcontrolfg ltlist data count)
   (progn(setq ppss sspp)
 (setvar "cmdecho" 1)

 (actdcl (strcat POWDESIGN_dcl_path "auxdisp") "ltcontrol")
 (set_tile "error" "請選擇要作用的線型!")
 (mode_tile "sellinetype" 1)

 (setq tblock_list (coll_block))
 (if (null (nth 0 tblock_list)) (mode_tile "lt_on" 1))

 (setq ltlist '() count 0)
 (foreach nn defltype_list
   (progn
     (setq data (strcat (nth 0 nn) " " (nth 1 nn)))
     (setq ltlist (cons data ltlist)
           count (1+ count))
   );progn
 )
 (setq ltlist (reverse ltlist))
 (act_pop_list ltlist "sellinetype")

 (action_tile "sellinetype" "(mode_tile \"on\" 0) (mode_tile \"off\" 0)(mode_tile \"curlayer\" 0)")
 (action_tile "on" "(mode_tile \"sellinetype\" 0)(set_tile \"error\" \"\")(show_hideltype)")
 (action_tile "off" "(act_pop_list ltlist \"sellinetype\")(mode_tile \"sellinetype\" 0)(hide_showltype)(set_tile \"error\" \"\")")

 (action_tile "accept" "(ltcontrol_ok)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)

 (if ltcontrolfg (control_ltype))

 (setvar "cmdecho" 1))
 (prin1)
)

(defun show_hideltype()
  (setq tblock_list (coll_block))
  (cond
    ((null (nth 0 tblock_list)) (set_tile "error" "沒有被隱藏的線型!")(mode_tile "sellinetype" 1))
    (T
       (coll_hideblock)
       (mode_tile "sellinetype" 0)
       (act_pop_list hide_list "sellinetype")
    );T
  );cond

)


(defun coll_hideblock()
    (setq hide_list '())
    (foreach nn tblock_list
       (progn
         (if (= "$$" (substr nn 1 2))
           (progn
              (foreach mm defltype_list
                 (progn
                    (if (= nn (nth 3 mm))
                      (progn
                         (setq hide_list (cons (strcat (nth 0 mm) "-" (nth 1 mm))  hide_list))
                      );progn
                    );if
                 );progn
              );foreach
           );progn
         );if
       );progn
    );foreach
    (setq hide_list (reverse hide_list))
)


(defun hide_showltype()
  (setq tblock_list (coll_block))
)


(defun ltcontrol_hide()
    (princ (strcat "\n隱藏 " (nth 0 (nth nn defltype_list)) " 線型..."))
    (if (= acad_ver "GENIUS")
        (command ".block" (nth 3 (nth nn defltype_list)) "none" "0,0" (ssget "x" (list (cons 6 (nth 1 (nth nn defltype_list))))) "")
        (command "block" (nth 3 (nth nn defltype_list)) "none" "0,0" (ssget "x" (list (cons 6 (nth 1 (nth nn defltype_list))))) "")
    )
)

(defun control_ltype()
   (setvar "cmdecho" 0)
   (setq aaa sellist)
   (foreach nn sellist
     (progn
       (if (= lt_off "1")
         (progn
            (setq blktype (tblsearch "BLOCK" (nth 3 (nth nn defltype_list))))
            (if (null blktype)
               (progn
                  (setq ltyp (nth 1 (nth nn defltype_list)))
                  (setq ltyp_grp (ssget "x" (list (cons 6 ltyp))))
                  (if ltyp_grp
                    (ltcontrol_hide)
                    (princ (strcat "\n圖面上沒有" (nth 0 (nth nn defltype_list)) " 線型 !!" ))
                  );if
               );progn
               (progn
                  (setq bbb ltlist)
                  (setq data (nth nn ltlist))
                  (setq ccc data)
                  (setq num (get_word data " "))
                  (setq data (substr data 1 (- num 1)))
                  (setq blkname (nth 3 (assoc data defltype_list)))
                  (princ blkname)
                  (if (= acad_ver "GENIUS")
                      (command ".insert" (strcat "*" blkname) "none" "0,0" "1" "0")
                      (command "insert" (strcat "*" blkname) "none" "0,0" "1" "0")
                  )
                  (command "purge" "b" blkname "n")
                  (ltcontrol_hide)
               );progn
            )
         );progn
         (progn
           (setq data (nth nn hide_list))
           (setq num (get_word data "-"))
           (setq data (substr data 1 (- num 1)))
           (setq blkname (nth 3 (assoc data defltype_list)))
           (princ blkname)
           (if (= acad_ver "GENIUS")
               (command ".insert" (strcat "*" blkname) "none" "0,0" "1" "0")
               (command "insert" (strcat "*" blkname) "none" "0,0" "1" "0")
           )
           (command "purge" "b" blkname "n")
         )
       );if
     );progn
   )
)


(defun ltcontrol_ok()
  (setq lt_on       (get_tile "on")
        lt_off      (get_tile "off")
        ltname (get_tile "sellinetype"))
  (cond
    ((and (= "0" lt_on) (= "0" lt_off))
     (set_tile "error" "未選擇線型顯示狀態!"))
    ((= "" ltname) (set_tile "error" "未選擇線型!"))
    (T
       (if (= "1" lt_on) (setq act_txt "on") (setq act_txt "off"))
       (setq kw (get_word ltname " ") sellist '())
       (while (/= nil kw)
          (setq data (substr ltname 1 (- kw 1)))
          (setq sellist (cons (atoi data) sellist)
                ltname (substr ltname (1+ kw))
                kw (get_word ltname " "))
       );while
       (setq sellist (cons (atoi ltname) sellist))
       (setq ltcontrolfg t)
       (done_dialog)
    );t
  );cond
)

(defun c:chto_clayer()
   (setq clayer (getvar "clayer"))
   (princ (strcat "\n選擇要變換到目前層(" clayer ")的圖形: "))
   (setq selent (ssget))
   (if (/= nil selent)
     (command "change" "p" "" "p" "la" clayer "")
   )
   (princ (strcat "\n所選擇的圖形已經變換到 "clayer " 層!" ))
   (princ)
)



