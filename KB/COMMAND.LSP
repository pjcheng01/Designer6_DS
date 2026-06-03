;;;
;;;
;;;
;;(if (= 0 (getvar "dimscale")) (setvar "dimscale" 1))
;;(setvar "dimtdec" 8)
;;=============================================================================================
(defun c:autoload()
 (if (or (null POWDESIGN_path)(/= jin "#$%")(/= #### 85))
   (progn
     (princ "\n藝祥機械設計家系統載入中...")
     (load "designer")
     (if (null POWDESIGN_path)
         (load "config")
     );if
     (loaddesigner)
   )
 )
)



;;使用者自定圖庫
(defun c:userblk1()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC) (cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "BOM2" "poweriso" 0))
(defun c:userblk2()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "BOM2" "poweriso" 0))

;;油氣壓符號
(defun c:oilgas1()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC) (cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "GASE&OIL" "poweriso" 0))
(defun c:oilgas2()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "GASE&OIL" "poweriso" 0))

;;油壓缸
(defun c:OILTANK1()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "OILTANK" "poweriso" 0))
(defun c:OILTANK2()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "OILTANK" "poweriso" 0))
;;氣壓缸
(defun c:GASTANK1()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "GASTANK" "poweriso" 0))
(defun c:GASTANK2()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "GASTANK" "poweriso" 0))
;;直線滾珠襯套
(defun c:LINEBUSH1()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "LINEBUSH" "poweriso" 0))
(defun c:LINEBUSH2()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "LINEBUSH" "poweriso" 0))
;;微動開關
(defun c:LINESWITCH1()(c:autoload)(setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "LINESWITCH" "poweriso" 0))
(defun c:LINESWITCH2()(c:autoload)(setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "LINESWITCH" "poweriso" 0))
;;線性滑軌
(defun c:LINERULE1()(c:autoload)(setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "LINERULE" "poweriso" 0))
(defun c:LINERULE2()(c:autoload)(setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "LINERULE" "poweriso" 0))
;;快速夾具
(defun c:QUICKTAH1()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "QUICKTAH" "poweriso" 0))
(defun c:QUICKTAH2()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "QUICKTAH" "poweriso" 0))
;;環首桿
(defun c:HRINGS1()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblku "userblkm" "userblkm" "HRINGS" "poweriso" 0))
(defun c:HRINGS2()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "HRINGS" "poweriso" 0))

(defun c:callcalc()(c:autoload) (startapp "calc"))
(defun c:manauser_menu()(c:autoload)(cond ((null c:manamenu)(load "userMENU"))(t (princ))) (c:manamenu "usermenu.mnu" "usermenu" "manamenu"))
(defun loaddesigner()(cond ((null c:#setting)(load "system"))(t (princ))))


(setq  sysdrawbar1     "輔助繪圖(一)"
       sysdrawbar2     "輔助繪圖(二)"
       syseditbar1     "輔助編輯(一)"
       syseditbar2     "輔助編輯(二)"
       sysprojbar      "投影線"
       syssetlinebar   "作圖線性設定"
       sysauxdimbar1   "輔助標註一"
       sysauxdimbar2   "輔助標註二"
       sysauxdimbar3   "幾合公差標註"
       sysbombar       "組合圖與材料清單"
       syslayerbar     "圖層控制"
       sysquarbar      "資料查詢"
       sysscrewbar     "鍵槽與螺紋"
       sysshaftbar     "軸產生器"
       sysosnapbar     "鎖點模式組"
       sysshscalbar    "放圖框定比例"
       sysblkmanbar    "開放圖庫"
       syscal&lib      "辭庫與計算機")

(defun c:chtobyl()(c:autoload) (CHLTYPE "bylayer" "bylayer"))
(defun c:chtobylk()(c:autoload) (CHLTYPE "byblock" "byblock"))
(defun c:chtosl()(c:autoload)   (CHLTYPE sys_CONT_ltype sys_CONT_ltypecol))
(defun c:chtocl()(c:autoload)   (CHLTYPE sys_center_ltype sys_center_ltypecol))
(defun c:chtocl2()(c:autoload)   (CHLTYPE sys_stcenter_ltype sys_stcenter_ltypecol))
(defun c:chtotl()(c:autoload)   (CHLTYPE sys_CONT1_ltype sys_CONT1_ltypecol))
(defun c:chtodl()(c:autoload)   (CHLTYPE sys_dashed_ltype sys_dashed_ltypecol))
(defun c:chtoSdl()(c:autoload)   (CHLTYPE sys_Sdashed_ltype sys_Sdashed_ltypecol))
(defun c:chtopl()(c:autoload)   (CHLTYPE sys_phantom_ltype sys_phantom_ltypecol))
(defun c:chtoSpl()(c:autoload)   (CHLTYPE sys_Sphantom_ltype sys_Sphantom_ltypecol))
(defun c:chtohl()(c:autoload)   (CHLTYPE sys_hatch_ltype sys_hatch_ltypecol))

;;功能表指令
(defun c:&cns_finish()(c:autoload) (cond ((null c:cns_finish)(load "auxdim"))(t (princ))) (c:cns_finish))            ;[CNS 加工符號]
(defun c:&out_l_r_arc()(c:autoload) (cond ((null c:out_l_r_arc)(load "auxdim"))(t (princ))) (c:out_l_r_arc))         ;[左右括號]
(defun c:&out_cns_finish()(c:autoload) (cond ((null c:out_cns_finish)(load "auxdim"))(t (princ))) (c:out_cns_finish));[整體性加工符號]
(defun c:&jis_finish()(c:autoload) (cond ((null c:jis_finish)(load "auxdim"))(t (princ))) (c:jis_finish))            ;[JIS 加工符號]
;;-------
(defun c:&autoSHSCAL()(c:autoload) (cond ((null c:SHSCAL)(load "SHSCAL"))(t (princ))) (c:autoSHSCAL)) ;[放圖框定比例]
(defun c:&resetting()(c:autoload) (cond ((null c:resetting)(load "SHSCAL"))(t (princ))) (c:resetting)) ;[重設比例]
(defun c:&SCAL()(c:autoload) (cond ((null c:scal)(load "aux-qury"))(t (princ))) (c:SCAL)) ;[比例查詢]
(defun c:&chsheet_att()(c:autoload) (cond ((null c:chsheet_att)(load "SHSCAL"))(t (princ))) (c:chsheet_att)) ;[修改圖框屬性]
(defun c:&autoplot()(c:autoload) (cond ((null c:autoplot)(load "autoplot"))(t (princ))) (c:autoplot)) ;[自動連續出圖]
(defun c:&draw_autoplot()(c:autoload) (cond ((null c:draw_autoplot)(load "plotset"))(t (princ))) (c:draw_autoplot)) ;[自動連續出圖]
;;-------
(defun c:&cap_sybom()(c:autoload) (cond ((null c:cap_sybom)(load "PDMBOM3"))(t (princ))) (c:cap_sybom))
(defun c:&insline()(c:autoload) (cond ((null c:insline)(load "insline"))(t (princ))) (c:insline))
(defun c:&hp()(c:autoload) (cond ((null c:hp)(load "hp-k"))(t (princ))) (c:hp))
(defun c:&hp2()(c:autoload) (cond ((null c:hp2)(load "hp-k"))(t (princ))) (c:hp2))
(defun c:&hp3()(c:autoload) (cond ((null c:hp3)(load "hp-k"))(t (princ))) (c:hp3))
(defun c:&batch_plot()(c:autoload) (cond ((null c:batch_plot)(load "hp-k"))(t (princ))) (c:batch_plot))
;;-------
(defun c:&asctext()(c:autoload) (cond ((null c:asctext)(load "asctext"))(t (princ))) (c:asctext)) ;[載入文字檔]
;;-------
(defun c:&chtosl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtosl))   ;[粗連續線]
(defun c:&chtotl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtotl))   ;[細連續線]
(defun c:&chtocl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtocl))   ;[標準中心線]
(defun c:&chtocl2()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtocl2)) ;[短中心線]
(defun c:&chtodl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtodl))   ;[標準虛線]
(defun c:&chtoSdl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtoSdl)) ;[短虛線]
(defun c:&chtopl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtopl))   ;[標準假想線]
(defun c:&chtoSpl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtoSpl)) ;[短假想線]
(defun c:&chtohl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtohl))   ;[剖面線]
(defun c:&chtodim()(c:autoload) (chltype "continuous" "3")) ;[尺寸線]

;;--------系統變數設定
(defun c:&tran_act()(c:autoload)(load "tran_act") (c:tran_act));舊圖轉新圖(應用)

