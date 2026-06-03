btplot:dialog{label="批次出圖";
	:boxed_column{:row{:edit_box{label="檔 案:";edit_width=25;key="FLE";}
			   :button{label="選取檔案";width=15;key="SEL";}}
		      :row{:edit_box{label="張 數:";edit_width=25;key="NUM";}
		      	   :spacer{width=15;}}
		      :spacer{height=0.5;}
		      :row{:button{label="新 增";key="ADD";}
		           :button{label="刪 除";key="DEL";}}
		      :list_box{key="LST";}
		     }
		     :row{:button{label="出 圖";key="accept";}
		     	  :button{label="取 消";is_cancel=true;}}
		}