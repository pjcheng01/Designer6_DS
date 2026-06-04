;;;
;;;
;;;
(defun c:fieldset(/   #path_dcl #upperdata #process_temp     #downdata exe_st
                    #process_list        #s_word_set       #s_postword_set    gf_val        mm   cmdecho_v
                    exetrans_flag        #class_data_list  #class_name_list   #old_classdef #filterclassdef
                    #filterclassdata     #init_set_list
               )
  
  
       (setq cmdecho_v (getvar "cmdecho"))
       (setvar "cmdecho" 0)
      
       (setq #path_dcl powdesign_DCL_PATH )
       (actdcl (strcat #path_dcl "fieldset") "fieldset")
       (setq #upperdata nil)
       (setq #process_temp nil)
       (setq #downdata nil)
       (setq exe_st 0)
       (setq gf_val nil)
       (setq #process_list nil)
       (setq #process_list (getfile_value&fieldset (strcat powdesign_PATH "dwgdata.txt")))
       (setq #process_list (acad_strlsort #process_list))
      ;|(if (/= (setq gf_val (vgetfile_val&fieldset (strcat powdesign_PATH "system.ini") "舊圖框屬性對應資訊點標籤")) nil)
                (setq a 2)
                (setq #process_list (read gf_val))
                (foreach mm #process_list
                         (setq #process_temp (cons (strcat (strcase (car mm)) " , " (strcase (cadr mm))) #process_temp))
                );foreach
                (setq #process_list (reverse #process_temp))
        );if      |;
  
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
       (unload_dialog dcl_id)
       ;(if (= exe_st 1)
       ;     (c:fieldset)
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
                (alert (strcat fname "檔案不存在!!"))
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
             
        (setq ff (open (strcat powdesign_path "dwgdata.txt") "w"))
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