(defun c:&transdwg()(c:autoload)(load "transdwg") (c:transdwg));舊圖轉新圖(設定)
(defun c:&auto_ch_clk_scal()(c:autoload) (cond ((null c:setosmode)(load "dfsystem"))(t (princ))) (c:auto_ch_clk_scal)) ;[比例變動時會連動的BLOCK
(defun c:&setosmode()(c:autoload) (cond ((null c:setosmode)(load "dfsystem"))(t (princ))) (c:setosmode)) ;[鎖點模式組別定義]
(defun c:&defball()(c:autoload) (cond ((null c:defball)(load "dfsystem"))(t (princ)))(c:defball)) ;[指標球定義]
(defun c:&defbomlist()(c:autoload) (cond ((null c:defbomlist)(load "dfsystem"))(t (princ)))(c:defbomlist)) ;[材料清單欄寬定義]
(defun c:&defltype()(c:autoload) (cond ((null c:defltype)(load "dfsystem"))(t (princ)))(c:defltype)) ;[設定線型系統變數]
(defun c:&deflayer()(c:autoload) (cond ((null c:deflayer)(load "dfsystem"))(t (princ)))(c:deflayer)) ;[設定圖層系統變數]
(defun c:&defdate_type()(c:autoload) (cond ((null c:defdate_type)(load "dfsystem"))(t (princ)))(c:defdate_type)) ;[圖框日期型式]
(defun c:&passdfac()(c:autoload) (cond ((null c:passdfac)(load "dfsystem"))(t (princ))) (c:passdfac))    ;零件組合時預設之顏色                    ;零件組合時預設之顏色]^C^C
(defun c:&psdellay()(c:autoload) (cond ((null c:psdellay)(load "dfsystem"))(t (princ))) (c:psdellay))    ;零件組合時刪除之圖層
(defun c:&psdelblk()(c:autoload) (cond ((null c:psdelblk)(load "dfsystem"))(t (princ))) (c:psdelblk))    ;零件組合時刪除之圖塊
(defun c:&auntklay()(c:autoload) (cond ((null c:auntklay)(load "dfsystem"))(t (princ))) (c:auntklay))    ;自動拆圖時不拆之層
(defun c:&ncinplay()(c:autoload) (cond ((null c:ncinplay)(load "dfsystem"))(t (princ))) (c:ncinplay))    ;不建立資訊點的圖層
(defun c:&auntkblk()(c:autoload) (cond ((null c:auntkblk)(load "dfsystem"))(t (princ))) (c:auntkblk))    ;自動拆圖時不拆之圖塊
(defun c:&lt_prtdd()(c:autoload) (cond ((null c:lt_prtdd)(load "dfsystem"))(t (princ))) (c:lt_prtdd))    ;零件定義資料
(defun c:&goac_inp()(c:autoload) (cond ((null c:goac_inp)(load "dfsystem"))(t (princ))) (c:goac_inp))    ;取舊圖框屬性建資訊點
(defun c:&odshtblk()(c:autoload) (cond ((null c:odshtblk)(load "dfsystem"))(t (princ))) (c:odshtblk))    ;舊圖框屬性BLOCK名稱
(defun c:&lt_map()(c:autoload) (cond ((null c:lt_map)(load "dfsystem"))(t (princ))) (c:lt_map))        ;舊圖框屬性對應資訊籤
(defun c:&trapmage()(c:autoload) (cond ((null c:trapmage)(load "dfsystem"))(t (princ))) (c:trapmage))  ;推拔系統管理
(defun c:&signing()(c:autoload) (cond ((null c:signing)(load "dfsystem"))(t (princ))) (c:signing));審核簽名資料
(defun c:&sheetset()(c:autoload) (cond ((null c:sheetset)(load "sheetset"))(t (princ)))(c:sheetset)) ;[圖框設定]
(defun c:&modsheetset()(c:autoload) (cond ((null c:modsheetset)(load "sheetset"))(t (princ)))(c:modsheetset)) ;[修改圖框設定]
;;--------
(defun c:&manauser_menu()(c:autoload) (cond ((null c:usermake_part_sld)(load "userMENU"))(t (princ))) (c:manauser_menu)) ;[管理自建功能]
(defun c:&usermake_part_sld()(c:autoload) (cond ((null c:usermake_part_sld)(load "userMENU"))(t (princ)))(c:usermake_part_sld)) ;[製作功能幻燈片]
;;;--------
(defun c:&mc()(c:autoload) (cond ((null c:mc)(load "auxdraw1"))(t (princ))) (c:mc)) ;畫環形圓
(defun c:&POLCIR()(c:autoload) (cond ((null c:POLCIR)(load "auxdraw1"))(t (princ))) (c:POLCIR)) ;距離-角度 圓
(defun c:&XYCIR()(c:autoload) (cond ((null c:XYCIR)(load "auxdraw1"))(t (princ))) (c:XYCIR))    ;X-Y 圓
(defun c:&2cir()(c:autoload) (cond ((null c:2cir)(load "auxdraw1"))(t (princ))) (c:2cir))       ;等角度畫圓
(defun c:&3e()(c:autoload) (cond ((null c:3e)(load "auxdraw1"))(t (princ))) (c:3e))             ;矩形
(defun c:&srect()(c:autoload) (cond ((null c:srect)(load "auxdraw1"))(t (princ))) (c:srect))    ;矩形
(defun c:&crect()(c:autoload) (cond ((null c:crect)(load "auxdraw1"))(t (princ))) (c:crect))    ;矩形
(defun c:&srect1()(c:autoload) (cond ((null c:srect1)(load "auxdraw1"))(t (princ))) (c:srect1)) ;矩形
(defun c:&mrect()(c:autoload) (cond ((null c:mrect)(load "auxdraw1"))(t (princ))) (c:mrect))    ;矩形
(defun c:&codim()(c:autoload) (cond ((null c:co)(load "auxdraw1"))(t (princ))) (c:codim))       ;圓角輔助標註圖形
(defun c:&codim1()(c:autoload) (cond ((null c:co1)(load "auxdraw1"))(t (princ))) (c:codim1))    ;圓角輔助標註圖形
(defun c:&c-slot()(c:autoload) (cond ((null c:c-slot)(load "auxedit"))(t (princ))) (c:c-slot))  ;鈑金件彎形孔
;;;--------
(defun c:&sec5()(c:autoload) (cond ((null c:sec5)(load "auxdraw1"))(t (princ)))(c:sec5)) ;連續剖面
(defun c:&sec1()(c:autoload) (cond ((null c:sec1)(load "auxdraw1"))(t (princ)))(c:sec1)) ;剖面
(defun c:&sec2()(c:autoload) (cond ((null c:sec2)(load "auxdraw1"))(t (princ)))(c:sec2)) ;剖面文字
(defun c:&sec3()(c:autoload) (cond ((null c:sec3)(load "auxdraw1"))(t (princ)))(c:sec3)) ;詳圖文字
(defun c:&sec4()(c:autoload) (cond ((null c:sec4)(load "auxdraw1"))(t (princ)))(c:sec4)) ;詳圖指標
(defun c:&sec6()(c:autoload) (cond ((null c:sec6)(load "auxdraw1"))(t (princ)))(c:sec6)) ;詳圖指標( ? 矢視圖)
(defun c:&cen1()(c:autoload) (cond ((null c:cen1)(load "auxdraw1"))(t (princ)))(c:cen1)) ;軸中心線
(defun c:&cen2()(c:autoload) (cond ((null c:cen2)(load "auxdraw1"))(t (princ)))(c:cen2)) ;圓中心線
(defun c:&stock()(c:autoload) (cond ((null c:stock)(load "auxdraw1"))(t (princ)))(c:stock)) ;輔助畫三視圖
(defun c:&mcir()(c:autoload) (cond ((null c:wcir)(load "auxdraw1"))(t (princ)))(c:mcir)) ;同心圓
(defun c:&wedmark()(c:autoload) (cond ((null c:wedmark)(load "auxdim"))(t (princ)))(c:wedmark)) ;熔接點
(defun c:&holemark()(c:autoload) (cond ((null c:holemark)(load "auxdraw1"))(t (princ)))(c:holemark)) ;精準孔符號
;;;--------
(defun c:&chtobyl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ)))(c:chtobyl))    ;變換成BYLAYER線性
(defun c:&chtobylk()(c:autoload) (cond ((null c:chtobylk)(load "auxedit"))(t (princ)))(c:chtobylk)) ;變換成BYBLOCK線性
(defun c:&chtosl()(c:autoload) (cond ((null c:chtosl)(load "auxedit"))(t (princ)))(c:chtosl))    ;變換粗連續線性
(defun c:&chtocl()(c:autoload) (cond ((null c:chtocl)(load "auxedit"))(t (princ)))(c:chtocl))    ;變換標準中心線性
(defun c:&chtocl2()(c:autoload) (cond ((null c:chtocl2)(load "auxedit"))(t (princ)))(c:chtocl2)) ;變換短中心線性
(defun c:&chtotl()(c:autoload) (cond ((null c:chtotl)(load "auxedit"))(t (princ)))(c:chtotl))    ;變換細連續線性
(defun c:&chtodl()(c:autoload) (cond ((null c:chtodl)(load "auxedit"))(t (princ)))(c:chtodl))    ;變換虛線性
(defun c:&chtopl()(c:autoload) (cond ((null c:chtopl)(load "auxedit"))(t (princ)))(c:chtopl))    ;變換假想線性
(defun c:&chtohl()(c:autoload) (cond ((null c:chtohl)(load "auxedit"))(t (princ)))(c:chtohl))    ;變換剖面線性
(defun c:&1CHAM()(c:autoload) (cond ((null c:1CHAM)(load "auxedit"))(t (princ)))(c:1CHAM))    ;保留一邊導角
(defun c:&1FILL()(c:autoload) (cond ((null c:1FILL)(load "auxedit"))(t (princ)))(c:1FILL))    ;保留一邊圓角
(defun c:&c&r&lt()(c:autoload) (cond ((null c:c&r&lt)(load "auxedit"))(t (princ)))(c:c&r&lt)) ;拷貝,旋轉換線性
(defun c:&c&r&la()(c:autoload) (cond ((null c:c&r&la)(load "auxedit"))(t (princ)))(c:c&r&la)) ;拷貝,旋轉換圖層
(defun c:&c&s()(c:autoload) (cond ((null c:c&s)(load "auxedit"))(t (princ)))(c:c&s))          ;拷貝並縮放比例
;;;輔助編輯(二)
(defun c:&bshaft()(c:autoload) (cond ((null c:bshaft)(load "auxedit"))(t (princ)))(C:bshaft))         ;截斷軸
(defun c:&sheetbrk()(c:autoload) (cond ((null c:sheetbrk)(load "auxdraw"))(t (princ))) (c:sheetbrk))  ;鈑金截斷線
(defun c:&mbreak()(c:autoload)   (cond ((null c:mbreak)(load "auxdraw1"))(t (princ))) (c:mbreak))     ;連續原點截斷
(defun c:&mbrl()(c:autoload)     (cond ((null c:mbrl)(load "auxdraw1"))(t (princ))) (c:mbrl))         ;連續截斷交叉點
(defun c:&cirhi()(c:autoload)    (cond ((null c:cirhi)(load "auxdraw1"))(t (princ))) (c:cirhi))       ;圓形被前景遮住
(defun c:&1hid()(c:autoload)     (cond ((null c:1hid)(load "auxdraw1"))(t (princ))) (c:1hid))         ;線段被前景遮住
(defun c:&ext()(c:autoload)      (cond ((null c:ext)(load "auxdraw1"))(t (princ))) (c:ext))           ;延伸線段
(defun c:&aoff()(c:autoload)     (cond ((null c:aoff)(load "auxedit"))(t (princ))) (c:aoff))          ;OFFSET變換線型
(defun c:&offl()(c:autoload)     (cond ((null c:offl)(load "auxedit"))(t (princ))) (c:offl))          ;OFFSET變換圖層
;;;輔助編輯(三)
(defun c:&cir_enLg()(c:autoload)     (cond ((null c:c:cir_enLg)(load "cir_enLg"))(t (princ))) (c:cir_enLg))       ;圓形局部放大
(defun c:&rec_enLg()(c:autoload)     (cond ((null c:c:rec_enLg)(load "rec_enLg"))(t (princ))) (c:rec_enLg))       ;矩形局部放大
(defun c:&hkring1()(c:autoload)      (cond ((null c:hkring1)(load "auxedit"))(t (princ))) (c:hkring1))            ;扣環槽(孔用)
(defun c:&hkring2()(c:autoload)      (cond ((null c:hkring2)(load "auxedit"))(t (princ))) (c:hkring2))            ;扣環槽(軸用)
;;投影線
(defun c:&pul()(c:autoload)      (cond ((null c:pul)(load "projline"))(t (princ)))(c:pul))                ;旋轉投影線
(defun c:&pur()(c:autoload)      (cond ((null c:pur)(load "projline"))(t (princ)))(c:pur))                ;旋轉投影線
(defun c:&pdl()(c:autoload)      (cond ((null c:pdl)(load "projline"))(t (princ)))(c:pdl))                ;旋轉投影線
(defun c:&pdr()(c:autoload)      (cond ((null c:pdr)(load "projline"))(t (princ)))(c:pdr))                ;旋轉投影線
(defun c:&delproj()(c:autoload)  (cond ((null c:delproj)(load "projline"))(t (princ)))(c:delproj))        ;消除投影線
(defun c:&hline()(c:autoload)    (cond ((null c:hline)(load "projline"))(t (princ)))(c:hline))            ;水平投影線
(defun c:&vline()(c:autoload)    (cond ((null c:vline)(load "projline"))(t (princ)))(c:vline))            ;垂直投影線
(defun c:&hvline()(c:autoload)   (cond ((null c:hvline)(load "projline"))(t (princ)))(c:hvline))          ;十字投影線
(defun c:&tline()(c:autoload)    (cond ((null c:tline)(load "projline"))(t (princ)))(c:tline))            ;角度投影線
(defun c:&ptline()(c:autoload)   (cond ((null c:ptline)(load "projline"))(t (princ)))(c:ptline))          ;與線平行投影線
(defun c:&vtline()(c:autoload)   (cond ((null c:vtline)(load "projline"))(t (princ)))(c:vtline))          ;與線垂直投影線
(defun c:&angline()(c:autoload)  (cond ((null c:angline)(load "projline"))(t (princ)))(c:angline))        ;任意角度投影線
(defun c:&ofpjline()(c:autoload) (cond ((null c:ofpjline)(load "projline"))(t (princ)))(c:ofpjline))      ;偏移投影線
;;輔助標註一
(defun c:&rectdim()(c:autoload)    (cond ((null c:rectdim)(load "auxdim"))(t (princ)))(c:rectdim))        ;方體標註符號
(defun c:&facedim1()(c:autoload)   (cond ((null c:rectdim)(load "auxdim"))(t (princ)))(c:facedim1))       ;面標註符號
(defun c:&facedim2()(c:autoload)   (cond ((null c:rectdim)(load "auxdim"))(t (princ)))(c:facedim2))       ;面標註符號
(defun c:&refdim()(c:autoload)     (cond ((null c:autodim)(load "auxdim"))(t (princ)))(c:refdim))         ;參考標註符號
(defun c:&diadim()(c:autoload)     (cond ((null c:autodim)(load "auxdim"))(t (princ)))(c:diadim))         ;直徑標註符號
(defun c:&autodia()(c:autoload)    (cond ((null c:autodim)(load "auxdim"))(t (princ)))(c:autodia))        ;直徑標註
(defun c:&rtdim()(c:autoload)      (cond ((null c:autodim)(load "auxdim"))(t (princ)))(c:rt_dim))         ;還原
(defun c:&con_dim()(c:autoload)    (cond ((null c:con_dim)(load "auxdim"))(t (princ)))(c:con_dim))        ;寸連續標註
(defun c:&wedding1()(c:autoload)    (cond ((null c:wedding)(load "auxdim"))(t (princ)))(wedding 1))       ;邊熔接
(defun c:&wedding2()(c:autoload)    (cond ((null c:wedding)(load "auxdim"))(t (princ)))(wedding 2))       ;對邊熔接
(defun c:&chg_dim()(c:autoload)    (cond ((null c:chg_dim)(load "auxdim"))(t (princ)))(c:chg_dim))        ; 註(整體性)
(defun c:&d-tol()(c:autoload)      (cond ((null c:chg_dim)(load "auxdim"))(t (princ)))(c:d-tol))          ; 標註(分離性)
(defun c:&no_tol()(c:autoload)     (cond ((null c:no_tol)(load "auxdim"))(t (princ)))(c:no_tol))          ;公差標註
(defun c:&toler_hole()(c:autoload) (cond ((null c:toler_hole)(load "auxdim"))(t (princ)))(c:toler_hole))  ;孔尺寸容許差
(defun c:&toler_sha()(c:autoload)  (cond ((null c:toler_sha)(load "auxdim"))(t (princ)))(c:toler_sha))    ;軸尺寸容許差
;;輔助標註二
(defun c:&mdim()(c:autoload)        (cond ((null c:mdim)(load "mdim"))(t (princ)))(c:mdim))               ;原點標註法
(defun c:&newmo()(c:autoload)       (cond ((null c:newmo)(load "auxdraw1"))(t (princ)))(c:newmo))         ;設定 x,y 新原點
(defun c:&wcood1()(c:autoload)      (cond ((null c:wcood)(load "auxdraw1"))(t (princ)))(c:wcood 1))       ;寫出座標x,y
(defun c:&wcood3()(c:autoload)      (cond ((null c:wcood)(load "auxdraw1"))(t (princ)))(c:wcood 3))       ;寫出座標(x,y)
(defun c:&lexplode()(c:autoload)    (cond ((null c:lexplode)(load "auxdim"))(t (princ)))(c:lexplode))     ;尺寸爆炸回原層
(defun c:&autolead()(c:autoload)    (cond ((null c:autolead)(load "auxdim"))(t (princ)))(c:autolead))     ;引線帶辭庫(分離)
(defun c:&autolead2()(c:autoload)   (cond ((null c:autolead2)(load "auxdim"))(t (princ)))(c:autolead2))   ;引線帶辭庫(整體)
(defun c:&dimcham()(c:autoload)     (cond ((null c:dimcham)(load "auxdim"))(t (princ)))(c:dimcham))       ;45度倒角標註
(defun c:&dimcham2()(c:autoload)     (cond ((null c:dimcham)(load "auxdim"))(t (princ)))(c:dimcham2))     ;45度倒角標註
(defun c:&cring_auxdim()(c:autoload)  (cond ((null c:dimcham)(load "auxdim"))(t (princ)))(c:cring_auxdim));扣環標註
(defun c:&keydim()(c:autoload)        (cond ((null c:keydim)(load "auxdim"))(t (princ)))(c:keydim))       ;鍵槽鍵座標註
;;幾合公差標註
(defun c:&dimgeo()(c:autoload) (cond ((null c:dimgeo)(load "auxdim"))(t (princ)))(c:dimgeo))               ;幾何公差標註
(defun c:&dimgeo_base()(c:autoload) (cond ((null c:dimgeo_base)(load "auxdim"))(t (princ)))(c:dimgeo_base));幾何公差標註(基準面)
(defun c:&bsline()(c:autoload)  (cond ((null c:bsline)(load "auxdim"))(t (princ)))(c:bsline))              ;基準線
(defun c:&lealine()(c:autoload) (cond ((null c:lealine)(load "auxdim"))(t (princ)))(c:lealine))            ;指引線
(defun c:&dim-gbase()(c:autoload)(cond ((null c:dim-gbase)(load "auxdim"))(t (princ)))(c:dim-gbase))       ;基準面
;;組合圖與材料清單
(defun c:&AUTObom90()(c:autoload)  (cond ((null bom)(load "bom"))(t (princ))) (AUTObom 90))   ;向上定距(連續號)
(defun c:&AUTObom270()(c:autoload) (cond ((null bom)(load "bom"))(t (princ))) (AUTObom 270))  ;向下定距(連續號)
(defun c:&AUTObom0()(c:autoload)   (cond ((null bom)(load "bom"))(t (princ))) (AUTObom 0))    ;向左定距(連續號)
(defun c:&AUTObom180()(c:autoload) (cond ((null bom)(load "bom"))(t (princ))) (AUTObom 180))  ;向右定距(連續號)
(defun c:&keyin_bom90()(c:autoload)     (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 90))   ;向上定距(不連續號)
(defun c:&keyin_bom270()(c:autoload)    (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 270))  ;向下定距(不連續號)
(defun c:&keyin_bom0()(c:autoload)      (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 0))    ;向左定距(不連續號)
(defun c:&keyin_bom180()(c:autoload)    (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 180))  ;向右定距(不連續號)
(defun c:&autobom1()(c:autoload)        (cond ((null bom)(load "bom"))(t (princ)))(autobom 1))      ;自由拉出(連續號)
(defun c:&keyin_bom1()(c:autoload)      (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 1))    ;自由拉出(不連續號)
(defun c:&addbomtxt_xdata()(c:autoload) (cond ((null bom)(load "bom"))(t (princ)))(C:addbomtxt_xdata))   ;編輯指標球
(defun c:&drawbom_list()(c:autoload)    (cond ((null bom)(load "bom"))(t (princ)))(C:drawbom_list))      ;產生材料單圖形
(defun c:&delbom_list()(c:autoload)     (cond ((null bom)(load "bom"))(t (princ)))(C:delbom_list))       ;刪除材料單圖形
(defun c:&bomlist_txt()(c:autoload)     (cond ((null bom)(load "bom"))(t (princ)))(C:bomlist_txt))       ;產生材料單文字檔
(defun c:&out()(c:autoload)             (cond ((null bom)(load "bom"))(t (princ)))(c:out))               ;組合圖拆出零件圖
(defun c:&in()(c:autoload)              (cond ((null bom)(load "bom"))(t (princ)))(c:in))                ;零件圖組裝成組合圖
;;;;;;由資訊點產生指標球
(defun c:&AUTObom90_info()(c:autoload)  (cond ((null manaball)(load "manaball"))(t (princ))) (AUTObom_info 90))   ;向上定距(連續號)
(defun c:&AUTObom270_info()(c:autoload) (cond ((null manaball)(load "manaball"))(t (princ))) (AUTObom_info 270))  ;向下定距(連續號)
(defun c:&AUTObom0_info()(c:autoload)   (cond ((null manaball)(load "manaball"))(t (princ))) (AUTObom_info 0))    ;向左定距(連續號)
(defun c:&AUTObom180_info()(c:autoload) (cond ((null manaball)(load "manaball"))(t (princ))) (AUTObom_info 180))  ;向右定距(連續號)
(defun c:&keyin_bom90_info()(c:autoload)     (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 90))   ;向上定距(不連續號)
(defun c:&keyin_bom270_info()(c:autoload)    (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 270))  ;向下定距(不連續號)
(defun c:&keyin_bom0_info()(c:autoload)      (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 0))    ;向左定距(不連續號)
(defun c:&keyin_bom180_info()(c:autoload)    (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 180))  ;向右定距(不連續號)
(defun c:&autobom1_info()(c:autoload)        (cond ((null manaball)(load "manaball"))(t (princ)))(autobom_info 1))          ;自由拉出(連續號)
(defun c:&keyin_bom1_info()(c:autoload)      (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 1))      ;自由拉出(不連續號)
;;圖層控制
(defun c:&pshow()(c:autoload)      (cond ((null c:pshow)(load "LAYER"))(t (princ)))(c:pshow))                 ;顯示層
(defun c:&phide()(c:autoload)      (cond ((null c:phide)(load "LAYER"))(t (princ)))(c:phide))                 ;隱藏層
(defun c:&BSHOW()(c:autoload)      (cond ((null c:BSHOW)(load "LAYER"))(t (princ)))(c:BSHOW))                 ;顯示 BLOCK
(defun c:&ashow()(c:autoload)      (cond ((null c:ASHOW)(load "LAYER"))(t (princ)))(c:ASHOW))                 ;全部顯示
(defun c:&THRAW()(c:autoload)      (cond ((null c:THRAW)(load "LAYER"))(t (princ)))(c:THRAW))                 ;解凍層
(defun c:&PFREE()(c:autoload)      (cond ((null c:PFREE)(load "LAYER"))(t (princ)))(c:PFREE))                 ;冷凍層
(defun c:&LTCONTROL()(c:autoload)  (cond ((null c:LTCONTROL)(load "LAYER"))(t (princ)))(c:LTCONTROL))         ;線型顯示控制
(defun c:&mlc()(c:autoload)        (cond ((null c:MLC)(load "LAYER"))(t (princ)))(c:MLC))                     ;製作層
(defun c:&AUTOMLC()(c:autoload)    (cond ((null c:AUTOMLC)(load "LAYER"))(t (princ)))(c:AUTOMLC))             ;建立連續圖層
(defun c:&CHLAY()(c:autoload)      (cond ((null c:CHLAY)(load "LAYER"))(t (princ)))(c:CHLAY))                 ;改變層
(defun c:&CHto_clayer()(c:autoload)(cond ((null c:CHto_clayer)(load "LAYER"))(t (princ)))(c:CHto_clayer))     ;變換圖元到目前層
(defun c:&DLAY()(c:autoload)       (cond ((null c:DLAY)(load "LAYER"))(t (princ)))(c:DLAY))                   ;刪除層
(defun c:&SLAY()(c:autoload)       (cond ((null c:SLAY)(load "LAYER"))(t (princ)))(c:SLAY))                   ;指定目前層
(defun c:&LCONTROL()(c:autoload)   (cond ((null c:LCONTROL)(load "LAYER"))(t (princ)))(c:LCONTROL))           ;輸入層名以控制圖層
(defun c:&SLTYPE()(c:autoload)     (cond ((null c:SLTYPE)(load "LAYER"))(t (princ)))(c:SLTYPE))               ;線色顯示
(defun c:&SPART()(c:autoload)      (cond ((null c:SPART)(load "LAYER"))(t (princ)))(c:SPART))                 ;層色顯示
(defun c:RS()(c:autoload)      (cond ((null c:ASHOW)(load "LAYER"))(t (princ)))(c:ASHOW))                 ;全部顯示
(defun c:LS()(c:autoload)      (cond ((null c:pshow)(load "LAYER"))(t (princ)))(c:pshow))
;;資料查詢
(defun c:&ironsize1()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 1))
(defun c:&ironsize2()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 2))
(defun c:&carqury2()(c:autoload)   (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(carqury 2))
(defun c:&ironsize3()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 3))  ;黑白鋼管規格
(defun c:&ironsize4()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 4))  ;白鋼管規格
(defun c:&funcc()(c:autoload)      (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(c:funcc))     ;量計算法
(defun c:&ironsize5()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 5))  ;板
(defun c:&ironsize6()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 6))  ;角鐵
(defun c:&ironsize7()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 7))  ;三角鐵
(defun c:&carqury1()(c:autoload)   (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(carqury 1))   ;寸表
(defun c:&e-len()(c:autoload)      (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(c:e-len))     ;英制長度
(defun c:&d-2p()(c:autoload)       (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(c:d-2p))      ;英制距離
(defun c:&arclen()(c:autoload)     (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(c:arclen))    ;詢
;;鍵槽與螺紋
(defun c:&SLOT4()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT4)) ;雙圓鍵
(defun c:&SLOT1()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT1)) ;雙圓鍵
(defun c:&SLOT2()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT2)) ;雙圓鍵
(defun c:&SLOT5()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT5)) ;雙圓鍵
(defun c:&SLOT3()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT3)) ;半圓鍵
(defun c:&lc()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:lc))       ;軸銑雙邊
(defun c:&keyway_1()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:keyway_1))    ;有圓,畫鍵槽與鍵座
(defun c:&keyway_2()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:keyway_2))    ;無圓,畫鍵槽與鍵座
(defun c:&drill5()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:drill5))        ;鑽孔
(defun c:&drill4()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:drill4))        ;通
(defun c:&thrill()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:thrill))        ;攻牙
(defun c:&thRILl2()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:thRILl2))      ;攻牙(通孔)
(defun c:&thrill3()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:thrill3))      ;沉窩螺絲孔
(defun c:&thrill4()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(C:thrill4))      ;推拔螺絲孔
(defun c:&pipscrew()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(C:pipscrew))    ;管螺絲孔",
;;螺紋外牙
(defun c:&Screwline()(c:autoload) (cond ((null c:Screwline)(load "scrwline"))(t (princ)))(c:Screwline))
;;次組合 
(defun c:&subsys()    (c:autoload)(cond ((null c:subsys)    (load "s_asmset"))(t (princ)))(c:subsys))
(defun c:&sub_on_off()(c:autoload)(cond ((null c:sub_on_off)(load "s_asmset"))(t (princ)))(c:sub_on_off))
(defun c:&sub_remove()(c:autoload)(cond ((null c:sub_remove)(load "s_asmset"))(t (princ)))(c:sub_remove))
(defun c:&part_cr()   (c:autoload)(cond ((null c:part_cr)   (load "s_asmset"))(t (princ)))(c:part_cr))
(defun c:&part_del()  (c:autoload)(cond ((null c:part_del)  (load "s_asmset"))(t (princ)))(c:part_del))
;;軸產生器
(defun c:&ho1()(c:autoload) (cond ((null c:ho1)(load "auxdraw1"))(t (princ)))(C:ho1))   ;軸剖面
(defun c:&ho2()(c:autoload) (cond ((null c:ho2)(load "auxdraw1"))(t (princ)))(C:ho2))   ;軸剖面
(defun c:&ho()(c:autoload)  (cond ((null c:ho)(load "auxdraw1"))(t (princ)))(C:ho))     ;軸外形
(defun c:&sha()(c:autoload) (cond ((null c:sha)(load "auxdraw1"))(t (princ)))(C:sha))   ;軸外形

