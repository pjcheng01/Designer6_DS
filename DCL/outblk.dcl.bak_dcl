outblk:dialog{
               label="拆零件";
               initial_focus="dpartpath";
      :row{
         :column{
           :row{
                :boxed_column{
                              label="拆圖模式";
                              :radio_button{label="拆出次組合圖";
                                            key="dsubasm";
                                           }//end of radio_button
                              :text{label="次組合圖存檔路徑:";}
                              :edit_box{key="subasmpath";
                                        edit_width=30;}
                              :radio_button{label="拆出零件圖";
                                            key="dpart";
                                            value=1;
                                           }//end of radio_button
                              :boxed_column{
                                            label="拆出零件圖模式";
                                            :boxed_column{
                                                           :radio_button{label="自動拆圖";
                                                                         key="dauto";
                                                                         value=1;
                                                                        }//end of radio_button
                                                           :radio_button{label="自選圖形一個一個拆圖";
                                                                         key="draw_sel";
                                                                        }//end of radio_button
                                                         }//end of boxed_column
                                           }//end of boxed_column
                              
                        }//end of boxed_column
               }//end of row
        // :edit_box{label="零件圖存放路徑:";
        //           key="partpath";
        //           width=30;}
           :text{label="零件圖存放路徑:";}
           :edit_box{key="dpartpath";
                     edit_width=32;}
           :edit_box{label="檔名前置碼(可有可無):";
                     key="precode";
                     edit_width=8;}
           :edit_box{label="檔名後置碼(可有可無):";
                     key="backcode";
                     edit_width=8;}
           ok_cancel;
        //     }//end of row
                }//end of column
         :column{
                 :row{
                      :edit_box{label="不拆出之零件圖層群組前置碼:";
                                key="nondcode";
                                edit_width=6;}
                      :button{label="排除確認-->>";
                              key="nondcodeok";}//nondcode_ok
                     }//end of row
                  :row{
                      :edit_box{label="    拆出之零件圖層群組前置碼:";
                                key="dcode";
                                edit_width=6;}
                      :button{label="加入確認<<--";
                              key="dcodeok";}//nondcode_ok
                     }//end of row   
                 :row{
                      :list_box{
                                multiple_select = true;
                                label="要自動拆拆出的零件圖層";
                                key="c_list";
                                height=20;
                                width=16;}
                      :column{
                             spacer_1;
                             spacer_1;
                             :button{label="排除-->";
                                     key="add";}
                             :button{label="加入<--";
                                     key="del";}
                             spacer_1;
                             spacer_1;
                             }//end of column
                      :list_box{
                                multiple_select = true;
                                label="不拆出的零件圖層";
                                key="non_list";
                                height=20;
                                width=16;}
                     }//end of row
             //  :text{label="按住 [Ctrl]鍵,可多重選擇線型 !";}
                }//end of column
         }//end of row
           errtile;

}//end of dialog

