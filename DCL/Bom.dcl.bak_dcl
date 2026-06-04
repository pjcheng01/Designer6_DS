// 拆零件
out:dialog{
           label="拆零件";
          initial_focus="partpath";
      :row{
         :column{
           :row{
                :boxed_column{
                              label="拆圖模式";
                              :radio_button{label="拆出次組合圖";
                                            key="subassem";
                                           }//end of radio_button
                              :text{label="次組合圖存檔路徑:";}
                              :edit_box{key="subpath";
                                        edit_width=30;}
                              :radio_button{label="拆出零件圖";
                                            key="part";
                                            value=1;
                                           }//end of radio_button
                              :boxed_column{
                                            label="拆出零件圖模式";
                                            :boxed_column{
                                                           :radio_button{label="自動拆圖";
                                                                         key="auto";
                                                                         value=1;
                                                                        }//end of radio_button
                                                           :radio_button{label="自選圖形一個一個拆圖";
                                                                         key="onebyone";
                                                                        }//end of radio_button
                                                         }//end of boxed_column
                                           }//end of boxed_column
                               :boxed_column{
                                             label="零件圖存檔模式";
                                             :radio_button{label="以原圖層層名存檔";
                                                           key="oldlay";
                                                          }//end of radio_button
                                             :radio_button{label="以 0 層層名存檔";
                                                           key="lay0";
                                                           value=1;
                                                          }//end of radio_button
                                       }//end of boxed_column
                        }//end of boxed_column
               }//end of row
        // :edit_box{label="零件圖存放路徑:";
        //           key="partpath";
        //           width=30;}
           :text{label="零件圖存放路徑:";}
           :edit_box{key="partpath";
                     edit_width=32;}
           :edit_box{label="檔名前置碼(可有可無):";
                     key="fcode";
                     edit_width=8;}
           :edit_box{label="檔名後置碼(可有可無):";
                     key="bcode";
                     edit_width=8;}
           ok_cancel;
        //     }//end of row
                }//end of column
         :column{
                 :row{
                      :edit_box{label="不拆出之零件圖層群組前置碼:";
                                key="code";
                                edit_width=6;}
                      :button{label="排除確認-->>";
                              key="exe";}
                     }//end of row
                 :row{
                      :list_box{
                                multiple_select = true;
                                label="要自動拆拆出的零件圖層";
                                key="outlalist";
                                height=20;
                                width=16;}
                      :column{
                             spacer_1;
                             spacer_1;
                             :button{label="排除-->";
                                     key="noout";}
                             :button{label="加入<--";
                                     key="out";}
                             spacer_1;
                             spacer_1;
                             }//end of column
                      :list_box{
                                multiple_select = true;
                                label="不拆出的零件圖層";
                                key="nolalist";
                                height=20;
                                width=16;}
                     }//end of row
             //  :text{label="按住 [Ctrl]鍵,可多重選擇線型 !";}
                }//end of column
         }//end of row
           errtile;

}//end of dialog


bomball_xdata:dialog{
              label="輸入材料清單內容";
                 initial_focus="xdata2";
                :row{
                    :boxed_column{
                                 :row{
                                       :text{
                                             key="label1";
                                             width=12;}
                                       :edit_box{
                                                   key="xdata1";
                                                   edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label2";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata2";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label3";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata3";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label4";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata4";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label5";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata5";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label6";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata6";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label7";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata7";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label8";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata8";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                      :text{
                                            key="label9";
                                            width=12;}
                                       :edit_box{
                                                key="xdata9";
                                                edit_width=16;}
                                     }//end of boxed_row
                                 :row{
                                      :text{
                                            key="label10";
                                            width=12;}
                                       :edit_box{
                                                key="xdata10";
                                                edit_width=16;}
                                     }//end of boxed_row

                                 }//end of boxed_column

                    :boxed_column{
                                 :row{
                                       :text{
                                             key="label11";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata11";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label12";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata12";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label13";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata13";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label14";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata14";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label15";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata15";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label16";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata16";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label17";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata17";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                       :text{
                                             key="label18";
                                             width=12;}
                                       :edit_box{
                                                 key="xdata18";
                                                 edit_width=16;}
                                      }//end of boxed_row
                                 :row{
                                      :text{
                                            key="label19";
                                            width=12;}
                                       :edit_box{
                                                key="xdata19";
                                                edit_width=16;}
                                     }//end of boxed_row
                                 :row{
                                      :text{
                                            key="label20";
                                            width=12;}
                                       :edit_box{
                                                key="xdata20";
                                                edit_width=16;}
                                     }//end of boxed_row

                                 }//end of boxed_column

                   }//end of row
//              ok_cancel;
                ok_only;
//             :row{
//                  ok_button;
//                  cancel_button;
//                  :spacer{width=30;}
//                  :button{label="辭庫";
//                          key="lib";}
//                 }
                errtile;

}





drawbom_list:dialog{
            label="產生材料清單圖形";
            :boxed_column{
                   label="選擇清單圖形格式";
                   :row{
                          :image_button{
                                        width=14;
                                        height=6;
                                        key="list1";
                                        color=-2;
                                       }//end of image_button
                          :image_button{
                                        width=14;
                                        height=6;
                                        key="list2";
                                        color=-2;
                                       }//end of image_button
                        }//end of row
                   :row{
                          :image_button{
                                        width=14;
                                        height=6;
                                        key="list3";
                                        color=-2;
                                       }//end of image_button
                          :image_button{
                                        width=14;
                                        height=6;
                                        key="list4";
                                        color=-2;
                                       }//end of image_button
                         }
                        }//end of row
             spacer_1;
             :row{
                 :edit_box{label="字高:";
                           edit_width=4;
                           key="txth";}
                 :edit_box{label="欄高:";
                           edit_width=4;
                           key="colh";}

                 }
             spacer_1;
             :row{
                :spacer{width=6;}
                ok_cancel;
                :spacer{width=6;}
                 }//end of row
             errtile;
}

////╭════════════════════╮
////║設計日期:2000. 9. 26                    ║
////║更新日期:                               ║
////║設計者:陳冠達                           ║
////║功能說明:圖框比例設定                   ║
////║相關檔案:bom.lsp                        ║
////╰════════════════════╯
//pdm_selsheet:dialog{
//                  label="拆圖後零件圖使用那一種圖框";
//                 :list_box{
//                           fixed_width_font=true;
//                           label="圖框型式:";
//                           key="type";
//                           width=16;
//                          }//end of list_box
//                 ok_only;
//                 errtile;
//}//

//╭════════════════════╮
//║設計日期:2000. 9. 26                    ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:圖框比例設定                   ║
//║相關檔案:bom.lsp                        ║
//╰════════════════════╯
pdm_selsheet:dialog{
                  label="拆圖後零件圖使用那一種圖框";
                :row{
                 :list_box{
                           fixed_width_font=true;
                           label="圖框型式:";
                           key="type";
                           width=16;
                          }//end of list_box
                          
                 :list_box{
                           fixed_width_font=true;
                           label="圖紙尺寸:";
                           key="size";
                           width=20;
                          }//end of list_box
                     }//end of row
                 ok_cancel;
                 errtile;
}//                 
                 
