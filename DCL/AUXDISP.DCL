
//輸入層名以控制圖層
lcontrol:dialog{
              label="圖層控制";

              :row{
                :boxed_column{
//              :boxed_row{
                            label="圖層狀態";
                            :radio_button{
                                          label="開";
                                          key="on";
                                         }//end of radio_button
                            :radio_button{
                                          label="關";
                                          key="off";
                                         }//end of radio_button
                            :radio_button{
                                          label="冷凍";
                                          key="freeze";
                                         }//end of radio_button
                            :radio_button{
                                          label="解凍";
                                          key="thraw";
                                         }//end of radio_button
                            :radio_button{
                                          label="目前層";
                                          key="curlayer";
                                         }//end of radio_button
                           }//end of column
                :list_box{
                          label="選擇要作的用圖層";
                          width=20;
                          key="sellayer";
                         }
               }//end of row
               :edit_box{label="層名:";
                        edit_width=10;
                           key="laname";}
                spacer_1;
                ok_cancel;
                errtile;
}//end of dialog


//選擇欲顯示之圖層名稱
pshow:dialog{
              label="圖層控制";

                :list_box{
                          label="選擇要顯示之圖層圖層";
                          width=20;
                          key="sellayer";
                          multiple_select = true;
                         }
                spacer_1;
                :text{
                       label="目前層 : ";
                       key=curlay;}
                spacer_1;
                ok_cancel;
                errtile;
}//end of dialog


//線型顯示控制
ltcontrol:dialog{
              label="線型顯示控制";

              :row{
                :boxed_column{
                            label="線型顯示狀態";
                            :radio_button{
                                          label="開";
                                          key="on";
                                         }//end of radio_button
                            :radio_button{
                                          label="關";
                                          key="off";
                                         }//end of radio_button
                           }//end of column
                :list_box{
                          multiple_select = true;
                          label="選擇線型";
                          width=40;
                          key="sellinetype";
                         }
               }//end of row
               :text{label="按住 [Ctrl]鍵,可多重選擇線型 !";}
                spacer_1;
                ok_cancel;
                errtile;
}//end of dialog

automlc:dialog{
              label="連續自動建立圖層";
              initial_focus="fcode";
              :edit_box{label="前置碼(可有可無)";
                        edit_width=10;
                        key="fcode";}
              :edit_box{label="起始流水號";
                        edit_width=10;
                        key="snum";}
              :edit_box{label="要建立的圖層數量";
                        edit_width=10;
                        key="eqty";}
              spacer_1;
              ok_cancel;
              errtile;
}//end of dialog
