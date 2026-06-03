;;;
;;;┌────────────────────────────────┐
;;;│  程  式 :desinger版                                            │
;;;│  主程式 :showblk                                               │
;;;│  日  期 :89.2.6                                                │
;;;│  姓  名 :jacky                                                 │
;;;│  對話框 :                                                      │
;;;│  方  法 :                                                      │
;;;│  相關檔案:sub numList                                          │
;;;└────────────────────────────────┘





(defun c:showblk(/
                    sepcode            #nonpart       #onlayer          #offlayer
		    #group_list        #ungroup_list
		    #sel_list          #Lsp_draw_sel   #all_blk_list   #on_blk_list   #off_blk_list
		    #all_blk_list_g  #on_blk_list_g    #off_blk_list_g #all_blk_list_set
		    #on_blk_list_set #off_blk_list_set #all_blk_sslist #on_blk_sslist
		    #off_blk_sslist
		    dcL_id             oker             #all_group        #non_inp_set
		    #partref_group_set len_blance       #LSP_sub_name     #asm_set     
		    
		)
      
   
     (if (= (ssget "x") nil)
        (progn
             (alert "圖面無資料")
             (exit)
        );progn
     );if	             
     (setvar "cmdecho" 0)
     (setq sepcode   (vgetfile_val&showblk (strcat powdesign_PATH "system.ini") "分隔碼 (零件名稱與視圖代號間)"))
     (setq #nonpart  (vgetfile_val&showblk (strcat powdesign_PATH "system.ini") "不建立資訊點的圖層"))
     (setq #on_layer (vgetfile_val&showblk (strcat powdesign_PATH "system.ini") "零件 (BLOCK) 繪圖層"))
  
     (if (and  (/= sepcode nil)
	       (/= (read sepcode) nil)
	 );and      
         (progn
             (setq sepcode   (car (read sepcode)))
	 );progn
         (progn
	      (alert "\n 不合理分隔碼 (零件名稱與視圖代號間)")
	      (exit)
	 );progn
     );if
     (setq #nonpart  (read #nonpart))
     (setq #on_layer (car (read #on_layer)))
   
     (setq old_error *ERROR*)
     (setq *ERROR* error&showblk)
     (command "undo" "m")
     
     (setq #off_layer "hide_block_layer")
     (if (= (tblobjname "layer" #on_layer) nil)
         (command "-layer" "m" #on_layer "" )
     );if  
     (if (= (tblobjname "layer" #off_layer) nil)
         (command "-layer" "m" #off_layer "" )
     );if
     (command "-layer"  "t" #on_layer "s" #on_layer "")
     (command "-layer"  "off" #off_layer "f" #off_layer "")
     
     
     
  
     (setq #path_dcl Powdesign_DCL_PATH)
     (setq #group_list nil)
     (setq #sel_list nil)
     (setq #Lsp_draw_sel "1")
  
     (setq #all_blk_list nil)
     (setq #on_blk_list  nil)
     (setq #off_blk_list nil)

     (setq #all_blk_list_set nil)
     (setq #on_blk_list_set  nil)
     (setq #off_blk_list_set nil)
  
     (setq #all_blk_sslist nil)
     (setq #on_blk_sslist  nil)
     (setq #off_blk_sslist nil)
  
     (setq #all_blk_list_g nil);g:group
     (setq #on_blk_list_g  nil)
     (setq #off_blk_list_g nil)

     (setq #asm_set nil)
     (coLL_block&showblk)
     (setq #group_list #off_blk_list_g) 
     ;(setq #all_group (coLL_block&showblk))
        
     (actdcl (strcat #path_dcl "showblk") "showblk")
     (action_tile "c_list"  "(setq #sel_list (selectpro))")
     (action_tile "draw_sel" "(subsys_draw_sel&showblk)")
     (action_tile "accept" "(setq oker 1)(done_dialog)")
     (action_tile "cancel" "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
     (start_dialog)
    
     (if (= oker 1)
         (progn
              (showblk_ok&showblk)
	     
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

  (defun coll_block&showblk(/ nonpart_set nonpart_set_i nonpart_ent
			      flag        blkdata_list  blkname offblkset all_ssname
			      blkset  blkent blkent_list  i s_num  blkname_off s_num_off mm
			   )
     ;(setq #all_blk_list_set (ssget "x" (list (cons 0 "INSERT"))))
     (setq #asm_set                  (ssget "X" (list (cons 0 "insert") (list -3 (list "SUB")) )))
     (setq #all_blk_list_set (ssget "X" (list (cons 0 "insert")  (cons 2  (strcat "*" sepcode "*")))))
     (if (and (/= #all_blk_list_set nil)
	      (/= (sslength #all_blk_list_set) 0)
	 );and
         (progn
             (foreach mm #nonpart
                 (setq nonpart_set (ssget "x" (list (cons 0 "INSERT")(cons 8 mm))))
                 (setq nonpart_set_i 0)
                 (while (and (/= nonpart_set nil)
		             (/= (setq nonpart_ent (ssname nonpart_set nonpart_set_i)) nil)
		        );and
	              (ssdel  nonpart_ent #all_blk_list_set)
	              (setq nonpart_set_i (1+ nonpart_set_i))
	         );while
             );foreach
	     (if (/= #all_blk_list_set nil)
                 (setq #all_blk_sslist (list #all_blk_list_set))
	     );if  
	 );progn
     );if  
     (if (and (/= #all_blk_list_set nil)
	      (/= (sslength #all_blk_list_set) 0)
	 );and
         (progn
	      (setq #all_blk_list_set_i 0)
              (while  (/= (setq all_ssname  (ssname #all_blk_list_set #all_blk_list_set_i)) nil)
		          
	            (setq blkdata_list (entget  all_ssname))
			  
		    (setq blkname (cdr (assoc 2 blkdata_list)))
		    (setq #all_blk_list (append #all_blk_list (list blkname)))
		
		    (setq s_num (string_search&showblk blkname sepcode))
		    (setq blkname (strcase (substr blkname 1 (1- s_num))))
		    (if (= (member blkname #all_blk_list_g) nil)
                        (setq #all_blk_list_g (append #all_blk_list_g (list blkname)))
		    );if
		    (setq #all_blk_list_set_i (1+ #all_blk_list_set_i))
              );while
	      ;(foreach mm #all_blk_list_g
;		    (setq mm (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm "*")))))
;		    (setq #all_blk_list_set (append #all_blk_list_set (list mm)))
;	      );foreach
	      (setq #on_blk_list #all_blk_list)
	      (setq #on_blk_list_g #all_blk_list_g)
	   
	      (setq #on_blk_list_set #all_blk_list_set)
	      (if (/= #on_blk_list_set nil)
		  (setq #on_blk_sslist (list #on_blk_list_set))
	      );if
	   
	      (setq offblkset (ssget "x" (list (cons 0 "INSERT")(cons 8 #off_layer))))
	   
	      (setq #off_blk_list_set offblkset)
	      (if (/= #off_blk_list_set nil)
	          (setq #off_blk_sslist   (list offblkset))
              );if		
              ;(setq blkset (ssget "x" (list (cons 0 "INSERT")(cons 8 #on_layer))))
	      ;(setq #on_blk_list_set blkset)
              (setq i 0)
              (if (/= offblkset nil)
                  (progn
                       (while (/= (setq blkent (ssname offblkset i)) nil)
			    (ssdel blkent #on_blk_list_set)
                            (setq blkent_list (entget blkent))
			    (setq blkname_off (cdr (assoc 2 blkent_list)))
			    (setq #off_blk_list (append #off_blk_list (list blkname_off)))
			 
		            (setq s_num_off (string_search&showblk blkname_off sepcode))
		            (setq blkname_off (strcase (substr blkname_off 1 (1- s_num_off))))
			    (if (= (member blkname_off  #off_blk_list_g) nil)
                                (setq #off_blk_list_g (append #off_blk_list_g (list blkname_off)))
			    );if  
                            (setq i (1+ i))
                       );while
		       
		       (foreach mm #off_blk_list
			      (setq #on_blk_list (remove_one&showblk #on_blk_list mm))
			                   
                       );foreach
		    
		        (foreach mm #off_blk_list_g
			      (setq #on_blk_list_g (remove_one&showblk #on_blk_list_g mm))
			                          
                       );foreach
		       (if (/= #on_blk_list_set nil)
			   (setq #on_blk_sslist (list #on_blk_list_set))
		       );if	 
		      
		       
		       
	          );progn
		  
              );if
	     
	      
	 );progn
         (progn
	      (alert  "\n完全無圖塊(BLOCK) ! ")
	 );progn  
	      
     );if  
        
  );defun
  (defun error&showblk(msg)
     (command "undo" "b")
     (setq *error* old_error)
     (princ)
 )

  (defun subsys_draw_sel&showblk()
         
         (if (= (get_tile "draw_sel") "1")
	     (progn
                  ;(mode_3&showblk)
	          (mode_tile "c_list" 1)
	          (setq #Lsp_draw_sel "1")
	     );progn
	     (progn
                  ;(mode_4&showblk)
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
 (defun showblk_ok&showblk  (/ partdata_list parttemp_list p_list entdata_list mm 3_view_set
			       3_view_i 3_entname 3_view_list

			      )
      (setq partdata_list nil)
      (setq parttemp_list nil)
      (setq 3_view_list   nil)
      (cond (
	       (= #Lsp_draw_sel "0")
	       (init_finish&showblk "init")
	       (foreach mm #sel_list
		    (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm sepcode "*")))))
		    ;(setq 3_view_i 0)
		   ; (while (setq 3_entname (ssname 3_view_set 3_view_i))
		   ;      (setq 3_view_list (append 3_view_list (list (cdr(assoc 2 (entget 3_entname))))))
                    ;     (setq 3_view_i (1+ 3_view_i))
		    ;);while
		    (setq 3_view_list (append 3_view_list (list 3_view_set)))
	       );foreach 	 
	       (init_finish&showblk "finish")	    
	       (setq partdata_list 3_view_list) 
	    )
	    (
               (= #Lsp_draw_sel "1")
	       (setq partdata_list (loop_sel&showblk))
	     
	    )
	    (t
	      (alert "#Lsp_draw_sel無值!")
	      (exit)
	    )
       );cond
       
       (foreach mm partdata_list
              (blk_on mm)
       );forech
 );defun  
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘


  
 
 
(defun loop_sel&showblk(/       ent blk_list entname  blkname2 entname_list mm sel_mode w_i 3_view_list 3_view_set 3_view_i s_num 3_entname 3_view_list_g)
       (init_finish&showblk "init")
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
		      (foreach mm blk_list
			   (setq s_num (string_search&showblk mm sepcode))
			   (setq mm (substr mm 1 (1- s_num)))
			   (if (= (member (strcase mm) 3_view_list_g) nil)
			       (progn
				    (setq 3_view_list_g (append 3_view_list_g (list mm)))
			            (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm sepcode "*")))))
			            (setq 3_view_list (append 3_view_list (list 3_view_set)))
			       );progn
			   );if
			   ;(setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm sepcode "*")))))
			   ;(setq 3_view_i 0)
			   ;(while (setq 3_entname (ssname 3_view_set 3_view_i))
			   ;       (setq 3_view_list (append 3_view_list (list (cdr(assoc 2 (entget 3_entname))))))
                           ;       (setq 3_view_i (1+ 3_view_i))
			   ;);while
			   ;(setq 3_view_list (append 3_view_list (list 3_view_set)))
		      );foreach
		      (setq blk_list 3_view_list)
                      (foreach mm entname_list
	                  (redraw mm 4)
	              );foreach
                      (init_finish&showblk "finish")
                      blk_list
                );progn
	     );1
	     (;|2|;(= sel_mode 2)
	           (progn
		        (setq grpname_data nil)
		        ;(setq entlist '())
		        (setq grpname_data (getstring "\n請輸入前置碼 (可用逗號隔開 如 s*,motor*,tablet*):  "))
		        (setq grpname_data (strcat "(\"" grpname_data "\")"))
		        (while (/= (string_search&showblk  grpname_data  ",") nil)
		               (setq grpname_data (string_subst&showblk "\"  \""  "," grpname_data))
			);while  
		        (setq grpname_data (read grpname_data))
		        (setq blk_list nil)
		        (foreach mm grpname_data
			       (setq grp_set (ssget "x" (list (cons 0 "INSERT")(cons 2 mm))))
			      ; (setq w_i 0);while_i
			      ; (while (/= (setq entname (ssname grp_set w_i)) nil)
	                       ;     (setq blkname2 (cdr (assoc 2 (entget entname))))
			       ;     (setq blk_list  (cons (strcase blkname2) blk_list))
			;	    (setq w_i (1+ w_i))
		               ;);while
			       (setq blk_list  (append  blk_list (list grp_set)))
			);foreach
		        (init_finish&showblk "finish")
		        blk_list
		   );progn
	     );2
	);cond     
);defun loop_sel&showblk



 


(defun blk_on(bn);bn:blkname ip:information point
     ;(command "-insert" bn '(0 0 0) 1 1 "")
     (if (and (/= bn nil)
	      (/= (sslength bn) 0)
	 );and     
         (command "change" bn "" "P" "LA" #on_layer "")
     );if  
);defun
 (defun blk_off(bn )
      ;(setq blkset (ssget "x" (list (cons 0 "INSERT")(cons 2 bn))))
      ;(if (/= blkset nil)
;	  (if (= (sslength blkset) 1)
;	      (progn
 ;                  (setq erase_blk (ssname blkset 0))
  ;                 (command "erase" erase_blk "")
   ;              
    ;          );progn
;	      (progn
;		   (alert "\n多個零件共用一個 BLOCK 名稱")
;	      );progn
;	  );if
 ;      );if
    (if (and (/= bn nil)
	     (/= (sslength bn) 0)
	);and     
        (command "change" bn "" "P" "LA" #off_layer "")
    );if  
 );defun  
     



;(defun init_finish&showblk(in_fi / mm  source_state_group_on_240 source_state_asm_off_240 non_inp_set_240);in_fi:init_finish
(defun init_finish&showblk(in_fi / mm    );in_fi:init_finish  
    
     
  
     (cond (;|init|;
	      (= (strcase in_fi) "INIT")
	      (blk_off #asm_set)
	      (foreach mm #on_blk_sslist
                     (blk_off mm)
              );foreach
              (foreach mm #off_blk_sslist
                     (blk_on mm)
              );foreach
	    );init
	   (;|finish|;
	     (= (strcase in_fi) "FINISH")
	     (blk_on #asm_set)
             (foreach mm #on_blk_sslist
                     (blk_on mm)
              );foreach
              (foreach mm #off_blk_sslist
                     (blk_off mm)
              );foreach
	   
	  );finish
       );COND
 );defun
 
  (defun string_search&showblk(string search_s / prt flag string_len search_s_len find_s)
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

  (defun remove_one&showblk (li obj / i ret_list nthdata)
     (setq i 0)
     (setq ret_list nil)
     (setq nthdata nil)
     (while (/= (setq nthdata (nth i li)) nil)
          (if (/= (strcase nthdata) (strcase obj) )
              (setq ret_list (append ret_list (list nthdata)))
          );if
          (setq i (1+ i))
     );while
     ret_list
 );defun

 (defun string_subst&showblk(rep_s search_s string  / prt flag string_len search_s_len find_s)
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


(defun vgetfile_val&showblk(fname initxt / ff  needdata data txtid objdata dd)
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
      needdata
  
);defun  



 