;;;
;;;凱柏連結晶英 ERP 系統 pdmbom3
(defun c:cap_sybom( / qq bomball_grp partdata count balllist num ff fname rf tittxt title_list
                     qty ent data8 qf data bomdata outtxt tag txt num outf)
  (load "manapart")
  (setq typ 1)
  (if (findfile (strcat POWdesign_path "atitle.txt"))
    (progn
      (setq needlayer (coll_all_layer))  ;; 選擇所有圖層,並過濾不建立資訊點的圖層
      (foreach nn needlayer
        (progn
          (setq ggg (ssget "x" (list (cons 8 nn))))
          (if (null ggg) (setq needlayer (removelist nn needlayer)))
        );progn
      );foreach
      (setq bomball_grp (ssget "x" (list (cons 0 "INSERT") (cons 2 "PARTREF"))))  ;;取所有資訊點
      (setq partdata (read (getfile_val (strcat POWdesign_path "SYSTEM.ini") "零件定義資料")))
      (setq count 0 balllist '() num 1)

      (cond
       ((or (= typ 2)(= typ 0)(= typ 3))(setq ff (open (strcat  POWDESIGN_path "bom.out") "w")))
       ((= typ 1)
        ;(setq fname (getstring "\n檔名: "))
        ;(setq ff (open (strcat  fname ".xls") "w")))
        (setq ff (open (strcat  powdesign_path "pdmbom3.txt") "w")))
      )

      (setq rf (open (strcat  POWDESIGN_path "atitle.txt") "r"))
      (setq tittxt (read-line rf))                               ;;tittxt 層名;品名;材質;圖號;製圖;說明;數量;表面處理;機種;規格;英文品名
      (close rf)                                                 ;; 寫出本組合圖名

;;;======================================================================================================
;;;取出[檔號]與 [組立圖料號]
      (setq str_filename(curdwgname)) ;取出[檔號]
      (setq str_attdef "DWGNO")   ;;[組立圖料號]
      (setq str_assmatno "") ;;[組立圖料號]
      (setq set_blk (ssget "x" '((0 . "INSERT")(-3 ("SHEETFLAG")))))
      (if set_blk (progn
	(setq ent_obj (ssname set_blk 0))
	(setq int_i 0)
	(repeat 10
	  	(setq ent_obj (entnext ent_obj))
	  	(if (= "ATTRIB" (cdr (assoc 0 (entget ent_obj))))(progn
		    (setq str_attrib (cdr (assoc 2 (entget ent_obj))))
	  	    (if (= str_attdef str_attrib)(setq str_assmatno (cdr (assoc 1 (entget ent_obj)))))
		))
	)
      ))
;;;======================================================================================================
;;;寫出 title至pdmbom3.txt
      (write-line (strcat "檔號;組立圖料號;" tittxt) ff)

      (setq title_list (TXT_TRAN_LIST tittxt))                   ;;title_list ("層名" "品名" "材質" ...)
      (if (or (= typ 2)(= typ 0)(= typ 3))(write-line (curdwgname) ff))

      (if (/= nil bomball_grp)
        (progn
          (setq qty (sslength bomball_grp))

          (repeat qty
            (setq ent (ssname bomball_grp count))
            (setq data8 (cdr (assoc 8 (entget ent))))
            (if (member data8 needlayer)
                (setq needlayer (removelist data8 needlayer))     ;;needlayer 沒有資訊點的零件圖層
            );if
;;寫出有資訊點的零件圖層
            (setq qf (open (strcat POWDESIGN_path "atitle.txt") "r"))
            (setq data (read-line qf))(close qf)
            (setq bomdata (reverse (get_bomdata ent)))
;;title_list ("層名" "品名" "材質" "#圖號" "製圖" "數量" "表面處理" "英文品名" "規格" "機種" "說明")
;;bomdata (("TAG3" "內六角承窩螺絲") ("TAG8" "") ("TAG13" "") ("TAG1" "") ("TAG2" "") ("TAG6" "") ("TAG7" "") ("TAG11" "") ("TAG12" "") ("TAG4" "") ("TAG5" "") ("TAG10" "8mm*20mm*P1.25") ("TAG9" "Screw.SKT.HD CAP") ("TAG14" "") ("TAG15" ""))
;;partdata (("組合件號" "" "TAG1") ("次組合名稱" "" "TAG2") ("品名" "PARTNAME" "TAG3") ("材質" "MATERIAL" "TAG4") ("#圖號" "DWGNO" "TAG5") ("製圖" "DRAWER" "TAG6") ("數量" "QTY" "TAG7") ("表面處理" "SURFACE" "TAG8") ("英文品名" "" "TAG9") ("規格" "" "TAG10") ("機種" "ITEM" "TAG11") ("說明" "" "TAG12"))
            (if (or (= typ 0)(= typ 2)(= typ 3))
                (progn
                      (if (assoc count subdata_list)                                     ;rex
                          (setq subid (nth 1 (assoc count subdata_list)))                ;rex
                          (setq subid "")                                                ;rex
                      )                                                                  ;rex
                      (if (/= "" subid)                                                  ;rex
                          (setq outtxt (strcat "1;" (rtos num 2) ";" subid ";" data8))   ;rex
                          (setq outtxt (strcat "1;" (rtos num 2) ";0;" data8))
                      )                                                                  ;rex
                );progn
                (setq outtxt data8)
            )
            (foreach nn (cdr title_list)
              (progn
                (setq tag (nth 2 (assoc nn partdata)))
                (setq txt (nth 1 (assoc tag bomdata)))
                (if (= "" txt)
                  (progn
                    (if(or(= typ 2)(= typ 3) (= typ 0))(setq txt "nil") (setq txt ""))
                  );progn
                );if
                (setq outtxt (strcat outtxt ";" txt))
              );progn
            );foreach

;;;======================================================================================================
;;;加入[檔號]與 [組立圖料號]
            (setq outtxt(strcat str_filename ";" str_assmatno ";" outtxt))
;;;======================================================================================================

            (write-line outtxt ff)


            (setq count (1+ count))
            (setq num (1+ num))
            (princ ".")
          );repeat
        );progn
      );if
    ;;needlayer沒有資訊點的零件圖層資料寫出               ;; outtxt 沒有資訊點的資料 0;5;0;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil
    (if (/= nil needlayer)
        (progn
             (foreach nn needlayer
                (progn
                     (if (or (= typ 0)(= typ 2)(= typ 3))                          ;; 0;5;0;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil;nil
                         (progn                                                    ;; │││ │
                              (setq outtxt (strcat "0;" (rtos num 2 ) ";0;" nn))   ;; │││ └─────  第 4 筆以後: 與 title_list 欄位對應的資料
                              (repeat (- (length title_list) 1)                    ;; ││└─────── 第 3 筆: 父系編號
                              (setq outtxt (strcat outtxt ";nil")))                ;; │└──────── 第 2 筆: 流水號
                         );progn                                                   ;; └───────── 第 1 筆: 0 ->沒資訊點(tree狀不顯示圖示)
                         (progn                                                    ;;                               1 ->有資訊點(tree狀顯示圖示)
                              (setq outtxt nn)
                              (repeat (length title_list)

                                    (setq outtxt (strcat outtxt ";"))

                              );repeat
                         );progn
                    );if
                    (setq num (1+ num))
;;;======================================================================================================
;;;加入[檔號]與 [組立圖料號]
                    (setq outtxt(strcat str_filename ";" str_assmatno ";" outtxt))
;;;======================================================================================================
                    ;;(write-line outtxt ff) ;;SAM
                    (princ ".")
               );progn
            );foreach
        );progn
     );if
     (close ff)
     (if (and (= 1 typ) (findfile (strcat  powdesign_path "pdmbom3.txt")))(progn
          (startapp (strcat  POWDESIGN_path "pdmbom3.exe"))
	  (if (null c:cad_to_pdm)(load "pdm-cad"))
	  (c:cad_to_pdm)
     ))
    );progn
    (progn
      (c:sortcol)
      (c:outbom_out)
    );progn
  );if
  (princ)
)
