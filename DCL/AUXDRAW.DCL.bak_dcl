//E型扣環
//軸用Ｃ型扣環標註
//孔用Ｃ型扣環標註
//Ｅ型扣環標註
//鑽孔攻牙(不通孔)
//鑽孔攻牙(不通孔)
//沉窩螺絲孔
//推拔螺絲孔
//==============================================================================
//╭════════════════════╮
//║設計日期:1996. 1. 3                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:圖框比例設定                   ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:SHSCAL.LSP                     ║
//╰════════════════════╯
shscal:dialog{
       label="藝祥資訊 POWERCAD";
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
               value="1";
               }
              :radio_button{
               label= "橫式";
               key="hor";
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
       spacer_1;
       :column{
           :row{
                : spacer { width = 13; }
                :text {
                        label="    出圖MM    =    圖形單位 ";
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
       spacer_1;
       ok_cancel;

      :text {
            key = "draw_limit";
            value="請選擇圖紙與比例!!";
            }//text
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
       label="藝祥資訊 POWERCAD";
       :list_box{
                 label="選擇比例";
                 key="scal_list";
                 width=15;
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
//║功能說明:畫多個L線                      ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:L_LINE.LSP                     ║
//╰════════════════════╯
l_line1:dialog{
       label="藝祥資訊 POWERCAD";

       :column{
              :image{
                     key="ll_sld";
                     height =5;
                     width=15;
                     color =-2;
                     }
               :edit_box{
                         label="各線間距";
                         key="l_dist";
                         value="10";
                         edit_width=8;
                        }
               :edit_box{
                         label="線數量";
                         key="l_qty";
                         edit_width=8;
                        }
              }//end of column

         spacer_1;
         ok_cancel;
        :text {
              key = "message";
              }//text
}

//╭════════════════════╮
//║設計日期:1996. 1. 3                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:選多個L線                      ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:L_LINE.LSP                     ║
//╰════════════════════╯
sel_l_line:dialog{
       label="藝祥資訊 POWERCAD";
       :text {
             label="請選擇轉折線路畫法型式";
             }//text
       :column{
         :row{
              :image_button{
                     key="lline_sld1";
                     height =5;
                     width=15;
                     color =-2;
                    }
              :image_button{
                     key="lline_sld2";
                     height =5;
                     width=15;
                     color =-2;
                    }
              :image_button{
                     key="lline_sld7";
                     height =5;
                     width=15;
                     color =-2;
                    }
              :image_button{
                     key="lline_sld8";
                     height =5;
                     width=15;
                     color =-2;
                    }
             }//end of row
         :row{
              :image_button{
                     key="lline_sld3";
                     height =5;
                     width=15;
                     color =-2;
                    }
              :image_button{
                     key="lline_sld4";
                     height =5;
                     width=15;
                     color =-2;
                    }
              :image_button{
                     key="lline_sld5";
                     height =5;
                     width=15;
                     color =-2;
                    }
              :image_button{
                     key="lline_sld6";
                     height =5;
                     width=15;
                     color =-2;
                    }
             }//end of row
        }//end of column
        ok_cancel;
        :text {
              key = "message";
              }//text
}

//╭════════════════════╮
//║設計日期:1996. 1. 22                    ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:線號編輯                       ║
//║檔案名稱:AUXDRAW.DCL                    ║
//║相關檔案:SIEDNUM.LSP                    ║
//╰════════════════════╯
siednum:dialog{
       key = "showhead";
       :edit_box{ label = "新線號";
                  key = "modnum" ;
                  edit_width =10;
                }
       spacer_1;
       ok_cancel;
       :text {
             key = "message";
             }//text
}

//╭════════════════════╮
//║設計日期: 1995.02.02                    ║
//║更新日期:                               ║
//║設 計 者: 陳冠達                        ║
//║功能說明: 簡易立體控制箱                ║
//║                                        ║
//║執行方式:                               ║
//║相關檔案: box1.lsp                      ║
//╰════════════════════╯
box1:dialog{
     label="請輸入相關參數";
     :column{
        :image{
               key="sh_sld";
               height =10;
               width=30;
               color =-2;
              }
        :boxed_column{
              :edit_box{
                        key="boxl";
                        label="寬度:";
                        edit_width=8;
                       }
              :edit_box{
                        label="深度:";
                        key="boxw";
                        edit_width=8;
                       }
              :edit_box{
                        label="高度:";
                        key="boxh";
                        edit_width=8;
                       }
            }//end of boxed_column
     }//end of column
     spacer_1;
     ok_cancel;
    :text { key = "message"; }

}

//╭════════════════════╮
//║設計日期:1996. 1. 5                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:面版孔顯示設定                 ║
//║檔案名稱:                               ║
//║相關檔案:facedisp.lsp                   ║
//╰════════════════════╯
facedisp:dialog{
          label="面版顯示選擇";
          :boxed_column{
                        label = "面版上材料圖形";
                        :radio_button{
                                 label= "顯示";
                                 key="upshow";
                                 value=1;}
                        :radio_button{
                                 label= "隱藏";
                                 key="uphide";}
                       }
          spacer_1;
          :boxed_column{
                        label = "面版孔圖形";
                        :radio_button{
                                 label= "顯示";
                                 key="holeshow";
                                 value=1;}
                        :radio_button{
                                 label= "隱藏";
                                 key="holehide";}
                       }
          spacer_1;
          :boxed_column{
                        label = "面版下材料圖形";
                        :radio_button{
                                 label= "顯示";
                                 key="btshow";
                                 value=1;}
                        :radio_button{
                                 label= "隱藏";
                                 key="bthide";}
                       }
          spacer_1;
          ok_cancel;

}

cringdim:dialog{
  label="軸用Ｃ型扣環";
   :row{
     :image_button{
        label="尺寸標註";
        color=-2;
        width=5;
        height=5;
        key="cring";
         }//end of image_button
      :boxed_radio_column{
         width=3;
         height=3;
       label="標註型式";
          :radio_button{
           label="扣環槽寬ｍ";
           key="cring2";
          }//end of radio_button
          :radio_button{
          label="扣環槽徑ｄ";
           key="cring3";
           }//end of radio_button
        }//end of boxed_radio_column
       }//end of row

    :row{
      :list_box{
        width=15;
        height=10;
       label="適用軸徑";
       key="list";
       }//end of list_box
          spacer_1;
          ok_cancel;
     }//end of row
     errtile;
    }//end

//==============================================================================
dringdim:dialog{
  label="孔用Ｃ型扣環";
   :row{
     :image_button{
        label="尺寸標註";
        color=-2;
        width=5;
        height=5;
        key="dring";
         }//end of image_button
      :boxed_radio_column{
         width=3;
         height=3;
       label="標註型式";
          :radio_button{
           label="扣環槽寬ｍ";
           key="dring2";
          }//end of radio_button
          :radio_button{
          label="扣環槽徑ｄ";
           key="dring3";
           }//end of radio_button
        }//end of boxed_radio_column
       }//end of row

    :row{
      :list_box{
        width=15;
        height=10;
       label="適用軸徑";
       key="list";
       }//end of list_box
          spacer_1;
          ok_cancel;
     }//end of row
     errtile;
    }//end
//===============================================================================

eringdim:dialog{
  label="Ｅ型扣環";
   :row{
     :image_button{
        label="尺寸標註";
        color=-2;
        width=5;
        height=5;
        key="ering";
         }//end of image_button
      :boxed_radio_column{
         width=3;
         height=3;
       label="標註型式";
          :radio_button{
           label="扣環槽寬ｍ";
           key="ering2";
          }//end of radio_button
          :radio_button{
          label="扣環槽徑ｄ";
           key="ering3";
           }//end of radio_button
        }//end of boxed_radio_column
       }//end of row

    :row{
      :list_box{
        width=15;
        height=10;
       label="適用軸徑";
       key="list";
       }//end of list_box
          spacer_1;
          ok_cancel;
     }//end of row
     errtile;
    }//end
//===============================================================================

e_cring:dialog{
  label="軸用Ｃ型扣環";
   :row{
    :column{
     :boxed_radio_column{
       :radio_button{
         label="距軸端";
         key="radio1";
         }//end of radio_button
       :radio_button{
         label="距某定點";
         key="radio2";
         }//end of radio_button
       }//end of boxed_radio_column
      :edit_box{
        label="距離";
        key="edit1";
        edit_width=10;
        }//end of edit_box
//    :edit_box{
//      label="角度";
//      key="edit2";
//      }//end of edit_box
      }//end of column

    :boxed_radio_column{
      label="種類";
      :radio_button{
        label="軸用Ｃ型扣環";
        key="radio3";
        }//end of radio_button
      :radio_button{
        label="孔用Ｃ型扣環";
        key="radio4";
        }//end of radio_button
      :radio_button{
        label="Ｅ型扣環";
        key="radio5";
        }//end of radio_button
     }//end of boxed_radio_column
   }//end of row
      errtile;
      ok_cancel;
}//end
///========================
e_cringhelp1:dialog{
  :column{
   :text{
    label="標準尺寸=10 11 12 13 14 15 16 17";
   }
   :text{
    label="18 19 20 21 22 24 25 26 28 29 30";
   }
   :text{
    label="32 34 35 36 38 40 42 45 48 50 52";
   }
   :text{
    label="55 56 58 60 62 63 65 68 70 72 75";
   }
   :text{
    label="78 80 82 85 88 88 90 95 100 105 ";
   }
   :text{
    label="110 115 120 125";
   }
   :row{
    :column{
      :edit_box{
        label="ｄ２ 軸徑=";
        edit_width=2;
        key="edit_help1";
      }//end of edit_box
     :edit_box{
        label="　ｍ 值=";
        edit_width=2;
        key="edit_help2";
       }//end of edit_box
     }//end of column
   :image_button{
     key="image_help1";
        width=10;
        height=5;
     color=-2;
    }//end of image_button
   }//end of row
 }//end of column
  errtile;
  ok_cancel;
// spacer_1;
}
///====================================
e_cringhelp2:dialog{
  :column{
   :text{
    label="標準尺寸=10 11 12 13 14 15 16 17";
   }
   :text{
    label="18 19 20 21 22 24 25 26 28 30 32";
   }
   :text{
    label="34 35 36 37 38 40 42 45 47 48 50";
   }
   :text{
    label="52 55 56 58 60 62 63 65 68 70 72";
   }
   :text{
    label="75 78 80 82 85 88 90 92 95 98 100";
   }
   :text{
    label="102 105 108 110 112 115 120 125";
   }
   :row{
    :column{
      :edit_box{
        label="ｄ２ 軸徑=";
        edit_width=2;
        key="edit_help1";
      }//end of edit_box
     :edit_box{
        label="　ｍ 值=";
        edit_width=2;
        key="edit_help2";
       }//end of edit_box
     }//end of column
   :image_button{
     key="image_help1";
        width=10;
        height=5;
     color=-2;
    }//end of image_button
   }//end of row
 }//end of column
  errtile;
  ok_cancel;
// spacer_1;
}
////=========================================
e_cringhelp3:dialog{
  :column{
   :text{
    label="標準尺寸=0.8 1.2 1.5 2 2.5 3 4 5";
   }
   :text{
    label="6 7 8 9 10 12 15 19 24";
   }//end of text
   :row{
    :column{
      :edit_box{
        label="ｄ２ 軸徑=";
        edit_width=2;
        key="edit_help1";
      }//end of edit_box
     :edit_box{
        label="　ｍ 值=";
        edit_width=2;
        key="edit_help2";
       }//end of edit_box
     }//end of column
   :image_button{
     key="image_help1";
        width=10;
        height=5;
     color=-2;
    }//end of image_button
   }//end of row
 }//end of column
  errtile;
  ok_cancel;
// spacer_1;
}

//鑽孔攻牙(不通孔)
//==============================================================================
thrill:dialog{
        label="攻螺絲深度";
        :row{
             :column{
                    :row{
                                 :boxed_column{label="中心線";
                                               :radio_button{label="畫";
                                                             value=1;
                                                             key="cenl";}
                                               :radio_button{label="不畫";
                                                             key="nocenl";}
                                              }//end of boxed_clumn
                    :boxed_column{label="選擇視圖";
                                  :row{
                                       :image_button{
                                                     key="views";
                                                     width=18;
                                                     height=5;
                                                     color=-2;
                                                    }
                                       :image_button{
                                                     key="viewf";
                                                     width=18;
                                                     height=5;
                                                     color=-2;
                                                    }
                                       }//end ofrow
                                  :row{
                                       :image_button{
                                                     key="hviewf";
                                                     width=18;
                                                     height=5;
                                                     color=-2;
                                                    }
                                       :image_button{
                                                     key="hviews";
                                                     width=18;
                                                     height=5;
                                                     color=-2;
                                                    }
                                       }//end ofrow

                                  }//end of boxed_column
                        }//end of row
                      :row{
                           :boxed_column{label="選擇尺寸";
                                   :row{
                                        :radio_button{label="公制";
                                                      value=1;
                                                      key="thrill-m";}
                                        :radio_button{label="英制";
                                                      key="thrill-i";}
                                       }//end of row
                                   :list_box{
                                             label="螺紋尺寸";
                                             key="size_list";
                                             width=17;
                                             value=1;
                                             height=10;
                                            }//end of list_box
                                  }//end of column

                        // :column{
                                   :boxed_column{label="工件材料";
                                                 :radio_button{label="鋼,鑄鋼,青銅,青銅鑄件";
                                                               value=1;
                                                               key="mat1";}
                                                 :radio_button{label="鑄鐵";
                                                               key="mat2";}
                                                 :radio_button{label="鋁其他輕合金系";
                                                               key="mat3";}
                                                 :radio_button{label="攻牙深度=螺紋尺寸x 2";
                                                               key="mat4";}
                                                      :radio_button{label="攻牙深度=螺紋尺寸x ?? 倍 ";
                                                                     key="mat5";}
                                                 :row{
                                                      :edit_box{label="請輸入倍數:";
                                                                edit_width=4;
                                                                key="ss";
                                                               }//end of edit_box
                                                      :spacer{width=10;}
                                                     }//end of row
                                                 }//end of boxed_column
                         //       }//end of column
                          }//end of row
                    }//end of column
                :boxed_column{label="加工資料";
                        :image{
                               key="viewd";
                               width=30;
                               height=12;
                               color=-2;
                              }
                    //  :row{:text{label="鑽孔尺寸d:";}
                    //       :text{key="drillsize";
                    //             fixed_width_font=true;
                    //             width=14;}
                    //      }
                        :row{
                             :edit_box{label="鑽孔尺寸d:";
                                       key="drillsize";
                                       edit_width=14;}
                             :spacer{width=5;}
                            }
                        :row{:text{label="攻牙尺寸D:";}
                             :text{key="thrillsize";
                                   fixed_width_font=true;
                                   width=14;}
                            }
                        :edit_box{label="鑽孔深度h:";
                                  key="drillh";}
                        :edit_box{label="攻牙深度H:";
                                  key="thrillh";}
                        :edit_box{label="中心線延伸距離:";
                                  value=3;
                                  key="cline";}
                       }//end of column
            }//end of row
           ok_cancel;
           errtile;
}

//鑽孔攻牙(通孔)
thrill2:dialog{
        label="攻螺絲";
        :row{
             label="選擇尺寸";
             :column{
                    :boxed_column{
                                  :radio_button{label="公制";
                                                value=1;
                                                key="mm";}
                                  :radio_button{label="英制";
                                                key="inch";}
                                  }//end of boxed_column
                    :boxed_column{
                                  :radio_button{label="實線";
                                                value=1;
                                                key="sl";}
                                  :radio_button{label="虛線";
                                                key="dl";}
                                  }//end of boxed_column
                     spacer_1;
                     spacer_1;
                     spacer_1;
                    }//end of column
             :list_box{
                       label="螺紋尺寸";
                       fixed_width_font=true;
                       key="size_list";
                       width=13;
                       height=18;
                      }//end of list_box
            }//end of row
        ok_cancel;
        errtile;
}

//沉窩螺絲孔
thrill3:dialog{
        label="沉窩螺絲孔";
        :boxed_row{
                   label="視圖選擇";
                   :image_button{
                                key="top";
                                height =5;
                                width=10;
                                color =-2;
                               }
                   :image_button{
                                key="side";
                                height =5;
                                width=10;
                                color =-2;
                   }
            }//end of boxed_row
        :row{
             label="選擇尺寸";
             :column{
                    :boxed_column{
                                  :radio_button{label="公制";
                                                value=1;
                                                key="mm";}
                                  :radio_button{label="英制";
                                                key="inch";}
                                  }//end of boxed_column
                    :boxed_column{
                                  :radio_button{label="實線";
                                                value=1;
                                                key="sl";}
                                  :radio_button{label="虛線";
                                                key="dl";}
                                  }//end of boxed_column
                    }//end of column
             :list_box{
                       label="螺紋尺寸";
                       fixed_width_font=true;
                       key="size_list";
                       width=13;
                       height=13;
                      }//end of list_box
            }//end of row
        ok_cancel;
        errtile;
}

//推拔螺絲孔
thrill4:dialog{
        label="推拔螺絲孔";
        :boxed_row{
                   label="視圖選擇";
                   :image_button{
                                key="top";
                                height =5;
                                width=10;
                                color =-2;
                               }
                   :image_button{
                                key="side";
                                height =5;
                                width=10;
                                color =-2;
                   }
            }//end of boxed_row
        :column{
             label="選擇尺寸";
             :boxed_row{
                        :radio_button{label="實線";
                                      value=1;
                                      key="sl";}
                        :radio_button{label="虛線";
                                      key="dl";}
                        }//end of boxed_row
             :list_box{
                       label="螺紋尺寸";
                       fixed_width_font=true;
                       key="size_list";
                       width=13;
                       height=13;
                      }//end of list_box
            }//end of column
        ok_cancel;
        errtile;
}

//改良型 OFFSET
aoff:dialog{
            initial_focus        = "dist";
            label="改良型 OFFSET";
            :edit_box{
                      label="偏移距離:";
                      key="dist";
                      edit_width=6;
                     }
            :text{label="偏移距離若沒輸入，則由使用者自由點選!!";}
            spacer_1;
            :popup_list{
                        label="偏移後線型:";
                        width=12;
                        height=5;
                        value=1;
                        key="ltype";
                       }
            spacer_1;
           ok_cancel;
           errtile;
}

//("標  稱"   "(外)外徑(內)根徑"  "(外)根徑(內)內徑"  "平行有效內螺紋長度" "推拔有效內螺紋長度" "有效外螺紋長度")
pipscrew:dialog{
                label="管用內螺紋";
         :boxed_column{label="選擇視圖";
              :row{
              :image_button{
                     key="top_sld";
                     height =5;
                     width=5;
                     color =-2;
                    }
              :image_button{
                     key="side_sld";
                     height =5;
                     width=5;
                     color =-2;
                    }
              :image_button{
                     key="butm_sld";
                     height =5;
                     width=5;
                     color =-2;
                    }
                  }//end of row
             }//end of boxed_column
                :list_box{
                          label="選擇標稱";
                          key="size";
                          width=10;
                          height=10;
                          fixed_width_font=true;
                         }//end of list_box
                :row{
                :boxed_column{label="選擇有效內螺紋長度";
                              :row{
                                   :radio_button{
                                                 label= "推拔內螺紋:";
                                                 key="tappip";
                                                }
                                   :text{key="tappip_size";
                                         width=10;}
                                   }//end of row
                              :row{
                                   :radio_button{
                                                 label= "平行內螺紋:";
                                                 key="parpip";
                                                 value="1";
                                                }
                                   :text{key="parpip_size";
                                         width=10;}
                                   }//end of row
                             }//end of boxed_column
             :boxed_column{label="線型";
                        :radio_button{label="實線";
                                      value=1;
                                      key="sl";}
                        :radio_button{label="虛線";
                                      key="dl";}
                        }//end of boxed_row
                    }//end of row
                spacer_1;
                ok_cancel;
                errtile;
}//end of dialog
