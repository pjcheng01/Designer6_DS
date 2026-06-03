
carqury:dialog{
               key="title";
           :list_box{key="text1";
                     width=82;
                     fixed_width_font=true;
                     height=19;}

           ok_only;

}

ironsize:dialog{
                key="title";
                :list_box{key="text1";
                          width=50;
                          fixed_width_font=true;
                          height=19;}

                ok_only;
}

function:dialog{
                key="title";
                :boxed_column{
                           :text{key="func1";
                                 width=32;}
                           :text{key="func2";
                                 width=32;}
                             }
                ok_only;
               }