;;辭庫與計算機(函數名稱更改時需一同更改 sheetset.lsp 中之名稱)
(defun c:&useword()(c:autoload) (cond ((null c:useword)(load "wordlib1"))(t (princ)))(c:useword))       ;使用辭庫
(defun c:&creatword()(c:autoload) (cond ((null c:creatword)(load "wordlib1"))(t (princ)))(c:creatword)) ;辭庫建立

;;;[組合圖整合功能]
(defun c:&moveparts() (c:autoload)(cond ((null c:moveparts)(load "assembly"))(t (princ)))(c:moveparts)) ;[移動零件]
(defun c:&copyparts() (c:autoload)(cond ((null c:copyparts)(load "assembly"))(t (princ)))(c:copyparts)) ;[複製零件]
(defun c:&delparts()  (c:autoload)(cond ((null c:delparts)(load "assembly"))(t (princ)))(c:delparts))   ;[刪除零件]
(defun c:&roteparts() (c:autoload)(cond ((null c:roteparts)(load "assembly"))(t (princ)))(c:roteparts)) ;[旋轉零件]
(defun c:&mirparts()  (c:autoload)(cond ((null c:mirparts)(load "assembly"))(t (princ)))(c:mirparts))   ;[鏡射零件]

;;放圖框定比例
(defun c:&resetting()(c:autoload)(if (null c:resetting)(load "shscal"))(C:resetting)) ;重設比例
(defun c:&ch_sheet()(c:autoload)(load "shscal")(ch_sheet 1)) ;更換圖框
(defun c:&SCAl()(c:autoload) (cond ((null c:scal)(load "aux-qury"))(t (princ)))(C:SCAL)) ;比例查詢

