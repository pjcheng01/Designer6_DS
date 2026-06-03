//╭════════════════════╮
//║設計日期:1996. 1. 3                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:圖框比例設定                   ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:SHSCAL.LSP                     ║
//╰════════════════════╯
shscal:dialog{
       label="藝祥資訊";
       :boxed_row{
          :boxed_radio_column{
            label="請選擇圖紙與型式:";
            :radio_button{
             label= "A0 圖紙: 1189 x 841";
             key="a0";
             }
            :radio_button{
             label= "A1 圖紙:  841 x 594";
             key="a1";
             }
            :radio_button{
             label= "A2 圖紙:  594 x 420";
             key="a2";
             }
            :radio_button{
             label= "A3 圖紙:  420 x 297";
             key="a3";
             }
            :radio_button{
             label= "A4 圖紙:  297 x 210";
             key="a4";
             value="1";
             }
          }//end of boxed_radio_column

          :boxed_column{
            :boxed_radio_column{
              label="圖紙型式:";
              :radio_button{
               label= "直式";
               key="ver";
               }
              :radio_button{
               label= "橫式";
               key="hor";
               value="1";
               }
             }//end of boxed_radio_column
              :image{
                     key="sh_sld";
                     height =5;
                     width=15;
                     color =-2;
                    }
          }//end of boxed_column
       }//end of boxed_row
//     :boxed_row{label="圖框插入方式";
//                :radio_button{
//                              label= "插入圖框(Insert)";
//                              key="insert";
//                              value="1";
//                             }
//                :radio_button{
//                              label= "外部參考圖框(Xref)";
//                              key="refer";
//                             }
//               }
       spacer_1;
       :column{
           :row{
                : spacer { width = 13; }
                :text {
                        label=" 出圖公釐  =    圖形單位 ";
                        fixed_width_font=true;
                        width=true;
                      }//text
               }//end of row
           :row{
                 :button{
                         label="設定比例..";
                         key="setcal";
                        }
                 :text {
                         label=":";
                       }//text
                 :edit_box{
                           key="out_mm";
                           edit_width=8;
                          }
                 :text {
                         label="=";
                       }//text
                 :edit_box{
                           key="out_unit";
                           edit_width=8;
                          }
               }//end of row
              }//end of column
      :text {
            key = "draw_limit";
            value="請選擇圖紙與比例!!";
            }//text
       spacer_1;
       ok_cancel;
       :text{key="errtxt";}

}

//╭════════════════════╮
//║設計日期:1996. 1. 3                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:選擇比例                       ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:SHSCAL.LSP                     ║
//╰════════════════════╯
selscal:dialog{
       label="藝祥資訊";
       :list_box{
                 label="選擇比例";
                 key="scal_list";
                 width=15;
                 height=20;
                }
        ok_only;
}
//╭════════════════════╮
//║設計日期:1996. 1. 3                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:重新選擇比例                   ║
//║相關檔案:SHSCAL.LSP                     ║
//╰════════════════════╯
reselscal:dialog{
       label="藝祥資訊";
       :list_box{
                 label="選擇比例";
                 key="scal_list";
                 width=15;
                 height=15;
                }
        :boxed_row{
                   label="尺寸更新方式";
                   :radio_button{
                                 label= "自動更新";
                                 value=1;
                                 key="all";
                                 }
                   :radio_button{
                                 label= "使用者自選";
                                 key="user"; }
                  }//end of boxed_row
        :row{
             : spacer { width = 6; }
             :text {
                     label="出圖公釐 = 圖形單位 ";
                     fixed_width_font=true;
                     width=true;
                   }//text
            }//end of row
        :row{
              :text{ label="輸入新比例";}
              :text {
                      label=":";
                    }//text
              :edit_box{
                        key="out_mm";
                        edit_width=8;
                       }
              :text {
                      label="=";
                    }//text
              :edit_box{
                        key="out_unit";
                        edit_width=8;
                       }
              :spacer{width=3;}
            }//end of row
        :text{key="curscal";}
        spacer_1;
        ok_cancel;
        errtile;
}

//╭════════════════════╮
//║設計日期:1998. 8. 27                    ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:選擇比例                       ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:SHSCAL.LSP                     ║
//╰════════════════════╯
resetscal:dialog{
       label="藝祥資訊";
       :list_box{
                 label="選擇比例";
                 key="scal_list";
                 width=30;
                 height=20;
                }

        ok_only;
}

