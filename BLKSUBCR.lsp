;;;
;;;┌────────────────────────────────┐
;;;│  程  式 :desinger版                                            │
;;;│  主程式 :blksubcr                                              │
;;;│  日  期 :90.02.20                                              │
;;;│  姓  名 :jacky                                                 │
;;;│  對話框 :                                                      │
;;;│  方  法 :                                                      │
;;;│  相關檔案:sub numList                                          │
;;;└────────────────────────────────┘
;blksubcr      -->次組合建立

 



; sub 代表 次組合
(defun c:blksubcr(/  #asm_path_dcl             #group_list     #group_list_set  #ungroup_list
		     #source_state_group_on    #source_state_group_on_set       #asm_set
		     #asm_judge                #source_state_group_off
		     #source_state_group_on_set
		     #source_state_asm_on      #source_state_asm_off
		     #source_state_asm_on_set  #source_state_asm_off_set
		     #sepcode                   #nonpart         #on_layer       #off_layer
		     dcL_id                    oker             #all_group
		     #non_inp_set
		     #partref_group_set        len_blance       #LSP_sub_name    #Lsp_draw_sel
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
     (setq #group_list_set nil)
     (setq #ungroup_list nil)
     (setq #source_state_group_on  nil)
     (setq #source_state_group_on_set  nil)
  
     (setq #asm_set nil)
     (setq #asm_judge   nil)
     (setq #source_state_asm_on     nil)
     (setq #source_state_asm_off    nil)
     (setq #source_state_asm_on_set     nil)
     (setq #source_state_asm_off_set    nil)
    

     (setq #sepcode   (vgetfile_val&blksubcr (strcat powdesign_PATH "system.ini") "分隔碼 (零件名稱與視圖代號間)"))
     (setq #nonpart  (vgetfile_val&blksubcr (strcat powdesign_PATH "system.ini") "不建立資訊點的圖層"))
     (setq #on_layer (vgetfile_val&blksubcr (strcat powdesign_PATH "system.ini") "零件 (BLOCK) 繪圖層"))
  
     (if (and  (/= #sepcode nil)
	       (/= (read #sepcode) nil)
	 );and      
         (progn
             (setq #sepcode   (car (read #sepcode)))
	 );progn
         (progn
	      (alert "\n 不合理分隔碼 (零件名稱與視圖代號間)")
	      (exit)
	 );progn
     );if
     (setq #nonpart  (read #nonpart))
     (setq #on_layer (car (read #on_layer)))
     (setq #off_layer "hide_block_layer")
  
     (if (= (tblobjname "layer" #on_layer) nil)
         (command "-layer" "m" #on_layer "" )
     );if  
     (if (= (tblobjname "layer" #off_layer) nil)
         (command "-layer" "m" #off_layer "" )
     );if
     (command "-layer"  "t" #on_layer "s" #on_layer "")
     (command "-layer"  "off" #off_layer "f" #off_layer "")
     ;(setq #non_inp_set nil)
     
     (setq #LSP_sub_name nil)
     (setq #Lsp_draw_sel "1")
   
                                       
     (actdcl (strcat #asm_path_dcl "blksubcr") "blksubcr")
     (generate_group&existasm&blksubcr)
     (mode_tile "sub_add" 0)
     (mode_tile "sub_del" 1)
  
     (mode_1&blksubcr)
    
     (set_tile  "cue"   "操作步驟: (1) 先輸入 {次組合名稱}, 按 [enter]" )  
     (set_tile  "cue1"  "          (2) 後選擇 {是否圖選}" ) 
     (mode_tile "sub_name" 2) 
     (action_tile "sub_name" "(subsys_name&blksubcr)") 
  
     (action_tile "p_list"  "(mode_tile \"sub_add\" 0) (mode_tile \"sub_del\" 1)")
     (action_tile "j_list"  "(mode_tile \"sub_add\" 1) (mode_tile \"sub_del\" 0)")  

     (action_tile "sub_add"  "(subsys_add&blksubcr)")
     (action_tile "sub_del"  "(subsys_deL&blksubcr)")
     (action_tile "draw_sel" "(subsys_draw_sel&blksubcr)")
     (action_tile "accept" "(setq oker 1)(done_dialog)")
     (action_tile "cancel" "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
     (start_dialog)
    
     (if (= oker 1)
         (progn
              (subsys_ok&blksubcr)
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
  
  
  (defun  subsys_name&blksubcr()
        
          
          (if (and
                   (/= (get_tile "sub_name") "")
                   ;(/= #asm_judge nil)
                   (= (member (strcase (get_tile "sub_name")) #asm_judge) nil)
                   
              );and       
              (progn
                   (setq #LSP_sub_name (strcase (get_tile "sub_name")))
                   (setq #Lsp_draw_sel (get_tile "draw_sel"))
        
                   (set_tile "error" "")
                   (mode_2&blksubcr)
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



   (defun subsys_add&blksubcr (/ p_list_msel    p_list_mp   group_list_nth    e1        e2
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
                           (setq groupmanage_retval (groupmanage&blksubcr  group_list_nth #group_list ".>>."  #ungroup_list))
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
    );defun_subsys_add&blksubcr

   (defun subsys_deL&blksubcr (/ j_list_msel   j_list_mp   ungroup_list_nth   e1        e2
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
                          (setq groupmanage_retval (groupmanage&blksubcr  ungroup_list_nth #group_list ".<<." #ungroup_list))
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
    );defun_subsys_deL&blksubcr
;}}}}}}
  

  (defun subsys_draw_sel&blksubcr(/ tlayer_list  asmfp       temp_group_list
                                    asmdata      asmdata_key  asmdata_body     asmdata_key_body
                                    asmdata_list asm_mp       temp_asmdata     asmdata_groupname
                                    asm_code_groupname
                                  )
         
         (if (= (get_tile "draw_sel") "1")
             (progn
                  (mode_3&blksubcr)
                  (setq #Lsp_draw_sel "1")
             );progn
             (progn
                  (mode_4&blksubcr)
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

 

(defun subsys_ok&blksubcr  (/  partdata_list parttemp_list p_list      entdata_list
			       mm            3_view_set
			       3_view_i      3_entname     3_view_list ss3 insp

			      )
      (setq partdata_list nil)
      (setq parttemp_list nil)
      (setq 3_view_list   nil)
      (cond (
	       (= #Lsp_draw_sel "0")
	       (init_finish&blksubcr "init")
	       (foreach mm #ungroup_list
		    (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm #sepcode "*")))))
		    (setq 3_view_list (append 3_view_list (list 3_view_set)))
	       );foreach 	 
	       (init_finish&blksubcr "finish")	    
	       (setq partdata_list 3_view_list) 
	    )
	    (
               (= #Lsp_draw_sel "1")
	       (setq partdata_list (loop_sel&blksubcr))
	     
	    )
	    (t
	      (alert "#Lsp_draw_sel無值!")
	      (exit)
	    )
       );cond
       (setq ss3 (car partdata_list))
       (foreach mm (cdr partdata_list)
              (command "select" ss3 mm "")
              (setq ss3 (ssget "p"))
       );forech
       (setq insp '(0 0 0))
       (if (/= ss3 nil)
           (progn
	        (command "block"  #LSP_sub_name insp ss3 "" )
                (command "insert" #LSP_sub_name insp "1" "1" "0")
	        (adxdata&blksubcr "sub")
	        (princ (strcat "\n次組合圖塊 " #LSP_sub_name " 建立完成! "))
	   );progn
	   (progn
	        (alert (strcat "\n未建立次組合 " #LSP_sub_name " 圖塊!"))
	   );progn
       );if	 
 );defun

  
     
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘
;{{{{{{
 (defun mode_1&blksubcr()
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
 );mode_1&blksubcr

 (defun mode_2&blksubcr()
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

  
 (defun mode_3&blksubcr()
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
 (defun mode_4&blksubcr()
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






 (defun loop_sel&blksubcr(/       ent blk_list entname  blkname2 entname_list mm sel_mode w_i 3_view_list 3_view_set 3_view_i s_num 3_entname 3_view_list_g)
       (init_finish&blksubcr "init")
       (setq sel_mode (getint "\n[圖選(1) / 前置碼方式(2)] <圖選>:   "))
       (setq entname_list nil)
       (cond (;1
	        (or (= sel_mode nil)
		    (= sel_mode 1)
		);or
	        (progn      
		     (setq ent 1)
                     (setq blk_list '())
                     
       
                     (while (/= ent nil)
                          (progn
                               (setq ent      (entsel "\n請選擇物件:<離開 按enter> "))
		  
                               (if (/= ent nil)
                                 (progn
                                    (setq entname  (car ent))
			            ;(redraw entname 3)
			            (setq blkname2 (cdr (assoc 2 (entget entname))))
			            ;(setq entname_list (cons entname entname_list))
				    (if (/= (string_search&hideblk blkname2 sepcode)  nil)
				        (progn
					     (redraw entname 3)
					     (setq entname_list (cons entname entname_list))
				            (setq blk_list  (cons (strcase blkname2) blk_list))
					);progn
				        (progn
				             (alert "\n不具零件名稱之圖塊 (BLOCK)!")
					);progn  
				    );if  
                                 );progn
                               );if
                          );progn
                      );while
		      (setq 3_view_list nil)
		      (setq 3_view_set nil)
		      (setq 3_view_list_g nil)
		      (foreach mm blk_list
			   (setq s_num (string_search&blksubcr mm #sepcode))
			   (setq mm (substr mm 1 (1- s_num)))
			   (if (= (member (strcase mm) 3_view_list_g) nil)
			       (progn
				    (setq 3_view_list_g (append 3_view_list_g (list mm)))
			            (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm #sepcode "*")))))
			            (setq 3_view_list (append 3_view_list (list 3_view_set)))
			       );progn
			   );if  
		      );foreach
		      (setq blk_list 3_view_list)
                      (foreach mm entname_list
	                  (redraw mm 4)
	              );foreach
                      (init_finish&blksubcr "finish")
                      blk_list
                );progn
	     );1
	     (;|2|;(= sel_mode 2)
	           (progn
		        (setq grpname_data nil)
		        ;(setq entlist '())
		        (setq grpname_data (getstring "\n請輸入前置碼 (可用逗號隔開 如 s*,motor*,tablet*):  "))
		        (setq grpname_data (strcat "(\"" grpname_data "\")"))
		        (while (/= (string_search&blksubcr  grpname_data  ",") nil)
		               (setq grpname_data (string_subst&blksubcr "\"  \""  "," grpname_data))
			);while  
		        (setq grpname_data (read grpname_data))
		        (setq blk_list nil)
		        (foreach mm grpname_data
			       (setq grp_set (ssget "x" (list (cons 0 "INSERT")(cons 2 mm))))
			       (setq blk_list  (append  blk_list (list grp_set)))
			);foreach
		        (init_finish&blksubcr "finish")
		        blk_list
		   );progn
	     );2
	);cond     
);defun
 (defun *error* (msg)
       (princ)
)  

(defun generate_group&existasm&blksubcr(/  mm nonpart_set nonpart_set_i nonpart_ent i
					   all_ssname blkdata_list blkname s_num
				       )

     ;過濾零件
     (setq #group_list_set (ssget "X" (list (cons 0 "insert")  (cons 2  (strcat "*" #sepcode "*")))))
     (if (and (/= #group_list_set nil)
	      (/= (sslength #group_list_set) 0)
	 );and
         (progn
             (foreach mm #nonpart
                 (setq nonpart_set (ssget "x" (list (cons 0 "INSERT")(cons 8 mm))))
                 (setq nonpart_set_i 0)
                 (while (and (/= nonpart_set nil)
		             (/= (setq nonpart_ent (ssname nonpart_set nonpart_set_i)) nil)
		        );and
	              (ssdel  nonpart_ent #group_list_set)
	              (setq nonpart_set_i (1+ nonpart_set_i))
	         );while
             );foreach
	    ; (if (/= #group_list_set nil)
            ;     (setq #all_blk_sslist (list #group_list_set))
	    ; );if  
	 );progn
     );if
     (setq i 0)
     (setq all_ssname nil)
     (while  (and  (/= #group_list_set nil)
	           (/= (setq all_ssname  (ssname #group_list_set i)) nil)
	     );and
	     (setq blkdata_list (entget all_ssname))	          
	     (setq blkname (cdr (assoc 2 blkdata_list)))
	     (setq s_num (string_search&blksubcr blkname #sepcode))
	     (setq blkname (strcase (substr blkname 1 (1- s_num))))
	     (if (= (member blkname #group_list) nil)
                 (setq #group_list (append #group_list (list blkname)))
	     );if
	     (setq i (1+ i))

     );while
     (setq #source_state_group_off_set (ssget "X" (list (cons 0 "insert")(cons 8 #off_layer)  (cons 2  (strcat "*" #sepcode "*")))))

      ;過濾次組合 
     (setq #asm_set                  (ssget "X" (list (cons 0 "insert") (list -3 (list "SUB")) )))
     (setq #source_state_asm_on_set #asm_set)
     (setq #source_state_asm_off_set (ssget "X" (list (cons 0 "insert") (cons 8 #off_layer) (list -3 (list "SUB")) )))
     (setq i 0)
     (setq all_ssname nil)
     (while  (and  (/= #asm_set nil)
	           (/= (setq all_ssname  (ssname #asm_set i)) nil)
	     );and
             (setq blkdata_list (entget all_ssname))	          
	     (setq blkname (cdr (assoc 2 blkdata_list)))
             (if (= (member (strcase blkname)  #asm_judge) nil)
	         (setq #asm_judge (append #asm_judge (list blkname)))
	     );if  
	     (setq i (1+ i))
     );while
     (setq i 0)
     (setq all_ssname nil)
     (while  (and  (/= #source_state_asm_off_set nil)
	           (/= (setq all_ssname  (ssname #source_state_asm_off_set i)) nil)
	     );and
          
	     (ssdel all_ssname 	#source_state_asm_on_set)          
	     (setq i (1+ i))
     );while
  
     
     (if (/= #group_list nil)
         (setq #group_list (acad_strlsort #group_list))
     );if  
     
     
);defun




(defun groupmanage&blksubcr(  element grp_list  action_type Ungrp_list )
     (setq action_type (strcase action_type))
     (setq element (strcase element))
     (cond (;|add|; (= action_type ".>>.")
                    (setq grp_list (remove_one&blksubcr element grp_list ))
                    (setq Ungrp_list (append Ungrp_list (list  element)))
                    (setq grp_list (acad_strlsortp&blksubcr grp_list))
                    (setq Ungrp_list (acad_strlsortp&blksubcr Ungrp_list))
                    (list grp_list Ungrp_list)
                    
            
           );add
           (;|del|; (= action_type ".<<.")
                    (setq grp_list (append grp_list (list  element)))
                    (setq Ungrp_list (remove_one&blksubcr element Ungrp_list ))
                    (setq grp_list (acad_strlsortp&blksubcr grp_list))
                    (setq Ungrp_list (acad_strlsortp&blksubcr Ungrp_list))
                    (list grp_list Ungrp_list)
           );del
     );cond
 );defun 
                   
(defun remove_one&blksubcr ( obj li /  remove_flag i ret_list nthdata)
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


(defun blk_on(bn);bn:blkname ip:information point
    (if (/= bn nil)
         (command "change" bn "" "P" "LA" #on_layer "")
     );if  
);defun
 (defun blk_off(bn )
    (if (/= bn nil)
        (command "change" bn "" "P" "LA" #off_layer "")
    );if  
 );defun  

(defun init_finish&blksubcr(in_fi / mm);in_fi:init_finish
     (cond (;|init|;
              (= (strcase in_fi) "INIT")
              (foreach mm (list #source_state_group_off_set)
                     (blk_on mm)
              );foreach
              (foreach mm (list  #source_state_asm_on_set)
                     (blk_off mm)
              );foreach
           );init
           (;|finish|;
              (= (strcase in_fi) "FINISH")
              (foreach mm (list #source_state_group_off_set)
                     (blk_off mm)
              );foreach
              (foreach mm (list  #source_state_asm_on_set)
                     (blk_on mm)
              );foreach
           );finish
       );COND
 );defun





 
  (defun string_search&blksubcr(string search_s / prt flag string_len search_s_len find_s)
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

(defun vgetfile_val&blksubcr(fname initxt / ff  needdata data txtid objdata dd)
       (if (= (setq ff   (open fname "r")) nil)
           (progn
                (alert "system.ini檔案不存在")
                (exit)
           ) ;progn
    
       );if
       (setq #textdef initxt)
       (setq needdata nil)
       (setq #downdata nil)
 
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
                     )  ;progn
           
                 );if
             );progn
     
          );if
      );while
      (setq #downdata (reverse #downdata))
      (close ff)
      (setq a (list needdata))
      needdata
  
);defun
(defun adxdata&blksubcr(xdata_flag / entname oldentdata dd newdata newent)
   (if (= (tblsearch "appid" xdata_flag) nil)
       (regapp xdata_flag)
   );if  
   (setq entname (entlast))
   (setq oldentdata (entget entname))
   (setq newdata (list -3 (list xdata_flag (cons 1000 "1"))))
   (setq newent (append oldentdata (list newdata)))
   (entmod newent)
 (princ)
);defun

(defun acad_strlsortp&blksubcr(sortlist / )
     (if (/= sortlist nil)
         (setq sortlist (acad_strlsort sortlist))
     );if
     sortlist
);defun