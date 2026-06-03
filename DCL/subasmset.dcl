subsys:dialog {
                  label = "次組合建立";
                  initial_focus="sub_name";
                  :row{
                  
                       :edit_box    {
                                         label = "次組合名稱";
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
                                      label = "一般零件";
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
                                      label = "組成次組合之零件";
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


   //********************************************************************************************* 

part_cr:dialog {
                  label = "次組合部份新增";
                  initial_focus="sub_name";
                  :row{
                  
                       :popup_list    {
                                         label = "次組合名稱";
                                         key   = "sub_name";
                                         edit_width =16;
                                         //height=6;
                                         //fixed_width = true;
                                         //value = "0";
                                        
                                       }

                       :text   { width=20; }

                   }//row
                   
                   :row{

                         :list_box {
                                                  label = "次組合現有零件";
                                                  key   = "c_list";//current_list
                                                  list  = "";
                                                  width = 15;
                                                  height =12;
                                                  //fixed_width_font = true;
                                                 
                                    }//list_box 
                         :list_box  {
                                      label = "一般零件";
                                      key   = "p_list";
                                     // list  = "a\nb\nc\n";
                                      width = 15;
                                      height = 12;
                                      fixed_width_font = true;
                                      multiple_select = true;
                                    }
                             :column{
                                      :text   { width=6; }
                                      :button   {
                                                   label="加入>>";
                                                   key  ="sub_add";
                                                }
                                      :text   { width=6; }
                                      :button   {
                                                   label="<<還原";
                                                   key  ="sub_del";
                                                }
                                      :text   { width=6; }
                                    }
                          :column   {          
                                      :list_box {
                                                  label = "加入次組合之零件";
                                                  key   = "j_list";
                                                  list  = "";
                                                  width = 15;
                                                  height =12;
                                                  fixed_width_font = true;
                                                  multiple_select = true;
                                                }
                                      
                                    }//column
                                    

                          }//row
                         :row{
                                :toggle{
                                         label="圖選";
                                         key  ="draw_sel";
                                         value="1";
                                       }
                              }        
                          spacer_1;
                          ok_cancel;
                          
                }   //dialog


     //*************************************************************************************

     part_del:dialog {
                  label = "次組合部份解散";
                  initial_focus="sub_name";
                  :row{
                  
                       :popup_list    {
                                         label = "次組合名稱";
                                         key   = "sub_name";
                                         edit_width =16;
                                         //fixed_width = true;
                                         //value = "0";
                                        
                                       }
                       :text   {
                                  width=20;
                               } 

                   }//row
                   :row{
                         :list_box  {
                                      label = "次組合現有零件";
                                      key   = "c_list";
                                     // list  = "a\nb\nc\n";
                                      width = 30;
                                     // height = 10;
                                      fixed_width = true;
                                      multiple_select = true;
                                    }
                             :column{
                                      :text   { width=6; }
                                      :button   {
                                                   label="脫離>>";
                                                   key  ="sub_add";
                                                }
                                      :text   { width=6; }
                                      :button   {
                                                   label="<<還原";
                                                   key  ="sub_del";
                                                }
                                      :text   { width=6; }
                                    }
                                  
                                      :list_box {
                                                  label = "脫離次組合零件";
                                                  key   = "out_list";
                                                  list  = "";
                                                  width = 30;
                                                  height =8;
                                                  fixed_width = true;
                                                  multiple_select = true;
                                                }
                                  

                          }//row
                          :row{
                                :toggle{
                                         label="圖選";
                                         key  ="draw_sel";
                                         value="1";
                                       }
                              }        
                          spacer_1;
                          ok_cancel;
                          
                }   //dialog

   //***********************************************************************************


   sub_remove:dialog {
                  label = "次組合解散";
                 initial_focus="c_list";
                   :row{
                         :list_box  {
                                      label = "次組合";
                                      key   = "c_list";
                                     
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
                                                   label="加入解散>>";
                                                   key  ="sub_add";
                                                }
                                      :row{
                                          }
                                      :button   {
                                                   label="<<還    原";
                                                   key  ="sub_del";
                                                }
                                      :row{
                                          }
                                    }            
                          :list_box {
                                      label = "解散之次組合";
                                      key   = "out_list";
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
                          
                }  //dialog

   //*****************************************************************************************


   sub_on_off:dialog {
                    label = "次組合開關";
                    initial_focus="c_list";
                    :row{
                         :list_box  {
                                      label = "次組合( 開 )";
                                      key   = "c_list";
                                     
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
                                                   label="加入(關)>>";
                                                   key  ="sub_add";
                                                }
                                      :row{
                                          }
                                      :button   {
                                                   label="<<加入(開)";
                                                   key  ="sub_del";
                                                }
                                      :row{
                                          }
                                    }            
                          :list_box {
                                      label = "次組合( 關 )";
                                      key   = "out_list";
                                      list  = "";
                                      width = 30;
                                      height = 10;
                                      fixed_width_font = true;
                                      multiple_select = true;
                                    }


                          }
                       //   :row{
                        //        :toggle{
                         //                label="圖選";
                        //                 key  ="draw_sel";
                        //               }
                        //      }         
                          spacer_1;
                          ok_cancel;
                          
                } //dialog


 //***********************************************************************************************               