;;鎖點模式組
(defun c:&setosmode()(c:autoload) (cond ((null c:setosmode)(load "dfsystem"))(t (princ)))(C:setosmode)) ;設定鎖點模式組

;;物料結構
(defun c:&makepart()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:makepart))                    ;建立新零件圖層
(defun c:&edit_bomp()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:edit_bomp))                  ;修改資訊點資料
(defun c:&addbomp()(c:autoload) (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:addbomp))                    ;建立資訊點(自己輸入資料)
(defun c:&addbom_olddwg()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:addbom_olddwg))         ;建立資訊點(取出圖面上文字)
(defun c:&addbomp_sheet()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:addbomp_sheet))          ;建立資訊點(由圖框屬性萃取)
(defun c:&move_bomp()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:move_bomp))                 ;移動資訊點(選擇圖元)
(defun c:&on_bomlayer()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:on_bomlayer))              ;打開資訊點
(defun c:&off_bomlayer()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:off_bomlayer))           ;關閉資訊點
(defun c:&automakepart()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:automakepart))           ;自動建立資訊點
(defun c:&layer_how()(c:autoload)  (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:layer_how))               ;計算零件
(defun c:&creat_bmpf()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:creat_bmpf))               ;建立影像檔
(defun c:&sortcol()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:sortcol))                      ;物料結構與圖檔管理顯示欄位順序
(defun c:&bomtree1()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(bomtree 1))                     ;物料清單匯出到Excel
(defun c:&bomtree0()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(bomtree 0))                     ;物料結構樹
(defun c:&bomtree2()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(bomtree 2))                     ;瀏覽
(defun c:&bomtree3()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(bomtree 3))                     ;物料清單再更新
(defun c:&chlacol()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:chlacol))                      ;選擇零件新顏色
(defun c:&dwg_libpath()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:defdwg_path)(load "dfsystem"))(t (princ)))(c:dwg_libpath))

