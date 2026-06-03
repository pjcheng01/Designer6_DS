;;;
;;;╭════════════════════════════════════════════╮
;;;║設計日期: 2001.01.31                                                                    ║
;;;║更新日期:                                                                               ║
;;;║設 計 者: 佘宗紋                                                                        ║
;;;║功能說明: 連續編號指標球(資訊點)                                                        ║
;;;║執行方式: (autobom btype)                                                               ║
;;;║相關檔案: system.lsp(deflayer)                                                          ║
;;;╰════════════════════════════════════════════╯
;
;;;自由拉出(連續編號)        (AUTObom_info 1)
;;;向上定距指標球(連續編號)  (AUTObom_info 90)
;;;向下定距指標球(連續編號)  (AUTObom_info 270)
;;;向左定距指標球(連續編號)  (AUTObom_info 0)
;;;向右定距指標球(連續編號)  (AUTObom_info 180)
(defun autobom_info(btype / autob_fg ent)
   
   (progn
          (setq ppss sspp autob_fg nil ent nil)
          (setvar "cmdecho" 0)

          (setq old_osmode (getvar "osmode"))
          (setq old_layer (getvar "clayer"))
          (setq old_color (getvar "cecolor"))
          (setq scal (getvar "dimscale"))
          (cond
               ((= "BYLAYER" old_color)(setq old_color 256))
               ((= "BYBLOCK" old_color)(setq old_color 0))
          )

          (defun *error* (msg)
                 (princ msg)
                 (command "clayer" old_layer "cecolor" old_color)
                 (setvar "cmdecho" 1)
                 (setvar "osmode" old_osmode)
          )
          (actdcl (strcat powdesign_path "manapart") "autob_info")
          (setq scal (getvar "dimscale"))
          (if (null di)
            (setq gooddi (* scal (atof sys_ball_dia)))
            (setq di gooddi)
          )
          (if (and (/= nil ftxt)(/= "" ftxt))(set_tile "ftxt" ftxt))

          (set_tile "dist" (rtos (* 1.2 (* scal (atof sys_ball_dia))) 2 2))
          (if (= 1 btype)(mode_tile "dist" 1))

          (set_tile "error" (strcat "請注意:件號間距不可小於 " (rtos gooddi 2 2)))
          (action_tile "accept" "(autobom_info_ok)")
          (action_tile "cancel" "(done_dialog)")
          (start_dialog)

          (if autob_fg
              (progn
          ;          (bomdata_yesno)
                    (cond
                      ((= btype 0)   (setq ballang 0))
                      ((= btype 30)  (setq ballang (/ pi 6)))            ;FOR ISO
                      ((= btype 90)  (setq ballang (* pi 0.5)))
                      ((= btype 150) (setq ballang (* pi (/ 5 6.0))))    ;FOR ISO
                      ((= btype 180) (setq ballang pi))
                      ((= btype 210) (setq ballang (* pi (/ 7 6.0))))    ;FOR ISO
                      ((= btype 270) (setq ballang (* pi 1.5)))
                      ((= btype 330) (setq ballang (* pi (/ 11 6.0))))   ;FOR ISO
                      (T (princ))
                    )
                    (setvar "osmode" 0)

                    (while (null ent)
                           (setq ent (entsel "\n選擇圖元或資訊點 :"))
                    )
                    (select_ent_info)

                    (if (/= btype 1)
                        (setq bomtxtp (getpoint p1 "\n件號位置:  "))
                    );if

                    (while p1
                       (setq bomtxt (strcat ftxt (rtos fno 2 0)))

                       (if (= btype 1) (setq bomtxtp (getpoint p1 "\n件號位置:  ")))
                       (setq ang (angle bomtxtp p1))

                       (cond
                         ((= "1" sys_ball_yesno) (setq p2 (polar bomtxtp ang (* 0.5 scal (atof sys_ball_dia)))))
                         ((= "0" sys_ball_yesno) (setq p2 (polar bomtxtp ang (* 0.9 scal (atof sys_balltxt_hei)))))
                         ((= "2" sys_ball_yesno) (setq p2 (get_sixball_intp)))
                       )
                       (make_layer sys_ball_layer sys_ball_layercol)

                       (cond
                          ((= "1" sys_ball_yesno)
                           (command "circle" bomtxtp "d" (* scal (atof sys_ball_dia)))
                           (ad1xdata (entlast) data8 (list data8 (cons 1000 data8)))
                           (ad1xdata (entlast) "layer" (list "layer" (cons 1000 data8)))
                          )
                          ((= "0" sys_ball_yesno) (princ))
                          ((= "2" sys_ball_yesno) (princ))
                       )

                       (command "line" p1 p2 "")
                       (ad1xdata (entlast) data8 (list data8 (cons 1000 data8)))
                       (ad1xdata (entlast) "layer" (list "layer" (cons 1000 data8)))

                       (command "text" "m" bomtxtp (* scal (atof sys_balltxt_hei)) "0" bomtxt)
                       (ad1xdata (entlast) data8 (list data8 (cons 1000 data8)))
                       (ad1xdata (entlast) "layer" (list "layer" (cons 1000 data8)))

                      ; (if (= "Yes" bomdata_flag) (add_bomball_xdata (entlast) bomtxt))

                       (command "clayer" old_layer "cecolor" old_color)

;;;====================變更資訊點組合件號值=============================================
                       (setq $data1 (getatt ent 2 "TAG1")
                             $data1 (subst (cons 1 bomtxt) (assoc 1 $data1) $data1))
                       (entmod $data1)
;;;====================變更資訊點組合件號值=============================================

                       (setq ent nil)
                       (setq ent (entsel "\n選擇圖元或資訊點 :"))
                       (if ent (select_ent_info)(setq p1 nil))

                       (if (and (/= btype 1) p1) (setq bomtxtp (polar bomtxtp ballang di)))
                       (setq fno (1+ fno))
                    );while
                    (command "clayer" old_layer "cecolor" old_color)
              );progn
          );if
                    (setvar "cmdecho" 1)
                    (setvar "osmode" old_osmode))
   (princ)
)

