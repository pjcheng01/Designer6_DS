
message:dialog{
             key="title";
                 spacer_1;
             :text{
                       key="txt";
                       width=60;
                     //  fixed_width_font=true;
                       }//end of list_box
                 spacer_1;
                 ok_cancel;
                 errtile;
}

shty:dialog{
             label="選取圖框種類";
             :list_box{
                       label="圖框種類";
                       key="shty";
                       fixed_width_font=true;
                       height=12;
                       width=16;
                       }//end of list_box
                 spacer_1;
                 ok_cancel;
                 errtile;
}

sheetset:dialog{
                label="圖框設定";
             :boxed_column{
                label="圖框設定";
               :row{
                    :button{
                              label="   圖  框  種  類   ";
                              key="sel_shty";
                           }
                    :edit_box{
                    //          label="圖框種類";
                              key="shty";
                              edit_width=12;
                             }
                    :text{width=3;}
                    :edit_box{
                              label="圖紙名稱 :";
                              key="name";
                              edit_width=12;
                             }
                    }//row
               :row{
                    :button{
                              label="空白區水平寬度";
                              key="cal_hwid";
                           }
                    :edit_box{
                           //   label="水平寬度";
                              key="hwid";
                              edit_width=12;
                             }
                    :text{width=3;}
                    :edit_box{
                              label="圖紙尺寸 :";
                              key="size";
                              edit_width=12;
                             }
                    }//row
               :row{
                    :button{
                              label="空白區垂直寬度";
                              key="cal_vwid";
                           }
                    :edit_box{
                           //   label="垂直寬度";
                              key="vwid";
                              edit_width=12;
                             }
                    :text{width=3;}
                    :edit_box{
                              label="圖檔檔名 :";
                              key="filename";
                              edit_width=12;
                             }
                    }//row
               :row{
                    :toggle{
                            label="圖框無屬性";
                            key="nonatt";
                           }
                    :text{width=10;}
                    :text{
                          label="圖檔路徑 :";
                         }
                    :edit_box{
                     //         label="                  圖檔路徑";
                              key="path";
                              edit_width=29;
                             }
                    }//row
             }//end of boxed
               spacer_1;
               :row{
                  :list_box{
                            label="屬性標籤                       提示文字                                                     對應詞庫                                特殊識別碼";
                            key="tolist";
                            fixed_width_font=true;
                            height=14;
                            width=68;
                            }//end of list_box
               //   :list_box{
               //             label="屬性標籤";
               //             key="logo";
               //             fixed_width_font=true;
               //             height=12;
               //             width=14;
               //            }//end of list_box
               //   :list_box{
               //             label="提示文字";
               //             key="txt";
               //             fixed_width_font=true;
               //             height=12;
               //             width=16;
               //            }//end of list_box
               //   :list_box{
               //             label="對應詞庫";
               //             key="lib";
               //             fixed_width_font=true;
               //             height=12;
               //             width=16;
               //            }//end of list_box
               //   :list_box{
               //             label="特殊識別碼";
               //             key="code";
               //             fixed_width_font=true;
               //             height=12;
               //             width=10;
               //            }//end of list_box
                    :column{
                            :text{}
                            :button{label="上移";
                                      key="up";}
                            :button{label="下移";
                                      key="down";}
                            :text{}
                           }//end of column
                    }//row
               //     spacer_1;
               :row{
                    :edit_box{
                              key="e_logo";
                              fixed_width_font=true;
                              edit_width=10;
                             }//end of list_box
                    :edit_box{
                              key="e_txt";
                              edit_width=28;
                             }
                    :popup_list{
                              key="e_lib";
                              fixed_width_font=true;
                              edit_width=14;
                             }//end of list_box
                    :popup_list{
                              key="e_code";
                              fixed_width_font=true;
                              edit_width=8;
                             }//end of list_box
                    :button{
                              label="修改";
                              key="mod";
                              fixed_width_font=true;
                           }//end of list_box
                    }//row
                    spacer_1;
              //       :spacer{width=10;}

               :row{
                     :text{width=6;}
                     ok_cancel;
                     :text{width=2;}
                     :button{label="建立詞庫";
                             key="creatlib";}
                     :text{width=2;}
                     :button{label="使用詞庫";
                             key="uselib";}
                     :text{width=6;}
                   }//row
                errtile;

}