(defun c:&opendwg()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:opendwg))                       ;開舊圖
(defun c:&insdwg()(c:autoload) (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:insdwg))           ;插入舊圖
(defun c:&AUTOB()(c:autoload)  (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:AUTOB))             ;全自動指標球
(defun c:&pdmwblk()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:pdmwblk))         ;建立公用 BLOCK
(defun c:&defbom()(c:autoload) (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:df_bomdbase)(load "dfsystem"))(t (princ)))(c:defbom))           ;定義材料清單欄位
(defun c:&bomlist()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:bomlist))          ;產生圖面材料清單
(defun c:&mana_database()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:mana_database)(load "manapart"))(t (princ)))(c:mana_database))          ;管理物料資料庫
(defun c:&df_bomdbase()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:df_bomdbase)(load "dfsystem"))(t (princ)))(c:df_bomdbase))          ;物料資料庫欄位定義
(defun c:&fieldset()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:fieldset)(load "dfsystem"))(t (princ)))(c:fieldset))          ;圖檔管理資料庫欄位設定值

;;Power Offset
(defun c:offtosl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ))) (aoff_to_which_ltype sys_CONT_ltype sys_CONT_ltypecol) )
(defun c:offtotl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ)))(aoff_to_which_ltype  sys_CONT1_ltype sys_CONT1_ltypecol))
(defun c:offtodl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ)))(aoff_to_which_ltype  sys_dashed_ltype sys_dashed_ltypecol))
(defun c:offtosdl()(c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ))) (aoff_to_which_ltype sys_dashed1_ltype sys_dashed1_ltypecol))
(defun c:offtocl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ)))(aoff_to_which_ltype  sys_center_ltype sys_center_ltypecol))
(defun c:offtoscl()(c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ))) (aoff_to_which_ltype sys_stcenter_ltype sys_stcenter_ltypecol))
(defun c:offtopl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ)))(aoff_to_which_ltype  sys_phantom_ltype sys_phantom_ltypecol))
(defun c:offtospl()(c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ))) (aoff_to_which_ltype sys_phantom1_ltype sys_phantom1_ltypecol))
(defun c:offtohl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ)))(aoff_to_which_ltype  sys_hatch_ltype sys_hatch_ltypecol))

