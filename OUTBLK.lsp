;;;
;;;┌────────────────────────────────┐
;;;│  程  式 :desinger版                                            │
;;;│  主程式 :outblk                                                │
;;;│  日  期 :89.2.14                                               │
;;;│  姓  名 :jacky                                                 │
;;;│  對話框 :                                                      │
;;;│  方  法 :                                                      │
;;;│  相關檔案:sub numList                                          │
;;;└────────────────────────────────┘




(defun c:outblk(/  #path_dcl    #sepcode       #nonpart      #on_layer
		   #group_list  #ungroup_list
		   #sel_list    #Lsp_draw_sel     #all_blk_list   #on_blk_list   #off_blk_list
		   #all_blk_list_g  #on_blk_list_g    #off_blk_list_g #all_blk_list_set
		   #on_blk_list_set #off_blk_list_set #all_blk_sslist #on_blk_sslist
		   #off_blk_sslist
		   dcL_id         oker             #all_group        #non_inp_set
		                       
		        
		);c:outblk
   
     (if (= (ssget "x") nil)
         (progn
              (alert "圖面無資料")
              (exit)
         );progn
     );if	             
     (setvar "cmdecho" 0)
     (setq #path_dcl Powdesign_DCL_PATH)
      
     (setq #sepcode   (vgetfile_val&outblk (strcat powdesign_PATH "system.ini") "分隔碼 (零件名稱與視圖代號間)"))
     (setq #nonpart   (vgetfile_val&outblk (strcat powdesign_PATH "system.ini") "自動拆圖時不拆之圖層"))
     (setq #on_layer  (vgetfile_val&outblk (strcat powdesign_PATH "system.ini") "零件 (BLOCK) 繪圖層"))
  
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
     ;(setq #sepcode   (car (read #sepcode)))
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

  
     (setq #group_list nil)
     (setq #sel_list nil)
     (setq #Lsp_draw_sel "1")
  
     (setq #all_blk_list nil)
     (setq #on_blk_list  nil)
     (setq #off_blk_list nil)
  
     (setq #all_blk_list_g nil)
     (setq #on_blk_list_g  nil)
     (setq #off_blk_list_g nil)
  
     (setq #all_blk_list_set nil)
     (setq #on_blk_list_set  nil)
     (setq #off_blk_list_set nil)
  
     (setq #all_blk_sslist nil)
     (setq #on_blk_sslist  nil)
     (setq #off_blk_sslist nil)
     
  
     (coLL_block&outblk)
     (setq #group_list #all_blk_list_g)
     (setq #ungroup_list nil)
     ;(setq #all_group (coLL_block&outblk))
        
     (actdcl (strcat #path_dcl "outblk") "outblk")
     (subsys_draw_sel&outblk)
     (set_tile "dpartpath" (getvar "dwgprefix"))
     (action_tile "dsubasm"  "(mode_sub)")
     (action_tile "dpart"    "(mode_pout)")
     (action_tile "dauto"     "(subsys_draw_sel&outblk)")
    ; (action_tile "c_list"  "(setq #sel_list (selectpro))")
     (action_tile "nondcodeok" "(nondcodeok_pro)")
     (action_tile "dcodeok" "(dcodeok_pro)")
     (action_tile "draw_sel" "(subsys_draw_sel&outblk)")
     (action_tile "add"      "(part_add&outblk)")
     (action_tile "del"      "(part_del&outblk)")
     (action_tile "accept"   "(setq oker 1)(get_tilevalue)(done_dialog)")
     (action_tile "cancel"   "(done_dialog)(unload_dialog dcL_id)(setq oker 0)")
     (start_dialog)
    
     (if (= oker 1)
         (progn
              (outblk_ok&outblk)
	     
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

 
  
(defun coll_block&outblk(/    yesno   #asm_set      nonpart_set  nonpart_set_i nonpart_ent
			      flag    blkdata_list  blkname      offblkset     all_ssname
			      blkset  blkent        blkent_list  i s_num       blkname_off s_num_off mm
			   )
     (initget "Yes No")
     (setq yesno (getkword  "\n次組合部份是否要拆圖? [是(Y)/否(N)] <N>:"))
     
     (if (or (= yesno nil) (= yesno "No"))
         (progn
             (setq #all_blk_list_set (ssget "X" (list (cons 0 "insert")  (cons 2  (strcat "*" #sepcode "*")))))
	 );progn
         (progn
	      (setq #all_blk_list_set (ssget "X" (list (cons 0 "insert")  (cons 2  (strcat "*" #sepcode "*")))))
	      (setq #asm_set          (ssget "X" (list (cons 0 "insert")  (list -3 (list "SUB")) )))
	      (if (and (/= #all_blk_list_set nil)
		       (/= #asm_set          nil)
		  );and
		  (progn
	               (command "select" #all_blk_list_set  #asm_set "")
                       (setq #all_blk_list_set (ssget "p"))
		  );progn
		  (progn
		       (if (= #all_blk_list_set nil)
			   (setq #all_blk_list_set #asm_set)
		       );if
		  );progn
	       );if	
	 );progn
     );if  
	   
     	     
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
		
		    (setq s_num (string_search&outblk blkname #sepcode))
		    (if (/= s_num nil)
		        (setq blkname (strcase (substr blkname 1 (1- s_num))))
		        (setq blkname (strcat "<.SUB.>" blkname))
		    );if  
		    (if (= (member blkname #all_blk_list_g) nil)
                        (setq #all_blk_list_g (append #all_blk_list_g (list blkname)))
		    );if
		    (setq #all_blk_list_set_i (1+ #all_blk_list_set_i))
              );while
	     
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
          
              (setq i 0)
              (if (/= offblkset nil)
                  (progn
                       (while (/= (setq blkent (ssname offblkset i)) nil)
			    (ssdel blkent #on_blk_list_set)
                            (setq blkent_list (entget blkent))
			    (setq blkname_off (cdr (assoc 2 blkent_list)))
			    (setq #off_blk_list (append #off_blk_list (list blkname_off)))
			 
		            (setq s_num_off (string_search&outblk blkname_off #sepcode))
		            (setq blkname_off (strcase (substr blkname_off 1 (1- s_num_off))))
			    (if (= (member blkname_off  #off_blk_list_g) nil)
                                (setq #off_blk_list_g (append #off_blk_list_g (list blkname_off)))
			    );if  
                            (setq i (1+ i))
                       );while
		       
		       (foreach mm #off_blk_list
			      (setq #on_blk_list (remove_one&outblk #on_blk_list mm))
			                   
                       );foreach
		    
		        (foreach mm #off_blk_list_g
			      (setq #on_blk_list_g (remove_one&outblk #on_blk_list_g mm))
			                          
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

  (defun subsys_draw_sel&outblk()
         
         (if (= (get_tile "draw_sel") "1")
	     (progn
                  ;(mode_3&outblk)
	          (mode_draw_sel)
	          ;(mode_tile "c_list" 1)
	          (setq #Lsp_draw_sel "1")
	     );progn
	     (progn
                  ;(mode_4&outblk)
	          ;(mode_tile "c_list" 0)
	          (mode_auto)
	          (setq #Lsp_draw_sel "0")
	          (if (/= #group_list nil)
	              (setq #group_list (acad_strlsort #group_list))
		  );if
	          (start_List "c_list" 3)
	          (mapcar 'add_list #group_list)
                  (end_list)
	         
	
	     );progn  
         );if  
  );defu


;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  main function  area                           │
;;;│                                                                │
;;;└───────────────────────────────┘
(defun get_tilevalue()
     (setq #dpartpath_v (get_tile "dpartpath"))
     (setq #precode_v   (get_tile "precode"))
     (setq #backcode_v   (get_tile "backcode"))
);defun  
     

                                   ; or_num_w is order number written
 (defun outblk_ok&outblk  (/   non_insert_set  partdata_list  parttemp_list countPart p_list    entdata_list mm 3_view_set
                               3_view_i       3_entname      3_view_list
			       out_dwgpath    out_dwgname s_num explode_set insp outent base_ent explode_ent explode_ent1
			       dpartpath_len dpartpath_char lalst stime etime tsec tmin min_v sec mm1 mm_i
			       yesno yesno1 s_num1 explode_ent_g explode_sub_set explode_ent_list keepv_yn status_keep
			       explode_ent_list
			       
			     )
 
     

      (setq regen_v (getvar "regenmode"))
      (setvar "regenmode" 0)
      (command "zoom" "e")
      (setq partdata_list nil)
      (setq parttemp_list nil)
      (setq countPart 0)
      (cond (
	       (= #Lsp_draw_sel "0")
	       (setq #sel_list #group_list)
	       (foreach mm #sel_list
		    (if (= (strcase (substr mm 1 7)) "<.SUB.>")
		        (progn
			     (setq mm (strcase (substr mm 8)))
			     (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 mm))))
			);progn
		        (progn    
		  	     (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm  #sepcode "*")))))
			);progn
		    );if  
		    (setq 3_view_list (append 3_view_list (list 3_view_set)))
	       );foreach 	 
	       (setq partdata_list 3_view_list) 
	    )
	    (
               (= #Lsp_draw_sel "1")
	       (setq partdata_list (loop_sel&outblk))
	     
	    )
	    (t
	      (alert "#Lsp_draw_sel無值!")
	      (exit)
	    )
       );cond
       (setq dpartpath_len (strlen #dpartpath_v))
       (setq dpartpath_char (substr #dpartpath_v dpartpath_len 1))
       (if (and (/= dpartpath_char "\\")
	        (/= dpartpath_char "/")
	   );or    
           (setq out_dwgpath (strcat #dpartpath_v "\\"))
	   (setq out_dwgpath #dpartpath_v)
       );if
       
       
       (setq insp (getpoint "\n插入點: "))
       (princ "\n拆圖進行中......")
       (setq lalst (length partdata_list))
       (setq stime (getvar "cdate"))
       (setq status_keep nil)
       (foreach mm partdata_list
	    (command "undo" "M")
	    (if (/= mm  nil)
	        (progn
	            (setq 3_entname (ssname mm 0))
	            
	            (setq out_dwgname (cdr (assoc 2 (entget 3_entname))))
	            (setq s_num (string_search&outblk out_dwgname #sepcode))
		    (if (/= s_num nil)
		        (progn
	                    (setq out_dwgname (substr out_dwgname 1 (1- s_num)))
		            (setq mm (ssget "x" (list (cons 0 "insert")(cons 2 (strcat out_dwgname #sepcode "*")))))
			);progn
		        (progn
			     (setq mm (ssget "x" (list (cons 0 "insert")(cons 2 out_dwgname ))))
			     (if (/= status_keep t)
			         (progn
			              (initget "Yes No")
                                      (setq yesno1    (getkword  "\n次組合部份是否爆炸(explode)拆出零件圖? [是(Y)/否(N)] <N>:  <計時中...>"))
				      (initget "Yes No")
				      (setq keepv_yn  (getkword  "\n是否將上一提示取消, 並保持其設定值?    [是(Y)/否(N)] <Y>:  <計時中...>"))
				      (if (or (= keepv_yn nil)
					      (= keepv_yn "Yes")
					  );or
					  (setq status_keep t)
				      );if
				 );progn
			       );if
			    
				      
                             (if  (= yesno1 "Yes")
			          (progn
			               (setq explode_sub_set (ssadd))
		                       (setq mm_i 0)
				       (setq explode_ent_g nil)
				       (setq explode_ent_list nil)
		                       (while (setq mm1 (ssname mm mm_i))
					    ;(command "undo" "M")
		                            (setq base_ent (entlast))
	                                    (command "explode" mm1)
		                            (while (/= (setq explode_ent1 (entnext base_ent)) nil)
					         (setq explode_ent explode_ent1)
					         (setq explode_ent (cdr (assoc 2 (entget explode_ent))))
					         (setq s_num1 (string_search&outblk explode_ent #sepcode))
					         (setq explode_ent (substr explode_ent 1 (1- s_num1)))
					         (if (= (member (strcase explode_ent) explode_ent_g) nil)
			                             (progn
				                         (setq explode_ent_g (append explode_ent_g (list explode_ent)))
				                        ; (if (/= s_num nil)
			                                 (setq explode_ent_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat explode_ent #sepcode "*")))))
				                         ;    (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2  mm ))))
				                        ; );if
						         ;(ssadd explode_ent_set explode_sub_set)  
			                                 (setq explode_ent_list (append explode_ent_list (list explode_ent_set)))
			                              );progn
			                         );if
		                                 ;(ssadd explode_ent_list explode_sub_set)
		                                 (setq base_ent explode_ent1)
		                            );while
		                            (setq mm_i (1+ mm_i))
					    ;(command "undo" "b")
		                        );while
				        (sub_take_apart&outblk explode_ent_list)
				        (setq mm nil)
			                
				  );progn
			     );if  
			 );progn
		    );if  
		    (setq out_dwgname (strcat out_dwgpath   #precode_v out_dwgname #backcode_v))
		    (if (/= mm nil)
		        (progn
			        
		            (setq explode_set (ssadd))
		            (setq mm_i 0)
		            (while (setq mm1 (ssname mm mm_i))
		                 (setq base_ent (entlast))
	                         (command "explode" mm1)
		                 (while (/= (setq explode_ent (entnext base_ent)) nil)
		                     (ssadd explode_ent explode_set)
		                     (setq base_ent explode_ent)
		                 );while
		                 (setq mm_i (1+ mm_i))
		            );while  
		            
	                   (if (findfile (strcat out_dwgname ".dwg"))
                               (progn
				    
                                    (princ (strcat out_dwgname ".DWG 已經存在 !!"))
                                    (setq yesno (strcase (getstring "\n是否要將該檔覆蓋<Y>: ")))
                                    (if (or (= yesno "") (= yesno "Y"))
                                      (progn
                                     ;(setq insp (getpoint "\n插入點: "))
                                           (command "wblock" out_dwgname "y" "" insp explode_set "")
				           ;(princ "    完成!")
                                      );progn
                                    );if
                               );progn
                               (progn
                            ;(setq insp (getpoint "\n插入點: "))
                                    (command "wblock" out_dwgname "" insp explode_set "")
                                    ;(princ "    完成!")
                              );progn
                          );if
			  (princ (strcat "\n零件拆出成 " (strcase out_dwgname) ".DWG............" (rtos (setq countPart (1+ countPart)) 2 0) "/" (rtos  lalst 2 0) "\n"))
			   
		         
			  
			  
			  
			);progn
		     );if 
                    
		);progn
	    );if  
            (command "undo" "b")   
       );forech
       (setq etime (getvar "cdate"))
       (setq tsec (howtime stime etime))
       (setq tmin (/ tsec 60))
       (setq tsec (- tsec (* tmin 60)))
       (princ (strcat "\n自動拆出 " (rtos lalst 2 0) " 個零件共費時 " (rtos tmin 2 0) " 分" (rtos tsec 2 0) " 秒!"))
       (setq tsec (* 50 lalst))
       (setq min_v (/ tsec 60))
       (setq sec (- tsec (* min_v 60)))
       (princ (strcat "\n傳統手動拆一個零件約需 50 秒," (rtos lalst 2 0) " 個零件共需費時 " (rtos min_v 2 0)
                  " 分" (rtos sec 2 0) " 秒!"))
       (princ "    完成!")
       (setvar "regenmode" regen_v)
 );defun  
              
       
 

  
;;;┌────────────────────────────────┐
;;;│                                                                │
;;;│                  library function area                         │
;;;│                                                                │
;;;└────────────────────────────────┘

(defun sub_take_apart&outblk(partdata_list / mm&t 3_entname&t out_dwgname&t 3_entname&t s_num out_dwgpath
			                     explode_set mm_i mm1 base_ent explode_ent yesno
			    )
     (setq out_dwgpath #dpartpath_v)
     (setq s_num nil)
     (setq lalst (1- (+ lalst (length partdata_list))))
     (foreach mm&t partdata_list
	    ;(command "undo" "M")
            (if (/= mm&t  nil)
	        (progn
	            (setq 3_entname&t (ssname mm&t 0))
	            (setq out_dwgname&t (cdr (assoc 2 (entget 3_entname&t))))
		    (setq s_num (string_search&outblk out_dwgname&t #sepcode))
		   
		    (if (/= s_num nil)
		        (progn
	                    (setq out_dwgname&t (substr out_dwgname&t 1 (1- s_num)))
		            (setq mm&t (ssget "x" (list (cons 0 "insert")(cons 2 (strcat out_dwgname&t #sepcode "*")))))
			);progn
		       
		    );if  
		    (setq out_dwgname&t (strcat out_dwgpath   #precode_v out_dwgname&t #backcode_v))
		    (if (/= mm&t nil)
		        (progn
			        
		            (setq explode_set (ssadd))
		            (setq mm_i 0)
		            (while (setq mm1 (ssname mm&t mm_i))
		                 (setq base_ent (entlast))
	                         (command "explode" mm1)
		                 (while (/= (setq explode_ent (entnext base_ent)) nil)
		                     (ssadd explode_ent explode_set)
		                     (setq base_ent explode_ent)
		                 );while
		                 (setq mm_i (1+ mm_i))
		            );while  
		            
	                   (if (findfile (strcat out_dwgname&t ".dwg"))
                               (progn
				    
                                    (princ (strcat out_dwgname&t ".DWG 已經存在 !!"))
                                    (setq yesno (strcase (getstring "\n是否要將該檔覆蓋<Y>: ")))
                                    (if (or (= yesno "") (= yesno "Y"))
                                      (progn
                                     ;(setq insp (getpoint "\n插入點: "))
                                           (command "wblock" out_dwgname&t "y" "" insp explode_set "")
				           ;(princ "    完成!")
                                      );progn
                                    );if
                               );progn
                               (progn
                            ;(setq insp (getpoint "\n插入點: "))
                                    (command "wblock" out_dwgname&t "" insp explode_set "")
                                    ;(princ "    完成!")
                              );progn
                          );if
			  (princ (strcat "\n次組合零件拆出成 " (strcase out_dwgname&t) ".DWG............" (rtos (setq countPart (1+ countPart)) 2 0) "/" (rtos  lalst 2 0) "\n"))
			   
		         
			  
			  
			  
			);progn
		     );if
		   
		);progn
	    );if  
           ; (command "undo" "b")   
       );foreach
);defun  
 
 
(defun loop_sel&outblk(/       ent blk_list entname  blkname2 entname_list mm sel_mode w_i 3_view_list 3_view_set 3_view_i s_num 3_entname 3_view_list_g)
       ;(init_finish&outblk "init")
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
				    ; (if (/= (string_search&outblk blkname2 #sepcode)  nil)
				    (setq blk_list  (cons (strcase blkname2) blk_list))
				    ;    (alert "\n不具零件名稱之圖塊 (BLOCK)!")
				    ;);if
                                    ;(setq blk_list  (cons (strcase blkname2) blk_list))
                                 );progn
                               );if
                          );progn
                      );while
		      (setq 3_view_list nil)
		      (setq 3_view_set nil)
		      (setq 3_view_list_g nil)
		      (foreach mm blk_list
			   (setq s_num (string_search&outblk mm #sepcode))
			   (if (/= s_num nil)
			       (setq mm (substr mm 1 (1- s_num)))
			   );if  
			   (if (= (member (strcase mm) 3_view_list_g) nil)
			       (progn
				    (setq 3_view_list_g (append 3_view_list_g (list mm)))
				    (if (/= s_num nil)
			                (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm #sepcode "*")))))
				        (setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2  mm ))))
				    );if  
			            (setq 3_view_list (append 3_view_list (list 3_view_set)))
			       );progn
			   );if
			   ;(setq 3_view_set (ssget "x" (list (cons 0 "INSERT")(cons 2 (strcat mm #sepcode "*")))))
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
                      ;(init_finish&outblk "finish")
                      blk_list
                );progn
	     );1
	     (;|2|;(= sel_mode 2)
	           (progn
		        (setq grpname_data nil)
		        ;(setq entlist '())
		        (setq grpname_data (getstring "\n請輸入前置碼 (可用逗號隔開 如 s*,motor*,tablet*):  "))
		        (setq grpname_data (strcat "(\"" grpname_data "\")"))
		        (while (/= (string_search&outblk  grpname_data  ",") nil)
		               (setq grpname_data (string_subst&outblk "\"  \""  "," grpname_data))
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
		        ;(init_finish&outblk "finish")
		        blk_list
		   );progn
	     );2
	);cond     
);defun loop_sel&outblk



 (defun *error* (msg)
       (princ)
 );defun



(defun blk_on(bn);bn:blkname ip:information point
    (if (/= bn nil)
        (command "change" bn "" "P" "LA" #on_layer "")
    );if  
);defun
 (defun blk_off(bn)
     (if (/= bn nil)
         (command "change" bn "" "P" "LA" #off_layer "")
     );if  
 );defun  
     






 
  (defun string_search&outblk(string search_s / prt flag string_len search_s_len find_s)
     (setq retprt nil)
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

  (defun remove_one&outblk (li obj / i ret_list nthdata)
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

 (defun string_subst&outblk(rep_s search_s string  / prt flag string_len search_s_len find_s)
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

(defun vgetfile_val&outblk(fname initxt / ff  needdata data txtid objdata dd)
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


 (defun mode_sub()
     (set_tile "dsubasm"    "1")
     (mode_tile "subasmpath" 0)
     (set_tile "dpart"      "0")
     (mode_tile "dauto"      1)
     (mode_tile "draw_sel"   1)
     (mode_tile "dpartpath"  1)
     (mode_tile "precode"    1)
     (mode_tile "backcode"   1)
     (mode_tile "nondcode"   1)
     (mode_tile "nondcodeok" 1)
     (mode_tile "dcode"   1)
     (mode_tile "dcodeok" 1)
     (mode_tile "c_list"     1)
     (mode_tile "add"        1)
     (mode_tile "del"        1)
     (mode_tile "non_list"   1)
 );defun

 (defun mode_pout()
     (set_tile  "dsubasm"    "0")
     (mode_tile "subasmpath" 1)
     (set_tile  "dpart"      "1")
     (mode_tile "dauto"      0)
     (mode_tile "draw_sel"   0)
     (mode_tile "dpartpath"  0)
     (mode_tile "precode"    0)
     (mode_tile "backcode"   0)
     (mode_tile "nondcode"   0)
     (mode_tile "nondcodeok" 0)
     (mode_tile "dcode"   0)
     (mode_tile "dcodeok" 0)
     (mode_tile "c_list"     0)
     (mode_tile "add"        0)
     (mode_tile "del"        0)
     (mode_tile "non_list"   0)
 );defun

(defun mode_auto()
     (mode_tile "dsubasm"    0)
     (mode_tile "subasmpath" 1)
     (mode_tile "dpart"      0)
     (mode_tile "dauto"      0)
     (mode_tile "draw_sel"   0)
     (mode_tile "dpartpath"  0)
     (mode_tile "precode"    0)
     (mode_tile "backcode"   0)
     (mode_tile "nondcode"   0)
     (mode_tile "nondcodeok" 0)
     (mode_tile "dcode"   0)
     (mode_tile "dcodeok" 0)
     (mode_tile "c_list"     0)
     (mode_tile "add"        0)
     (mode_tile "del"        0)
     (mode_tile "non_list"   0)
 );defun

(defun mode_draw_sel()
     (mode_tile "dsubasm"    0)
     (mode_tile "subasmpath" 1)
     (mode_tile "dpart"      0)
     (mode_tile "dauto"      0)
     (mode_tile "draw_sel"   0)
     (mode_tile "dpartpath"  0)
     (mode_tile "precode"    0)
     (mode_tile "backcode"   0)
     (mode_tile "nondcode"   1)
     (mode_tile "nondcodeok" 1)
     (mode_tile "dcode"   1)
     (mode_tile "dcodeok" 1)
     (mode_tile "c_list"     1)
     (mode_tile "add"        1)
     (mode_tile "del"        1)
     (mode_tile "non_list"   1)
 );defun


(defun part_add&outblk (/ p_list_msel    p_list_mp   group_list_nth    e1        e2
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
                           (setq groupmanage_retval (groupmanage&outblk  group_list_nth #group_list ".>>."  #ungroup_list))
                           (setq #group_list   (car groupmanage_retval))
                           (setq #ungroup_list (cadr groupmanage_retval))
                         
                  );foreach
                  (start_List "c_list" 3)
                  (mapcar 'add_list #group_list)
                  (end_list)
                  (start_List "non_list" 3)
                  (mapcar 'add_list #ungroup_list)
                  (end_list)
              );progn
           );if
    );defun


(defun part_deL&outblk (/ j_list_msel   j_list_mp   ungroup_list_nth   e1        e2
                             num1          num2        all_len1           all_len2  
                             ungroup_list_temp         groupmanage_retval
                           )
          (setq j_list_Msel (get_tile "non_list"))
          (if (/= j_list_msel nil)
              (progn
                   (setq ungroup_list_temp #ungroup_list)
                   (setq j_list_Msel (read (strcat "(" j_List_msel ")")))
                   (foreach j_list_mp j_list_msel
                          (setq ungroup_list_nth (nth   j_list_mp ungroup_list_temp))
                          (setq groupmanage_retval (groupmanage&outblk  ungroup_list_nth #group_list ".<<." #ungroup_list))
                          (setq #group_list   (car groupmanage_retval))
                          (setq #ungroup_list (cadr groupmanage_retval))
                   );foreach
                   (start_List "c_list" 3)
                   (mapcar 'add_list #group_list)
                   (end_list)
                   (start_List "non_list" 3)
                   (mapcar 'add_list #ungroup_list)
                   (end_list)
              );progn
          );if  
    );defun


(defun groupmanage&outblk(  element grp_list  action_type Ungrp_list )
     (setq action_type (strcase action_type))
     (setq element (strcase element))
     (cond (;|add|; (= action_type ".>>.")
                    (setq grp_list (remove_one&outblk grp_list element  ))
                    (setq Ungrp_list (append Ungrp_list (list  element)))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
                    
            
           );add
           (;|del|; (= action_type ".<<.")
                    (setq grp_list (append grp_list (list  element)))
                    (setq Ungrp_list (remove_one&outblk  Ungrp_list element))
                    (setq grp_list (acad_strlsortp grp_list))
                    (setq Ungrp_list (acad_strlsortp Ungrp_list))
                    (list grp_list Ungrp_list)
           );del
     );cond
 );defun

(defun acad_strlsortp(sortlist / )
     (if (/= sortlist nil)
         (setq sortlist (acad_strlsort sortlist))
     );if
     sortlist
);defun

(defun nondcodeok_pro(/ nondcode_v slen temp_group_list mm )
     (setq nondcode_v (getrealstr2 (getrealstr (get_tile "nondcode"))))
     (setq slen (strlen nondcode_v))
     (if (/= nondcode_v "")
         (progn
	     (setq temp_group_list #group_list)
	     (foreach  mm  temp_group_list
	          (if (= (strcase nondcode_v) (strcase (substr mm  1 slen)))
		      (progn
			   (setq #group_list (remove_one&outblk #group_list mm  ))
                           (setq #Ungroup_list (append #Ungroup_list (list  mm)))
		      );progn
		  );if
	     );foreach
	  );progn
     );if  
     (setq #group_list (acad_strlsortp #group_list))
     (setq #Ungroup_list (acad_strlsortp #Ungroup_list))
     (start_List "c_list" 3)
     (mapcar 'add_list #group_list)
     (end_list)
     (start_List "non_list" 3)
     (mapcar 'add_list #Ungroup_list)
     (end_list)
  );defun


(defun dcodeok_pro(/ dcode_v slen temp_group_list mm )
     (setq dcode_v (getrealstr2 (getrealstr (get_tile "dcode"))))
     (setq slen (strlen dcode_v))
     (if (/= dcode_v "")
         (progn
	     (setq temp_group_list #ungroup_list)
	     (foreach  mm  temp_group_list
	          (if (= (strcase dcode_v) (strcase (substr mm  1 slen)))
		      (progn
			   (setq #ungroup_list (remove_one&outblk #ungroup_list mm  ))
                           (setq #group_list (append #group_list (list  mm)))
		      );progn
		  );if
	     );foreach
	  );progn
     );if  
     (setq #ungroup_list (acad_strlsortp #ungroup_list))
     (setq #group_list (acad_strlsortp #group_list))
     (start_List "c_list" 3)
     (mapcar 'add_list #group_list)
     (end_list)
     (start_List "non_list" 3)
     (mapcar 'add_list #ungroup_list)
     (end_list)
  );defun

  (defun howtime(st et / st stt sthour stmin stsec et ett ethour etmin etsec ttime)
       (setq st     (rtos st 2 10)
             stt    (substr st (1+ (get_word st ".")))
             sthour (* 60 60 (atoi (substr stt 1 2)))
             stmin  (* 60 (atoi (substr stt 3 2)))
             stsec  (atoi  (substr stt 5 2)))
       (setq et     (rtos et 2 10)
             ett    (substr et (1+ (get_word et ".")))
             ethour (* 60 60 (atoi (substr ett 1 2)))
             etmin  (* 60 (atoi (substr ett 3 2)))
             etsec  (atoi (substr ett 5 2)))
       (setq ttime (- (+ ethour etmin etsec) (+ sthour stmin stsec)))
       ttime
  );defun
     