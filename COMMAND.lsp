;;;
;;;
;;;
;;(if (= 0 (getvar "dimscale")) (setvar "dimscale" 1))
;;(setvar "dimtdec" 8)
;;=============================================================================================
(defun c:autoload()
  ;; DraftSight 2025 移植版本：
  ;; 移除加密狗判斷 (/= jin "#$%")(/= #### 85)，改為只判斷路徑是否已載入
  (if (null POWDESIGN_path)
    (progn
      (princ "\n載入機械設計家系統中...")
      (load "designer")
      (if (null POWDESIGN_path)
        (load "config")
      )
      (loaddesigner)
      ;; campro 模組：有安裝才載入
      (if (findfile (strcat POWDESIGN_path "campro.lsp"))
        (progn
          (load "campro")
          (if (= "1" (getini (strcat POWDESIGN_path "campro.ini") "SHEET" "update"))
            (progn
              (setq DrawNo (string_remove (getvar "DWGNAME") ".DWG"))
              (startapp "campro.exe" (strcat DrawNo ";0"))
            )
          )
        )
      )
    )
  )
)


;;�ͬf�Ȼs
(defun c:campro_change_onoff() (change_onoff))	;;�۰ʧ�s�}��
(defun c:campro_update_sheet() (update_sheet))	;;��s�Ϯظ��
(defun c:campro_sheet_to_pdm() (sheet_to_pdm))	;;�Ϯظ�Ƽg�JPDM
(defun c:campro_auto_shscal()  (campro_shscal)) ;;PDM��Ϯةw���
(defun c:campro_cap_sybom() (c:autoload) (campro_sybom)) ;;�զX�Ϯظ�Ƽg�JPDM

;;�ϥΪ̦۩w�Ϯw
(defun c:userblk1()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC) (cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "BOM2" "poweriso" 0))
(defun c:userblk2()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "BOM2" "poweriso" 0))

;;�o�����Ÿ�
(defun c:oilgas1()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC) (cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "GASE&OIL" "poweriso" 0))
(defun c:oilgas2()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "GASE&OIL" "poweriso" 0))

;;�o����
(defun c:OILTANK1()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "OILTANK" "poweriso" 0))
(defun c:OILTANK2()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "OILTANK" "poweriso" 0))
;;������
(defun c:GASTANK1()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "GASTANK" "poweriso" 0))
(defun c:GASTANK2()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "GASTANK" "poweriso" 0))
;;���u�u�]Ũ�M
(defun c:LINEBUSH1()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "LINEBUSH" "poweriso" 0))
(defun c:LINEBUSH2()(c:autoload) (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "LINEBUSH" "poweriso" 0))
;;�L�ʶ}��
(defun c:LINESWITCH1()(c:autoload)(setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "LINESWITCH" "poweriso" 0))
(defun c:LINESWITCH2()(c:autoload)(setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "LINESWITCH" "poweriso" 0))
;;�u�ʷƭy
(defun c:LINERULE1()(c:autoload)(setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "LINERULE" "poweriso" 0))
(defun c:LINERULE2()(c:autoload)(setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "LINERULE" "poweriso" 0))
;;�ֳt����
(defun c:QUICKTAH1()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblkm "userblkm" "userblkm" "QUICKTAH" "poweriso" 0))
(defun c:QUICKTAH2()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "QUICKTAH" "poweriso" 0))
;;������
(defun c:HRINGS1()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblkm)(load "userblkm"))(t (princ))) (userblku "userblkm" "userblkm" "HRINGS" "poweriso" 0))
(defun c:HRINGS2()(c:autoload)  (setq dclmenu_path bmanager_path)(PRINC)(cond ((null userblku)(load "userblku"))(t (princ))) (userblku "userblku" "userblku" "HRINGS" "poweriso" 0))

(defun c:callcalc()(c:autoload) (startapp "calc"))
(defun c:manauser_menu()(c:autoload)(cond ((null c:manamenu)(load "userMENU"))(t (princ))) (c:manamenu "usermenu.mnu" "usermenu" "manamenu"))
(defun loaddesigner()(cond ((null c:#setting)(load "system"))(t (princ))))


(setq  sysdrawbar1     "���Uø��(�@)"
       sysdrawbar2     "���Uø��(�G)"
       syseditbar1     "���U�s��(�@)"
       syseditbar2     "���U�s��(�G)"
       sysprojbar      "��v�u"
       syssetlinebar   "�@�Ͻu�ʳ]�w"
       sysauxdimbar1   "���U�е��@"
       sysauxdimbar2   "���U�е��G"
       sysauxdimbar3   "�X�X���t�е�"
       sysbombar       "�զX�ϻP���ƲM��"
       syslayerbar     "�ϼh����"
       sysquarbar      "��Ƭd��"
       sysscrewbar     "��ѻP����"
       sysshaftbar     "�b���;�"
       sysosnapbar     "���I�Ҧ���"
       sysshscalbar    "��Ϯةw���"
       sysblkmanbar    "�}��Ϯw"
       syscal&lib      "��w�P�p���")

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

;;�\������O
(defun c:&cns_finish()(c:autoload) (cond ((null c:cns_finish)(load "auxdim"))(t (princ))) (c:cns_finish))            ;[CNS �[�u�Ÿ�]
(defun c:&out_l_r_arc()(c:autoload) (cond ((null c:out_l_r_arc)(load "auxdim"))(t (princ))) (c:out_l_r_arc))         ;[���k�A��]
(defun c:&out_cns_finish()(c:autoload) (cond ((null c:out_cns_finish)(load "auxdim"))(t (princ))) (c:out_cns_finish));[����ʥ[�u�Ÿ�]
(defun c:&jis_finish()(c:autoload) (cond ((null c:jis_finish)(load "auxdim"))(t (princ))) (c:jis_finish))            ;[JIS �[�u�Ÿ�]
;;-------
(defun c:&autoSHSCAL()(c:autoload) (cond ((null c:SHSCAL)(load "SHSCAL"))(t (princ))) (c:autoSHSCAL)) ;[��Ϯةw���]
(defun c:&resetting()(c:autoload) (cond ((null c:resetting)(load "SHSCAL"))(t (princ))) (c:resetting)) ;[���]���]
(defun c:&SCAL()(c:autoload) (cond ((null c:scal)(load "aux-qury"))(t (princ))) (c:SCAL)) ;[��Ҭd��]
(defun c:&chsheet_att()(c:autoload) (cond ((null c:chsheet_att)(load "SHSCAL"))(t (princ))) (c:chsheet_att)) ;[�ק�Ϯ��ݩ�]
(defun c:&autoplot()(c:autoload) (cond ((null c:autoplot)(load "autoplot"))(t (princ))) (c:autoplot)) ;[�۰ʳs��X��]
(defun c:&draw_autoplot()(c:autoload) (cond ((null c:draw_autoplot)(load "plotset"))(t (princ))) (c:draw_autoplot)) ;[�۰ʳs��X��]
;;-------
(defun c:&cap_sybom()(c:autoload) (cond ((null c:cap_sybom)(load "PDMBOM3"))(t (princ))) (c:cap_sybom))
(defun c:&insline()(c:autoload) (cond ((null c:insline)(load "insline"))(t (princ))) (c:insline))
(defun c:&hp()(c:autoload) (cond ((null c:hp)(load "hp-k"))(t (princ))) (c:hp))
(defun c:&hp2()(c:autoload) (cond ((null c:hp2)(load "hp-k"))(t (princ))) (c:hp2))
(defun c:&hp3()(c:autoload) (cond ((null c:hp3)(load "hp-k"))(t (princ))) (c:hp3))
(defun c:&batch_plot()(c:autoload) (cond ((null c:batch_plot)(load "hp-k"))(t (princ))) (c:batch_plot))
;;-------
(defun c:&asctext()(c:autoload) (cond ((null c:asctext)(load "asctext"))(t (princ))) (c:asctext)) ;[���J��r��]
;;-------
(defun c:&chtosl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtosl))   ;[�ʳs��u]
(defun c:&chtotl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtotl))   ;[�ӳs��u]
(defun c:&chtocl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtocl))   ;[�зǤ��߽u]
(defun c:&chtocl2()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtocl2)) ;[�u���߽u]
(defun c:&chtodl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtodl))   ;[�зǵ�u]
(defun c:&chtoSdl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtoSdl)) ;[�u��u]
(defun c:&chtopl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtopl))   ;[�зǰ��Q�u]
(defun c:&chtoSpl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtoSpl)) ;[�u���Q�u]
(defun c:&chtohl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ))) (c:chtohl))   ;[�孱�u]
(defun c:&chtodim()(c:autoload) (chltype "continuous" "3")) ;[�ؤo�u]

