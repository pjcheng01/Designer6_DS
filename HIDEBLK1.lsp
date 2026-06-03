;;;
;;;┌────────────────────────────────┐
;;;│  程  式 :desinger版                                            │
;;;│  主程式 :hideblk                                               │
;;;│  日  期 :89.2.7                                                │
;;;│  姓  名 :jacky                                                 │
;;;│  對話框 :                                                      │
;;;│  方  法 :                                                      │
;;;│  相關檔案:sub numList                                          │
;;;└────────────────────────────────┘




(defun c:hideblk(/  #asm_path_dcl         #group_list    #ungroup_list    #asm_judge        #source_state_group_on
		   #source_state_asm_off    dcL_id         oker             #all_group        #non_inp_set
		   #partref_group_set      len_blance     #LSP_sub_name    #Lsp_draw_sel     #asm_data
		   #current_group_list_off #have_asmdata_list sepcode
		)
   
     (if (= (ssget "x") nil)
         (progn
              (alert "圖面無資料")
              (exit)
         );progn
     );if	             
     (setvar "cmdecho" 0)
     (setq #path_dcl Powdesign_DCL_PATH)
     (setq sepcode (vgetfile_val&hideblk (strcat powdesign_PATH "system.ini") "分隔碼 (零件名稱與視圖代號間)"))
     (setq sepcode (car (read sepcode)))
     (setq #group_list nil)
     (setq #sel_list nil)
     (setq #Lsp_draw_sel "1")
  
     (setq #all_blk_list nil)
     (setq #on_blk_list  nil)
     (setq #off_blk_list nil)
  
     (setq #all_blk_list_g nil)
     (setq #on_blk_list_g  nil)
     (setq #off_blk_list_g nil)
  
     (coLL_block&hideblk)
     (setq #group_list #on_blk_list_g) 
     ;(setq #all_group (coLL_block&hideblk))
        
     (actdcl (strcat #path_dcl "hideblk") "hideblk")
     (action_tile "c_list"  "(setq #sel_list (selectpro))")
     (action_tile "draw_sel" "(subsys_draw_sel&hideblk)")
     (action_tile "accept" "(setq oker 1)(done_dialog)")
     (action_tile "cancel" "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
     (start_dialog)
    
     (if (= oker 1)
         (progn
              (hideblk_ok&hideblk)
	     
	 );progn  
     );if
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

  (defun coll_block&hideblk(/ flag blkdata_list blkname blkset  blkent blkent_list  i blkname_on
                              s_num_on  
			    )
     (setq flag t)
     (if (/= (tblnext "block" flag) nil)
         (progn
              ;(while (setq blkdata_list (tblnext "block" flag))
              ;     (setq flag nil)
              ;     (setq blkname (cdr (assoc 2 blkdata_list)))
              ;     (setq #all_blk_list (append #all_blk_list (list blkname)))
              ;);while
              (setq blkset (ssget "x" (list (cons 0 "INSERT"))))
              (setq i 0)
              (if (/= blkset nil)
                  (progn
                       (while (setq blkent (ssname blkset i))
                            (setq blkent_list (entget blkent))
			    (setq blkname_on (cdr (assoc 2 blkent_list)))
                            (setq #on_blk_list (append #on_blk_list (list blkname_on)))
			 
			    (setq s_num_on (string_search&hideblk blkname_on sepcode))
		            (setq blkname_on (strcase (substr blkname_on 1 (1- s_num_on))))
			    (if (= (member blkname_on  #on_blk_list_g) nil)
                                (setq #on_blk_list_g (append #on_blk_list_g (list blkname_on)))
			    );if  
                            (setq i (1+ i))
                       );while
		      ; (setq #off_blk_list #all_blk_list)
		      ; (foreach mm #on_blk_list
                       ;       (setq #off_blk_list (remove_one&hideblk #off_blk_list mm))
                       ;);foreach
	          );progn
		  (progn
		       (alert  "\n圖面上無圖塊(BLOCK) ! ")
		  );progn  
              );if
	 );progn
         (progn
	      (alert  "\n完全無圖塊(BLOCK) ! ")
	 );progn  
	      
     );if  
        
  );defun
 

  (defun subsys_draw_sel&hideblk(/ tlayer_list  asmfp       temp_group_list
			        asmdata      asmdata_key  asmdata_body     asmdata_key_body
			        asmdata_list asm_mp       temp_asmdata     asmdata_groupname
			        asm_code_groupname
			     )
         
         (if (= (get_tile "draw_sel") "1")
	     (progn
                  ;(mode_3&hideblk)
	          (mode_tile "c_list" 1)
	          (setq #Lsp_draw_sel "1")
	     );progn
	     (progn
                  ;(mode_4&hideblk)
	          (mode_tile "c_list" 0)
	          (setq #Lsp_draw_sel "0")
	          (if (/= #group_list nil)
	              (setq #group_list (acad_strlsort #group_list))
		  );if
	          (start_List "c_list" 3)
	          (mapcar 'add_list #group_list)
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
 (defun hideblk_ok&hideblk  (/ partdata_list parttemp_list p_list      entdata_list mm 3_view_set
                               3_view_i      3_entname     3_view_list
			     )
      (setq partdata_list nil)
      (setq parttemp_list nil)
      (cond (
	       (= #Lsp_draw_sel "0")
	      ; (init_finish&showblk "init")
	       (foreach mm #sel_list
		    (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm "*")))))
		    (setq 3_view_i 0)
		    (while (setq 3_entname (ssname 3_view_set 3_view_i))
		         (setq 3_view_list (append 3_view_list (list (cdr(assoc 2 (entget 3_entname))))))
                         (setq 3_view_i (1+ 3_view_i))
		    );while
	       );foreach 	 
	       ;(init_finish&showblk "finish")	    
	       (setq partdata_list 3_view_list) 
	       ;(setq partdata_list #sel_list) 
	    )
	    (
               (= #Lsp_draw_sel "1")
	       (setq partdata_list (loop_sel&hideblk))
	     
	    )
	    (t
	      (alert "#Lsp_draw_sel無值!")
	      (exit)
	    )
       );cond
       
       (foreach mm partdata_list
              (blk_off mm)
       );forech
 );defun  
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘


  
 
 
(defun loop_sel&hideblk(/       ent blk_list entname  blkname2 entname_list mm sel_mode w_i 3_view_list 3_view_set 3_view_i s_num 3_entname)
      ; (init_finish&showblk "init")
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
			            (redraw entname 3)
			            (setq blkname2 (cdr (assoc 2 (entget entname))))
			            (setq entname_list (cons entname entname_list))
                                    (setq blk_list  (cons (strcase blkname2) blk_list))
                                 );progn
                               );if
                          );progn
                      );while
		      (setq 3_view_list nil)
		      (setq 3_view_set nil)
		      (foreach mm blk_list
			   (setq s_num (string_search&hideblk mm sepcode))
			   (setq mm (substr mm 1 (1- s_num)))
			   (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm "*")))))
			   (setq 3_view_i 0)
			   (while (setq 3_entname (ssname 3_view_set 3_view_i))
			          (setq 3_view_list (append 3_view_list (list (cdr(assoc 2 (entget 3_entname))))))
                                  (setq 3_view_i (1+ 3_view_i))
			   );while
		      );foreach
		      (setq blk_list 3_view_list)
                      (foreach mm entname_list
	                  (redraw mm 4)
	              );foreach
                      ;(init_finish&showblk "finish")
                      blk_list
                );progn
	     );1
	     (;|2|;(= sel_mode 2)
	           (progn
		        (setq grpname_data nil)
		        ;(setq entlist '())
		        (setq grpname_data (getstring "\n請輸入前置碼 (可用逗號隔開 如 s*,motor*,tablet*):  "))
		        (setq grpname_data (strcat "(\"" grpname_data "\")"))
		        (while (/= (string_search&hideblk  grpname_data  ",") nil)
		               (setq grpname_data (string_subst&hideblk "\"  \""  "," grpname_data))
			);while  
		        (setq grpname_data (read grpname_data))
		        (setq blk_list nil)
		        (foreach mm grpname_data
			       (setq grp_set (ssget "x" (list (cons 0 "INSERT")(cons 2 mm))))
			       (setq w_i 0);while_i
			       (while (/= (setq entname (ssname grp_set w_i)) nil)
	                            (setq blkname2 (cdr (assoc 2 (entget entname))))
			            (setq blk_list  (cons (strcase blkname2) blk_list))
				    (setq w_i (1+ w_i))
		               );while	 
			);foreach
		      ;  (init_finish&showblk "finish")
		        blk_list
		   );progn
	     );2
	);cond     
);defun loop_sel&hideblk



 (defun *error* (msg)
       (princ)
 );defun



(defun blk_on(bn);bn:blkname ip:information point
      (command "-insert" bn '(0 0 0) 1 1 "")
 );defun
 (defun blk_off(bn / blkset erase_blk)
      (setq blkset (ssget "x" (list (cons 0 "INSERT")(cons 2 bn))))
      (if (/= blkset nil)
	  (if (= (sslength blkset) 1)
	      (progn
                   (setq erase_blk (ssname blkset 0))
                   ;(command "explode"  explode_blk "")
                   (command "erase" erase_blk "")
                   ;(command "purge" "B" bn "N")
                   ;(command "-insert" bn '(0 0 0) 1 1 "")
              );progn
	      (progn
		   (alert "\n多個零件共用一個 BLOCK 名稱")
	      );progn
	  );if
       );if	
 );defun  
     



;(defun init_finish&hideblk(in_fi / mm  source_state_group_on_240 source_state_asm_off_240 non_inp_set_240);in_fi:init_finish
(defun init_finish&hideblk(in_fi / mm    );in_fi:init_finish  
    
     
  
     (cond (;|init|;
	      (= (strcase in_fi) "INIT")
	      (foreach mm #on_blk_list
                     (blk_off mm)
              );foreach
              (foreach mm #off_blk_list
                     (blk_on mm)
              );foreach
	    );init
	   (;|finish|;
	     (= (strcase in_fi) "FINISH")
             (foreach mm #on_blk_list
                     (blk_on mm)
              );foreach
              (foreach mm #off_blk_list
                     (blk_off mm)
              );foreach
	   
	  );finish
       );COND
 );defun


 ;defun 
  (defun string_search&hideblk(string search_s / prt flag string_len search_s_len find_s)
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

(defun selectpro(/ select_list mm mult_sel)
     (setq select_list nil)
     (if (/= #group_list nil)
         (progn
              (setq mult_sel (read (strcat "(" (get_tile "c_list") ")")))
	      (foreach mm mult_sel
		     (setq select_list (append select_list (list (nth mm #group_list))))
	      );foreach
	 );progn
      );if
      select_list
  );defun  

  (defun remove_one&hideblk (li obj / i ret_list nthdata)
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

 (defun string_subst&hideblk(rep_s search_s string  / prt flag string_len search_s_len find_s)
      (if (and (/= string "")
  	       (/= search_s "")
	       (/= string nil)
	       (/= search_s nil)
	  );and
          (progn
               (setq prt 1)
	       (setq retstr "")
               (setq flag nil)
	       (setq string_len (strlen string))
               (setq search_s_len (strlen search_s))
               (while (/= (setq find_s (substr string prt search_s_len)) "")
	            (if (=  find_s search_s)
		        (setq find_s rep_s)  
	            );if
		    (setq retstr (strcat retstr find_s))
	            (setq prt (1+ prt))
	       );while
	  );progn
          (progn
	       (setq flag nil)
	  );progn
     );if
     retstr
);defun

(defun vgetfile_val&hideblk(fname initxt / ff  needdata data txtid objdata dd)
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


 

 