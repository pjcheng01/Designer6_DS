;;;
;;軸用Ｃ型扣環標註
;;孔用Ｃ型扣環標註
;;Ｅ型扣環標註
;功能說明:軸用Ｃ型扣環標註
;;=============================================================================================
;日期:85,08,19
;相關檔案:cringdim.dcl,cringdim.doc,cringdim.sld
;版本:
;公司:POWERSOFT
  (defun c:cringdim()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
    (setvar "cmdecho" 0)
    (setq dcl_id (load_dialog (strcat powdesign_dcl_path "auxdraw.dcl")))
    (if (< dcl_id 0)(exit))
    (if (not (new_dialog "cringdim" dcl_id ""))(exit))

    (setq dtp 0 dtm 0 mtp 0 mtm 0)
    (setq flag 0)
    (setq nn nil)
    (show_sld "cring" (strcat powdesign_sld_path "cringdim"))
    (set_tile "cring2" "1")
    (set_list)
    (action_tile "list" "(set_name $value)")
    (action_tile "accept" "(cringok)")
    (action_tile "cancel" "(done_dialog)(setq flag 0)")
    (start_dialog)
    (if (= flag 1)
     (progn
       (setvar "cmdecho" 1)
       (cond ((= cring2 1) (command "dim" "dimtol" "on" "hor" pause pause pause "" "dimtol" "off" "e"))
             ((= cring3 1) (command "dim" "dimtol" "on" "ver" pause pause pause """dimtol" "off" "e"))
       )
     )

    )
    (unload_dialog dcl_id)
   (SETQ FFF nil))
    );end



    (defun cringok()
    (setq flag 1)
    (setq cring2 (atoi (get_tile "cring2")))
    (setq cring3 (atoi (get_tile "cring3")))
     (if (= cring2 1)
      (progn
       (setvar "dimtp" mtp)
       (setvar "dimtm" mtm)
      )
     )
     (if (= cring3 1)
      (progn
       (setvar "dimtp" dtp)
       (setvar "dimtm" dtm)
      )
     )

      (if (= nn nil)
          (set_tile "error" "請選擇軸徑")
          (done_dialog)
      )
    )


    (defun set_list()
      (setq ff (open (strcat powdesign_data_path "cringdim.doc") "r"))
      (setq c_list'())
      (setq data (read-line ff))
      (setq data (read-line ff))
       (while (/= data nil)
         (setq data1 (read data))
         (setq data2 (nth 0 data1))
         (setq c_list (cons data2 c_list))
         (setq data (read-line ff))
        )
      (close ff)
      (setq c_list (reverse c_list))
      (start_list "list")
      (mapcar 'add_list c_list)
      (end_list)
     )

     (defun set_name(value)
       (setq nn (atoi value))
       (setq rr (open (strcat powdesign_data_path "cringdim.doc") "r"))
        (repeat (+ 2 nn)
         (setq da (read-line rr))
        )
      (setq da (read da))
      (setq d1 (atof (nth 0 da)))
      (setq dtp (atof (nth 1 da)))
      (setq dtm (atof (nth 2 da)))
      (setq mtp (atof (nth 3 da)))
      (setq mtm (atof (nth 4 da)))
      (close rr)
     )


     (defun show_sld(key sld)
      (setq x (dimx_tile key))
      (setq y (dimy_tile key))
      (start_image key)
      (fill_image 0 0 x y -2)
      (slide_image 0 0 x y sld)
      (end_image)
     )

;==============================================================================
;功能說明:孔用Ｃ型扣環標註
;日期:85,08,19
;相關檔案:dringdim.dcl,dringdim.doc,dringdim.sld
;版本:
;公司:POWERSOFT
  (defun c:dringdim()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
    (setvar "cmdecho" 0)
    (setq dcl_id (load_dialog (strcat powdesign_dcl_path "auxdraw.dcl")))
    (if (< dcl_id 0)(exit))
    (if (not (new_dialog "dringdim" dcl_id ""))(exit))

    (setq dtp 0 dtm 0 mtp 0 mtm 0)
    (setq flag 0)
    (setq nn nil)
    (show_sld "dring" (strcat powdesign_sld_path "dringdim"))
    (set_tile "dring2" "1")
    (set_list)
    (action_tile "list" "(set_name $value)")
    (action_tile "accept" "(dringok)")
    (action_tile "cancel" "(done_dialog)(setq flag 0)")
    (start_dialog)
    (if (= flag 1)
     (progn
       (setvar "cmdecho" 1)
       (cond ((= dring2 1) (command "dim" "dimtol" "on" "hor" pause pause pause "" "dimtol" "off" "e"))
             ((= dring3 1) (command "dim" "dimtol" "on" "ver" pause pause pause """dimtol" "off" "e"))
       )
     )

    )
    (unload_dialog dcl_id)
   (SETQ FFF nil))
    );end

    (defun dringok()
    (setq flag 1)
    (setq dring2 (atoi (get_tile "dring2")))
    (setq dring3 (atoi (get_tile "dring3")))
     (if (= dring2 1)
      (progn
       (setvar "dimtp" mtp)
       (setvar "dimtm" mtm)
      )
     )
     (if (= dring3 1)
      (progn
       (setvar "dimtp" dtp)
       (setvar "dimtm" dtm)
      )
     )

      (if (= nn nil)
          (set_tile "error" "請選擇軸徑")
          (done_dialog)
      )
    )


    (defun set_list()
      (setq ff (open (strcat powdesign_data_path "dringdim.doc") "r"))
      (setq c_list'())
      (setq data (read-line ff))
      (setq data (read-line ff))
       (while (/= data nil)
         (setq data1 (read data))
         (setq data2 (nth 0 data1))
         (setq c_list (cons data2 c_list))
         (setq data (read-line ff))
        )
      (close ff)
      (setq c_list (reverse c_list))
      (start_list "list")
      (mapcar 'add_list c_list)
      (end_list)
     )

     (defun set_name(value)
       (setq nn (atoi value))
      (setq rr (open (strcat powdesign_data_path "dringdim.doc") "r"))
        (repeat (+ 2 nn)
         (setq da (read-line rr))
        )
      (setq da (read da))
      (setq d1 (atof (nth 0 da)))
      (setq dtp (atof (nth 1 da)))
      (setq dtm (atof (nth 2 da)))
      (setq mtp (atof (nth 3 da)))
      (setq mtm (atof (nth 4 da)))
      (close rr)
     )


     (defun show_sld(key sld)
      (setq x (dimx_tile key))
      (setq y (dimy_tile key))
      (start_image key)
      (fill_image 0 0 x y -2)
      (slide_image 0 0 x y sld)
      (end_image)
     )

;==============================================================================
;功能說明:Ｅ型扣環標註
;日期:85,08,19
;相關檔案:eringdim.dcl,eringdim.doc,eringdim.sld
;版本:
;公司:POWERSOFT
  (defun c:eringdim()
   (if (and (= jin "#$%")(= #### 85))(setq FFF t))(WHILE (/= FFF nil)(setq ppss sspp)
    (setvar "cmdecho" 0)
    (setq dcl_id (load_dialog (strcat powdesign_dcl_path "auxdraw.dcl")))
    (if (< dcl_id 0)(exit))
    (if (not (new_dialog "eringdim" dcl_id ""))(exit))

    (setq dtp 0 dtm 0 mtp 0 mtm 0)
    (setq flag 0)
    (setq nn nil)
    (show_sld "ering" (strcat powdesign_dcl_path "eringdim"))
    (set_tile "ering2" "1")
    (set_list)
    (action_tile "list" "(set_name $value)")
    (action_tile "accept" "(eringok)")
    (action_tile "cancel" "(done_dialog)(setq flag 0)")
    (start_dialog)
    (if (= flag 1)
     (progn
       (setvar "cmdecho" 1)
       (cond ((= ering2 1) (command "dim" "dimtol" "on" "hor" pause pause pause "" "dimtol" "off" "e"))
             ((= ering3 1) (command "dim" "dimtol" "on" "ver" pause pause pause """dimtol" "off" "e"))
       )
     )

    )
    (unload_dialog dcl_id)
   (SETQ FFF nil))
    );end



    (defun eringok()
    (setq flag 1)
    (setq ering2 (atoi (get_tile "ering2")))
    (setq ering3 (atoi (get_tile "ering3")))
     (if (= ering2 1)
      (progn
       (setvar "dimtp" mtp)
       (setvar "dimtm" mtm)
      )
     )
     (if (= ering3 1)
      (progn
       (setvar "dimtp" dtp)
       (setvar "dimtm" dtm)
      )
     )

      (if (= nn nil)
          (set_tile "error" "請選擇軸徑")
          (done_dialog)
      )
    )


    (defun set_list()
      (setq ff (open (strcat powdesign_data_path "eringdim.doc") "r"))
      (setq c_list'())
      (setq data (read-line ff))
      (setq data (read-line ff))
       (while (/= data nil)
         (setq data1 (read data))
         (setq data2 (nth 0 data1))
         (setq c_list (cons data2 c_list))
         (setq data (read-line ff))
        )
      (close ff)
      (setq c_list (reverse c_list))
      (start_list "list")
      (mapcar 'add_list c_list)
      (end_list)
     )

     (defun set_name(value)
       (setq nn (atoi value))
       (setq rr (open (strcat powdesign_data_path "eringdim.doc") "r"))
        (repeat (+ 2 nn)
         (setq da (read-line rr))
        )
      (setq da (read da))
      (setq d1 (atof (nth 0 da)))
      (setq dtp (atof (nth 1 da)))
      (setq dtm (atof (nth 2 da)))
      (setq mtp (atof (nth 3 da)))
      (setq mtm (atof (nth 4 da)))
      (close rr)
     )


     (defun show_sld(key sld)
      (setq x (dimx_tile key))
      (setq y (dimy_tile key))
      (start_image key)
      (fill_image 0 0 x y -2)
      (slide_image 0 0 x y sld)
      (end_image)
     )