;;--------�t���ܼƳ]�w
(defun c:&tran_act()(c:autoload)(load "tran_act") (c:tran_act));�¹���s��(����)

(defun c:&transdwg()(c:autoload)(load "transdwg") (c:transdwg));�¹���s��(�]�w)
(defun c:&auto_ch_clk_scal()(c:autoload) (cond ((null c:setosmode)(load "dfsystem"))(t (princ))) (c:auto_ch_clk_scal)) ;[����ܰʮɷ|�s�ʪ�BLOCK
(defun c:&setosmode()(c:autoload) (cond ((null c:setosmode)(load "dfsystem"))(t (princ))) (c:setosmode)) ;[���I�Ҧ��էO�w�q]
(defun c:&defball()(c:autoload) (cond ((null c:defball)(load "dfsystem"))(t (princ)))(c:defball)) ;[���вy�w�q]
(defun c:&defbomlist()(c:autoload) (cond ((null c:defbomlist)(load "dfsystem"))(t (princ)))(c:defbomlist)) ;[���ƲM����e�w�q]
(defun c:&defltype()(c:autoload) (cond ((null c:defltype)(load "dfsystem"))(t (princ)))(c:defltype)) ;[�]�w�u���t���ܼ�]
(defun c:&deflayer()(c:autoload) (cond ((null c:deflayer)(load "dfsystem"))(t (princ)))(c:deflayer)) ;[�]�w�ϼh�t���ܼ�]
(defun c:&defdate_type()(c:autoload) (cond ((null c:defdate_type)(load "dfsystem"))(t (princ)))(c:defdate_type)) ;[�Ϯؤ������]
(defun c:&passdfac()(c:autoload) (cond ((null c:passdfac)(load "dfsystem"))(t (princ))) (c:passdfac))    ;�s��զX�ɹw�]���C��                    ;�s��զX�ɹw�]���C��]^C^C
(defun c:&psdellay()(c:autoload) (cond ((null c:psdellay)(load "dfsystem"))(t (princ))) (c:psdellay))    ;�s��զX�ɧR�����ϼh
(defun c:&psdelblk()(c:autoload) (cond ((null c:psdelblk)(load "dfsystem"))(t (princ))) (c:psdelblk))    ;�s��զX�ɧR�����϶�
(defun c:&auntklay()(c:autoload) (cond ((null c:auntklay)(load "dfsystem"))(t (princ))) (c:auntklay))    ;�۰ʩ�Ϯɤ���h
(defun c:&ncinplay()(c:autoload) (cond ((null c:ncinplay)(load "dfsystem"))(t (princ))) (c:ncinplay))    ;���إ߸�T�I���ϼh
(defun c:&auntkblk()(c:autoload) (cond ((null c:auntkblk)(load "dfsystem"))(t (princ))) (c:auntkblk))    ;�۰ʩ�Ϯɤ���϶�
(defun c:&lt_prtdd()(c:autoload) (cond ((null c:lt_prtdd)(load "dfsystem"))(t (princ))) (c:lt_prtdd))    ;�s��w�q���
(defun c:&goac_inp()(c:autoload) (cond ((null c:goac_inp)(load "dfsystem"))(t (princ))) (c:goac_inp))    ;���¹Ϯ��ݩʫظ�T�I
(defun c:&odshtblk()(c:autoload) (cond ((null c:odshtblk)(load "dfsystem"))(t (princ))) (c:odshtblk))    ;�¹Ϯ��ݩ�BLOCK�W��
(defun c:&lt_map()(c:autoload) (cond ((null c:lt_map)(load "dfsystem"))(t (princ))) (c:lt_map))        ;�¹Ϯ��ݩʹ�����T��
(defun c:&trapmage()(c:autoload) (cond ((null c:trapmage)(load "dfsystem"))(t (princ))) (c:trapmage))  ;���ިt�κ޲z
(defun c:&signing()(c:autoload) (cond ((null c:signing)(load "dfsystem"))(t (princ))) (c:signing));�f��ñ�W���
(defun c:&sheetset()(c:autoload) (cond ((null c:sheetset)(load "sheetset"))(t (princ)))(c:sheetset)) ;[�Ϯس]�w]
(defun c:&modsheetset()(c:autoload) (cond ((null c:modsheetset)(load "sheetset"))(t (princ)))(c:modsheetset)) ;[�ק�Ϯس]�w]
;;--------
(defun c:&manauser_menu()(c:autoload) (cond ((null c:usermake_part_sld)(load "userMENU"))(t (princ))) (c:manauser_menu)) ;[�޲z�۫إ\��]
(defun c:&usermake_part_sld()(c:autoload) (cond ((null c:usermake_part_sld)(load "userMENU"))(t (princ)))(c:usermake_part_sld)) ;[�s�@�\��ۿO��]
;;;--------
(defun c:&mc()(c:autoload) (cond ((null c:mc)(load "auxdraw1"))(t (princ))) (c:mc)) ;�e���ζ�
(defun c:&POLCIR()(c:autoload) (cond ((null c:POLCIR)(load "auxdraw1"))(t (princ))) (c:POLCIR)) ;�Z��-���� ��
(defun c:&XYCIR()(c:autoload) (cond ((null c:XYCIR)(load "auxdraw1"))(t (princ))) (c:XYCIR))    ;X-Y ��
(defun c:&2cir()(c:autoload) (cond ((null c:2cir)(load "auxdraw1"))(t (princ))) (c:2cir))       ;�����׵e��
(defun c:&3e()(c:autoload) (cond ((null c:3e)(load "auxdraw1"))(t (princ))) (c:3e))             ;�x��
(defun c:&srect()(c:autoload) (cond ((null c:srect)(load "auxdraw1"))(t (princ))) (c:srect))    ;�x��
(defun c:&crect()(c:autoload) (cond ((null c:crect)(load "auxdraw1"))(t (princ))) (c:crect))    ;�x��
(defun c:&srect1()(c:autoload) (cond ((null c:srect1)(load "auxdraw1"))(t (princ))) (c:srect1)) ;�x��
(defun c:&mrect()(c:autoload) (cond ((null c:mrect)(load "auxdraw1"))(t (princ))) (c:mrect))    ;�x��
(defun c:&codim()(c:autoload) (cond ((null c:co)(load "auxdraw1"))(t (princ))) (c:codim))       ;�ꨤ���U�е��ϧ�
(defun c:&codim1()(c:autoload) (cond ((null c:co1)(load "auxdraw1"))(t (princ))) (c:codim1))    ;�ꨤ���U�е��ϧ�
(defun c:&c-slot()(c:autoload) (cond ((null c:c-slot)(load "auxedit"))(t (princ))) (c:c-slot))  ;�z�����s�Τ�
;;;--------
(defun c:&sec5()(c:autoload) (cond ((null c:sec5)(load "auxdraw1"))(t (princ)))(c:sec5)) ;�s��孱
(defun c:&sec1()(c:autoload) (cond ((null c:sec1)(load "auxdraw1"))(t (princ)))(c:sec1)) ;�孱
(defun c:&sec2()(c:autoload) (cond ((null c:sec2)(load "auxdraw1"))(t (princ)))(c:sec2)) ;�孱��r
(defun c:&sec3()(c:autoload) (cond ((null c:sec3)(load "auxdraw1"))(t (princ)))(c:sec3)) ;�ԹϤ�r
(defun c:&sec4()(c:autoload) (cond ((null c:sec4)(load "auxdraw1"))(t (princ)))(c:sec4)) ;�Թϫ���
(defun c:&sec6()(c:autoload) (cond ((null c:sec6)(load "auxdraw1"))(t (princ)))(c:sec6)) ;�Թϫ���( ? �ڵ���)
(defun c:&cen1()(c:autoload) (cond ((null c:cen1)(load "auxdraw1"))(t (princ)))(c:cen1)) ;�b���߽u
(defun c:&cen2()(c:autoload) (cond ((null c:cen2)(load "auxdraw1"))(t (princ)))(c:cen2)) ;�ꤤ�߽u
(defun c:&stock()(c:autoload) (cond ((null c:stock)(load "auxdraw1"))(t (princ)))(c:stock)) ;���U�e�T����
(defun c:&mcir()(c:autoload) (cond ((null c:wcir)(load "auxdraw1"))(t (princ)))(c:mcir)) ;�P�߶�
(defun c:&wedmark()(c:autoload) (cond ((null c:wedmark)(load "auxdim"))(t (princ)))(c:wedmark)) ;�����I
(defun c:&holemark()(c:autoload) (cond ((null c:holemark)(load "auxdraw1"))(t (princ)))(c:holemark)) ;��ǤղŸ�
;;;--------
(defun c:&chtobyl()(c:autoload) (cond ((null c:chtobyl)(load "auxedit"))(t (princ)))(c:chtobyl))    ;�ܴ���BYLAYER�u��
(defun c:&chtobylk()(c:autoload) (cond ((null c:chtobylk)(load "auxedit"))(t (princ)))(c:chtobylk)) ;�ܴ���BYBLOCK�u��
(defun c:&chtosl()(c:autoload) (cond ((null c:chtosl)(load "auxedit"))(t (princ)))(c:chtosl))    ;�ܴ��ʳs��u��
(defun c:&chtocl()(c:autoload) (cond ((null c:chtocl)(load "auxedit"))(t (princ)))(c:chtocl))    ;�ܴ��зǤ��߽u��
(defun c:&chtocl2()(c:autoload) (cond ((null c:chtocl2)(load "auxedit"))(t (princ)))(c:chtocl2)) ;�ܴ��u���߽u��
(defun c:&chtotl()(c:autoload) (cond ((null c:chtotl)(load "auxedit"))(t (princ)))(c:chtotl))    ;�ܴ��ӳs��u��
(defun c:&chtodl()(c:autoload) (cond ((null c:chtodl)(load "auxedit"))(t (princ)))(c:chtodl))    ;�ܴ���u��
(defun c:&chtopl()(c:autoload) (cond ((null c:chtopl)(load "auxedit"))(t (princ)))(c:chtopl))    ;�ܴ����Q�u��
(defun c:&chtohl()(c:autoload) (cond ((null c:chtohl)(load "auxedit"))(t (princ)))(c:chtohl))    ;�ܴ��孱�u��
(defun c:&1CHAM()(c:autoload) (cond ((null c:1CHAM)(load "auxedit"))(t (princ)))(c:1CHAM))    ;�O�d�@��ɨ�
(defun c:&1FILL()(c:autoload) (cond ((null c:1FILL)(load "auxedit"))(t (princ)))(c:1FILL))    ;�O�d�@��ꨤ
(defun c:&c&r&lt()(c:autoload) (cond ((null c:c&r&lt)(load "auxedit"))(t (princ)))(c:c&r&lt)) ;����,���ഫ�u��
(defun c:&c&r&la()(c:autoload) (cond ((null c:c&r&la)(load "auxedit"))(t (princ)))(c:c&r&la)) ;����,���ഫ�ϼh
(defun c:&c&s()(c:autoload) (cond ((null c:c&s)(load "auxedit"))(t (princ)))(c:c&s))          ;�������Y����
;;;���U�s��(�G)
(defun c:&bshaft()(c:autoload) (cond ((null c:bshaft)(load "auxedit"))(t (princ)))(C:bshaft))         ;�I�_�b
(defun c:&sheetbrk()(c:autoload) (cond ((null c:sheetbrk)(load "auxdraw"))(t (princ))) (c:sheetbrk))  ;�z���I�_�u
(defun c:&mbreak()(c:autoload)   (cond ((null c:mbreak)(load "auxdraw1"))(t (princ))) (c:mbreak))     ;�s����I�I�_
(defun c:&mbrl()(c:autoload)     (cond ((null c:mbrl)(load "auxdraw1"))(t (princ))) (c:mbrl))         ;�s��I�_��e�I
(defun c:&cirhi()(c:autoload)    (cond ((null c:cirhi)(load "auxdraw1"))(t (princ))) (c:cirhi))       ;��γQ�e���B��
(defun c:&1hid()(c:autoload)     (cond ((null c:1hid)(load "auxdraw1"))(t (princ))) (c:1hid))         ;�u�q�Q�e���B��
(defun c:&ext()(c:autoload)      (cond ((null c:ext)(load "auxdraw1"))(t (princ))) (c:ext))           ;�����u�q
(defun c:&aoff()(c:autoload)     (cond ((null c:aoff)(load "auxedit"))(t (princ))) (c:aoff))          ;OFFSET�ܴ��u��
(defun c:&offl()(c:autoload)     (cond ((null c:offl)(load "auxedit"))(t (princ))) (c:offl))          ;OFFSET�ܴ��ϼh
;;;���U�s��(�T)
(defun c:&cir_enLg()(c:autoload)     (cond ((null c:c:cir_enLg)(load "cir_enLg"))(t (princ))) (c:cir_enLg))       ;��Χ�����j
(defun c:&rec_enLg()(c:autoload)     (cond ((null c:c:rec_enLg)(load "rec_enLg"))(t (princ))) (c:rec_enLg))       ;�x�Χ�����j
(defun c:&hkring1()(c:autoload)      (cond ((null c:hkring1)(load "auxedit"))(t (princ))) (c:hkring1))            ;������(�ե�)
(defun c:&hkring2()(c:autoload)      (cond ((null c:hkring2)(load "auxedit"))(t (princ))) (c:hkring2))            ;������(�b��)
;;��v�u
(defun c:&pul()(c:autoload)      (cond ((null c:pul)(load "projline"))(t (princ)))(c:pul))                ;�����v�u
(defun c:&pur()(c:autoload)      (cond ((null c:pur)(load "projline"))(t (princ)))(c:pur))                ;�����v�u
(defun c:&pdl()(c:autoload)      (cond ((null c:pdl)(load "projline"))(t (princ)))(c:pdl))                ;�����v�u
(defun c:&pdr()(c:autoload)      (cond ((null c:pdr)(load "projline"))(t (princ)))(c:pdr))                ;�����v�u
(defun c:&delproj()(c:autoload)  (cond ((null c:delproj)(load "projline"))(t (princ)))(c:delproj))        ;������v�u
(defun c:&hline()(c:autoload)    (cond ((null c:hline)(load "projline"))(t (princ)))(c:hline))            ;������v�u
(defun c:&vline()(c:autoload)    (cond ((null c:vline)(load "projline"))(t (princ)))(c:vline))            ;������v�u
(defun c:&hvline()(c:autoload)   (cond ((null c:hvline)(load "projline"))(t (princ)))(c:hvline))          ;�Q�r��v�u
(defun c:&tline()(c:autoload)    (cond ((null c:tline)(load "projline"))(t (princ)))(c:tline))            ;���ק�v�u
(defun c:&ptline()(c:autoload)   (cond ((null c:ptline)(load "projline"))(t (princ)))(c:ptline))          ;�P�u�����v�u
(defun c:&vtline()(c:autoload)   (cond ((null c:vtline)(load "projline"))(t (princ)))(c:vtline))          ;�P�u������v�u
(defun c:&angline()(c:autoload)  (cond ((null c:angline)(load "projline"))(t (princ)))(c:angline))        ;���N���ק�v�u
(defun c:&ofpjline()(c:autoload) (cond ((null c:ofpjline)(load "projline"))(t (princ)))(c:ofpjline))      ;������v�u
;;���U�е��@
(defun c:&rectdim()(c:autoload)    (cond ((null c:rectdim)(load "auxdim"))(t (princ)))(c:rectdim))        ;����е��Ÿ�
(defun c:&facedim1()(c:autoload)   (cond ((null c:rectdim)(load "auxdim"))(t (princ)))(c:facedim1))       ;���е��Ÿ�
(defun c:&facedim2()(c:autoload)   (cond ((null c:rectdim)(load "auxdim"))(t (princ)))(c:facedim2))       ;���е��Ÿ�
(defun c:&refdim()(c:autoload)     (cond ((null c:autodim)(load "auxdim"))(t (princ)))(c:refdim))         ;�ѦҼе��Ÿ�
(defun c:&diadim()(c:autoload)     (cond ((null c:autodim)(load "auxdim"))(t (princ)))(c:diadim))         ;���|�е��Ÿ�
(defun c:&autodia()(c:autoload)    (cond ((null c:autodim)(load "auxdim"))(t (princ)))(c:autodia))        ;���|�е�
(defun c:&rtdim()(c:autoload)      (cond ((null c:autodim)(load "auxdim"))(t (princ)))(c:rt_dim))         ;�٭�
(defun c:&con_dim()(c:autoload)    (cond ((null c:con_dim)(load "auxdim"))(t (princ)))(c:con_dim))        ;�o�s��е�
(defun c:&wedding1()(c:autoload)    (cond ((null c:wedding)(load "auxdim"))(t (princ)))(wedding 1))       ;�亲��
(defun c:&wedding2()(c:autoload)    (cond ((null c:wedding)(load "auxdim"))(t (princ)))(wedding 2))       ;���亲��
(defun c:&chg_dim()(c:autoload)    (cond ((null c:chg_dim)(load "auxdim"))(t (princ)))(c:chg_dim))        ; ��(�����)
(defun c:&d-tol()(c:autoload)      (cond ((null c:chg_dim)(load "auxdim"))(t (princ)))(c:d-tol))          ; �е�(������)
(defun c:&no_tol()(c:autoload)     (cond ((null c:no_tol)(load "auxdim"))(t (princ)))(c:no_tol))          ;���t�е�
(defun c:&toler_hole()(c:autoload) (cond ((null c:toler_hole)(load "auxdim"))(t (princ)))(c:toler_hole))  ;�դؤo�e�\�t
(defun c:&toler_sha()(c:autoload)  (cond ((null c:toler_sha)(load "auxdim"))(t (princ)))(c:toler_sha))    ;�b�ؤo�e�\�t
;;���U�е��G
(defun c:&mdim()(c:autoload)        (cond ((null c:mdim)(load "mdim"))(t (princ)))(c:mdim))               ;���I�е��k
(defun c:&newmo()(c:autoload)       (cond ((null c:newmo)(load "auxdraw1"))(t (princ)))(c:newmo))         ;�]�w x,y �s���I
(defun c:&wcood1()(c:autoload)      (cond ((null c:wcood)(load "auxdraw1"))(t (princ)))(c:wcood 1))       ;�g�X�y��x,y
(defun c:&wcood3()(c:autoload)      (cond ((null c:wcood)(load "auxdraw1"))(t (princ)))(c:wcood 3))       ;�g�X�y��(x,y)
(defun c:&lexplode()(c:autoload)    (cond ((null c:lexplode)(load "auxdim"))(t (princ)))(c:lexplode))     ;�ؤo�z���^��h
(defun c:&autolead()(c:autoload)    (cond ((null c:autolead)(load "auxdim"))(t (princ)))(c:autolead))     ;�޽u�a��w(����)
(defun c:&autolead2()(c:autoload)   (cond ((null c:autolead2)(load "auxdim"))(t (princ)))(c:autolead2))   ;�޽u�a��w(����)
(defun c:&dimcham()(c:autoload)     (cond ((null c:dimcham)(load "auxdim"))(t (princ)))(c:dimcham))       ;45�׭˨��е�
(defun c:&dimcham2()(c:autoload)     (cond ((null c:dimcham)(load "auxdim"))(t (princ)))(c:dimcham2))     ;45�׭˨��е�
(defun c:&cring_auxdim()(c:autoload)  (cond ((null c:dimcham)(load "auxdim"))(t (princ)))(c:cring_auxdim));�����е�
(defun c:&keydim()(c:autoload)        (cond ((null c:keydim)(load "auxdim"))(t (princ)))(c:keydim))       ;�����y�е�
;;�X�X���t�е�
(defun c:&dimgeo()(c:autoload) (cond ((null c:dimgeo)(load "auxdim"))(t (princ)))(c:dimgeo))               ;�X�󤽮t�е�
(defun c:&dimgeo_base()(c:autoload) (cond ((null c:dimgeo_base)(load "auxdim"))(t (princ)))(c:dimgeo_base));�X�󤽮t�е�(��ǭ�)
(defun c:&bsline()(c:autoload)  (cond ((null c:bsline)(load "auxdim"))(t (princ)))(c:bsline))              ;��ǽu
(defun c:&lealine()(c:autoload) (cond ((null c:lealine)(load "auxdim"))(t (princ)))(c:lealine))            ;���޽u
(defun c:&dim-gbase()(c:autoload)(cond ((null c:dim-gbase)(load "auxdim"))(t (princ)))(c:dim-gbase))       ;��ǭ�
;;�զX�ϻP���ƲM��
(defun c:&AUTObom90()(c:autoload)  (cond ((null bom)(load "bom"))(t (princ))) (AUTObom 90))   ;�V�W�w�Z(�s��)
(defun c:&AUTObom270()(c:autoload) (cond ((null bom)(load "bom"))(t (princ))) (AUTObom 270))  ;�V�U�w�Z(�s��)
(defun c:&AUTObom0()(c:autoload)   (cond ((null bom)(load "bom"))(t (princ))) (AUTObom 0))    ;�V���w�Z(�s��)
(defun c:&AUTObom180()(c:autoload) (cond ((null bom)(load "bom"))(t (princ))) (AUTObom 180))  ;�V�k�w�Z(�s��)
(defun c:&keyin_bom90()(c:autoload)     (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 90))   ;�V�W�w�Z(���s��)
(defun c:&keyin_bom270()(c:autoload)    (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 270))  ;�V�U�w�Z(���s��)
(defun c:&keyin_bom0()(c:autoload)      (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 0))    ;�V���w�Z(���s��)
(defun c:&keyin_bom180()(c:autoload)    (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 180))  ;�V�k�w�Z(���s��)
(defun c:&autobom1()(c:autoload)        (cond ((null bom)(load "bom"))(t (princ)))(autobom 1))      ;�ۥѩԥX(�s��)
(defun c:&keyin_bom1()(c:autoload)      (cond ((null bom)(load "bom"))(t (princ)))(keyin_bom 1))    ;�ۥѩԥX(���s��)
(defun c:&addbomtxt_xdata()(c:autoload) (cond ((null bom)(load "bom"))(t (princ)))(C:addbomtxt_xdata))   ;�s����вy
(defun c:&drawbom_list()(c:autoload)    (cond ((null bom)(load "bom"))(t (princ)))(C:drawbom_list))      ;���ͧ��Ƴ�ϧ�
(defun c:&delbom_list()(c:autoload)     (cond ((null bom)(load "bom"))(t (princ)))(C:delbom_list))       ;�R�����Ƴ�ϧ�
(defun c:&bomlist_txt()(c:autoload)     (cond ((null bom)(load "bom"))(t (princ)))(C:bomlist_txt))       ;���ͧ��Ƴ��r��
(defun c:&out()(c:autoload)             (cond ((null bom)(load "bom"))(t (princ)))(c:out))               ;�զX�ϩ�X�s���
(defun c:&in()(c:autoload)              (cond ((null bom)(load "bom"))(t (princ)))(c:in))                ;�s��ϲո˦��զX��
;;;;;;�Ѹ�T�I���ͫ��вy
(defun c:&AUTObom90_info()(c:autoload)  (cond ((null manaball)(load "manaball"))(t (princ))) (AUTObom_info 90))   ;�V�W�w�Z(�s��)
(defun c:&AUTObom270_info()(c:autoload) (cond ((null manaball)(load "manaball"))(t (princ))) (AUTObom_info 270))  ;�V�U�w�Z(�s��)
(defun c:&AUTObom0_info()(c:autoload)   (cond ((null manaball)(load "manaball"))(t (princ))) (AUTObom_info 0))    ;�V���w�Z(�s��)
(defun c:&AUTObom180_info()(c:autoload) (cond ((null manaball)(load "manaball"))(t (princ))) (AUTObom_info 180))  ;�V�k�w�Z(�s��)
(defun c:&keyin_bom90_info()(c:autoload)     (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 90))   ;�V�W�w�Z(���s��)
(defun c:&keyin_bom270_info()(c:autoload)    (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 270))  ;�V�U�w�Z(���s��)
(defun c:&keyin_bom0_info()(c:autoload)      (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 0))    ;�V���w�Z(���s��)
(defun c:&keyin_bom180_info()(c:autoload)    (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 180))  ;�V�k�w�Z(���s��)
(defun c:&autobom1_info()(c:autoload)        (cond ((null manaball)(load "manaball"))(t (princ)))(autobom_info 1))          ;�ۥѩԥX(�s��)
(defun c:&keyin_bom1_info()(c:autoload)      (cond ((null manaball)(load "manaball"))(t (princ)))(keyin_bom_info 1))      ;�ۥѩԥX(���s��)
;;�ϼh����
(defun c:&pshow()(c:autoload)      (cond ((null c:pshow)(load "LAYER"))(t (princ)))(c:pshow))                 ;��ܼh
(defun c:&phide()(c:autoload)      (cond ((null c:phide)(load "LAYER"))(t (princ)))(c:phide))                 ;���üh
(defun c:&BSHOW()(c:autoload)      (cond ((null c:BSHOW)(load "LAYER"))(t (princ)))(c:BSHOW))                 ;��� BLOCK
(defun c:&ashow()(c:autoload)      (cond ((null c:ASHOW)(load "LAYER"))(t (princ)))(c:ASHOW))                 ;�������
(defun c:&THRAW()(c:autoload)      (cond ((null c:THRAW)(load "LAYER"))(t (princ)))(c:THRAW))                 ;�ѭ�h
(defun c:&PFREE()(c:autoload)      (cond ((null c:PFREE)(load "LAYER"))(t (princ)))(c:PFREE))                 ;�N��h
(defun c:&LTCONTROL()(c:autoload)  (cond ((null c:LTCONTROL)(load "LAYER"))(t (princ)))(c:LTCONTROL))         ;�u����ܱ���
(defun c:&mlc()(c:autoload)        (cond ((null c:MLC)(load "LAYER"))(t (princ)))(c:MLC))                     ;�s�@�h
(defun c:&AUTOMLC()(c:autoload)    (cond ((null c:AUTOMLC)(load "LAYER"))(t (princ)))(c:AUTOMLC))             ;�إ߳s��ϼh
(defun c:&CHLAY()(c:autoload)      (cond ((null c:CHLAY)(load "LAYER"))(t (princ)))(c:CHLAY))                 ;���ܼh
(defun c:&CHto_clayer()(c:autoload)(cond ((null c:CHto_clayer)(load "LAYER"))(t (princ)))(c:CHto_clayer))     ;�ܴ��Ϥ���ثe�h
(defun c:&DLAY()(c:autoload)       (cond ((null c:DLAY)(load "LAYER"))(t (princ)))(c:DLAY))                   ;�R���h
(defun c:&SLAY()(c:autoload)       (cond ((null c:SLAY)(load "LAYER"))(t (princ)))(c:SLAY))                   ;���w�ثe�h
(defun c:&LCONTROL()(c:autoload)   (cond ((null c:LCONTROL)(load "LAYER"))(t (princ)))(c:LCONTROL))           ;��J�h�W�H����ϼh
(defun c:&SLTYPE()(c:autoload)     (cond ((null c:SLTYPE)(load "LAYER"))(t (princ)))(c:SLTYPE))               ;�u�����
(defun c:&SPART()(c:autoload)      (cond ((null c:SPART)(load "LAYER"))(t (princ)))(c:SPART))                 ;�h�����
(defun c:RS()(c:autoload)      (cond ((null c:ASHOW)(load "LAYER"))(t (princ)))(c:ASHOW))                 ;�������
(defun c:LS()(c:autoload)      (cond ((null c:pshow)(load "LAYER"))(t (princ)))(c:pshow))
;;��Ƭd��
(defun c:&ironsize1()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 1))
(defun c:&ironsize2()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 2))
(defun c:&carqury2()(c:autoload)   (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(carqury 2))
(defun c:&ironsize3()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 3))  ;�¥տ��޳W��
(defun c:&ironsize4()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 4))  ;�տ��޳W��
(defun c:&funcc()(c:autoload)      (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(c:funcc))     ;�q�p��k
(defun c:&ironsize5()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 5))  ;�O
(defun c:&ironsize6()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 6))  ;���K
(defun c:&ironsize7()(c:autoload)  (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(ironsize 7))  ;�T���K
(defun c:&carqury1()(c:autoload)   (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(carqury 1))   ;�o��
(defun c:&e-len()(c:autoload)      (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(c:e-len))     ;�^�����
(defun c:&d-2p()(c:autoload)       (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(c:d-2p))      ;�^��Z��
(defun c:&arclen()(c:autoload)     (cond ((null c:ironsize)(load "aux-qury"))(t (princ)))(c:arclen))    ;��
;;��ѻP����
(defun c:&SLOT4()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT4)) ;������
(defun c:&SLOT1()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT1)) ;������
(defun c:&SLOT2()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT2)) ;������
(defun c:&SLOT5()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT5)) ;������
(defun c:&SLOT3()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:SLOT3)) ;�b����
(defun c:&lc()(c:autoload) (cond ((null c:SLOT4)(load "DRAWMECH"))(t (princ)))(c:lc))       ;�b������
(defun c:&keyway_1()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:keyway_1))    ;����,�e��ѻP��y
(defun c:&keyway_2()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:keyway_2))    ;�L��,�e��ѻP��y
(defun c:&drill5()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:drill5))        ;�p��
(defun c:&drill4()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:drill4))        ;�q
(defun c:&thrill()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:thrill))        ;���
(defun c:&thRILl2()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:thRILl2))      ;���(�q��)
(defun c:&thrill3()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(c:thrill3))      ;�I��������
(defun c:&thrill4()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(C:thrill4))      ;����������
(defun c:&pipscrew()(c:autoload) (cond ((null c:keyway_1)(load "auxdraw"))(t (princ)))(C:pipscrew))    ;��������",
;;�����~��
(defun c:&Screwline()(c:autoload) (cond ((null c:Screwline)(load "scrwline"))(t (princ)))(c:Screwline))
;;���զX 
(defun c:&subsys()    (c:autoload)(cond ((null c:subsys)    (load "s_asmset"))(t (princ)))(c:subsys))
(defun c:&sub_on_off()(c:autoload)(cond ((null c:sub_on_off)(load "s_asmset"))(t (princ)))(c:sub_on_off))
(defun c:&sub_remove()(c:autoload)(cond ((null c:sub_remove)(load "s_asmset"))(t (princ)))(c:sub_remove))
(defun c:&part_cr()   (c:autoload)(cond ((null c:part_cr)   (load "s_asmset"))(t (princ)))(c:part_cr))
(defun c:&part_del()  (c:autoload)(cond ((null c:part_del)  (load "s_asmset"))(t (princ)))(c:part_del))
;;�b���;�
(defun c:&ho1()(c:autoload) (cond ((null c:ho1)(load "auxdraw1"))(t (princ)))(C:ho1))   ;�b�孱
(defun c:&ho2()(c:autoload) (cond ((null c:ho2)(load "auxdraw1"))(t (princ)))(C:ho2))   ;�b�孱
(defun c:&ho()(c:autoload)  (cond ((null c:ho)(load "auxdraw1"))(t (princ)))(C:ho))     ;�b�~��
(defun c:&sha()(c:autoload) (cond ((null c:sha)(load "auxdraw1"))(t (princ)))(C:sha))   ;�b�~��

