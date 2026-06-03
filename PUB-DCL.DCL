
//╭════════════════════╮
//║設計日期:1996.02. 25                    ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:文章編輯系統                   ║
//║檔案名稱:                               ║
//║相關檔案:                               ║
//╰════════════════════╯
word:dialog{
           label="藝祥資訊POWER EDIT 文章編輯系統";
           :text{key="filename";}
           :text{label="0123456789012345678901234567890123456789012345678901234567890123456789012";}
           :list_box{key="word_list";
                     fixed_width_font=true;
                     allow_accept=true;
                     initial_focus="edit_data";
                     width=95;
                     height=18;
                    }
           :text{label="對齊參考  01234567890123456789012345678901234567890123456789012345678901234";}
           :edit_box{
                     label="選項內容:";
                     fixed_width_font=true;
                     key="edit_data";
                     edit_width=86;
                    }
           :boxed_row{
              :button{
                      label="加入一列...";
                      key="add_col";
                     }
              :button{
                      label="原資料更新";
                      key="up_data";
                     }
              :button{
                      label="資料刪除...";
                      key="del_data";
                     }
                ok_only;
             }//end of row
            spacer_1;
            errtile;
}

//╭════════════════════╮
//║設計日期:1996.02. 25                    ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:文章編輯系統副對話框之一       ║
//║檔案名稱:                               ║
//║相關檔案:                               ║
//╰════════════════════╯
word1:dialog{
            label="加一列方式";
            :radio_button{
                          label="加在選項的上一列";
                          key="u_col";
                          value="1";
             }
            :radio_button{
                          label="加在選項的下一列";
                          key="d_col";
             }
             spacer_1;
             ok_cancel;
}
//╭════════════════════╮
//║設計日期:1996.02. 25                    ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:文章編輯系統副對話框之一       ║
//║檔案名稱:                               ║
//║相關檔案:                               ║
//╰════════════════════╯
word2:dialog{
            label="刪除資料方式";
            :radio_button{
                          label="刪除後該列保留空白";
                          key="dsave_col";
                          value="1";
             }
            :radio_button{
                          label="整列刪除";
                          key="dall_col";
             }
             spacer_1;
             ok_cancel;
}

//╭════════════════════╮
//║設計日期:1995.10.10                     ║
//║更新日期:                               ║
//║設計者:陳冠達                           ║
//║功能說明:警示框                         ║
//╰════════════════════╯
allert:dialog{
       label="Powersoft 警示訊息";
       spacer_1;
       :text{ key="ms_allert"; }
       spacer_1;
       ok_only;
      }

