blksubcr:dialog {
                  label = "次組合 （BLOCK） 建立";
                  initial_focus="sub_name";
                  :row{
                  
                       :edit_box    {
                                         label = "次組合（BLOCK）名稱";
                                         key   = "sub_name";
                                         edit_width=16;
                                         value = "";
                                     }
                       :column {  
                   
                               }

                       :text   {
                                  label="             ";               
                               } 
                       :text   {
                                  label="             ";               
                               } 
                             

                      :text   {
                                  label="             ";               
                               } 


                               
                       :text   {
                                  label="             ";               
                               } 
           
                        
                  
                 


                   }//row
                   :row{
                         :list_box  {
                                      label = "一般零件（BLOCK）";
                                      key   = "p_list";
                                     // list  = "a\nb\nc\n";
                                      width = 30;
                                      height = 10;
                                      fixed_width_font = true;
                                      multiple_select = true;
                                    }
                             :column{
                                      :row {
                                           }
                                      :row {
                                           }
                                      :row {
                                           }
                                      :button   {
                                                   label="加入>>";
                                                   key  ="sub_add";
                                                }
                                      :row{
                                          }
                                      :button   {
                                                   label="<<還原";
                                                   key  ="sub_del";
                                                }
                                      :row{
                                          }
                                    }            
                          :list_box {
                                      label = "組成次組合之零件（BLOCK）";
                                      key   = "j_list";
                                      list  = "";
                                      width = 30;
                                      height = 10;
                                      fixed_width_font = true;
                                      multiple_select = true;
                                    }


                          }
                          :row{
                                :toggle{
                                         label="圖選";
                                         key  ="draw_sel";
                                         value="1";
                                       }
                              }         
                          spacer_1;
                          ok_cancel;
                          
                          :text{
                                 fixed_width_font = true;
                                 key= "cue";
                                               
                               }
                           :text{
                                 fixed_width_font = true;
                                 key= "cue1";
                                }      
                          errtile;
                          
                }//dialog
