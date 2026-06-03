setup:dialog{
             label="安裝藝祥機械設計家系統";
             initial_focus="install_disk";
                  :boxed_column{label="您使用藝祥哪些產品";
                                :toggle{label="機械設計家";
                                        value=1;
                                        key="design50";}
                                :toggle{label="POWERISO 等角立體系統圖";
                                        key="poweriso";}
                                :toggle{label="POWERPARTS 機械元件系統";
                                        key="powparts";}
                    //          :toggle{label="POWER MANAGER 圖檔管理系統";
                    //                     key="fm";}
                                :toggle{label="與 PowerPDM 系統聯結";
                                           key="powerpdm";}
                               }
                       :boxed_column{label="機械設計家";
                                     :edit_box{label="機械設計家安裝路徑:";
                                               key="design50_path";
                                               edit_width=50;}
                                     :edit_box{label="系統資料庫路徑(辭庫)";
                                                key="database_path";
                                               edit_width=50;}
                                      :edit_box{label="圖庫系統(ITEM*)路徑";
                                                key="block_path";
                                               edit_width=50;}
                                    }//end of boxed_column
                                :edit_box{label="POWERISO安裝路徑:";
                                           key="poweriso_path";
                                           edit_width=50;}
                                :edit_box{label="POWERPARTS安裝路徑:";
                                           key="powparts_path";
                                           edit_width=50;}
           //                   :edit_box{label="POWER MANAGER安裝路徑:";
           //                             key="fm_path";
           //                            edit_width=30;}
                          :edit_box{key="pdmserver_path";
                                    label="圖文管理系統 Server 端路徑:";
                                   edit_width=50;}
                          :edit_box{key="pdmclient_path";
                                    label="圖文管理系統 Client 端路徑:";
                                   edit_width=50;}
                          :edit_box{key="atttxt_path";
                                    label="PowerPDM 圖文管理系統屬性萃取檔路徑:";
                                    edit_width=50;}
                           :popup_list{label="CAD拆零件時機種命名方式:";
                                       width=8;
                                       height=4;
                                       key="pout_typ";}
                           :popup_list{label="存圖時自動PURGE不存在的BLOCK:";
                                       width=8;
                                       height=4;
                                       key="purg_blk";}
             spacer_1;
             ok_cancel;
             errtile;
}//end of setup

allert:dialog{
       key="messlable";
       spacer_1;
       :text{ key="ms_allert1";
              width=60;
       }
       :text{ key="ms_allert2";
              width=60;
       }
       spacer_1;
       ok_cancel;
      }
allert1:dialog{
       key="messlable";
       spacer_1;
       :text{ key="ms_allert1";
              fixed_width_font=true;
              width=60;
       }
       spacer_1;
       ok_only;
      }