;;��w�P�p���(��ƦW�٧��ɻݤ@�P��� sheetset.lsp �����W��)
(defun c:&useword()(c:autoload) (cond ((null c:useword)(load "wordlib1"))(t (princ)))(c:useword))       ;�ϥ���w
(defun c:&creatword()(c:autoload) (cond ((null c:creatword)(load "wordlib1"))(t (princ)))(c:creatword)) ;��w�إ�

;;;[�զX�Ͼ�X�\��]
(defun c:&moveparts() (c:autoload)(cond ((null c:moveparts)(load "assembly"))(t (princ)))(c:moveparts)) ;[���ʹs��]
(defun c:&copyparts() (c:autoload)(cond ((null c:copyparts)(load "assembly"))(t (princ)))(c:copyparts)) ;[�ƻs�s��]
(defun c:&delparts()  (c:autoload)(cond ((null c:delparts)(load "assembly"))(t (princ)))(c:delparts))   ;[�R���s��]
(defun c:&roteparts() (c:autoload)(cond ((null c:roteparts)(load "assembly"))(t (princ)))(c:roteparts)) ;[����s��]
(defun c:&mirparts()  (c:autoload)(cond ((null c:mirparts)(load "assembly"))(t (princ)))(c:mirparts))   ;[��g�s��]

