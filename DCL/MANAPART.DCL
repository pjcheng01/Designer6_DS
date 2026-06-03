
makeparts:dialog{
                 key="label";
                 initial_focus="pname";
         :row{
            :column{
                          :boxed_column{
                                        label="提示";
                                        :text{label="＊ : 表示必須輸入資料的欄位";}
                                        :text{label="＃ : 表示必須自動拆圖時內定的檔名";}
                                       }
            :boxed_column{
                          :edit_box{
                                    label="＊零件圖層名稱";
                                    edit_width=30;
                                    key="layer";
                                    }//end of edit_box
                           :row{
                                :button{label="＊選擇顏色(不可選bylayer, byblock)...";
                                        key="selcol";}
                                :edit_box{
                                          key="col";
                                          edit_width=4;}
                               }//end of row
                          :row{
                               :text{key="lab3";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data3";
                                        }//end of edit_box
                              }//end of row
                          spacer_1;
                          :text{key="lab";}
                          :list_box{
                                     key="partgroup";
                                    
                                     height=18;
                                     width=28;
                                   }//end of list_box


                              }//end of boxed_column
                         }//end of boxed_column
                  :boxed_column{
                          :row{
                               :text{key="lab1";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data1";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab2";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data2";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab4";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data4";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab5";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data5";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab6";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data6";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab7";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data7";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab8";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data8";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab9";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data9";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab10";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data10";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab11";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data11";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab12";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data12";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab13";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data13";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab14";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data14";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab15";
                                     edit_width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data15";
                                        }//end of edit_box
                              }//end of row
                          :row{:text{label="圖層名稱應用的欄位則請輸入 ＊ ";}}
                              }//end of column
             }//end of row
                 :row{
                      ok_cancel;
                      :button{label="辭庫";
                              key="lib";}
                     }
                 errtile;
}//end of dialog

bomdata:dialog{
                 label="資訊點資料";
                 initial_focus="pname";
//               :boxed_column{
//                            label="提示";
                               :text{label="＊ : 表示必須輸入資料的欄位";}
                               :text{label="＃ : 表示必須自動拆圖時內定的檔名";}
//                            }
                 :boxed_column{
                          :edit_box{
                                    label="＊零件圖層名稱";
                                    edit_width=30;
                                    key="layer";
                                    }//end of edit_box
                          :row{
                               :text{key="lab3";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data3";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab1";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data1";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab2";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data2";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab4";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data4";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab5";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data5";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab6";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data6";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab7";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data7";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab8";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data8";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab9";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data9";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab10";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data10";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab11";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data11";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab12";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data12";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab13";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data13";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab14";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data14";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab15";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data15";
                                        }//end of edit_box
                              }//end of row
                          :row{:text{label="圖層名稱應用的欄位則請輸入 ＊ ";}}
                  }//end of column
//               spacer_1;
                 :row{
                      ok_cancel;
                      :button{label="辭庫";
                              key="lib";}
                     }
                 errtile;
}//end of dialog