(defun c:&chtodim() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2")) (t (princ)) ) (ch_to_objlayer sys_dim_layer) )
(defun c:&chtotxt() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit2"))(t (princ)))(ch_to_objlayer sys_text_layer))
;;=============================================================================================
;;等角立體圖
(defun c:&isomenu1()(c:autoload)(c:isomenu1))  ;等角圖１
(defun c:&isomenu2()(c:autoload)(c:isomenu2))  ;等角圖２
(defun c:&isoblk1()(c:autoload)(c:isoblk1))    ;爆炸圖圖庫管理
(defun c:&isoblk2()(c:autoload)(c:isoblk2))    ;使用爆炸圖圖庫

;;=============================================================================================
;;機械元件 [銷]
(defun c:&openpin()(c:autoload)(c:openpin))  ;開口銷
(defun c:&sprpin()(c:autoload)(c:sprpin))    ;彈簧銷
(defun c:&parpinA()(c:autoload)(c:parpinA))  ;A 型平行銷
(defun c:&parpinB()(c:autoload)(c:parpinB))  ;B 型平行銷
(defun c:&tappin()(c:autoload)(c:tappin))    ;推拔銷

;;機械元件 [鍵]
(defun c:&parkey7()(c:autoload)(c:parkey7))  ;A 種半圓鍵
(defun c:&parkey8()(c:autoload)(c:parkey8))  ;B 種半圓鍵
(defun c:&parkey6()(c:autoload)(c:parkey6))  ;帶頭斜鍵
(defun c:&parkey5()(c:autoload)(c:parkey5))  ;推拔鍵(斜鍵)
(defun c:&parkey1()(c:autoload)(c:parkey1))  ;平行鍵單頭圓形
(defun c:&parkey2()(c:autoload)(c:parkey2))  ;平行鍵雙頭圓形
(defun c:&parkey3()(c:autoload)(c:parkey3))  ;平行鍵單頭尖形
(defun c:&parkey4()(c:autoload)(c:parkey4))  ;平行鍵雙頭尖形

;;機械元件 [油 封]
(defun c:&soilseal()(c:autoload) (c:soilseal))   ;S 型 帶彈簧橡膠外周
(defun c:&smoilseal()(c:autoload)(c:smoilseal))  ;SM型 帶彈簧金屬外周
(defun c:&saoilseal()(c:autoload)(c:saoilseal))  ;SA型 帶彈簧之組成
(defun c:&doilseal()(c:autoload) (c:doilseal))   ;D 型 帶彈簧橡膠外周附防塵
(defun c:&dmoilseal()(c:autoload)(c:dmoilseal))  ;DM型 帶彈簧金屬外周附防塵
(defun c:&daoilseal()(c:autoload)(c:daoilseal))  ;DA型 帶彈簧之組成附防塵
(defun c:&goilseal()(c:autoload) (c:goilseal))   ;G 型 未帶彈簧橡膠外周
(defun c:&gmoilseal()(c:autoload)(c:gmoilseal))  ;GM型 未帶彈簧金屬外周
(defun c:&gaoilseal()(c:autoload)(c:gaoilseal))  ;GA型 未帶彈簧之組成

;;機械元件 [連座軸承組]
(defun c:&UcF()(c:autoload)(c:UcF))    ;UCF圓柱孔形角凸緣型
(defun c:&Ucpp()(c:autoload)(c:Ucpp))  ;UCP圓柱孔形連座型
(defun c:&Uct()(c:autoload)(c:Uct))    ;UCT圓筒孔形收縮形
(defun c:&Ukf()(c:autoload)(c:UkF))    ;UKF斜度孔形角凸緣型
(defun c:&Ukp()(c:autoload)(c:Ukp))    ;UKP斜度孔形連座型
(defun c:&Ukt()(c:autoload)(c:Ukt))    ;UKT斜度孔形收緊型
(defun c:&UcFl()(c:autoload)(c:UcFl))  ;UCFL圓柱孔形菱形凸緣型
(defun c:&UkFl()(c:autoload)(c:UkFl))  ;UKFL斜度孔形菱形凸緣型
(defun c:&UcFc()(c:autoload)(c:UcFc))  ;UCFC圓柱孔形套管圓凸緣型
(defun c:&UkFc()(c:autoload)(c:UkFc))  ;UKFC 推拔形附插承接合圓凸緣型

;;機械元件[華司(墊圈)]
(defun c:&cirwash1()(c:autoload)(c:cirwash1))    ;圓形平墊圈(小形)
(defun c:&recwash1()(c:autoload)(c:recwash1))    ;方形平墊圈(小形)
(defun c:&recwash2()(c:autoload)(c:recwash2))    ;方形平墊圈(大形)
(defun c:&spwasher()(c:autoload)(c:spwasher))    ;彈簧墊圈
;(defun c:&bearwash1()(c:autoload)(c:bearwash1))  ;直舌型式滾動軸承螺帽用墊圈
;(defun c:&bearwash2()(c:autoload)(c:bearwash2))  ;彎舌型式滾動軸承螺帽用墊圈

(defun c:&bearwash1()(c:autoload)(c:shnutwasher))  ;直舌型式滾動軸承螺帽用墊圈
(defun c:&bearwash2()(c:autoload)(c:shnutwasher2))  ;彎舌型式滾動軸承螺帽用墊圈

;;機械元件[型鋼系列]
(defun c:&l_steel()(c:autoload)(c:l_steel))    ;L 形等邊角鋼
(defun c:&c_steel()(c:autoload)(c:c_steel))    ;槽(C)型鋼
(defun c:&i_steel()(c:autoload)(c:i_steel))    ;I 形鋼
(defun c:&h_steel()(c:autoload)(c:h_steel))    ;H 形鋼
(defun c:&l_steel2()(c:autoload)(c:l_steel2))  ;熱軋不銹鋼等邊角鋼
(defun c:&l_steel3()(c:autoload)(c:l_steel3))  ;不等邊角鋼
(defun c:&l_steel4()(c:autoload)(c:l_steel4))  ;不等邊不等厚
(defun c:&t_steel()(c:autoload)(c:t_steel))    ;T 形鋼

;;機械元件[輕量型鋼]
(defun c:&SCsteel1()(c:autoload)(c:SCsteel1))    ;輕槽形鋼
(defun c:&SNsteel()(c:autoload)(c:SNsteel))      ;帽形鋼
(defun c:&SCsteel2()(c:autoload)(c:SCsteel2))    ;唇槽形鋼
(defun c:&SLsteel()(c:autoload)(c:SLsteel))      ;輕角鋼
(defun c:&SZsteel1()(c:autoload)(c:SZsteel1))    ;輕 Z 形鋼
(defun c:&SZsteel2()(c:autoload)(c:SZsteel2))    ;唇 Z 形鋼

;;機械元件[螺栓與螺帽]
(defun c:&Jbase()(c:autoload)(c:Jbase))                ;J型基礎螺栓
(defun c:&lbase()(c:autoload)(c:lbase))                ;L型基礎螺栓
(defun c:&lAbase()(c:autoload)(c:lAbase))              ;LA型基礎螺栓
(defun c:&JAbase()(c:autoload)(c:JAbase))              ;JA型基礎螺栓
(defun c:&sockhead()(c:autoload)(c:sockhead))          ;內六角螺栓
(defun c:&outsixp()(c:autoload)(c:outsixp))            ;平形端六角頭螺栓
(defun c:&6screwendcp()(c:autoload)(c:6screwendcp))    ;圓形端六角頭螺栓
(defun c:&6sgefp()(c:autoload)(c:6sgefp))              ;平形端六角頭螺栓. 含墊圈
(defun c:&6sgecp()(c:autoload)(c:6sgecp))              ;圓形端六角頭螺栓. 含墊圈
(defun c:&sqscwp()(c:autoload)(c:sqscwp))              ;平形端方頭螺栓
(defun c:&sqsecp()(c:autoload)(c:sqsecp))              ;圓形端方頭螺栓
(defun c:&1sisefp()(c:autoload)(c:1sisefp))            ;平形端一字槽埋頭螺栓
(defun c:&1sisecp()(c:autoload)(c:1sisecp))            ;圓形端一字槽埋頭螺栓
(defun c:&1siskefp()(c:autoload)(c:1siskefp))          ;有鍵 . 平形端一字槽埋頭螺栓
(defun c:&1siskecp()(c:autoload)(c:1siskecp))          ;有鍵 . 圓形端一字槽埋頭螺栓
(defun c:&6f_nceap()(c:autoload)(c:6f_nceap))          ;圓形底承窩 . 全柱頭端六角承窩固定螺栓
(defun c:&6f_ncetp()(c:autoload)(c:6f_ncetp))          ;圓形底承窩 . 錐形端  六角承窩固定螺栓
(defun c:&6f_nceup()(c:autoload)(c:6f_nceup))          ;圓形底承窩 . 杯形端  六角承窩固定螺栓
(defun c:&6f_ntefp()(c:autoload)(c:6f_ntefp))          ;圓錐底承窩 . 平形端  六角承窩固定螺栓
(defun c:&6f_nteap()(c:autoload)(c:6f_nteap))          ;圓錐底承窩 . 全柱頭端六角承窩固定螺栓
(defun c:&6f_ntetp()(c:autoload)(c:6f_ntetp))          ;圓錐底承窩 . 錐形端  六角承窩固定螺栓
(defun c:&6f_nteup()(c:autoload)(c:6f_nteup))          ;圓錐底承窩 . 杯形端  六角承窩固定螺栓
(defun c:&6f_ndeap()(c:autoload)(c:6f_ndeap))          ;圓鑽底承窩 . 全柱頭端六角承窩固定螺栓
(defun c:&6f_ndetp()(c:autoload)(c:6f_ndetp))          ;圓鑽底承窩 . 錐形端  六角承窩固定螺栓
(defun c:&6f_ndeup()(c:autoload)(c:6f_ndeup))          ;圓鑽底承窩 . 杯形端  六角承窩固定螺栓
(defun c:&wing_1erp()(c:autoload)(c:wing_1erp))        ;1 種 . 粗糙端翼形螺栓
(defun c:&wing_1efp()(c:autoload)(c:wing_1efp))        ;1 種 . 平形端翼形螺栓
(defun c:&wing_1ecp()(c:autoload)(c:wing_1ecp))        ;1 種 . 圓形端翼形螺栓
(defun c:&wing_2erp()(c:autoload)(c:wing_2erp))        ;2 種 . 粗糙端翼形螺栓
(defun c:&wing_2efp()(c:autoload)(c:wing_2efp))        ;2 種 . 平形端翼形螺栓
(defun c:&wing_2ecp()(c:autoload)(c:wing_2ecp))        ;2 種 . 圓形端翼形螺栓
(defun c:&wing_3erp()(c:autoload)(c:wing_3erp))        ;3 種 . 粗糙端翼形螺栓
(defun c:&wing_3efp()(c:autoload)(c:wing_3efp))        ;3 種 . 平形端翼形螺栓
(defun c:&wing_3ecp()(c:autoload)(c:wing_3ecp))        ;3 種 . 圓形端翼形螺栓
(defun c:&Lnkscrewp()(c:autoload)(c:Lnkscrewp))        ;鉸接螺栓
(defun c:&skescrewp()(c:autoload)(c:skescrewp))        ;敲擊螺栓
(defun c:&eyeboltp()(c:autoload)(c:eyeboltp))          ;環首螺栓
(defun c:&sockless()(c:autoload)(c:sockless))          ;無頭固定螺栓
(defun c:&fixsock()(c:autoload)(c:fixsock))            ;有槽固定螺栓
(defun c:&tscrew()(c:autoload)(c:tscrew))              ;平形端Ｔ形螺栓
(defun c:&tscrewcp()(c:autoload)(c:tscrewcp))          ;圓形端Ｔ形螺栓
(defun c:&six-snut()(c:autoload)(c:six-snut))          ;六角螺帽(小)
(defun c:&six-bnut()(c:autoload)(c:six-bnut))          ;六角螺帽(大)
(defun c:&bearth()(c:autoload)(c:bearth))              ;滾動軸承用螺帽

;;機械元件 [軸承類]
(defun c:&bear32x()(c:autoload)(c:bear32x))    ;圓錐滾子軸承
(defun c:&bear6x()(c:autoload)(c:bear6x))      ;深槽滾珠軸承
(defun c:&bear12x()(c:autoload)(c:bear12x))    ;自動調心滾珠軸承
(defun c:&bear230x()(c:autoload)(c:bear230x))  ;自動調心滾子軸承

(defun c:&bear51x()(c:autoload)(c:bear51x))  ;單向止推滾珠軸承
(defun c:&bear52x()(c:autoload)(c:bear52x))  ;雙向止推滾珠軸承
(defun c:&bear29x()(c:autoload)(c:bear29x))  ;自動調心止推滾子軸承
(defun c:&bear7x() (c:autoload)(c:bear7x))   ;接觸角滾珠軸承
(defun c:&bear5x() (c:autoload)(c:bear5x))   ;雙列滾珠軸承
(defun c:&bearn2x()(c:autoload)(c:bearn2x))  ;雙列圓筒滾子軸承

(defun c:&bearnxx()(c:autoload)(c:bearnxx))    ;圓筒滾子軸承

;;機械元件 [扣環]
(defun c:&shaftc()(c:autoload)(c:shaftc))  ;軸用 C 型扣環
(defun c:&holec()(c:autoload)(c:holec))    ;孔用 C 型扣環
(defun c:&shafte()(c:autoload)(c:shafte))  ;E 型扣環

;;機械元件 [鏈輪]
(defun c:&b_sgear()(c:autoload)(c:b_sgear))  ;B 型鏈齒輪
(defun c:&5-1_gear()(c:autoload)(c:5-1_gear));正齒輪
(defun c:&5-2_gear()(c:autoload)(c:5-2_gear));螺旋齒輪
(defun c:&5-3_gear()(c:autoload)(c:5-3_gear));齒條
(defun c:&5-4_gear()(c:autoload)(c:5-4_gear));傘齒輪
(defun c:&5-5_gear()(c:autoload)(c:5-5_gear));蝸桿
(defun c:&5-6_gear()(c:autoload)(c:5-6_gear));蝸輪
(defun c:&5-7_gear()(c:autoload)(c:5-7_gear));三角皮帶輪
;;=============================================================================================
;;系統內定簡易指令
(defun ch_lt_c(lty colr)
 (setq aa colr)
 (setq bb lty)
 (if (= "INTELLICAD" cad_version)
     (if (= 0 (atoi colr))
          (command "linetype" "s" lty "" "colour" colr)
          (command "linetype" "s" lty "" "colour" (atoi colr))
     )
     (if (= 0 (atoi colr))
          (command "linetype" "s" lty "" "color" colr)
          (command "linetype" "s" lty "" "color" (atoi colr))
     )
 );if
    (princ)

)
;(defun ch_lt_c (lty col)
;  (setq aa col)
;  (if (= 0 (atoi col))
;    (command "linetype" "s" lty "" "color" col)
;    (command "linetype" "s" lty "" "color" (atoi col))
;  )
;    (princ)
;)

(defun c:sll()(c:autoload)(c:&sl&)(command "script" (strcat powdesign_path "drawline"))(princ))
(defun c:dll()(c:autoload)(c:&dl&)(command "script" (strcat powdesign_path "drawline"))(princ))
(defun c:Sdll()(c:autoload)(c:&Sdl&)(command "script" (strcat powdesign_path "drawline"))(princ))
(defun c:cll()(c:autoload)(c:&cl&)(command "script" (strcat powdesign_path "drawline"))(princ))
(defun c:scll()(c:autoload)(c:&scl&)(command "script" (strcat powdesign_path "drawline"))(princ))
(defun c:pll()(c:autoload)(c:&pl&)(command "script" (strcat powdesign_path "drawline"))(princ))
(defun c:Spll()(c:autoload)(c:&Spl&)(command "script" (strcat powdesign_path "drawline"))(princ))
(defun c:tll()(c:autoload)(c:&tl&)(command "script" (strcat powdesign_path "drawline"))(princ))
(defun c:hll()(c:autoload)(c:&hl&)(command "script" (strcat powdesign_path "drawline"))(princ))
;;==============================
;;;;系統內定線型&圖層副程式
;;粗連續線
(defun c:&sl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_CONT_ltype sys_CONT_ltypecol)
; (setvar "cmdecho" 1)
)
;;虛線
(defun c:&dl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_dashed_ltype sys_dashed_ltypecol)
; (setvar "cmdecho" 1)
)
;;短虛線
(defun c:&Sdl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_Sdashed_ltype sys_Sdashed_ltypecol)
; (setvar "cmdecho" 1)
)
;;中心線
(defun c:&cl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_center_ltype sys_center_ltypecol)
; (setvar "cmdecho" 1)
)
;;短中心線
(defun c:&scl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_stcenter_ltype sys_stcenter_ltypecol)
; (setvar "cmdecho" 1)
)
;;假想線
(defun c:&pl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_phantom_ltype  sys_phantom_ltypecol)
; (setvar "cmdecho" 1)
)
;;假想線
(defun c:&Spl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_Sphantom_ltype  sys_Sphantom_ltypecol)
; (setvar "cmdecho" 1)
)
;;細實線
(defun c:&tl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_CONT1_ltype sys_CONT1_ltypecol)
; (setvar "cmdecho" 1)
)
;;剖面線
(defun c:&hl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_hatch_ltype sys_hatch_ltypecol)
; (setvar "cmdecho" 1)
)
;;切換到零件外形層
(defun c:&0&()(c:autoload)
  (loaddesigner)
  (setvar "cmdecho" 0)
  (command "layer" "s" "0" "" "linetype" "s" sys_CONT_ltype "" "color" sys_CONT_ltypecol)
; (setvar "cmdecho" 1)
  (princ)
)
;;切換到尺寸層
(defun c:&d&()(c:autoload)
  (loaddesigner)
  (setvar "cmdecho" 0)
  (clauc sys_dim_layer sys_dim_layercol "CONTINUOUS")
  (ch_lt_c "BYLAYER" "BYLAYER")
;  (setvar "cmdecho" 1)
)
;;切換到文字層
(defun c:&t&()(c:autoload)
  (loaddesigner)
  (setvar "cmdecho" 0)
  (clauc sys_text_layer sys_text_layercol "CONTINUOUS")
  (ch_lt_c "BYLAYER" "BYLAYER")
; (setvar "cmdecho" 1)
)
;;切換到零件外形層
(defun c:&by&()(c:autoload)
  (loaddesigner)
  (setvar "cmdecho" 0)
  (ch_lt_c "BYLAYER" "BYLAYER")
; (setvar "cmdecho" 1)
)
;;切換到投影線層
(defun c:&p&()(c:autoload)
 (loaddesigner)
  (setvar "cmdecho" 0)
  (clauc sys_proj_layer sys_proj_layercol "CONTINUOUS")
  (ch_lt_c "BYLAYER" "BYLAYER")
; (setvar "cmdecho" 1)
)
;;======================
;;;=============
(defun $getosval(olist / oslistval olist va count val)
   (setq oslistval (list 1 2 32 4 16 256 128 8 64 512 2048 1024) count 0 val 0)
   (foreach nn olist
     (progn
       (if (= "1" nn)(setq va (nth count oslistval))(setq va 0))
       (setq val (+ val va))
       (setq count (1+ count))
     );progn
   );foreach
   val
);defun