;;��Ϯةw���
(defun c:&resetting()(c:autoload)(if (null c:resetting)(load "shscal"))(C:resetting)) ;���]���
(defun c:&ch_sheet()(c:autoload)(load "shscal")(ch_sheet 1)) ;�󴫹Ϯ�
(defun c:&SCAl()(c:autoload) (cond ((null c:scal)(load "aux-qury"))(t (princ)))(C:SCAL)) ;��Ҭd��

;;���I�Ҧ���
(defun c:&setosmode()(c:autoload) (cond ((null c:setosmode)(load "dfsystem"))(t (princ)))(C:setosmode)) ;�]�w���I�Ҧ���

;;���Ƶ��c
(defun c:&makepart()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:makepart))                    ;�إ߷s�s��ϼh
(defun c:&edit_bomp()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:edit_bomp))                  ;�ק��T�I���
(defun c:&addbomp()(c:autoload) (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:addbomp))                    ;�إ߸�T�I(�ۤv��J���)
(defun c:&addbom_olddwg()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:addbom_olddwg))         ;�إ߸�T�I(���X�ϭ��W��r)
(defun c:&addbomp_sheet()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:addbomp_sheet))          ;�إ߸�T�I(�ѹϮ��ݩʵѨ�)
(defun c:&move_bomp()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:move_bomp))                 ;���ʸ�T�I(��ܹϤ�)
(defun c:&on_bomlayer()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:on_bomlayer))              ;���}��T�I
(defun c:&off_bomlayer()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:off_bomlayer))           ;������T�I
(defun c:&automakepart()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:automakepart))           ;�۰ʫإ߸�T�I
(defun c:&layer_how()(c:autoload)  (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:layer_how))               ;�p��s��
(defun c:&creat_bmpf()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ))) (c:creat_bmpf))               ;�إ߼v����
(defun c:&sortcol()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:sortcol))                      ;���Ƶ��c�P���ɺ޲z�����춶��
(defun c:&bomtree1()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(bomtree 1))                     ;���ƲM��ץX��Excel
(defun c:&bomtree0()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(bomtree 0))                     ;���Ƶ��c��
(defun c:&bomtree2()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(bomtree 2))                     ;�s��
(defun c:&bomtree3()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(bomtree 3))                     ;���ƲM��A��s
(defun c:&chlacol()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:chlacol))                      ;��ܹs��s�C��
(defun c:&dwg_libpath()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:defdwg_path)(load "dfsystem"))(t (princ)))(c:dwg_libpath))

