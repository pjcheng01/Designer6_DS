;;;
;;;┌────────────────────────────────┐
;;;│  程  式 :desinger版                                            │
;;;│  主程式 :subsys                                                │
;;;│  日  期 :89.11.16                                              │
;;;│  姓  名 :jacky                                                 │
;;;│  對話框 :                                                      │
;;;│  方  法 :                                                      │
;;;│  相關檔案:sub numList                                          │
;;;└────────────────────────────────┘
;subsys      -->次組合建立
;sub_on_off  -->次組合開關
;sub_remove  -->次組合解除
;part_deL    -->次組合部份增加
;part_cr     -->次組合部份解除
;sub_reverse -->次組合反向開關
 



; sub 代表 次組合
(defun c:subsys(/  #asm_path_dcl         #group_list    #ungroup_list    #asm_judge         #source_state_group_off
                   #source_state_asm_on  dcL_id         oker             #all_group         #non_inp_set
                   #partref_group_set    len_blance     #LSP_sub_name    #Lsp_draw_sel
                )
    ; (POWERSOFT_DESIGNER2000)
    ; (if (not (and (= piec_designer1 "#$%&") (=  piec_designer2 "###@")))
    ;     (exit)
    ; );if    
     (if (= (ssget "x") nil)
         (progn
              (alert "圖面無資料")
              (exit)
         );progn
     );if
     (setvar "cmdecho" 0)
     
     (setq #asm_path_dcl Powdesign_DCL_PATH)
     ;(setq #asm_path_data Powdesign_ASM_PATH)
     (setq #group_list nil)
     (setq #ungroup_list nil)
     (setq #asm_judge   nil)
     (setq #source_state_group_off nil)
     (setq #source_state_asm_on    nil)
     
     (setq #non_inp_set nil)
     
     (setq #LSP_sub_name nil)
     (setq #Lsp_draw_sel "1")
     (setq #all_group (coLL_Layer&fun1))
     (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
     (cond ( (=  #partref_group_set nil)
              
              (setq len_blance (getdata_YN "\n 完全未建立資訊點, 須建立(Y/N)? <N>: "))
              (if (= len_blance nil)
                  (setq len_blance "Y")
              );if      
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn  
                  (progn
                       (alert "\n 資訊點完全未建立 ")
                       (exit)
                  );progn  
              );if
           ) 
           ( (/= (length #all_group) (sslength #partref_group_set))
         
              (setq len_blance (getdata_YN "\n 是否自動檢查資訊點之建立(Y/N)? <N>: "))
              (if (= len_blance nil)
                  (setq len_blance "N")
              );if
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                       
                  );progn  
              );if
           );2 
     );cond
                                       
     (actdcl (strcat #asm_path_dcl "subasmset") "subsys")
     (generate_group&existasm&fun1)
     (mode_tile "sub_add" 0)
     (mode_tile "sub_del" 1)
  
     (mode_1&fun1)
    
     (set_tile  "cue"   "操作步驟: (1) 先輸入 {次組合名稱}, 按 [enter]" )  
     (set_tile  "cue1"  "          (2) 後選擇 {是否圖選}" ) 
     (mode_tile "sub_name" 2) 
     (action_tile "sub_name" "(subsys_name&fun1)") 
  
     (action_tile "p_list"  "(mode_tile \"sub_add\" 0) (mode_tile \"sub_del\" 1)")
     (action_tile "j_list"  "(mode_tile \"sub_add\" 1) (mode_tile \"sub_del\" 0)")  

     (action_tile "sub_add"  "(subsys_add&fun1)")
     (action_tile "sub_del"  "(subsys_deL&fun1)")
     (action_tile "draw_sel" "(subsys_draw_sel&fun1)")
     (action_tile "accept" "(setq oker 1)(done_dialog)")
     (action_tile "cancel" "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
     (start_dialog)
   (unload_dialog dcl_id)
    
     (unload_dialog dcl_id)
     (if (= oker 1)
         (progn
              (subsys_ok&fun1)
              ;(c:subsys)
         );progn  
       
     )
     (princ)
);defun

;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function before  DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘


;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function between DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
  (defun coll_layer&fun1(/ coll_layer_list ladata)
     (setq total_layer_list (list (cdadr (tblnext "layer" t))))
     (setq ladata (tblnext "layer"))
     (while ladata
          (setq total_layer_list (cons (strcase (cdadr ladata)) total_layer_list))
          (setq ladata (tblnext "layer"))
     );while
     total_layer_list
    
  );defun
  (defun  subsys_name&fun1()
        
          
          (if (and
                   (/= (get_tile "sub_name") "")
                   ;(/= #asm_judge nil)
                   (= (member (strcase (get_tile "sub_name")) #asm_judge) nil)
                   
              );and       
              (progn
                   (setq #LSP_sub_name (strcase (get_tile "sub_name")))
                   (setq #Lsp_draw_sel (get_tile "draw_sel"))
        
                   (set_tile "error" "")
                   (mode_2&fun1)
                   (set_tile "cue"  "" )
                   (set_tile "cue1"  "" )
              
               )
               (progn
                   (mode_tile  "accept"   1)
                   (set_tile  "cue"   "操作步驟: (1) 先輸入 {次組合名稱}, 按 [enter]" )  
                   (set_tile  "cue1"  "          (2) 後選擇 {是否圖選}" ) 
                   ;(set_tile "cue"  "提示: (1) 先輸入 {次組合名稱}, 按 [enter] --> (2)後選擇 {是否圖選}" )
                   (set_tile "error" "次組合名稱重覆或無資料輸入!")
               );progn
            
                   
          )
        
          
  );subsys_name



   (defun subsys_add&fun1 (/ p_list_msel    p_list_mp   group_list_nth    e1        e2
                             num1           num2        all_len1          all_len2  group_list_temp
                                            groupmanage_retval
                          );subsys_add
         (setq p_list_Msel (get_tile "p_list"))
         (if (/= p_list_Msel nil)
             (progn
                  (setq group_list_temp   #group_list)
                  (setq p_list_Msel (read (strcat "(" p_List_msel ")")))
                  (foreach p_list_mp p_list_msel
                           (setq group_list_nth (nth p_list_mp group_list_temp))
                           (setq groupmanage_retval (groupmanage&fun1  group_list_nth #group_list ".>>."  #ungroup_list))
                           (setq #group_list   (car groupmanage_retval))
                           (setq #ungroup_list (cadr groupmanage_retval))
                         
                  );foreach
                  (start_List "p_list" 3)
                  (mapcar 'add_list #group_list)
                  (end_list)
                  (start_List "j_list" 3)
                  (mapcar 'add_list #ungroup_list)
                  (end_list)
              );progn
           );if
    );defun_subsys_add&fun1

   (defun subsys_deL&fun1 (/ j_list_msel   j_list_mp   ungroup_list_nth   e1        e2
                             num1          num2        all_len1           all_len2  
                             ungroup_list_temp         groupmanage_retval
                           )
          (setq j_list_Msel (get_tile "j_list"))
          (if (/= j_list_msel nil)
              (progn
                   (setq ungroup_list_temp #ungroup_list)
                   (setq j_list_Msel (read (strcat "(" j_List_msel ")")))
                   (foreach j_list_mp j_list_msel
                          (setq ungroup_list_nth (nth   j_list_mp ungroup_list_temp))
                          (setq groupmanage_retval (groupmanage&fun1  ungroup_list_nth #group_list ".<<." #ungroup_list))
                          (setq #group_list   (car groupmanage_retval))
                          (setq #ungroup_list (cadr groupmanage_retval))
                   );foreach
                   (start_List "p_list" 3)
                   (mapcar 'add_list #group_list)
                   (end_list)
                   (start_List "j_list" 3)
                   (mapcar 'add_list #ungroup_list)
                   (end_list)
              );progn
          );if  
    );defun_subsys_deL&fun1
;}}}}}}
  

  (defun subsys_draw_sel&fun1(/ tlayer_list  asmfp       temp_group_list
                                asmdata      asmdata_key  asmdata_body     asmdata_key_body
                                asmdata_list asm_mp       temp_asmdata     asmdata_groupname
                                asm_code_groupname
                             )
         
         (if (= (get_tile "draw_sel") "1")
             (progn
                  (mode_3&fun1)
                  (setq #Lsp_draw_sel "1")
             );progn
             (progn
                  (mode_4&fun1)
                  (setq #Lsp_draw_sel "0")
                  
                  (start_List "p_list" 3)
                  (mapcar 'add_list #group_list)
                  (end_list)
                  (start_list "j_list" 3)
                  (mapcar 'add_list nil)
                  (end_list)
        
             );progn  
         );if  
  );defun
 






;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  main function  area                           │
;;;│                                                                │
;;;└────────────────────────────────┘

                                   ; or_num_w is order number written
 (defun subsys_ok&fun1  (/ p_list entdata_list mm)
      (cond (
               (= #Lsp_draw_sel "0")
               (setq p_list #ungroup_list)
            )
            (
               (= #Lsp_draw_sel "1")
               (setq p_list (loop_sel&fun1))
            )
            (t
              (alert "#Lsp_draw_sel無值!")
              (exit)
            )
       );cond
       (foreach mm p_list
              (setq entdata_list (get_bomdata&fun1 (get_bompent&fun1 mm)))
              (setq entdata_list (subst (list "TAG2" #LSP_sub_name) (assoc "TAG2" entdata_list )entdata_list))
              (addatt_tobomball (get_bompent&fun1 mm)  entdata_list)
       );forech
 );defun  
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
 (defun mode_1&fun1()
       (mode_tile "sub_name" 0)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "p_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "j_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 1)
       (mode_tile "accept" 1)
       (mode_tile "cancel" 0)
 );mode_1&fun1

 (defun mode_2&fun1()
       (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
       ;(mode_tile "n_popup"  0)
       (mode_tile "p_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "j_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept" 0)
       (mode_tile "cancel" 0)
 );mode_2

  
 (defun mode_3&fun1()
       (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "p_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "j_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_3
 (defun mode_4&fun1()
       (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "p_list"   0)
       (mode_tile "sub_add"  0) 
       (mode_tile "j_list"   0)
       (mode_tile "sub_del"  0)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_4
;}}}}}}




(defun loop_sel&fun1(/ ent entlist  entname     Layname8 entname_list mm source_state_group_off_240
                       source_state_asm_on_240  non_inp_set_240
                    )
       (setq source_state_group_off_240 nil)
       (setq source_state_asm_on_240  nil)
       (setq non_inp_set_240           nil)
       (foreach mm #source_state_group_off
              (setq source_state_group_off_240 (str_merge&fun1 source_state_group_off_240 mm))
       );foreach
       (foreach mm #source_state_asm_on
              (setq source_state_asm_on_240 (str_merge&fun1 source_state_asm_on_240 mm))
       );foreach
       (foreach mm #non_inp_set
              (setq non_inp_set_240 (str_merge&fun1 non_inp_set_240 mm))
       );foreach
       (setq ent 1)
       (setq entlist '())
       (init_finish&fun1 "init")
       (while (/= ent nil)
              (progn
                
                  (setq ent      (entsel "\n請選擇物件:<離開 按enter> "))
                  
                  (if (/= ent nil)
                      (progn
                           (setq entname  (car ent))
                           (redraw entname 3)
                           (setq Layname8 (cdr (assoc 8 (entget entname))))
                           (setq entname_list (cons entname entname_list))
                           (setq entlist  (cons (strcase Layname8) entlist))
                      )
                  )
                );progn
        );while
        
        (foreach mm entname_list
                 (redraw mm 4)
        );foreach
        (init_finish&fun1 "finish")
        entlist
  
);defun loop_sel&fun1


 (defun *error* (msg)
       (princ)
)  

(defun generate_group&existasm&fun1(/  mm assoc_data tag2data)
     
   
    
     (foreach mm  (all_infp&fun1)
            (setq assoc_data  (assoc "TAG2" (get_bomdata&fun1 mm)))
            (if (/= assoc_data nil)
                (progn
                     (setq mm (strcase (cdr (assoc 8 (entget mm)))))
                     (setq tag2data (strcase(cadr assoc_data)))
                     (if (or (= tag2data nil)
                             (= tag2data "")
                         );or
                         (progn
                              ;(setq tag2data (strcase tag2data))
                              (setq #group_list (append #group_list (list mm)))
                              (if (< (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                  (setq #source_state_group_off  (append #source_state_group_off (list mm)))
                              );if
                         );progn
                         (progn
                              (if (= (member tag2data #asm_judge) nil)
                                  (setq #asm_judge  (append #asm_judge (list tag2data)))
                              );if      
                              (if (>= (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                  (setq #source_state_asm_on  (append #source_state_asm_on (list mm)))
                              );if
                         );progn  
                     );if
                     
                );progn  
            );if  
            
     );foreach
     (setq #group_list (acad_strlsortp #group_list))
     
     
);defun

(defun all_infp&fun1(/ ent laname all_ent_set i )
  (setq ent nil) 
  ;(setq laname (strcase lname))
  (setq all_ent_set nil)  
  (setq #non_inp_set #all_group)
  (if #partref_group_set
      (progn
           (setq i 0)
           (while (setq ent (ssname #partref_group_set i))
                (setq all_ent_set (append all_ent_set (list ent)))
                (setq #non_inp_set (remove_one&fun1 (strcase (cdr (assoc 8 (entget ent))))#non_inp_set ))
                (setq i (1+ i))
           );while
      );progn   
  );if
  all_ent_set 
);defun

(defun get_bompent&fun1(lname / partref_group laname ent)
  (setq ent nil) 
  (setq laname (strcase lname))
  (setq partref_group (ssget "x" (list (cons 8 laname) (cons 0 "INSERT")(cons 2 "PARTREF"))))
  (if partref_group
     (setq ent (ssname partref_group 0))
  );if
  ent
);defun

(defun get_bomdata&fun1(ballname / nextent datalist nextent_data nextent_data2 nextent_data1)
   (if (/= ballname nil)
       (progn
            (setq nextent (entnext ballname) datalist '())
            (setq nextent_data (entget nextent))
            (while (= "ATTRIB" (cdr (assoc 0 nextent_data)))
                   (setq nextent_data2 (cdr (assoc 2 nextent_data)) )
                   (setq nextent_data1 (cdr (assoc 1 nextent_data)) )
                   (setq datalist (cons (list nextent_data2 nextent_data1) datalist))
                   (setq nextent (entnext nextent))
                   (setq nextent_data (entget nextent))
            );while
        );progn
   );if  
   datalist
);defun

(defun groupmanage&fun1(  element grp_list  action_type Ungrp_list )
     (setq action_type (strcase action_type))
     (setq element (strcase element))
     (cond (;|add|; (= action_type ".>>.")
                    (setq grp_list (remove_one&fun1 element grp_list ))
                    (setq Ungrp_list (append Ungrp_list (list  element)))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
                    
            
           );add
           (;|del|; (= action_type ".<<.")
                    (setq grp_list (append grp_list (list  element)))
                    (setq Ungrp_list (remove_one&fun1 element Ungrp_list ))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
           );del
     );cond
 );defun 
                   
(defun remove_one&fun1 ( obj li /  remove_flag i ret_list nthdata)
     (setq ret_list nil)
     (setq i 0)
     (setq remove_flag nil)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= (strcase nthdata)(strcase obj)) 
              (setq ret_list (append ret_list (list nthdata)))
              (setq remove_flag t)
          );if
          (setq i (1+ i))
     );while
     (if (=  remove_flag nil)
         (setq ret_list li)
         (setq ret_list ret_list)
     );if
     
);defun




(defun init_finish&fun1(in_fi / mm);in_fi:init_finish
     (cond (;|init|;
              (= (strcase in_fi) "INIT")
              (foreach mm source_state_group_off_240
                     (command "-layer" "on" mm "")
              );foreach
              (foreach mm source_state_asm_on_240
                     (layeroff&fun1 mm)
              );foreach
              (foreach mm non_inp_set_240
                     (layeroff&fun1 mm)
              );foreach
           );init
           (;|finish|;
              (= (strcase in_fi) "FINISH")
              (foreach mm source_state_group_off_240
                     (layeroff&fun1 mm)
              );foreach
              (foreach mm source_state_asm_on_240
                     (command "-layer" "on" mm "")
              );foreach
              (foreach mm non_inp_set_240
                     (command "-layer" "on" mm "")
              );foreach
           );finish
       );COND
 );defun

(defun layeroff&fun1(en)
     (setq en (strcat "," en))
     (if (/= (string_search&fun1 (strcase en) (strcat ","(getvar "clayer") ",") ) nil)
         (command "-layer" "off" en "y" "")
         (command "-layer" "off" en "")
     );if
);defun



 (defun str_merge&fun1(li str / reverse_data  merge_str  merge_list mergedata)
      (setq reverse_data (reverse li))
      (setq merge_str  (car reverse_data))
      (setq merge_list (cdr reverse_data))
   
      (if (= merge_str nil)
          (setq merge_str ",")
      );if
      (if (<= (strlen (setq mergedata (strcat merge_str  "," str ","))) 240)
          (progn
               (if (= merge_str ",")
                   (setq merge_str str)
                   (setq merge_str mergedata)
               );if      
               (setq merge_list (cons merge_str merge_list))
               (setq merge_list (reverse merge_list))
          );progn
          (progn
               (setq merge_list (append li (list str)))
          );progn  
      );if
      merge_list
  );defun 
  (defun string_search&fun1(string search_s / prt flag string_len search_s_len find_s)
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

;************************************************************************************************************



 ;;;┌────────────────────────────────┐
 ;;;│  程  式 :desinger版                                            │
 ;;;│  主程式 :part_cr                                               │
 ;;;│  日  期 :89.11.22                                              │
 ;;;│  姓  名 :jacky                                                 │
 ;;;│  對話框 :                                                      │
 ;;;│  方  法 :                                                      │
 ;;;│  相關檔案:sub numList                                          │
 ;;;└────────────────────────────────┘
 



; sub 代表 次組合
(defun c:part_cr(/  #asm_path_dcl         #group_list    #ungroup_list    #asm_judge        #source_state_group_off
                   #source_state_asm_on  dcL_id         oker             #all_group         #non_inp_set
                   #partref_group_set    len_blance     #LSP_sub_name    #Lsp_draw_sel      #asm_data
                   #have_asmdata_list
                )
    ; (POWERSOFT_DESIGNER2000)
    ; (if (not (and (= piec_designer1 "#$%&") (=  piec_designer2 "###@")))
    ;     (exit)
    ; );if    
     (if (= (ssget "x") nil)
         (progn
              (alert "圖面無資料")
              (exit)
         );progn
     );if                    
     (setvar "cmdecho" 0)
     (setq #asm_path_dcl Powdesign_DCL_PATH)
     ;(setq #asm_path_data Powdesign_ASM_PATH)
     (setq #group_list nil)
     (setq #ungroup_list nil)
     (setq #asm_judge   nil)
     (setq #source_state_group_off nil)
     (setq #source_state_asm_on    nil)
     (setq #have_asmdata_list nil)
     (setq #non_inp_set nil)
     (setq #LSP_sub_name nil)
     (setq #Lsp_draw_sel "1")
     
     (setq #all_group (coLL_Layer&part_cr))
     (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
  
     (cond ( (=  #partref_group_set nil)
              
              (setq len_blance (getdata_YN "\n 完全未建立資訊點, 須建立(Y/N)? <Y>: "))
              (if (= len_blance nil)
                  (setq len_blance "Y")
              );if      
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                       
                  );progn  
                  (progn
                       (alert "\n 資訊點完全未建立 ")
                       (exit)
                  );progn  
              );if
           ) 
           ( (/= (length #all_group) (sslength #partref_group_set))
         
              (setq len_blance (getdata_YN "\n 是否自動檢查資訊點之建立(Y/N)? <N>: "))
              (if (= len_blance nil)
                  (setq len_blance "N")
              );if
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn
              );if
           );2 
     );cond
                                       
     
     (generate_group&existasm&part_cr)
     (if (= #asm_judge nil)
         (progn
              (alert "\n無次組合資料, 請建立次組合!!")
              (exit)
         );progn
     );if
  
     (actdcl (strcat #asm_path_dcl "subasmset") "part_cr")
     (to_box_subname&part_cr)

     (mode_tile "sub_add" 0)
     (mode_tile "sub_del" 1)
  
     (mode_1&part_cr)
    
     ;(set_tile  "cue"  "提示: (1) 先選擇 {次組合名稱} --> (2)後選擇 {是否圖選}" )  
     ;(mode_tile "sub_name" 2)

     (action_tile "sub_name" "(subsys_name&part_cr)")
  
     (action_tile "p_list"  "(mode_tile \"sub_add\" 0) (mode_tile \"sub_del\" 1)")
     (action_tile "j_list"  "(mode_tile \"sub_add\" 1) (mode_tile \"sub_del\" 0)")  

     (action_tile "sub_add"  "(subsys_add&part_cr)")
     (action_tile "sub_del"  "(subsys_deL&part_cr)")
     (action_tile "draw_sel" "(subsys_draw_sel&part_cr)")
     (action_tile "accept" "(setq oker 1)(done_dialog)")
     (action_tile "cancel" "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
     (start_dialog)
   (unload_dialog dcl_id)
    
     (unload_dialog dcl_id)
     (if (= oker 1)
         (progn
              (subsys_ok&part_cr)
              ;(c:subsys)
         );progn  
       
     )
     (princ)
);defun

;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function before  DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘


;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function between DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
  (defun to_box_subname&part_cr()
     ; (start_List "sub_name" 3)
     ; (mapcar 'add_list #asm_judge)
     ; (end_list)

      (act_pop_list #asm_judge "sub_name")
  );defun  
    
  (defun coll_layer&part_cr(/ coll_layer_list ladata)
     (setq total_layer_list (list (cdadr (tblnext "layer" t))))
     (setq ladata (tblnext "layer"))
     (while ladata
          (setq total_layer_list (cons (strcase (cdadr ladata)) total_layer_list))
          (setq ladata (tblnext "layer"))
     );while
     total_layer_list
    
  );defun
  (defun  subsys_name&part_cr(/ acad_strlsorttemp)
        
          (setq #LSP_sub_name (nth (atoi (get_tile "sub_name"))  #asm_judge))
          (setq #Lsp_draw_sel (get_tile "draw_sel"))
          (set_tile "error" "")
          (mode_2&part_cr)
          ;(set_tile "cue"  "提示:" )
    
          (setq acad_strlsorttemp (acad_strlsortp (cdr (assoc #LSP_sub_name #have_asmdata_list))))

          ;(start_List "c_list" 3)
          ;(mapcar 'add_list acad_strlsorttemp)
          ;(end_list)
          (act_pop_list acad_strlsorttemp "c_list")
                 
  );subsys_name

   (defun subsys_add&part_cr (/ p_list_msel    p_list_mp   group_list_nth    e1        e2
                             num1           num2        all_len1          all_len2  group_list_temp
                                            groupmanage_retval
                          );subsys_add
         (setq p_list_Msel (get_tile "p_list"))
         (if (/= p_list_Msel nil)
             (progn
                  (setq group_list_temp   #group_list)
                  (setq p_list_Msel (read (strcat "(" p_List_msel ")")))
                  (foreach p_list_mp p_list_msel
                           (setq group_list_nth (nth p_list_mp group_list_temp))
                           (setq groupmanage_retval (groupmanage&part_cr  group_list_nth #group_list ".>>."  #ungroup_list))
                           (setq #group_list   (car groupmanage_retval))
                           (setq #ungroup_list (cadr groupmanage_retval))
                         
                  );foreach
                  ;(start_List "p_list" 3)
                  ;(mapcar 'add_list #group_list)
                  ;(end_list)
                  (act_pop_list #group_list "p_list")
                  ;(start_List "j_list" 3)
                  ;(mapcar 'add_list #ungroup_list)
                  ;(end_list)
                  (act_pop_list #ungroup_list "j_list")
              );progn
           );if
    ) ;defun_subsys_add&part_cr

  (defun subsys_deL&part_cr (/ j_list_msel   j_list_mp   ungroup_list_nth   e1        e2
                             num1          num2        all_len1           all_len2  
                             ungroup_list_temp         groupmanage_retval
                           )
          (setq j_list_Msel (get_tile "j_list"))
          (if (/= j_list_msel nil)
              (progn
                   (setq ungroup_list_temp #ungroup_list)
                   (setq j_list_Msel (read (strcat "(" j_List_msel ")")))
                   (foreach j_list_mp j_list_msel
                          (setq ungroup_list_nth (nth   j_list_mp ungroup_list_temp))
                          (setq groupmanage_retval (groupmanage&part_cr  ungroup_list_nth #group_list ".<<." #ungroup_list))
                          (setq #group_list   (car groupmanage_retval))
                          (setq #ungroup_list (cadr groupmanage_retval))
                   );foreach
                   ;(start_List "p_list" 3)
                   ;(mapcar 'add_list #group_list)
                   ;(end_list)
                   (act_pop_list #group_list "p_list")
                   ;(start_List "j_list" 3)
                   ;(mapcar 'add_list #ungroup_list)
                   ;(end_list)
                   (act_pop_list #ungroup_list "j_list")
              );progn
          );if  
    );defun_subsys_deL&part_cr
;}}}}}}
  

  (defun subsys_draw_sel&part_cr(/ tlayer_list  asmfp       temp_group_list
                                asmdata      asmdata_key  asmdata_body     asmdata_key_body
                                asmdata_list asm_mp       temp_asmdata     asmdata_groupname
                                asm_code_groupname
                             )
         
         (if (= (get_tile "draw_sel") "1")
             (progn
                  (mode_3&part_cr)
                  (setq #Lsp_draw_sel "1")
             );progn
             (progn
                  (mode_4&part_cr)
                  (setq #Lsp_draw_sel "0")
                  
                  (start_List "p_list" 3)
                  (mapcar 'add_list #group_list)
                  (end_list)
                  (start_list "j_list" 3)
                  (mapcar 'add_list nil)
                  (end_list)
        
             );progn  
         );if  
  );defun
 






;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  main function  area                           │
;;;│                                                                │
;;;└────────────────────────────────┘

                                   ; or_num_w is order number written
 (defun subsys_ok&part_cr  (/ p_list entdata_list mm)
      (cond (
               (= #Lsp_draw_sel "0")
               (setq p_list #ungroup_list)
            )
            (
               (= #Lsp_draw_sel "1")
               (setq p_list (loop_sel&part_cr))
               ;(setq p_list (append p_list #ungroup_list))
            )
            (t
              (alert "#Lsp_draw_sel無值!")
              (exit)
            )
       );cond
       (foreach mm p_list
              (setq entdata_list (get_bomdata&part_cr (get_bompent&part_cr mm)))
              (setq entdata_list (subst (list "TAG2" #LSP_sub_name) (assoc "TAG2" entdata_list )entdata_list))
              (addatt_tobomball (get_bompent&part_cr mm)  entdata_list)
       );forech
 );defun  
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
 (defun mode_1&part_cr()
       (mode_tile "sub_name" 0)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "p_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "j_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 1)
       (mode_tile "accept" 1)
       (mode_tile "cancel" 0)
 );mode_1&part_cr

 (defun mode_2&part_cr()
       (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
       ;(mode_tile "n_popup"  0)
       (mode_tile "p_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "j_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept" 0)
       (mode_tile "cancel" 0)
 );mode_2

  
 (defun mode_3&part_cr()
       (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "p_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "j_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_3
 (defun mode_4&part_cr()
       (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "p_list"   0)
       (mode_tile "sub_add"  0) 
       (mode_tile "j_list"   0)
       (mode_tile "sub_del"  0)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_4
;}}}}}}




(defun loop_sel&part_cr(/ ent entlist entname  Layname8 entname_list mm
                          source_state_group_off_240    source_state_asm_on_240
                          non_inp_set_240
                       )
       (setq source_state_group_off_240 nil)
       (setq source_state_asm_on_240  nil)
       (setq non_inp_set_240           nil)
       (foreach mm #source_state_group_off
              (setq source_state_group_off_240 (str_merge&part_cr source_state_group_off_240 mm))
       );foreach
       (foreach mm #source_state_asm_on
              (setq source_state_asm_on_240 (str_merge&part_cr source_state_asm_on_240 mm))
       );foreach
       (foreach mm #non_inp_set
              (setq non_inp_set_240 (str_merge&part_cr non_inp_set_240 mm))
       );foreach
       (setq ent 1)
       (setq entlist '())
       (init_finish&part_cr "init")
       (while (/= ent nil)
              (progn
                
                  (setq ent      (entsel "\n請選擇物件:<離開 按enter> "))
                  
                  (if (/= ent nil)
                      (progn
                           (setq entname  (car ent))
                           (redraw entname 3)
                           (setq Layname8 (cdr (assoc 8 (entget entname))))
                           (setq entname_list (cons entname entname_list))
                           (setq entlist  (cons (strcase Layname8) entlist))
                      )
                  )
                );progn
        );while
        
        (foreach mm entname_list
                 (redraw mm 4)
        );foreach
        (init_finish&part_cr "finish")
        entlist
  
);defun loop_sel&part_cr



 (defun *error* (msg)
       (princ)
 );defun


(defun generate_group&existasm&part_cr(/  mm assoc_data tag2data assoc_asmdata new_assoc_asmdata)
     
   
    
     (foreach mm  (all_infp&part_cr)
            (setq assoc_data  (assoc "TAG2" (get_bomdata&part_cr mm)))
            (if (/= assoc_data nil)
                (progn
                     (setq mm (strcase (cdr (assoc 8 (entget mm)))))
                     (setq tag2data  (strcase (cadr assoc_data)))
                     (if (or (= tag2data nil)
                             (= tag2data "")
                         );or
                         (progn
                              ;(setq tag2data (strcase tag2data))
                              (setq #group_list (append #group_list (list mm)))
                              (if (< (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                  (setq #source_state_group_off  (append #source_state_group_off (list mm)))
                              );if
                         );progn
                         (progn
                              (if (= (setq assoc_asmdata (assoc tag2data #have_asmdata_list)) nil)
                                  (progn
                                       (setq #have_asmdata_list  (append #have_asmdata_list (list (list tag2data mm))))
                                  );progn
                                  (progn
                                       (setq new_assoc_asmdata  (append assoc_asmdata (list mm)))
                                       (setq #have_asmdata_list (subst new_assoc_asmdata assoc_asmdata #have_asmdata_list))
                                  );progn
                              );if      
                              (if (= (member tag2data #asm_judge) nil)      
                                  (setq #asm_judge  (append #asm_judge (list tag2data)))
                              );if      
                              (if (>= (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                  (setq #source_state_asm_on  (append #source_state_asm_on (list mm)))
                              );if
                         );progn  
                     );if
                     
                );progn  
            );if  
            
     );foreach
     (setq #group_list (acad_strlsortp #group_list)) 
);defun

(defun all_infp&part_cr(/ ent laname all_ent_set i )
  (setq ent nil) 
  ;(setq laname (strcase lname))
  (setq all_ent_set nil)  
  (setq #non_inp_set #all_group)
  (if #partref_group_set
      (progn
           (setq i 0)
           (while (setq ent (ssname #partref_group_set i))
                (setq all_ent_set (append all_ent_set (list ent)))
                (setq #non_inp_set (remove_one&part_cr (strcase (cdr (assoc 8 (entget ent))))#non_inp_set ))
                (setq i (1+ i))
           );while
      );progn   
  );if
  all_ent_set 
);defun

(defun get_bompent&part_cr(lname / partref_group laname ent)
  (setq ent nil) 
  (setq laname (strcase lname))
  (setq partref_group (ssget "x" (list (cons 8 laname) (cons 0 "INSERT")(cons 2 "PARTREF"))))
  (if partref_group
     (setq ent (ssname partref_group 0))
  );if
  ent
);defun

(defun get_bomdata&part_cr(ballname / nextent datalist nextent_data nextent_data2 nextent_data1)
   (if (/= ballname nil)
       (progn
            (setq nextent (entnext ballname) datalist '())
            (setq nextent_data (entget nextent))
            (while (= "ATTRIB" (cdr (assoc 0 nextent_data)))
                   (setq nextent_data2 (cdr (assoc 2 nextent_data)) )
                   (setq nextent_data1 (cdr (assoc 1 nextent_data)) )
                   (setq datalist (cons (list nextent_data2 nextent_data1) datalist))
                   (setq nextent (entnext nextent))
                   (setq nextent_data (entget nextent))
            );while
        );progn
   );if  
   datalist
);defun
(defun groupmanage&part_cr(  element grp_list  action_type Ungrp_list )
     (setq action_type (strcase action_type))
     (setq element (strcase element))
     (cond (;|add|; (= action_type ".>>.")
                    (setq grp_list (remove_one&part_cr element grp_list ))
                    (setq Ungrp_list (append Ungrp_list (list  element)))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
                    
            
           );add
           (;|del|; (= action_type ".<<.")
                    (setq grp_list (append grp_list (list  element)))
                    (setq Ungrp_list (remove_one&part_cr element Ungrp_list ))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
           );del
     );cond
 );defun
 
                   


(defun remove_one&part_cr ( obj li / remove_flag i ret_list nthdata)
     (setq i 0)
     (setq remove_flag nil)
     (setq ret_list nil)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= (strcase nthdata)(strcase obj)) 
              (setq ret_list (append ret_list (list nthdata)))
              (setq remove_flag t)
          );if
          (setq i (1+ i))
     );while
     (if (=  remove_flag nil)
         (setq ret_list li)
         (setq ret_list ret_list)
     );if  
);defun



(defun init_finish&part_cr(in_fi / mm);in_fi:init_finish
     
     (cond (;|init|;
              (= (strcase in_fi) "INIT")
              (foreach mm source_state_group_off_240
                     (command "-layer" "on" mm "")
              );foreach
              (foreach mm source_state_asm_on_240
                     (layeroff&part_cr mm)
              );foreach
              (foreach mm non_inp_set_240
                     (layeroff&part_cr mm)
              );foreach
           );init
           (;|finish|;
              (= (strcase in_fi) "FINISH")
              (foreach mm source_state_group_off_240
                     (layeroff&part_cr mm)
              );foreach
              (foreach mm source_state_asm_on_240
                     (command "-layer" "on" mm "")
              );foreach
              (foreach mm non_inp_set_240
                     (command "-layer" "on" mm "")
              );foreach
           );finish
       );COND
 );defun

(defun layeroff&part_cr(en)
     (setq en (strcat "," en))
     (if (/= (string_search&part_cr (strcase en) (strcat ","(getvar "clayer") ",") ) nil)
         (command "-layer" "off" en "y" "")
         (command "-layer" "off" en "")
     );if
);defun



 (defun str_merge&part_cr(li str / reverse_data  merge_str  merge_list mergedata)
      (setq reverse_data (reverse li))
      (setq merge_str  (car reverse_data))
      (setq merge_list (cdr reverse_data))
   
      (if (= merge_str nil)
          (setq merge_str ",")
      );if
      (if (<= (strlen (setq mergedata (strcat merge_str  "," str ","))) 240)
          (progn
               (if (= merge_str ",")
                   (setq merge_str str)
                   (setq merge_str mergedata)
               );if      
               (setq merge_list (cons merge_str merge_list))
               (setq merge_list (reverse merge_list))
          );progn
          (progn
               (setq merge_list (append li (list str)))
          );progn  
      );if
      merge_list
  );defun 
  (defun string_search&part_cr(string search_s / prt flag string_len search_s_len find_s)
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


;**********************************************************************************************************



 ;;;┌────────────────────────────────┐
 ;;;│  程  式 :desinger版                                            │
 ;;;│  主程式 :part_DEL                                              │
 ;;;│  日  期 :89.11.22                                              │
 ;;;│  姓  名 :jacky                                                 │
 ;;;│  對話框 :                                                      │
 ;;;│  方  法 :                                                      │
 ;;;│  相關檔案:sub numList                                          │
 ;;;└────────────────────────────────┘
 



; sub 代表 次組合
(defun c:part_DEL(/  #asm_path_dcl         #group_list    #ungroup_list    #asm_judge        #source_state_group_on
                   #source_state_asm_on    dcL_id         oker             #all_group        #non_inp_set
                   #partref_group_set      len_blance     #LSP_sub_name    #Lsp_draw_sel     #asm_data
                   #current_group_list_off #have_asmdata_list
                )
    ; (POWERSOFT_DESIGNER2000)
    ; (if (not (and (= piec_designer1 "#$%&") (=  piec_designer2 "###@")))
    ;     (exit)
    ; );if    
     (if (= (ssget "x") nil)
         (progn
              (alert "圖面無資料")
              (exit)
         );progn
     );if                    
     (setvar "cmdecho" 0)
     (setq #asm_path_dcl Powdesign_DCL_PATH)
     ;(setq #asm_path_data Powdesign_ASM_PATH)
     (setq #group_list nil)
     (setq #ungroup_list nil)
     (setq #asm_judge   nil)
     (setq #source_state_group_on nil)
     (setq #source_state_asm_on    nil)
     (setq #have_asmdata_list nil)
     (setq #non_inp_set nil)
     (setq #LSP_sub_name nil)
     (setq #Lsp_draw_sel "1")
     
     (setq #current_group_list_off nil)
     (setq #all_group (coLL_Layer&part_DEL))
     (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
             
     (cond ( (=  #partref_group_set nil)
              
              (setq len_blance (getdata_YN "\n 完全未建立資訊點, 須建立(Y/N)? <Y>:"))
              (if (= len_blance nil)
                  (setq len_blance "Y")
              );if      
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn  
                  (progn
                       (alert "\n 資訊點完全未建立 ")
                       (exit)
                  );progn  
              );if
           ) 
           ( (/= (length #all_group) (sslength #partref_group_set))
         
              (setq len_blance (getdata_YN "\n 是否自動檢查資訊點之建立(Y/N)? <N>: "))
              (if (= len_blance nil)
                  (setq len_blance "N")
              );if
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn  
              );if
           );2 
     );cond  
                                       
     
     (generate_group&existasm&part_DEL)
     (if (= #asm_judge nil)
         (progn
              (alert "\n無次組合資料, 請建立次組合!!")
              (exit)
         );progn
     );if
  
     (actdcl (strcat #asm_path_dcl "subasmset") "part_del")
     (to_box_subname&part_DEL)
     (mode_tile "sub_add" 0)
     (mode_tile "sub_del" 1)
  
     (mode_1&part_DEL)
    
     ;(set_tile  "cue"  "提示: (1) 先選擇 {次組合名稱} --> (2)後選擇 {是否圖選}" )  
     ;(mode_tile "sub_name" 2) 
     (action_tile "sub_name" "(subsys_name&part_DEL)") 
  
     (action_tile "c_list"  "(mode_tile \"sub_add\" 0) (mode_tile \"sub_del\" 1)")
     (action_tile "out_list"  "(mode_tile \"sub_add\" 1) (mode_tile \"sub_del\" 0)")  

     (action_tile "sub_add"  "(subsys_add&part_DEL)")
     (action_tile "sub_del"  "(subsys_deL&part_DEL)")
     (action_tile "draw_sel" "(subsys_draw_sel&part_DEL)")
     (action_tile "accept" "(setq oker 1)(done_dialog)")
     (action_tile "cancel" "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
     (start_dialog)
   (unload_dialog dcl_id)
    
     (unload_dialog dcl_id)
     (if (= oker 1)
         (progn
              (subsys_ok&part_DEL)
              ;(c:subsys)
         );progn  
       
     )
     (princ)
);defun

;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function before  DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘


;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function between DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
  (defun to_box_subname&part_DEL()
      ;(start_List "sub_name" 3)
      ;(mapcar 'add_list #asm_judge)
      ;(end_list)
      (act_pop_list #asm_judge "sub_name")
  );defun  
    
  (defun coll_layer&part_DEL(/ coll_layer_list ladata)
     (setq total_layer_list (list (cdadr (tblnext "layer" t))))
     (setq ladata (tblnext "layer"))
     (while ladata
          (setq total_layer_list (cons (strcase (cdadr ladata)) total_layer_list))
          (setq ladata (tblnext "layer"))
     );while
     total_layer_list
    
  );defun
  (defun  subsys_name&part_DEL(/ mm remove_retval len_before)
        
          (setq #LSP_sub_name (nth (atoi (get_tile "sub_name"))  #asm_judge))
          (setq #Lsp_draw_sel (get_tile "draw_sel"))
          (set_tile "error" "")
          (mode_2&part_DEL)
          ;(set_tile "cue"  "提示:" )
          (setq #group_list (acad_strlsortp (cdr (assoc #LSP_sub_name #have_asmdata_list))))
          (foreach mm #group_list
                
                  (if (< (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                      (setq #current_group_list_off (append #current_group_list_off (list mm)))
                  );if  
          );foreach  
          
                 
  );subsys_name

   (defun subsys_add&part_DEL (/ p_list_msel    p_list_mp   group_list_nth    e1        e2
                                 num1           num2        all_len1          all_len2  group_list_temp
                                 groupmanage_retval
                          );subsys_add
         (setq p_list_Msel (get_tile "c_list"))
         (if (/= p_list_Msel nil)
             (progn
                  (setq group_list_temp   #group_list)
                  (setq p_list_Msel (read (strcat "(" p_List_msel ")")))
                  (foreach p_list_mp p_list_msel
                           (setq group_list_nth (nth p_list_mp group_list_temp))
                           (setq groupmanage_retval (groupmanage&part_DEL  group_list_nth #group_list ".>>."  #ungroup_list))
                           (setq #group_list   (car groupmanage_retval))
                           (setq #ungroup_list (cadr groupmanage_retval))
                         
                  );foreach
                  ;(start_List "c_list" 3)
                  ;(mapcar 'add_list #group_list)
                  ;(end_list)
                  (act_pop_list #group_list "c_list")
                  ;(start_List "out_list" 3)
                  ;(mapcar 'add_list #ungroup_list)
                  ;(end_list)
                  (act_pop_list #ungroup_list "out_list")
              );progn
           );if
    ) ;defun_subsys_add&part_DEL

  (defun subsys_deL&part_DEL (/ j_list_msel   j_list_mp   ungroup_list_nth   e1        e2
                             num1          num2        all_len1           all_len2  
                             ungroup_list_temp         groupmanage_retval
                           )
          (setq j_list_Msel (get_tile "out_list"))
          (if (/= j_list_msel nil)
              (progn
                   (setq ungroup_list_temp #ungroup_list)
                   (setq j_list_Msel (read (strcat "(" j_List_msel ")")))
                   (foreach j_list_mp j_list_msel
                          (setq ungroup_list_nth (nth   j_list_mp ungroup_list_temp))
                          (setq groupmanage_retval (groupmanage&part_DEL  ungroup_list_nth #group_list ".<<." #ungroup_list))
                          (setq #group_list   (car groupmanage_retval))
                          (setq #ungroup_list (cadr groupmanage_retval))
                   );foreach
                   ;(start_List "c_list" 3)
                   ;(mapcar 'add_list #group_list)
                   ;(end_list)
                   (act_pop_list #group_list "c_list")
                   ;(start_List "out_list" 3)
                   ;(mapcar 'add_list #ungroup_list)
                   ;(end_list)
                   (act_pop_list #ungroup_list "out_list")
              );progn
          );if  
    );defun_subsys_deL&part_DEL
;}}}}}}
  

  (defun subsys_draw_sel&part_DEL(/ tlayer_list  asmfp       temp_group_list
                                asmdata      asmdata_key  asmdata_body     asmdata_key_body
                                asmdata_list asm_mp       temp_asmdata     asmdata_groupname
                                asm_code_groupname
                             )
         
         (if (= (get_tile "draw_sel") "1")
             (progn
                  (mode_3&part_DEL)
                  (setq #Lsp_draw_sel "1")
             );progn
             (progn
                  (mode_4&part_DEL)
                  (setq #Lsp_draw_sel "0")
                  ;(start_List "c_list" 3)
                  ;(mapcar 'add_list #group_list)
                  ;(end_list)
                  (act_pop_list #group_list "c_list")
                  ;(start_list "out_list" 3)
                  ;(mapcar 'add_list nil)
                  ;(end_list)
                  (act_pop_list '() "out_list")
        
             );progn  
         );if  
  );defun
 






;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  main function  area                           │
;;;│                                                                │
;;;└────────────────────────────────┘

                                   ; or_num_w is order number written
 (defun subsys_ok&part_DEL  (/ p_list entdata_list mm)
      (cond (
               (= #Lsp_draw_sel "0")
               (setq p_list #ungroup_list)
            )
            (
               (= #Lsp_draw_sel "1")
               (setq p_list (loop_sel&part_DEL))
            )
            (t
              (alert "#Lsp_draw_sel無值!")
              (exit)
            )
       );cond
       (foreach mm p_list
              (setq entdata_list (get_bomdata&part_DEL (get_bompent&part_DEL mm)))
              (setq entdata_list (subst (list "TAG2" "") (assoc "TAG2" entdata_list )entdata_list))
              (addatt_tobomball (get_bompent&part_DEL mm)  entdata_list)
       );forech
 );defun  
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
 (defun mode_1&part_DEL()
       (mode_tile "sub_name" 0)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "c_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "out_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 1)
       (mode_tile "accept" 1)
       (mode_tile "cancel" 0)
 );mode_1&part_DEL

 (defun mode_2&part_DEL()
       (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
       ;(mode_tile "n_popup"  0)
       (mode_tile "c_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "out_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept" 0)
       (mode_tile "cancel" 0)
 );mode_2

  
 (defun mode_3&part_DEL()
       (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "c_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "out_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_3
 (defun mode_4&part_DEL()
       (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "c_list"   0)
       (mode_tile "sub_add"  0) 
       (mode_tile "out_list"   0)
       (mode_tile "sub_del"  0)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_4
;}}}}}}




(defun loop_sel&part_DEL(/ ent                       entlist         entname
                           Layname8                  entname_list    mm
                           source_state_group_on_240 source_state_asm_on_240
                           non_inp_set_240           group_list_240   current_group_list_off_240
                        )
       (setq source_state_group_on_240 nil)
       (setq source_state_asm_on_240   nil)
       (setq non_inp_set_240           nil)
       (setq group_list_240            nil)
       (setq current_group_list_off_240 nil)
       (foreach mm #source_state_group_on
              (setq source_state_group_on_240 (str_merge&part_DEL source_state_group_on_240 mm))
       );foreach
       (foreach mm #source_state_asm_on
              (setq source_state_asm_on_240 (str_merge&part_DEL source_state_asm_on_240 mm))
       );foreach
       (foreach mm #group_list
              (setq group_list_240 (str_merge&part_DEL group_list_240 mm))
       )
       (foreach mm #current_group_list_off
              (setq current_group_list_off_240 (str_merge&part_DEL current_group_list_off_240 mm))
       )
       (foreach mm #non_inp_set
              (setq non_inp_set_240 (str_merge&part_DEL non_inp_set_240 mm))
       );foreach
       (setq ent 1)
       (setq entlist '())
       (init_finish&part_DEL "init")
       (while (/= ent nil)
              (progn
                
                  (setq ent      (entsel "\n請選擇物件:<離開 按enter> "))
                  
                  (if (/= ent nil)
                      (progn
                           (setq entname  (car ent))
                           (redraw entname 3)
                           (setq Layname8 (cdr (assoc 8 (entget entname))))
                           (setq entname_list (cons entname entname_list))
                           (setq entlist  (cons (strcase Layname8) entlist))
                      )
                  )
                );progn
        );while
        
        (foreach mm entname_list
                 (redraw mm 4)
        );foreach
        (init_finish&part_DEL "finish")
        entlist
  
);defun loop_sel&part_DEL



 (defun *error* (msg)
       (princ)
 );defun


(defun generate_group&existasm&part_DEL(/  mm assoc_data tag2data assoc_asmdata new_assoc_asmdata)
     
   
    
     (foreach mm  (all_infp&part_DEL)
            (setq assoc_data  (assoc "TAG2" (get_bomdata&part_DEL mm)))
            (if (/= assoc_data nil)
                (progn
                     (setq mm (strcase (cdr (assoc 8 (entget mm)))))
                     (setq tag2data  (strcase (cadr assoc_data)))
                     (if (or (= tag2data nil)
                                  (= tag2data "")
                         );or
                              
                         (progn
                              (if (>= (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                  (setq #source_state_group_on  (append #source_state_group_on (list mm)))
                              );if
                         );progn
                         (progn
                              (if (= (setq assoc_asmdata (assoc tag2data #have_asmdata_list)) nil)
                                  (progn
                                       (setq #have_asmdata_list  (append #have_asmdata_list (list (list tag2data mm))))
                                  );progn
                                  (progn
                                       (setq new_assoc_asmdata  (append assoc_asmdata (list mm)))
                                       (setq #have_asmdata_list (subst new_assoc_asmdata assoc_asmdata #have_asmdata_list))
                                  );progn
                              );if      
                              (if (= (member tag2data #asm_judge) nil)      
                                  (setq #asm_judge  (append #asm_judge (list tag2data)))
                              );if      
                              (if (>= (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                  (setq #source_state_asm_on  (append #source_state_asm_on (list mm)))
                              );if
                         );progn  
                     );if
                     
                );progn  
            );if  
            
     );foreach
     
);defun

(defun all_infp&part_DEL(/ ent laname all_ent_set i )
  (setq ent nil) 
  ;(setq laname (strcase lname))
  (setq all_ent_set nil)  
  (setq #non_inp_set #all_group)
  (if #partref_group_set
      (progn
           (setq i 0)
           (while (setq ent (ssname #partref_group_set i))
                (setq all_ent_set (append all_ent_set (list ent)))
                (setq #non_inp_set (remove_one&part_DEL (strcase (cdr (assoc 8 (entget ent))))#non_inp_set ))
                (setq i (1+ i))
           );while
      );progn   
  );if
  all_ent_set 
);defun

(defun get_bompent&part_DEL(lname / partref_group laname ent)
  (setq ent nil) 
  (setq laname (strcase lname))
  (setq partref_group (ssget "x" (list (cons 8 laname) (cons 0 "INSERT")(cons 2 "PARTREF"))))
  (if partref_group
     (setq ent (ssname partref_group 0))
  );if
  ent
);defun

(defun get_bomdata&part_DEL(ballname / nextent datalist nextent_data nextent_data2 nextent_data1)
   (if (/= ballname nil)
       (progn
            (setq nextent (entnext ballname) datalist '())
            (setq nextent_data (entget nextent))
            (while (= "ATTRIB" (cdr (assoc 0 nextent_data)))
                   (setq nextent_data2 (cdr (assoc 2 nextent_data)) )
                   (setq nextent_data1 (cdr (assoc 1 nextent_data)) )
                   (setq datalist (cons (list nextent_data2 nextent_data1) datalist))
                   (setq nextent (entnext nextent))
                   (setq nextent_data (entget nextent))
            );while
        );progn
   );if  
   datalist
);defun
(defun groupmanage&part_DEL(  element grp_list  action_type Ungrp_list )
     (setq action_type (strcase action_type))
     (setq element (strcase element))
     (cond (;|add|; (= action_type ".>>.")
                    (setq grp_list (remove_one&part_del element grp_list ))
                    (setq Ungrp_list (append Ungrp_list (list  element)))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
                    
            
           );add
           (;|del|; (= action_type ".<<.")
                    (setq grp_list (append grp_list (list  element)))
                    (setq Ungrp_list (remove_one&part_del element Ungrp_list ))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
           );del
     );cond
 );defun
 
                   


(defun remove_one&part_DEL ( obj li / remove_flag i ret_list nthdata)
     (setq ret_list nil)
     (setq remove_flag nil)
     (setq i 0)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= (strcase nthdata)(strcase obj)) 
              (setq ret_list (append ret_list (list nthdata)))
              (setq remove_flag t)
          );if
          (setq i (1+ i))
     );while
     (if (=  remove_flag nil)
         (setq ret_list li)
         (setq ret_list ret_list)
     );if
    
);defun



(defun init_finish&part_DEL(in_fi / mm);in_fi:init_finish
   
     (cond (;|init|;
              (= (strcase in_fi) "INIT")
              (foreach mm source_state_group_on_240
                     (layeroff&part_DEL mm)
              );foreach
              (foreach mm source_state_asm_on_240
                     (layeroff&part_DEL mm)
              );foreach
              (foreach mm group_list_240
                     (command "-layer" "on" mm "")
              );foreach 
              (foreach mm non_inp_set_240
                     (layeroff&part_DEL mm)
              );foreach
           );init
           (;|finish|;
              (= (strcase in_fi) "FINISH")
               (foreach mm source_state_group_on_240
                     (command "-layer" "on" mm "")
              );foreach
              (foreach mm source_state_asm_on_240
                     (command "-layer" "on" mm "")
              );foreach
              (foreach mm current_group_list_off_240
                     (layeroff&part_DEL mm)
              );foreach 
              (foreach mm non_inp_set_240
                     (command "-layer" "on" mm "")
              );foreach
 
           );finish
       );COND
 );defun
 (defun layeroff&part_DEL(en)
     (setq en (strcat "," en))
     (if (/= (string_search&part_DEL (strcase en) (strcat ","(getvar "clayer") ",") ) nil)
         (command "-layer" "off" en "y" "")
         (command "-layer" "off" en "")
     );if
);defun



 (defun str_merge&part_DEL(li str / reverse_data  merge_str  merge_list mergedata)
      (setq reverse_data (reverse li))
      (setq merge_str  (car reverse_data))
      (setq merge_list (cdr reverse_data))
   
      (if (= merge_str nil)
          (setq merge_str ",")
      );if
      (if (<= (strlen (setq mergedata (strcat merge_str  "," str ","))) 240)
          (progn
               (if (= merge_str ",")
                   (setq merge_str str)
                   (setq merge_str mergedata)
               );if      
               (setq merge_list (cons merge_str merge_list))
               (setq merge_list (reverse merge_list))
          );progn
          (progn
               (setq merge_list (append li (list str)))
          );progn  
      );if
      merge_list
  );defun 
  (defun string_search&part_DEL(string search_s / prt flag string_len search_s_len find_s)
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



;******************************************************************************************



 ;;;┌────────────────────────────────┐
 ;;;│  程  式 :desinger版                                            │
 ;;;│  主程式 :Sub_REmove                                            │
 ;;;│  日  期 :89.11.22                                              │
 ;;;│  姓  名 :jacky                                                 │
 ;;;│  對話框 :                                                      │
 ;;;│  方  法 :                                                      │
 ;;;│  相關檔案:sub numList                                          │
 ;;;└────────────────────────────────┘




; sub 代表 次組合
(defun c:Sub_REmove(/  #asm_path_dcl         #group_list    #ungroup_list    #asm_judge        #source_state_group_on
                   #source_state_asm_off    dcL_id         oker             #all_group        #non_inp_set
                   #partref_group_set      len_blance     #LSP_sub_name    #Lsp_draw_sel     #asm_data
                   #current_group_list_off #have_asmdata_list
                )
    ; (POWERSOFT_DESIGNER2000)
    ; (if (not (and (= piec_designer1 "#$%&") (=  piec_designer2 "###@")))
    ;     (exit)
    ; );if    
     (if (= (ssget "x") nil)
         (progn
              (alert "圖面無資料")
              (exit)
         );progn
     );if                    
     (setvar "cmdecho" 0)
     (setq #asm_path_dcl Powdesign_DCL_PATH)
     ;(setq #asm_path_data Powdesign_ASM_PATH)
     (setq #group_list nil)
     (setq #ungroup_list nil)
     (setq #asm_judge   nil)
     (setq #source_state_group_on nil)
     (setq #source_state_asm_off    nil)
     (setq #have_asmdata_list nil)
     (setq #non_inp_set nil)
     (setq #LSP_sub_name nil)
     (setq #Lsp_draw_sel "1")
     (setq #current_group_list_off nil)
     (setq #all_group (coLL_Layer&Sub_REmove))
     (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
             
     (cond ( (=  #partref_group_set nil)
              
              (setq len_blance (getdata_YN "\n 完全未建立資訊點, 須建立(Y/N)? <Y>: "))
              (if (= len_blance nil)
                  (setq len_blance "Y")
              );if      
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn  
                  (progn
                       (alert "\n 資訊點完全未建立 ")
                       (exit)
                  );progn  
              );if
           ) 
           ( (/= (length #all_group) (sslength #partref_group_set))
         
              (setq len_blance (getdata_YN "\n 是否自動檢查資訊點之建立(Y/N)? <N>: "))
              (if (= len_blance nil)
                  (setq len_blance "N")
              );if
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn  
              );if
           );2 
     );cond  
                                       
     
     (generate_group&existasm&Sub_REmove)
     (if (= #asm_judge nil)
         (progn
              (alert "\n無次組合資料, 請建立次組合!!")
              (exit)
         );progn
     );if
  
     (actdcl (strcat #asm_path_dcl "subasmset") "sub_remove")
     ;(to_box_c_list&Sub_REmove)
     (mode_tile "sub_add" 0)
     (mode_tile "sub_del" 1)
  
     (mode_2&Sub_REmove)
    
     ;(set_tile  "cue"  "提示: 選擇 {是否圖選} !!" )  
     ;(mode_tile "sub_name" 2) 
     ;(action_tile "sub_name" "(subsys_name&Sub_REmove)") 
  
     (action_tile "c_list"  "(mode_tile \"sub_add\" 0) (mode_tile \"sub_del\" 1)")
     (action_tile "out_list"  "(mode_tile \"sub_add\" 1) (mode_tile \"sub_del\" 0)")  

     (action_tile "sub_add"  "(subsys_add&Sub_REmove)")
     (action_tile "sub_del"  "(subsys_deL&Sub_REmove)")
     (action_tile "draw_sel" "(subsys_draw_sel&Sub_REmove)")
     (action_tile "accept" "(setq oker 1)(done_dialog)")
     (action_tile "cancel" "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
     (start_dialog)
   (unload_dialog dcl_id)
    
     (unload_dialog dcl_id)
     (if (= oker 1)
         (progn
              (subsys_ok&Sub_REmove)
              ;(c:subsys)
         );progn  
       
     )
     (princ)
);defun

;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function before  DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘


;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function between DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
  (defun to_box_c_list&Sub_REmove()
      (start_List "c_list" 3)
      (mapcar 'add_list #group_list)
      (end_list)
  );defun  
    
  (defun coll_layer&Sub_REmove(/ coll_layer_list ladata)
     (setq total_layer_list (list (cdadr (tblnext "layer" t))))
     (setq ladata (tblnext "layer"))
     (while ladata
          (setq total_layer_list (cons (strcase (cdadr ladata)) total_layer_list))
          (setq ladata (tblnext "layer"))
     );while
     total_layer_list
    
  );defun
 

   (defun subsys_add&Sub_REmove (/ p_list_msel    p_list_mp   group_list_nth    e1        e2
                                 num1           num2        all_len1          all_len2  group_list_temp
                                 groupmanage_retval
                          );subsys_add
         (setq p_list_Msel (get_tile "c_list"))
         (if (/= p_list_Msel nil)
             (progn
                  (setq group_list_temp   #group_list)
                  (setq p_list_Msel (read (strcat "(" p_List_msel ")")))
                  (foreach p_list_mp p_list_msel
                           (setq group_list_nth (nth p_list_mp group_list_temp))
                           (setq groupmanage_retval (groupmanage&Sub_REmove  group_list_nth #group_list ".>>."  #ungroup_list))
                           (setq #group_list   (car groupmanage_retval))
                           (setq #ungroup_list (cadr groupmanage_retval))
                         
                  );foreach
                  (start_List "c_list" 3)
                  (mapcar 'add_list #group_list)
                  (end_list)
                  (start_List "out_list" 3)
                  (mapcar 'add_list #ungroup_list)
                  (end_list)
              );progn
           );if
    ) ;defun_subsys_add&Sub_REmove

  (defun subsys_deL&Sub_REmove (/ j_list_msel   j_list_mp   ungroup_list_nth   e1        e2
                             num1          num2        all_len1           all_len2  
                             ungroup_list_temp         groupmanage_retval
                           )
          (setq j_list_Msel (get_tile "out_list"))
          (if (/= j_list_msel nil)
              (progn
                   (setq ungroup_list_temp #ungroup_list)
                   (setq j_list_Msel (read (strcat "(" j_List_msel ")")))
                   (foreach j_list_mp j_list_msel
                          (setq ungroup_list_nth (nth   j_list_mp ungroup_list_temp))
                          (setq groupmanage_retval (groupmanage&Sub_REmove  ungroup_list_nth #group_list ".<<." #ungroup_list))
                          (setq #group_list   (car groupmanage_retval))
                          (setq #ungroup_list (cadr groupmanage_retval))
                   );foreach
                   (start_List "c_list" 3)
                   (mapcar 'add_list #group_list)
                   (end_list)
                   (start_List "out_list" 3)
                   (mapcar 'add_list #ungroup_list)
                   (end_list)
              );progn
          );if  
    );defun_subsys_deL&Sub_REmove
;}}}}}}
  

  (defun subsys_draw_sel&Sub_REmove(/ tlayer_list  asmfp       temp_group_list
                                asmdata      asmdata_key  asmdata_body     asmdata_key_body
                                asmdata_list asm_mp       temp_asmdata     asmdata_groupname
                                asm_code_groupname
                             )
         
         (if (= (get_tile "draw_sel") "1")
             (progn
                  (mode_3&Sub_REmove)
                  (setq #Lsp_draw_sel "1")
             );progn
             (progn
                  (mode_4&Sub_REmove)
                  (setq #Lsp_draw_sel "0")
                  (start_List "c_list" 3)
                  (mapcar 'add_list #group_list)
                  (end_list)
                 ; (start_List "c_list" 3)
                 ; (mapcar 'add_list #group_list)
                 ; (end_list)
                  (start_list "out_list" 3)
                  (mapcar 'add_list nil)
                  (end_list)
        
             );progn  
         );if  
  );defun
 






;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  main function  area                           │
;;;│                                                                │
;;;└────────────────────────────────┘

                                   ; or_num_w is order number written
 (defun subsys_ok&Sub_REmove  (/ partdata_list parttemp_list p_list entdata_list mm)
      (setq partdata_list nil)
      (setq parttemp_list nil)
      (cond (
               (= #Lsp_draw_sel "0")
               (setq p_list #ungroup_list)
               (foreach mm p_list
                      (setq parttemp_list (cdr (assoc (strcase mm) #have_asmdata_list)))
                      (setq partdata_list (append partdata_list parttemp_list))
               );foreach
            )
            (
               (= #Lsp_draw_sel "1")
               (setq p_list (loop_sel&Sub_REmove))
               (foreach mm p_list
                      (setq mm  (cadr (assoc "TAG2" (get_bomdata&Sub_REmove (get_bompent&Sub_REmove mm)))))
                      (setq parttemp_list (cdr (assoc (strcase mm) #have_asmdata_list)))
                      (setq partdata_list (append partdata_list parttemp_list))
               );foreach
            )
            (t
              (alert "#Lsp_draw_sel無值!")
              (exit)
            )
       );cond
       
       (foreach mm partdata_list
              (setq entdata_list (get_bomdata&Sub_REmove (get_bompent&Sub_REmove mm)))
              (setq entdata_list (subst (list "TAG2" "") (assoc "TAG2" entdata_list )entdata_list))
              (addatt_tobomball (get_bompent&Sub_REmove mm)  entdata_list)
       );forech
 );defun  
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
 (defun mode_1&Sub_REmove()
      ; (mode_tile "sub_name" 0)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "c_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "out_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 1)
       (mode_tile "accept" 1)
       (mode_tile "cancel" 0)
 );mode_1&Sub_REmove

 (defun mode_2&Sub_REmove()
      ; (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
       ;(mode_tile "n_popup"  0)
       (mode_tile "c_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "out_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept" 0)
       (mode_tile "cancel" 0)
 );mode_2

  
 (defun mode_3&Sub_REmove()
       ;(mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "c_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "out_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_3
 (defun mode_4&Sub_REmove()
       ;(mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "c_list"   0)
       (mode_tile "sub_add"  0) 
       (mode_tile "out_list"   0)
       (mode_tile "sub_del"  0)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_4
;}}}}}}




(defun loop_sel&Sub_REmove(/  source_state_group_on_240  source_state_asm_off_240  non_inp_set_240 ent entlist entname  Layname8 entname_list mm)
       (setq source_state_group_on_240 nil)
       (setq source_state_asm_off_240  nil)
       (setq non_inp_set_240           nil)
       (foreach mm #source_state_group_on
              (setq source_state_group_on_240 (str_merge&Sub_REmove source_state_group_on_240 mm))
       );foreach
       (foreach mm #source_state_asm_off
              (setq source_state_asm_off_240 (str_merge&Sub_REmove source_state_asm_off_240 mm))
       );foreach
       (foreach mm #non_inp_set
              (setq non_inp_set_240 (str_merge&Sub_REmove non_inp_set_240 mm))
       );foreach
       (setq ent 1)
       (setq entlist '())
       (init_finish&Sub_REmove "init")
       (while (/= ent nil)
              (progn
                
                  (setq ent      (entsel "\n請選擇物件:<離開 按enter> "))
                  
                  (if (/= ent nil)
                      (progn
                           (setq entname  (car ent))
                           (redraw entname 3)
                           (setq Layname8 (cdr (assoc 8 (entget entname))))
                           (setq entname_list (cons entname entname_list))
                           (setq entlist  (cons (strcase Layname8) entlist))
                      )
                  )
                );progn
        );while
        
        (foreach mm entname_list
                 (redraw mm 4)
        );foreach
        (init_finish&Sub_REmove "finish")
        entlist
  
);defun loop_sel&Sub_REmove



 (defun *error* (msg)
       (princ)
 );defun


(defun generate_group&existasm&Sub_REmove(/  mm assoc_data tag2data assoc_asmdata new_assoc_asmdata)
     
   
    
     (foreach mm  (all_infp&Sub_REmove)
            (setq assoc_data  (assoc "TAG2" (get_bomdata&Sub_REmove mm)))
            (if (/= assoc_data nil)
                (progn
                     (setq mm (strcase (cdr (assoc 8 (entget mm)))))
                     (setq tag2data  (strcase (cadr assoc_data)))
                     (if (or (= tag2data nil)
                                  (= tag2data "")
                         );or
                              
                         (progn
                              (if (>= (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                  (setq #source_state_group_on  (append #source_state_group_on (list mm)))
                              );if
                         );progn
                         (progn
                              (if (= (setq assoc_asmdata (assoc tag2data #have_asmdata_list)) nil)
                                  (progn
                                       (setq #have_asmdata_list  (append #have_asmdata_list (list (list tag2data mm))))
                                  );progn
                                  (progn
                                       (setq new_assoc_asmdata  (append assoc_asmdata (list mm)))
                                       (setq #have_asmdata_list (subst new_assoc_asmdata assoc_asmdata #have_asmdata_list))
                                  );progn
                              );if      
                              (if (= (member tag2data #asm_judge) nil)      
                                  (setq #asm_judge  (append #asm_judge (list tag2data)))
                              );if      
                              (if (< (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                  (setq #source_state_asm_off  (append #source_state_asm_off (list mm)))
                              );if
                         );progn  
                     );if
                     
                );progn  
            );if  
            
     );foreach
     (setq #group_list #asm_judge)
     (setq #ungroup_list nil)
     
);defun

(defun all_infp&Sub_REmove(/ ent laname all_ent_set i )
  (setq ent nil) 
  ;(setq laname (strcase lname))
  (setq all_ent_set nil)  
  (setq #non_inp_set #all_group)
  (if #partref_group_set
      (progn
           (setq i 0)
           (while (setq ent (ssname #partref_group_set i))
                (setq all_ent_set (append all_ent_set (list ent)))
                (setq #non_inp_set (remove_one&Sub_REmove (strcase (cdr (assoc 8 (entget ent))))#non_inp_set ))
                (setq i (1+ i))
           );while
      );progn   
  );if
  all_ent_set 
);defun

(defun get_bompent&Sub_REmove(lname / partref_group laname ent)
  (setq ent nil) 
  (setq laname (strcase lname))
  (setq partref_group (ssget "x" (list (cons 8 laname) (cons 0 "INSERT")(cons 2 "PARTREF"))))
  (if partref_group
     (setq ent (ssname partref_group 0))
  );if
  ent
);defun

(defun get_bomdata&Sub_REmove(ballname / nextent datalist nextent_data nextent_data2 nextent_data1)
   (if (/= ballname nil)
       (progn
            (setq nextent (entnext ballname) datalist '())
            (setq nextent_data (entget nextent))
            (while (= "ATTRIB" (cdr (assoc 0 nextent_data)))
                   (setq nextent_data2 (cdr (assoc 2 nextent_data)) )
                   (setq nextent_data1 (cdr (assoc 1 nextent_data)) )
                   (setq datalist (cons (list nextent_data2 nextent_data1) datalist))
                   (setq nextent (entnext nextent))
                   (setq nextent_data (entget nextent))
            );while
        );progn
   );if  
   datalist
);defun
(defun groupmanage&Sub_REmove(  element grp_list  action_type Ungrp_list )
     (setq action_type (strcase action_type))
     (setq element (strcase element))
     (cond (;|add|; (= action_type ".>>.")
                    (setq grp_list (remove_one&Sub_REmove element grp_list ))
                    (setq Ungrp_list (append Ungrp_list (list  element)))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
                    
            
           );add
           (;|del|; (= action_type ".<<.")
                    (setq grp_list (append grp_list (list  element)))
                    (setq Ungrp_list (remove_one&Sub_REmove element Ungrp_list ))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
           );del
     );cond
 );defun
 
                   


(defun remove_one&Sub_REmove ( obj li / remove_flag i ret_list nthdata)
     (setq ret_list nil)
     (setq remove_flag nil)
     (setq i 0)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= (strcase nthdata)(strcase obj)) 
              (setq ret_list (append ret_list (list nthdata)))
              (setq remove_flag t)
          );if
          (setq i (1+ i))
     );while
     (if (=  remove_flag nil)
         (setq ret_list li)
         (setq ret_list ret_list)
     );if
    
);defun

(defun layeroff&Sub_REmove(en)
     (setq en (strcat "," en))
     (if (/= (string_search&Sub_REmove (strcase en) (strcat ","(getvar "clayer") ",") ) nil)
         (command "-layer" "off" en "y" "")
         (command "-layer" "off" en "")
     );if
);defun

;(defun init_finish&Sub_REmove(in_fi / mm  source_state_group_on_240 source_state_asm_off_240 non_inp_set_240);in_fi:init_finish
(defun init_finish&Sub_REmove(in_fi / mm    );in_fi:init_finish  
    
     
  
     (cond (;|init|;
              (= (strcase in_fi) "INIT")
              (foreach mm source_state_group_on_240
                     (layeroff&Sub_REmove mm)
              );foreach
              (foreach mm source_state_asm_off_240
                     (command "-layer" "on" mm "")
              );foreach
              (foreach mm non_inp_set_240
                     (layeroff&Sub_REmove mm)
              );foreach
           );init
           (;|finish|;
             (= (strcase in_fi) "FINISH")
             (foreach mm source_state_group_on_240
                    (command "-layer" "on" mm "")
             );foreach
             (foreach mm source_state_asm_off_240
                    (layeroff&Sub_REmove mm)
             );foreach
             (foreach mm non_inp_set_240
                    (command "-layer" "on" mm "")
             );foreach
          );finish
       );COND
 );defun


 (defun str_merge&Sub_REmove(li str / reverse_data  merge_str  merge_list mergedata)
      (setq reverse_data (reverse li))
      (setq merge_str  (car reverse_data))
      (setq merge_list (cdr reverse_data))
   
      (if (= merge_str nil)
          (setq merge_str ",")
      );if
      (if (<= (strlen (setq mergedata (strcat merge_str  "," str ","))) 240)
          (progn
               (if (= merge_str ",")
                   (setq merge_str str)
                   (setq merge_str mergedata)
               );if      
               (setq merge_list (cons merge_str merge_list))
               (setq merge_list (reverse merge_list))
          );progn
          (progn
               (setq merge_list (append li (list str)))
          );progn  
      );if
      merge_list
  );defun 
  (defun string_search&Sub_REmove(string search_s / prt flag string_len search_s_len find_s)
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


;******************************************************************************************



 ;;;┌────────────────────────────────┐
 ;;;│  程  式 :desinger版                                            │
 ;;;│  主程式 :Sub_On_Off                                            │
 ;;;│  日  期 :89.11.28                                              │
 ;;;│  姓  名 :jacky                                                 │
 ;;;│  對話框 :                                                      │
 ;;;│  方  法 :                                                      │
 ;;;│  相關檔案:sub numList                                          │
 ;;;└────────────────────────────────┘



; sub 代表 次組合
(defun c:Sub_On_Off(/  #asm_path_dcl            #group_list        #ungroup_list        #asm_judge        #source_state_group_on
                       #source_state_asm_off    dcL_id             oker                 #all_group        #non_inp_set
                       #partref_group_set       len_blance         #LSP_sub_name        #Lsp_draw_sel     #asm_data
                       #current_group_list_off  #have_asmdata_list #asm_judge_source_on #asm_judge_source_off
                )
    ; (POWERSOFT_DESIGNER2000)
    ; (if (not (and (= piec_designer1 "#$%&") (=  piec_designer2 "###@")))
    ;     (exit)
    ; );if    
     (if (= (ssget "x") nil)
         (progn
              (alert "圖面無資料")
              (exit)
         );progn
     );if                    
     (setvar "cmdecho" 0)
     (setq #asm_path_dcl Powdesign_DCL_PATH)
     ;(setq #asm_path_data Powdesign_ASM_PATH)
     (setq #group_list nil)
     (setq #ungroup_list nil)
     (setq #asm_judge   nil)
     (setq #source_state_group_on nil)
     (setq #source_state_asm_off    nil)
     (setq #have_asmdata_list nil)
     (setq #non_inp_set nil)
     (setq #LSP_sub_name nil)
     (setq #asm_judge_source_on nil)
     (setq #asm_judge_source_off nil)
     (setq #Lsp_draw_sel "0")
     (setq #current_group_list_off nil)
     (setq #all_group (coLL_Layer&Sub_On_Off))
     (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
             
     (cond ( (=  #partref_group_set nil)
              
              (setq len_blance (getdata_YN "\n 完全未建立資訊點, 須建立(Y/N)? <Y>: "))
              (if (= len_blance nil)
                  (setq len_blance "Y")
              );if      
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn  
                  (progn
                       (alert "\n 資訊點完全未建立 ")
                       (exit)
                  );progn  
              );if
           ) 
           ( (/= (length #all_group) (sslength #partref_group_set))
         
              (setq len_blance (getdata_YN "\n 是否自動檢查資訊點之建立(Y/N)? <N>: "))
              (if (= len_blance nil)
                  (setq len_blance "N")
              );if
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn  
              );if
           );2 
     );cond  
                                       
     
     (generate_group&existasm&Sub_On_Off)
     (if (= #asm_judge nil)
         (progn
              (alert "\n無次組合資料, 請建立次組合!!")
              (exit)
         );progn
     );if
  
     (actdcl (strcat #asm_path_dcl "subasmset") "sub_on_off")
     ;(to_box_c_list&Sub_On_Off)
     (mode_tile   "sub_add" 0)
     (mode_tile   "sub_del" 1)
     
     (mode_2&Sub_On_Off)
     
     (subsys_draw_sel&Sub_On_Off)
      
     ;(set_tile    "cue"       "提示: 選擇 {是否圖選} !!" );the key "cue" is disable
     
     (action_tile "c_list"    "(mode_tile \"sub_add\" 0) (mode_tile \"sub_del\" 1)")
     
     (action_tile "out_list"  "(mode_tile \"sub_add\" 1) (mode_tile \"sub_del\" 0)")  
     
     (action_tile "sub_add"  "(subsys_add&Sub_On_Off)")
     
     (action_tile "sub_del"  "(subsys_deL&Sub_On_Off)")
     
     (action_tile "draw_sel" "(subsys_draw_sel&Sub_On_Off)");the key "draw_sel" is disable
     
     (action_tile "accept"   "(setq oker 1)(done_dialog)")
      
     (action_tile "cancel"   "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
      
     (start_dialog)
   (unload_dialog dcl_id)
    
     (unload_dialog dcl_id)
     (if (= oker 1)
         (progn
              (subsys_ok&Sub_On_Off)
              ;(c:subsys)
         );progn  
       
     )
     (princ)
);defun

;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function before  DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘


;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function between DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
  (defun to_box_c_list&Sub_On_Off()
      (start_List "c_list" 3)
      (mapcar 'add_list #group_list)
      (end_list)
  );defun  
    
  (defun coll_layer&Sub_On_Off(/ coll_layer_list ladata)
     (setq total_layer_list (list (cdadr (tblnext "layer" t))))
     (setq ladata (tblnext "layer"))
     (while ladata
          (setq total_layer_list (cons (strcase (cdadr ladata)) total_layer_list))
          (setq ladata (tblnext "layer"))
     );while
     total_layer_list
    
  );defun
  

   (defun subsys_add&Sub_On_Off (/ p_list_msel    p_list_mp   group_list_nth    e1        e2
                                 num1           num2        all_len1          all_len2  group_list_temp
                                 groupmanage_retval
                          );subsys_add
         (setq p_list_Msel (get_tile "c_list"))
         (if (/= p_list_Msel nil)
             (progn
                  (setq group_list_temp   #group_list)
                  (setq p_list_Msel (read (strcat "(" p_List_msel ")")))
                  (foreach p_list_mp p_list_msel
                           (setq group_list_nth (nth p_list_mp group_list_temp))
                           (setq groupmanage_retval (groupmanage&Sub_On_Off  group_list_nth #group_list ".>>."  #ungroup_list))
                           (setq #group_list   (car groupmanage_retval))
                           (setq #ungroup_list (cadr groupmanage_retval))
                         
                  );foreach
                  (start_List "c_list" 3)
                  (mapcar 'add_list #group_list)
                  (end_list)
                  (start_List "out_list" 3)
                  (mapcar 'add_list #ungroup_list)
                  (end_list)
              );progn
           );if
    ) ;defun_subsys_add&Sub_On_Off

  (defun subsys_deL&Sub_On_Off (/ j_list_msel   j_list_mp   ungroup_list_nth   e1        e2
                             num1          num2        all_len1           all_len2  
                             ungroup_list_temp         groupmanage_retval
                           )
          (setq j_list_Msel (get_tile "out_list"))
          (if (/= j_list_msel nil)
              (progn
                   (setq ungroup_list_temp #ungroup_list)
                   (setq j_list_Msel (read (strcat "(" j_List_msel ")")))
                   (foreach j_list_mp j_list_msel
                          (setq ungroup_list_nth (nth   j_list_mp ungroup_list_temp))
                          (setq groupmanage_retval (groupmanage&Sub_On_Off  ungroup_list_nth #group_list ".<<." #ungroup_list))
                          (setq #group_list   (car groupmanage_retval))
                          (setq #ungroup_list (cadr groupmanage_retval))
                   );foreach
                   (start_List "c_list" 3)
                   (mapcar 'add_list #group_list)
                   (end_list)
                   (start_List "out_list" 3)
                   (mapcar 'add_list #ungroup_list)
                   (end_list)
              );progn
          );if  
    );defun_subsys_deL&Sub_On_Off
;}}}}}}
  

  (defun subsys_draw_sel&Sub_On_Off(/ tlayer_list  asmfp       temp_group_list
                                asmdata      asmdata_key  asmdata_body     asmdata_key_body
                                asmdata_list asm_mp       temp_asmdata     asmdata_groupname
                                asm_code_groupname
                             )
         
         (if (= (get_tile "draw_sel") "1")
             (progn
                  (mode_3&Sub_On_Off)
                  (setq #Lsp_draw_sel "1")
             );progn
             (progn
                  (mode_4&Sub_On_Off)
                  (setq #Lsp_draw_sel "0")
                  (start_List "c_list" 3)
                  (mapcar 'add_list #group_list)
                  (end_list)
                 ; (start_List "c_list" 3)
                 ; (mapcar 'add_list #group_list)
                 ; (end_list)
                  (start_list "out_list" 3)
                  (mapcar 'add_list #ungroup_list)
                  (end_list)
        
             );progn  
         );if  
  );defun
 






;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  main function  area                           │
;;;│                                                                │
;;;└────────────────────────────────┘

                                   ; or_num_w is order number written
 (defun subsys_ok&Sub_On_Off  (/ partdata_list parttemp_list grp_prs_list unpartdata_list unparttemp_list ungrp_prs_list entdata_list mm)
      (setq partdata_list        nil)
      (setq partdata_list_240    nil)
      (setq parttemp_list        nil)
      (setq unpartdata_list      nil)
      (setq unpartdata_list_240  nil)
      (setq unparttemp_list      nil)
      (cond (
               (= #Lsp_draw_sel "0")
               (setq grp_prs_list   #group_list)
               (setq ungrp_prs_list #ungroup_list)
             
               (foreach mm grp_prs_list;group_process_list
                      (setq parttemp_list (cdr (assoc (strcase mm) #have_asmdata_list)))
                      (setq partdata_list (append partdata_list parttemp_list))
               );foreach
               
               (foreach mm ungrp_prs_list;ungroup_process_list
                      (setq unparttemp_list (cdr (assoc (strcase mm) #have_asmdata_list)))
                      (setq unpartdata_list (append unpartdata_list unparttemp_list))
               );foreach
            )
            (
               (= #Lsp_draw_sel "1")
               (setq ungrp_prs_list (loop_sel&Sub_On_Off))
               (foreach mm ungrp_prs_list
                      (setq mm  (cadr (assoc "TAG2" (get_bomdata&Sub_On_Off (get_bompent&Sub_On_Off mm)))))
                      (setq unparttemp_list (cdr (assoc (strcase mm) #have_asmdata_list)))
                      (setq unpartdata_list (append unpartdata_list unparttemp_list))
               );foreach
            )
            (t
              (alert "#Lsp_draw_sel無值!")
              (exit)
            )
       );cond
       (foreach mm partdata_list
              (setq partdata_list_240 (str_merge&Sub_On_Off partdata_list_240 mm))
       );foreach
       (foreach mm unpartdata_list
              (setq unpartdata_list_240 (str_merge&Sub_On_Off unpartdata_list_240 mm))
       );foreach
       (foreach mm partdata_list_240
              (command "-layer" "on" mm "")
       );foreach
       (foreach mm unpartdata_list_240
              (layeroff&Sub_On_Off mm)
       );foreach
   
       
      
 );defun  
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
 (defun mode_1&Sub_On_Off()
      ; (mode_tile "sub_name" 0)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "c_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "out_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 1)
       (mode_tile "accept" 1)
       (mode_tile "cancel" 0)
 );mode_1&Sub_On_Off

 (defun mode_2&Sub_On_Off()
      ; (mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
       ;(mode_tile "n_popup"  0)
       (mode_tile "c_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "out_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept" 0)
       (mode_tile "cancel" 0)
 );mode_2

  
 (defun mode_3&Sub_On_Off()
       ;(mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "c_list"   1)
       (mode_tile "sub_add"  1) 
       (mode_tile "out_list"   1)
       (mode_tile "sub_del"  1)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_3
 (defun mode_4&Sub_On_Off()
       ;(mode_tile "sub_name" 1)
      ; (mode_tile "num"      1)
      ; (mode_tile "n_popup"  1)
       (mode_tile "c_list"   0)
       (mode_tile "sub_add"  0) 
       (mode_tile "out_list"   0)
       (mode_tile "sub_del"  0)
       (mode_tile "draw_sel" 0)
       (mode_tile "accept"   0)
       (mode_tile "cancel"   0)
 );mode_4
;}}}}}}




(defun loop_sel&Sub_On_Off(/  source_state_group_on_240  source_state_asm_off_240  non_inp_set_240 ent entlist entname  Layname8 entname_list mm)
       (setq source_state_group_on_240 nil)
       (setq source_state_asm_off_240  nil)
       (setq non_inp_set_240           nil)
       (foreach mm #source_state_group_on
              (setq source_state_group_on_240 (str_merge&Sub_On_Off source_state_group_on_240 mm))
       );foreach
       (foreach mm #source_state_asm_off
              (setq source_state_asm_off_240 (str_merge&Sub_On_Off source_state_asm_off_240 mm))
       );foreach
       (foreach mm #non_inp_set
              (setq non_inp_set_240 (str_merge&Sub_On_Off non_inp_set_240 mm))
       );foreach
       (setq ent 1)
       (setq entlist '())
       (init_finish&Sub_On_Off "init")
       (while (/= ent nil)
              (progn
                
                  (setq ent      (entsel "\n請選擇物件:<離開 按enter> "))
                  
                  (if (/= ent nil)
                      (progn
                           (setq entname  (car ent))
                           (redraw entname 3)
                           (setq Layname8 (cdr (assoc 8 (entget entname))))
                           (setq entname_list (cons entname entname_list))
                           (setq entlist  (cons (strcase Layname8) entlist))
                      );progn
                  );if
                );progn
        );while
        
        (foreach mm entname_list
                 (redraw mm 4)
        );foreach
        (init_finish&Sub_On_Off "finish")
        entlist
  
);defun loop_sel&Sub_On_Off



 (defun *error* (msg)
       (princ)
 );defun


(defun generate_group&existasm&Sub_On_Off( /  mm assoc_data tag2data assoc_asmdata new_assoc_asmdata attrpart_state
                                              attrpart_source_s_g_on_240           have_inp_list
                                              source_s_g_on_and_have_inp
                                         )
     
   
     (setq attrpart_state nil)
     (setq attrpart_source_s_g_on_240 nil)
     ;(setq have_inp_list nil);inp: information point
     (setq source_s_g_on_and_have_inp nil)
     (foreach mm  (all_infp&Sub_On_Off)
           
            
            (setq assoc_data  (assoc "TAG2" (get_bomdata&Sub_On_Off mm)))
            (if (/= assoc_data nil)
                (progn
                     (setq mm (strcase (cdr (assoc 8 (entget mm)))))
                    ; (setq have_inp_list (append have_inp_list (list mm)))
                     (setq tag2data  (strcase (cadr assoc_data)))
                     (if (or (= tag2data nil)
                             (= tag2data "")
                         );or
                         (progn
                              (if (>= (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                   (setq #source_state_group_on  (append #source_state_group_on (list mm)))
                              );if
                         );progn
                         (progn
                              (if (= (setq assoc_asmdata (assoc tag2data #have_asmdata_list)) nil)
                                  (progn
                                       (setq #have_asmdata_list  (append #have_asmdata_list (list (list tag2data mm))))
                                  );progn
                                  (progn
                                       (setq new_assoc_asmdata  (append assoc_asmdata (list mm)))
                                       (setq #have_asmdata_list (subst new_assoc_asmdata assoc_asmdata #have_asmdata_list))
                                  );progn
                              );if      
                              (if (= (member tag2data #asm_judge) nil)
                                  (progn
                                       (setq #asm_judge  (append #asm_judge (list tag2data)))
                                       (if (>= (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                           (setq #asm_judge_source_on  (append #asm_judge_source_on (list tag2data)))
                                       );if
                                  );progn  
                              );if      
                             ;(if (< (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                             ;    (setq #source_state_asm_off  (append #source_state_asm_off (list mm)))
                             ; );if
                         );progn  
                     );if
                     
                );progn  
            );if  
            
     );foreach
     (setq attrpart_state (getdata_YN "\非任何次組合之零件是否關掉(off)! (Y/N)? <Y>:"))
     (setq as 1)
     (if (or (= attrpart_state nil)
             (= attrpart_state "")
         );or    
         (setq attrpart_state "Y")
     );if
     (if (or (= (strcase attrpart_state) "Y")
             (= (strcase attrpart_state) "YES")
         );or
         (progn
               
               (setq source_s_g_on_and_have_inp (append #source_state_group_on (list "$Partref_Bom")))
               
               (foreach mm source_s_g_on_and_have_inp;s_g_on:state_group_on
                      (setq attrpart_source_s_g_on_240 (str_merge&Sub_On_Off attrpart_source_s_g_on_240 mm))
               );foreach
           
               (foreach mm attrpart_source_s_g_on_240
                      (layeroff&Sub_On_Off mm)
               );foreach
               
          );progn
          
     );if  
     
     (foreach mm #asm_judge
            (if (= (member  mm  #asm_judge_source_on) nil)
                (setq #asm_judge_source_off (append #asm_judge_source_off (list mm)))
            );if
     );foreach
     
     (setq #group_list    #asm_judge_source_on)
     (setq #ungroup_list #asm_judge_source_off)
     
     
);defun

(defun all_infp&Sub_On_Off(/ ent laname all_ent_set i )
  (setq ent nil) 
  ;(setq laname (strcase lname))
  (setq all_ent_set nil)  
  (setq #non_inp_set #all_group)
  (if #partref_group_set
      (progn
           (setq i 0)
           (while (setq ent (ssname #partref_group_set i))
                (setq all_ent_set (append all_ent_set (list ent)))
                (setq #non_inp_set (remove_one&Sub_On_Off (strcase (cdr (assoc 8 (entget ent))))#non_inp_set ))
                (setq i (1+ i))
           );while
      );progn   
  );if
  all_ent_set 
);defun

(defun get_bompent&Sub_On_Off(lname / partref_group laname ent)
  (setq ent nil) 
  (setq laname (strcase lname))
  (setq partref_group (ssget "x" (list (cons 8 laname) (cons 0 "INSERT")(cons 2 "PARTREF"))))
  (if partref_group
     (setq ent (ssname partref_group 0))
  );if
  ent
);defun

(defun get_bomdata&Sub_On_Off(ballname / nextent datalist nextent_data nextent_data2 nextent_data1)
   (if (/= ballname nil)
       (progn
            (setq nextent (entnext ballname) datalist '())
            (setq nextent_data (entget nextent))
            (while (= "ATTRIB" (cdr (assoc 0 nextent_data)))
                   (setq nextent_data2 (cdr (assoc 2 nextent_data)) )
                   (setq nextent_data1 (cdr (assoc 1 nextent_data)) )
                   (setq datalist (cons (list nextent_data2 nextent_data1) datalist))
                   (setq nextent (entnext nextent))
                   (setq nextent_data (entget nextent))
            );while
        );progn
   );if  
   datalist
);defun
(defun groupmanage&Sub_On_Off(  element grp_list  action_type Ungrp_list )
     (setvar "cmdecho" 0)
     (setq action_type (strcase action_type))
     (setq element (strcase element))
     (cond (;|add|; (= action_type ".>>.")
                    (setq grp_list (remove_one&Sub_On_Off element grp_list ))
                    (setq Ungrp_list (append Ungrp_list (list  element)))
                    
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    
                    (list grp_list Ungrp_list)
                    
            
           );add
           (;|del|; (= action_type ".<<.")
                    (setq grp_list (append grp_list (list  element)))
                    (setq Ungrp_list (remove_one&Sub_On_Off element Ungrp_list ))
                    
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
           );del
     );cond
 );defun
 
                   


(defun remove_one&Sub_On_Off ( obj li / remove_flag i ret_list nthdata)
     (setq ret_list nil)
     (setq remove_flag nil)
     (setq i 0)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= (strcase nthdata)(strcase obj)) 
              (setq ret_list (append ret_list (list nthdata)))
              (setq remove_flag t)
          );if
          (setq i (1+ i))
     );while
     (if (=  remove_flag nil)
         (setq ret_list li)
         (setq ret_list ret_list)
     );if
    
);defun

(defun layeroff&Sub_On_Off(en)
     (setq en (strcat "," en ))
     (if (/= (string_search&Sub_On_Off (strcase en) (strcat ","(getvar "clayer") ",") ) nil)
         (progn
              (command "-layer" "off" en "y" "")
         );progn
         (progn
              (command "-layer" "off" en "")
         );progn  
     );if
     (setq ass en)
);defun

(defun init_finish&Sub_On_Off(in_fi / mm    );in_fi:init_finish  
    
     
  
     (cond (;|init|;
              (= (strcase in_fi) "INIT")
              (foreach mm source_state_group_on_240
                     (layeroff&Sub_On_Off mm)
              );foreach
              (foreach mm source_state_asm_off_240
                     (command "-layer" "on" mm "")
              );foreach
              (foreach mm non_inp_set_240
                     (layeroff&Sub_On_Off mm)
              );foreach
           );init
           (;|finish|;
             (= (strcase in_fi) "FINISH")
             (foreach mm source_state_group_on_240
                    (command "-layer" "on" mm "")
             );foreach
             (foreach mm source_state_asm_off_240
                    (layeroff&Sub_On_Off mm)
             );foreach
             (foreach mm non_inp_set_240
                    (command "-layer" "on" mm "")
             );foreach
          );finish
       );COND
 );defun


 (defun str_merge&Sub_On_Off(li str / reverse_data  merge_str  merge_list mergedata)
      (setq reverse_data (reverse li))
      (setq merge_str  (car reverse_data))
      (setq merge_list (cdr reverse_data))
   
      (if (= merge_str nil)
          (setq merge_str ",")
      );if
      (if (<= (strlen (setq mergedata (strcat merge_str  "," str ","))) 240)
          (progn
               (if (= merge_str ",")
                   (setq merge_str str)
                   (setq merge_str mergedata)
               );if      
               (setq merge_list (cons merge_str merge_list))
               (setq merge_list (reverse merge_list))
          );progn
          (progn
               (setq merge_list (append li (list str)))
          );progn  
      );if
      merge_list
  );defun 
  (defun string_search&Sub_On_Off(string search_s / prt flag string_len search_s_len find_s)
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


;*****************************************************************************************************



 ;;;┌────────────────────────────────┐
 ;;;│  程  式 :desinger版                                            │
 ;;;│  主程式 :Sub_reverse                                           │
 ;;;│  日  期 :89.11.29                                              │
 ;;;│  姓  名 :jacky                                                 │
 ;;;│  對話框 :                                                      │
 ;;;│  方  法 :                                                      │
 ;;;│  相關檔案:sub numList                                          │
 ;;;└────────────────────────────────┘
 


; sub 代表 次組合
(defun c:Sub_Reverse(/  #asm_path_dcl            #group_list        #ungroup_list        #asm_judge        #source_state_group_on
                       #source_state_asm_off    dcL_id             oker                 #all_group        #non_inp_set
                       #partref_group_set       len_blance         #LSP_sub_name        #Lsp_draw_sel     #asm_data
                       #current_group_list_off  #have_asmdata_list #asm_judge_source_on #asm_judge_source_off
                )
     (if (= (ssget "x") nil)
         (progn
              (alert "圖面無資料")
              (exit)
         );progn
     );if                    
     (setvar "cmdecho" 0)
     ;(setq #asm_path_dcl Powdesign_DCL_PATH)
  
     (setq #group_list nil)
     (setq #ungroup_list nil)
     (setq #asm_judge   nil)
     (setq #source_state_group_on nil)
     (setq #source_state_group_off nil)
     (setq #source_state_asm_off    nil)
     (setq #have_asmdata_list nil)
     (setq #non_inp_set nil)
     (setq #LSP_sub_name nil)
     (setq #asm_judge_source_on nil)
     (setq #asm_judge_source_off nil)
     (setq #Lsp_draw_sel "0")
     (setq #current_group_list_off nil)
     (setq #all_group (coLL_Layer&Sub_Reverse))
     (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
             
     (cond ( (=  #partref_group_set nil)
              
              (setq len_blance (getdata_YN "\n 完全未建立資訊點, 須建立(Y/N)? <Y>:"))
              (if (= len_blance nil)
                  (setq len_blance "Y")
              );if      
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart) 
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn  
                  (progn
                       (alert "\n 資訊點完全未建立 ")
                       (exit)
                  );progn  
              );if
           ) 
           ( (/= (length #all_group) (sslength #partref_group_set))
         
              (setq len_blance (getdata_YN "\n 是否自動檢查資訊點之建立(Y/N)? <N>: "))
              (if (= len_blance nil)
                  (setq len_blance "N")
              );if
              (if (or (= (strcase len_blance) "Y")
                      (= (strcase len_blance) "YES")
                  );or
                  (progn
                       (load "manapart")
                       (c:automakepart)
                       (setq #partref_group_set (ssget "x" (list  (cons 0 "INSERT")(cons 2 "PARTREF"))))
                  );progn  
              );if
           );2 
     );cond  
                                       
     
     (generate_group&existasm&Sub_Reverse)
     (if (= #asm_judge nil)
         (progn
              (alert "\n無次組合資料, 請建立次組合!!")
              (exit)
         );progn
     );if
     (subsys_ok&Sub_Reverse)
     (princ)
);defun

;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function before  DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘


;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  function between DCL area                     │
;;;│                                                                │
;;;└────────────────────────────────┘

    
  (defun coll_layer&Sub_Reverse(/ coll_layer_list ladata)
     (setq total_layer_list (list (cdadr (tblnext "layer" t))))
     (setq ladata (tblnext "layer"))
     (while ladata
          (setq total_layer_list (cons (strcase (cdadr ladata)) total_layer_list))
          (setq ladata (tblnext "layer"))
     );while
     total_layer_list
    
  );defun
 
 
 






;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  main function  area                           │
;;;│                                                                │
;;;└────────────────────────────────┘

                                   ; or_num_w is order number written
 (defun subsys_ok&Sub_Reverse  (/ partdata_list parttemp_list grp_prs_list unpartdata_list unparttemp_list ungrp_prs_list entdata_list mm)
      (setq partdata_list        nil)
      (setq partdata_list_240    nil)
      (setq parttemp_list        nil)
      (setq unpartdata_list      nil)
      (setq unpartdata_list_240  nil)
      (setq unparttemp_list      nil)
    
               ;(= #Lsp_draw_sel "0")
               (setq grp_prs_list   #group_list)
               (setq ungrp_prs_list #ungroup_list)
             
               (foreach mm grp_prs_list;group_process_list
                      (setq parttemp_list (cdr (assoc (strcase mm) #have_asmdata_list)))
                      (setq partdata_list (append partdata_list parttemp_list))
               );foreach
               
               (foreach mm ungrp_prs_list;ungroup_process_list
                      (setq unparttemp_list (cdr (assoc (strcase mm) #have_asmdata_list)))
                      (setq unpartdata_list (append unpartdata_list unparttemp_list))
               );foreach
         
            
            
      
       (foreach mm partdata_list
              (setq partdata_list_240 (str_merge&Sub_Reverse partdata_list_240 mm))
       );foreach
       (foreach mm unpartdata_list
              (setq unpartdata_list_240 (str_merge&Sub_Reverse unpartdata_list_240 mm))
       );foreach
       (foreach mm partdata_list_240
              (layeroff&Sub_Reverse mm)
       );foreach
       (foreach mm unpartdata_list_240
              (command "-layer" "on" mm "")
       );foreach
   
       
 
 );defun  
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘

(defun *error* (msg)
      (princ)
);defun


(defun generate_group&existasm&Sub_Reverse( /  mm assoc_data tag2data assoc_asmdata new_assoc_asmdata  
                                              cond_attrpart_state   attrpart_source_s_g_on_240           have_inp_list
                                              source_s_g_on_and_have_inp         source_s_g_off_and_have_inp
                                              attrpart_source_s_g_off_240
                                          )
                           
   
     
     
     (setq cond_attrpart_flag nil)
     (setq cond_attrpart_state nil)
     (setq attrpart_source_s_g_on_240 nil)
     (setq attrpart_source_s_g_off_240 nil)
     (setq source_s_g_on_and_have_inp nil)
     (setq source_s_g_off_and_have_inp nil)
     (foreach mm  (all_infp&Sub_Reverse)
           
            
            (setq assoc_data  (assoc "TAG2" (get_bomdata&Sub_Reverse mm)))
            (if (/= assoc_data nil)
                (progn
                     (setq mm (strcase (cdr (assoc 8 (entget mm)))))
                
                     (setq tag2data  (strcase (cadr assoc_data)))
                     (if (or (= tag2data nil)
                             (= tag2data "")
                         );or
                         (progn
                              (if (>= (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                   (setq #source_state_group_on   (append #source_state_group_on  (list mm)))
                                   (setq #source_state_group_off  (append #source_state_group_off (list mm)))
                              );if
                         );progn
                         (progn
                              (if (= (setq assoc_asmdata (assoc tag2data #have_asmdata_list)) nil)
                                  (progn
                                       (setq #have_asmdata_list  (append #have_asmdata_list (list (list tag2data mm))))
                                  );progn
                                  (progn
                                       (setq new_assoc_asmdata  (append assoc_asmdata (list mm)))
                                       (setq #have_asmdata_list (subst new_assoc_asmdata assoc_asmdata #have_asmdata_list))
                                  );progn
                              );if      
                              (if (= (member tag2data #asm_judge) nil)      
                                  (setq #asm_judge  (append #asm_judge (list tag2data)))
                                  (if (>= (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                                      (setq #asm_judge_source_on  (append #asm_judge_source_on (list tag2data)))
                                  );if
                              );if      
                             ;(if (< (cdr (assoc 62 (entget (tblobjname "layer" mm)))) 0)
                             ;    (setq #source_state_asm_off  (append #source_state_asm_off (list mm)))
                             ; );if
                         );progn  
                     );if
                     
                );progn  
            );if  
            
     );foreach
     (cond (;1
                (or (and (/= #source_state_group_on  nil)
                         (/= #source_state_group_off nil)
                    );and
                    (and (/= #source_state_group_on  nil)
                         (= #source_state_group_off nil)
                    );and
                );or
                (setq cond_attrpart_flag 1)
                (setq cond_attrpart_state (getdata_YN "\非任何次組合之零件是否關掉(off)! (Y/N)? <Y>:"))
                     
            );1
            (;2
                
                (and (= #source_state_group_on  nil)
                     (/= #source_state_group_off  nil)
                );and
                (setq cond_attrpart_flag 2)
                (setq cond_attrpart_state (getdata_YN "\非任何次組合之零件是否打開(on)! (Y/N)? <N>:"))
                      
            );2
     );cond
     
     (if (and (= cond_attrpart_state "")
              (= cond_attrpart_flag 1)
         );and
         (setq cond_attrpart_state "Y")
     );if
     (if (and (= cond_attrpart_state "")
              (= cond_attrpart_flag   2)
         );and
         (setq cond_attrpart_state "N")
     );if
     (if (and (/= cond_attrpart_state nil)
              (or (= (strcase cond_attrpart_state) "Y")
                  (= (strcase cond_attrpart_state) "YES")
              );or
         );and     
         (progn
              (cond (;1
                        (or (and (/= #source_state_group_on  nil)
                                 (/= #source_state_group_off nil)
                            );and
                            (and (/= #source_state_group_on  nil)
                                 (= #source_state_group_off nil)
                            );and
                        );or    
                        (setq source_s_g_on_and_have_inp (append #source_state_group_on (list "$Partref_Bom")))
                        (foreach mm source_s_g_on_and_have_inp;s_g_on:state_group_on
                               (setq attrpart_source_s_g_on_240 (str_merge&Sub_Reverse attrpart_source_s_g_on_240 mm))
                        );foreach
                        (foreach mm attrpart_source_s_g_on_240
                               (layeroff&Sub_Reverse mm)
                        );foreach
                    );1
                    (;2
                        
                        (and (= #source_state_group_on  nil)
                             (/= #source_state_group_off  nil)
                        );and
                
                        (setq source_s_g_off_and_have_inp (append #source_state_group_off (list "$Partref_Bom")))
                        (foreach mm source_s_g_off_and_have_inp;s_g_off:state_group_off
                               (setq attrpart_source_s_g_off_240 (str_merge&Sub_Reverse attrpart_source_s_g_off_240 mm))
                        );foreach
                        (foreach mm attrpart_source_s_g_off_240
                               (command "-layer" "on" mm "")
                        );foreach
                    );2
             );cond 
         );progn
     );if  
     
     (foreach mm #asm_judge
            (if (= (member  mm  #asm_judge_source_on) nil)
                (setq #asm_judge_source_off (append #asm_judge_source_off (list mm)))
            );if
     );foreach  
     (setq #group_list    #asm_judge_source_on)
     (setq #ungroup_list #asm_judge_source_off)
     
);defun

(defun all_infp&Sub_Reverse(/ ent laname all_ent_set i )
  (setq ent nil) 
  ;(setq laname (strcase lname))
  (setq all_ent_set nil)  
  (setq #non_inp_set #all_group)
  (if #partref_group_set
      (progn
           (setq i 0)
           (while (setq ent (ssname #partref_group_set i))
                (setq all_ent_set (append all_ent_set (list ent)))
                (setq #non_inp_set (remove_one&Sub_Reverse (strcase (cdr (assoc 8 (entget ent))))#non_inp_set ))
                (setq i (1+ i))
           );while
      );progn   
  );if
  all_ent_set 
);defun

(defun get_bompent&Sub_Reverse(lname / partref_group laname ent)
  (setq ent nil) 
  (setq laname (strcase lname))
  (setq partref_group (ssget "x" (list (cons 8 laname) (cons 0 "INSERT")(cons 2 "PARTREF"))))
  (if partref_group
     (setq ent (ssname partref_group 0))
  );if
  ent
);defun

(defun get_bomdata&Sub_Reverse(ballname / nextent datalist nextent_data nextent_data2 nextent_data1)
   (if (/= ballname nil)
       (progn
            (setq nextent (entnext ballname) datalist '())
            (setq nextent_data (entget nextent))
            (while (= "ATTRIB" (cdr (assoc 0 nextent_data)))
                   (setq nextent_data2 (cdr (assoc 2 nextent_data)) )
                   (setq nextent_data1 (cdr (assoc 1 nextent_data)) )
                   (setq datalist (cons (list nextent_data2 nextent_data1) datalist))
                   (setq nextent (entnext nextent))
                   (setq nextent_data (entget nextent))
            );while
        );progn
   );if  
   datalist
);defun

 
                   


(defun remove_one&Sub_Reverse ( obj li / remove_flag i ret_list nthdata)
     (setq ret_list nil)
     (setq remove_flag nil)
     (setq i 0)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= (strcase nthdata)(strcase obj)) 
              (setq ret_list (append ret_list (list nthdata)))
              (setq remove_flag t)
          );if
          (setq i (1+ i))
     );while
     (if (=  remove_flag nil)
         (setq ret_list li)
         (setq ret_list ret_list)
     );if
    
);defun

(defun layeroff&Sub_Reverse(en)
     (setq en (strcat "," en))
     (if (/= (string_search&Sub_Reverse (strcase en) (strcat ","(getvar "clayer") ",") ) nil)
         (command "-layer" "off" en "y" "")
         (command "-layer" "off" en "")
     );if
);defun



 (defun str_merge&Sub_Reverse(li str / reverse_data  merge_str  merge_list mergedata)
      (setq reverse_data (reverse li))
      (setq merge_str  (car reverse_data))
      (setq merge_list (cdr reverse_data))
   
      (if (= merge_str nil)
          (setq merge_str ",")
      );if
      (if (<= (strlen (setq mergedata (strcat merge_str  "," str ","))) 240)
          (progn
               (if (= merge_str ",")
                   (setq merge_str str)
                   (setq merge_str mergedata)
               );if      
               (setq merge_list (cons merge_str merge_list))
               (setq merge_list (reverse merge_list))
          );progn
          (progn
               (setq merge_list (append li (list str)))
          );progn  
      );if
      merge_list
  );defun 
  (defun string_search&Sub_Reverse(string search_s / prt flag string_len search_s_len find_s)
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

;*************************************************************************************************************
(defun getdata_YN(mage / yn)
     (initget  "Y N")
     (setq yn (getkword mage))
);defun

(defun acad_strlsortp(sortlist / )
     (if (/= sortlist nil)
         (setq sortlist (acad_strlsort sortlist))
     );if
     sortlist
);defun  
                      
