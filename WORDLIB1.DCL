creat_word:dialog{
                  label="辭庫管理";
                  :row{
                       :list_box{
                                 label="辭庫分類";
                                 width=20;
                                 height=12;
                                 key="group_list";
                                }
                       :list_box{
                                 label="分類內容";
                                 width=40;
                                 height=12;
                                 key="word_list";
                                }
                      }//end of row
                  spacer_1;
                  :row{
                       :boxed_column{
                                 :radio_button{
                                               label="辭庫建立";
                                               key="creat_id";
                                               value=1;
                                              }//end of radio_button
                                 :radio_button{
                                               label="辭庫編輯";
                                               key="modify_id";
                                              }//end of radio_button
                                 }//end of boxed_column
                  :boxed_column{
                            label="建立與編輯";
                            :row{
                                 :button{label="辭庫分類...";
                                         key="sel_group";}
                                 :edit_box{
                                           edit_width=20;
                                           key="belong_group";
                                          }
                                }//end of row
                            :row{
                                 :button{label="分類內容...";
                                         key="sel_data";}
                                 :edit_box{
                                           edit_width=40;
                                           key="worddata";
                                          }
                                }//end of row
                           }//end of boxed_column
                    }//end of row
                  spacer_1;
                       :row{
                            :button{
                                    label="刪除";
                                    key="del";
                                   }//end of button
                            :button{
                                    label="取代";
                                    key="replace";
                                   }//end of button
                            :button{
                                    label="建立";
                                    key="creat";
                                   }//end of button
                           }//end of column
                  ok_only;
                  errtile;
}

use_word:dialog{
                label="使用辭庫";
                :boxed_row{
                           label="以辭庫分類方式選擇所要文字";
                           :column{
                                  :boxed_column{
                                                label="文字條件";
                                                :edit_box{label="字高";
                                                          edit_width=4;
                                                          key="height";
                                                         }
                                                :edit_box{label="角度";
                                                          edit_width=4;
                                                          key="angle";
                                                          value="0";
                                                         }
                                                :popup_list{
                                                            label="對齊方式:";
                                                            key= "fit_type";
                                                            edit_width=8;
                                                           }
                                               }//end of boxed_column

                                              :list_box{
                                                        label="辭庫分類";
                                                        width=14;                                               width=30;
                                                        height=18;
                                                        key="group_list";
                                                        fixed_width_font= true ;
                                                       }
                                  }//end of column
                           :column{
                                   :button{label="顯示全部資料";
                                           key="alldata";}
                                   :list_box{
                                             label="分類內容";
                                             width=40;
                                             height=10;
                                             key="word_list";
                                             fixed_width_font= true ;
                                            }
                                 :boxed_column{
                                               label="全部書寫內容";
                                               :list_box{
                                                         width=30;
                                                         height=5;
                                                         key="write_list";
                                                         fixed_width_font= true ;
                                                        }
                                               :row{
                                                   :button{label="修改";
                                                           key="mod";}
                                                   :button{label="刪除";
                                                           key="del";}
                                                   }//end of row
                                               :edit_box{edit_width=44;
                                                         key="moddata";}
                                              }//end of boxed_column
                                   :text{label="注意:選擇以對齊方式書寫時, 不可以多行書寫!";}
                                  }//end of column
                          }//end of boxed_row
          //    spacer_1;
                :row{
                     :edit_box{label="書寫內容:";
                               edit_width=55;
                               key="data";
                              }
                     :button{label="下一行";
                             key="next";
                            }//end of button
                    }//end of row
                ok_cancel;
                errtile;
}

search_mode:dialog{
                 label="搜尋語法說明";
                 :text{label="特殊字元說明:";}
                 :text{label=" 萬用字元%";}
                 :text{label=" 特定字元_";}
                 spacer_1;
                 :text{label="萬用字元% 範例:";}
                 :text{label="   %機器%  表示辭庫中只要有\"機器\"二字者, 不論此二字前面或後面使是否有任何文字, 均一律挑選出來";}
                 :text{label="   %機器   表示辭庫中任何文字, 只要最後二字有\"機器\"者, 均一律挑選出來";}
                 :text{label="   機器%   表示辭庫中任何文字, 只要前面二字有\"機器\"者, 均一律挑選出來";}
                 spacer_1;
                 :text{label="_ 特定字元範例:";}
                 :text{label=" _機器_  表示辭庫中只要有\"機器\"二字者, 此二字前面或後面有任何1個字元, 均一律挑選出來";}
                 :text{label="_機器   表示辭庫中任何文字, 只要最後二字有\"機器\"且此二字前方只有1 個字元, 均一律挑選出來";}
                 :text{label="機器_   表示辭庫中任何文字, 只要最前面二字有\"機器\"且此二字後方只有1 個字元, 均一律挑選出來";}
                 :text{label="1個\" _ \" 代表一個英文或數字, 2個\" _ \" 連寫代表二個英文或數字";}
                 :text{label="注意: 2個\" _ \" 才能代表一個中文字";}
                 spacer_1;
                 ok_only;
}

pub_use_word:dialog{
                label="使用辭庫";
                :row{
                     :boxed_column{
                                  label="辭庫使用方式";
                                  :radio_button{
                                                label="由辭庫分類尋找";
                                                key="usetype";
                                                value=1;
                                               }//end of radio_button
                                  :radio_button{
                                                label="使用者定義搜尋";
                                                key="userdef";
                                               }//end of radio_button
                                  :button{label="搜尋語法說明";
                                         key="search_mode";}
                                  }
                     :boxed_column{
                  label="輸入自訂搜尋條件";
                                  :edit_box{label="搜尋條件";
                                            edit_width=20;
                                            key="search_kword";
                                           }
                                  :button{label="開始搜尋";
                                          key="exes";}
                                  :button{label="all data";
                                          key="alldata";}
                                  }//end of box_column
                    }//end of row
                :boxed_row{
                           label="以辭庫分類方式選擇所要文字";
                                         :list_box{
                                                   label="辭庫分類";
                                                   width=30;                                               width=30;
                                                   height=12;
                                                   key="group_list";
                                                   fixed_width_font= true ;
                                                  }
                           :text{label="===>";}
                                         :list_box{
                                                   label="分類內容";
                                                   width=30;
                                                   height=12;
                                                   key="word_list";
                                                   fixed_width_font= true ;
                                                  }
                          }//end of boxed_row
                spacer_1;
                :edit_box{label="書寫內容:";
                          edit_width=45;
                          key="data";
                         }
                ok_cancel;
                errtile;
}

name_list:dialog{
                label="請選擇...";
                :list_box{
                         width=30;
                         height=15;
                         key="na_list";
                         }//end of list_box
                spacer_1;
                ok_cancel;
                errtile;
}//end dialog