(defun c:&opendwg()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:opendwg))                       ;�}�¹�
(defun c:&insdwg()(c:autoload) (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:insdwg))           ;���J�¹�
(defun c:&AUTOB()(c:autoload)  (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:AUTOB))             ;���۰ʫ��вy
(defun c:&pdmwblk()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:pdmwblk))         ;�إߤ��� BLOCK
(defun c:&defbom()(c:autoload) (cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:df_bomdbase)(load "dfsystem"))(t (princ)))(c:defbom))           ;�w�q���ƲM�����
(defun c:&bomlist()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:makepart)(load "manapart"))(t (princ)))(c:bomlist))          ;���͹ϭ����ƲM��
(defun c:&mana_database()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:mana_database)(load "manapart"))(t (princ)))(c:mana_database))          ;�޲z���Ƹ�Ʈw
(defun c:&df_bomdbase()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:df_bomdbase)(load "dfsystem"))(t (princ)))(c:df_bomdbase))          ;���Ƹ�Ʈw���w�q
(defun c:&fieldset()(c:autoload)(cond ((null powdesign_path)(load "designer")(loaddesIgner))(t (princ))) (cond ((null c:fieldset)(load "dfsystem"))(t (princ)))(c:fieldset))          ;���ɺ޲z��Ʈw���]�w��

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
;;���������
(defun c:&isomenu1()(c:autoload)(c:isomenu1))  ;�����Ϣ�
(defun c:&isomenu2()(c:autoload)(c:isomenu2))  ;�����Ϣ�
(defun c:&isoblk1()(c:autoload)(c:isoblk1))    ;�z���ϹϮw�޲z
(defun c:&isoblk2()(c:autoload)(c:isoblk2))    ;�ϥ��z���ϹϮw