//╭════════════════════╮
//║設計日期:1996. 1. 4                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:修改圖框                       ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:MODDRAW.LSP                    ║
//╰════════════════════╯
moddraw:dialog{
       label="藝祥資訊 POWERCAD";
      :text {
            label="請選擇想要修改的圖紙型式!!";
            }//text
       :boxed_row{
          :row{
            :column{
                    :radio_button{
                     label= "A0 直式圖紙";
                     key="a0ver";
                     }
                    :radio_button{
                     label= "A1 直式圖紙";
                     key="a1ver";
                     }
                    :radio_button{
                     label= "A2 直式圖紙";
                     key="a2ver";
                     }
                    :radio_button{
                     label= "A3 直式圖紙";
                     key="a3ver";
                     }
                    :radio_button{
                     label= "A4 直式圖紙";
                     key="a4ver";
                     }
                     spacer_1;
                     :radio_button{
                      label= "A0 橫式圖紙";
                      key="a0hor";
                      }
                     :radio_button{
                      label= "A1 橫式圖紙";
                      key="a1hor";
                      }
                     :radio_button{
                      label= "A2 橫式圖紙";
                      key="a2hor";
                      }
                     :radio_button{
                      label= "A3 橫式圖紙";
                      key="a3hor";
                      }
                     :radio_button{
                      label= "A4 橫式圖紙";
                      key="a4hor";
                    }
                  }//end of column
           :column{
                :image{
                       key="sh_ver";
                       height =5;
                       width=15;
                       color =-2;
                      }
                spacer_1;
                :image{
                       key="sh_hor";
                       height =5;
                       width=15;
                       color =-2;
                      }
                  }//end of column
              }//end of row
          }//end of boxed_row

       spacer_1;
        ok_cancel;
       :text {
               key = "noselect";
              }//text
}

//╭════════════════════╮
//║設計日期:1996. 1. 3                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:圖框屬性                       ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:SHSCAL.LSP                     ║
//╰════════════════════╯
sheetatt:dialog{
                label="圖框屬性";
   :row{
        :column{
                initial_focus="data1";
                :row{
                     :text{key="label1";
                           width=10; }
                     :edit_box{
                               key="data1";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib1";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label2";
                           width=10; }
                     :edit_box{
                               key="data2";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib2";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label3";
                           width=10; }
                     :edit_box{
                               key="data3";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib3";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label4";
                           width=10; }
                     :edit_box{
                               key="data4";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib4";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label5";
                           width=10; }
                     :edit_box{
                               key="data5";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib5";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label6";
                           width=10; }
                     :edit_box{
                               key="data6";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib6";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label7";
                           width=10; }
                     :edit_box{
                               key="data7";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib7";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label8";
                           width=10; }
                     :edit_box{
                               key="data8";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib8";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label9";
                           width=10; }
                     :edit_box{
                               key="data9";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib9";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label10";
                           width=10; }
                     :edit_box{
                               key="data10";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib10";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label11";
                           width=10; }
                     :edit_box{
                               key="data11";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib11";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label12";
                           width=10; }
                     :edit_box{
                               key="data12";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib12";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label13";
                           width=10; }
                     :edit_box{
                               key="data13";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib13";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label14";
                           width=10; }
                     :edit_box{
                               key="data14";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib14";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label15";
                           width=10; }
                     :edit_box{
                               key="data15";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib15";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label16";
                           width=10; }
                     :edit_box{
                               key="data16";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib16";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label17";
                           width=10; }
                     :edit_box{
                               key="data17";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib17";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label18";
                           width=10; }
                     :edit_box{
                               key="data18";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib18";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label19";
                           width=10; }
                     :edit_box{
                               key="data19";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib19";
                                 edit_width=12;
                                }
                    }//end of row
               }//end of column
        :column{
                :row{
                     :text{key="label20";
                           width=10; }
                     :edit_box{
                               key="data20";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib20";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label21";
                           width=10; }
                     :edit_box{
                               key="data21";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib21";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label22";
                           width=10; }
                     :edit_box{
                               key="data22";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib22";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label23";
                           width=10; }
                     :edit_box{
                               key="data23";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib23";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label24";
                           width=10; }
                     :edit_box{
                               key="data24";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib24";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label25";
                           width=10; }
                     :edit_box{
                               key="data25";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib25";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label26";
                           width=10; }
                     :edit_box{
                               key="data26";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib26";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label27";
                           width=10; }
                     :edit_box{
                               key="data27";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib27";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label28";
                           width=10; }
                     :edit_box{
                               key="data28";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib28";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label29";
                           width=10; }
                     :edit_box{
                               key="data29";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib29";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label30";
                           width=10; }
                     :edit_box{
                               key="data30";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib30";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label31";
                           width=10; }
                     :edit_box{
                               key="data31";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib31";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label32";
                           width=10; }
                     :edit_box{
                               key="data32";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib32";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label33";
                           width=10; }
                     :edit_box{
                               key="data33";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib33";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label34";
                           width=10; }
                     :edit_box{
                               key="data34";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib34";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label35";
                           width=10; }
                     :edit_box{
                               key="data35";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib35";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label36";
                           width=10; }
                     :edit_box{
                               key="data36";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib36";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label37";
                           width=10; }
                     :edit_box{
                               key="data37";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib37";
                                 edit_width=12;
                                }
                    }//end of row
                :row{
                     :text{key="label38";
                           width=10; }
                     :edit_box{
                               key="data38";
                               edit_width=12;
                              }
                     :popup_list{
                                 label= "辭庫選取";
                                 key="lib38";
                                 edit_width=12;
                                }
                    }//end of row
               }//end of column
       }//end of row

       :row{
             :spacer{width=20;}
         //  ok_only;
             ok_cancel;
             :button{
                     label="辭庫編修";
                     key="editlib";
                    }//end of button
             :spacer{width=20;}
           }
                errtile;

}