automakepart:dialog{label="自動建立資訊點";
                 :row{
                      :list_box{
                             // multiple_select = true;
                                label="要建立資訊點的圖層";
                                key="yeslayers";
                                multiple_select=true;
                                height=20;
                                width=20;}
                      :column{
                             spacer_1;
                             spacer_1;
                             :button{label="排除-->";
                                     key="no";}
                             :button{label="<--加入";
                                     key="yes";}
                             spacer_1;
                             spacer_1;
                             }//end of column
                      :list_box{
                             // multiple_select = true;
                                label="不建立資訊點的圖層";
                                key="nolayer";
                                multiple_select=true;
                                height=20;
                                width=20;}
                      :boxed_column{
                      //         label="欄位預設值";
                      //         :boxed_column{
                      //                      label="自動件號資料";
                      //                      :edit_box{label="件號前置文字";
                      //                                key="ftxt";
                      //                                edit_width=12;}
                      //                      :edit_box{label="起始件號";
                      //                                key="sno";
                      //                                edit_width=12;}
                      //                      }//end of boxed_column
                             :row{
                                 :column{
                                    //   :text{key="lab1";
                                    //         width=12;}
                                    //   :text{key="lab2";
                                    //         width=12;}
                                         :text{key="lab3";
                                               width=12;}
                                         :text{key="lab4";
                                               width=12;}
                                         :text{key="lab5";
                                               width=12;}
                                         :text{key="lab6";
                                               width=12;}
                                         :text{key="lab7";
                                               width=12;}
                                         :text{key="lab8";
                                               width=12;}
                                         :text{key="lab9";
                                               width=12;}
                                         :text{key="lab10";
                                               width=12;}
                                         :text{key="lab11";
                                               width=12;}
                                         :text{key="lab12";
                                               width=12;}
                                         :text{key="lab13";
                                               width=12;}
                                         :text{key="lab14";
                                               width=12;}
                                         :text{key="lab15";
                                               width=12;}
                                        }//end of column
                                 :column{
                                         :edit_box{key="data3";
                                                   edit_width=12;}
                                         :edit_box{key="data4";
                                                   edit_width=12;}
                                         :edit_box{key="data5";
                                                   edit_width=12;}
                                         :edit_box{key="data6";
                                                   edit_width=12;}
                                         :edit_box{key="data7";
                                                   edit_width=12;}
                                         :edit_box{key="data8";
                                                   edit_width=12;}
                                         :edit_box{key="data9";
                                                   edit_width=12;}
                                         :edit_box{key="data10";
                                                   edit_width=12;}
                                         :edit_box{key="data11";
                                                   edit_width=12;}
                                         :edit_box{key="data12";
                                                   edit_width=12;}
                                         :edit_box{key="data13";
                                                   edit_width=12;}
                                         :edit_box{key="data14";
                                                   edit_width=12;}
                                         :edit_box{key="data15";
                                                   edit_width=12;}
                                        }//end of column

                                    }//end of row
                                        :text{label="圖層名稱應用的欄位則請輸入 ＊ ";
                                              width=30; }
                                }//end of boxed_column
                     }//end of row
        //       :row{
        //            :text{label="圖層名稱也應用在那一欄位(選不選皆可):";}
        //            :popup_list{
        //                        key="col";
        //                        width=20;
        //                        height=5;
        //                       }
        //            :spacer{width=20;}
        //           }//end of row
           :row{
           ok_cancel;
           :button{label="辭庫";
                   key="lib";}
               }//end of row
           :row{
                errtile;
                :text{key="mess";}
               }//end of row
           :text{key="mess2";}
}//end of dialog

sortcol:dialog{
           //    label="物料結構與圖檔管理顯示欄位順序定義";
               label="物料結構顯示欄位順序定義";
               :row{
                    :column{
                            spacer_1;
                            spacer_1;
                            :button{label="上移 ^";
                                      key="up";}
                            :button{label="下移 v";
                                      key="down";}
                            spacer_1;
                            spacer_1;
                           }//end of column
                    :column{
                            :list_box{
                                      label="內定欄位";
                                      key="default";
                                      fixed_width_font=true;
                                      height=3;
                                      width=15;
                                     }//end of list_box
                            :list_box{
                                      label="自定的欄位";
                                      key="need";
                                      fixed_width_font=true;
                                      height=18;
                                      width=15;
                                     }//end of list_box
                              }//end of column
                    :column{
                            spacer_1;
                            spacer_1;
                            :button{label="排除＞＞";
                                      key="out";}
                            :button{label="＜＜加入";
                                      key="in";}
                            spacer_1;
                            spacer_1;
                           }//end of column
                    :list_box{
                              label="排除的欄位";
                              key="noneed";
                              fixed_width_font=true;
                              height=18;
                              width=15;
                             }//end of list_box
                   }//end of row
           ok_cancel;
           errtile;
}//end of dialog

autob:dialog{label="自動產生指標球";
             :edit_box{
                       label="件號前置文字:";
                       edit_width=10;
                       key="ftxt";
                       }//end of edit_box
             :edit_box{
                       label="起始件號:";
                       edit_width=10;
                       key="fno";
                       }//end of edit_box
             :edit_box{
                       label="件號間距:";
                       edit_width=10;
                       key="dist";
                       }//end of edit_box
             spacer_1;
             ok_cancel;
             errtile;
}//end of dialog

//╭════════════════════╮
//║設計日期:2000.09.03                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:警示框                         ║
//╰════════════════════╯
allert:dialog{
       label="警示訊息";
       spacer_1;
       :text{ key="allert1"; }
       :text{ key="allert2"; }
       spacer_1;
       ok_cancel;
      }