;;=============================================================================================
;;���񤸥� [�P]
(defun c:&openpin()(c:autoload)(c:openpin))  ;�}�f�P
(defun c:&sprpin()(c:autoload)(c:sprpin))    ;�u®�P
(defun c:&parpinA()(c:autoload)(c:parpinA))  ;A ������P
(defun c:&parpinB()(c:autoload)(c:parpinB))  ;B ������P
(defun c:&tappin()(c:autoload)(c:tappin))    ;���޾P

;;���񤸥� [��]
(defun c:&parkey7()(c:autoload)(c:parkey7))  ;A �إb����
(defun c:&parkey8()(c:autoload)(c:parkey8))  ;B �إb����
(defun c:&parkey6()(c:autoload)(c:parkey6))  ;�a�Y����
(defun c:&parkey5()(c:autoload)(c:parkey5))  ;������(����)
(defun c:&parkey1()(c:autoload)(c:parkey1))  ;��������Y���
(defun c:&parkey2()(c:autoload)(c:parkey2))  ;���������Y���
(defun c:&parkey3()(c:autoload)(c:parkey3))  ;��������Y�y��
(defun c:&parkey4()(c:autoload)(c:parkey4))  ;���������Y�y��

;;���񤸥� [�o ��]
(defun c:&soilseal()(c:autoload) (c:soilseal))   ;S �� �a�u®�󽦥~�P
(defun c:&smoilseal()(c:autoload)(c:smoilseal))  ;SM�� �a�u®���ݥ~�P
(defun c:&saoilseal()(c:autoload)(c:saoilseal))  ;SA�� �a�u®���զ�
(defun c:&doilseal()(c:autoload) (c:doilseal))   ;D �� �a�u®�󽦥~�P������
(defun c:&dmoilseal()(c:autoload)(c:dmoilseal))  ;DM�� �a�u®���ݥ~�P������
(defun c:&daoilseal()(c:autoload)(c:daoilseal))  ;DA�� �a�u®���զ�������
(defun c:&goilseal()(c:autoload) (c:goilseal))   ;G �� ���a�u®�󽦥~�P
(defun c:&gmoilseal()(c:autoload)(c:gmoilseal))  ;GM�� ���a�u®���ݥ~�P
(defun c:&gaoilseal()(c:autoload)(c:gaoilseal))  ;GA�� ���a�u®���զ�

;;���񤸥� [�s�y�b�Ӳ�]
(defun c:&UcF()(c:autoload)(c:UcF))    ;UCF��W�էΨ��Y�t��
(defun c:&Ucpp()(c:autoload)(c:Ucpp))  ;UCP��W�էγs�y��
(defun c:&Uct()(c:autoload)(c:Uct))    ;UCT�굩�էΦ��Y��
(defun c:&Ukf()(c:autoload)(c:UkF))    ;UKF�׫פէΨ��Y�t��
(defun c:&Ukp()(c:autoload)(c:Ukp))    ;UKP�׫פէγs�y��
(defun c:&Ukt()(c:autoload)(c:Ukt))    ;UKT�׫פէΦ���
(defun c:&UcFl()(c:autoload)(c:UcFl))  ;UCFL��W�էε٧ΥY�t��
(defun c:&UkFl()(c:autoload)(c:UkFl))  ;UKFL�׫פէε٧ΥY�t��
(defun c:&UcFc()(c:autoload)(c:UcFc))  ;UCFC��W�էήM�޶�Y�t��
(defun c:&UkFc()(c:autoload)(c:UkFc))  ;UKFC ���ާΪ����ӱ��X��Y�t��

;;���񤸥�[�إq(�԰�)]
(defun c:&cirwash1()(c:autoload)(c:cirwash1))    ;��Υ��԰�(�p��)
(defun c:&recwash1()(c:autoload)(c:recwash1))    ;��Υ��԰�(�p��)
(defun c:&recwash2()(c:autoload)(c:recwash2))    ;��Υ��԰�(�j��)
(defun c:&spwasher()(c:autoload)(c:spwasher))    ;�u®�԰�
;(defun c:&bearwash1()(c:autoload)(c:bearwash1))  ;���ޫ����u�ʶb�����U�ι԰�
;(defun c:&bearwash2()(c:autoload)(c:bearwash2))  ;�s�ޫ����u�ʶb�����U�ι԰�

(defun c:&bearwash1()(c:autoload)(c:shnutwasher))  ;���ޫ����u�ʶb�����U�ι԰�
(defun c:&bearwash2()(c:autoload)(c:shnutwasher2))  ;�s�ޫ����u�ʶb�����U�ι԰�

;;���񤸥�[�����t�C]
(defun c:&l_steel()(c:autoload)(c:l_steel))    ;L �ε��䨤��
(defun c:&c_steel()(c:autoload)(c:c_steel))    ;��(C)����
(defun c:&i_steel()(c:autoload)(c:i_steel))    ;I �ο�
(defun c:&h_steel()(c:autoload)(c:h_steel))    ;H �ο�
(defun c:&l_steel2()(c:autoload)(c:l_steel2))  ;����׿����䨤��
(defun c:&l_steel3()(c:autoload)(c:l_steel3))  ;�����䨤��
(defun c:&l_steel4()(c:autoload)(c:l_steel4))  ;�����䤣���p
(defun c:&t_steel()(c:autoload)(c:t_steel))    ;T �ο�

;;���񤸥�[���q����]
(defun c:&SCsteel1()(c:autoload)(c:SCsteel1))    ;���ѧο�
(defun c:&SNsteel()(c:autoload)(c:SNsteel))      ;�U�ο�
(defun c:&SCsteel2()(c:autoload)(c:SCsteel2))    ;�B�ѧο�
(defun c:&SLsteel()(c:autoload)(c:SLsteel))      ;������
(defun c:&SZsteel1()(c:autoload)(c:SZsteel1))    ;�� Z �ο�
(defun c:&SZsteel2()(c:autoload)(c:SZsteel2))    ;�B Z �ο�

;;���񤸥�[����P���U]
(defun c:&Jbase()(c:autoload)(c:Jbase))                ;J����¦����
(defun c:&lbase()(c:autoload)(c:lbase))                ;L����¦����
(defun c:&lAbase()(c:autoload)(c:lAbase))              ;LA����¦����
(defun c:&JAbase()(c:autoload)(c:JAbase))              ;JA����¦����
(defun c:&sockhead()(c:autoload)(c:sockhead))          ;����������
(defun c:&outsixp()(c:autoload)(c:outsixp))            ;���κݤ����Y����
(defun c:&6screwendcp()(c:autoload)(c:6screwendcp))    ;��κݤ����Y����
(defun c:&6sgefp()(c:autoload)(c:6sgefp))              ;���κݤ����Y����. �t�԰�
(defun c:&6sgecp()(c:autoload)(c:6sgecp))              ;��κݤ����Y����. �t�԰�
(defun c:&sqscwp()(c:autoload)(c:sqscwp))              ;���κݤ��Y����
(defun c:&sqsecp()(c:autoload)(c:sqsecp))              ;��κݤ��Y����
(defun c:&1sisefp()(c:autoload)(c:1sisefp))            ;���κݤ@�r�ѮI�Y����
(defun c:&1sisecp()(c:autoload)(c:1sisecp))            ;��κݤ@�r�ѮI�Y����
(defun c:&1siskefp()(c:autoload)(c:1siskefp))          ;���� . ���κݤ@�r�ѮI�Y����
(defun c:&1siskecp()(c:autoload)(c:1siskecp))          ;���� . ��κݤ@�r�ѮI�Y����
(defun c:&6f_nceap()(c:autoload)(c:6f_nceap))          ;��Ω��Ӻ� . ���W�Y�ݤ����Ӻ۩T�w����
(defun c:&6f_ncetp()(c:autoload)(c:6f_ncetp))          ;��Ω��Ӻ� . �@�κ�  �����Ӻ۩T�w����
(defun c:&6f_nceup()(c:autoload)(c:6f_nceup))          ;��Ω��Ӻ� . �M�κ�  �����Ӻ۩T�w����
(defun c:&6f_ntefp()(c:autoload)(c:6f_ntefp))          ;���@���Ӻ� . ���κ�  �����Ӻ۩T�w����
(defun c:&6f_nteap()(c:autoload)(c:6f_nteap))          ;���@���Ӻ� . ���W�Y�ݤ����Ӻ۩T�w����
(defun c:&6f_ntetp()(c:autoload)(c:6f_ntetp))          ;���@���Ӻ� . �@�κ�  �����Ӻ۩T�w����
(defun c:&6f_nteup()(c:autoload)(c:6f_nteup))          ;���@���Ӻ� . �M�κ�  �����Ӻ۩T�w����
(defun c:&6f_ndeap()(c:autoload)(c:6f_ndeap))          ;���p���Ӻ� . ���W�Y�ݤ����Ӻ۩T�w����
(defun c:&6f_ndetp()(c:autoload)(c:6f_ndetp))          ;���p���Ӻ� . �@�κ�  �����Ӻ۩T�w����
(defun c:&6f_ndeup()(c:autoload)(c:6f_ndeup))          ;���p���Ӻ� . �M�κ�  �����Ӻ۩T�w����
(defun c:&wing_1erp()(c:autoload)(c:wing_1erp))        ;1 �� . ���W���l������
(defun c:&wing_1efp()(c:autoload)(c:wing_1efp))        ;1 �� . ���κ��l������
(defun c:&wing_1ecp()(c:autoload)(c:wing_1ecp))        ;1 �� . ��κ��l������
(defun c:&wing_2erp()(c:autoload)(c:wing_2erp))        ;2 �� . ���W���l������
(defun c:&wing_2efp()(c:autoload)(c:wing_2efp))        ;2 �� . ���κ��l������
(defun c:&wing_2ecp()(c:autoload)(c:wing_2ecp))        ;2 �� . ��κ��l������
(defun c:&wing_3erp()(c:autoload)(c:wing_3erp))        ;3 �� . ���W���l������
(defun c:&wing_3efp()(c:autoload)(c:wing_3efp))        ;3 �� . ���κ��l������
(defun c:&wing_3ecp()(c:autoload)(c:wing_3ecp))        ;3 �� . ��κ��l������
(defun c:&Lnkscrewp()(c:autoload)(c:Lnkscrewp))        ;�Ǳ�����
(defun c:&skescrewp()(c:autoload)(c:skescrewp))        ;�V������
(defun c:&eyeboltp()(c:autoload)(c:eyeboltp))          ;��������
(defun c:&sockless()(c:autoload)(c:sockless))          ;�L�Y�T�w����
(defun c:&fixsock()(c:autoload)(c:fixsock))            ;���ѩT�w����
(defun c:&tscrew()(c:autoload)(c:tscrew))              ;���κݢ������
(defun c:&tscrewcp()(c:autoload)(c:tscrewcp))          ;��κݢ������
(defun c:&six-snut()(c:autoload)(c:six-snut))          ;�������U(�p)
(defun c:&six-bnut()(c:autoload)(c:six-bnut))          ;�������U(�j)
(defun c:&bearth()(c:autoload)(c:bearth))              ;�u�ʶb�ӥ����U

