
partmenu:dialog{
     key = "title";
     :row{
          :column{
          :list_box{ label="功能目錄";
                     fixed_width_font=true;
                     key="function";
                     allow_accept=true;
                     width=20;
                     height=18;
                   }//end of list_box
          :boxed_column{
                     label="圖像點取方式";
                     :radio_button{
                             label="執行功能";
                             key="exe";
                             value=1;
                            }//end of radio_button
                     :radio_button{
                             label="圖像放大";
                             key="zoom";
                            }//end of radio_button
                     :radio_button{
                             label="指令查詢";
                             key="comm";
                            }//end of radio_button
                    }
           ok_only;
           }//end of column

          :boxed_column{
                       label="請選擇一項";
                       :row{
                            :image_button{
                                          key="sld1";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld2";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld3";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld4";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button

                       }//end of row
                       :row{
                           :edit_box {
                                  key = "sld1_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld2_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld3_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld4_txt";
                                  edit_width=14;
                                 }//edit_box
                           }//end of row
                       :row{
                            :image_button{
                                          key="sld5";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld6";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld7";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld8";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button

                       }//end of row
                       :row{
                           :edit_box {
                                  key = "sld5_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld6_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld7_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld8_txt";
                                  edit_width=14;
                                 }//edit_box
                           }//end of row
                       :row{
                            :image_button{
                                          key="sld9";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld10";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld11";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld12";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button

                       }//end of row
                       :row{
                           :edit_box {
                                  key = "sld9_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld10_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld11_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld12_txt";
                                  edit_width=14;
                                 }//edit_box
                           }//end of row
                       :row{
                            :image_button{
                                          key="sld13";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld14";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld15";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button
                            :image_button{
                                          key="sld16";
                                          height =5;
                                          width=14;
                                          color =253;} //end of image_button

                       }//end of row
                       :row{
                           :edit_box {
                                  key = "sld13_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld14_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld15_txt";
                                  edit_width=14;
                                 }//edit_box
                           :edit_box {
                                  key = "sld16_txt";
                                  edit_width=14;
                                 }//edit_box
                           }//end of row
                      }//end of boxed_column
         }//end of row
         errtile;
}

manamenu:dialog{
             key="title";
             :row{
                  :column{
                          :list_box{ label="功能目錄";
                                     fixed_width_font=true;
                                     key="function";
                                     allow_accept=true;
                                     width=16;
                                     height=20;
                                   }
                          :boxed_column{
                                        label="建立目錄";
                                        :edit_box{label="目錄名稱:";
                                                  key="cataname";
                                                  edit_width=30;}
                                        :button{label="執行建立目錄";
                                                  key="addcala";}
                                        :text{key="mess";}
                                      //  errtile;
                                       }//end of boxed_column
                          }//end of column
                  :boxed_column{
                                label="建立功能條件";
                                :row{
                                     :radio_button{key="lisp";
                                                   label="自創 Autolisp 程式";}
                                     :radio_button{key="comm";
                                                   label="AutoCAD 內建指令";}
                                    }//end of row
                                :row{
                                     :button{label="選擇幻燈片檔名...";
                                             key="selfile";}
                                     :text{key = "sldfname";
                                           width=10; }
                                    }//end of row
                                :edit_box {label="lisp檔名:";
                                           key = "lispfname";
                                           edit_width=10;}
                                :edit_box{label="lisp 函數定義方式:";
                                          edit_width=10;
                                          key="deftype";}
                                :edit_box {label="指令執行方式:";
                                           key = "comtype";
                                           edit_width=10;}
                                :edit_box {label="功能描述:";
                                           key = "descript";
                                           edit_width=10;}
                                :row{
                                     :column{
                                          :button{label="建立功能";
                                                  key="addfunc";}
                                          :button{label="清除條件值";
                                                   key="clear";}
                                         }//end of column
                                      :column{
                                               :image{key="sld";
                                                     height =5;
                                                     width=20;}
                                             }//end co column
                                    }//end of row
                                :text{key="note";}
                               }//end of boxed_column
                 }//end of row
                 ok_cancel;
                 errtile;
}


zoomblock:dialog{
               :image{
                      key="sld_name";
                      height=25;
                      width=70;
                      color =-2;
                      }
               ok_only;
}