(defun autobom_info_ok()
  (setq di (get_tile "dist")
        ftxt (get_tile "ftxt")
        fno (get_tile "fno"))
  (if (and (/= nil ftxt)(/= "" ftxt))
          (progn
               (set_tile "ftxt" ftxt)
               (setq ftxt_len (strlen ftxt))
          );progn
          (progn
               (setq ftxt_len 0)
          );progn  
  );if
  (cond
    ((= "" di)(set_tile "error" "未輸入件號間距!"))
    ((= "" fno)(set_tile "error" "未輸入起始件號!"))
    ((= 0 (atoi fno))(set_tile "error" "件號不可為 0 值或文字!"))
    (T (setq autob_fg t fno (atoi fno))(setq di (atof di))(done_dialog))
  );cond
)

;;;由圖層名直接找資訊點
(defun findbomp_ent_info(lname)
   (setq ssg1 (ssget "x" (list (cons 8 lname)(cons 0 "INSERT")(cons 2 "PARTREF"))))
   (if ssg1 (setq ssg1 (ssname ssg1 0)))
   ssg1
)

;;;選擇圖元或資訊點
(defun select_ent_info()

        (setq entdata (entget (car ent))
              data0 (cdr (assoc 0 entdata))
              data8 (cdr (assoc 8 entdata))
              data2 (cdr (assoc 2 entdata))
        )
        (if (and (= data0 "INSERT")(= (strcase data2) "PARTREF"))
          (progn
            (setq p1 (cdr (assoc 10 entdata)))
           ; (setq ee t)
          );progn
          (progn
            (setq ent (findbomp_ent_info data8))
            (if (/= nil ent)
                (setq p1 (cdr(assoc 10 (entget ent))))
                (progn (alert "找不到資訊點 , 請先建立資訊點 !") (exit))
            );if
          );progn
        );if

);defun