(defun c:O1(/ list1)
   (c:autoload)
   (setq prefix (getvar "dctcust"))
   (setq OUT_LSPPATH (substr PREFIX 1 (- (strlen prefix) 10)))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;假如support 目錄下沒有個人化的 osmode.ini, 則自動建立該檔
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "第一組鎖點模式")))
   (setvar "osmode" ($getosval list1))
   (princ "\n已設定成第一組鎖點模式!")
   (princ)
)
(defun c:O2(/ list1)
   (c:autoload)
   (setq prefix (getvar "dctcust"))
   (setq OUT_LSPPATH (substr PREFIX 1 (- (strlen prefix) 10)))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;假如support 目錄下沒有個人化的 osmode.ini, 則自動建立該檔
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "第二組鎖點模式")))
   (setvar "osmode" ($getosval list1))
   (princ "\n已設定成第二組鎖點模式!")
   (princ)
)
(defun c:O3(/ list1)
   (c:autoload)
   (setq prefix (getvar "dctcust"))
   (setq OUT_LSPPATH (substr PREFIX 1 (- (strlen prefix) 10)))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;假如support 目錄下沒有個人化的 osmode.ini, 則自動建立該檔
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "第三組鎖點模式")))
   (setvar "osmode" ($getosval list1))
   (princ "\n已設定成第三組鎖點模式!")
   (princ)
)
(defun c:O4(/ list1)
   (c:autoload)
   (setq prefix (getvar "dctcust"))
   (setq OUT_LSPPATH (substr PREFIX 1 (- (strlen prefix) 10)))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;假如support 目錄下沒有個人化的 osmode.ini, 則自動建立該檔
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "第四組鎖點模式")))
   (setvar "osmode" ($getosval list1))
   (princ "\n已設定成第四組鎖點模式!")
   (princ)
)
(defun c:O5(/ list1)
   (c:autoload)
   (setq prefix (getvar "dctcust"))
   (setq OUT_LSPPATH (substr PREFIX 1 (- (strlen prefix) 10)))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;假如support 目錄下沒有個人化的 osmode.ini, 則自動建立該檔
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "第五組鎖點模式")))
   (setvar "osmode" ($getosval list1))
   (princ "\n已設定成第五組鎖點模式!")
   (princ)
)
(defun c:O6()(c:autoload) (setvar "osmode" 0)
   (princ "\n已設定成第六組鎖點模式!")
(princ))


