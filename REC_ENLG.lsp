;;;
;;;局部詳圖
; MODES
; System variable save
(defun modes_recenlg(a)
   (setq MLST nil)
   (repeat (length a)
      (setq MLST (append MLST (list (list (car a) (getvar (car a))))))
      (setq a (cdr a)) ) )
;--------------------------------------
; System variable restore
(defun moder_recenlg()
   (repeat (length MLST)
      (setvar (caar MLST) (cadar MLST))
      (setq MLST (cdr MLST)) ) )
;--------------------------------------
; Delta x y
(defun dxy_recenlg(p dx dy)
  (list
     (+ dx (car p))
     (+ dy (cadr p)) ) )
;--------------------------------------
; Item from association list
(defun item_recenlg(n alist)
  (cdr (assoc n alist) ) )
;--------------------------------------
; midpoint_recenlg between two points
(defun midpoint_recenlg(p1 p2)
  (mapcar
      '(lambda (x1 x2)
               (* 0.5 (+ x1 x2)))
       p1 p2) )
;--------------------------------------
; TRIM entities on points outside boundary
(defun trim1_recenlg(ename p)
   (setq fuzz 1E-6)
   (if (not
          (and
             (<= (- x0 fuzz) (car p)  (+ x2 fuzz))
             (<= (- y0 fuzz) (cadr p) (+ y2 fuzz))))
       (progn
         (command (list ename p))
         T) ) )
;--------------------------------------
; TRIM ARC IFF quadrant point is on arc
(defun trimarc_recenlg(ename cen rad sa ea quad)
   (if (or
          (<= sa quad ea)
          (<= sa (+ quad d360) ea) )
        (trim1_recenlg ename (polar cen quad rad)) ) )
;--------------------------------------
; Crossing Selection
(defun sscross_recenlg(p0 p2 / ss1 ss2)
      (setq
         ss1 (ssget "c" p0 p2)
         ss2 (ssget "w" p0 p2) )
      (if (/= (sslength ss1) (sslength ss2))
         (progn
            (command "select" ss1 "r" ss2 "")
            (setq
               ss1 nil
               ss2 nil )
            (ssget "p") ) ) )
