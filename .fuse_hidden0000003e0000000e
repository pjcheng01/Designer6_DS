;;;
;╭════════════════════╮
;║設計日期: 1996.  .                      ║
;║更新日期:                               ║
;║設 計 者: 陳冠達                        ║
;║功能說明:                               ║
;║                                        ║
;║執行方式:                               ║
;║相關檔案: pub-dcl.dcl(word)             ║
;╰════════════════════╯
(defun editword(fname)
   ;; DraftSight: 移除加密狗 WHILE 迴圈
  (setvar "highlight" 0)
  (setvar "cmdecho" 0)
  (actdcl "pub-dcl" "word")

;顯示資料於 list_box 內
  (set_tile "filename" "檔案載入中,請稍後...")
  (act_list fname)

  (set_tile "filename" (strcat "檔案名稱:" (strcase fname)))
  (mode_tile "add_col" 1)
  (mode_tile "up_data" 1)
  (mode_tile "del_data" 1)
  (mode_tile "edit_data" 1)
  (set_tile "error" "請先點選文件內容!!")


  (action_tile "add_col"  "(add_col)")
  (action_tile "up_data"  "(updata (get_tile \"edit_data\"))")
  (action_tile "del_data" "(del_col)")
  (action_tile "word_list" "(show_txt)")

  (action_tile "accept" "(done_dialog)")
  (start_dialog)
  (unload_dialog dcl_id)
  (setvar "cmdecho" 1)
   ;; removed FFF
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
  (mode_tile "add_col" 0)
  (mode_tile "up_data" 0)
  (mode_tile "del_data" 0)
  (mode_tile "edit_data" 0)
  (set_tile "error" "")
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
        (unload_dialog dcl_id)
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
        (unload_dialog dcl_id)
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

(defun c:edword()
  (setq bb (getfiled "請選擇要編輯的檔名" "" "" 2))
  (if aa
    (editword bb)
  )
  (princ)
)
