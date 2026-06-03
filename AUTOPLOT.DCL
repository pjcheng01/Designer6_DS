autoplot:dialog{
                key="title";
                :row{
                    :edit_box{label="圖檔路徑:";
                              width=40;
                              key="dwgpath";}
                    :button{label="檔名文字檔(*.txt)";
                            key="txtfile";
                           }
                    }
                :row{
                     :popup_list{
                                 label="出圖設備:";
                                 width=10;
                                 key="ploter";
                                }
                     :popup_list{
                                 label="紙張大小:";
                                 width=10;
                                 key="papersize";
                                }
                    }
                :list_box{
                          label="出圖檔案";
                          key="plotfile";
                          height=20;
                          width=16;
          //    fixed_width = true;
                          multiple_select = true;
                         }

                :row{
                     :button{label="加入";
                             key="addfile";}
                     :button{label="移除";
                             key="removefile";}
                     :button{label="全部移除";
                             key="allremove";}
                     :button{label="全選";
                             key="allselect";}
                  }

               spacer_1;
               ok_cancel;
               errtile;
}