;--------------------------------------
; Identify entities
(defun id_recenlg(ent / ename etype)
   (setq
      ename (item_recenlg -1 ent)
      etype (item_recenlg 0 ent)
   )
   (if (= etype "ARC")
      (list ename etype (item_recenlg 50 ent) (item_recenlg 51 ent)) ; sa & ea
      (list ename etype)
   )
)
;--------------------------------------
;;;
(defun c:rec_enLg  ( / ss1 ss2 aa polyent p1 p3 scl d0 d180)
  ;; 已移除加密狗判斷(progn ;; DraftSight: 移除加密狗 WHILE 迴圈(setq ppss sspp)
  ---------- Internal error handler
      (defun myerror ()
         (if (/= S "Function cancelled")
            (princ (strcat "\nError: " s)) )
         (command)
         (moder_recenlg)
         (setq *error* olderr)
         (princ) )
; ---------- Initialize
   (setq
      olderr   *error*
      *error*  myerror
      d0   0.0
      d90  (* 0.5 pi)
      d180 pi
      d270 (* 1.5 pi)
      d360 (* 2.0 pi) )
   (modes_recenlg '("CMDECHO" "HIGHLIGHT" "BLIPMODE" "OSMODE" "PLINETYPE"))
   (setvar "cmdecho" 1)
   (setvar "blipmode" 0)
   (setvar "osmode" 0)
   (setvar "plinetype" 0)
   (setq hm (getvar "highlight"))
   (command "undo" "mark")
   (command "layer" "set" "0" "on" "0" "")
   ; ---------- get clip box
   (princ "\n截取詳圖:")
   (setq
      p0  (getpoint "\n第一角點: ")
      ok  p0 )
   (if ok
     (progn
       (initget (+ 1 32)) ; disallow nulls, draw crossing box

       (setq
          p2  (getcorner p0 "\n另一角點: ")
          p1  (list (car p2) (cadr p0))
          p3  (list (car p0) (cadr p2)) )
       (mem_curset)(c:&pl&)
       (command "rectang" p0 p2)
       (rt_to_old_set)
       (if (setq ss1 (ssget "c" p0 p2))
          (setq ok T)
          (progn
             (setq ok nil)
             (princ "\n沒有物件被選到!") ) ) )  )
   (if ok
     (progn
       ; ---------- draw clip box
       (setq midp (midpoint_recenlg p0 p2))
       (mem_curset)
       (c:&pl&)
       (command "pline" p0 "w" 0 0 p1 p2 p3 "c")
       (rt_to_old_set)
       (setq polyent (entlast))
       ;
       ; ---------- mark the last entity in the drawing
       (command "point" "0,0")
       (setq lastent (entlast))
       (entdel lastent)
       ;
       ; ----------- move the clip to one side
       (setq osna (getvar "orthomode"))
       (setvar "orthomode" 0)
       (princ "\n詳圖位置: ")
       (command "move" polyent "" midp pause)
       (setq newpnt (getvar "lastpoint"))
       (while (equal newpnt midp)
         (command "undo" "1")
         (princ "\n詳圖位置: ")
         (command "move" polyent "" midp pause)
         (setq newpnt (getvar "lastpoint"))
       )
       (setvar "highlight" 0)
       (command "copy" ss1 "" midp newpnt)
       (setvar "highlight" hm)
       ;
       ; ----------- get the new clip boundaries
       (setq
          ename (entnext polyent)
          p0    (item_recenlg 10 (entget ename))
          ename (entnext (entnext ename))
          p2    (item_recenlg 10 (entget ename))
          x0    (car p0)
          x2    (car p2)
          y0    (cadr p0)
          y2    (cadr p2)
          lim   (+ 1 (fix (abs (- y2 y0)))))
       (if (< x2 x0)
         (setq
            x0  (car p2)
            x2  (car p0) ) )
       (if (< y2 y0)
         (setq
           y0 (cadr p2)
           y2 (cadr p0) ) )
       ; ---------- explode everything we can, gather what we can't
       (setq
          ename lastent
          ss2   (ssadd) )
       (princ "\n資料處理中......")
       (while (setq ename (entnext ename))
          (setq
             ent (entget ename)
             etype (item_recenlg 0 ent) )
          (if (= hm 1) (redraw ename 3)) ; highlight entity
          (cond
             ((= etype "INSERT")
              (if (and (equal (item_recenlg 41 ent) (item_recenlg 42 ent))
                       (equal (item_recenlg 41 ent) (item_recenlg 43 ent)))
                  (command "explode" ename)
                 (ssadd ename ss2) ) )
              ((member etype '("POLYLINE" "LWPOLYLINE" "DIMENSION" "INSERT"))
               (command "explode" ename) )
             ((ssadd ename ss2) ) ) )
       ; ---------- remove everything outside the clip box
       (setq
         ss1 (ssget "c" p0 p2))
       (command "erase" ss2 "r" ss1 "")) )
   ; ---------- do the trimming
   (setq trimmed nil) ; list of trimmed circles, arcs
   (while ok
      ; ---------- form a selection set of objects
      ;            crossing the border
      (setq
         ok  nil
         i   0
         ss1 (sscross_recenlg p0 p2)
         l   (if ss1
                (sslength ss1)
                0 ) )
      ; ---------- trim each entity crossing the border
                    (setq hh 1)
      (if (> l 0)
         (command "trim" polyent "")  )
      (while (< i l)
         (setq
            ename (ssname ss1 i)
            ent   (entget ename)
            etype (item_recenlg 0 ent) )
         (if (not (member (id_recenlg ent) trimmed)) ; if we trimmed this exact entity
             (progn                          ;  don't trim it again
                (setq trimmed (cons (id_recenlg ent) trimmed))
                (cond
                   ((= etype "LINE") ; trim endpoints
                    (trim1_recenlg ename (item_recenlg 10 ent))
                    (trim1_recenlg ename (item_recenlg 11 ent)) )
                   ((= etype "CIRCLE")
                    (setq hhj 3)
                    (setq
                       cen (item_recenlg 10 ent)
                       rad (item_recenlg 40 ent)
                       ok  T )
                    (cond ; trim first quadrant outside border
                     ( (trim1_recenlg ename (dxy_recenlg cen rad     0.0   ))   )
                     ( (trim1_recenlg ename (dxy_recenlg cen 0.0     rad   ))   )
                     ( (trim1_recenlg ename (dxy_recenlg cen (- rad) 0.0   ))   )
                     ( (trim1_recenlg ename (dxy_recenlg cen 0.0     (- rad)))  )  ) )
                   ((= etype "ARC")
                    (setq
                       cen (item_recenlg 10 ent)
                       rad (item_recenlg 40 ent)
                       sa  (item_recenlg 50 ent)
                       ea  (item_recenlg 51 ent)
                       ok  T )
                    (if (> sa ea)
                       (setq ea (+ ea d360)) )
                    (cond ; trim first endpoint or quadrant outside border
                      ((trim1_recenlg ename (polar cen sa rad))       )
                      ((trim1_recenlg ename (polar cen ea rad))       )
                      ((trimarc_recenlg ename cen rad sa ea d0)      )
                      ((trimarc_recenlg ename cen rad sa ea d90)     )
                      ((trimarc_recenlg ename cen rad sa ea d180)    )
                      ((trimarc_recenlg ename cen rad sa ea d270)    ) ) ) ) ) )
         (setq i (1+ i)) )
      (if (> l 0) (command "")) )

   ; ---------- erase any lines, circles, or arcs we left behind
   (setq
      i   0
      ss1 (sscross_recenlg p0 p2)
      l   (if ss1
             (sslength ss1)
             0 ) )
   (while (< i l)
      (setq
         ename (ssname ss1 i)
         ent   (entget ename)
         etype (item_recenlg 0 ent) )
      (if (member etype '("LINE" "CIRCLE" "ARC"))
         (entdel ename) )
      (setq i (1+ i)) )
   (setvar "highlight" 1)
   ;----------------------------------------------------------
   (princ)
   (setq scl (getreal "\n比例 <1>:"))
   (if (= scl nil) (setq scl 1))
   ;(setq aa (getstring "\n邊界是否刪除<y>: "))
   (setq aa "N")
   (if (or (= aa "") (= aa "y") (= aa "Y"))
           (progn
            (entdel polyent)
            (command "scale" ss2 "" newpnt scl)
           )
            (command "scale" ss2 polyent "" newpnt scl))
   (setvar "orthomode" osna)
   ;----------------------------------------------------------
   (moder_recenlg)                            ; Restore saved modes
   (entdel ename)
   (setq *error* olderr)              ; Restore old *error* handler
  (SETQ FFF nil))
   (princ)
)
