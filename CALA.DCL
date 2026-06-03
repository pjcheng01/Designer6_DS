
cala:dialog{
           label="POWERTEC 計算機";
           :edit_box{key="function";
                     fixed_width_font=true;}
           :row{
               :boxed_column{
                             :row{
                                  :button{label="Ｍ＋";
                                          key="m+";}
                                  :button{label="Ｍ－";
                                          key="m-";}
                                  :button{label="ＭＲ";
                                          key="mr";}
                                  :button{label="ＭＣ";
                                          key="mc";}
                                 }
                             :row{
                                   :button{label="７";
                                           key="7";}
                                   :button{label="８";
                                           key="8";}
                                   :button{label="９";
                                           key="9";}
                                 }//end of row

                             :row{
                                   :button{label="４";
                                           key="4";}
                                   :button{label="５";
                                           key="5";}
                                   :button{label="６";
                                           key="6";}
                                 }//end of row
                             :row{
                                   :button{label="１";
                                           key="1";}
                                   :button{label="２";
                                           key="2";}
                                   :button{label="３";
                                           key="3";}
                                 }//end of row

                             :row{
                                   :button{label="０";
                                           key="0";}
                                   :button{label="００";
                                           key="0d";}
                                   :button{label="．";
                                           key="pd";}
                                 }//end of row
                            }//end of boxed_column

               :column{
                       :boxed_row{
                           :button{label="Ｃ";
                                   key="c";}
                           :button{label="ＡＣ";
                                   key="ac";}
                              }//end of column
                       :row{
                            :button{label="（";
                                    key="left_c";}
                            :button{label="）";
                                    key="right_c";}
                          }//end of row
                       :row{
                            :button{label="×";

                                    key="x";}
                            :button{label="÷";
                                    key="dv";}
                          }//end of row
                       :row{
                            :button{label="＋";
                                    key="+";}
                            :button{label="－";
                                    key="-";}
                          }//end of row
                       :row{
                            :button{label="EXP";
                                    key="exp";}
                            :button{label="SQRT";
                                    key="sqrt";}
                          }//end of row

                  :button{label="＝";
                          key="=";}

                  }//end of column
               }//end of row
             spacer_1;
             :row{
                  :text{key="mtitle";}
                  :text{key="memory";}
                  :spacer{width=15;}
                 }
             ok_only;
             errtile;
}//end of dialog


cale:dialog{
           label="POWERTEC 工程計算機";
           :edit_box{key="function";
                     fixed_width_font=true;}
           :boxed_column{
                         :row{
                              :button{label="Ｉ->Ｍ";
                                      key="itom";}
                              :button{label="Ｍ->Ｉ";
                                      key="mtoi";}
                              :button{label="１／Ｘ";
                                      key="1/x";}
                              :button{label="＋／－";
                                      key="+/-";}
                              :button{label="Ｐｉ";
                                      key="pi";}
//                            :button{label="Ｘ！";
//                                    key="x!";}
                             }//end of row
                       :row{
                          :column{
                                 :row{
                                      :button{label="ａｓｉｎ";
                                              key="asin";}
                                      :button{label="ａｃｏｓ";
                                              key="acos";}
                                      :button{label="ａｔａｎ";
                                              key="atan";}
                                 //   :spacer{width=15;}
                                     }//end of row
                                 :row{
                                      :button{label=" ｓｉｎ ";
                                              key="sin";}
                                      :button{label=" ｃｏｓ ";
                                              key="cos";}
                                      :button{label=" ｔａｎ ";
                                              key="tan";}
                                     }//end of row
                                 }//end of column
                                 :boxed_column{
                                     :button{label="Ｃ";
                                             key="c";}
                                     :button{label="ＡＣ";
                                             key="ac";}
                                        }//end of column
                            }//end of row
                       }//end of boxed_column
           :row{
               :boxed_column{
                             :row{
                                  :button{label="Ｍ＋";
                                          key="m+";}
                                  :button{label="Ｍ－";
                                          key="m-";}
                                  :button{label="ＭＲ";
                                          key="mr";}
                                  :button{label="ＭＣ";
                                          key="mc";}
                                 }
                             :row{
                                   :button{label="７";
                                           key="7";}
                                   :button{label="８";
                                           key="8";}
                                   :button{label="９";
                                           key="9";}
                                 }//end of row

                             :row{
                                   :button{label="４";
                                           key="4";}
                                   :button{label="５";
                                           key="5";}
                                   :button{label="６";
                                           key="6";}
                                 }//end of row
                             :row{
                                   :button{label="１";
                                           key="1";}
                                   :button{label="２";
                                           key="2";}
                                   :button{label="３";
                                           key="3";}
                                 }//end of row

                             :row{
                                   :button{label="０";
                                           key="0";}
                                   :button{label="００";
                                           key="0d";}
                                   :button{label="．";
                                           key="pd";}
                                 }//end of row
                            }//end of boxed_column

               :boxed_column{
                       :row{
                            :button{label="（";
                                    key="left_c";}
                            :button{label="）";
                                    key="right_c";}
                          }//end of row
                       :row{
                            :button{label="×";

                                    key="x";}
                            :button{label="÷";
                                    key="dv";}
                          }//end of row
                       :row{
                            :button{label="＋";
                                    key="+";}
                            :button{label="－";
                                    key="-";}
                          }//end of row
                       :row{
                            :button{label="EXP";
                                    key="exp";}
                            :button{label="SQRT";
                                    key="sqrt";}
                          }//end of row

                  :button{label="＝";
                          key="=";}

                  }//end of boxed_column
               }//end of row
             spacer_1;
             :row{
                  :text{key="mtitle";}
                  :text{key="memory";}
                  :spacer{width=15;}
                 }
             ok_only;
             errtile;
}//end of dialog