cbomdata:dialog{
                 label="物料資料";
                 initial_focus="pname";
                 :boxed_column{
                          :row{
                               :text{key="lab1";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data1";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab2";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data2";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab3";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data3";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab4";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data4";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab5";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data5";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab6";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data6";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab7";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data7";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab8";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data8";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab9";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data9";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab10";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data10";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab11";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data11";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab12";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data12";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab13";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data13";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab14";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data14";
                                        }//end of edit_box
                              }//end of row
                          :row{
                               :text{key="lab15";
                                     width=10;}
                               :edit_box{
                                         edit_width=30;
                                         key="data15";
                                        }//end of edit_box
                              }//end of row
                  }//end of column
                 spacer_1;
                 :row{
                      ok_cancel;
                      :button{label="辭庫";
                              key="lib";}
                     }
                 errtile;
}//end of dialog

//╭════════════════════╮
//║設計日期:2001.01.30                     ║
//║更新日期:                               ║
//║設計者:佘宗紋                           ║
//║功能說明:手動產生指標球(連續編號)       ║
//╰════════════════════╯

autob_info:dialog{label="手動產生指標球";
             :edit_box{
                       label="件號前置文字:";
                       edit_width=10;
                       key="ftxt";
                       }//end of edit_box
             :edit_box{
                       label="起始件號:";
                       edit_width=10;
                       key="fno";
                       }//end of edit_box
             :edit_box{
                       label="件號間距:";
                       edit_width=10;
                       key="dist";
                       }//end of edit_box
             spacer_1;
             ok_cancel;
             errtile;
}//end of dialog
//╭════════════════════╮
//║設計日期:2001.02.01                     ║
//║更新日期:                               ║
//║設計者:佘宗紋                           ║
//║功能說明:手動產生指標球(不連續編號)     ║
//╰════════════════════╯

keyinb_info:dialog{label="手動產生指標球";
             :edit_box{
                       label="件號前置文字:";
                       edit_width=10;
                       key="ftxt";
                       }//end of edit_box
             :edit_box{
                       label=" 件 號 : ";
                       edit_width=10;
                       key="fno";
                       }//end of edit_box
             :edit_box{
                       label="件號間距:";
                       edit_width=10;
                       key="dist";
                       }//end of edit_box
             spacer_1;
             ok_cancel;
             errtile;
}//end of dialog

mana_database:dialog{
                    label="物料資料庫管理";
                    :row{ 
                         :list_box{label="物料資料庫";
                                   key="data"; 
                                   width=56;
                                   height=20;
                                 //fixed_width_font=true;
                                   }
                         :boxed_column{
                                       :row{
                                            :text{key="lab1";
                                                  width=10;}
                                            :edit_box{key="data1";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab2";
                                                  width=10;}
                                            :edit_box{key="data2";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab3";
                                                  width=10;}
                                            :edit_box{key="data3";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab4";
                                                  width=10;}
                                            :edit_box{key="data4";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab5";
                                                  width=10;}
                                            :edit_box{key="data5";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab6";
                                                  width=10;}
                                            :edit_box{key="data6";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab7";
                                                  width=10;}
                                            :edit_box{key="data7";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab8";
                                                  width=10;}
                                            :edit_box{key="data8";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab9";
                                                  width=10;}
                                            :edit_box{key="data9";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab10";
                                                  width=10;}
                                            :edit_box{key="data10";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab11";
                                                  width=10;}
                                            :edit_box{key="data11";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab12";
                                                  width=10;}
                                            :edit_box{key="data12";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab13";
                                                  width=10;}
                                            :edit_box{key="data13";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab14";
                                                  width=10;}
                                            :edit_box{key="data14";
                                                      edit_width=20;}
                                           }//end of row
                                       :row{
                                            :text{key="lab15";
                                                  width=10;}
                                            :edit_box{key="data15";
                                                      edit_width=20;}
                                           }//end of row
                                       :boxed_row{
                                                  :button{label="增加";
                                                         key="add";}
                                                  :button{label="修改";
                                                          key="mod";}
                                                  :button{label="刪除";
                                                          key="del";}
                                                  
                                                 }
                                      }//end of boxed_column 

                        }//end of row 
 
                    ok_cancel;
                    errtile;  


}//end of dialog
