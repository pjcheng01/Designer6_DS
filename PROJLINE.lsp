;;;
;;旋轉投影線      pdr
;;旋轉投影線      pdl
;;旋轉投影線      pur
;;旋轉投影線      pul
;;消除投影線      delproj
;;水平投影線      hline     0
;;垂直投影線      vline     1
;;十字投影線      hvline    2
;;角度投影線      tline     3
;;與線平行投影線  ptline    4
;;與線垂直投影線  vtline    5
;;任意角度投影              6
;;偏移投影                  7
;;==============================================================================================
;(defun setproj_layer(/ projent entdata layername layercol layerlty)
(defun setproj_layer()
 (setq projent (entsel "\n或按Enter鍵以系統內定圖層/<選擇圖元並以該圖元的圖層作為投影線圖層>:"))
 (if (null projent)
   (progn
     (setq sys_proj_layer      (nth 1 (assoc "投影線層" deflayer_list)))           ;投影線層
     (setq sys_proj_layercol   (nth 2 (assoc "投影線層" deflayer_list)))           ;投影線層顏色
   );progn
   (progn
     (setq entdata (entget (car projent)))
     (setq layername (cdr (assoc 8 entdata)))
     (setq layerdata (tblsearch "LAYER" layername)
           layercol (cdr (assoc 62 layerdata))
           layerlty (cdr (assoc 6 layerdata)))

     (setq sys_proj_layer      layername)
     (setq sys_proj_layercol   (rtos layercol 2 0))
   );progn
 );if
 (princ (strcat "\n目前投影線圖層為 " sys_proj_layer " ,顏色為 " sys_proj_layercol))
)

(defun c:pdr() (setproj_layer)(rotproj 2 1))
(defun c:pdl() (setproj_layer)(rotproj 2 2))
(defun c:pur() (setproj_layer)(rotproj 1 3))
(defun c:pul() (setproj_layer)(rotproj 1 4))

(defun rotproj(typ typ1 / curlayer curcolor curltype la bl flag s-bl e-bl y p1 p102 p103 p104
                          tl ang p1 ph pv interh interv int_y1 int_y2 p-high p-lower)
   ;; 已移除加密狗判斷(progn ;; DraftSight: 移除加密狗 WHILE 迴圈(setq ppss sspp)
  (setq curlayer (getvar "clayer"))
  (setq curcolor (getvar "cecolor"))
  (setq curltype (getvar "celtype"))
  (command "layer" "on" curlayer "")
  (setq la (tblsearch "layer" sys_proj_layer))
  (if (= la nil) (command "layer" "n" sys_proj_layer "c" sys_proj_layercol sys_proj_layer ""))
  (setq BL nil)
  (setq flag 1)
  (setq BL (entsel "\n或按Enter鍵繪製基準線/<選擇旋轉基準線>: "))

  (cond
    ((= typ1 1)
        (if (= BL nil)
           (progn
              (setq S-BL (getpoint "\n選擇旋轉基準線之基準點: "))
              (setq Y (getvar "viewsize"))
              (setq p1 S-BL)
              (setq p103 (polar p1 (- (* pi 0.25)) (+ (/ Y 5) ppss))
                    p102 (polar p103 (/ (* pi 2) 3) (/ Y 22))
                    p104 (polar p103 (/ (* 5 pi) 6) (/ Y 22)))
              (grdraw p1 p103 2)
              (grdraw p103 p104 2)
              (grdraw p103 p102 2)
              (setq TL (getdist S-BL "\n輸入基準線長度: ")
                    E-BL (polar S-BL (- (/ pi 4.)) (+ TL ppss)))
              (grdraw p1 p103 0)
              (grdraw p103 p104 0)
              (grdraw p103 p102 0)
              (command "line" S-BL E-BL "")
              (setq ang (angle S-BL E-BL))

           )
           (progn
             (setq BL (entget (car BL))
                   S-BL (cdr (assoc 10 BL))
                   E-BL (cdr (assoc 11 BL))
                  ang (angle S-BL E-BL))
           )
        )
    );1
    ((= typ1 2)
        (if (= BL nil)
           (progn
              (setq S-BL (getpoint "\n選擇旋轉基準線之基準點: "))
              (setq Y (getvar "viewsize"))
              (setq p1 S-BL)
              (setq p103 (polar p1 (- (* pi 0.75)) (/ Y 5))
                    p102 (polar p103 (/ pi 6) (/ Y 22))
                    p104 (polar p103 (/ pi 3) (/ Y 22)))
              (grdraw p1 p103 2)
              (grdraw p103 p104 2)
              (grdraw p103 p102 2)
              (setq TL (getdist S-BL "\n輸入基準線長度: ")
                    E-BL (polar S-BL (- (* pi 0.75)) TL))
              (grdraw p1 p103 0)
              (grdraw p103 p104 0)
              (grdraw p103 p102 0)
              (command "line" S-BL E-BL "")
              (setq ang (angle S-BL E-BL))

           )
           (progn
             (setq BL (entget (car BL))
                   S-BL (cdr (assoc 10 BL))
                   E-BL (cdr (assoc 11 BL))
                  ang (angle S-BL E-BL))
           )
        )
    );2
    ((= typ1 3)
        (if (= BL nil)
           (progn
              (setq S-BL (getpoint "\n選擇旋轉基準線之基準點: "))
              (setq Y (getvar "viewsize"))
              (setq p1 S-BL)
              (setq p103 (polar p1 (* pi 0.25) (/ Y 5))
                    p102 (polar p103 (/ (* pi 4) 3) (/ Y 22))
                    p104 (polar p103 (/ (* 7 pi) 6) (/ Y 22)))
              (grdraw p1 p103 2)
              (grdraw p103 p104 2)
              (grdraw p103 p102 2)
              (setq TL (getdist S-BL "\n輸入基準線長度: ")
                    E-BL (polar S-BL (/ pi 4.) TL))
              (grdraw p1 p103 0)
              (grdraw p103 p104 0)
              (grdraw p103 p102 0)
              (command "line" S-BL E-BL "")
              (setq ang (angle S-BL E-BL))
           )
           (progn
             (setq BL (entget (car BL))
                   S-BL (cdr (assoc 10 BL))
                   E-BL (cdr (assoc 11 BL))
                  ang (angle S-BL E-BL))
           )
        )
    );3
    ((= typ1 4)
        (if (= BL nil)
           (progn
              (setq S-BL (getpoint "\n選擇旋轉基準線之基準點: "))
              (setq Y (getvar "viewsize"))
              (setq p1 S-BL)
              (setq p103 (polar p1 (* pi 0.75) (/ Y 5))
                    p102 (polar p103 (- (/ pi 6)) (/ Y 22))
                    p104 (polar p103 (- (/ pi 3)) (/ Y 22)))
              (grdraw p1 p103 2)
              (grdraw p103 p104 2)
              (grdraw p103 p102 2)
              (setq TL (getdist S-BL "\n輸入基準線長度: ")
                    E-BL (polar S-BL (* pi 0.75) TL))
              (grdraw p1 p103 0)
              (grdraw p103 p104 0)
              (grdraw p103 p102 0)
              (command "line" S-BL E-BL "")
              (setq ang (angle S-BL E-BL))
           )
           (progn
             (setq BL (entget (car BL))
                   S-BL (cdr (assoc 10 BL))
                   E-BL (cdr (assoc 11 BL))
                  ang (angle S-BL E-BL))
           )
        )
    );
  );cond

  (setq P1 (getpoint "\n選擇投影點: "))
  (while p1
    (setq oldosmode (getvar "osmode"))
    (setvar "osmode" 0)
    (setq ph (polar p1 0 3)
          pv (polar p1 (* pi 0.5) 3))
    (setq interh (inters p1 ph s-bl e-bl nil)
          interv (inters p1 pv s-bl e-bl nil)
          int_y1 (nth 1 interh)
          int_y2 (nth 1 interv))
    (if (> int_y1 int_y2) (setq p-high interh p-lower interv)
                          (setq p-high interv p-lower interh))

    (command "linetype" "s" "bylayer" "" "color" "bylayer" "layer" "s" sys_proj_layer "")
    (command "linetype" "s" "continuous" "")
    (cond
      ((= 1 typ) (command "xline" "h" p-high "")(command "xline" "v" p-high ""))
      ((= 2 typ) (command "xline" "h" p-lower "")(command "xline" "v" p-lower ""))
      (T (princ))
    )
    (command "layer" "s" curlayer "")
    (command "linetype" "s" curltype "")
    (setvar "osmode" oldosmode)
    (setq P1 (getpoint "\n選擇投影點: "))
  );while
  (SETQ FFF nil))
  (princ)
)


(defun c:hline() (setproj_layer)(hvpjline 0))
(defun c:vline() (setproj_layer)(hvpjline 1))
(defun c:hvline() (setproj_layer)(hvpjline 2))
(defun c:tline(/ ang) (setq ang (getangle "\n輸入投影線角度: ")) (setproj_layer)(hvpjline 3))
(defun c:ptline(/ ent) (setq ent (entsel "\n選擇平行投影的參考基準線: ")) (setproj_layer)(hvpjline 4))
(defun c:vtline(/ ent) (setq ent (entsel "\n選擇垂直投影的參考基準線: ")) (setproj_layer)(hvpjline 5))
(defun c:angline(/ ent ang)
  (setq ent (entsel "\n選擇投影的參考基準線: "))
  (setq ang (getdist "\n輸入與參考基準線投之夾度: "))
  (setproj_layer)
  (hvpjline 6))
(defun c:ofpjline(/ ent dist p) (setproj_layer)(hvpjline 7))

(defun hvpjline(typ)
   ;; 已移除加密狗判斷(progn ;; DraftSight: 移除加密狗 WHILE 迴圈(setq ppss sspp)
   (setvar "CMDECHO" 0)
   (setq oldosmode (getvar "osmode"))
   (setq curlayer (getvar "clayer"))
   (setq curcolor (getvar "cecolor"))
   (setq curltype (getvar "celtype"))
   (setq la (tblsearch "layer" sys_proj_layer))
   (if (= la nil) (command "layer" "n" sys_proj_layer "c" sys_proj_layercol sys_proj_layer ""))
   (setq flag 1)
   (cond
     ((= typ 0) (setq p (getpoint "\n選擇水平投影點: ")) (SETQ WW P))
     ((= typ 1) (setq p (getpoint "\n選擇垂直投影點: ")))
     ((= typ 2) (setq p (getpoint "\n選擇十字投影點: ")))
     ((or (= typ 3)(= typ 4)(= typ 5)(= typ 6)) (setq p (getpoint "\n選擇投影點: ")))
     ((= TYP 7)
         (initget "T")
         (setq dist (getdist "\n通過 T/<偏移距離>: "))
         (if (= "T" dist)
           (progn
              (setq ent (entsel "\n選擇投影的參考基準線: "))
              (setq p (getpoint "\n通過點: "))
           );progn
           (progn
              (setq ent (entsel "\n選擇參考基準線: "))
              (setq p (getpoint "\n在哪一側做偏移投影: "))
           );progn
         ))
   )
   (command "linetype" "s" "bylayer" "" "color" "bylayer" "layer" "s" sys_proj_layer "")
   (command "linetype" "s" "continuous" "")
   (setvar "osmode" 0)
   (cond
     ((= typ 0) (command "xline" "h" p ""))
     ((= typ 1) (command "xline" "v" p ""))
     ((= typ 2) (command "xline" "h" p "")(command "xline" "v" p ""))
     ((= typ 3) (command "xline" "a" (* 180.0 (/ ang pi)) p ""))
     ((= typ 4) (command "xline" "a" "r" ent "0" p ""))
     ((= typ 5) (command "xline" "a" "r" ent "90" p ""))
     ((= typ 6) (command "xline" "a" "r" ent ang p ""))
     ((= typ 7) (if (= "T" dist) (command "xline" "o" "t" ent p "")
                                 (command "xline" "o" dist ent p "")))
   )
   (setvar "osmode" oldosmode)
   (if (minusp (cdr(assoc 62 (tblsearch "layer" curlayer))))
       (command "layer" "s" curlayer "off" curlayer "y" "")
       (command "layer" "s" curlayer "")
   );if
   (command "linetype" "s" curltype "")

;  (if (= curcolor "BYLAYER") (command "color" "") (command "color" (atoi curcolor)))
;  (if (= curcolor "BYLAYER") (command "color" "") (command "color" (atoi curcolor)))
   (cond
     ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
     ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
     (T (command "color" (atoi curcolor)))
   )
   (while (= flag 1)
      (setq rp nil)
      (initget "Undo")
      (cond
        ((= typ 0) (setq rp p p (getpoint "\n或輸入U消除上一條投影線/<選擇水平投影點>: ")))
        ((= typ 1) (setq rp p p (getpoint "\n或輸入U消除上一條投影線/<選擇垂直投影點>: ")))
        ((= typ 2) (setq rp p p (getpoint "\n或輸入U消除上一條投影線/<選擇十字投影點>: ")))
        ((or (= typ 3)(= typ 4)(= typ 5)(= typ 6))
           (setq rp p p (getpoint "\n或輸入U消除上一條投影線/<選擇投影點>: ")))
        ((= TYP 7)
            (if (= "T" dist)
              (progn
                 (setq ent (entsel "\n選擇投影的參考基準線: "))
                 (if (null ent)
                    (setq p nil)
                    (setq p (getpoint "\n通過點: "))
                 )
              );progn
              (progn
                 (setq ent (entsel "\n選擇參考基準線: "))
                 (if (null ent)
                    (setq p nil)
                    (setq p (getpoint "\n在哪一側做偏移投影: "))
                 )
              )
            ))
      )
      (if (= p "Undo")
         (progn
            (if (/= 2 typ) (entdel (entlast))
              (progn
                (entdel (entlast))
                (entdel (entlast))
              )
            )
            (setq yyu 1)
            (initget "Redo")
            (cond
              ((= typ 0) (setq p (getpoint "\n或輸入R救回投影線/<選擇水平投影點: >")))
              ((= typ 1) (setq p (getpoint "\n或輸入R救回投影線/<選擇垂直投影點: >")))
              ((= typ 2) (setq p (getpoint "\n或輸入R救回投影線/<選擇十字投影點: >")))
              ((or (= typ 3)(= typ 4)(= typ 5)(= typ 6)) (setq p (getpoint "\n或輸入R救回投影線/<選擇投影點: >")))
              ((= TYP 7)
                  (initget "T")
                  (setq dist (getdist "\n通過 T/<偏移距離>: "))
                  (if (= "T" dist)
                    (progn
                       (setq ent (entsel "\n選擇投影的參考基準線: "))
                       (if (null ent)
                          (setq p nil)
                          (setq p (getpoint "\n通過點: "))
                       )
                    );progn
                    (progn
                       (setq ent (entsel "\n選擇參考基準線: "))
                       (if (null ent)
                          (setq p nil)
                          (setq p (getpoint "\n在哪一側做偏移投影: "))
                       )
                    );progn
                  ))
            );cond
         );progn
      );if
      (if (or (/= p nil) (= p "Undo") (= p "Redo"))
         (progn
           (if (= p "Redo")(setq p rp))
           (command "layer" "s" sys_proj_layer "")
           (command "color" "bylayer")
           (command "linetype" "s" "continuous" "")
           (setvar "osmode" 0)
           (cond
             ((= typ 0) (command "xline" "h" p ""))
             ((= typ 1) (command "xline" "v" p ""))
             ((= typ 2) (command "xline" "h" p "")(command "xline" "v" p ""))
             ((= typ 3) (command "xline" "a" (* 180.0 (/ ang pi)) p ""))
             ((= typ 4) (command "xline" "a" "r" ent "0" p ""))
             ((= typ 5) (command "xline" "a" "r" ent "90" p ""))
             ((= typ 6) (command "xline" "a" "r" ent ang p "")(princ "a"))
             ((= typ 7) (if (= "T" dist) (command "xline" "o" "t" ent p "")
                                         (command "xline" "o" dist ent p "")))
           );cond
           (setvar "osmode" oldosmode)
           (if (minusp (cdr(assoc 62 (tblsearch "layer" curlayer))))
               (command "layer" "s" curlayer "off" curlayer "y" "")
               (command "layer" "s" curlayer "")
           );if
          (command "linetype" "s" curltype "")

;         (if (= curcolor "BYLAYER") (command "color" "") (command "color" (atoi curcolor)))
          (cond
            ((= curcolor "BYBLOCK") (command "color" "BYBLOCK"))
            ((= curcolor "BYLAYER") (command "color" "BYLAYER"))
            (T (command "color" (atoi curcolor)))
          )

         );progn
         (setq flag 0)
      )
   )
   (setvar "CMDECHO" 1)
  (SETQ FFF nil))
   (princ)
)


;;消除投影線      delproj
;(defun c:delproj()
;   (setq projline (ssget "x" (list (cons 8 sys_proj_layer))))
;   (if projline (command "erase" projline ""))
;   (princ)
;)
(defun c:delproj()
   (setq projline (ssget "x" (list (cons 0 "XLINE"))))
   (if projline (command "erase" projline ""))
   (princ)
)