;;;球形為6角形
       (defun get_sixball_intp()
          (setq lent (entlast))
          (command "polygon" "6" bomtxtp "c" (* 0.5 scal (atof sys_ball_dia)))
          (command "explode" "l")
          (setq s1 (entnext lent)
                s2 (entnext s1)
                s3 (entnext s2)
                s4 (entnext s3)
                s5 (entnext s4)
                s6 (entnext s5)
                s1data (entget s1)
                s1data10 (cdr (assoc 10 s1data))
                s1data11 (cdr (assoc 11 s1data))
                s2data (entget s2)
                s2data10 (cdr (assoc 10 s2data))
                s2data11 (cdr (assoc 11 s2data))
                s3data (entget s3)
                s3data10 (cdr (assoc 10 s3data))
                s3data11 (cdr (assoc 11 s3data))
                s4data (entget s4)
                s4data10 (cdr (assoc 10 s4data))
                s4data11 (cdr (assoc 11 s4data))
                s5data (entget s5)
                s5data10 (cdr (assoc 10 s5data))
                s5data11 (cdr (assoc 11 s5data))
                s6data (entget s6)
                s6data10 (cdr (assoc 10 s6data))
                s6data11 (cdr (assoc 11 s6data)))
           (command "u")
           (cond
             ((/= nil (setq po_intp (inters p1 bomtxtp s1data10 s1data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s2data10 s2data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s3data10 s3data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s4data10 s4data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s5data10 s5data11))))
             ((/= nil (setq po_intp (inters p1 bomtxtp s6data10 s6data11))))
           )
           po_intp
      );defun


;;;==========================================================================================
;;;╭════════════════════════════════════════════╮
;;;║設計日期: 2001.02.01                                                                    ║
;;;║更新日期:                                                                               ║
;;;║設 計 者: 佘宗紋                                                                        ║
;;;║功能說明: 不連續編號指標球                                                              ║
;;;║執行方式: (keyin_bom_info btype)                                                        ║
;;;║相關檔案: system.lsp(deflayer)                                                          ║
;;;╰════════════════════════════════════════════╯

;自由拉出(不連續編號)        (keyin_bom_info 1)
;向上定距指標球(不連續編號)  (keyin_bom_info 90)
;向下定距指標球(不連續編號)  (keyin_bom_info 270)
;向左定距指標球(不連續編號)  (keyin_bom_info 0)
;向右定距指標球(不連續編號)  (keyin_bom_info 180)