//╭════════════════════╮
//║設計日期:1996. 1. 3                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:圖框比例設定                   ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:SHSCAL.LSP                     ║
//╰════════════════════╯
autoshscal:dialog{
       label="藝祥資訊";
       :row{
          :list_box{
                     fixed_width_font=true;
                     label="圖紙型式:";
                     key="type";
                     width=20;
                     value=0;
                   }//end of list_box
          :list_box{
                     fixed_width_font=true;
                     label="圖紙尺寸:";
                     key="size";
                     width=20;
                     value=0;
                   }//end of list_box
       }//end of row
//     :boxed_column{label="圖框插入方式";
//                   :text{key="ssize";}
//
//                   :row{
//                        :radio_button{
//                                      label= "插入圖框(Insert)";
//                                      key="ins";
//                                      value="1";
//                                     }
//                        :radio_button{
//                                      label= "外部參考圖框(Xref)";
//                                      key="xref";
//                                     }
//                       }//end of row
//                    :text{label="請注意:以[外部參考圖框(Xref)]插入的圖框,不具有[屬性]功能!";}
//                  }//end of boxed_column
       spacer_1;
       :column{
           :row{
                : spacer { width = 13; }
                :text {
                        label=" 出圖公釐  =    圖形單位 ";
                        fixed_width_font=true;
                        //width=true;
                      }//text
               }//end of row
           :row{
                 :button{
                         label="設定比例..";
                         key="setcal";
                        }
                 :text {
                         label=":";
                       }//text
                 :edit_box{
                           key="out_mm";
                           edit_width=8;
                          }
                 :text {
                         label="=";
                       }//text
                 :edit_box{
                           key="out_unit";
                           edit_width=8;
                          }
               }//end of row
              }//end of column
      :text {
            key = "draw_limit";
            value="請選擇圖紙與比例!!";
            }//text
       spacer_1;
       ok_cancel;
       :text{key="errtxt";}

}

//╭════════════════════╮
//║設計日期:1999. 1. 27                    ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:圖紙變更                       ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:SHSCAL.LSP                     ║
//╰════════════════════╯
change_sheet:dialog{
       label="圖紙變更";
       :row{
          :list_box{
                     fixed_width_font=true;
                     label="圖紙型式:";
                     key="type";
                     width=20;
                     value=0;
                   }//end of list_box
          :list_box{
                     fixed_width_font=true;
                     label="圖紙尺寸:";
                     key="size";
                     width=20;
                     value=0;
                   }//end of list_box
       }//end of row
//     :radio_button{
//                   label= "插入圖框(Insert)";
//                   key="ins";
//                   value="1";
//                  }
       spacer_1;
       ok_cancel;
       errtile;

}

//╭════════════════════╮
//║設計日期:2002.11.21                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:設變資料                       ║
//║檔案名稱:                               ║
//║相關檔案:                               ║
//╰════════════════════╯
modify:dialog{
              label="輸入設變內容";
              :row{
                   :text{key="ver_label";
                         width=12;}
                   :spacer{width=20;}
                   :edit_box{
                             key="ver";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="name_label";
                         width=12;}
                   :edit_box{
                             key="name";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data1_label";
                         width=12;}
                   :edit_box{
                             key="data1";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data2_label";
                         width=12;}
                   :edit_box{
                             key="data2";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data3_label";
                         width=12;}
                   :edit_box{
                             key="data3";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data4_label";
                         width=12;}
                   :edit_box{
                             key="data4";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data5_label";
                         width=12;}
                   :edit_box{
                             key="data5";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data6_label";
                         width=12;}
                   :edit_box{
                             key="data6";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data7_label";
                         width=12;}
                   :edit_box{
                             key="data7";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data8_label";
                         width=12;}
                   :edit_box{
                             key="data8";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data9_label";
                         width=12;}
                   :edit_box{
                             key="data9";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="data10_label";
                         width=12;}
                   :edit_box{
                             key="data10";
                             edit_width=40;
                            }
                  }//end of row
              :row{
                   :text{key="date_label";
                         width=12;}
                   :edit_box{
                             key="date";
                             edit_width=40;
                            }
                  }//end of row

              ok_cancel;
              errtile;
}//end


