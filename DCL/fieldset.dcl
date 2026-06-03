 fieldset:dialog {
                  label = "目前資料庫欄位設定值";
                   :row{   
                            
                 
                     
                            :boxed_column{          
                                           :list_box  {
                                                         label = "欄　位 ; 中文說明";
                                                         key   = "ltd"; // LineType Define
                                              // list  = "a\nb\nc\n";
                                                         fixed_width_font=true;
                                                         width = 20;
                                                         height = 10;
                                              //fixed_width = true;
                                                         multiple_select = true;
                                             
                                                      }//list_box
                                  
                                     
                                           :column{
                                                   :row{       
                                   
                                                         :column{     
                                                                  label = "                 欄位";
                                                                  :edit_box   {
                                                                         
                                                                                  key   = "fldv";//field value
                                                                                  edit_width=20;
                                                                                  value = "";
                                         
                                                                              } //edit_box
                                                                 
                                                              } //col
                                               
                                                         :column{
                                    
                                                                   :text{
                                                                          label="         ";
                                                                        }//text 
                                                                   :text {
                                                                          label="         ＝＞";
                                                                        }
                                                                   :text{
                                                                          label="         ";
                                                                        }//text 
                                               
                                                              }//column    
                                                       :column{
                                                                label = "             中文說明";
                                                                :edit_box  {
                                                             
                                                                              key   = "chaccount";//chinese account
                                                                              edit_width=20;
                                                                              value = "";
                                         
                                                                           } //edit_box
                                                                //:popup_list{
                                                                 //             key="newlay_pop";
                                                                 // 
                                                                  //            edit_width=20;
                                                                  //            value="1";
                                                                  //          }//pop                
                                                 
                                                              }//col
                                                    }//row                  
                                                    //:row{  
                                                     //     :button{
                                                     //               key = "add";
                                                     //              label="增加";
                                                      //           }//radio_button
                                           
                                                          :button{
                                                                   key = "mod";
                                                                  label="修改";
                                                                 }//radio_button
                                           
                                                        //  :button{
                                                         //          key = "del";
                                                          //        label="刪除";
                                                           //      }//radio_button
                                                       //}//row
                                                 }//column
                                 
                              }//col
                          }//row    
                             
                       
                            
                                     spacer_1;
                                     ok_cancel;
                         // :text{
                                 
                         //        key= "cue1";
                                 
                         //      }       
                         
                          
                } 