(defun keyin_bom_info(btype)
   
   (progn
          (setq ppss sspp autob_fg nil ent nil)
          (setvar "cmdecho" 0)

          (setq old_osmode (getvar "osmode"))
          (setq old_layer (getvar "clayer"))
          (setq old_color (getvar "cecolor"))
          (setq scal (getvar "dimscale"))
          (cond
               ((= "BYLAYER" old_color)(setq old_color 256))
               ((= "BYBLOCK" old_color)(setq old_color 0))
          )

          (defun *error* (msg)
                 (princ msg)
                 (command "clayer" old_layer "cecolor" old_color)
                 (setvar "cmdecho" 1)
                 (setvar "osmode" old_osmode)
          )
          (actdcl (strcat powdesign_path "manapart") "keyinb_info")
          (setq scal (getvar "dimscale"))
          (if (null di)
            (setq gooddi (* scal (atof sys_ball_dia)))
            (setq di gooddi)
          )
          (if (and (/= nil ftxt)(/= "" ftxt))(set_tile "ftxt" ftxt))


          (set_tile "dist" (rtos (* 1.2 (* scal (atof sys_ball_dia))) 2 2))
          (if (= 1 btype)(mode_tile "dist" 1))

          (set_tile "error" (strcat "請注意:件號間距不可小於 " (rtos gooddi 2 2)))
          (action_tile "accept" "(autobom_info_ok)")
          (action_tile "cancel" "(done_dialog)")
          (start_dialog)

          (if autob_fg
              (progn
          ;          (bomdata_yesno)
                    (cond
                      ((= btype 0)   (setq ballang 0))
                      ((= btype 30)  (setq ballang (/ pi 6)))            ;FOR ISO
                      ((= btype 90)  (setq ballang (* pi 0.5)))
                      ((= btype 150) (setq ballang (* pi (/ 5 6.0))))    ;FOR ISO
                      ((= btype 180) (setq ballang pi))
                      ((= btype 210) (setq ballang (* pi (/ 7 6.0))))    ;FOR ISO
                      ((= btype 270) (setq ballang (* pi 1.5)))
                      ((= btype 330) (setq ballang (* pi (/ 11 6.0))))   ;FOR ISO
                      (T (princ))
                    )
                    (setvar "osmode" 0)

                    (while (null ent)
                           (setq ent (entsel "\n選擇圖元或資訊點 :"))
                    )
                    (select_ent_info)

                    (if (/= btype 1)
                        (setq bomtxtp (getpoint p1 "\n件號位置:  "))
                    );if

                    (while p1
                       (setq bomtxt (strcat ftxt (rtos fno 2 0)))

                       (if (= btype 1) (setq bomtxtp (getpoint p1 "\n件號位置:  ")))
                       (setq ang (angle bomtxtp p1))

                       (cond
                         ((= "1" sys_ball_yesno) (setq p2 (polar bomtxtp ang (* 0.5 scal (atof sys_ball_dia)))))
                         ((= "0" sys_ball_yesno) (setq p2 (polar bomtxtp ang (* 0.9 scal (atof sys_balltxt_hei)))))
                         ((= "2" sys_ball_yesno) (setq p2 (get_sixball_intp)))
                       )
                       (make_layer sys_ball_layer sys_ball_layercol)

                       (cond
                          ((= "1" sys_ball_yesno)
                           (command "circle" bomtxtp "d" (* scal (atof sys_ball_dia)))
                           (ad1xdata (entlast) data8 (list data8 (cons 1000 data8)))
                           (ad1xdata (entlast) "layer" (list "layer" (cons 1000 data8)))
                          )
                          ((= "0" sys_ball_yesno) (princ))
                          ((= "2" sys_ball_yesno) (princ))
                       )

                       (command "line" p1 p2 "")
                       (ad1xdata (entlast) data8 (list data8 (cons 1000 data8)))
                       (ad1xdata (entlast) "layer" (list "layer" (cons 1000 data8)))

                       (command "text" "m" bomtxtp (* scal (atof sys_balltxt_hei)) "0" bomtxt)
                       (ad1xdata (entlast) data8 (list data8 (cons 1000 data8)))
                       (ad1xdata (entlast) "layer" (list "layer" (cons 1000 data8)))

                      ; (if (= "Yes" bomdata_flag) (add_bomball_xdata (entlast) bomtxt))

                       (command "clayer" old_layer "cecolor" old_color)

;;;====================變更資訊點組合件號值=============================================
                       (setq $data1 (getatt ent 2 "TAG1")
                             $data1 (subst (cons 1 bomtxt) (assoc 1 $data1) $data1))
                       (entmod $data1)
;;;====================變更資訊點組合件號值=============================================

                       (setq ent nil)
                       (setq ent (entsel "\n選擇圖元或資訊點 :"))
                       (if ent (select_ent_info)(setq p1 nil))

                       (if p1 (setq fno (getint (strcat "\n輸入件號 :" ftxt))))

                       (if (and (/= btype 1) p1)(setq bomtxtp (polar bomtxtp ballang di)));if
                    );while
                    (command "clayer" old_layer "cecolor" old_color)
              );progn
          );if
                    (setvar "cmdecho" 1)
                    (setvar "osmode" old_osmode))
   (princ)
)
