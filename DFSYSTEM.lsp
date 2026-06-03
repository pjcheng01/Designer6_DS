;;;
;;設定圖層系統變數
;;設定線型系統變數
;;材料清單欄寬定義
;;指標球定義
;;鎖點模式組
;;圖框日期型式
;;零件組合時預設之顏色
;;零件組合時刪除之圖層
;;零件組合時刪除之圖塊
;;自動拆圖時不拆之圖層
;;不建立資訊點的圖層
;;自動拆圖時不拆之圖塊
;;舊圖框屬性BLOCK名稱
;;比例變動時會連動的BLOCK
;;推拔系統管理
;;=============================================================================================
;;鎖點模式組
;;typ= 0 建立 osmode.ini
;;typ= 1 更新 osmode.ini
(defun wr_osmode_to_supp(typ)
   (setq prefix (getvar "dctcust"))
   (setq OUT_LSPPATH (substr PREFIX 1 (- (strlen prefix) 10)))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   (cond
     ((null (findfile osnapfile))
        (setq ff (open osnapfile "w"))
        (write-line "第一組鎖點模式=(\"1\" \"1\" \"1\" \"0\" \"1\" \"0\" \"0\" \"0\" \"0\" \"0\" \"0\" \"0\")" ff)
        (write-line "第二組鎖點模式=(\"0\" \"0\" \"0\" \"1\" \"1\" \"1\" \"0\" \"0\" \"0\" \"0\" \"0\" \"0\")" ff)
        (write-line "第三組鎖點模式=(\"0\" \"0\" \"0\" \"0\" \"0\" \"0\" \"1\" \"1\" \"1\" \"1\" \"0\" \"0\")" ff)
        (write-line "第四組鎖點模式=(\"1\" \"1\" \"1\" \"1\" \"0\" \"0\" \"1\" \"0\" \"0\" \"0\" \"0\" \"0\")" ff)
        (write-line "第五組鎖點模式=(\"0\" \"0\" \"0\" \"0\" \"0\" \"0\" \"0\" \"0\" \"1\" \"1\" \"1\" \"1\")" ff)
        (close ff)
      )
      ((= typ 1)
        (setq ff (open osnapfile "w"))
        (write-line outdata1 ff)
        (write-line outdata2 ff)
        (write-line outdata3 ff)
        (write-line outdata4 ff)
        (write-line outdata5 ff)
        (close ff)
      )
   );cond
);defun
(defun c:setosmode(/ osnapfile osnapfile prefix out_lsppath)
   (actdcl (strcat powdesign_dcl_path "system") "setosmode")
   (mode_tile "end6" 1)
   (mode_tile "mid6" 1)
   (mode_tile "int6" 1)
   (mode_tile "cen6" 1)
   (mode_tile "qua6" 1)
   (mode_tile "tan6" 1)
   (mode_tile "per6" 1)
   (mode_tile "nod6" 1)
   (mode_tile "ins6" 1)
   (mode_tile "nea6" 1)
   (mode_tile "app6" 1)
   (mode_tile "qui6" 1)

   (wr_osmode_to_supp 0) ;假如support 目錄下沒有個人化的 osmode.ini, 則自動建立該檔

 ; (setq list1 (read (getfile_val (strcat POWDESIGN_path "system.ini") "第一組鎖點模式")))
 ; (setq list2 (read (getfile_val (strcat POWDESIGN_path "system.ini") "第二組鎖點模式")))
 ; (setq list3 (read (getfile_val (strcat POWDESIGN_path "system.ini") "第三組鎖點模式")))
 ; (setq list4 (read (getfile_val (strcat POWDESIGN_path "system.ini") "第四組鎖點模式")))
 ; (setq list5 (read (getfile_val (strcat POWDESIGN_path "system.ini") "第五組鎖點模式")))

   (setq list1 (read (getfile_val osnapfile "第一組鎖點模式")))
   (setq list2 (read (getfile_val osnapfile "第二組鎖點模式")))
   (setq list3 (read (getfile_val osnapfile "第三組鎖點模式")))
   (setq list4 (read (getfile_val osnapfile "第四組鎖點模式")))
   (setq list5 (read (getfile_val osnapfile "第五組鎖點模式")))

   (set_tile "end1" (nth 0  list1)) (set_tile "end2" (nth 0  list2)) (set_tile "end3" (nth 0  list3)) (set_tile "end4" (nth 0  list4)) (set_tile "end5" (nth 0  list5))
   (set_tile "mid1" (nth 1  list1)) (set_tile "mid2" (nth 1  list2)) (set_tile "mid3" (nth 1  list3)) (set_tile "mid4" (nth 1  list4)) (set_tile "mid5" (nth 1  list5))
   (set_tile "int1" (nth 2  list1)) (set_tile "int2" (nth 2  list2)) (set_tile "int3" (nth 2  list3)) (set_tile "int4" (nth 2  list4)) (set_tile "int5" (nth 2  list5))
   (set_tile "cen1" (nth 3  list1)) (set_tile "cen2" (nth 3  list2)) (set_tile "cen3" (nth 3  list3)) (set_tile "cen4" (nth 3  list4)) (set_tile "cen5" (nth 3  list5))
   (set_tile "qua1" (nth 4  list1)) (set_tile "qua2" (nth 4  list2)) (set_tile "qua3" (nth 4  list3)) (set_tile "qua4" (nth 4  list4)) (set_tile "qua5" (nth 4  list5))
   (set_tile "tan1" (nth 5  list1)) (set_tile "tan2" (nth 5  list2)) (set_tile "tan3" (nth 5  list3)) (set_tile "tan4" (nth 5  list4)) (set_tile "tan5" (nth 5  list5))
   (set_tile "per1" (nth 6  list1)) (set_tile "per2" (nth 6  list2)) (set_tile "per3" (nth 6  list3)) (set_tile "per4" (nth 6  list4)) (set_tile "per5" (nth 6  list5))
   (set_tile "nod1" (nth 7  list1)) (set_tile "nod2" (nth 7  list2)) (set_tile "nod3" (nth 7  list3)) (set_tile "nod4" (nth 7  list4)) (set_tile "nod5" (nth 7  list5))
   (set_tile "ins1" (nth 8  list1)) (set_tile "ins2" (nth 8  list2)) (set_tile "ins3" (nth 8  list3)) (set_tile "ins4" (nth 8  list4)) (set_tile "ins5" (nth 8  list5))
   (set_tile "nea1" (nth 9  list1)) (set_tile "nea2" (nth 9  list2)) (set_tile "nea3" (nth 9  list3)) (set_tile "nea4" (nth 9  list4)) (set_tile "nea5" (nth 9  list5))
   (set_tile "app1" (nth 10 list1)) (set_tile "app2" (nth 10 list2)) (set_tile "app3" (nth 10 list3)) (set_tile "app4" (nth 10 list4)) (set_tile "app5" (nth 10 list5))
   (set_tile "qui1" (nth 11 list1)) (set_tile "qui2" (nth 11 list2)) (set_tile "qui3" (nth 11 list3)) (set_tile "qui4" (nth 11 list4)) (set_tile "qui5" (nth 11 list5))
   (setq curosmode (getvar "osmode"))
   (get_osmodeset)
   (cond
    ((= curosmode itemv1) (set_tile "item1" "1"))
    ((= curosmode itemv2) (set_tile "item2" "1"))
    ((= curosmode itemv3) (set_tile "item3" "1"))
    ((= curosmode itemv4) (set_tile "item4" "1"))
    ((= curosmode itemv5) (set_tile "item5" "1"))
    (T (set_tile "item6" "1"))

   )
   (action_tile "item6" "(set_tile \"item1\" \"0\")
                         (set_tile \"item2\" \"0\")
                         (set_tile \"item3\" \"0\")
                         (set_tile \"item4\" \"0\")
                         (set_tile \"item5\" \"0\")")

   (action_tile "item1" "(set_tile \"item6\" \"0\")")
   (action_tile "item2" "(set_tile \"item6\" \"0\")")
   (action_tile "item3" "(set_tile \"item6\" \"0\")")
   (action_tile "item4" "(set_tile \"item6\" \"0\")")
   (action_tile "item5" "(set_tile \"item6\" \"0\")")


   (action_tile "accept" "(get_osmodeset)(setosmode_ok)(done_dialog)")
   (action_tile "cancel" "(done_dialog)")

   (start_dialog)
   (setvar "cmdecho" 1)
   (setq list1 nil list2 nil list3 nil list4 nil list5 nil curosmode nil item1 nil item2 nil item3 nil item4 nil item5 nil itemv1 nil itemv2 nil itemv3 nil itemv4 nil itemv5 nil
                     end1 nil end2 nil end3 nil end4 nil end5 nil endv1 nil endv2 nil endv3 nil endv4 nil endv5 nil outitem1 nil
                     mid1 nil mid2 nil mid3 nil mid4 nil mid5 nil midv1 nil midv2 nil midv3 nil midv4 nil midv5 nil outitem2 nil
                     int1 nil int2 nil int3 nil int4 nil int5 nil intv1 nil intv2 nil intv3 nil intv4 nil intv5 nil outitem3 nil
                     cen1 nil cen2 nil cen3 nil cen4 nil cen5 nil cenv1 nil cenv2 nil cenv3 nil cenv4 nil cenv5 nil outitem4 nil
                     qua1 nil qua2 nil qua3 nil qua4 nil qua5 nil quav1 nil quav2 nil quav3 nil quav4 nil quav5 nil outitem5 nil
                     tan1 nil tan2 nil tan3 nil tan4 nil tan5 nil tanv1 nil tanv2 nil tanv3 nil tanv4 nil tanv5 nil outdata1 nil
                     per1 nil per2 nil per3 nil per4 nil per5 nil perv1 nil perv2 nil perv3 nil perv4 nil perv5 nil outdata2 nil
                     nod1 nil nod2 nil nod3 nil nod4 nil nod5 nil nodv1 nil nodv2 nil nodv3 nil nodv4 nil nodv5 nil outdata3 nil
                     ins1 nil ins2 nil ins3 nil ins4 nil ins5 nil insv1 nil insv2 nil insv3 nil insv4 nil insv5 nil outdata4 nil
                     nea1 nil nea2 nil nea3 nil nea4 nil nea5 nil neav1 nil neav2 nil neav3 nil neav4 nil neav5 nil outdata5 nil
                     app1 nil app2 nil app3 nil app4 nil app5 nil appv1 nil appv2 nil appv3 nil appv4 nil appv5 nil
                     qui1 nil qui2 nil qui3 nil qui4 nil qui5 nil quiv1 nil quiv2 nil quiv3 nil quiv4 nil quiv5 nil)
   (prin1)
)
(defun get_osmodeset()
   (setq end1 (get_tile "end1") end2 (get_tile "end2") end3 (get_tile "end3") end4 (get_tile "end4") end5 (get_tile "end5")
         mid1 (get_tile "mid1") mid2 (get_tile "mid2") mid3 (get_tile "mid3") mid4 (get_tile "mid4") mid5 (get_tile "mid5")
         int1 (get_tile "int1") int2 (get_tile "int2") int3 (get_tile "int3") int4 (get_tile "int4") int5 (get_tile "int5")
         cen1 (get_tile "cen1") cen2 (get_tile "cen2") cen3 (get_tile "cen3") cen4 (get_tile "cen4") cen5 (get_tile "cen5")
         qua1 (get_tile "qua1") qua2 (get_tile "qua2") qua3 (get_tile "qua3") qua4 (get_tile "qua4") qua5 (get_tile "qua5")
         tan1 (get_tile "tan1") tan2 (get_tile "tan2") tan3 (get_tile "tan3") tan4 (get_tile "tan4") tan5 (get_tile "tan5")
         per1 (get_tile "per1") per2 (get_tile "per2") per3 (get_tile "per3") per4 (get_tile "per4") per5 (get_tile "per5")
         nod1 (get_tile "nod1") nod2 (get_tile "nod2") nod3 (get_tile "nod3") nod4 (get_tile "nod4") nod5 (get_tile "nod5")
         ins1 (get_tile "ins1") ins2 (get_tile "ins2") ins3 (get_tile "ins3") ins4 (get_tile "ins4") ins5 (get_tile "ins5")
         nea1 (get_tile "nea1") nea2 (get_tile "nea2") nea3 (get_tile "nea3") nea4 (get_tile "nea4") nea5 (get_tile "nea5")
         app1 (get_tile "app1") app2 (get_tile "app2") app3 (get_tile "app3") app4 (get_tile "app4") app5 (get_tile "app5")
         qui1 (get_tile "qui1") qui2 (get_tile "qui2") qui3 (get_tile "qui3") qui4 (get_tile "qui4") qui5 (get_tile "qui5"))
   (setq item1 (get_tile "item1"))
   (setq item2 (get_tile "item2"))
   (setq item3 (get_tile "item3"))
   (setq item4 (get_tile "item4"))
   (setq item5 (get_tile "item5"))
   (setq item6 (get_tile "item6"))
   (if (= "0" end1) (setq endv1 0)  (setq endv1     1 )) (if (= "0" end2) (setq endv2 0)  (setq endv2     1 ))
   (if (= "0" mid1) (setq midv1 0)  (setq midv1     2 )) (if (= "0" mid2) (setq midv2 0)  (setq midv2     2 ))
   (if (= "0" int1) (setq intv1 0)  (setq intv1    32 )) (if (= "0" int2) (setq intv2 0)  (setq intv2    32 ))
   (if (= "0" cen1) (setq cenv1 0)  (setq cenv1     4 )) (if (= "0" cen2) (setq cenv2 0)  (setq cenv2     4 ))
   (if (= "0" qua1) (setq quav1 0)  (setq quav1    16 )) (if (= "0" qua2) (setq quav2 0)  (setq quav2    16 ))
   (if (= "0" tan1) (setq tanv1 0)  (setq tanv1   256 )) (if (= "0" tan2) (setq tanv2 0)  (setq tanv2   256 ))
   (if (= "0" per1) (setq perv1 0)  (setq perv1   128 )) (if (= "0" per2) (setq perv2 0)  (setq perv2   128 ))
   (if (= "0" nod1) (setq nodv1 0)  (setq nodv1     8 )) (if (= "0" nod2) (setq nodv2 0)  (setq nodv2     8 ))
   (if (= "0" ins1) (setq insv1 0)  (setq insv1    64 )) (if (= "0" ins2) (setq insv2 0)  (setq insv2    64 ))
   (if (= "0" nea1) (setq neav1 0)  (setq neav1   512 )) (if (= "0" nea2) (setq neav2 0)  (setq neav2   512 ))
   (if (= "0" app1) (setq appv1 0)  (setq appv1  2048 )) (if (= "0" app2) (setq appv2 0)  (setq appv2  2048 ))
   (if (= "0" qui1) (setq quiv1 0)  (setq quiv1  1024 )) (if (= "0" qui2) (setq quiv2 0)  (setq quiv2  1024 ))

   (if (= "0" end3) (setq endv3 0)  (setq endv3     1 )) (if (= "0" end4) (setq endv4 0)  (setq endv4     1 ))
   (if (= "0" mid3) (setq midv3 0)  (setq midv3     2 )) (if (= "0" mid4) (setq midv4 0)  (setq midv4     2 ))
   (if (= "0" int3) (setq intv3 0)  (setq intv3    32 )) (if (= "0" int4) (setq intv4 0)  (setq intv4    32 ))
   (if (= "0" cen3) (setq cenv3 0)  (setq cenv3     4 )) (if (= "0" cen4) (setq cenv4 0)  (setq cenv4     4 ))
   (if (= "0" qua3) (setq quav3 0)  (setq quav3    16 )) (if (= "0" qua4) (setq quav4 0)  (setq quav4    16 ))
   (if (= "0" tan3) (setq tanv3 0)  (setq tanv3   256 )) (if (= "0" tan4) (setq tanv4 0)  (setq tanv4   256 ))
   (if (= "0" per3) (setq perv3 0)  (setq perv3   128 )) (if (= "0" per4) (setq perv4 0)  (setq perv4   128 ))
   (if (= "0" nod3) (setq nodv3 0)  (setq nodv3     8 )) (if (= "0" nod4) (setq nodv4 0)  (setq nodv4     8 ))
   (if (= "0" ins3) (setq insv3 0)  (setq insv3    64 )) (if (= "0" ins4) (setq insv4 0)  (setq insv4    64 ))
   (if (= "0" nea3) (setq neav3 0)  (setq neav3   512 )) (if (= "0" nea4) (setq neav4 0)  (setq neav4   512 ))
   (if (= "0" app3) (setq appv3 0)  (setq appv3  2048 )) (if (= "0" app4) (setq appv4 0)  (setq appv4  2048 ))
   (if (= "0" qui3) (setq quiv3 0)  (setq quiv3  1024 )) (if (= "0" qui4) (setq quiv4 0)  (setq quiv4  1024 ))

   (if (= "0" end5) (setq endv5 0)  (setq endv5     1 ))
   (if (= "0" mid5) (setq midv5 0)  (setq midv5     2 ))
   (if (= "0" int5) (setq intv5 0)  (setq intv5    32 ))
   (if (= "0" cen5) (setq cenv5 0)  (setq cenv5     4 ))
   (if (= "0" qua5) (setq quav5 0)  (setq quav5    16 ))
   (if (= "0" tan5) (setq tanv5 0)  (setq tanv5   256 ))
   (if (= "0" per5) (setq perv5 0)  (setq perv5   128 ))
   (if (= "0" nod5) (setq nodv5 0)  (setq nodv5     8 ))
   (if (= "0" ins5) (setq insv5 0)  (setq insv5    64 ))
   (if (= "0" nea5) (setq neav5 0)  (setq neav5   512 ))
   (if (= "0" app5) (setq appv5 0)  (setq appv5  2048 ))
   (if (= "0" qui5) (setq quiv5 0)  (setq quiv5  1024 ))

   (setq outitem1 (list end1 mid1 int1 cen1 qua1 tan1 per1 nod1 ins1 nea1 app1 qui1))
   (setq outitem2 (list end2 mid2 int2 cen2 qua2 tan2 per2 nod2 ins2 nea2 app2 qui2))
   (setq outitem3 (list end3 mid3 int3 cen3 qua3 tan3 per3 nod3 ins3 nea3 app3 qui3))
   (setq outitem4 (list end4 mid4 int4 cen4 qua4 tan4 per4 nod4 ins4 nea4 app4 qui4))
   (setq outitem5 (list end5 mid5 int5 cen5 qua5 tan5 per5 nod5 ins5 nea5 app5 qui5))
   (setq itemv1 (+ endv1 midv1 intv1 cenv1 quav1 tanv1 perv1 nodv1 insv1 neav1 appv1 quiv1))
   (setq itemv2 (+ endv2 midv2 intv2 cenv2 quav2 tanv2 perv2 nodv2 insv2 neav2 appv2 quiv2))
   (setq aaaa (+ endv2 midv2 intv2 cenv2 quav2 tanv2 perv2 nodv2 insv2 neav2 appv2 quiv2))
   (setq itemv3 (+ endv3 midv3 intv3 cenv3 quav3 tanv3 perv3 nodv3 insv3 neav3 appv3 quiv3))
   (setq itemv4 (+ endv4 midv4 intv4 cenv4 quav4 tanv4 perv4 nodv4 insv4 neav4 appv4 quiv4))
   (setq itemv5 (+ endv5 midv5 intv5 cenv5 quav5 tanv5 perv5 nodv5 insv5 neav5 appv5 quiv5))
);defun
(defun setosmode_ok()
   (cond
     ((= "1" item1) (setvar "osmode" itemv1))
     ((= "1" item2) (setvar "osmode" itemv2))
     ((= "1" item3) (setvar "osmode" itemv3))
     ((= "1" item4) (setvar "osmode" itemv4))
     ((= "1" item5) (setvar "osmode" itemv5))
     ((= "1" item6) (setvar "osmode" 0))
   )
   (setq outdata1 (strcat "第一組鎖點模式=(\"" end1 "\" \""  mid1 "\" \"" int1 "\" \"" cen1 "\" \""
                                               qua1 "\" \""  tan1 "\" \"" per1 "\" \"" nod1 "\" \""
                                               ins1 "\" \""  nea1 "\" \"" app1 "\" \"" qui1 "\"" ")"))
   (setq outdata2 (strcat "第二組鎖點模式=(\"" end2 "\" \""  mid2 "\" \"" int2 "\" \"" cen2 "\" \""
                                               qua2 "\" \""  tan2 "\" \"" per2 "\" \"" nod2 "\" \""
                                               ins2 "\" \""  nea2 "\" \"" app2 "\" \"" qui2 "\"" ")"))
   (setq outdata3 (strcat "第三組鎖點模式=(\"" end3 "\" \""  mid3 "\" \"" int3 "\" \"" cen3 "\" \""
                                               qua3 "\" \""  tan3 "\" \"" per3 "\" \"" nod3 "\" \""
                                               ins3 "\" \""  nea3 "\" \"" app3 "\" \"" qui3 "\"" ")"))
   (setq outdata4 (strcat "第四組鎖點模式=(\"" end4 "\" \""  mid4 "\" \"" int4 "\" \"" cen4 "\" \""
                                               qua4 "\" \""  tan4 "\" \"" per4 "\" \"" nod4 "\" \""
                                               ins4 "\" \""  nea4 "\" \"" app4 "\" \"" qui4 "\"" ")"))
   (setq outdata5 (strcat "第五組鎖點模式=(\"" end5 "\" \""  mid5 "\" \"" int5 "\" \"" cen5 "\" \""
                                               qua5 "\" \""  tan5 "\" \"" per5 "\" \"" nod5 "\" \""
                                               ins5 "\" \""  nea5 "\" \"" app5 "\" \"" qui5 "\"" ")"))
 ; (file_update  "system.INI" "swapfile.txt" "第一組鎖點模式" "=" outdata1)
 ; (file_update  "system.INI" "swapfile.txt" "第二組鎖點模式" "=" outdata2)
 ; (file_update  "system.INI" "swapfile.txt" "第三組鎖點模式" "=" outdata3)
 ; (file_update  "system.INI" "swapfile.txt" "第四組鎖點模式" "=" outdata4)
 ; (file_update  "system.INI" "swapfile.txt" "第五組鎖點模式" "=" outdata5)
   (wr_osmode_to_supp 1)

)


;;設定圖層系統變數
;╭═════════════════════════════════════════════╮
;║設計日期: 1997.12. 9                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明: 設定圖層系統變數                                                                    ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: system.dcl(deflayer)                                                            ║
;╰═════════════════════════════════════════════╯
(defun c:deflayer()
 (setvar "cmdecho" 0)

 (actdcl (strcat powdesign_dcl_path "system") "deflayer")

 (deflayer_set_tile_smode)

 (action_tile "ltycol1" "(setq selcol_id 1)")
 (action_tile "ltycol2" "(setq selcol_id 2)")
 (action_tile "ltycol3" "(setq selcol_id 3)")
 (action_tile "ltycol4" "(setq selcol_id 4)")
 (action_tile "ltycol5" "(setq selcol_id 5)")
 (action_tile "ltycol6" "(setq selcol_id 6)")
 (action_tile "ltycol7" "(setq selcol_id 7)")
 (action_tile "ltycol8" "(setq selcol_id 8)")
 (action_tile "ltycol9" "(setq selcol_id 9)")
 (action_tile "ltycol10" "(setq selcol_id 10)")
 (action_tile "ltycol11" "(setq selcol_id 11)")
 (action_tile "ltycol12" "(setq selcol_id 12)")
 (action_tile "ltycol13" "(setq selcol_id 13)")
 (action_tile "ltycol14" "(setq selcol_id 14)")
 (action_tile "ltycol15" "(setq selcol_id 15)")
 (action_tile "ltycol16" "(setq selcol_id 16)")
 (action_tile "ltycol17" "(setq selcol_id 17)")
 (action_tile "ltycol18" "(setq selcol_id 18)")
 (action_tile "ltycol19" "(setq selcol_id 19)")
 (action_tile "ltycol20" "(setq selcol_id 20)")
 (if (= cad_version "INTELLICAD")
   (action_tile "selcol" "(ddsel_col (strcat \"ltycol\" (rtos selcol_id 2 2)))")
   (action_tile "selcol" "(ddsel_col (strcat \"ltycol\" (rtos selcol_id 2 0)))")
 )
; (action_tile "selcol" "(ddsel_col (strcat \"ltycol\" (rtos selcol_id 2 0)))")

 (action_tile "accept" "(deflayer_ok)(done_dialog)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (setvar "cmdecho" 1)
 (prin1)
)

(defun deflayer_ok()
  (if (/= "" (get_tile "label1" )) (setq label1  (get_tile "label1") ltype1  (get_tile "ltype1" )  ltycol1  (get_tile "ltycol1" )
                                         outtxt1  (strcat "(\"" label1  "\" \"" ltype1  "\" \"" ltycol1  "\")"))
                                   (setq outtxt1 ""))
  (if (/= "" (get_tile "label2" )) (setq label2  (get_tile "label2") ltype2  (get_tile "ltype2" )  ltycol2  (get_tile "ltycol2" )
                                         outtxt2  (strcat "(\"" label2  "\" \"" ltype2  "\" \"" ltycol2  "\")"))
                                   (setq outtxt2 ""))
  (if (/= "" (get_tile "label3" )) (setq label3  (get_tile "label3") ltype3  (get_tile "ltype3" )  ltycol3  (get_tile "ltycol3" )
                                         outtxt3  (strcat "(\"" label3  "\" \"" ltype3  "\" \"" ltycol3  "\")"))
                                   (setq outtxt3 ""))
  (if (/= "" (get_tile "label4" )) (setq label4  (get_tile "label4") ltype4  (get_tile "ltype4" )  ltycol4  (get_tile "ltycol4" )
                                         outtxt4  (strcat "(\"" label4  "\" \"" ltype4  "\" \"" ltycol4  "\")"))
                                   (setq outtxt4 ""))
  (if (/= "" (get_tile "label5" )) (setq label5  (get_tile "label5") ltype5  (get_tile "ltype5" )  ltycol5  (get_tile "ltycol5" )
                                         outtxt5  (strcat "(\"" label5  "\" \"" ltype5  "\" \"" ltycol5  "\")"))
                                   (setq outtxt5 ""))
  (if (/= "" (get_tile "label6" )) (setq label6  (get_tile "label6") ltype6  (get_tile "ltype6" )  ltycol6  (get_tile "ltycol6" )
                                         outtxt6  (strcat "(\"" label6  "\" \"" ltype6  "\" \"" ltycol6  "\")"))
                                   (setq outtxt6 ""))
  (if (/= "" (get_tile "label7" )) (setq label7  (get_tile "label7") ltype7  (get_tile "ltype7" )  ltycol7  (get_tile "ltycol7" )
                                         outtxt7  (strcat "(\"" label7  "\" \"" ltype7  "\" \"" ltycol7  "\")"))
                                   (setq outtxt7 ""))
  (if (/= "" (get_tile "label8" )) (setq label8  (get_tile "label8") ltype8  (get_tile "ltype8" )  ltycol8  (get_tile "ltycol8" )
                                         outtxt8  (strcat "(\"" label8  "\" \"" ltype8  "\" \"" ltycol8  "\")"))
                                   (setq outtxt8 ""))
  (if (/= "" (get_tile "label9" )) (setq label9  (get_tile "label9") ltype9  (get_tile "ltype9" )  ltycol9  (get_tile "ltycol9" )
                                         outtxt9  (strcat "(\"" label9  "\" \"" ltype9  "\" \"" ltycol9  "\")"))
                                   (setq outtxt9 ""))
  (if (/= "" (get_tile "label10")) (setq label10 (get_tile "label10") ltype10 (get_tile "ltype10") ltycol10 (get_tile "ltycol10")
                                         outtxt10 (strcat "(\"" label10 "\" \"" ltype10 "\" \"" ltycol10 "\")"))
                                   (setq outtxt10 ""))
  (if (/= "" (get_tile "label11")) (setq label11 (get_tile "label11") ltype11 (get_tile "ltype11") ltycol11 (get_tile "ltycol11")
                                         outtxt11 (strcat "(\"" label11 "\" \"" ltype11 "\" \"" ltycol11 "\")"))
                                   (setq outtxt11 ""))
  (if (/= "" (get_tile "label12" )) (setq label12 (get_tile "label12") ltype12 (get_tile "ltype12" ) ltycol12  (get_tile "ltycol12" )
                                         outtxt12 (strcat "(\"" label12 "\" \"" ltype12 "\" \"" ltycol12 "\")"))
                                   (setq outtxt12 ""))
  (if (/= "" (get_tile "label13" )) (setq label13 (get_tile "label13") ltype13 (get_tile "ltype13" ) ltycol13  (get_tile "ltycol13" )
                                         outtxt13 (strcat "(\"" label13 "\" \"" ltype13 "\" \"" ltycol13 "\")"))
                                   (setq outtxt13 ""))
  (if (/= "" (get_tile "label14" )) (setq label14 (get_tile "label14") ltype14 (get_tile "ltype14" ) ltycol14  (get_tile "ltycol14" )
                                         outtxt14 (strcat "(\"" label14 "\" \"" ltype14 "\" \"" ltycol14 "\")"))
                                   (setq outtxt14 ""))
  (if (/= "" (get_tile "label15" )) (setq label15 (get_tile "label15") ltype15 (get_tile "ltype15" ) ltycol15  (get_tile "ltycol15" )
                                         outtxt15 (strcat "(\"" label15 "\" \"" ltype15 "\" \"" ltycol15 "\")"))
                                   (setq outtxt15 ""))
  (if (/= "" (get_tile "label16" )) (setq label16 (get_tile "label16") ltype16  (get_tile "ltype16" ) ltycol16  (get_tile "ltycol16" )
                                         outtxt16 (strcat "(\"" label16 "\" \"" ltype16 "\" \"" ltycol16 "\")"))
                                   (setq outtxt16 ""))
  (if (/= "" (get_tile "label17" )) (setq label17 (get_tile "label17") ltype17  (get_tile "ltype17" ) ltycol17  (get_tile "ltycol17" )
                                         outtxt17 (strcat "(\"" label17 "\" \"" ltype17 "\" \"" ltycol17 "\")"))
                                   (setq outtxt17 ""))
  (if (/= "" (get_tile "label18" )) (setq label18 (get_tile "label18") ltype18  (get_tile "ltype18" ) ltycol18  (get_tile "ltycol18" )
                                         outtxt18 (strcat "(\"" label18 "\" \"" ltype18 "\" \"" ltycol18 "\")"))
                                   (setq outtxt18 ""))
  (if (/= "" (get_tile "label19" )) (setq label19 (get_tile "label19") ltype19  (get_tile "ltype19" ) ltycol19  (get_tile "ltycol19" )
                                         outtxt19 (strcat "(\"" label19 "\" \"" ltype19 "\" \"" ltycol19 "\")"))
                                   (setq outtxt19 ""))
  (if (/= "" (get_tile "label20")) (setq label20 (get_tile "label20") ltype20 (get_tile "ltype20") ltycol20 (get_tile "ltycol20")
                                         outtxt20 (strcat "(\"" label20 "\" \"" ltype20 "\" \"" ltycol20 "\")"))
                                   (setq outtxt20 ""))
  (setq outdata (strcat "圖層定義=(" outtxt1 outtxt2 outtxt3 outtxt4 outtxt5 outtxt6 outtxt7
                                     outtxt8 outtxt9 outtxt10 outtxt11 outtxt12 outtxt13 outtxt14
                                     outtxt15 outtxt16 outtxt17 outtxt18 outtxt19 outtxt20 ")"))
  (file_update  "SYSTEM.INI" "SYSTEM.NEW" "圖層定義" "=" outdata)
  (get_layerdef)
)




(defun deflayer_set_tile_smode()
   (setq qty (length deflayer_list) count 0 coun 1)
   (repeat qty
     (if (= "INTELLICAD" cad_version)
       (progn
         (set_tile (strcat "label"  (rtos coun 2 2)) (nth 0 (nth count deflayer_list)))
         (setq readlay (strcase (nth 1 (nth count deflayer_list))))
         (set_tile (strcat "ltype"  (rtos coun 2 2)) readlay)
         (set_tile (strcat "ltycol" (rtos coun 2 2)) (nth 2 (nth count deflayer_list)))
       );progn
       (progn
         (set_tile (strcat "label"  (rtos coun 2 0)) (nth 0 (nth count deflayer_list)))
         (setq readlay (strcase (nth 1 (nth count deflayer_list))))
         (set_tile (strcat "ltype"  (rtos coun 2 0)) readlay)
         (set_tile (strcat "ltycol" (rtos coun 2 0)) (nth 2 (nth count deflayer_list)))
       );progn
     );if
     ;(set_tile (strcat "label"  (rtos coun 2 0)) (nth 0 (nth count deflayer_list)))
     ;(setq readlay (strcase (nth 1 (nth count deflayer_list))))
     ;(set_tile (strcat "ltype"  (rtos coun 2 0)) readlay)
     ;(set_tile (strcat "ltycol" (rtos coun 2 0)) (nth 2 (nth count deflayer_list)))
     (setq count (1+ count) coun (1+ coun))
   )
   (if (= "INTELLICAD" cad_version)
     (progn
       (repeat (- 20 count)
         (set_tile (strcat "label"  (rtos coun 2 2)) "")
         (mode_tile (strcat "ltype"  (rtos coun 2 2)) 1)
         (mode_tile (strcat "ltycol" (rtos coun 2 2)) 1)
         (setq count (1+ count) coun (1+ coun))
       )
     );progn
     (progn
       (repeat (- 20 count)
         (set_tile (strcat "label"  (rtos coun 2 0)) "")
         (mode_tile (strcat "ltype"  (rtos coun 2 0)) 1)
         (mode_tile (strcat "ltycol" (rtos coun 2 0)) 1)
         (setq count (1+ count) coun (1+ coun))
       )
     );progn
   );if
   ;(repeat (- 20 count)
   ;  (set_tile (strcat "label"  (rtos coun 2 0)) "")
   ;  (mode_tile (strcat "ltype"  (rtos coun 2 0)) 1)
   ;  (mode_tile (strcat "ltycol" (rtos coun 2 0)) 1)
   ;  (setq count (1+ count) coun (1+ coun))
   ;)
)


;;材料清單欄寬定義
;;
;╭═════════════════════════════════════════════╮
;║設計日期: 1997.12. 9                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明:                                                                                     ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: system.dcl(defbomlist)                                                          ║
;╰═════════════════════════════════════════════╯
(defun c:defbomlist()
 (setvar "cmdecho" 0)

 (actdcl (strcat powdesign_dcl_path "system") "defbomlist")

 (defbomlist_set_tile_smode)
 (set_tile "qty" defbomqty_id)


 (action_tile "accept" "(defbomlist_ok)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (setvar "cmdecho" 1)
 (prin1)
)

(defun defbomlist_ok()
  (setq qtyid (get_tile "qty"))
  (if (/= (atoi qtyid) 0)
    (progn
      (if (= "INTELLICAD" cad_version)
        (setq qtyid (rtos (atoi qtyid) 2 2))
        (setq qtyid (rtos (atoi qtyid) 2 0))
      )
      ;(setq qtyid (rtos (atoi qtyid) 2 0))
      (if (/= "" (get_tile "label1" )) (setq label1  (get_tile "label1") ltype1  (get_tile "ltype1" )
                                             outtxt1  (strcat "(\"" label1  "\" \"" ltype1  "\")"))
                                       (setq outtxt1 ""))
      (if (/= "" (get_tile "label2" )) (setq label2  (get_tile "label2") ltype2  (get_tile "ltype2" )
                                             outtxt2  (strcat "(\"" label2  "\" \"" ltype2 "\")"))
                                       (setq outtxt2 ""))
      (if (/= "" (get_tile "label3" )) (setq label3  (get_tile "label3") ltype3  (get_tile "ltype3" )
                                             outtxt3  (strcat "(\"" label3  "\" \"" ltype3 "\")"))
                                       (setq outtxt3 ""))
      (if (/= "" (get_tile "label4" )) (setq label4  (get_tile "label4") ltype4  (get_tile "ltype4" )
                                             outtxt4  (strcat "(\"" label4  "\" \"" ltype4 "\")"))
                                       (setq outtxt4 ""))
      (if (/= "" (get_tile "label5" )) (setq label5  (get_tile "label5") ltype5  (get_tile "ltype5" )
                                             outtxt5  (strcat "(\"" label5  "\" \"" ltype5 "\")"))
                                       (setq outtxt5 ""))
      (if (/= "" (get_tile "label6" )) (setq label6  (get_tile "label6") ltype6  (get_tile "ltype6" )
                                             outtxt6  (strcat "(\"" label6  "\" \"" ltype6 "\")"))
                                       (setq outtxt6 ""))
      (if (/= "" (get_tile "label7" )) (setq label7  (get_tile "label7") ltype7  (get_tile "ltype7" )
                                             outtxt7  (strcat "(\"" label7  "\" \"" ltype7 "\")"))
                                       (setq outtxt7 ""))
      (if (/= "" (get_tile "label8" )) (setq label8  (get_tile "label8") ltype8  (get_tile "ltype8" )
                                             outtxt8  (strcat "(\"" label8  "\" \"" ltype8  "\")"))
                                       (setq outtxt8 ""))
      (if (/= "" (get_tile "label9" )) (setq label9  (get_tile "label9") ltype9  (get_tile "ltype9" )
                                             outtxt9  (strcat "(\"" label9  "\" \"" ltype9  "\")"))
                                       (setq outtxt9 ""))
      (if (/= "" (get_tile "label10")) (setq label10 (get_tile "label10") ltype10 (get_tile "ltype10")
                                             outtxt10 (strcat "(\"" label10 "\" \"" ltype10 "\")"))
                                       (setq outtxt10 ""))
      (if (/= "" (get_tile "label11")) (setq label11 (get_tile "label11") ltype11 (get_tile "ltype11")
                                             outtxt11 (strcat "(\"" label11 "\" \"" ltype11  "\")"))
                                       (setq outtxt11 ""))
      (if (/= "" (get_tile "label12" )) (setq label12 (get_tile "label12") ltype12 (get_tile "ltype12" )
                                             outtxt12 (strcat "(\"" label12 "\" \"" ltype12  "\")"))
                                       (setq outtxt12 ""))
      (if (/= "" (get_tile "label13" )) (setq label13 (get_tile "label13") ltype13 (get_tile "ltype13" )
                                             outtxt13 (strcat "(\"" label13 "\" \"" ltype13  "\")"))
                                       (setq outtxt13 ""))
      (if (/= "" (get_tile "label14" )) (setq label14 (get_tile "label14") ltype14 (get_tile "ltype14" )
                                             outtxt14 (strcat "(\"" label14 "\" \"" ltype14  "\")"))
                                       (setq outtxt14 ""))
      (if (/= "" (get_tile "label15" )) (setq label15 (get_tile "label15") ltype15 (get_tile "ltype15" )
                                             outtxt15 (strcat "(\"" label15 "\" \"" ltype15  "\")"))
                                       (setq outtxt15 ""))
      (if (/= "" (get_tile "label16" )) (setq label16 (get_tile "label16") ltype16  (get_tile "ltype16" )
                                             outtxt16 (strcat "(\"" label16 "\" \"" ltype16 "\")"))
                                       (setq outtxt16 ""))
      (if (/= "" (get_tile "label17" )) (setq label17 (get_tile "label17") ltype17  (get_tile "ltype17" )
                                             outtxt17 (strcat "(\"" label17 "\" \"" ltype17 "\")"))
                                       (setq outtxt17 ""))
      (if (/= "" (get_tile "label18" )) (setq label18 (get_tile "label18") ltype18  (get_tile "ltype18" )
                                             outtxt18 (strcat "(\"" label18 "\" \"" ltype18 "\")"))
                                       (setq outtxt18 ""))
      (if (/= "" (get_tile "label19" )) (setq label19 (get_tile "label19") ltype19  (get_tile "ltype19" )
                                             outtxt19 (strcat "(\"" label19 "\" \"" ltype19 "\")"))
                                       (setq outtxt19 ""))
      (if (/= "" (get_tile "label20")) (setq label20 (get_tile "label20") ltype20 (get_tile "ltype20")
                                             outtxt20 (strcat "(\"" label20 "\" \"" ltype20 "\")"))
                                       (setq outtxt20 ""))
      (setq outdata (strcat "材料清單欄位定義=(" outtxt1 outtxt2 outtxt3 outtxt4 outtxt5 outtxt6 outtxt7
                                         outtxt8 outtxt9 outtxt10 outtxt11 outtxt12 outtxt13 outtxt14
                                         outtxt15 outtxt16 outtxt17 outtxt18 outtxt19 outtxt20 ")"))
      (file_update  "SYSTEM.INI" "SYSTEM.NEW" "材料清單欄位定義" "=" outdata)
      (file_update  "SYSTEM.INI" "SYSTEM.NEW" "數量位置" "=" (strcat "數量位置" "=\""  qtyid "\""))
      (done_dialog)
      (get_bomlistdef)
    );progn
    (set_tile "error" "對話框下方的[數量] 欄位置輸入錯誤或空值!!")
  );if

)




(defun defbomlist_set_tile_smode()
   (setq qty (length defbomlist_list) count 0 coun 1)
   (if (= "INTELLICAD" cad_version)
     (progn
         (repeat qty
           (set_tile (strcat "label"  (rtos coun 2 2)) (nth 0 (nth count defbomlist_list)))
           (setq readlay (strcase (nth 1 (nth count defbomlist_list))))
           (set_tile (strcat "ltype"  (rtos coun 2 2)) readlay)
           (setq count (1+ count) coun (1+ coun))
         )
         (repeat (- 20 count)
           (set_tile (strcat "label"  (rtos coun 2 2)) "")
           (mode_tile (strcat "ltype"  (rtos coun 2 2)) 1)
           (setq count (1+ count) coun (1+ coun))
         )
     );progn
     (progn
         (repeat qty
           (set_tile (strcat "label"  (rtos coun 2 0)) (nth 0 (nth count defbomlist_list)))
           (setq readlay (strcase (nth 1 (nth count defbomlist_list))))
           (set_tile (strcat "ltype"  (rtos coun 2 0)) readlay)
           (setq count (1+ count) coun (1+ coun))
         )
         (repeat (- 20 count)
           (set_tile (strcat "label"  (rtos coun 2 0)) "")
           (mode_tile (strcat "ltype"  (rtos coun 2 0)) 1)
           (setq count (1+ count) coun (1+ coun))
         )
     );progn
   );if
  ; (repeat qty
  ;   (set_tile (strcat "label"  (rtos coun 2 0)) (nth 0 (nth count defbomlist_list)))
  ;   (setq readlay (strcase (nth 1 (nth count defbomlist_list))))
  ;   (set_tile (strcat "ltype"  (rtos coun 2 0)) readlay)
  ;   (setq count (1+ count) coun (1+ coun))
  ; )
  ; (repeat (- 20 count)
  ;   (set_tile (strcat "label"  (rtos coun 2 0)) "")
  ;   (mode_tile (strcat "ltype"  (rtos coun 2 0)) 1)
  ;   (setq count (1+ count) coun (1+ coun))
  ; )
)



;; 設定線型系統變數
;╭═════════════════════════════════════════════╮
;║設計日期: 1997.12. 9                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明: 設定線型系統變數                                                                    ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: system.dcl(defltyle)                                                            ║
;╰═════════════════════════════════════════════╯
(defun c:defltype()
 (setvar "cmdecho" 0)

 (if (= "INTELLICAD" cad_version)
   (actdcl (strcat powdesign_dcl_path "system") "intelli_defltype")
   (actdcl (strcat powdesign_dcl_path "system") "defltype")
 )
 ;(actdcl (strcat powdesign_dcl_path "system") "defltype")

 (defltype_set_tile_smode)

 (action_tile "ltycol1" "(setq selcol_id 1)")
 (action_tile "ltycol2" "(setq selcol_id 2)")
 (action_tile "ltycol3" "(setq selcol_id 3)")
 (action_tile "ltycol4" "(setq selcol_id 4)")
 (action_tile "ltycol5" "(setq selcol_id 5)")
 (action_tile "ltycol6" "(setq selcol_id 6)")
 (action_tile "ltycol7" "(setq selcol_id 7)")
 (action_tile "ltycol8" "(setq selcol_id 8)")
 (action_tile "ltycol9" "(setq selcol_id 9)")
 (action_tile "ltycol10" "(setq selcol_id 10)")
 (action_tile "ltycol11" "(setq selcol_id 11)")
 (action_tile "ltycol12" "(setq selcol_id 12)")
 (action_tile "ltycol13" "(setq selcol_id 13)")
 (action_tile "ltycol14" "(setq selcol_id 14)")
 (action_tile "ltycol15" "(setq selcol_id 15)")
 (action_tile "ltycol16" "(setq selcol_id 16)")
 (action_tile "ltycol17" "(setq selcol_id 17)")
 (action_tile "ltycol18" "(setq selcol_id 18)")
 (action_tile "ltycol19" "(setq selcol_id 19)")
 (action_tile "ltycol20" "(setq selcol_id 20)")
 (if (= "INTELLICAD" cad_version)
   (action_tile "selcol" "(ddsel_col (strcat \"ltycol\" (rtos selcol_id 2 2)))")
   (action_tile "selcol" "(ddsel_col (strcat \"ltycol\" (rtos selcol_id 2 0)))")
 )
; (action_tile "selcol" "(ddsel_col (strcat \"ltycol\" (rtos selcol_id 2 0)))")

 (action_tile "accept" "(defltype_ok)(done_dialog)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (setvar "cmdecho" 1)
 (prin1)
)

(defun defltype_ok()
  (if (/= "" (get_tile "label1" )) (setq label1  (get_tile "label1") ltype1  (nth (atoi (get_tile "ltype1" )) curlty_list)  ltycol1  (get_tile "ltycol1" )
                                         outtxt1  (strcat "(\"" label1  "\" \"" ltype1  "\" \"" ltycol1 "\" \"$$SL\")"))
                                   (setq outtxt1 ""))
  (if (/= "" (get_tile "label2" )) (setq label2  (get_tile "label2") ltype2  (nth (atoi (get_tile "ltype2" )) curlty_list)  ltycol2  (get_tile "ltycol2" )
                                         outtxt2  (strcat "(\"" label2  "\" \"" ltype2  "\" \"" ltycol2 "\" \"$$TL\")"))
                                   (setq outtxt2 ""))
  (if (/= "" (get_tile "label3" )) (setq label3  (get_tile "label3") ltype3  (nth (atoi (get_tile "ltype3" )) curlty_list)  ltycol3  (get_tile "ltycol3" )
                                         outtxt3  (strcat "(\"" label3  "\" \"" ltype3  "\" \"" ltycol3 "\" \"$$DL\")"))
                                   (setq outtxt3 ""))

  (if (/= "" (get_tile "label4" )) (setq label4  (get_tile "label4") ltype4  (nth (atoi (get_tile "ltype4" )) curlty_list)  ltycol4  (get_tile "ltycol4" )
                                         outtxt4  (strcat "(\"" label4  "\" \"" ltype4  "\" \"" ltycol4 "\" \"$$CL\")"))
                                   (setq outtxt4 ""))
  (if (/= "" (get_tile "label5" )) (setq label5  (get_tile "label5") ltype5  (nth (atoi (get_tile "ltype5" )) curlty_list)  ltycol5  (get_tile "ltycol5" )
                                         outtxt5  (strcat "(\"" label5  "\" \"" ltype5  "\" \"" ltycol5 "\" \"$$SCL\")"))
                                   (setq outtxt5 ""))
  (if (/= "" (get_tile "label6" )) (setq label6  (get_tile "label6") ltype6  (nth (atoi (get_tile "ltype6" )) curlty_list)  ltycol6  (get_tile "ltycol6" )
                                         outtxt6  (strcat "(\"" label6  "\" \"" ltype6  "\" \"" ltycol6 "\" \"$$HL\")"))
                                   (setq outtxt6 ""))
  (if (/= "" (get_tile "label7" )) (setq label7  (get_tile "label7") ltype7  (nth (atoi (get_tile "ltype7" )) curlty_list)  ltycol7  (get_tile "ltycol7" )
                                         outtxt7  (strcat "(\"" label7  "\" \"" ltype7  "\" \"" ltycol7 "\" \"$$PL\")"))
                                   (setq outtxt7 ""))
  (if (/= "" (get_tile "label8" )) (setq label8  (get_tile "label8") ltype8  (nth (atoi (get_tile "ltype8" )) curlty_list)  ltycol8  (get_tile "ltycol8" )
                                         outtxt8  (strcat "(\"" label8  "\" \"" ltype8  "\" \"" ltycol8 "\")"))
                                   (setq outtxt8 ""))
  (if (/= "" (get_tile "label9" )) (setq label9  (get_tile "label9") ltype9  (nth (atoi (get_tile "ltype9" )) curlty_list)  ltycol9  (get_tile "ltycol9" )
                                         outtxt9  (strcat "(\"" label9  "\" \"" ltype9  "\" \"" ltycol9 "\")"))
                                   (setq outtxt9 ""))
  (if (/= "" (get_tile "label10")) (setq label10 (get_tile "label10") ltype10 (nth (atoi (get_tile "ltype10")) curlty_list)  ltycol10 (get_tile "ltycol10")
                                         outtxt10 (strcat "(\"" label10 "\" \"" ltype10 "\" \"" ltycol10 "\")"))
                                   (setq outtxt10 ""))
  (if (/= "" (get_tile "label11")) (setq label11 (get_tile "label11") ltype11 (nth (atoi (get_tile "ltype11")) curlty_list)  ltycol11 (get_tile "ltycol11")
                                         outtxt11 (strcat "(\"" label11 "\" \"" ltype11 "\" \"" ltycol11 "\")"))
                                   (setq outtxt11 ""))
  (if (/= "" (get_tile "label12" )) (setq label12 (get_tile "label12") ltype12  (nth (atoi (get_tile "ltype12" )) curlty_list)  ltycol12  (get_tile "ltycol12" )
                                         outtxt12 (strcat "(\"" label12 "\" \"" ltype12 "\" \"" ltycol12 "\")"))
                                   (setq outtxt12 ""))
  (if (/= "" (get_tile "label13" )) (setq label13 (get_tile "label13") ltype13  (nth (atoi (get_tile "ltype13" )) curlty_list)  ltycol13  (get_tile "ltycol13" )
                                         outtxt13 (strcat "(\"" label13 "\" \"" ltype13 "\" \"" ltycol13 "\")"))
                                   (setq outtxt13 ""))
  (if (/= "" (get_tile "label14" )) (setq label14 (get_tile "label14") ltype14  (nth (atoi (get_tile "ltype14" )) curlty_list)  ltycol14  (get_tile "ltycol14" )
                                         outtxt14 (strcat "(\"" label14 "\" \"" ltype14 "\" \"" ltycol14 "\")"))
                                   (setq outtxt14 ""))
  (if (/= "" (get_tile "label15" )) (setq label15 (get_tile "label15") ltype15  (nth (atoi (get_tile "ltype15" )) curlty_list)  ltycol15  (get_tile "ltycol15" )
                                         outtxt15 (strcat "(\"" label15 "\" \"" ltype15 "\" \"" ltycol15 "\")"))
                                   (setq outtxt15 ""))
  (if (/= "" (get_tile "label16" )) (setq label16 (get_tile "label16") ltype16  (nth (atoi (get_tile "ltype16" )) curlty_list)  ltycol16  (get_tile "ltycol16" )
                                         outtxt16 (strcat "(\"" label16 "\" \"" ltype16 "\" \"" ltycol16 "\")"))
                                   (setq outtxt16 ""))
  (if (/= "" (get_tile "label17" )) (setq label17 (get_tile "label17") ltype17  (nth (atoi (get_tile "ltype17" )) curlty_list)  ltycol17  (get_tile "ltycol17" )
                                         outtxt17 (strcat "(\"" label17 "\" \"" ltype17 "\" \"" ltycol17 "\")"))
                                   (setq outtxt17 ""))
  (if (/= "" (get_tile "label18" )) (setq label18 (get_tile "label18") ltype18  (nth (atoi (get_tile "ltype18" )) curlty_list)  ltycol18  (get_tile "ltycol18" )
                                         outtxt18 (strcat "(\"" label18 "\" \"" ltype18 "\" \"" ltycol18 "\")"))
                                   (setq outtxt18 ""))
  (if (/= "" (get_tile "label19" )) (setq label19 (get_tile "label19") ltype19  (nth (atoi (get_tile "ltype19" )) curlty_list)  ltycol19  (get_tile "ltycol19" )
                                         outtxt19 (strcat "(\"" label19 "\" \"" ltype19 "\" \"" ltycol19 "\")"))
                                   (setq outtxt19 ""))
  (if (/= "" (get_tile "label20")) (setq label20 (get_tile "label20") ltype20 (nth (atoi (get_tile "ltype20")) curlty_list)  ltycol20 (get_tile "ltycol20")
                                         outtxt20 (strcat "(\"" label20 "\" \"" ltype20 "\" \"" ltycol20 "\")"))
                                   (setq outtxt20 ""))
  (setq outdata (strcat "線性定義=(" outtxt1 outtxt2 outtxt3 outtxt4 outtxt5 outtxt6 outtxt7
                                     outtxt8 outtxt9 outtxt10 outtxt11 outtxt12 outtxt13 outtxt14
                                     outtxt15 outtxt16 outtxt17 outtxt18 outtxt19 outtxt20 ")"))
  (file_update  "SYSTEM.INI" "SYSTEM.NEW" "線性定義" "=" outdata)
  (redefine_ltype)           ;線型定義

)


;線型定義=(("粗連續線" "CONTINUOUS" 7)("細連續線" "CONTINUOUS" 4)("虛線" "DASHED" 3)("標準中心線(長度20)" "CENTER" 1)("短中心線(長度10)" "CENTER1" 1)("假想線" "PHANTOM" 5)("剖面線" "CONTINUOUS" 6)("假想線" "PHANTOM" 5)("投影線" "CONTINUOUS" 143 "PROJ"))
;;(file_update   "SYSTEM.INI" "SYSTEM.NEW "線型定義" "=")
;                  oldfile       newfile     label   flagtxt

(defun file_update(oldfile newfile labl flagtxt outdata)

         (setq xoldfile (open (strcat powdesign_path oldfile) "r"))
         (setq xnewfile (open (strcat powdesign_path newfile) "w"))
         (setq rd_data (read-line xoldfile))
      (while rd_data
         (setq flag_id (get_word rd_data "="))
         (if flag_id
           (progn
             (if (= labl (substr rd_data 1 (- flag_id 1)))
                 (write-line outdata xnewfile)
                 (write-line rd_data xnewfile)
             );if
           )
           (write-line rd_data xnewfile)
         );if
         (setq rd_data (read-line xoldfile))
      )
      (close xoldfile)
      (close xnewfile)

;;資料重新寫入
      (setq xoldfile (open (strcat powdesign_path newfile) "r"))
      (setq xnewfile (open (strcat powdesign_path oldfile) "w"))
      (setq rd_data (read-line xoldfile))
      (while rd_data
         (write-line rd_data xnewfile)
         (setq rd_data (read-line xoldfile))
      )
      (close xoldfile)
      (close xnewfile)

)


(defun defltype_set_tile_smode()
   (setq curlty_list '())
   (setq curlty_data (tblnext "ltype" t))
   (while curlty_data
      (setq lty (cdr (assoc 2 curlty_data))
            curlty_list (cons lty curlty_list))
      (setq curlty_data (tblnext "ltype"))
   )
   (setq curlty_list (reverse curlty_list))

   (setq qty (length defltype_list) count 0 coun 1)

   (repeat qty
     (set_tile (strcat "label"  (rtos coun 2 0)) (nth 0 (nth count defltype_list)))
     (setq readlty (strcase (nth 1 (nth count defltype_list))))
     (act_pop_list curlty_list (strcat "ltype"  (rtos coun 2 0)))
     (setq cc 0)
     (while (setq ltyname (nth cc curlty_list))
       (if (= ltyname readlty) (set_tile (strcat "ltype"  (rtos coun 2 0)) (rtos cc 2 0)))
       (setq cc (1+ cc))
     )


     (set_tile (strcat "ltycol" (rtos coun 2 0)) (nth 2 (nth count defltype_list)))
     (setq count (1+ count) coun (1+ coun))
   )
   (repeat (- 20 count)
     (set_tile (strcat "label"  (rtos coun 2 0)) "")
     (mode_tile (strcat "ltype"  (rtos coun 2 0)) 1)
     (mode_tile (strcat "ltycol" (rtos coun 2 0)) 1)
     (setq count (1+ count) coun (1+ coun))
   )
)


;;指標球定義
;;╭═════════════════════════════════════════════╮
;;║設計日期: 1997.12. 9                                                                      ║
;;║更新日期:                                                                                 ║
;;║設 計 者: 陳冠達                                                                          ║
;;║功能說明: 指標球定義                                                                          ║
;;║                                                                                          ║
;;║執行方式:                                                                                 ║
;;║相關檔案: system.dcl(deflayer)                                                            ║
;;╰═════════════════════════════════════════════╯
;;格式:("圓球有無:1(有), 0(無)" "圓球直徑" "指標型式:0(無), 1(圓點), 2(箭頭)" "指標尺寸" " "字高")
;;指標球定義=("1" "7" "0" "0" "3")
;; defball_list          :  指標球定義=("1" "7" "0" "0" "3")
;; sys_ball_yesno        :  指標球有無
;; sys_ball_dia          :  指標球直徑
;; sys_ballpoint_type    :  指標形式      ;; sys_balldonut_yesno   :  指線圓點有無
;; sys_ballpoint_size    :  指標尺寸      ;  ; sys_balldonut_dia
;; sys_balltxt_hei       :  指標球字高
;
(defun c:defball()
 (setvar "cmdecho" 0)

 (actdcl (strcat powdesign_dcl_path "system") "defball")


 (set_tile "ball" sys_ball_yesno)
 (cond
  ((= "0" sys_ball_yesno)(set_tile "noball" "1")(mode_tile "balldia" 1)(set_tile "balldia" ""))
  ((= "1" sys_ball_yesno)(set_tile "ball" "1")(mode_tile "balldia" 0)(set_tile "balldia" sys_ball_dia))
 );cond
 (cond
  ((= "0" sys_ballpoint_type)(set_tile "none" "1")(mode_tile "pointsize" 1))
  ((= "1" sys_ballpoint_type)(set_tile "donut" "1")(mode_tile "pointsize" 0))
  ((= "2" sys_ballpoint_type)(set_tile "arror" "1")(mode_tile "pointsize" 0))
 );
 (set_tile "txth"      sys_balltxt_hei)
 (set_tile "balldia"   sys_ball_dia)
 (set_tile "pointsize"  sys_ballpoint_size)

 (show_defball_sld)

 (action_tile "ball"    "(show_defball_sld)(mode_tile \"balldia\" 0)(set_tile \"balldia\" sys_ball_dia)")
 (action_tile "noball"  "(show_defball_sld)(mode_tile \"balldia\" 1)(set_tile \"balldia\" \"\")")

 (action_tile "donut"   "(show_defball_sld)(mode_tile \"pointsize\" 0)(set_tile \"pointsize\"  sys_ballpoint_size)")
 (action_tile "none"    "(show_defball_sld)(mode_tile \"pointsize\" 1)(set_tile \"pointsize\"  \"\")")
 (action_tile "arror"   "(show_defball_sld)(mode_tile \"pointsize\" 0)(set_tile \"pointsize\"  sys_ballpoint_size)")

 (action_tile "accept" "(defball_ok)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (setvar "cmdecho" 1)
 (prin1)
)

(defun show_defball_sld()
  (setq xball_yes (get_tile "ball"))
  (setq xdonut_yes (get_tile "donut"))
  (setq xnone_yes (get_tile "none"))
  (setq xarror_yes (get_tile "arror"))
  (cond
    ((and (/= "0" xball_yes)(/= "0" xdonut_yes))
      (show_sld "balltype" (strcat powdesign_sld_path "ball&p")))
    ((and (/= "0" xball_yes)(/= "0" xnone_yes))
      (show_sld "balltype" (strcat powdesign_sld_path "ball")))
    ((and (/= "0" xball_yes)(/= "0" xarror_yes))
      (show_sld "balltype" (strcat powdesign_sld_path "ball&arr")))
    ((and (= "0" xball_yes)(/= "0" xdonut_yes))
      (show_sld "balltype" (strcat powdesign_sld_path "ballno&p")))
    ((and (= "0" xball_yes)(/= "0" xnone_yes))
      (show_sld "balltype" (strcat powdesign_sld_path "ballno")))
    ((and (= "0" xball_yes)(/= "0" xarror_yes))
      (show_sld "balltype" (strcat powdesign_sld_path "ballno&a")))
  )
)


(defun defball_ok()
   (setq ball_yesno  (get_tile "ball")
         donut_yesno (get_tile "donut")
         bomtxth (get_tile "txth")
         balldia (get_tile "balldia")
         arror (get_tile "arror")
         pointsize (get_tile "pointsize"))

   (cond
     ((and (= ball_yesno "1") (= 0 (atof balldia))(< 0 (atof balldia))) (set_tile "error" "指標球直徑資料錯誤!"))
     ((and (= donut_yesno "1") (= 0 (atof pointsize))(< 0 (atof pointsize))) (set_tile "error" "指線圓點直徑資料錯誤!"))
     ((and (= arror "1") (= 0 (atof pointsize))(< 0 (atof pointsize))) (set_tile "error" "指線尺寸資料錯誤!"))
     ((= 0 (atof bomtxth)) (set_tile "error" "字高資料錯誤!"))
     ((and (> (atof bomtxth) (atof balldia))(= ball_yesno "1"))
       (set_tile "error" "字高不能大於標球直徑!"))
     (T
        (if (= "1" ball_yesno) (setq sys_ball_yesno "1" sys_ball_dia balldia)
                               (setq sys_ball_yesno "0" sys_ball_dia "0"))
        (cond
          ((= "1" donut_yesno) (setq sys_ballpoint_type "1" sys_ballpoint_size pointsize))
          ((= "1" arror) (setq sys_ballpoint_type "2" sys_ballpoint_size pointsize))
          (T (setq sys_ballpoint_type "0" sys_ballpoint_size "0"))
        );cond
        (setq sys_balltxt_hei bomtxth)
        (done_dialog)
 ;格式:      ("圓球有無" "圓球直徑" "圓點有無" "圓點直徑" "字高")
 ;指標球定義=("1" "10" "0" "0" "6")
        (setq outdata (strcat "指標球定義=(\"" sys_ball_yesno "\" \""  sys_ball_dia "\" \""
                                             sys_ballpoint_type "\" \"" sys_ballpoint_size "\" \""
                                             sys_balltxt_hei "\"" ")"))

        (file_update  "SYSTEM.INI" "SYSTEM.NEW" "指標球定義" "=" outdata))
   )
)

;;圖框日期型式 (0)  1998.11.2       (1)  1998/11/2        (4) 19981102
;;             (2)  87.11.2         (3)  87/11/2
;;             (5)  1998年11月2日   (6)  87年11月2日
;;             (7) JAN.28.1998      (10) JAN/28/1998
;;             (8) 1998.JAN.28      (9)  1998/JAN/28
;;             (11) JAN.2.98        (12) JAN/2/98

(defun c:defdate_type()
 (setvar "cmdecho" 0)

 (actdcl (strcat powdesign_dcl_path "system") "defdatetype")

 (set_tile (strcat "date" (getfile_val (strcat POWDESIGN_path "shscal.ini") "圖框日期型式")) "1")
 (action_tile "accept" "(defdate_type_ok)(done_dialog)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (setvar "cmdecho" 1)
 (prin1)
)
(defun defdate_type_ok()
  (cond
    ((= (get_tile "date0") "1") (setq outdata "圖框日期型式=0"))
    ((= (get_tile "date1") "1") (setq outdata "圖框日期型式=1"))
    ((= (get_tile "date2") "1") (setq outdata "圖框日期型式=2"))
    ((= (get_tile "date3") "1") (setq outdata "圖框日期型式=3"))
    ((= (get_tile "date4") "1") (setq outdata "圖框日期型式=4"))
    ((= (get_tile "date5") "1") (setq outdata "圖框日期型式=5"))
    ((= (get_tile "date6") "1") (setq outdata "圖框日期型式=6"))
    ((= (get_tile "date7") "1") (setq outdata "圖框日期型式=7"))
    ((= (get_tile "date8") "1") (setq outdata "圖框日期型式=8"))
    ((= (get_tile "date9") "1") (setq outdata "圖框日期型式=9"))
    ((= (get_tile "date10") "1") (setq outdata "圖框日期型式=10"))
    ((= (get_tile "date11") "1") (setq outdata "圖框日期型式=11"))
    ((= (get_tile "date12") "1") (setq outdata "圖框日期型式=12"))
  );cond
  (file_update  "shscal.INI" "swapfile.txt" "圖框日期型式" "=" outdata)
)
;;c:passdfac***********************************************************************************

;;零件組合時預設之顏色
(defun c:passdfac(/ #upperdata #process_temp     #downdata exe_st
                    #process_list        #s_word_set       #s_postword_set    gf_val        mm   cmdecho_v
                    exetrans_flag        #class_data_list  #class_name_list   #old_classdef #filterclassdef
                    #filterclassdata     #init_set_list
                  );Part ASSemble DeFAult Color
  
      
       (setq cmdecho_v (getvar "cmdecho"))
       (setvar "cmdecho" 0)
       (actdcl (strcat powdesign_DCL_PATH "system") "passdfac")
       (setq #upperdata nil)
       (setq #process_temp nil)
       (setq #downdata nil)
       (setq #mult_sel nil)
       (setq #mult_sel_one nil)
       (setq exe_st 0)
       ;(setq exetrans_flag 0)
       (setq gf_val nil)
       ;(setq #class_data_list nil)
       ;(setq #class_name_list nil)
       (setq #process_list nil)

       (if (/= (setq gf_val (vgetfile_val&passdfac (strcat powdesign_PATH "system.ini") "零件組合時預設之顏色")) nil)
           (progn
                (setq #process_list (read gf_val))
                (foreach mm #process_list
                         ;(setq #process_temp (append #process_temp (list (strcase (rtos mm))) ))
                         (setq #process_temp (append #process_temp (list (strcase (rtos mm 2 0))) ))
                );foreach
                (setq #process_list  #process_temp)
           );progn        
       );if      
      
    
       (data_tobox&passdfac)
       (setq linkflag&passdfac nil)
       (action_tile "datalst"    "(setq linkflag&passdfac t)(datalst_pro&passdfac)(set_color&passdfac \"clr_btn\" (atoi (get_tile \"clr\")))")
       (action_tile "clr"        "(set_color&passdfac \"clr_btn\" (atoi (get_tile \"clr\")))")
       ;(action_tile "clr_btn"    "(set_tile \"clr\" (rtos (col_pro&passdfac \"clr_btn\")))")
       (action_tile "clr_btn"    "(set_tile \"clr\" (rtos (col_pro&passdfac \"clr_btn\") 2 0))")
       (action_tile "add"        "(add_pro&passdfac)")
       (action_tile "mod"        "(mod_pro&passdfac)")
       (action_tile "del"        "(del_pro&passdfac)")
     
       (action_tile "accept" "(setq exe_st 1)(done_dialog)(write_systemini&passdfac)")
       (action_tile "cancel" "(setq exe_st 0)(done_dialog)(unload_dialog dcL_id)")
       (start_dialog)
       (if (= exe_st 1)
           (c:passdfac)
       );if      
       (setvar "cmdecho" cmdecho_v)
       (princ)
  );defun

  
(defun col_pro&passdfac(key / x y lacol newcol col_v)
     (setq x (dimx_tile key))
     (setq y (dimy_tile key))
     ;(setq lacol (get_tile key))
     (setq lacol "0")
     (setq newcol (acad_colordlg (atoi lacol)))
     (cond
         ((= newcol 0) (setq newcol "BYBLOCK"))
         ((= newcol 256) (setq newcol "BYLAYER"))
         ((/= nil newcol) (setq newcol (rtos newcol 2 0)))
     )

     (if (null newcol) (setq col_v (atoi lacol)) (setq col_v (atoi newcol)))

     ;(setq col_v (ddsel_col key))
     (start_image key)
     (fill_image 0 0 x y  col_v)

     (slide_image 0 0 x y (strcat powdesign_sld_path "passdfac"))
     (end_image)
     col_v
);defun

(defun set_color&passdfac( key col_v&0 / x y )
     (if (= col_v&0 "")
         (setq col_v&0 7)
     );if
     (setq x (dimx_tile key))
     (setq y (dimy_tile key))
     (start_image key)
     (fill_image 0 0 x y  col_v&0)

     (slide_image 0 0 x y (strcat powdesign_sld_path "ltypedef0"))
     (end_image)
);defun


(defun data_tobox&passdfac()
       (start_List "datalst" 3)
       (mapcar 'add_list #process_list)
       (end_list)

);defun data_tobox&passdfac




(defun datalst_pro&passdfac(/ data_key mult_sel_one data_pro_temp)
     (if (/= #process_list nil)
         (progn
              (setq #mult_sel (read (strcat "(" (get_tile "datalst") ")")))
              (setq #mult_sel_one (car (reverse #mult_sel)))

             ; (foreach mm mult_sel;只做一個 loop
              (setq data_key (nth #mult_sel_one #process_list))
              (set_tile "clr" data_key)
         );progn
    );if 
);defun datalst_pro&passdfac


(defun add_pro&passdfac(/ add_key total_list)
       (setq add_key (strcase (get_tile "clr")))
       (if (and (/= add_key "")
                ;(= (member add_key #process_list) nil)
           );and        
           (progn
                (setq #process_list (append   #process_list (list  add_key)))
                ;(setq #process_list (acad_strlsort #process_list))
                (start_List "datalst" 3)
                (mapcar 'add_list #process_list)
                (end_list)
           );progn
           (alert "資料重覆或空白")
        );if
        (setq linkflag&passdfac nil)
        (set_tile "clr" "")
);defun cadd

(defun mod_pro&passdfac(/ mod_key i olddatakey nth_data prs_temp #process_list_temp i)
       (setq mod_key (strcase (get_tile "clr")))
       (if (and (= linkflag&passdfac t)
                (/= mod_key "")
                ;(= (member mod_key #process_list) nil)
           );and
           (progn
                ;(setq prs_temp nil)
               ; (setq olddatakey (nth #mult_sel_one #process_list))
             ;   ;|(setq i 0)
             ;   (while (/= (setq nth_data (nth i #process_list)) nil)
             ;          (setq i (1+ i))
             ;          (if (/= olddatakey nth_data)
             ;              (setq prs_temp (append prs_temp (list nth_data)))
             ;          );if
             ;   );while|;
                (setq #process_list_temp nil)
                (setq i 0)
                (while (setq nthdata (nth i #process_list))
                       (if (= i #mult_sel_one)
                           (setq nthdata mod_key)
                       );if      
                       (setq #process_list_temp (append   #process_list_temp (list  nthdata)))
                       (setq i (1+ i))
                );while  
                ;(setq #process_list (cons  mod_key  prs_temp))
                (setq #process_list #process_list_temp)
                (start_List "datalst" 3)
                (mapcar 'add_list #process_list)
                (end_list)
            );progn
           (alert "資料重覆或空白")
        );if
        (setq linkflag&passdfac nil)
        (set_tile "clr" "")
);defun mod
(defun del_pro&passdfac(/  mm_data  delprs_temp i nth_data mm)
       (if (and (= linkflag&passdfac t)
                (/= #mult_sel nil)
           );and        
           (progn
                (setq delprs_temp nil)
                ;(foreach mm #mult_sel
                ;       (setq mm_data (nth mm #process_list))
                ;       (setq #process_list (subst  ""  mm_data  #process_list))
                ;       ;(setq #class_data_list (subst  "" (assoc mm_data  #class_data_list) #class_data_list))
                ;);foreach
                (setq i 0)

                (while (/= (setq nth_data (nth i #process_list)) nil)

                       (if (= (member i #mult_sel) nil)
                           (setq delprs_temp (append delprs_temp (list nth_data)))
                       );if
                       (setq i (1+ i))
                );while
                (setq #process_list delprs_temp)
                      
                (start_List "datalst" 3)
                (mapcar 'add_list #process_list)
                (end_list)
                

           );progn
           (alert "無選擇資料!!")
        );if
        (setq linkflag&passdfac nil)
        (set_tile "clr" "")
        (setq #mult_sel nil)
        
);defun cadd  
 
(defun vgetfile_val&passdfac(fname initxt / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "system.ini檔案不存在")
                (exit)
           ) ;progn
    
       );if
  ;jacky
       (setq #textdef initxt)
       (setq needdata nil)
       (setq #downdata nil)
  ;jacky
 ; (setq data (read-line ff))
  (while (setq data (read-line ff))
    
    (setq #downdata (cons data #downdata))
    (if (/= nil (setq txtid (get_word data "=")))
      (progn
        (setq objdata (strcase (substr data 1 (- txtid 1))))
        (if (= objdata initxt)
            (progn
                 (setq dd data needdata (substr data (1+ txtid)) data nil)
                 (setq #downdata (cdr #downdata))
                 (setq #upperdata (reverse #downdata))
                 (setq #downdata nil)
            )  
           
        );if
      );progn
     
    );if
  );while
  (setq #downdata (reverse #downdata))
  (close ff)
  (setq a (list needdata))
  needdata
  
)

(defun write_systemini&passdfac(/ ff num  #process_list_temp temp mm prew postw w_list  w_word forlist class_ff assoc_data)
             
        (setq ff (open (strcat powdesign_path "system.ini") "w"))
        (setq num nil)
        (setq temp nil)
        (setq #process_list_temp nil)
  
        (foreach mm  #process_list
               (setq #process_list_temp (append #process_list_temp (list (atoi mm))))
        );foreach
        (setq #process_list #process_list_temp)
        (if (= #upperdata nil)
            (progn
                 (setq #upperdata #downdata)
                 (setq #downdata nil)
            );progn
        );if  
        (if (/= #process_list nil)
            (progn
                 (setq w_word (strcat #textdef "=" (list_tostring&passdfac  #process_list )))
                 (setq forlist (append #upperdata (list w_word) #downdata))
            );progn
            (progn
                 (setq forlist (append #upperdata  #downdata))
            );progn
        );if  
        (foreach mm forlist
               (write-line mm ff)
        );foreach  
        (close ff)

);defun

(defun list_tostring&passdfac(  arg / fi temp blank tran_str )
       (setq fi        0 )
       (setq temp      "")
       (setq blank     " ")
       (setq tran_str  "")

       (while (/=  (nth fi arg) nil)
              (progn
                   (if (= fi (1- (length arg)))
                       (setq blank "")
                   )
                   (setq  tran_str (etos&passdfac (nth fi arg)))
                   (setq temp  (strcat temp tran_str blank))
                   (setq fi (+ fi 1))

               );progn
        );while

        (setq temp  (strcat "(" temp " )"))
        temp
 );list_tostring&passdfac

 (defun etos&passdfac (arg / file)
     (if (= 'STR (type arg)) (setq arg (strcat "\"" arg "\"")))
     (setq  file (open "$" "w"))
     (princ arg  file)
     (close file)
     (setq file (open "$" "r"))
     (setq arg (read-line file))
     (close file)
     arg
);eots&fun1

(defun *error* (msg)
       (princ)
)                         
          


;lt_dcltr*******************************************************************************************

;;零件組合時刪除之圖層
(defun c:psdellay();Part aSsemble DELlete LAYer
       (lt_dcltr "psdellay" "零件組合時刪除之圖層")
);defun
;;零件組合時刪除之圖塊
(defun c:psdelblk();Part aSsemble DELlete BLocK
       (lt_dcltr "psdelblk" "零件組合時刪除之圖塊")
);defun
;;自動拆圖時不拆之圖層
(defun c:auntklay();AUto NoT TaKe LAYer
       (lt_dcltr "auntklay" "自動拆圖時不拆之圖層")
);defun
;;不建立資訊點的圖層
(defun c:ncinplay();Non Create INformation Point LAYer
       (lt_dcltr "ncinplay" "不建立資訊點的圖層")
);defun
;;自動拆圖時不拆之圖塊
(defun c:auntkblk();AUto NoT TaKe BLocK
       (lt_dcltr "auntkblk" "自動拆圖時不拆之圖塊")
);defun

;;舊圖框屬性BLOCK名稱
(defun c:odshtblk();OlD SHeeT BLocK
       (lt_dcltr "odshtblk" "舊圖框屬性BLOCK名稱")
);defun

;;比例變動時會連動的BLOCK
(defun c:auto_ch_clk_scal()
       (lt_dcltr "auto_ch_clk_scal" "比例變動時會連動的BLOCK")
);defun


(defun lt_dcltr(dclname systemname /  #upperdata #process_temp     #downdata exe_st
                    #process_list        #s_word_set       #s_postword_set    gf_val        mm   cmdecho_v
                    exetrans_flag        #class_data_list  #class_name_list   #old_classdef #filterclassdef
                    #filterclassdata     #init_set_list
                  )

       (setq cmdecho_v (getvar "cmdecho"))
       (setvar "cmdecho" 0)
       (actdcl (strcat powdesign_DCL_PATH "system") dclname)
       (setq #upperdata nil)
       (setq #process_temp nil)
       (setq #downdata nil)
       (setq #mult_sel nil)
       (setq #mult_sel_one nil)
       (setq exe_st 0)
       ;(setq exetrans_flag 0)
       (setq gf_val nil)
       ;(setq #class_data_list nil)
       ;(setq #class_name_list nil)
       (setq #process_list nil)

       (if (/= (setq gf_val (vgetfile_val&lt_dcltr (strcat powdesign_PATH "system.ini") systemname)) nil)
           (progn
                (setq #process_list (read gf_val))
                (foreach mm #process_list
                         (setq #process_temp (append #process_temp (list (strcase mm)) ))
                );foreach
                (setq #process_list (acad_strlsort #process_temp))
           );progn        
       );if      

    
       (data_tobox&lt_dcltr)
       (setq linkflag&lt_dcltr nil)
       (action_tile "datalst"    "(setq linkflag&lt_dcltr t)(datalst_pro&lt_dcltr)")
       (action_tile "add"    "(add_pro&lt_dcltr)")
       (action_tile "mod"    "(mod_pro&lt_dcltr)")
       (action_tile "del"    "(del_pro&lt_dcltr)")
     
       (action_tile "accept" "(setq exe_st 1)(done_dialog)(write_systemini&lt_dcltr)")
       (action_tile "cancel" "(setq exe_st 0)(done_dialog)(unload_dialog dcL_id)")
       (start_dialog)
       (if (= exe_st 1)
           (lt_dcltr dclname systemname)
       );if      
       (setvar "cmdecho" cmdecho_v)
       (princ)
  );defun

  

 



(defun data_tobox&lt_dcltr()
       (start_List "datalst" 3)
       (mapcar 'add_list #process_list)
       (end_list)
       
);defun data_tobox&lt_dcltr




(defun datalst_pro&lt_dcltr(/ data_key mult_sel_one data_pro_temp)
     (if (/= #process_list nil)
         (progn
              (setq #mult_sel (read (strcat "(" (get_tile "datalst") ")")))
              (setq #mult_sel_one (car (reverse #mult_sel)))

             ; (foreach mm mult_sel;只做一個 loop
              (setq data_key (nth #mult_sel_one #process_list))
              (set_tile "datadef" data_key)
         );progn
    );if 
);defun datalst_pro&lt_dcltr


(defun add_pro&lt_dcltr(/ add_key total_list)
       (setq add_key (strcase (get_tile "datadef")))
       (if (and (/= add_key "")
                (= (member add_key #process_list) nil)
           );and        
           (progn
                (set_tile "datadef" "")
                (setq #process_list (cons  add_key  #process_list))
                (setq #process_list (acad_strlsort #process_list))
                (start_List "datalst" 3)
                (mapcar 'add_list #process_list)
                (end_list)
           );progn
           (alert "資料重覆或空白")
        );if
        (setq linkflag&lt_dcltr nil)
        
);defun cadd

(defun mod_pro&lt_dcltr(/ mod_key i olddatakey nth_data prs_temp)
       (setq mod_key (strcase (get_tile "datadef")))
       (if (and (= linkflag&lt_dcltr t)
                (/= mod_key "")
                (= (member mod_key #process_list) nil)
           );and
           (progn
                (setq prs_temp nil)
                (setq olddatakey (nth #mult_sel_one #process_list))
                (setq i 0)
                (while (/= (setq nth_data (nth i #process_list)) nil)
                       (setq i (1+ i))
                       (if (/= olddatakey nth_data)
                           (setq prs_temp (append prs_temp (list nth_data)))
                       );if
                );while
                
                (setq #process_list (cons  mod_key  prs_temp))
                (setq #process_list (acad_strlsort #process_list))
                (set_tile "datadef" "")
                (start_List "datalst" 3)
                (mapcar 'add_list #process_list)
                (end_list)
            );progn
           (alert "資料重覆或空白")
        );if
        (setq linkflag&lt_dcltr nil)
        
);defun mod
(defun del_pro&lt_dcltr(/  mm_data  delprs_temp i nth_data mm)
       (if (and (= linkflag&lt_dcltr t)
                (/= #mult_sel nil)
           );and
           (progn
                (setq delprs_temp nil)
                (foreach mm #mult_sel
                       (setq mm_data (nth mm #process_list))
                       (setq #process_list (subst  ""  mm_data  #process_list))
                       ;(setq #class_data_list (subst  "" (assoc mm_data  #class_data_list) #class_data_list))
                );foreach
                (setq i 0)
                
                (while (/= (setq nth_data (nth i #process_list)) nil)
                       (setq i (1+ i))
                       (if (/= "" nth_data)
                           (setq delprs_temp (append delprs_temp (list nth_data)))
                       );if
                );while
                (setq #process_list (acad_strlsort delprs_temp))
                (set_tile "datadef" "")      
                (start_List "datalst" 3)
                (mapcar 'add_list #process_list)
                (end_list)
                

           );progn
           (alert "無選擇資料!")
        );if
        (setq linkflag&lt_dcltr nil)
        (setq #mult_sel nil)
        
);defun cadd  

(defun vgetfile_val&lt_dcltr(fname initxt / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "system.ini檔案不存在")
                (exit)
           ) ;progn
    
       );if
  ;jacky
       (setq #textdef initxt)
       (setq needdata nil)
       (setq #downdata nil)
  ;jacky
 ; (setq data (read-line ff))
  (while (setq data (read-line ff))
    
    (setq #downdata (cons data #downdata))
    (if (/= nil (setq txtid (get_word data "=")))
      (progn
        (setq objdata (strcase (substr data 1 (- txtid 1))))
        (if (= objdata initxt)
            (progn
                 (setq dd data needdata (substr data (1+ txtid)) data nil)
                 (setq #downdata (cdr #downdata))
                 (setq #upperdata (reverse #downdata))
                 (setq #downdata nil)
            )  
           
        );if
      );progn
     
    );if
  );while
  (setq #downdata (reverse #downdata))
  (close ff)
  (setq a (list needdata))
  needdata
  
)

(defun write_systemini&lt_dcltr(/ ff num  temp mm prew postw w_list  w_word forlist class_ff assoc_data)
             
        (setq ff (open (strcat powdesign_path "system.ini") "w"))
        (setq num nil)
        (setq temp nil)
        (if (/= #process_list nil)
            (progn
                 (setq w_word (strcat #textdef "=" (list_tostring&lt_dcltr  #process_list )))
                 (setq forlist (append #upperdata (list w_word) #downdata))
            );progn
            (progn
                 (setq forlist (append #upperdata  #downdata))
            );progn
        );if  
        (foreach mm forlist
               (write-line mm ff)
        );foreach  
        (close ff)
     
);defun

(defun list_tostring&lt_dcltr(  arg / fi temp blank tran_str )
       (setq fi        0 )
       (setq temp      "")
       (setq blank     " ")
       (setq tran_str  "")
       
       (while (/=  (nth fi arg) nil)
              (progn
                   (if (= fi (1- (length arg)))
                       (setq blank "")
                   )      
                   (setq  tran_str (etos&lt_dcltr (nth fi arg)))
                   (setq temp  (strcat temp tran_str blank))
                   (setq fi (+ fi 1))
                
               );progn
        );while
  
        (setq temp  (strcat "(" temp " )"))
        temp
 );list_tostring&lt_dcltr

 (defun etos&lt_dcltr (arg / file)
     (if (= 'STR (type arg)) (setq arg (strcat "\"" arg "\"")))
     (setq  file (open "$" "w"))
     (princ arg  file)
     (close file)
     (setq file (open "$" "r"))
     (setq arg (read-line file))
     (close file)
     arg
);eots&fun1



(defun get_defpart()          ;;jackson 90.2.20
  (setq partdata (read (getfile_val (strcat POWdesign_path "SYSTEM.ini") "零件定義資料")))
  (setq tag_list '() txt_list '())
  (foreach nn partdata
    (setq txt1 (nth 2 nn)
          txt2 (nth 0 nn))
    (setq data1 (list txt1 txt2))
    (setq txt_list (cons data1 txt_list))
    (setq data (strcat txt1 "=" txt2)
          tag_list (cons data tag_list))

  )
  (setq tag_list (reverse tag_list))
  (setq txt_list (reverse txt_list))
  (list tag_list txt_list)
)
(defun get_infp_set()
  (setq lab_list '())
 ;;2001/3/12 (setq ff (open (strcat POWdesign_path "dwgdata.txt") "r"))
  (setq ff (open (strcat POWdesign_path "dataname.txt") "r"))
  (setq data (read-line ff))
  (while data
    (setq data1 (substr data 1 (- (get_word data ";") 1)))
    (setq data (substr data (1+ (get_word data ";"))))
    (setq lab_list (cons (strcat data1 "=" data) lab_list))
    (setq data (read-line ff))
  );while
  (close ff)
  (setq lab_list (cdr (reverse lab_list)))
)

;c:lt_prtdd****************************************************************************************************
;;;零件資料定義

(defun c:lt_prtdd(/ #upperdata #process_temp     #downdata exe_st   ltd_id
                    #process_list        #1st_set       #2nd_set    gf_val        mm   cmdecho_v
                    exetrans_flag        #class_data_list  #class_name_list   #old_classdef #filterclassdef
                    #filterclassdata     #init_set_list
               );Part Define Data

       (setq cmdecho_v (getvar "cmdecho"))
       (setvar "cmdecho" 1)

       (actdcl (strcat powdesign_DCL_PATH "system") "lt_prtdd")

      ; (mode_tile "add" 1)                        ;;jackso
       (mode_tile "del" 1)                        ;;jackso
       (mode_tile "mod" 1)                        ;;jackso
       (setq tag_list (nth 0 (get_defpart)))                              ;;jackson
       (act_pop_list tag_list "iptag-r")          ;;jackson
       (get_infp_set)                             ;;jackson
       (act_pop_list lab_list "msdbfn-r")          ;;jackson

       (setq #upperdata nil)
       (setq #process_temp nil)
       (setq #downdata nil)
       (setq exe_st 0)
       (setq gf_val nil)
       (setq #process_list nil)
       (setq car1_list '() cadr2_list '() caddr3_list '() cadddr4_list '())

       (if (/= (setq gf_val (vgetfile_val&lt_prtdd (strcat powdesign_PATH "system.ini") "零件定義資料")) nil)
           (progn
                (setq #process_list (read gf_val))
                (foreach mm #process_list
                         (setq car1 (strcase (car mm)))
                         (setq cadr2  (strcase (cadr mm)))
                         (setq caddr3  (strcase (caddr mm)))
                         (setq cadddr4  (strcase (cadddr mm)))

                         (if (or (= cadr2 nil) (= cadr2 "") );or
                             (setq cadr2 "***")
                         );if
                         (if (or (= cadddr4 nil) (= cadddr4 "") );or
                             (setq cadddr4 "***")
                         );if
                         (setq car1_list(cons car1 car1_list))      ;rex
                         (setq cadr2_list(cons cadr2 cadr2_list))   ;rex
                         (setq caddr3_list(cons caddr3 caddr3_list));rex
                         (setq cadddr4_list(cons cadddr4 cadddr4_list));rex

                         (setq #process_temp (cons (strcat car1 (col_tab (- 26 (strlen car1))) " => " cadr2 (col_tab (- 20 (strlen cadr2))) " => " caddr3 (col_tab (- 6 (strlen caddr3))) " => " cadddr4) #process_temp))
                       ;  (setq #process_temp (cons (strcat car1 " => " cadr2 " => " caddr3 " => " cadddr4) #process_temp))
                );foreach
                (setq #process_list (reverse #process_temp))
                (setq car1_list   (reverse car1_list))       ;rex
                (setq cadr2_list  (reverse cadr2_list))      ;rex
                (setq caddr3_list (reverse caddr3_list))     ;rex
                (setq cadddr4_list(reverse cadddr4_list))     ;rex
           );progn        
       );if      
  
       (setq #1st_set nil)
       (setq #2nd_set nil)
       (setq #3rd_set nil)
       (setq #4th_set nil)

    ;   (to_boxdata&lt_prtdd)
       (act_pop_list #process_list "ltd")          ;;rex
       (iptag_init)
       (msdbfn_init)

       (action_tile "ltd" "(setq ltd_id $value)(ltd_edit_link&lt_prtdd)")
  
       (action_tile "add" "(addpro&lt_prtdd)")
       (action_tile "mod" "(modpro&lt_prtdd)")
       (action_tile "del" "(delpro&lt_prtdd)")
       (action_tile "fieldset" "(c:fieldset)(get_infp_set)(act_pop_list lab_list \"msdbfn-r\")")
       (action_tile "accept" "(setq exe_st 1)(done_dialog)(write_systemini&lt_prtdd)")
       (action_tile "cancel" "(setq exe_st 0)(done_dialog)(unload_dialog dcL_id)")
       (start_dialog)
       (if (= exe_st 1)
           (c:lt_prtdd)
       );if      
       (setvar "cmdecho" cmdecho_v)
       (princ)
  );defun


  (defun iptag_init()
       (setq #iptag_init_value (list "TAG1" "TAG2" "TAG3" "TAG4" "TAG5" "TAG6" "TAG7" "TAG8" "TAG9" "TAG10" "TAG11" "TAG12" "TAG13" "TAG14" "TAG15"))
       (start_List "iptag" 3)
       (mapcar 'add_list #iptag_init_value)
       (end_list)
  );defun
  (defun msdbfn_init()
       (setq #msdbfn_init_value (list "" "A_02" "A_03" "A_04" "A_05" "A_06" "A_07" "A_08" "A_09" "A_10"         ;;JACKSON
                                         "A_11" "A_12" "A_13" "A_14" "A_15"
                                );list
       );setq                                                                                              ;;JACKSON
    ;   (setq #msdbfn_init_value (list "" "A_02" "A_03" "A_04" "A_05" "A_06" "A_07" "A_08" "A_09" "A_10"         ;;JACKSON
    ;                                     "A_11" "A_12" "A_13" "A_14" "A_15" "A_16" "A_17" "A_18" "A_19" "A_20"
    ;                                     "A_21" "A_22" "A_23" "A_24" "A_25" "A_26" "A_27" "A_28" "A_29" "A_30"
    ;                                     "A_31" "A_32" "A_33" "A_34" "A_35" "A_36" "A_37" "A_38" "A_39" "A_40"
    ;                                     "A_41" "A_42" "A_43" "A_44" "A_45" "A_46" "A_47" "A_48" "A_49" "A_50"
    ;                            );list                                                                        ;;JACKSON
    ;   );setq
       (start_List "msdbfn" 3)
       (mapcar 'add_list #msdbfn_init_value)
       (end_list)
  )
  (defun trans_strtolist&lt_prtdd (/ ff  num     mm       w_word   temp      prew    postw    w_list  temp&S temp&L 
                                    1st_num  1st_word 2nd_word post_temp 2nd_num 3rd_word forlist 
                                 )
             
        (setq num nil)
        (setq temp nil)
        (setq temp&L nil)
       
        (if (/= #process_list nil)
            (progn
                 (foreach mm #process_list
                        (setq num      (string_search&lt_prtdd  mm "=>"))
                        (setq 1st_word (str_trim_blank&lt_prtdd (substr mm 1 (1- num))))
                        (setq mm       (str_trim_blank&lt_prtdd (substr mm (+  num 3))))
                        (setq num      (string_search&lt_prtdd  mm "=>"))
                        (setq 2nd_word (str_trim_blank&lt_prtdd (substr mm 1 (1- num))))
                        (setq mm       (str_trim_blank&lt_prtdd (substr mm (+  num 3))))
                        (setq num      (string_search&lt_prtdd  mm "=>"))
                        (setq 3rd_word (str_trim_blank&lt_prtdd (substr mm 1 (1- num))))
                        (setq 4th_word (str_trim_blank&lt_prtdd (substr mm (+  num 3))))
                        (if (= 2nd_word "***")
                            (setq 2nd_word "")
                        );if
                        (if (= 4th_word "***")
                            (setq 4th_word "")
                        );if
                   
                        (setq 1st_word (etos&lt_prtdd (strcase 1st_word)))
                        (setq 2nd_word (etos&lt_prtdd (strcase 2nd_word)))
                        (setq 3rd_word (etos&lt_prtdd (strcase 3rd_word)))
                        (setq 4th_word (etos&lt_prtdd (strcase 4th_word)))
                   
                        (setq temp&L   (cons (list 1st_word 2nd_word 3rd_word 4th_word ) temp&L))
 
                 );foreach
                 (setq temp&L (reverse temp&L))

                 
             );progn
           
        );if
        (setq #process_list temp&L)
        
);trans_strtolist&lt_prtdd


  (defun addpro&lt_prtdd(/ pnamingdata sheetattrdata insdata s_num 1st_word 2nd_word i)
         (pnaming_sheetattr_init&lt_prtdd)
         (setq pnamingdata (strcase (get_tile "pnaming")))
         (setq sheetattrdata (strcase (get_tile "sheetattr")))
         (setq iptagdata (nth (atoi (get_tile "iptag")) #iptag_init_value ))
         (setq msdbfndata (nth (atoi (get_tile "msdbfn")) #msdbfn_init_value ))
         (if (and (not (member pnamingdata    #1st_set))
                  (not (member sheetattrdata  #2nd_set))
                  (not (member iptagdata   #3rd_set))
                  (not (member msdbfndata #4th_set))
                  (/=  pnamingdata    "")
                  (/=  iptagdata   "")
             );and        
             (progn
                  (if (= sheetattrdata "")
                      (setq sheetattrdata "***")
                  );if
                  (if (= msdbfndata "")
                      (setq msdbfndata "***")
                  )

                  (setq insdata (strcat pnamingdata (col_tab (- 26 (strlen pnamingdata))) " => " sheetattrdata (col_tab (- 20 (strlen sheetattrdata))) " => " iptagdata (col_tab (- 6 (strlen iptagdata))) " => " msdbfndata));rex

                  (insert_data_to_list_lt_prtdd)

                  (act_pop_list #process_list "ltd")          ;;rex
                  (set_tile "ltd" (itoa insdata_id ))     ;;rex
                  (setq ltd_id insdata_id )              ;;rex

                ;  (setq insdata (strcat pnamingdata " => " sheetattrdata " => " iptagdata " => " msdbfndata))
                ;  (setq #process_list (append #process_list (list insdata)))
                ;  (setq #process_list (acad_strlsort #process_list))
                ;  (start_list "ltd" 3 )
                ;  (mapcar 'add_list #process_list)
                ;  (end_list)
             );progn
             (progn

                  (if (member pnamingdata #1st_set)
                      (alert (strcat  pnamingdata "稱謂資料重覆!!"))
                  );if
                  (if (member sheetattrdata #2nd_set)
                      (alert (strcat  sheetattrdata "圖框屬性資料重覆!!"))
                  );if
                  (if (member iptagdata #3rd_set)
                      (alert (strcat  iptagdata "資訊點標籤資料重覆!!"))
                  );if
                  (if (member msdbfndata #4th_set)
                      (alert (strcat msdbfndata  "物料結構資料庫欄位名稱資料重覆!!"))
                  );if
                  (if (= pnamingdata "")
                      (alert (strcat  pnamingdata "稱謂資料空白!!"))
                  );if  
                  (if (= iptagdata "")
                      (alert (strcat  iptagdata "資訊點標籤資料空白!!"))
                  );if
               

             );progn  
               
          );if
        
   );defun

;;rex 2001/2/5
(defun insert_data_to_list_lt_prtdd( / i $car1_list $cadr2_list $caddr3_list $cadddr4_list $#process_list)
                  (setq i 1)
                  (while (null (setq insdata_id(list_id (strcat "TAG" (itoa (- (atoi (substr iptagdata 4)) i))) caddr3_list)))
                         (setq i (+ i 1))
                  );while
                  (setq i 0 $car1_list '() $cadr2_list '() $caddr3_list '() $cadddr4_list '() $#process_list '())
                  (repeat (length #process_list)
                          (setq $car1_list  (cons  (nth i car1_list) $car1_list))
                          (setq $cadr2_list (cons  (nth i cadr2_list) $cadr2_list))
                          (setq $caddr3_list(cons  (nth i caddr3_list) $caddr3_list))
                          (setq $cadddr4_list(cons  (nth i cadddr4_list) $cadddr4_list))
                          (setq $#process_list  (cons  (nth i #process_list) $#process_list))
                          (if (= insdata_id (+ i 1))
                              (setq $car1_list  (cons  pnamingdata $car1_list)
                                    $cadr2_list (cons  sheetattrdata $cadr2_list)
                                    $caddr3_list(cons  iptagdata $caddr3_list)
                                    $cadddr4_list(cons  msdbfndata $cadddr4_list)
                                    $#process_list  (cons insdata $#process_list)
                              );setq
                          );if
                          (setq  i (+ i 1))
                  );repeat
                  (setq car1_list (reverse $car1_list))
                  (setq cadr2_list (reverse $cadr2_list))
                  (setq caddr3_list (reverse $caddr3_list))
                  (setq cadddr4_list (reverse $cadddr4_list))
                  (setq #process_list (reverse $#process_list))
);defun

   (defun get_sublist_num&lt_prtdd(be_searched_list object / count sear_data flag)
        (setq count 0)
        (setq real_count nil)
        (setq flag  t)
        (while (and flag
                    (/= be_searched_list nil)
                    (/= object           nil)
                    (/= (setq sear_data (nth count be_searched_list)) nil)
                    ;(/= (setq sear_data (nth count be_searched_list)) object)
               );and
               (if (= sear_data object)
                   (progn
                        (setq flag nil)
                        (setq real_count count)
                   );progn
               );if      
               (setq count (1+ count))
        );while
        real_count          
       
   );defun
   ;ltd之dialog 與 oldlay.newlay之 editbox 資料互動之結

   (defun ltd_edit_link&lt_prtdd(/ ltd_no ltd_word ltd_word_temp s_num pnamingdata sheetattrdata iptagdata msdbfndata seek_p seek_p1)
         (setq ltd_no (get_tile "ltd"));ltd_no: LTypeDefine_Number
         (setq ltd_word (nth (atoi ltd_no) #process_list))
         (setq s_num (string_search&lt_prtdd  ltd_word "=>"))
         (setq pnamingdata   (str_trim_blank&lt_prtdd (substr  ltd_word 1 (1- s_num))))
         (setq ltd_word (str_trim_blank&lt_prtdd (substr  ltd_word (+ s_num 3))))
         (setq s_num (string_search&lt_prtdd  ltd_word "=>"))
         (setq sheetattrdata   (str_trim_blank&lt_prtdd (substr  ltd_word 1 (1- s_num))))
         (setq ltd_word (str_trim_blank&lt_prtdd (substr  ltd_word (+ s_num 3))))
         (setq s_num (string_search&lt_prtdd  ltd_word "=>"))
         (setq iptagdata   (str_trim_blank&lt_prtdd (substr  ltd_word 1 (1- s_num))))
         (setq msdbfndata (str_trim_blank&lt_prtdd (substr  ltd_word (+ s_num 3))))
         (if (= sheetattrdata "***")
             (setq sheetattrdata "")
         );if
         (if (= msdbfndata "***")
             (setq msdbfndata "")
         );if  
         (set_tile "pnaming" pnamingdata)
         (set_tile "sheetattr" sheetattrdata)
         (setq seek_p (get_sublist_num&lt_prtdd #iptag_init_value iptagdata))
         (if (/= seek_p nil)
             (set_tile "iptag" (rtos seek_p 2 0 ))
             (alert (strcat "\n " iptagdata "資料不存在!!\n"))
         );if  
         ;(set_tile "iptag" iptagdata)
         (setq seek_p1 (get_sublist_num&lt_prtdd #msdbfn_init_value msdbfndata))
         (if (/= seek_p1 nil)
             (set_tile "msdbfn" (rtos seek_p1 2 0))
             (alert (strcat "\n " msdbfndata "資料不存在!!\n"))
         );if  
         ;(set_tile "msdbfn" msdbfndata)

         (cond
           ((or (= (strcase iptagdata) "TAG1")
                 (= (strcase iptagdata) "TAG2"))
                  (mode_tile "mod"        1)
                  (mode_tile "add"        1)
                  (mode_tile "del"        1) 
                  (mode_tile "pnaming"    1)
                  (mode_tile "sheetattr"  0)
                  (mode_tile "iptag"      1)
                  (mode_tile "msdbfn"     0))
            ((= (strcase iptagdata) "TAG3")
                  (mode_tile "mod"        0)
                  (mode_tile "add"        1)
                  (mode_tile "del"        1) 
                  (mode_tile "pnaming"    1)
                  (mode_tile "sheetattr"  0)
                  (mode_tile "iptag"      1)
                  (mode_tile "msdbfn"     0))
             (T
                  (mode_tile "mod"        0)
                  (mode_tile "add"        0)
                  (mode_tile "del"        0) 
                  (mode_tile "pnaming"    0)
                  (mode_tile "sheetattr"  0)
                  (mode_tile "iptag"      0)
                  (mode_tile "msdbfn"     0))
         );cond
   );defun

   (defun string_search&lt_prtdd(string search_s / prt flag string_len search_s_len find_s)
     (if (and (/= string "")
              (/= search_s "")
              (/= string nil)
              (/= search_s nil)
          );and
          (progn
               (setq prt 1)
               (setq retprt nil)
               (setq flag nil)
               (setq string_len (strlen string))
               (setq search_s_len (strlen search_s))
               (while (/= (setq find_s (substr string prt search_s_len)) "")
                    (if (=  find_s search_s)
                        (progn
                             (setq retprt prt)
                             (setq flag t)
                             (setq prt (1+ string_len))
                        );progn  
                    );if
                    (setq prt (1+ prt))
               );while
          );progn
          (progn
               (setq flag nil)
          );progn
     );if
     retprt
);defun
               
          



 
  (defun modpro&lt_prtdd(/ num   oldstr pnamingdata    sheetattrdata insdata
                          s_num 1st_word 2nd_word process_list_temp&lt_prtdd
                       );modpro
    
         (mode_tile "add"        0)
         (mode_tile "del"        0) 
         (mode_tile "pnaming"    0)
         (mode_tile "sheetattr"  0)
         (mode_tile "iptag"      0)
         (mode_tile "msdbfn"     0)
         (setq num     (get_tile "ltd"))
         
         
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (setq process_list_temp&lt_prtdd  #process_list)

                  ;(setq oldstr  (nth (atoi num) #process_list))
                  (setq pnamingdata (strcase (get_tile "pnaming")))
                  (setq sheetattrdata (strcase (get_tile "sheetattr")))
                  ;(setq iptagdata (strcase (get_tile "iptag")))
                  (setq iptagdata (nth (atoi (get_tile "iptag")) #iptag_init_value ))
                  ;(setq msdbfndata (strcase (get_tile "msdbfn")))
                  (setq msdbfndata (nth (atoi (get_tile "msdbfn")) #msdbfn_init_value ))
         
                  (if (and 
                         (/= pnamingdata "")
                         ;(/= sheetattrdata "")
                         (/= iptagdata "")
                         ;(/= msdbfndata "")
                      );and       
                      (progn
                         ; (setq #process_list (remove_one&lt_prtdd  #process_list (nth (atoi num) #process_list)   ))
                          (pnaming_sheetattr_init&lt_prtdd)
                        
                          (cond
                                  ((and   (= (member pnamingdata    (removelist (nth (atoi num) car1_list) car1_list)) nil)
                                          (= (member sheetattrdata  (removelist (nth (atoi num) cadr2_list) cadr2_list)) nil)
                                          (= (member iptagdata   (removelist (nth (atoi num) caddr3_list) caddr3_list)) nil)
                                          (= (member msdbfndata (removelist (nth (atoi num)  cadddr4_list) cadddr4_list)) nil)
                                          );and   
                                          (progn

                                               (setq car1_list     (removelist (nth (atoi num) car1_list)     car1_list    ));
                                               (setq cadr2_list    (removelist (nth (atoi num) cadr2_list)    cadr2_list   ));
                                               (setq caddr3_list   (removelist (nth (atoi num) caddr3_list)   caddr3_list  ));
                                               (setq cadddr4_list  (removelist (nth (atoi num) cadddr4_list)  cadddr4_list ));
                                               (setq #process_list (removelist (nth (atoi num) #process_list) #process_list));

                                               (if (= sheetattrdata "")
                                                   (setq sheetattrdata "***")
                                               );if
                                               (if (= msdbfndata "")
                                                   (setq msdbfndata "***")
                                               );if

                                               (setq insdata (strcat pnamingdata (col_tab (- 26 (strlen pnamingdata))) " => " sheetattrdata (col_tab (- 20 (strlen sheetattrdata))) " => " iptagdata (col_tab (- 6 (strlen iptagdata))) " => " msdbfndata));rex

                                               (insert_data_to_list_lt_prtdd)

                                               (act_pop_list #process_list "ltd")          ;;rex
                                               (set_tile "ltd" (itoa insdata_id ))     ;;rex
                                               (setq ltd_id insdata_id )              ;;rex


                                          ;     (setq insdata (strcat pnamingdata " => " sheetattrdata " => " iptagdata " => " msdbfndata))
                                          ;     (setq #process_list (cons  insdata #process_list))
                                          ;     (setq #process_list (acad_strlsort #process_list))
                                          ;     (start_list "ltd" 3)
                                          ;     (mapcar 'add_list #process_list)
                                          ;     (end_list)
                                          );progn
                                  );1 
                                  (t
                                         (progn
                                              (setq aa #1st_set bb #2nd_set cc #3rd_set dd #4th_set)
                                              (setq #process_list process_list_temp&lt_prtdd)
                                              (if (/= (member pnamingdata   #1st_set) nil)
                                                  (alert (strcat  pnamingdata  "資料重覆"))
                                              );if
                                              (if (/= (member sheetattrdata   #2nd_set) nil)
                                                  (alert (strcat  sheetattrdata  "資料重覆"))
                                              );if
                                              (if (/= (member iptagdata   #3rd_set) nil)
                                                  (alert (strcat  iptagdata  "資料重覆"))
                                              );if
                                              (if (/= (member msdbfndata   #4th_set) nil)
                                                  (alert (strcat  msdbfndata  "資料重覆"))
                                              );if
                                                     
                                             
                                             
                                              
                                         );progn
                                  );4 
                  
                                              
                           );cond

                      );progn
                      (progn
                           (if (= pnamingdata "")
                               (alert (strcat  pnamingdata "資料空白"))
                           );if  
                          ; (if (= sheetattrdata "")
                          ;     (alert (strcat  sheetattrdata "資料空白"))
                          ; );if
                           (if (= iptagdata "")
                               (alert (strcat  iptagdata "資料空白"))
                           );if
                           ;(if (= msdbfndata "")
                           ;    (alert (strcat  msdbfndata "資料空白"))
                           ;);if
                       );progn  
                           
                   ) ;if
               );progn
          );if

  );defun

  (defun delpro&lt_prtdd(/  num num_list mm insdata s_num 1st_word 2nd_word)
         (setq num     (get_tile "ltd")) ;; = ltd_id

         (setq car1_list     (removelist (nth (atoi num) car1_list)     car1_list    ));
         (setq cadr2_list    (removelist (nth (atoi num) cadr2_list)    cadr2_list   ));
         (setq caddr3_list   (removelist (nth (atoi num) caddr3_list)   caddr3_list  ));
         (setq cadddr4_list  (removelist (nth (atoi num) cadddr4_list)  cadddr4_list ));
         (setq #process_list (removelist (nth (atoi num) #process_list) #process_list));

         (act_pop_list #process_list "ltd")          ;;rex
         (if (>= (atoi num) (length #process_list))
             (set_tile "ltd" (itoa (- (atoi num) 1)))     ;;rex
             (set_tile "ltd" (itoa (atoi num)))     ;;rex
         );if
         (setq ltd_id (atoi num))              ;;rex
         (ltd_edit_link&lt_prtdd)

       ;  (setq num_list (read (strcat "(" num ")")))
       ;  (if (and (/= #process_list nil)
       ;           (/= num "")
       ;      );and
       ;      (progn
       ;           (foreach mm num_list
       ;                (setq insdata (nth mm #process_list))
       ;                (setq #process_list (subst  "" (nth mm #process_list)  #process_list ))
       ;
       ;           );foreach
       ;           (setq #process_list (remove_one&lt_prtdd #process_list ""))
       ;           (start_List "ltd" 3)
       ;           (mapcar 'add_list #process_list)
       ;           (end_list)
       ;      );progn
       ;  );if
       ;  (setq num_list nil)
  );defun


  (defun to_boxdata&lt_prtdd(/ mm s_num 1st_word 2nd_word)
        (if (/= #process_list "")
            (progn
                 (start_list "ltd" 3)
                 (mapcar 'add_list #process_list)
                 (end_list)
            );progn
        );if  
  );defun


  (defun vgetfile_val&lt_prtdd(fname initxt / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "system.ini檔案不存在")
                (exit)
           ) ;progn
    
       );if
  ;jacky
       (setq #textdef initxt)
       (setq needdata nil)
       (setq #downdata nil)
  ;jacky
  (while (setq data (read-line ff))
    
    (setq #downdata (cons data #downdata))
    (if (/= nil (setq txtid (get_word data "=")))
      (progn
        (setq objdata (strcase (substr data 1 (- txtid 1))))
        (if (= objdata initxt)
            (progn
                 (setq dd data needdata (substr data (1+ txtid)) data nil)
                 (setq #downdata (cdr #downdata))
                 (setq #upperdata (reverse #downdata))
                 (setq #downdata nil)
            );progn  
           
        );if
      );progn
     
    );if
  );while
  (setq #downdata (reverse #downdata))
  (close ff)
  needdata
  
);defun

(defun *error* (msg)
       (princ)
);defun

(defun write_systemini&lt_prtdd(/ ff num  temp mm prew postw w_list  w_word forlist class_ff assoc_data needlist partdata titletxt_list default_list noneedlist notxt txt dbcol)

        (setq ff (open (strcat powdesign_path "system.ini") "w"))
        (setq num nil)
        (setq temp nil)
        (if (/= #process_list nil)
            (progn
                 (trans_strtolist&lt_prtdd)
                 (setq w_word (strcat #textdef "=" (list_tostring&lt_prtdd  #process_list )))
                 (if (= #upperdata nil)
                     (progn
                          (setq #upperdata  #downdata)
                          (setq #downdata nil)
                     );progn
                 );if
                 (setq forlist (append #upperdata (list w_word) #downdata))
            );progn
            (progn
                 (setq forlist (append #upperdata  #downdata))
            );progn
        );if  
        (foreach mm forlist
               (write-line mm ff)
        );foreach  
        (close ff)
;;;重新定義 title.txt 2001/3/12
        (setq partdata (read (getfile_val (strcat POWdesign_path "SYSTEM.ini") "零件定義資料")))
        (setq titletxt_list (cddr partdata) needlist (list "層名"))
        (foreach nn titletxt_list
          (progn
            (setq txt (nth 0 nn))
       ;    (if (= "#" (substr txt 1 1))(setq txt (substr txt 2)))
            (setq needlist (cons txt needlist))
          );progn
        );foreach
        (setq needlist (reverse needlist))
        (setq default_list (list (nth 0 needlist) (nth 1 needlist)))
        (setq needlist (cddr needlist))
        (setq needlist (append default_list needlist))
        (setq txt (car needlist))
        (setq needlist (cdr needlist))
        (foreach nn needlist
          (setq txt (strcat txt ";" nn))
          (setq dbcol (nth 3 (assoc nn partdata)))
        );foreach
        (setq ff (open (strcat POWDESIGN_path "title.txt") "w"))
        (write-line txt ff)
        (princ txt)
        (if (/= 0 (length noneedlist))
          (progn
            (setq noneedlist (reverse noneedlist))
            (setq notxt (car noneedlist))
            (setq noneedlist (cdr noneedlist))
            (foreach nn noneedlist
              (setq notxt (strcat notxt ";" nn))
            );foreach
            (write-line notxt ff)
          );progn
          (write-line "" ff)
        );if
        (close ff)


);defun

(defun list_tostring&lt_prtdd(  arg / fi temp blank tran_str )
       (setq fi        0 )
       (setq temp      "")
       (setq blank     " ")
       (setq tran_str  "")
       
       (while (/=  (nth fi arg) nil)
              (progn
                   (if (= fi (1- (length arg)))
                       (setq blank "")
                   )
                   (setq  tran_str (etos&lt_prtdd (nth fi arg)))
                   (setq temp  (strcat temp tran_str blank))
                   (setq fi (+ fi 1))
                
               );progn
        );while
  
        (setq temp  (strcat "(" temp " )"))
        temp
 );list_tostring&fun1

 (defun etos&lt_prtdd (arg / file)
     (if (= 'STR (type arg)) (setq arg (strcat "\"" arg "\"")))
     (setq  file (open "$" "w"))
     (princ arg  file)
     (close file)
     (setq file (open "$" "r"))
     (setq arg (read-line file))
     (close file)
     arg
);eots&fun1

(defun pnaming_sheetattr_init&lt_prtdd(/ s_num 1st_word 2nd_word)
     (setq #1st_set     nil)
     (setq #2nd_set     nil)
     (setq #3rd_set     nil)
     (setq #4th_set     nil)
     (foreach mm #process_list
            (setq s_num (string_search&lt_prtdd mm "=>"))
            (setq 1st_word (str_trim_blank&lt_prtdd (strcase (substr  mm 1 (1- s_num)))))
            (setq mm       (str_trim_blank&lt_prtdd (strcase (substr  mm   (+ s_num 3)))))
            (setq s_num (string_search&lt_prtdd mm "=>"))
            (setq 2nd_word (str_trim_blank&lt_prtdd (strcase (substr  mm 1 (1- s_num)))))
            (setq mm       (str_trim_blank&lt_prtdd (strcase (substr  mm   (+ s_num 3)))))
            (setq s_num (string_search&lt_prtdd mm "=>"))
            (setq 3rd_word (str_trim_blank&lt_prtdd (strcase (substr  mm 1 (1- s_num)))))
            (setq 4th_word (str_trim_blank&lt_prtdd (strcase (substr  mm   (+ s_num 3)))))
           ; (setq 1st_word (str_trim_blank&lt_prtdd 1st_word))
           ; (setq 2nd_word (str_trim_blank&lt_prtdd 2nd_word))
            (setq #1st_set     (append #1st_set     (list 1st_word)))
            (setq #2nd_set     (remove_one&lt_prtdd  (append #2nd_set (list 2nd_word)) "***"))
            (setq #3rd_set     (append #3rd_set     (list 3rd_word)))
            (setq #4th_set     (remove_one&lt_prtdd  (append #4th_set (list 4th_word)) "***"))
            ;(setq #4th_set     (append #4th_set     (list 4th_word)))
     );foreach
);defun

(defun str_trim_blank&lt_prtdd(str / lprt rprt retstr)
     (setq Lprt 1)
     (setq rprt (strlen str))
     (while (= (substr str Lprt 1) " ")
            (setq Lprt (1+ Lprt))
     );while
     (while (= (substr str rprt 1) " ")
            (setq rprt (1- rprt))
     );while
    
     (setq retstr (substr str Lprt (1+ (- rprt Lprt))))
     retstr
);defun

(defun remove_one&lt_prtdd (li obj / i ret_list nthdata)
     (setq i 0)
     (setq ret_list nil)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= nthdata obj) 
              (setq ret_list (append ret_list (list nthdata)))
          );if
          (setq i (1+ i))
     );while
     ret_list
);defun  
  
                          
          

             
 ;c:goac_inp************************************************************************                      



(defun c:goac_inp(/ #upperdata #process_temp     #downdata exe_st
                    #process_list        #1st_set       #2nd_set    gf_val        mm   cmdecho_v
                    exetrans_flag        #class_data_list  #class_name_list   #old_classdef #filterclassdef
                    #filterclassdata     #init_set_list
               );Get Olddraw Atrribute Create INformation Point
  

       (setq cmdecho_v (getvar "cmdecho"))
       (setvar "cmdecho" 0)
       (actdcl (strcat powdesign_DCL_PATH "system") "goac_inp")


       (setq #upperdata nil)
       (setq #process_temp nil)
       (setq #downdata nil)
       (setq exe_st 0)
       (setq gf_val nil)
       (setq #process_list nil)

       (if (/= (setq gf_val (vgetfile_val&goac_inp (strcat powdesign_PATH "system.ini") "取舊圖框屬性建資訊點")) nil)
           (progn
                (setq #process_list (read gf_val))
                ;(setq loop_3_head_i 1)
                (foreach mm #process_list
                         (setq car1 (strcase (car mm)))
                         (setq cadr2  (strcase (cadr mm)))
                         (setq caddr3  (strcase (caddr mm)))
                         (if (or (= cadr2 nil)
                                 (= cadr2 "")
                             );or
                             (setq cadr2 "***")
                         );if
                         
                         ; (if (<= loop_3_head_i 3)
                         ;     (setq #process_temp (cons (strcat (strcat "!   " car1 ) " => " cadr2 " => " caddr3 ) #process_temp))
                         (setq #process_temp (cons (strcat car1 " => " cadr2 " => " caddr3 ) #process_temp))
                         ;);if
                         ;(setq loop_3_head_i (1+ loop_3_head_i))
                );foreach
                ;(setq #process_list (reverse #process_temp))
                (setq #process_list (acad_strlsort #process_temp))
           );progn        
       );if      
  
       (setq #1st_set nil)
       (setq #2nd_set nil)
       (setq #3rd_set nil)
       ;(setq #4th_set nil)
     
       (to_boxdata&goac_inp)
       (inptag_init) 
       ;(mode_tile "add" 0)
       ;(mode_tile "mod" 1)
       ;(mode_tile "del" 1)

       (action_tile "ltd" "(ltd_edit_link&goac_inp)")
  
       (action_tile "add" "(addpro&goac_inp)")
       (action_tile "mod" "(modpro&goac_inp)")
       (action_tile "del" "(delpro&goac_inp)")
       (action_tile "accept" "(setq exe_st 1)(done_dialog)(write_systemini&goac_inp)")
       (action_tile "cancel" "(setq exe_st 0)(done_dialog)(unload_dialog dcL_id)")
       (start_dialog)
       (if (= exe_st 1)
           (c:goac_inp)
       );if      
       (setvar "cmdecho" cmdecho_v)
       (princ)
  );defun

 ;| (defun tran_listtostr&goac_inp(/ mm  process_temp 2nd_wp 2nd_wp_num )
 ;
 ;       (if (/= #Process_list nil)
 ;          (progn
 ;               (setq process_temp nil)
 ;               (foreach mm #Process_list
 ;                        (setq process_temp (cons (strcat (strcase (car mm)) " => " (strcase (cadr mm)) " => " (strcase (caddr mm)) " => " (strcase (cadddr mm))) process_temp))
 ;               )
 ;               (setq #Process_list (reverse process_temp))
 ;          );progn
 ;
 ;      );if
 ;
 ; );defun tran_listtostr&goac_inp|;

  (defun inptag_init()
       (setq #inptag_init_value (list "TAG1" "TAG2" "TAG3" "TAG4" "TAG5" "TAG6" "TAG7" "TAG8" "TAG9" "TAG10" "TAG11" "TAG12" "TAG13" "TAG14" "TAG15"))
       (start_List "inptag" 3)
       (mapcar 'add_list #inptag_init_value)
       (end_list)
  );defun  
  (defun trans_strtolist&goac_inp (/ ff  num     mm       w_word   temp      prew    postw    w_list  temp&S temp&L 
                                    1st_num  1st_word 2nd_word post_temp 2nd_num 3rd_word forlist 
                                 )
             
       ;(if (= (type (car #process_list)) 'list)
       ;     (tran_listtostr&goac_inp)
;       );if  
        (setq num nil)
        (setq temp nil)
        (setq temp&L nil)
       
        (if (/= #process_list nil)
            (progn
                 (foreach mm #process_list
                        (setq num      (string_search&goac_inp  mm "=>"))
                        (setq 1st_word (str_trim_blank&goac_inp (substr mm 1 (1- num))))
                        (setq mm       (str_trim_blank&goac_inp (substr mm (+  num 3))))
                        (setq num      (string_search&goac_inp  mm "=>"))
                        (setq 2nd_word (str_trim_blank&goac_inp (substr mm 1 (1- num))))
                        (setq 3rd_word (str_trim_blank&goac_inp (substr mm (+  num 3))))
                        ;(setq num      (string_search&goac_inp  mm "=>"))
                        ;(setq 3rd_word (str_trim_blank&goac_inp (substr mm 1 (1- num))))
                        ;(setq 4th_word (str_trim_blank&goac_inp (substr mm (+  num 3))))
                       ; (if (= 1st_word "***")
                ;           (setq 1st_word "")
                ;       );if
                        (if (= 2nd_word "***")
                            (setq 2nd_word "")
                        );if
                ;        (if (= 3rd_word "***")
                ;           (setq 3rd_word "")
                ;       );if
                ;        (if (= 4th_word "***")
                ;           (setq 4th_word "")
                ;       );if
                   
                        (setq 1st_word (etos&goac_inp (strcase 1st_word)))
                        (setq 2nd_word (etos&goac_inp (strcase 2nd_word)))
                        (setq 3rd_word (etos&goac_inp (strcase 3rd_word)))
                        ;(setq 4th_word (etos&goac_inp (strcase 4th_word)))
                   
                        (setq temp&L   (cons (list 1st_word 2nd_word 3rd_word ) temp&L))
 
                 );foreach
                 (setq temp&L (reverse temp&L))

                 
             );progn

        );if
        (setq #process_list temp&L)
        
);trans_strtolist&goac_inp

 
  (defun addpro&goac_inp(/ namingdata oldattrdata insdata s_num 1st_word 2nd_word)
         (naming_oldattr_init&goac_inp)
         (setq namingdata (strcase (get_tile "naming")))
         (setq oldattrdata (strcase (get_tile "oldattr")))
         ;(setq inptagdata (strcase (get_tile "inptag")))
         (setq inptagdata (nth (atoi (get_tile "inptag")) #inptag_init_value ))
         ;(setq vfydatetagdata (strcase (get_tile "vfydatetag")))
       ;  ;|(if (= namingdata "")
       ;      (setq namingdata "***")
       ;  );if
       ;  (if (= oldattrdata "")
       ;      (setq oldattrdata "***")
       ;  )
       ;  (if (= inptagdata "")
       ;      (setq inptagdata "***")
       ;  )
       ;  (if (= vfydatetagdata "")
       ;      (setq vfydatetagdata "***")
       ;  )|;
         (if (and (not (member namingdata    #1st_set))
                  (not (member oldattrdata  #2nd_set))
                  (not (member inptagdata   #3rd_set))
                  ;(not (member vfydatetagdata #4th_set))
                  (/=  namingdata    "")
                  (/=  inptagdata   "")
                  ;(/=  vfydatetagdata "")
             );and        
             (progn
                  (if (= oldattrdata "")
                      (setq oldattrdata "***")
                  );if
                  ;(setq insdata (strcat namingdata " => " oldattrdata " => " inptagdata " => " vfydatetagdata))
                  (setq insdata (strcat namingdata " => " oldattrdata " => " inptagdata ))
                  (setq #process_list (append #process_list (list insdata)))
                  (setq #process_list (acad_strlsort #process_list))
                  (start_list "ltd" 3 )
                  (mapcar 'add_list #process_list)
                  (end_list)
             );progn
             (progn

                  (if (member namingdata #1st_set)
                      (alert (strcat  namingdata "稱謂資料重覆!!"))
                  );if
                  (if (member oldattrdata #2nd_set)
                      (alert (strcat  oldattrdata "舊圖框屬性資料重覆!!"))
                  );if
                  (if (member inptagdata #3rd_set)
                      (alert (strcat  inptagdata "資訊點標籤資料重覆!!"))
                  );if
                 ; (if (member vfydatetagdata #4th_set)
                 ;     (alert (strcat vfydatetagdata  "圖框審核日期標籤資料重覆!!"))
                 ; );if
                  (if (= namingdata "")
                      (alert (strcat  namingdata "稱謂資料空白!!"))
                  );if  
                  ;(if (= oldattrdata "")
                  ;    (alert (strcat  oldattrdata "舊圖框屬性資料空白!!"))
                  ;);if
                  (if (= inptagdata "")
                      (alert (strcat  inptagdata "資訊點標籤資料空白!!"))
                  );if
                  ;(if (= vfydatetagdata "")
                  ;    (alert (strcat  vfydatetagdata  "圖框審核日期標籤資料空白!!"))
                  ;);if
               
                    
             );progn  
               
          );if
        
   );defun

   ;ltd之dialog 與 oldlay.newlay之 editbox 資料互動結
   (defun get_sublist_num&goac_inp(be_searched_list object / count sear_data flag)
        (setq count 0)
        (setq real_count nil)
        (setq flag  t)
        (while (and flag
                    (/= be_searched_list nil)
                    (/= object           nil)
                    (/= (setq sear_data (nth count be_searched_list)) nil)
                    ;(/= (setq sear_data (nth count be_searched_list)) object)
               );and
               (if (= sear_data object)
                   (progn
                        (setq flag nil)
                        (setq real_count count)
                   );progn  
               );if      
               (setq count (1+ count))
        );while
        real_count          
       
   );defun

   (defun ltd_edit_link&goac_inp(/ ltd_no ltd_word ltd_word_temp s_num namingdata oldattrdata inptagdata vfydatetagdata seek_p)
         (setq ltd_no (get_tile "ltd"));ltd_no: LTypeDefine_Number
         (setq ltd_word (nth (atoi ltd_no) #process_list))
         (setq s_num (string_search&goac_inp  ltd_word "=>"))
         (setq namingdata   (str_trim_blank&goac_inp (substr  ltd_word 1 (1- s_num))))
         (setq ltd_word (str_trim_blank&goac_inp (substr  ltd_word (+ s_num 3))))
         (setq s_num (string_search&goac_inp  ltd_word "=>"))
         (setq oldattrdata   (str_trim_blank&goac_inp (substr  ltd_word 1 (1- s_num))))
         (setq inptagdata    (str_trim_blank&goac_inp (substr  ltd_word (+ s_num 3))))
         ;(setq s_num (string_search&goac_inp  ltd_word "=>"))
         ;(setq inptagdata   (str_trim_blank&goac_inp (substr  ltd_word 1 (1- s_num))))
         ;(setq vfydatetagdata (str_trim_blank&goac_inp (substr  ltd_word (+ s_num 3))))
         (if (= oldattrdata "***")
             (setq oldattrdata "")
         );if  
         (set_tile "naming" namingdata)
         (set_tile "oldattr" oldattrdata)
         (setq seek_p (get_sublist_num&goac_inp #inptag_init_value inptagdata))
         (if (/= seek_p nil)
             (set_tile "inptag" (rtos seek_p 2 0))
             (alert (strcat "\n " inptagdata "資料不存在!!\n"))
         );if  
         (if (or (= (strcase inptagdata) "TAG1")
                 (= (strcase inptagdata) "TAG2")
                 (= (strcase inptagdata) "TAG3")
             );or
             (progn
                  (mode_tile "add"     1)
                  (mode_tile "del"     1) 
                  (mode_tile "naming"  1)
                  (mode_tile "oldattr" 0)
                  (mode_tile "inptag"  1)
             );progn
             (progn
                  (mode_tile "add"     0)
                  (mode_tile "del"     0) 
                  (mode_tile "naming"  0)
                  (mode_tile "oldattr" 0)
                  (mode_tile "inptag"  0)
                  
             );progn
         );if  
                  
         ;(set_tile "vfydatetag" vfydatetagdata)
   );defun

   (defun string_search&goac_inp(string search_s / prt flag string_len search_s_len find_s)
     (if (and (/= string "")
              (/= search_s "")
              (/= string nil)
              (/= search_s nil)
          );and
          (progn
               (setq prt 1)
               (setq retprt nil)
               (setq flag nil)
               (setq string_len (strlen string))
               (setq search_s_len (strlen search_s))
               (while (/= (setq find_s (substr string prt search_s_len)) "")
                    (if (=  find_s search_s)
                        (progn
                             (setq retprt prt)
                             (setq flag t)
                             (setq prt (1+ string_len))
                        );progn  
                    );if
                    (setq prt (1+ prt))
               );while
          );progn
          (progn
               (setq flag nil)
          );progn
     );if
     retprt
);defun
               
          


    
 
  (defun modpro&goac_inp(/ num   oldstr namingdata    oldattrdata insdata
                          s_num 1st_word 2nd_word     process_list_mult
                       );modpro&goac_inp
    
         (mode_tile "naming"  0)
         (mode_tile "oldattr" 0)
         (mode_tile "inptag"  0)
         (mode_tile "add"     0)
         (mode_tile "del"     0)
    
         (setq num     (get_tile "ltd"))
         
         
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (setq process_list_mult #process_list)
                  
                  ;(setq oldstr  (nth (atoi num) #process_list))
                  (setq namingdata (strcase (get_tile "naming")))
                  (setq oldattrdata (strcase (get_tile "oldattr")))
                  (setq inptagdata (nth (atoi (get_tile "inptag")) #inptag_init_value ))
                  ;(setq inptagdata (strcase (get_tile "inptag")))
                  ;(setq vfydatetagdata (strcase (get_tile "vfydatetag")))
         
                  (if (and 
                         (/= namingdata "")
                         ;(/= oldattrdata "")
                         (/= inptagdata "")
                         ;(/= vfydatetagdata "")
                      );and       
                      (progn
                          (setq #process_list (remove_one&goac_inp  #process_list (nth (atoi num) #process_list)   ))
                          (naming_oldattr_init&goac_inp)
                        
                          (cond
                                 ((and   (= (member namingdata    #1st_set) nil)
                                                (= (member oldattrdata  #2nd_set) nil)
                                                (= (member inptagdata   #3rd_set) nil)
                                                ;(= (member vfydatetagdata #4th_set) nil)
                                          );and   
                                          (progn
                                               (if (= oldattrdata "")
                                                   (setq oldattrdata "***")
                                               );if
                                               ;(setq insdata (strcat namingdata " => " oldattrdata " => " inptagdata " => " vfydatetagdata))
                                               (setq insdata (strcat namingdata " => " oldattrdata " => " inptagdata ))
                                               ;(setq #process_str (vl-string-subst insdata oldstr #process_str))
                                               ;(setq #process_list (read #process_str))        
                                               (setq #process_list (cons  insdata #process_list))
                                               (setq #process_list (acad_strlsort #process_list))
                                               ;(setq #2nd_set (subst oldattrdata 2nd_word #2nd_set))
                                               (start_list "ltd" 3)
                                               (mapcar 'add_list #process_list)
                                               (end_list)
                                          );progn
                                  );1 
                                  (t
                                         (progn
                                              (setq #process_list process_list_mult)
                                              (if (/= (member namingdata   #1st_set) nil)
                                                  (alert (strcat  namingdata  "資料重覆"))
                                              );if
                                              (if (/= (member oldattrdata   #2nd_set) nil)
                                                  (alert (strcat  oldattrdata  "資料重覆"))
                                              );if
                                              (if (/= (member inptagdata   #3rd_set) nil)
                                                  (alert (strcat  inptagdata  "資料重覆"))
                                              );if
                                              ;(if (/= (member vfydatetagdata   #4th_set) nil)
                                        ;         (alert (strcat  vfydatetagdata  "資料重覆"))
                                         ;     );if
                                                     
                                             
                                             
                                              
                                         );progn
                                  );4 
                  
                                              
                           );cond
                         
                      );progn
                      (progn
                           (if (= namingdata "")
                               (alert (strcat  namingdata "資料空白"))
                           );if  
                          ; (if (= oldattrdata "")
                          ;     (alert (strcat  oldattrdata "資料空白"))
                          ; );if
                           (if (= inptagdata "")
                               (alert (strcat  inptagdata "資料空白"))
                           );if
                           ;(if (= vfydatetagdata "")
                           ;    (alert (strcat  vfydatetagdata "資料空白"))
                           ;);if
                       );progn  
                           
                   ) ;if
               );progn
          );if
        
  );defun

  (defun delpro&goac_inp(/  num num_list mm insdata s_num 1st_word 2nd_word)
         ;(naming_oldattr_init&goac_inp)
         (setq num     (get_tile "ltd"))
         (setq num_list (read (strcat "(" num ")")))
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (foreach mm num_list
                       (setq insdata (nth mm #process_list))
                       (setq #process_list (subst  "" (nth mm #process_list)  #process_list ))
                 
                  );foreach
                  (setq #process_list (remove_one&goac_inp #process_list ""))
                  (start_List "ltd" 3)
                  (mapcar 'add_list #process_list)
                  (end_list)
             );progn
         );if
         (setq num_list nil)
  );defun


  (defun to_boxdata&goac_inp(/ mm s_num 1st_word 2nd_word)
        (if (/= #process_list "")
            (progn
                 (start_list "ltd" 3)
                 (mapcar 'add_list #process_list)
                 (end_list)
            );progn
        );if  
  );defun


  (defun vgetfile_val&goac_inp(fname initxt / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "system.ini檔案不存在")
                (exit)
           ) ;progn
    
       );if
  ;jacky
       (setq #textdef initxt)
       (setq needdata nil)
       (setq #downdata nil)
  ;jacky
  (while (setq data (read-line ff))
    
    (setq #downdata (cons data #downdata))
    (if (/= nil (setq txtid (get_word data "=")))
      (progn
        (setq objdata (strcase (substr data 1 (- txtid 1))))
        (if (= objdata initxt)
            (progn
                 (setq dd data needdata (substr data (1+ txtid)) data nil)
                 (setq #downdata (cdr #downdata))
                 (setq #upperdata (reverse #downdata))
                 (setq #downdata nil)
            );progn  
           
        );if
      );progn
     
    );if
  );while
  (setq #downdata (reverse #downdata))
  (close ff)
  needdata
  
);defun

(defun *error* (msg)
       (princ)
);defun

(defun write_systemini&goac_inp(/ ff num  temp mm prew postw w_list  w_word forlist class_ff assoc_data)
             
        (setq ff (open (strcat powdesign_path "system.ini") "w"))
        (setq num nil)
        (setq temp nil)
        (if (/= #process_list nil)
            (progn
                 (trans_strtolist&goac_inp)
                 (setq w_word (strcat #textdef "=" (list_tostring&goac_inp  #process_list )))
                 (if (= #upperdata nil)
                     (progn
                          (setq #upperdata  #downdata)
                          (setq #downdata nil)
                     );progn
                 );if
                 (setq forlist (append #upperdata (list w_word) #downdata))
            );progn
            (progn
                 (setq forlist (append #upperdata  #downdata))
            );progn
        );if  
        (foreach mm forlist
               (write-line mm ff)
        );foreach  
        (close ff)
       ; (foreach mm #class_data_list
;                (write-line (vl-prin1-to-string mm) class_ff)
;       );foreach
 ;       (close class_ff)
);defun

(defun list_tostring&goac_inp(  arg / fi temp blank tran_str )
       (setq fi        0 )
       (setq temp      "")
       (setq blank     " ")
       (setq tran_str  "")
       
       (while (/=  (nth fi arg) nil)
              (progn
                   (if (= fi (1- (length arg)))
                       (setq blank "")
                   )      
                   (setq  tran_str (etos&goac_inp (nth fi arg)))
                   (setq temp  (strcat temp tran_str blank))
                   (setq fi (+ fi 1))
                
               );progn
        );while
  
        (setq temp  (strcat "(" temp " )"))
        temp
 );list_tostring&fun1

 (defun etos&goac_inp (arg / file)
     (if (= 'STR (type arg)) (setq arg (strcat "\"" arg "\"")))
     (setq  file (open "$" "w"))
     (princ arg  file)
     (close file)
     (setq file (open "$" "r"))
     (setq arg (read-line file))
     (close file)
     arg
);eots&fun1

(defun naming_oldattr_init&goac_inp(/ s_num 1st_word 2nd_word)
     (setq #1st_set     nil)
     (setq #2nd_set     nil)
     (setq #3rd_set     nil)
     ;(setq #4th_set     nil)
     (foreach mm #process_list
            (setq s_num (string_search&goac_inp mm "=>"))
            (setq 1st_word (str_trim_blank&goac_inp (strcase (substr  mm 1 (1- s_num)))))
            (setq mm       (str_trim_blank&goac_inp (strcase (substr  mm   (+ s_num 3)))))
            (setq s_num (string_search&goac_inp mm "=>"))
            (setq 2nd_word (str_trim_blank&goac_inp (strcase (substr  mm 1 (1- s_num)))))
            (setq 3rd_word (str_trim_blank&goac_inp (strcase (substr  mm   (+ s_num 3)))))
            ;(setq s_num (string_search&goac_inp mm "=>"))
            ;(setq 3rd_word (str_trim_blank&goac_inp (strcase (substr  mm 1 (1- s_num)))))
            ;(setq 4th_word (str_trim_blank&goac_inp (strcase (substr  mm   (+ s_num 3)))))
           ; (setq 1st_word (str_trim_blank&goac_inp 1st_word))
           ; (setq 2nd_word (str_trim_blank&goac_inp 2nd_word))
            (setq #1st_set     (append #1st_set     (list 1st_word)))
            (setq #2nd_set     (remove_one&goac_inp  (append #2nd_set (list 2nd_word)) "***"))
            (setq #3rd_set     (append #3rd_set     (list 3rd_word)))
            ;(setq #4th_set     (append #4th_set     (list 4th_word)))
     );foreach
);defun

(defun str_trim_blank&goac_inp(str / lprt rprt retstr)
     (setq Lprt 1)
     (setq rprt (strlen str))
     (while (= (substr str Lprt 1) " ")
            (setq Lprt (1+ Lprt))
     );while
     (while (= (substr str rprt 1) " ")
            (setq rprt (1- rprt))
     );while
    
     (setq retstr (substr str Lprt (1+ (- rprt Lprt))))
     retstr
);defun

(defun remove_one&goac_inp (li obj / i ret_list nthdata)
     (setq i 0)
     (setq ret_list nil)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= nthdata obj) 
              (setq ret_list (append ret_list (list nthdata)))
          );if
          (setq i (1+ i))
     );while
     ret_list
);defun  


;c:lt_map******************************************************************************************************                           
 
(defun c:lt_map(/   #upperdata #process_temp     #downdata exe_st
                    #process_list        #s_word_set       #s_postword_set    gf_val        mm   cmdecho_v
                    exetrans_flag        #class_data_list  #class_name_list   #old_classdef #filterclassdef
                    #filterclassdata     #init_set_list
               )
  
       (setq cmdecho_v (getvar "cmdecho"))
       (setvar "cmdecho" 0)
       (actdcl (strcat powdesign_DCL_PATH "system") "lt_map")

       (setq tag_list (nth 0 (get_defpart)))                              ;;jackson
       (act_pop_list tag_list "iptag-r")          ;;jackson
       (mode_tile "add" 1)                        ;;jackso
       (mode_tile "del" 1)                        ;;jackso
       (mode_tile "mod" 1)                        ;;jackso


       (setq #upperdata nil)
       (setq #process_temp nil)
       (setq #downdata nil)
       (setq exe_st 0)
       (setq gf_val nil)
       (setq #process_list nil)
  
       (if (/= (setq gf_val (vgetfile_val&lt_map (strcat powdesign_PATH "system.ini") "舊圖框屬性對應資訊點標籤")) nil)
           (progn
                (setq a 2)
                (setq #process_list (read gf_val))
                (foreach mm #process_list
                         (setq #process_temp (cons (strcat (strcase (car mm)) " => " (strcase (cadr mm))) #process_temp))
                );foreach
                (setq #process_list (reverse #process_temp))
           );progn        
       );if      
  
       (setq #s_word_set     nil)
       (setq #s_postword_set nil)
     
       (to_boxdata&lt_map)
       (inpt_init&lt_map)
       ;(mode_tile "add" 0)
       ;(mode_tile "mod" 1)
       ;(mode_tile "del" 1)

       (action_tile "ltd" "(ltd_edit_link&lt_map)")
  
       (action_tile "add" "(addpro&lt_map)")
       (action_tile "mod" "(modpro&lt_map)")
       (action_tile "del" "(delpro&lt_map)")
       (action_tile "accept" "(setq exe_st 1)(done_dialog)(write_systemini&lt_map)")
       (action_tile "cancel" "(setq exe_st 0)(done_dialog)(unload_dialog dcL_id)")
       (start_dialog)
       (if (= exe_st 1)
           (c:lt_map)
       );if      
       (setvar "cmdecho" cmdecho_v)
       (princ)
  );defun
  (defun inpt_init&lt_map()
 ;     (setq #inpt_init_value (list "TAG1" "TAG2" "TAG3" "TAG4" "TAG5" "TAG6" "TAG7" "TAG8" "TAG9" "TAG10" "TAG11" "TAG12" "TAG13" "TAG14" "TAG15"))  ;;jacky
       (setq #inpt_init_value (list "TAG3" "TAG4" "TAG5" "TAG6" "TAG7" "TAG8" "TAG9" "TAG10" "TAG11" "TAG12" "TAG13" "TAG14" "TAG15"))  ;;jackson
       (start_List "inpt" 3)
       (mapcar 'add_list #inpt_init_value)
       (end_list)
  );defun
  (defun tran_listtostr&lt_map(/ mm  process_temp 2nd_wp 2nd_wp_num )
  
        (if (/= #Process_list nil)
           (progn
                (setq process_temp nil)
                (foreach mm #Process_list
                         (setq process_temp (cons (strcat (strcase (car mm)) " => " (strcase (cadr mm))) process_temp))
                )
                (setq #Process_list (reverse process_temp))
           );progn        
           
       );if
       
  );defun tran_listtostr&lt_map


  (defun trans_strtolist&lt_map (/ ff  num     mm       w_word   temp      prew    postw    w_list  temp&S temp&L 
                            1st_num  1st_word 2nd_word post_temp 2nd_num 3rd_word forlist 
                          )
             
       ;(if (= (type (car #process_list)) 'list)
       ;     (tran_listtostr&lt_map)
;       );if  
        (setq num nil)
        (setq temp nil)
        (setq temp&L nil)
       
        (if (/= #process_list nil)
            (progn
                 (foreach mm #process_list
                        (setq 1st_num  (string_search&lt_map  mm "=>"))
                        (setq 1st_word (str_trim_blank&lt_map (substr mm 1 (1- 1st_num))))
                        (setq 2nd_word (str_trim_blank&lt_map (substr mm (+  1st_num 3))))
                       
                        (setq 1st_word (etos&lt_map (strcase 1st_word)))
                        (setq 2nd_word (etos&lt_map (strcase 2nd_word)))
                   
                        (setq temp&L   (cons (list 1st_word 2nd_word) temp&L))
 
                 );foreach
                 (setq temp&L (reverse temp&L))

                 
             );progn
           
        );if
        (setq #process_list temp&L)
        
);trans_strtolist&lt_map

 
  (defun addpro&lt_map(/ dwgattrdata inptdata insdata s_num s_word s_postword)
         (dwgattr_inp_init&lt_map)
         (setq dwgattrdata (strcase (get_tile "dwgattrt")))
         (setq inptdata (nth (atoi (get_tile "inpt")) #inpt_init_value ))
         ;(setq inptdata (strcase (get_tile "inpt")))
         (if (and (not (member dwgattrdata #s_word_set))
                  (not (member inptdata #s_postword_set))
                  (/= dwgattrdata "")
                  (/= inptdata "")
             );and        
             (progn
                  (setq insdata (strcat dwgattrdata " => " inptdata))
                  (setq #process_list (append #process_list (list insdata)))
                  (setq #process_list (acad_strlsort #process_list))
                  (start_list "ltd" 3 )
                  (mapcar 'add_list #process_list)
                  (end_list)
             );progn
             (progn
                  (if (member dwgattrdata #s_word_set)
                      (alert (strcat  dwgattrdata "圖框屬性標籤資料重覆!!"))
                  );if
                  (if (member inptdata #s_postword_set)
                      (alert (strcat  inptdata "資訊點標籤資料重覆!!"))
                  );if
                  (if (= dwgattrdata "")
                      (alert (strcat  dwgattrdata "圖框屬性標籤資料空白!!"))
                  );if  
                  (if (= inptdata "")
                      (alert (strcat  inptdata "資訊點標籤資料空白!!"))
                  );if    
               
                    
             );progn  
               
          );if
        
   );defun
   (defun get_sublist_num&lt_map(be_searched_list object / count sear_data flag)
        (setq count 0)
        (setq real_count nil)
        (setq flag  t)
        (while (and flag
                    (/= be_searched_list nil)
                    (/= object           nil)
                    (/= (setq sear_data (nth count be_searched_list)) nil)
                    ;(/= (setq sear_data (nth count be_searched_list)) object)
               );and
               (if (= sear_data object)
                   (progn
                        (setq flag nil)
                        (setq real_count count)
                   );progn  
               );if      
               (setq count (1+ count))
        );while
        real_count          
       
   );defun
   ;ltd之dialog 與 oldlay.newlay之 editbox 資料互動之結

   (defun ltd_edit_link&lt_map(/ ltd_no ltd_word s_num dwgattrdata inptdata seek_p)
         (setq ltd_no (get_tile "ltd"));ltd_no: LTypeDefine_Number
         (setq ltd_word (nth (atoi ltd_no) #process_list))
         (setq s_num (string_search&lt_map  ltd_word "=>"))
         (mode_tile "add" 0)
         (mode_tile "mod" 0)
         (mode_tile "del" 0)
         (setq dwgattrdata   (str_trim_blank&lt_map (substr  ltd_word 1 (1- s_num))))
         (setq inptdata   (str_trim_blank&lt_map (substr  ltd_word (+ s_num 3))))
         (set_tile "dwgattrt" dwgattrdata)
         (setq seek_p (get_sublist_num&lt_map #inpt_init_value inptdata))
         (if (/= seek_p nil)
             (set_tile "inpt" (rtos seek_p 2 0))
             (alert (strcat "\n " inptdata "資料不存在!!\n"))
         );if  
         ;(set_tile "inpt" inptdata)      
   );defun
   (defun string_search&lt_map(string search_s / prt flag string_len search_s_len find_s)
     (if (and (/= string "")
              (/= search_s "")
              (/= string nil)
              (/= search_s nil)
          );and
          (progn
               (setq prt 1)
               (setq retprt nil)
               (setq flag nil)
               (setq string_len (strlen string))
               (setq search_s_len (strlen search_s))
               (while (/= (setq find_s (substr string prt search_s_len)) "")
                    (if (=  find_s search_s)
                        (progn
                             (setq retprt prt)
                             (setq flag t)
                             (setq prt (1+ string_len))
                        );progn  
                    );if
                    (setq prt (1+ prt))
               );while
          );progn
          (progn
               (setq flag nil)
          );progn
     );if
     retprt
);defun
               
          


    
 
  (defun modpro&lt_map(/ num   oldstr dwgattrdata    inptdata insdata
                  s_num s_word s_postword process_list_temp&lt_map
                )
         (setq process_list_temp&lt_map #process_list)
         
         (setq num     (get_tile "ltd"))
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (setq oldstr  (nth (atoi num) #process_list))
                  ;(setq #process_str (vl-prin1-to-string #process_list))
         
                  (setq dwgattrdata (strcase (get_tile "dwgattrt")))
                  (setq inptdata (nth (atoi (get_tile "inpt")) #inpt_init_value ))
                  ;(setq inptdata (strcase (get_tile "inpt")))
         
                  (if (and 
                         (/= dwgattrdata "")
                         (/= inptdata "")
                      );and       
                      (progn
                          (setq #process_list (remove_one&lt_map  #process_list (nth (atoi num) #process_list)   ))
                          (dwgattr_inp_init&lt_map)
                          (setq s_num (string_search&lt_map  oldstr "=>"))
                          (setq s_word (str_trim_blank&lt_map  (substr oldstr 1 (1- s_num))))
                          (setq s_postword (str_trim_blank&lt_map  (substr oldstr (+ s_num 3))))
                          (cond
                                  ((or(and (= s_word dwgattrdata)
                                                  (= (member inptdata #s_postword_set) nil)
                                             );and
                                             (and (= (member dwgattrdata #s_word_set) nil)
                                                  (= s_postword inptdata)
                                             );and
                                             (and (= (member dwgattrdata #s_word_set) nil)
                                                  (= (member inptdata #s_postword_set) nil)
                                             );and
                                          );or   
                                             
                                          (progn
                                               (setq insdata (strcat dwgattrdata " => " inptdata))
                                               
                                               ;(setq #process_str (vl-string-subst insdata oldstr #process_str))
                                               ;(setq #process_list (read #process_str))        
                                               (setq #process_list (cons  insdata #process_list))
                                               (setq #process_list (acad_strlsort #process_list))
                                               ;(setq #s_postword_set (subst inptdata s_postword #s_postword_set))
                                               (start_list "ltd" 3)
                                               (mapcar 'add_list #process_list)
                                               (end_list)
                                          );progn
                                  );1 
                                 ; ;|( (and (= (member dwgattrdata #s_word_set) nil)
                                 ;              (= s_postword inptdata)
                                 ;         )
                                 ;         (progn
                                 ;              (setq insdata (strcat dwgattrdata " => " inptdata))
                                 ;              (setq #process_str (vl-string-subst insdata oldstr #process_str))
                                 ;              (setq #process_list (read #process_str))
                                 ;
                                 ;              (setq #s_word_set (subst  dwgattrdata  s_word  #s_word_set))
                                 ;              (start_list "ltd" 1 (atoi num ))
                                 ;              (add_list insdata)
                                 ;              (end_list)
                                 ;         );progn
                                 ; );2
                                 ; (  (and (= (member dwgattrdata #s_word_set) nil)
                                 ;              (= (member inptdata #s_postword_set) nil)
                                 ;         )
                                 ;         (progn
                                 ;              (setq insdata (strcat dwgattrdata " => " inptdata))
                                 ;              (setq #process_str (vl-string-subst insdata oldstr #process_str))
                                 ;              (setq #process_list (read #process_str))
                                 ;
                                 ;              (setq #s_word_set (subst  dwgattrdata  s_word  #s_word_set))
                                 ;              (setq #s_postword_set (subst inptdata s_postword #s_postword_set))
                                 ;              (start_list "ltd" 1 (atoi num ))
                                 ;              (add_list insdata)
                                 ;              (end_list)
                                 ;         );progn
                                 ; );3|;
                                  (t
                                         (progn
                                              (setq #process_list process_list_temp&lt_map)
                                              (if (or (member dwgattrdata #s_word_set)
                                                      (member inptdata #s_postword_set)
                                                  );or    
                                                  (alert (strcat  dwgattrdata " or "  inptdata  "資料重覆"))
                                              );if
                                             
                                              
                                         );progn
                                  );4 
                  
                                              
                           );cond
                         
                      );progn
                      (progn
                           (if (= dwgattrdata "")
                               (alert (strcat  dwgattrdata "圖框屬性標籤資料空白"))
                           );if  
                           (if (= inptdata "")
                               (alert (strcat  inptdata "資訊點標籤資料空白"))
                           );if
                       );progn  
                           
                   ) ;if
               );progn
          );if
        
  );defun

  (defun delpro&lt_map(/  num num_list mm insdata s_num s_word s_postword)
         ;(dwgattr_inp_init&lt_map)
         (setq num     (get_tile "ltd"))
         (setq num_list (read (strcat "(" num ")")))
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (foreach mm num_list
                       (setq insdata (nth mm #process_list))
                       (setq #process_list (subst  "" (nth mm #process_list)  #process_list ))
                 
                  );foreach
                  (setq #process_list (remove_one&lt_map #process_list ""))
                  (start_List "ltd" 3)
                  (mapcar 'add_list #process_list)
                  (end_list)
             );progn
         );if
         (setq num_list nil)
  );defun


  (defun to_boxdata&lt_map(/ mm s_num s_word s_postword)
        (if (/= #process_list "")
            (progn
                 (start_list "ltd" 3)
                 (mapcar 'add_list #process_list)
                 (end_list)
            );progn
        );if  
  );defun


  (defun vgetfile_val&lt_map(fname initxt / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "system.ini檔案不存在")
                (exit)
           ) ;progn
    
       );if
  ;jacky
       (setq #textdef initxt)
       (setq needdata nil)
       (setq #downdata nil)
  ;jacky
  (while (setq data (read-line ff))
    
    (setq #downdata (cons data #downdata))
    (if (/= nil (setq txtid (get_word data "=")))
      (progn
        (setq objdata (strcase (substr data 1 (- txtid 1))))
        (if (= objdata initxt)
            (progn
                 (setq dd data needdata (substr data (1+ txtid)) data nil)
                 (setq #downdata (cdr #downdata))
                 (setq #upperdata (reverse #downdata))
                 (setq #downdata nil)
            );progn  
           
        );if
      );progn
     
    );if
  );while
  (setq #downdata (reverse #downdata))
  (close ff)
  needdata
  
);defun

(defun *error* (msg)
       (princ)
);defun

(defun write_systemini&lt_map(/ ff num  temp mm prew postw w_list  w_word forlist class_ff assoc_data)
             
        (setq ff (open (strcat powdesign_path "system.ini") "w"))
        (setq num nil)
        (setq temp nil)
        (if (/= #process_list nil)
            (progn
                 (trans_strtolist&lt_map)
                 (setq w_word (strcat #textdef "=" (list_tostring&lt_map  #process_list )))
                 (if (= #upperdata nil)
                     (progn
                          (setq #upperdata  #downdata)
                          (setq #downdata nil)
                     );progn
                 );if
                 (setq forlist (append #upperdata (list w_word) #downdata))
            );progn
            (progn
                 (setq forlist (append #upperdata  #downdata))
            );progn
        );if  
        (foreach mm forlist
               (write-line mm ff)
        );foreach  
        (close ff)
       ; (foreach mm #class_data_list
;                (write-line (vl-prin1-to-string mm) class_ff)
;       );foreach
 ;       (close class_ff)
);defun

(defun list_tostring&lt_map(  arg / fi temp blank tran_str )
       (setq fi        0 )
       (setq temp      "")
       (setq blank     " ")
       (setq tran_str  "")
       
       (while (/=  (nth fi arg) nil)
              (progn
                   (if (= fi (1- (length arg)))
                       (setq blank "")
                   )      
                   (setq  tran_str (etos&lt_map (nth fi arg)))
                   (setq temp  (strcat temp tran_str blank))
                   (setq fi (+ fi 1))
                
               );progn
        );while
  
        (setq temp  (strcat "(" temp " )"))
        temp
 );list_tostring&fun1

 (defun etos&lt_map (arg / file)
     (if (= 'STR (type arg)) (setq arg (strcat "\"" arg "\"")))
     (setq  file (open "$" "w"))
     (princ arg  file)
     (close file)
     (setq file (open "$" "r"))
     (setq arg (read-line file))
     (close file)
     arg
);eots&fun1

(defun dwgattr_inp_init&lt_map(/ s_num s_word s_postword)
     (setq #s_word_set     nil)
     (setq #s_postword_set nil)
     (foreach mm #process_list
            (setq s_num (string_search&lt_map mm "=>"))
            (setq s_word (strcase (substr  mm 1 (1- s_num))))
            (setq s_postword (strcase (substr  mm (+ s_num 3))))
            (setq s_word (str_trim_blank&lt_map s_word))
            (setq s_postword (str_trim_blank&lt_map s_postword))
            (setq #s_word_set     (append #s_word_set     (list s_word)))
            (setq #s_postword_set (append #s_postword_set (list s_postword)))
     );foreach
);defun

(defun str_trim_blank&lt_map(str / lprt rprt retstr)
     (setq Lprt 1)
     (setq rprt (strlen str))
     (while (= (substr str Lprt 1) " ")
            (setq Lprt (1+ Lprt))
     );while
     (while (= (substr str rprt 1) " ")
            (setq rprt (1- rprt))
     );while
    
     (setq retstr (substr str Lprt (1+ (- rprt Lprt))))
     retstr
);defun

(defun remove_one&lt_map (li obj / i ret_list nthdata)
     (setq i 0)
     (setq ret_list nil)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= nthdata obj) 
              (setq ret_list (append ret_list (list nthdata)))
          );if
          (setq i (1+ i))
     );while
     ret_list
);defun  
  
                          
          

                  

  
;c:signing******************************************************************************************************                          
          
 
(defun c:signing(/  #upperdata #process_temp     #downdata exe_st
                    #process_list        #1st_set       #2nd_set    gf_val        mm   cmdecho_v
                    exetrans_flag        #class_data_list  #class_name_list   #old_classdef #filterclassdef
                    #filterclassdata     #init_set_list
               )
  
       (setq cmdecho_v (getvar "cmdecho"))
       (setvar "cmdecho" 0)
       (actdcl (strcat powdesign_DCL_PATH "system") "signing")
       (setq #upperdata nil)
       (setq #process_temp nil)
       (setq #downdata nil)
       (setq exe_st 0)
       (setq gf_val nil)
       (setq #process_list nil)
  
       (if (/= (setq gf_val (vgetfile_val&signing (strcat powdesign_PATH "system.ini") "審核簽名資料")) nil)
           (progn
                (setq #process_list (read gf_val))
                (foreach mm #process_list
                         (setq car1 (strcase (car mm)))
                         (setq cadr2  (strcase (cadr mm)))
                         (setq caddr3  (strcase (caddr mm)))
                         (setq cadddr4  (strcase (cadddr mm)))
                        
                         (if (or (= cadr2 nil)
                                 (= cadr2 "")
                             );or
                             (setq cadr2 "***")
                         );if
                 
                         (setq #process_temp (cons (strcat car1 " => " cadr2 " => " caddr3 " => " cadddr4) #process_temp))
                );foreach
                (setq #process_list (reverse #process_temp))
           );progn        
       );if      
  
       (setq #1st_set nil)
       (setq #2nd_set nil)
       (setq #3rd_set nil)
       (setq #4th_set nil)
     
       (to_boxdata&signing)
      
       ;(mode_tile "add" 0)
       ;(mode_tile "mod" 1)
       ;(mode_tile "del" 1)

       (action_tile "ltd" "(ltd_edit_link&signing)")
  
       (action_tile "add" "(addpro&signing)")
       (action_tile "mod" "(modpro&signing)")
       (action_tile "del" "(delpro&signing)")
       (action_tile "accept" "(setq exe_st 1)(done_dialog)(write_systemini&signing)")
       (action_tile "cancel" "(setq exe_st 0)(done_dialog)(unload_dialog dcL_id)")
       (start_dialog)
       (if (= exe_st 1)
           (c:signing)
       );if      
       (setvar "cmdecho" cmdecho_v)
       (princ)
  );defun

; ;| (defun tran_listtostr&signing(/ mm  process_temp 2nd_wp 2nd_wp_num )
;
;        (if (/= #Process_list nil)
;           (progn
;                (setq process_temp nil)
;                (foreach mm #Process_list
;                         (setq process_temp (cons (strcat (strcase (car mm)) " => " (strcase (cadr mm)) " => " (strcase (caddr mm)) " => " (strcase (cadddr mm))) process_temp))
;                )
;                (setq #Process_list (reverse process_temp))
;           );progn
;
;       );if
;
;  );defun tran_listtostr&signing|;


  (defun trans_strtolist&signing (/ ff  num     mm       w_word   temp      prew    postw    w_list  temp&S temp&L 
                                    1st_num  1st_word 2nd_word post_temp 2nd_num 3rd_word forlist 
                                 )
             
       ;(if (= (type (car #process_list)) 'list)
       ;     (tran_listtostr&signing)
;       );if  
        (setq num nil)
        (setq temp nil)
        (setq temp&L nil)
       
        (if (/= #process_list nil)
            (progn
                 (foreach mm #process_list
                        (setq num      (string_search&signing  mm "=>"))
                        (setq 1st_word (str_trim_blank&signing (substr mm 1 (1- num))))
                        (setq mm       (str_trim_blank&signing (substr mm (+  num 3))))
                        (setq num      (string_search&signing  mm "=>"))
                        (setq 2nd_word (str_trim_blank&signing (substr mm 1 (1- num))))
                        (setq mm       (str_trim_blank&signing (substr mm (+  num 3))))
                        (setq num      (string_search&signing  mm "=>"))
                        (setq 3rd_word (str_trim_blank&signing (substr mm 1 (1- num))))
                        (setq 4th_word (str_trim_blank&signing (substr mm (+  num 3))))
                       ; (if (= 1st_word "***")
                ;           (setq 1st_word "")
                ;       );if
                        (if (= 2nd_word "***")
                            (setq 2nd_word "")
                        );if
                ;        (if (= 3rd_word "***")
                ;           (setq 3rd_word "")
                ;       );if
                ;        (if (= 4th_word "***")
                ;           (setq 4th_word "")
                ;       );if
                   
                        (setq 1st_word (etos&signing (strcase 1st_word)))
                        (setq 2nd_word (etos&signing (strcase 2nd_word)))
                        (setq 3rd_word (etos&signing (strcase 3rd_word)))
                        (setq 4th_word (etos&signing (strcase 4th_word)))
                   
                        (setq temp&L   (cons (list 1st_word 2nd_word 3rd_word 4th_word ) temp&L))
 
                 );foreach
                 (setq temp&L (reverse temp&L))

                 
             );progn
           
        );if
        (setq #process_list temp&L)
        
);trans_strtolist&signing

 
  (defun addpro&signing(/ accountdata imagefiledata insdata s_num 1st_word 2nd_word)
         (account_imagefile_init&signing)
         (setq accountdata (strcase (get_tile "account")))
         (setq imagefiledata (strcase (get_tile "imagefile")))
         (setq vfyertagdata (strcase (get_tile "vfyertag")))
         (setq vfydatetagdata (strcase (get_tile "vfydatetag")))
        ; ;|(if (= accountdata "")
        ;     (setq accountdata "***")
        ; );if
        ; (if (= imagefiledata "")
        ;     (setq imagefiledata "***")
        ; )
        ; (if (= vfyertagdata "")
        ;     (setq vfyertagdata "***")
        ; )
        ; (if (= vfydatetagdata "")
        ;     (setq vfydatetagdata "***")
        ; )|;
         (if (and (not (member accountdata    #1st_set))
                  (not (member imagefiledata  #2nd_set))
                  (not (member vfyertagdata   #3rd_set))
                  (not (member vfydatetagdata #4th_set))
                  (/=  accountdata    "")
                  (/=  vfyertagdata   "")
                  (/=  vfydatetagdata "")
             );and        
             (progn
                  (if (= imagefiledata "")
                      (setq imagefiledata "***")
                  );if
                  (setq insdata (strcat accountdata " => " imagefiledata " => " vfyertagdata " => " vfydatetagdata))
                  (setq #process_list (append #process_list (list insdata)))
                  (setq #process_list (acad_strlsort #process_list))
                  (start_list "ltd" 3 )
                  (mapcar 'add_list #process_list)
                  (end_list)
             );progn
             (progn

                  (if (member accountdata #1st_set)
                      (alert (strcat  accountdata "帳號資料重覆!!"))
                  );if
                  (if (member imagefiledata #2nd_set)
                      (alert (strcat  imagefiledata "影像檔名資料重覆!!"))
                  );if
                  (if (member vfyertagdata #3rd_set)
                      (alert (strcat  vfyertagdata "圖框審核者標籤資料重覆!!"))
                  );if
                  (if (member vfydatetagdata #4th_set)
                      (alert (strcat vfydatetagdata  "圖框審核日期標籤資料重覆!!"))
                  );if
                  (if (= accountdata "")
                      (alert (strcat  accountdata "帳號資料空白!!"))
                  );if  
                  ;(if (= imagefiledata "")
                  ;    (alert (strcat  imagefiledata "影像檔名資料空白!!"))
                  ;);if
                  (if (= vfyertagdata "")
                      (alert (strcat  vfyertagdata "圖框審核者標籤資料空白!!"))
                  );if
                  (if (= vfydatetagdata "")
                      (alert (strcat  vfydatetagdata  "圖框審核日期標籤資料空白!!"))
                  );if
               
                    
             );progn  
               
          );if
        
   );defun

   ;ltd之dialog 與 oldlay.newlay之 editbox 資料互動之結

   (defun ltd_edit_link&signing(/ ltd_no ltd_word ltd_word_temp s_num accountdata imagefiledata vfyertagdata vfydatetagdata)
         (setq ltd_no (get_tile "ltd"));ltd_no: LTypeDefine_Number
         (setq ltd_word (nth (atoi ltd_no) #process_list))
         (setq s_num (string_search&signing  ltd_word "=>"))
         (setq accountdata   (str_trim_blank&signing (substr  ltd_word 1 (1- s_num))))
         (setq ltd_word (str_trim_blank&signing (substr  ltd_word (+ s_num 3))))
         (setq s_num (string_search&signing  ltd_word "=>"))
         (setq imagefiledata   (str_trim_blank&signing (substr  ltd_word 1 (1- s_num))))
         (setq ltd_word (str_trim_blank&signing (substr  ltd_word (+ s_num 3))))
         (setq s_num (string_search&signing  ltd_word "=>"))
         (setq vfyertagdata   (str_trim_blank&signing (substr  ltd_word 1 (1- s_num))))
         (setq vfydatetagdata (str_trim_blank&signing (substr  ltd_word (+ s_num 3))))
         (if (= imagefiledata "***")
             (setq imagefiledata "")
         );if  
         (set_tile "account" accountdata)
         (set_tile "imagefile" imagefiledata)
         (set_tile "vfyertag" vfyertagdata)
         (set_tile "vfydatetag" vfydatetagdata)
   );defun

   (defun string_search&signing(string search_s / prt flag string_len search_s_len find_s)
     (if (and (/= string "")
              (/= search_s "")
              (/= string nil)
              (/= search_s nil)
          );and
          (progn
               (setq prt 1)
               (setq retprt nil)
               (setq flag nil)
               (setq string_len (strlen string))
               (setq search_s_len (strlen search_s))
               (while (/= (setq find_s (substr string prt search_s_len)) "")
                    (if (=  find_s search_s)
                        (progn
                             (setq retprt prt)
                             (setq flag t)
                             (setq prt (1+ string_len))
                        );progn  
                    );if
                    (setq prt (1+ prt))
               );while
          );progn
          (progn
               (setq flag nil)
          );progn
     );if
     retprt
);defun
               
          


    
 
  (defun modpro&signing(/ num   oldstr accountdata    imagefiledata insdata
                          s_num 1st_word 2nd_word     process_list_temp&signing
                       )
         (setq num     (get_tile "ltd"))
         
         
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (setq process_list_temp&signing #process_list)
                  
                  ;(setq oldstr  (nth (atoi num) #process_list))
                  (setq accountdata (strcase (get_tile "account")))
                  (setq imagefiledata (strcase (get_tile "imagefile")))
                  (setq vfyertagdata (strcase (get_tile "vfyertag")))
                  (setq vfydatetagdata (strcase (get_tile "vfydatetag")))
         
                  (if (and 
                         (/= accountdata "")
                         ;(/= imagefiledata "")
                         (/= vfyertagdata "")
                         (/= vfydatetagdata "")
                      );and       
                      (progn
                          (setq #process_list (remove_one&signing  #process_list (nth (atoi num) #process_list)   ))
                          (account_imagefile_init&signing)
                          ;|(setq s_num (string_search&signing  oldstr "=>"))
                          ;(setq 1st_word (str_trim_blank&signing  (substr oldstr 1 (1- s_num))))
                          ;(setq oldstr       (str_trim_blank&signing (strcase (substr  oldstr   (+ s_num 3)))))
                          ;(setq s_num (string_search&signing oldstr "=>"))
                          ;(setq 2nd_word (str_trim_blank&signing (strcase (substr  oldstr 1 (1- s_num)))))
                          ;(setq oldstr       (str_trim_blank&signing (strcase (substr  oldstr   (+ s_num 3)))))
                          ;(setq s_num (string_search&signing oldstr "=>"))
                          ;(setq 3rd_word (str_trim_blank&signing (strcase (substr  oldstr 1 (1- s_num)))))
                          ;(setq 4th_word (str_trim_blank&signing (strcase (substr  oldstr   (+ s_num 3)))))|;
                        
                          (cond
                                     ;|((or  (and (= 1st_word accountdata)
                                     ;                (or (= (member imagefiledata  #2nd_set) nil)
                                     ;                    (= (member vfyertagdata   #3rd_set) nil)
                                     ;                    (= (member vfydatetagdata #4th_set) nil)
                                     ;                );or
                                     ;           );and
                                     ;           (and (= 2nd_word imagefiledata)
                                     ;                (or (= (member accountdata    #1st_set) nil)
                                     ;                    (= (member vfyertagdata   #3rd_set) nil)
                                     ;                    (= (member vfydatetagdata #4th_set) nil)
                                     ;                );or
                                     ;
                                     ;           );and
                                     ;           (and (= 3rd_word vfyertagdata)
                                     ;                (or (= (member accountdata    #1st_set) nil)
                                     ;                    (= (member imagefiledata  #2nd_set) nil)
                                     ;                    (= (member vfydatetagdata #4th_set) nil)
                                     ;                );or
                                     ;
                                     ;           );and
                                     ;           (and (= 4th_word vfydatetagdata)
                                     ;                (or (= (member accountdata    #1st_set) nil)
                                     ;                    (= (member imagefiledata  #2nd_set) nil)
                                     ;                    (= (member vfyertagdata   #3rd_set) nil)
                                     ;                );or
                                     ;
                                     ;           );and
                                     ;           (and (= (member accountdata    #1st_set) nil)
                                     ;                (= (member imagefiledata  #2nd_set) nil)
                                     ;                (= (member vfyertagdata   #3rd_set) nil)
                                     ;                (= (member vfydatetagdata #4th_set) nil)
                                     ;           );and
                                     ;     );or   |;
                                  ((and   (= (member accountdata    #1st_set) nil)
                                                (= (member imagefiledata  #2nd_set) nil)
                                                (= (member vfyertagdata   #3rd_set) nil)
                                                (= (member vfydatetagdata #4th_set) nil)
                                          );and   
                                          (progn
                                               (if (= imagefiledata "")
                                                   (setq imagefiledata "***")
                                               );if
                                               (setq insdata (strcat accountdata " => " imagefiledata " => " vfyertagdata " => " vfydatetagdata))
                                               
                                               ;(setq #process_str (vl-string-subst insdata oldstr #process_str))
                                               ;(setq #process_list (read #process_str))        
                                               (setq #process_list (cons  insdata #process_list))
                                               (setq #process_list (acad_strlsort #process_list))
                                               ;(setq #2nd_set (subst imagefiledata 2nd_word #2nd_set))
                                               (start_list "ltd" 3)
                                               (mapcar 'add_list #process_list)
                                               (end_list)
                                          );progn
                                  );1 
                                  ( t
                                         (progn
                                              (setq #process_list process_list_temp&signing)
                                              (if (/= (member accountdata   #1st_set) nil)
                                                  (alert (strcat  accountdata  "資料重覆"))
                                              );if
                                              (if (/= (member imagefiledata   #2nd_set) nil)
                                                  (alert (strcat  imagefiledata  "資料重覆"))
                                              );if
                                              (if (/= (member vfyertagdata   #3rd_set) nil)
                                                  (alert (strcat  vfyertagdata  "資料重覆"))
                                              );if
                                              (if (/= (member vfydatetagdata   #4th_set) nil)
                                                  (alert (strcat  vfydatetagdata  "資料重覆"))
                                              );if
                                                     
                                             
                                             
                                              
                                         );progn
                                  );4 
                  
                                              
                           );cond
                         
                      );progn
                      (progn
                           (if (= accountdata "")
                               (alert (strcat  accountdata "資料空白"))
                           );if  
                          ; (if (= imagefiledata "")
                          ;     (alert (strcat  imagefiledata "資料空白"))
                          ; );if
                           (if (= vfyertagdata "")
                               (alert (strcat  vfyertagdata "資料空白"))
                           );if
                           (if (= vfydatetagdata "")
                               (alert (strcat  vfydatetagdata "資料空白"))
                           );if
                       );progn  
                           
                   ) ;if
               );progn
          );if
        
  );defun

  (defun delpro&signing(/  num num_list mm insdata s_num 1st_word 2nd_word)
         ;(account_imagefile_init&signing)
         (setq num     (get_tile "ltd"))
         (setq num_list (read (strcat "(" num ")")))
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (foreach mm num_list
                       (setq insdata (nth mm #process_list))
                       (setq #process_list (subst  "" (nth mm #process_list)  #process_list ))
                 
                  );foreach
                  (setq #process_list (remove_one&signing #process_list ""))
                  (start_List "ltd" 3)
                  (mapcar 'add_list #process_list)
                  (end_list)
             );progn
         );if
         (setq num_list nil)
  );defun


  (defun to_boxdata&signing(/ mm s_num 1st_word 2nd_word)
        (if (/= #process_list "")
            (progn
                 (start_list "ltd" 3)
                 (mapcar 'add_list #process_list)
                 (end_list)
            );progn
        );if  
  );defun


  (defun vgetfile_val&signing(fname initxt / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "system.ini檔案不存在")
                (exit)
           ) ;progn
    
       );if
  ;jacky
       (setq #textdef initxt)
       (setq needdata nil)
       (setq #downdata nil)
  ;jacky
  (while (setq data (read-line ff))
    
    (setq #downdata (cons data #downdata))
    (if (/= nil (setq txtid (get_word data "=")))
      (progn
        (setq objdata (strcase (substr data 1 (- txtid 1))))
        (if (= objdata initxt)
            (progn
                 (setq dd data needdata (substr data (1+ txtid)) data nil)
                 (setq #downdata (cdr #downdata))
                 (setq #upperdata (reverse #downdata))
                 (setq #downdata nil)
            );progn  
           
        );if
      );progn
     
    );if
  );while
  (setq #downdata (reverse #downdata))
  (close ff)
  needdata
  
);defun

(defun *error* (msg)
       (princ)
);defun

(defun write_systemini&signing(/ ff num  temp mm prew postw w_list  w_word forlist class_ff assoc_data)
             
        (setq ff (open (strcat powdesign_path "system.ini") "w"))
        (setq num nil)
        (setq temp nil)
        (if (/= #process_list nil)
            (progn
                 (trans_strtolist&signing)
                 (setq w_word (strcat #textdef "=" (list_tostring&signing  #process_list )))
                 (if (= #upperdata nil)
                     (progn
                          (setq #upperdata  #downdata)
                          (setq #downdata nil)
                     );progn
                 );if
                 (setq forlist (append #upperdata (list w_word) #downdata))
            );progn
            (progn
                 (setq forlist (append #upperdata  #downdata))
            );progn
        );if  
        (foreach mm forlist
               (write-line mm ff)
        );foreach  
        (close ff)
       ; (foreach mm #class_data_list
;                (write-line (vl-prin1-to-string mm) class_ff)
;       );foreach
 ;       (close class_ff)
);defun

(defun list_tostring&signing(  arg / fi temp blank tran_str )
       (setq fi        0 )
       (setq temp      "")
       (setq blank     " ")
       (setq tran_str  "")
       
       (while (/=  (nth fi arg) nil)
              (progn
                   (if (= fi (1- (length arg)))
                       (setq blank "")
                   )      
                   (setq  tran_str (etos&signing (nth fi arg)))
                   (setq temp  (strcat temp tran_str blank))
                   (setq fi (+ fi 1))
                
               );progn
        );while
  
        (setq temp  (strcat "(" temp " )"))
        temp
 );list_tostring&fun1

 (defun etos&signing (arg / file)
     (if (= 'STR (type arg)) (setq arg (strcat "\"" arg "\"")))
     (setq  file (open "$" "w"))
     (princ arg  file)
     (close file)
     (setq file (open "$" "r"))
     (setq arg (read-line file))
     (close file)
     arg
);eots&fun1

(defun account_imagefile_init&signing(/ s_num 1st_word 2nd_word)
     (setq #1st_set     nil)
     (setq #2nd_set     nil)
     (setq #3rd_set     nil)
     (setq #4th_set     nil)
     (foreach mm #process_list
            (setq s_num (string_search&signing mm "=>"))
            (setq 1st_word (str_trim_blank&signing (strcase (substr  mm 1 (1- s_num)))))
            (setq mm       (str_trim_blank&signing (strcase (substr  mm   (+ s_num 3)))))
            (setq s_num (string_search&signing mm "=>"))
            (setq 2nd_word (str_trim_blank&signing (strcase (substr  mm 1 (1- s_num)))))
            (setq mm       (str_trim_blank&signing (strcase (substr  mm   (+ s_num 3)))))
            (setq s_num (string_search&signing mm "=>"))
            (setq 3rd_word (str_trim_blank&signing (strcase (substr  mm 1 (1- s_num)))))
            (setq 4th_word (str_trim_blank&signing (strcase (substr  mm   (+ s_num 3)))))
           ; (setq 1st_word (str_trim_blank&signing 1st_word))
           ; (setq 2nd_word (str_trim_blank&signing 2nd_word))
            (setq #1st_set     (append #1st_set     (list 1st_word)))
            (setq #2nd_set     (remove_one&signing  (append #2nd_set (list 2nd_word)) "***"))
            (setq #3rd_set     (append #3rd_set     (list 3rd_word)))
            (setq #4th_set     (append #4th_set     (list 4th_word)))
     );foreach
);defun

(defun str_trim_blank&signing(str / lprt rprt retstr)
     (setq Lprt 1)
     (setq rprt (strlen str))
     (while (= (substr str Lprt 1) " ")
            (setq Lprt (1+ Lprt))
     );while
     (while (= (substr str rprt 1) " ")
            (setq rprt (1- rprt))
     );while
    
     (setq retstr (substr str Lprt (1+ (- rprt Lprt))))
     retstr
);defun

(defun remove_one&signing (li obj / i ret_list nthdata)
     (setq i 0)
     (setq ret_list nil)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= nthdata obj) 
              (setq ret_list (append ret_list (list nthdata)))
          );if
          (setq i (1+ i))
     );while
     ret_list
);defun  
  
             
;*****************************************************************************************************************
;;圖檔管理預設路徑
;╭═════════════════════════════════════════════╮
;║設計日期: 2000.11.15                                                                      ║
;║更新日期:                                                                                 ║
;║設 計 者: 陳冠達                                                                          ║
;║功能說明: 圖檔管理預設路徑
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案:
;╰═════════════════════════════════════════════╯
(defun c:dwg_libpath(/ dwg_libpath_fg)
 (setvar "cmdecho" 0)

 (setq dwg_libpath_fg nil)
 (actdcl (strcat powdesign_dcl_path "system") "dwg_libpath")

 (set_tile "path" system_dwg_libpath)

 (action_tile "accept" "(dwg_libpath_ok)")
 (action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (if dwg_libpath_fg
   (progn
     (file_update  "system.INI" "swapfile.txt" "圖檔管理預設路徑" "="
          (strcat "圖檔管理預設路徑=" dwg_path))
     (setq system_dwg_libpath dwg_path)
   );progn
 );if
 (setvar "cmdecho" 1)
 (prin1)
)
(defun dwg_libpath_ok()
   (setq dwg_path (getrealstr3 (get_tile "path")))
   (setq endtxt (substr dwg_path (strlen dwg_path) 1))
   (if (= "" dwg_path) (set_tile "error" "路徑未輸入!")
     (progn
       (if (null (get_word dwg_path ":")) (set_tile "error" "路徑輸入不完全!")
         (progn
            (if (/= "\\" endtxt) (setq dwg_path (strcat dwg_path "\\")))
            (setq dwg_libpath_fg t)
            (done_dialog)
         );progn
       );if
     );progn
   );if
)


                          
;*****************************************************************************************************************
;;;╭════════════════════════════════════════════╮
;;;║設計日期: 2000.9.13                                                                     ║
;;;║更新日期:                                                                               ║
;;;║設 計 者: 佘宗紋                                                                        ║
;;;║功能說明: 材料清單欄位順序                                                              ║
;;;║相關檔案:                                                                               ║
;;;║相關副程式                                                                              ║
;;;╰════════════════════════════════════════════╯

(defun c:defbom(/ bomlist pdmlist widlist index fielddata bom pdm wid pbom ppdm ppdm_id pwid needlist)
       (setq bomlist '() pdmlist '() widlist '() index nil needlist '() newfielddata nil)
       (setvar "cmdecho" 1)

;;;===================取出 PDMBOM.INI 零件定義各欄位名稱==================
       (setq partdata (read (getfile_val (strcat powdesign_path "system.ini") "零件定義資料")))
       (foreach YY partdata
           (setq txt (nth 0 YY))
           (setq needlist (cons txt needlist))
       );foreach
       (setq needlist (reverse needlist))
       (SETQ WW NEEDLIST)

;;;===================取出 SYSTEM.INI 材料清單各欄位名稱==================
       (setq fielddata (read (getfile_val (strcat POWDESIGN_path "system.ini") "材料清單欄位定義")))
       (setq i 1)
       (foreach XX fielddata
           (if (= i 1)
               (progn
                     (setq pbom (nth 0 XX) ppdm (nth 2 XX) pwid (nth 1 XX))
                     (setq ppdm_id (get_sublist_num needlist ppdm))
               );progn
               (progn
                     (setq bom (nth 0 XX))
                     (setq pdm (nth 2 XX))
                     (setq wid (nth 1 XX))
                     (setq bomlist (cons bom bomlist))
                     (setq pdmlist (cons pdm pdmlist))
                     (setq widlist (cons wid widlist))
               );progn
           );if
           (setq i (+ i 1))
       );foreach

       (setq bomlist(reverse bomlist))
       (setq pdmlist(reverse pdmlist))
       (setq widlist(reverse widlist))


       (actdcl (strcat powdesign_dcl_path "system") "defbom")

       (set_tile "pbom" pbom)
       (set_tile "pwid" pwid)

       (mode_tile "edit" 1)
       (mode_tile "del" 1)
       (mode_tile "up" 1)
       (mode_tile "down" 1)

       (action_tile "bom" "(setq index $VALUE)(set_tile \"pdm\" index)(set_tile \"wid\" index)(exe_bom_pdm_wid index)")
       (action_tile "pdm" "(setq index $VALUE)(set_tile \"bom\" index)(set_tile \"wid\" index)(exe_bom_pdm_wid index)")
       (action_tile "wid" "(setq index $VALUE)(set_tile \"bom\" index)(set_tile \"pdm\" index)(exe_bom_pdm_wid index)")

       (action_tile "add" "(modify_field_defbom \"新增\")")
       (action_tile "edit" "(modify_field_defbom \"編輯\")")
       (action_tile "del" "(del_field_defbom)")

       (action_tile "up" "(exe_up_dfsystem_defbom index)")
       (action_tile "down" "(exe_down_dfsystem_defbom index)")

       (act_pop_list bomlist "bom")
       (act_pop_list pdmlist "pdm")
       (act_pop_list widlist "wid")

       (act_pop_list needlist "ppdm")
       (set_tile "ppdm" ppdm_id)


       (action_tile "accept" "(setq action_func T)(defbom_ok)")
       (action_tile "cancel" "(setq action_func nil)(done_dialog)")

       (start_dialog)

       (if action_func
           (progn
                  (setq ff (open (strcat POWDESIGN_path "system.ini") "r"))
                  (setq gg (open (strcat POWDESIGN_path "system.swr") "w"))
                  (setq ffdata (read-line ff))
                  (while ffdata
                         (write-line ffdata gg)
                         (setq ffdata (read-line ff))
                  );while
                  (close ff)
                  (close gg)
                  (setq ff (open (strcat POWDESIGN_path "system.swr") "r"))
                  (setq gg (open (strcat POWDESIGN_path "system.ini") "w"))
                  (setq ffdata (read-line ff))
                  (while ffdata
                         (if (= (substr ffdata 1 16) "材料清單欄位定義")
                                (write-line newdatastr gg)
                                (write-line ffdata gg)
                         );if
                         (setq ffdata (read-line ff))
                  );while
                  (close ff)
                  (close gg)
           );progn
       );if
       (princ)
)


(defun defbom_ok(/ i pwid pwid_err)
       (setq pbom(get_tile "pbom")
             ppdm(nth (atoi (get_tile "ppdm")) needlist)
             pwid(get_tile "pwid")
       )
       (setq i 1 pwid_err nil)
       (repeat (strlen pwid)
               (if (or (< (ascii (substr pwid i 1)) 48) (> (ascii (substr pwid i 1)) 57))
                   (setq pwid_err T)
               );if
               (setq i (+ i 1))
       );repeat
       (cond
             ((= pbom "")(set_tile "error" "件號欄位名稱未定義 !"))
             ((member pbom bomlist)(set_tile "error" "欄位名稱已存在 !"))
             ((= pwid "")(set_tile "error" "件號欄寬未定義 !"))
             (pwid_err (set_tile "error" "件號欄寬輸入錯誤 !"))
             (t

                       (setq i 0)
                       (repeat (length bomlist)
                               (setq newfielddata (cons (list (nth i bomlist) (nth i widlist) (nth i pdmlist)) newfielddata))
                               (setq i (+ i 1))
                       );repeat
                       (setq newfielddata(reverse newfielddata))
                       (setq newdatastr (strcat "材料清單欄位定義=((\"" pbom "\" \"" pwid "\" \"" ppdm "\")"))
                       (foreach XX newfielddata
                             (setq newdatastr(strcat newdatastr "(\"" (nth 0 XX) "\" \"" (nth 1 XX) "\" \"" (nth 2 XX) "\")"))
                       );foreach
                       (setq newdatastr(strcat newdatastr ")"))
                       (done_dialog)
             );t
       );cond
)



(defun exe_bom_pdm_wid(id)
       (mode_tile "edit" 0)
       (mode_tile "del" 0)
       (if (= "0" id)(mode_tile "up" 1)(mode_tile "up" 0))
       (if (= (- (length bomlist) 1) (atoi id))(mode_tile "down" 1)(mode_tile "down" 0))
)


;;;===========上移============
(defun exe_up_dfsystem_defbom(id / id new_list)
       (trans_list_up_defbom id "bom" bomlist)
       (setq bomlist new_list)
       (trans_list_up_defbom id "pdm" pdmlist)
       (setq pdmlist new_list)
       (trans_list_up_defbom id "wid" widlist)
       (setq widlist new_list)
       (cond
           ((= "0" new_id)
              (mode_tile "up" 1) (mode_tile "down" 0)
           );
           (t
              (mode_tile "up" 0) (mode_tile "down" 0)
           )
       );cond
       (setq index new_id)
       (princ)
);defun



(defun trans_list_up_defbom(id key listname / movetxt objtxt flist blist flist)
       (setq new_list '())
       (setq movetxt (nth (- (atoi id) 1) listname)
             objtxt  (nth (atoi id) listname))
       (setq flist (getfrontelist (- (atoi id) 1) listname))
       (setq blist (getbacklist (atoi id) listname))
       (setq blist (cons movetxt blist))
       (setq flist (reverse (cons objtxt (reverse flist))))
       (setq new_list (reverse flist))
       (foreach nn blist
         (progn
           (setq new_list (cons nn new_list))
         );progn
       )
       (setq new_list (reverse new_list))
       (act_pop_list new_list key)
       (setq new_id (rtos (- (atoi id) 1) 2 0))
       (set_tile key new_id)
)

;;;===========下移============
(defun exe_down_dfsystem_defbom(id / id new_list)
       (trans_list_down_defbom id "bom" bomlist)
       (setq bomlist new_list)
       (trans_list_down_defbom id "pdm" pdmlist)
       (setq pdmlist new_list)
       (trans_list_down_defbom id "wid" widlist)
       (setq widlist new_list)

       (cond
           ((= (length bomlist) (+ (atoi new_id) 1))
              (mode_tile "up" 0) (mode_tile "down" 1)
           );
           (t
              (mode_tile "up" 0) (mode_tile "down" 0)
           )
       );cond
       (setq index new_id)
       (princ)
);defun

(defun trans_list_down_defbom(id key listname / movetxt objtxt flist blist flist)
       (setq new_list '())
       (setq movetxt (nth (+ (atoi id) 1) listname)
             objtxt  (nth (atoi id) listname))
       (setq flist (getfrontelist (atoi id) listname))
       (setq blist (getbacklist (+ (atoi id) 1) listname))
       (setq blist (cons objtxt blist))
       (setq flist (reverse (cons movetxt (reverse flist))))
       (setq new_list (reverse flist))
       (foreach nn blist
         (progn
           (setq new_list (cons nn new_list))
         );progn
       )
       (setq new_list (reverse new_list))
       (act_pop_list new_list key)
       (setq new_id (rtos (+ (atoi id) 1) 2 0))
       (set_tile key new_id)
)

;;;===========新增;編輯============
(defun modify_field_defbom(title / bom wid pbom)
       (setq pbom(get_tile "pbom"))
       (if index
               (progn
                   (setq bom (nth (atoi index) bomlist))
                   (setq pdm (nth (atoi index) pdmlist))
                   (setq wid (nth (atoi index) widlist))
                   (SETQ SS PDM DD NEEDLIST)
                   (setq pdm_id (get_sublist_num needlist pdm))
               )
       );if
       (actdcl (strcat powdesign_dcl_path "system") "modify")

       (set_tile "title" title)
       (act_pop_list needlist "pdm")
       (if index
               (progn
                   (set_tile "bom" bom)
                   (set_tile "pdm" pdm_id)
                   (set_tile "wid" wid)
               )
       );if

       (action_tile "accept" "(modify_field_defbom_ok title)")
       (action_tile "cancel" "(done_dialog)")
       (start_dialog)


)

(defun modify_field_defbom_ok(typ / bom pdm wid i wid_err)
       (setq bom (get_tile "bom"))
       (setq pdm (nth (atoi (get_tile "pdm")) needlist))
       (setq wid (get_tile "wid"))
       (setq i 1 wid_err nil)
       (repeat (strlen wid)
               (if (or (< (ascii (substr wid i 1)) 48) (> (ascii (substr wid i 1)) 57))
                   (setq wid_err T)
               );if
               (setq i (+ i 1))
       );repeat
       (cond
             ((= bom "")(set_tile "error" "材料清單欄位未定義 !"))
             ((or (= bom pbom)(and (member bom bomlist)(= typ "新增")))(set_tile "error" "欄位已存在 !"))
             ((or (= bom pbom)(and (member bom bomlist)(= typ "編輯")(/= index (get_sublist_num bomlist bom))))(set_tile "error" "欄位已存在 !"))
             ((= wid "")(set_tile "error" "欄寬未定義 !"))
             (wid_err (set_tile "error" "欄寬輸入錯誤 !"))
             (t
                 (cond
                     ((= typ "新增")
                            (setq bomlist(reverse(cons bom (reverse bomlist))))
                            (setq pdmlist(reverse(cons pdm (reverse pdmlist))))
                            (setq widlist(reverse(cons wid (reverse widlist))))
                            (setq index (itoa (- (length bomlist) 1)))
                     )
                     ((= typ "編輯")
                            (setq bomlist (replace_list_defbom bomlist bom))
                            (setq pdmlist (replace_list_defbom pdmlist pdm))
                            (setq widlist (replace_list_defbom widlist wid))
                     )
                 );cond
                 (done_dialog)
                 (if (= typ "新增") (progn(mode_tile "edit" 0)(mode_tile "del" 0)(mode_tile "up" 0)(mode_tile "down" 1)))
                 (if (and (= typ "新增")(= "0" index)) (mode_tile "up" 1))
                 (act_pop_list bomlist "bom")
                 (act_pop_list pdmlist "pdm")
                 (act_pop_list widlist "wid")
                 (set_tile "bom" index)
                 (set_tile "pdm" index)
                 (set_tile "wid" index)

             )
       );cond
)

(defun replace_list_defbom(listname val / i)
       (setq new_list '() i 0)
       (foreach XX listname
                (if (= index (itoa i))
                    (setq new_list (cons val new_list))
                    (setq new_list (cons XX new_list))
                );if
                (setq i (+ i 1))
       )
       (reverse new_list)
);defun
;;;===========刪除============
(defun del_field_defbom()
       (setq bomlist (del_list_defbom bomlist))
       (setq pdmlist (del_list_defbom pdmlist))
       (setq widlist (del_list_defbom widlist))
       (setq gg bomlist)
       (if (= "0" index)
           (setq index "0")
           (setq index(itoa (- (atoi index) 1)))
       );if
       (cond
           ((and (= "0" index)(/= (length bomlist) 1)(/= nil bomlist))
               (mode_tile "up" 1) (mode_tile "down" 0)
           )
           ((= (length bomlist) 1)
               (mode_tile "up" 1) (mode_tile "down" 1)
           );
           ((null bomlist)
               (setq index nil)
               (mode_tile "up" 1) (mode_tile "down" 1)
               (mode_tile "edit" 1) (mode_tile "del" 1)
           );
           ((= (length bomlist) (+ (atoi index) 1))
               (mode_tile "up" 0) (mode_tile "down" 1)
           );
           (t
               (mode_tile "up" 0) (mode_tile "down" 0)
           )
       );cond
       (act_pop_list bomlist "bom")
       (act_pop_list pdmlist "pdm")
       (act_pop_list widlist "wid")
       (if (/= nil index)
           (progn
                (set_tile "bom" index)
                (set_tile "pdm" index)
                (set_tile "wid" index)
           );progn
       );if
)
(defun del_list_defbom(listname / i)
       (setq new_list '() i 0)
       (foreach XX listname
                (if (/= index (itoa i))
                    (setq new_list (cons XX new_list))
                );if
                (setq i (+ i 1))
       )
       (reverse new_list)
);defun

(defun c:df_bom_database()
   (actdcl (strcat powdesign_dcl_path "system") "setosmode")

   (action_tile "accept" "(get_osmodeset)(setosmode_ok)(done_dialog)")
   (action_tile "cancel" "(done_dialog)")

   (start_dialog)

)
             
                  
;;╭════════════════════════════════════════════╮
;;║設計日期: 2001.2.20                                                                     ║
;;║更新日期:                                                                               ║
;;║設 計 者: 陳冠達                                                                        ║
;;║功能說明: 物料資料庫欄位定義                                                            ║
;;║相關檔案:                                                                               ║
;;║相關副程式                                                                              ║
;;╰════════════════════════════════════════════╯

(defun c:df_bomdbase(/ title_list noneedlist partdata titletxt_list txt needlist lst_dataa)

  (setq ff (open (strcat powdesign_path "database.txt") "r"))
  ;---------------2003.3.21 SAM---------------
  (setq str_item (read-line ff))
  (setq data str_item)
  (setq lst_item (TXT_TRAN_LIST str_item))
  (setq str_data (read-line ff))
  (while str_data 
    	 (setq lst_data  (TXT_TRAN_LIST str_data))
    	 (setq lst_dataa (cons lst_data lst_dataa))
    	 (setq str_data  (read-line ff))
  )
  (setq lst_dataa (reverse lst_dataa))
  ;-------------------------------------------
  (close ff)
  
  (setq collist (TXT_TRAN_LIST data))
  (setq default_list (list (nth 0 collist)))
  (setq ndlist (cdr collist))

  (actdcl (strcat POWDESIGN_dcl_path "system") "df_bom_database")

  (setq totallist (nth 1 (get_defpart)))

  (setq needlist '() noneedlist '())
  (foreach nn ndlist
    (progn
      (setq data (assoc nn totallist))
      (setq txt (strcat (nth 0 data) "=" (nth 1 data)))
      (setq needlist (cons txt needlist))
    );progn
  )
  (setq needlist (reverse needlist))
  (foreach nn totallist
    (progn
      (if (null (member (nth 0 nn) ndlist))
        (progn
          (setq txt (strcat (nth 0 nn) "=" (nth 1 nn)))
          (setq noneedlist (cons txt noneedlist))
        );progn
      );if
    );progn
  )
  (setq noneedlist (reverse noneedlist))

  (mode_tile "up" 1)
  (mode_tile "down" 1)
  (mode_tile "out" 1)
  (mode_tile "in" 1)

  (mode_tile "default" 1)
  (action_tile "need" "(exe_needcol_dfsystem)")
  (action_tile "noneed" "(exe_noneedcol_desystem)")
  (action_tile "up" "(exe_up_dfsystem)")
  (action_tile "down" "(exe_down_dfsystem)")
  (action_tile "out" "(exe_out_dfsystem)")
  (action_tile "in" "(exe_in_dfsystem)")

  (act_pop_list default_list "default")

  (act_pop_list needlist "need")
  (act_pop_list noneedlist "noneed")
  (action_tile "accept" "(df_bom_sortcol_ok)")
  (action_tile "cancel" "(done_dialog)")
  (start_dialog)
)

(defun df_bom_sortcol_ok(/ ff txt txt1 dbcol qf partdata)
   (setq outtxt "料號")
   (foreach nn needlist
     (progn
        (setq txt_id (get_word nn "="))
        (setq txt (substr nn 1 (- txt_id 1)))
        (setq outtxt (strcat outtxt ";" txt))
     )progn
   );foreach

   ;------------------------2003.3.21 SAM-----------------------------
   (setq int_num 0)
   (setq lst_ssdata '())
   (setq lst_appdata '())
   (setq lst_mitem '())
   (setq lst_mitem (TXT_TRAN_LIST outtxt))
   (setq int_mitem_num (length lst_mitem))
   (repeat int_mitem_num
     	   (setq lst_test (member (nth int_num lst_mitem) lst_item))
     	   (if lst_test
	       (setq int_getnum (- (length lst_item) (length lst_test)))
	       (setq int_getnum (- int_num 1))
	   )
     	   (setq int_num (1+ int_num))
     
     	   (setq int_ssnum 0)
           (repeat (length lst_dataa)
	     	   (if lst_test 
	     	   	    (setq str_unit (nth int_getnum (nth int_ssnum lst_dataa)))
		            (setq str_unit "")
		   )
		   (setq lst_ssdata (cons str_unit lst_ssdata))
	     	   (setq int_ssnum (1+ int_ssnum))
	   )
     	   (setq lst_ssdata  (reverse lst_ssdata))
     	   (setq lst_appdata (cons lst_ssdata lst_appdata))
     	   (setq lst_ssdata '())
   )
   (setq lst_appdata (reverse lst_appdata))
  
   (setq ff (open (strcat powdesign_path "database.txt") "w"))
   (setq int_i 0 int_j 0 str_wa "")
   (write-line outtxt ff)
   (repeat (length (nth 0 lst_appdata))
           (repeat (length lst_appdata)
	           (if (= (+ int_i 1)(length lst_appdata))(setq str_sym "")(setq str_sym ";"))
                   (setq str_wt (strcat (nth int_j (nth int_i lst_appdata)) str_sym))
   	           (setq str_wa (strcat str_wa str_wt))
   		   (setq int_i (1+ int_i))
   	   )
           (write-line str_wa ff)(setq int_i 0 str_wa "")
           (setq int_j (1+ int_j))
   )        
   (close ff)
   ;------------------------------------------------------------------
   (done_dialog)
)


(defun exe_up_dfsystem(/ need_id movetxt objtxt flist blist)
  (setq need_id (get_tile "need")
        movetxt (nth (- (atoi need_id) 1) needlist)
        objtxt (nth (atoi need_id) needlist))
  (setq flist (getfrontelist (- (atoi need_id) 1) needlist))
  (setq blist (getbacklist (atoi need_id) needlist))
  (setq blist (cons movetxt blist))
  (setq flist (reverse (cons objtxt (reverse flist))))
  (setq needlist (reverse flist))
  (foreach nn blist
    (progn
      (setq needlist (cons nn needlist))
    );progn
  )
  (setq needlist (reverse needlist))
  (act_pop_list needlist "need")
  (setq new_id (rtos (- (atoi need_id) 1) 2 0))
  (set_tile "need" new_id)
  (if (= "0" new_id)
    (progn
      (mode_tile "up" 1)
      (mode_tile "down" 0)
    );progn
  );if
  (princ)
);defun
(defun exe_down_dfsystem(/ need_id movetxt objtxt flist blist)
  (setq need_id (get_tile "need")
        movetxt (nth (+ (atoi need_id) 1) needlist)
        objtxt (nth (atoi need_id) needlist))
  (setq flist (getfrontelist (atoi need_id) needlist))
  (setq blist (getbacklist (+ (atoi need_id) 1) needlist))
  (setq blist (cons objtxt blist))
  (setq flist (reverse (cons movetxt (reverse flist))))
  (setq needlist (reverse flist))
  (foreach nn blist
    (progn
      (setq needlist (cons nn needlist))
    );progn
  )
  (setq needlist (reverse needlist))

  (act_pop_list needlist "need")
  (setq new_id (rtos (+ (atoi need_id) 1) 2 0))
  (set_tile "need" new_id)

  (if (= (length needlist) (+ 2 (atoi need_id)))
    (progn
      (mode_tile "up" 0)
      (mode_tile "down" 1)
    );progn
  );if
  (princ)
);defun

(defun exe_needcol_dfsystem(/ need_id)
  (setq need_id (get_tile "need"))
  (cond
   ((= "0" need_id)
    (mode_tile "down" 0)
    (mode_tile "out" 0)
    (mode_tile "up" 1)
    (mode_tile "in" 1)
   )
   ((= (length needlist) (+ (atoi need_id) 1))
    (mode_tile "down" 1)
    (mode_tile "out" 0)
    (mode_tile "up" 0)
    (mode_tile "in" 1)
   )
   (T
    (mode_tile "down" 0)
    (mode_tile "out" 0)
    (mode_tile "up" 0)
    (mode_tile "in" 1)
   )
  )
  (princ)
);defun
(defun exe_out_dfsystem(/ abj need_id)
  (setq need_id (get_tile "need"))
  (setq abj (nth (atoi need_id) needlist))
  (setq needlist (removelist abj needlist))
  (act_pop_list needlist "need")
  (setq noneedlist (reverse (cons abj (reverse noneedlist))))
  (act_pop_list noneedlist "noneed")
  (princ)
);defun
(defun exe_noneedcol_desystem()
  (mode_tile "out" 1)
  (mode_tile "in" 0)
  (mode_tile "up" 1)
  (mode_tile "down" 1)
  (princ)
);defun
(defun exe_in_dfsystem(/ noneed_id abj)
  (setq noneed_id (get_tile "noneed"))
  (setq abj (nth (atoi noneed_id) noneedlist))
  (setq noneedlist (removelist abj noneedlist))
  (act_pop_list noneedlist "noneed")
  (setq needlist (reverse (cons abj (reverse needlist))))
  (act_pop_list needlist "need")
  (if (= 0 (length noneedlist))(mode_tile "in" 1))
  (princ)
);defun


;;;目前資料庫欄位設定
(defun c:fieldset(/ #upperdata #process_temp     #downdata exe_st
                    #process_list        #s_word_set       #s_postword_set    gf_val        mm   cmdecho_v
                    exetrans_flag        #class_data_list  #class_name_list   #old_classdef #filterclassdef
                    #filterclassdata     #init_set_list
               )
  
       (setq cmdecho_v (getvar "cmdecho"))
       (setvar "cmdecho" 0)
      
       (actdcl (strcat powdesign_DCL_PATH "system") "fieldset")
       (setq #upperdata nil)
       (setq #process_temp nil)
       (setq #downdata nil)
       (setq exe_st 0)
       (setq gf_val nil)
       (setq #process_list nil)
     ;;2001/3/12  (setq #process_list (getfile_value&fieldset (strcat powdesign_PATH "edwgdata.txt")))
       (setq #process_list (getfile_value&fieldset (strcat powdesign_PATH "dataname.txt")))
       (setq #process_list (acad_strlsort #process_list))
       ;(if (/= (setq gf_val (vgetfile_val&fieldset (strcat powdesign_PATH "system.ini") "舊圖框屬性對應資訊點標籤")) nil)
       ;    (progn
       ;         (setq a 2)
       ;         (setq #process_list (read gf_val))
       ;         (foreach mm #process_list
       ;                  (setq #process_temp (cons (strcat (strcase (car mm)) " , " (strcase (cadr mm))) #process_temp))
       ;         );foreach
       ;         (setq #process_list (reverse #process_temp))
       ;    );progn
       ;);if      ;

       (setq #s_word_set     nil)
       (setq #s_postword_set nil)

       (to_boxdata&fieldset)
       ;(chaccount_init)
       (mode_tile "fldv" 1)
       ;(mode_tile "mod" 1)
       ;(mode_tile "del" 1)

       (action_tile "ltd" "(ltd_edit_link&fieldset)")
  
       ;(action_tile "add" "(addpro&fieldset)")
       (action_tile "mod" "(modpro&fieldset)")
       ;(action_tile "del" "(delpro&fieldset)")
       (action_tile "accept" "(setq exe_st 1)(done_dialog)(write_systemini&fieldset)")
       (action_tile "cancel" "(setq exe_st 0)(done_dialog)(unload_dialog dcL_id)")
       (start_dialog)
       ;(if (= exe_st 1)
       ;    (c:fieldset)
       ;);if      
       (setvar "cmdecho" cmdecho_v)
       (princ)
  );defun
  


  
   ;ltd之dialog 與 oldlay.newlay之 editbox 資料互動之結

   (defun ltd_edit_link&fieldset(/ ltd_no ltd_word s_num fldvdata chaccountdata seek_p)
         (setq ltd_no (get_tile "ltd"));ltd_no: LTypeDefine_Number
         (setq ltd_word (nth (atoi ltd_no) #process_list))
         (setq s_num (string_search&fieldset  ltd_word ";"))
         (setq fldvdata   (str_trim_blank&fieldset (substr  ltd_word 1 (1- s_num))))
         (setq chaccountdata   (str_trim_blank&fieldset (substr  ltd_word (+ s_num 1))))
         (set_tile "fldv" fldvdata)
         (set_tile "chaccount" chaccountdata)
       
   );defun
   (defun string_search&fieldset(string search_s / prt flag string_len search_s_len find_s)
     (if (and (/= string "")
              (/= search_s "")
              (/= string nil)
              (/= search_s nil)
          );and
          (progn
               (setq prt 1)
               (setq retprt nil)
               (setq flag nil)
               (setq string_len (strlen string))
               (setq search_s_len (strlen search_s))
               (while (/= (setq find_s (substr string prt search_s_len)) "")
                    (if (=  find_s search_s)
                        (progn
                             (setq retprt prt)
                             (setq flag t)
                             (setq prt (1+ string_len))
                        );progn  
                    );if
                    (setq prt (1+ prt))
               );while
          );progn
          (progn
               (setq flag nil)
          );progn
     );if
     retprt
);defun
               
          


    
 
  (defun modpro&fieldset(/ num   oldstr fldvdata    chaccountdata insdata
                  s_num s_word s_postword process_list_temp&fieldset 
                )
         
         
         (setq num     (get_tile "ltd"))
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (setq s_postword nil)
                  (foreach mm #process_list
                        (setq s_num (string_search&fieldset  mm ";"))
                        (setq chaccountdata   (str_trim_blank&fieldset (substr  mm (+ s_num 1))))
                        (setq s_postword (append s_postword (list (strcase chaccountdata))))
                  );foreach  
                  (setq oldstr  (nth (atoi num) #process_list))
         
                  (setq fldvdata      (strcase (get_tile "fldv")))
                  (setq chaccountdata (strcase (get_tile "chaccount")))
                  (if (= chaccountdata "")
                      (setq  chaccountdata "未定")
                  );if  
         
                  (if (and 
                         (/= fldvdata "")
                         (/= chaccountdata "")
                      );and       
                      (progn
                            (setq s_postword (remove_one&fieldset s_postword "未定"))
                            (if (= (member chaccountdata s_postword) nil)
                               (progn
                                   (setq insdata (strcat fldvdata ";" chaccountdata))
                                   (setq #process_list (subst insdata (nth (atoi num) #process_list)  #process_list))
                               );progn
                               (progn
                                    (alert "\n <中文說明>:資料重覆!")
                               );progn
                           );if    
                         
                      );progn
                           
                   ) ;if
               (to_boxdata&fieldset)
               );progn
          );if
        
  );defun

  


  (defun to_boxdata&fieldset(/ mm s_num s_word s_postword)
        (if (/= #process_list "")
            (progn
                 (start_list "ltd" 3)
                 (mapcar 'add_list #process_list)
                 (end_list)
            );progn
        );if  
  );defun


  (defun getfile_value&fieldset(fname / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "dataname.txt檔案不存在")
                (exit)
           ) ;progn
    
       );if
       (setq needdata nil)
    
       (while (setq data (read-line ff))
            (if (/= (setq data (str_trim_blank&fieldset data)) "")
                (setq needdata (append needdata (list data)))
            );if  
       );while
       (close ff)
       needdata
  
);defun

(defun *error* (msg)
       (princ)
);defun

(defun write_systemini&fieldset(/ ff num  temp mm prew postw w_list  w_word forlist class_ff assoc_data)
             
        (setq ff (open (strcat powdesign_path "dataname.txt") "w"))
        (foreach mm #process_list
               (write-line mm ff)
        );foreach  
        (close ff)
  );defun



(defun fldv_inp_init&fieldset(/ s_num s_word s_postword)
     (setq #s_word_set     nil)
     (setq #s_postword_set nil)
     (foreach mm #process_list
            (setq s_num (string_search&fieldset mm ";"))
            (setq s_word (strcase (substr  mm 1 (1- s_num))))
            (setq s_postword (strcase (substr  mm (+ s_num 1))))
            (setq s_word (str_trim_blank&fieldset s_word))
            (setq s_postword (str_trim_blank&fieldset s_postword))
            (setq #s_word_set     (append #s_word_set     (list s_word)))
            (setq #s_postword_set (append #s_postword_set (list s_postword)))
     );foreach
);defun

(defun str_trim_blank&fieldset(str / lprt rprt retstr)
     (setq Lprt 1)
     (setq rprt (strlen str))
     (while (= (substr str Lprt 1) " ")
            (setq Lprt (1+ Lprt))
     );while
     (while (and (> rprt 0)
                 (= (substr str rprt 1) " ")
            );and                
            (setq rprt (1- rprt))
     );while
     (if (> lprt rprt)
         (setq retstr "")
         (setq retstr (substr str Lprt (1+ (- rprt Lprt))))
     );if  
     retstr
);defun

(defun remove_one&fieldset (li obj / i ret_list nthdata)
     (setq i 0)
     (setq ret_list nil)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= nthdata obj) 
              (setq ret_list (append ret_list (list nthdata)))
          );if
          (setq i (1+ i))
     );while
     ret_list
);defun  

;;推拔系統管理
;;trapmage:trap ManAGE********************************************************************
;╭═════════════════════════════════════════════╮
;║設計日期:2001.3. 7                                                                        ║
;║更新日期:                                                                                 ║
;║設 計 者: JACKY                                                                           ║
;║功能說明:                                                                                 ║
;║                                                                                          ║
;║執行方式:                                                                                 ║
;║相關檔案: system.dcl(TRAPMAGE)                                                            ║
;╰═════════════════════════════════════════════╯

(defun c:trapmage(/   exe_st               #process_list     #s_word_set        #s_postword_set
                      mm                   cmdecho_v
                      exetrans_flag        #class_data_list  #class_name_list   #old_classdef #filterclassdef
                      #filterclassdata     #init_set_list
                 )
  
       (setq cmdecho_v (getvar "cmdecho"))
       (setvar "cmdecho" 0)
       (actdcl (strcat powdesign_DCL_PATH "system") "trapmage")

      
      ; (setq #upperdata nil)
       ;(setq #process_temp nil)
       ;(setq #downdata nil)
       (setq exe_st 0)
       ;(setq gf_val nil)
       (setq #process_list nil)
       (setq #process_list (getfile_value&trapmage (strcat powdesign_data_PATH "trap_dir.dat")))
       (setq #process_list (acad_strlsort #process_list))
  
       (setq #s_word_set     nil)
       (setq #s_postword_set nil)
     
       (to_boxdata&trapmage)
       ;(trapang_init&trapmage)
       

       (action_tile "ltd" "(ltd_edit_link&trapmage)")
  
       (action_tile "add" "(addpro&trapmage)")
       (action_tile "mod" "(modpro&trapmage)")
       (action_tile "del" "(delpro&trapmage)")
       (action_tile "accept" "(setq exe_st 1)(done_dialog)(write_systemini&trapmage)")
       (action_tile "cancel" "(setq exe_st 0)(done_dialog)(unload_dialog dcL_id)")
       (start_dialog)
       (if (= exe_st 1)
           (c:trapmage)
       );if      
       (setvar "cmdecho" cmdecho_v)
       (princ)
  );defun
  (defun tran_listtostr&trapmage(/ mm  process_temp   )
  
        (if (/= #Process_list nil)
           (progn
                (setq process_temp nil)
                (foreach mm #Process_list
                         (setq process_temp (cons (strcat (strcase (car mm)) " => " (strcase (cadr mm))) process_temp))
                )
                (setq #Process_list (reverse process_temp))
           );progn        
           
       );if
       
  );defun tran_listtostr&trapmage


  (defun trans_strtolist&trapmage (/ ff  num     mm       w_word   temp      prew    postw    w_list  temp&S temp&L 
                            1st_num  1st_word 2nd_word post_temp 2nd_num 3rd_word forlist 
                          )
             
       ;(if (= (type (car #process_list)) 'list)
       ;     (tran_listtostr&trapmage)
;       );if  
        (setq num nil)
        (setq temp nil)
        (setq temp&L nil)
       
        (if (/= #process_list nil)
            (progn
                 (foreach mm #process_list
                        (setq 1st_num  (string_search&trapmage  mm "=>"))
                        (setq 1st_word (str_trim_blank&trapmage (substr mm 1 (1- 1st_num))))
                        (setq 2nd_word (str_trim_blank&trapmage (substr mm (+  1st_num 3))))
                       
                        (setq 1st_word (etos&trapmage (strcase 1st_word)))
                        (setq 2nd_word (etos&trapmage (strcase 2nd_word)))
                   
                        (setq temp&L   (cons (list 1st_word 2nd_word) temp&L))
 
                 );foreach
                 (setq temp&L (reverse temp&L))

                 
             );progn
           
        );if
        (setq #process_list temp&L)
        
);trans_strtolist&trapmage

 
  (defun addpro&trapmage(/ traptypedata trapangdata insdata   )
         (traptype_inp_init&trapmage)
         (setq traptypedata (strcase (get_tile "traptype")))
         (setq trapangdata  (strcase (get_tile "trapang")))
         (if (and (not (member traptypedata #s_word_set))
                  (/= traptypedata "")
                  (/= trapangdata "")
             );and        
             (progn
                  (setq insdata (strcat (tab traptypedata 25) " => " trapangdata))
                  (setq #process_list (append #process_list (list insdata)))
                  (setq #process_list (acad_strlsort #process_list))
                  (start_list "ltd" 3 )
                  (mapcar 'add_list #process_list)
                  (end_list)
             );progn
             (progn
                  (if (member traptypedata #s_word_set)
                      (alert (strcat  traptypedata "資料重覆!!"))
                  );if
                  ;(if (member trapangdata #s_postword_set)
                  ;    (alert (strcat  trapangdata "錐度 (a/2)資料重覆!!"))
                  ;);if
                  (if (= traptypedata "")
                      (alert (strcat  traptypedata "推拔型式資料空白!!"))
                  );if  
                  (if (= trapangdata "")
                      (alert (strcat  trapangdata "錐度 (a/2)資料空白!!"))
                  );if    
               
                    
             );progn  
               
          );if
        
   );defun
  
   ;ltd之dialog 與 oldlay.newlay之 editbox 資料互動之結

   (defun ltd_edit_link&trapmage(/ ltd_no ltd_word s_num traptypedata trapangdata )
         (setq ltd_no (get_tile "ltd"));ltd_no: LTypeDefine_Number
         (setq ltd_word (nth (atoi ltd_no) #process_list))
         (setq s_num (string_search&trapmage  ltd_word "=>"))
         (mode_tile "add" 0)
         (mode_tile "mod" 0)
         (mode_tile "del" 0)
         (setq traptypedata   (str_trim_blank&trapmage (substr  ltd_word 1 (1- s_num))))
         (setq trapangdata   (str_trim_blank&trapmage (substr  ltd_word (+ s_num 3))))
         (set_tile "traptype" traptypedata)
         (set_tile "trapang"  trapangdata)
   );defun
   (defun string_search&trapmage(string search_s / prt flag string_len search_s_len find_s)
     (if (and (/= string "")
              (/= search_s "")
              (/= string nil)
              (/= search_s nil)
          );and
          (progn
               (setq prt 1)
               (setq retprt nil)
               (setq flag nil)
               (setq string_len (strlen string))
               (setq search_s_len (strlen search_s))
               (while (/= (setq find_s (substr string prt search_s_len)) "")
                    (if (=  find_s search_s)
                        (progn
                             (setq retprt prt)
                             (setq flag t)
                             (setq prt (1+ string_len))
                        );progn  
                    );if
                    (setq prt (1+ prt))
               );while
          );progn
          (progn
               (setq flag nil)
          );progn
     );if
     retprt
);defun
               
       
  (defun modpro&trapmage(/ num   oldstr traptypedata    trapangdata insdata
                            s_num s_word s_postword process_list_temp&trapmage
                         )
         (setq process_list_temp&trapmage #process_list)
         
         (setq num     (get_tile "ltd"))
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (setq oldstr  (nth (atoi num) #process_list))
         
                  (setq traptypedata (strcase (get_tile "traptype")))
                  (setq trapangdata  (strcase (get_tile "trapang")))
                  ;(setq trapangdata (nth (atoi (get_tile "trapang")) #trapang_init_value ))
         
                  (if (and 
                         (/= traptypedata "")
                         (/= trapangdata "")
                      );and       
                      (progn
                          (setq #process_list (remove_one&trapmage  #process_list (nth (atoi num) #process_list)   ))
                          (traptype_inp_init&trapmage)
                          (setq s_num (string_search&trapmage  oldstr "=>"))
                          (setq s_word (str_trim_blank&trapmage  (substr oldstr 1 (1- s_num))))
                          (setq s_postword (str_trim_blank&trapmage  (substr oldstr (+ s_num 3))))
                          (cond
                                  (     (or  (and (= s_word traptypedata)
                                                  (or 
                                                     (=  (member trapangdata #s_postword_set) nil)
                                                     (/= (member trapangdata #s_postword_set) nil)
                                                  );or   
                                             );and
                                             (and (= (member traptypedata #s_word_set) nil)
                                                  (= s_postword trapangdata)
                                             );and
                                             (and (= (member traptypedata #s_word_set) nil)
                                                  (or 
                                                     (=  (member trapangdata #s_postword_set) nil)
                                                     (/= (member trapangdata #s_postword_set) nil)
                                                  );or
                                             );and
                                          );or   
                                             
                                          (progn
                                               (setq insdata (strcat (tab traptypedata 25) " => " trapangdata))
                                               
                                               ;(setq #process_str (vl-string-subst insdata oldstr #process_str))
                                               ;(setq #process_list (read #process_str))        
                                               (setq #process_list (cons  insdata #process_list))
                                               (setq #process_list (acad_strlsort #process_list))
                                               ;(setq #s_postword_set (subst trapangdata s_postword #s_postword_set))
                                               (start_list "ltd" 3)
                                               (mapcar 'add_list #process_list)
                                               (end_list)
                                          );progn
                                  );1 
                                 
                                  (t
                                         (progn
                                              (setq #process_list process_list_temp&trapmage)
                                              (if (or (member traptypedata #s_word_set)
                                                      (member trapangdata #s_postword_set)
                                                  );or    
                                                  (alert (strcat  traptypedata   "資料重覆!!"))
                                              );if
                                             
                                              
                                         );progn
                                  );4 
                  
                                              
                           );cond
                         
                      );progn
                      (progn
                           (if (= traptypedata "")
                               (alert (strcat  traptypedata "推拔型式資料空白"))
                           );if  
                           (if (= trapangdata "")
                               (alert (strcat  trapangdata "錐度 (a/2)資料空白"))
                           );if
                       );progn  
                           
                   ) ;if
               );progn
          );if
        
  );defun

    
 
 

  (defun delpro&trapmage(/  num num_list mm insdata s_num s_word s_postword)
         (traptype_inp_init&trapmage)
         (setq num     (get_tile "ltd"))
         (setq num_list (read (strcat "(" num ")")))
         (if (and (/= #process_list nil)
                  (/= num "")
             );and
             (progn
                  (foreach mm num_list
                       (setq insdata (nth mm #process_list))
                       (setq #process_list (subst  "" (nth mm #process_list)  #process_list ))
                 
                  );foreach
                  (setq #process_list (remove_one&trapmage #process_list ""))
                  (start_List "ltd" 3)
                  (mapcar 'add_list #process_list)
                  (end_list)
             );progn
         );if
         (setq num_list nil)
  );defun


  (defun to_boxdata&trapmage(/ mm s_num s_word s_postword)
        (if (/= #process_list "")
            (progn
                 (start_list "ltd" 3)
                 (mapcar 'add_list #process_list)
                 (end_list)
            );progn
        );if  
  );defun


  (defun getfile_value&trapmage(fname / ff  needdata data   pdata pdata1 pdata2 pdata12)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert (strcat fname "檔案不存在!!"))
                (exit)
           ) ;progn
    
       );if
       (setq needdata nil)
    
       (while (setq data (read-line ff))
            (if (/= (setq data (str_trim_blank&trapmage data)) "")
                (progn
                     (setq pdata (read data))
                     (setq pdata1 (car pdata))
                     (setq pdata1 (tab pdata1 25))
                     (setq pdata2 (cadr pdata))
                     (setq pdata12 (strcat pdata1 " => " pdata2))
                     (setq needdata (append needdata (list pdata12)))
                );progn  
            );if  
       );while
       (close ff)
       needdata
       
  
  );defun
  (defun tab(str num / str_len )
       (setq str (str_trim_blank&trapmage str)) 
       (setq str_len (strlen str))
       ;(setq blk_len (- num str_len))
       (if (> num str_len)
           (progn
                (while (<= (strlen (setq str (strcat str " "))) num)
                );while
           );progn
           (progn
                (if (= num str_len)
                    (progn
                         (setq str str)
                    );progn
                    (progn
                         (setq str (substr str 1 num))
                    );progn
                );if
           );progn
        );if
        str
   );defun

         
              
             

(defun *error* (msg)
       (princ)
);defun

(defun write_systemini&trapmage(/ ff num  temp mm    forlist  )
             
        (setq ff (open (strcat powdesign_data_path "trap_dir.dat") "w"))
        (setq num nil)
        (setq temp nil)
        (if (/= #process_list nil)
            (progn
                 (trans_strtolist&trapmage)
                 (foreach mm #process_list
                      (setq forlist (append forlist (list (etos&trapmage  mm ))))
                 );foreach  
            );progn
            
        );if  
        (foreach mm forlist
               (write-line mm ff)
        );foreach  
        (close ff)
       
);defun



 (defun etos&trapmage (arg / file)
     (if (= 'STR (type arg)) (setq arg (strcat "\"" arg "\"")))
     (setq  file (open "$" "w"))
     (princ arg  file)
     (close file)
     (setq file (open "$" "r"))
     (setq arg (read-line file))
     (close file)
     arg
);eots&fun1




(defun traptype_inp_init&trapmage(/ s_num s_word s_postword)
     (setq #s_word_set     nil)
     (setq #s_postword_set nil)
     (foreach mm #process_list
            (setq s_num (string_search&trapmage mm "=>"))
            (setq s_word (strcase (substr  mm 1 (1- s_num))))
            (setq s_postword (strcase (substr  mm (+ s_num 3))))
            (setq s_word (str_trim_blank&trapmage s_word))
            (setq s_postword (str_trim_blank&trapmage s_postword))
            (setq #s_word_set     (append #s_word_set     (list s_word)))
            (setq #s_postword_set (append #s_postword_set (list s_postword)))
     );foreach
);defun

(defun str_trim_blank&trapmage(str / lprt rprt retstr)
     (setq Lprt 1)
     (setq rprt (strlen str))
     (while (= (substr str Lprt 1) " ")
            (setq Lprt (1+ Lprt))
     );while
     (while (= (substr str rprt 1) " ")
            (setq rprt (1- rprt))
     );while
    
     (setq retstr (substr str Lprt (1+ (- rprt Lprt))))
     retstr
);defun

(defun remove_one&trapmage (li obj / i ret_list nthdata)
     (setq i 0)
     (setq ret_list nil)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= nthdata obj) 
              (setq ret_list (append ret_list (list nthdata)))
          );if
          (setq i (1+ i))
     );while
     ret_list
);defun  
  
                          
          

                  

 
