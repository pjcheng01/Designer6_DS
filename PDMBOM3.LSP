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
      (setq partdata (read (getfile_val (strcat POWdesign_path "SYSTEM.ini") "PART_DEF")))
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
;;; 2026-09-10：移除兩個外送步驟，只保留匯出 pdmbom3.txt。
;;;
;;; 原本這裡在寫完檔案之後還做兩件事：
;;;   (startapp "pdmbom3.exe")          把資料送進晶英 ERP
;;;   (load "pdm-cad")(c:cad_to_pdm)    把圖框屬性寫進 POWERPDM
;;;
;;; 兩個目標系統在移植版都已不存在：
;;;   - 晶英 ERP 的資料庫已停用（同 campro，見手冊 §10.5）
;;;   - PDM 模組於移植時刻意移除（手冊 §6 已完成第 3 項）。pdm-cad.lsp
;;;     只剩 PDMSERVER\Autocad\ 底下的殘留，不在支援路徑上，
;;;     (load "pdm-cad") 必定失敗。就算載得到，c:cad_to_pdm 用的
;;;     powerpdm_attribdata_path 與 powerpdm_path 在 config.doc 裡
;;;     根本沒有設定，一樣會炸。
;;;
;;; 資料檔本身的產生是正確的，錯誤只發生在這兩個外送步驟。
;;; 現在改為印出檔案路徑，由使用者自行取用。
     (if (and (= 1 typ) (findfile (strcat  powdesign_path "pdmbom3.txt")))
         (princ (strcat "\n物料清單已匯出: " powdesign_path "pdmbom3.txt"))
     )
    );progn
    (progn
      ;; 2026-09-14：原本這裡是 (c:sortcol)(c:outbom_out)。
      ;; c:outbom_out 全專案沒有定義（詳見 MANAPART.lsp 的 bomtree 同一處註解）。
      ;;
      ;; ⚠ 這一處還有另一個問題：本函式檢查的是 **atitle.txt**，但
      ;; c:sortcol 寫出來的是 **title.txt**。而 atitle.txt **全專案只有讀、
      ;; 沒有任何程式會寫**（本檔第 7、28、67 行都是讀）。所以就算改成
      ;; 「設定完自動重跑」也永遠不會成立——atitle.txt 不會憑空出現。
      ;; 它必須手動建立，格式是一行、以分號分隔的欄位名，例如：
      ;;     層名;數量;組合件號;機種;英文品名
      (princ "\n找不到 atitle.txt，無法產生凱柏連結晶英 ERP 的物料清單。")
      (princ "\n這個檔案沒有任何程式會自動產生，需手動建立於 ")
      (princ POWdesign_path)
      (princ "\n格式為一行、以分號分隔的欄位名，例如：層名;數量;組合件號;機種;英文品名")
    );progn
  );if
  (princ)
)