;;���񤸥� [�b����]
(defun c:&bear32x()(c:autoload)(c:bear32x))    ;���@�u�l�b��
(defun c:&bear6x()(c:autoload)(c:bear6x))      ;�`�Ѻu�]�b��
(defun c:&bear12x()(c:autoload)(c:bear12x))    ;�۰ʽդߺu�]�b��
(defun c:&bear230x()(c:autoload)(c:bear230x))  ;�۰ʽդߺu�l�b��

(defun c:&bear51x()(c:autoload)(c:bear51x))  ;��V����u�]�b��
(defun c:&bear52x()(c:autoload)(c:bear52x))  ;���V����u�]�b��
(defun c:&bear29x()(c:autoload)(c:bear29x))  ;�۰ʽդߤ���u�l�b��
(defun c:&bear7x() (c:autoload)(c:bear7x))   ;��Ĳ���u�]�b��
(defun c:&bear5x() (c:autoload)(c:bear5x))   ;���C�u�]�b��
(defun c:&bearn2x()(c:autoload)(c:bearn2x))  ;���C�굩�u�l�b��

(defun c:&bearnxx()(c:autoload)(c:bearnxx))    ;�굩�u�l�b��

;;���񤸥� [����]
(defun c:&shaftc()(c:autoload)(c:shaftc))  ;�b�� C ������
(defun c:&holec()(c:autoload)(c:holec))    ;�ե� C ������
(defun c:&shafte()(c:autoload)(c:shafte))  ;E ������

;;���񤸥� [���]
(defun c:&b_sgear()(c:autoload)(c:b_sgear))  ;B ���쾦��
(defun c:&5-1_gear()(c:autoload)(c:5-1_gear));������
(defun c:&5-2_gear()(c:autoload)(c:5-2_gear));���۾���
(defun c:&5-3_gear()(c:autoload)(c:5-3_gear));����
(defun c:&5-4_gear()(c:autoload)(c:5-4_gear));�ʾ���
(defun c:&5-5_gear()(c:autoload)(c:5-5_gear));����
(defun c:&5-6_gear()(c:autoload)(c:5-6_gear));����
(defun c:&5-7_gear()(c:autoload)(c:5-7_gear));�T���ֱa��
;;=============================================================================================
;;�t�Τ��w²�����O
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
;;;;�t�Τ��w�u��&�ϼh�Ƶ{��
;;�ʳs��u
(defun c:&sl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_CONT_ltype sys_CONT_ltypecol)
; (setvar "cmdecho" 1)
)
;;��u
(defun c:&dl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_dashed_ltype sys_dashed_ltypecol)
; (setvar "cmdecho" 1)
)
;;�u��u
(defun c:&Sdl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_Sdashed_ltype sys_Sdashed_ltypecol)
; (setvar "cmdecho" 1)
)
;;���߽u
(defun c:&cl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_center_ltype sys_center_ltypecol)
; (setvar "cmdecho" 1)
)
;;�u���߽u
(defun c:&scl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_stcenter_ltype sys_stcenter_ltypecol)
; (setvar "cmdecho" 1)
)
;;���Q�u
(defun c:&pl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_phantom_ltype  sys_phantom_ltypecol)
; (setvar "cmdecho" 1)
)
;;���Q�u
(defun c:&Spl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_Sphantom_ltype  sys_Sphantom_ltypecol)
; (setvar "cmdecho" 1)
)
;;�ӹ�u
(defun c:&tl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_CONT1_ltype sys_CONT1_ltypecol)
; (setvar "cmdecho" 1)
)
;;�孱�u
(defun c:&hl&()(c:autoload)
  (loaddesigner)
 (setvar "cmdecho" 0)
 (ch_lt_c sys_hatch_ltype sys_hatch_ltypecol)
; (setvar "cmdecho" 1)
)
;;������s��~�μh
(defun c:&0&()(c:autoload)
  (loaddesigner)
  (setvar "cmdecho" 0)
  (command "layer" "s" "0" "" "linetype" "s" sys_CONT_ltype "" "color" sys_CONT_ltypecol)
; (setvar "cmdecho" 1)
  (princ)
)
;;������ؤo�h
(defun c:&d&()(c:autoload)
  (loaddesigner)
  (setvar "cmdecho" 0)
  (clauc sys_dim_layer sys_dim_layercol "CONTINUOUS")
  (ch_lt_c "BYLAYER" "BYLAYER")
;  (setvar "cmdecho" 1)
)
;;�������r�h
(defun c:&t&()(c:autoload)
  (loaddesigner)
  (setvar "cmdecho" 0)
  (clauc sys_text_layer sys_text_layercol "CONTINUOUS")
  (ch_lt_c "BYLAYER" "BYLAYER")
; (setvar "cmdecho" 1)
)
;;������s��~�μh
(defun c:&by&()(c:autoload)
  (loaddesigner)
  (setvar "cmdecho" 0)
  (ch_lt_c "BYLAYER" "BYLAYER")
; (setvar "cmdecho" 1)
)
;;�������v�u�h
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
   ;; 已改：原用 dctcust（AutoCAD LT），改用 get_support_path（DraftSight）
   (setq OUT_LSPPATH (get_support_path))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;���psupport �ؿ��U�S���ӤH�ƪ� osmode.ini, �h�۰ʫإ߸���
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "�Ĥ@�����I�Ҧ�")))
   (setvar "osmode" ($getosval list1))
   (princ "\n�w�]�w���Ĥ@�����I�Ҧ�!")
   (princ)
)
(defun c:O2(/ list1)
   (c:autoload)
   ;; 已改：原用 dctcust（AutoCAD LT），改用 get_support_path（DraftSight）
   (setq OUT_LSPPATH (get_support_path))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;���psupport �ؿ��U�S���ӤH�ƪ� osmode.ini, �h�۰ʫإ߸���
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "�ĤG�����I�Ҧ�")))
   (setvar "osmode" ($getosval list1))
   (princ "\n�w�]�w���ĤG�����I�Ҧ�!")
   (princ)
)
(defun c:O3(/ list1)
   (c:autoload)
   ;; 已改：原用 dctcust（AutoCAD LT），改用 get_support_path（DraftSight）
   (setq OUT_LSPPATH (get_support_path))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;���psupport �ؿ��U�S���ӤH�ƪ� osmode.ini, �h�۰ʫإ߸���
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "�ĤT�����I�Ҧ�")))
   (setvar "osmode" ($getosval list1))
   (princ "\n�w�]�w���ĤT�����I�Ҧ�!")
   (princ)
)
(defun c:O4(/ list1)
   (c:autoload)
   ;; 已改：原用 dctcust（AutoCAD LT），改用 get_support_path（DraftSight）
   (setq OUT_LSPPATH (get_support_path))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;���psupport �ؿ��U�S���ӤH�ƪ� osmode.ini, �h�۰ʫإ߸���
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "�ĥ|�����I�Ҧ�")))
   (setvar "osmode" ($getosval list1))
   (princ "\n�w�]�w���ĥ|�����I�Ҧ�!")
   (princ)
)
(defun c:O5(/ list1)
   (c:autoload)
   ;; 已改：原用 dctcust（AutoCAD LT），改用 get_support_path（DraftSight）
   (setq OUT_LSPPATH (get_support_path))
   (setq osnapfile (strcat OUT_LSPPATH "osmode.ini"))
   ;���psupport �ؿ��U�S���ӤH�ƪ� osmode.ini, �h�۰ʫإ߸���
   (if (null (findfile osnapfile)) (wr_osmode_to_supp))
   (setq list1 (read (getfile_val osnapfile "�Ĥ������I�Ҧ�")))
   (setvar "osmode" ($getosval list1))
   (princ "\n�w�]�w���Ĥ������I�Ҧ�!")
   (princ)
)
(defun c:O6()(c:autoload) (setvar "osmode" 0)
   (princ "\n�w�]�w���Ĥ������I�Ҧ�!")
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

;;;�ϼh (BLOCK) ��
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