modsheetset:dialog{
                label="圖框設定修改";
             :boxed_column{
                label="圖框設定";
               :row{
                    :text{
                           label="                     圖  框  種  類 ";
                      //     width=6;
                         }
                    :popup_list{
                              key="shty";
                              edit_width=12;
                             }
                    :text{width=3;}
                    :popup_list{
                              label="圖紙名稱 :";
                              key="name";
                              edit_width=12;
                             }
                    }//row
               :row{
                    :button{
                              label="空白區水平寬度";
                              key="cal_hwid";
                           }
                    :edit_box{
                           //   label="水平寬度";
                              key="hwid";
                              edit_width=12;
                             }
                    :text{width=3;}
                    :edit_box{
                              label="圖紙尺寸 :";
                              key="size";
                              edit_width=12;
                             }
                    }//row
               :row{
                    :button{
                              label="空白區垂直寬度";
                              key="cal_vwid";
                           }
                    :edit_box{
                           //   label="垂直寬度";
                              key="vwid";
                              edit_width=12;
                             }
                    :text{width=3;}
                    :edit_box{
                              label="圖檔檔名 :";
                              key="filename";
                              edit_width=12;
                             }
                    }//row
               :row{
                    :toggle{
                            label="圖框無屬性";
                            key="nonatt";
                           }
                   // :text{width=5;}
                    :edit_box{
                              label="圖紙名稱 :  ";
                              key="name1";
                              edit_width=12;
                             }
                  //  :text{width=10;}
                  //  :text{
                  //        label=" 圖檔路徑檔名 :";
                  //       }
                    :edit_box{
                              label="圖檔路徑檔名 :";
                              key="path";
                           //   edit_width=29;
                              edit_width=20;
                             }
                    }//row
             }//end of boxed
               spacer_1;
               :row{
                  :list_box{
                            label="屬性標籤                       提示文字                                                     對應詞庫                                特殊識別碼";
                            key="tolist";
                            fixed_width_font=true;
                            height=14;
                            width=68;
                            }//end of list_box
               //   :list_box{
               //             label="屬性標籤";
               //             key="logo";
               //             fixed_width_font=true;
               //             height=12;
               //             width=14;
               //            }//end of list_box
               //   :list_box{
               //             label="提示文字";
               //             key="txt";
               //             fixed_width_font=true;
               //             height=12;
               //             width=16;
               //            }//end of list_box
               //   :list_box{
               //             label="對應詞庫";
               //             key="lib";
               //             fixed_width_font=true;
               //             height=12;
               //             width=16;
               //            }//end of list_box
               //   :list_box{
               //             label="特殊識別碼";
               //             key="code";
               //             fixed_width_font=true;
               //             height=12;
               //             width=10;
               //            }//end of list_box
                    :column{
                            :text{}
                            :button{label="上移";
                                      key="up";}
                            :button{label="下移";
                                      key="down";}
                            :text{}
                           }//end of column
                    }//row
               //     spacer_1;
               :row{
                    :edit_box{
                              key="e_logo";
                              fixed_width_font=true;
                              edit_width=10;
                             }//end of list_box
                    :edit_box{
                              key="e_txt";
                              edit_width=28;
                             }
                    :popup_list{
                              key="e_lib";
                              fixed_width_font=true;
                              edit_width=14;
                             }//end of list_box
                    :popup_list{
                              key="e_code";
                              fixed_width_font=true;
                              edit_width=8;
                             }//end of list_box
                    :button{
                              label="修改";
                              key="mod";
                              fixed_width_font=true;
                           }//end of list_box
                    }//row
                    spacer_1;
              //       :spacer{width=10;}

               :row{
                     :text{width=6;}
                     ok_cancel;
                     :text{width=2;}
                     :button{label="建立詞庫";
                             key="creatlib";}
                     :text{width=2;}
                     :button{label="使用詞庫";
                             key="uselib";}
                     :text{width=6;}
                   }//row
                errtile;

}