(defun c:000()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 76 "0"))
(defun c:111()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 76 "1"))
(defun c:222()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 76 "2"))
(defun c:333()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 76 "3"))
(defun c:444()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 76 "4"))
(defun c:555()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 76 "5"))
(defun c:777()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 174 "7"))
(defun c:888()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 174 "8"))
(defun c:999()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 174 "9"))
(defun c:110()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 142 "11"))
(defun c:112()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 142 "12"))
(defun c:113()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 253 "14"))
(defun c:115()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" func_col "16"))
(defun c:116()(c:autoload) (cond ((null usermenu)(load "userMENU"))(t (princ))) (usermenu "usermenu.mnu" "usermenu" "partmenu" 26 "17"))

(princ)

;;;圖層 (BLOCK) 關
(defun c:&creatblk()    (c:autoload)(cond ((null c:creatblk)    (load "creatblk"))(t (princ)))(c:creatblk))
(defun c:&showblk()     (c:autoload)(cond ((null c:showblk)     (load "showblk"))(t (princ)))(c:showblk))
(defun c:&s_allblk()     (c:autoload)(cond ((null c:s_allblk)     (load "s_allblk"))(t (princ)))(c:s_allblk))
(defun c:&hideblk()     (c:autoload)(cond ((null c:hideblk)     (load "hideblk"))(t (princ)))(c:hideblk))
(defun c:&outblk()      (c:autoload)(cond ((null c:outblk)      (load "outblk"))(t (princ)))(c:outblk))
(defun c:&blksubcr()    (c:autoload)(cond ((null c:blksubcr)    (load "blksubcr"))(t (princ)))(c:blksubcr))

;;;new function
;;Power Offset
(defun c:offtosl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit"))(t (princ))) (aoff_to_which_ltype sys_CONT_ltype sys_CONT_ltypecol) )
(defun c:offtotl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit"))(t (princ)))(aoff_to_which_ltype  sys_CONT1_ltype sys_CONT1_ltypecol))
(defun c:offtodl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit"))(t (princ)))(aoff_to_which_ltype  sys_dashed_ltype sys_dashed_ltypecol))
(defun c:offtosdl()(c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit"))(t (princ))) (aoff_to_which_ltype sys_dashed1_ltype sys_dashed1_ltypecol))
(defun c:offtocl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit"))(t (princ)))(aoff_to_which_ltype  sys_center_ltype sys_center_ltypecol))
(defun c:offtoscl()(c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit"))(t (princ))) (aoff_to_which_ltype sys_stcenter_ltype sys_stcenter_ltypecol))
(defun c:offtopl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit"))(t (princ)))(aoff_to_which_ltype  sys_phantom_ltype sys_phantom_ltypecol))
(defun c:offtospl()(c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit"))(t (princ))) (aoff_to_which_ltype sys_phantom1_ltype sys_phantom1_ltypecol))
(defun c:offtohl() (c:autoload) (cond ((null aoff_to_which_ltype)(load "auxedit"))(t (princ)))(aoff_to_which_ltype  sys_hatch_ltype sys_hatch_ltypecol))
