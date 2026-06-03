;;;
;;�t�Τ����ܼƧ�

; autocad_ver     : "14" or "12"
; deflayer_list   : (("�ϯȼh" "BORDER" "BYBLOCK") ("�ؤo�е��h" "DIM" "2") ("��r���Ѽh"�@"TEXT"�@"4")("���ж�y�h"�@"BALLBOM" "2")("���ƲM��h"�@"MATLIST" "2")("��v�u�h" "PROJ" "143"))
; defltype_list   : (("�ʳs��u" "CONTINUOUS" "7")("�ӳs��u" "CONTINUOUS" "4")("��u" "DASHED" "3")("�зǤ��߽u(����20)" "CENTER" "1")("�u���߽u(����10)" "CENTER1" "1")("���Q�u" "PHANTOM" "5")("�孱�u" "CONTINUOUS" "6")("���Q�u" "PHANTOM" "5")("��v�u" "CONTINUOUS" "143"))
; defbomlist_list : (("��" "15")("�~�W" "20")("����" "10")("�Ƹ�" "10")("�ƶq" "10")("�Ƶ�" "30"))
; defbomqty_id    : "�ƶq��m"    �Ҧp: "5"

; sys_sheet_layer       :     �Ϯؼh
; sys_sheet_layercol    :     �Ϯؼh�C��
; sys_dim_layer         :     �ؤo�h
; sys_dim_layercol      :     �ؤo�h�C��
; sys_text_layer        :     ��r�h
; sys_text_layercol     :     ��r�h�C��
; sys_ball_layer        :     ���ж�y�h
; sys_ball_layercol     :     ���ж�y�h�C��
; sys_proj_layer        :     ���ж�y�h
; sys_proj_layercol     :     ���ж�y�h�C��
; sys_bomlist_layer     :     ���ƲM��h
; sys_bomlist_layercol  :     ���ƲM��h�C��

; sys_CONT_ltype        :    �ʳs��u�u��
; sys_CONT_ltypecol     :    �ʳs��u�C��
; sys_CONT1_ltype       :    �ӳs��u�u��
; sys_CONT1_ltypecol    :    �ӳs��u�C��
; sys_dashed_ltype      :    ��u
; sys_dashed_ltypecol   :    ��u�C��
; sys_center_ltype      :    �зǤ��߽u
; sys_center_ltypecol   :    �зǤ��߽u�C��
; sys_stcenter_ltype    :    �u���߽u
; sys_stcenter_ltypecol :    �u���߽u�C��
; sys_phantom_ltype     :    ���Q�u
; sys_phantom_ltypecol  :    ���Q�u�C��
; sys_hatch_ltype       :    �孱�u
; sys_hatch_ltypeco1    :    �孱�u�C��


; defball_list          :  ���вy�w�q=("1" "7" "0" "0" "3")
; sys_ball_yesno        :  ���вy���L
; sys_ball_dia          :  ���вy���|
; sys_ballpoint_type    :  ���ЧΦ�      ;; sys_balldonut_yesno   :  ���u���I���L
; sys_ballpoint_size    :  ���Фؤo      ;  ; sys_balldonut_dia
; sys_balltxt_hei       :  ���вy�r��

; partindel_layer       :  �s��զX�ɧR�����ϼh
; partindel_BLOCK       :  �s��զX�ɧR�����϶�

;
;;=============================================================================================
(defun getval(initxt)
   (if (or (null POWDESIGN_path)(/= jin "#$%")(/= #### 85))(c:autoload))
   (setq ff (open (strcat powdesign_path "system.ini") "r"))
  ;(setq ff (open (strcat "p:\\designer6\\" "system.ini") "r"))
  (setq data (read-line ff))
  (while data
    (if (/= nil (setq txtid (get_word data "=")))
      (progn
        (setq objdata (strcase (substr data 1 (- txtid 1))))
        (if (= objdata initxt)
           (setq dd data needdata (substr data (1+ txtid)) data nil)
           (setq data (read-line ff))
        );if
      );progn
      (setq data (read-line ff))
    );if
  );while
  (close ff)
  needdata
)

;�Ҧ��{����r��Ʀ�C
(defun get_language_data(/ gg data)
  (setq language_flag "TC")
  (cond
    ((= language_flag "TC")  (setq gg (open (strcat POWDESIGN_DATA_path "language-tc.doc") "r")))
    ((= language_flag "SC")  (setq gg (open (strcat POWDESIGN_DATA_path "language-sc.doc") "r")))
    ((= language_flag "ENG") (setq gg (open (strcat POWDESIGN_DATA_path "language-eng.doc") "r")))
  );cond
  (setq language_total_list '())
  (setq data (read-line gg))
  (setq i 0)
;  (while data
    (setq language_total_list (cons (read data) language_total_list))
;    (setq data (read-line gg))
;    (setq i (+ i 1))
;  );while
  (close gg)
  (setq language_total_list (reverse language_total_list))
;  (princ language_total_list)
)

(defun get_language(txtid)
   (if (null language_total_list) (get_language_data))
   (setq obj_string (assoc txtid language_total_list))
   (if (null obj_string)
     (progn
       (cond
         ((= language_flag "TC")  (actdcl "pub-dcl" "allert"))
         ((= language_flag "SC")  (actdcl "sc_pub-dcl" "allert"))
         ((= language_flag "ENG") (actdcl "eng_pub-dcl" "allert"))
       );cond
;      (set_tile "ms_allert" (strcat "�r��N�X" (rtos txtid 2 0) "���s�b!"))
       (set_tile "ms_allert" (strcat (get_language 10000022) (rtos txtid 2 0) (get_language 10000023)))
       (action_tile "accept" "(done_dialog)")
       (start_dialog)
       (exit)
     )
     (nth 1 (assoc txtid language_total_list))
   )
)

;�榡:      ("��y���L" "��y���|" "���I���L" "���I���|" "�r��")
;���вy�w�q=("1" "10" "0" "0" "6")
(defun get_bomdef()
   (setq defball_list (read (getval "���вy�w�q")))
   (setq sys_ball_yesno      (nth 0 defball_list)
         sys_ball_dia        (nth 1 defball_list)
         sys_ballpoint_type  (nth 2 defball_list)
         sys_ballpoint_size  (nth 3 defball_list)
         sys_balltxt_hei     (nth 4 defball_list))
)

;���ƲM�����w�q=(("��" "10") ("�~�W" "20")("����" "10") ("�Ƹ�" "10") ("�ƶq" "10") ("����" "16") ("�Ƶ�" "20"))
(defun get_bomlistdef()
   (setq defbomlist_list (read (getval "���ƲM�����w�q")))
   (setq defbomqty_id    (read (getval "�ƶq��m")))
)


;;�Ϯ��ݩ�=(("����" "����" "TYPE")("�ϦW" "�ϦW" "DWGNAME")("����" "����" "MATERIAL")("�ϸ�" "" "DWGNO")("�ƶq" "" "QTY"))
;(defun get_sheetatt()            ;�Ϯج����w�q
;   (setq defsheetatt_list (read (getval "�Ϯ��ݩ�")))
;)



;;=============================================================================================

;�ϼh�w�q=(("�ϯȼh" "BORDER" "BYBLOCK") ("�ؤo�е��h" "DIM" "2") ("��r���Ѽh"�@"TEXT"�@"4")("���ж�y�h"�@"BALLBOM" "2")("���ƲM��h"�@"MATLIST" "2")("��v�u�h" "PROJ" "143"))
(defun get_layerdef()
   (setq deflayer_list (read (getval "�ϼh�w�q")))
   (setq sys_sheet_layer     (nth 1 (assoc "�ϯȼh" deflayer_list)))             ;�Ϯؼh
   (setq sys_sheet_layercol  (nth 2 (assoc "�ϯȼh" deflayer_list)))             ;�Ϯؼh�C��

   (setq sys_dim_layer       (nth 1 (assoc "�ؤo�е��h" deflayer_list)))         ;�ؤo�h
   (setq sys_dim_layercol    (nth 2 (assoc "�ؤo�е��h" deflayer_list)))         ;�ؤo�h�C��

   (setq sys_text_layer      (nth 1 (assoc "��r���Ѽh" deflayer_list)))         ;��r�h
   (setq sys_text_layercol   (nth 2 (assoc "��r���Ѽh" deflayer_list)))         ;��r�h�C��

   (setq sys_ball_layer      (nth 1 (assoc "���ж�y�h" deflayer_list)))         ;���ж�y�h
   (setq sys_ball_layercol   (nth 2 (assoc "���ж�y�h" deflayer_list)))         ;���ж�y�h�C��

   (setq sys_proj_layer      (nth 1 (assoc "��v�u�h" deflayer_list)))           ;��v�u�h
   (setq sys_proj_layercol   (nth 2 (assoc "��v�u�h" deflayer_list)))           ;��v�u�h�C��

   (setq sys_bomlist_layer      (nth 1 (assoc "���ƲM��h" deflayer_list)))           ;���ж�y�h
   (setq sys_bomlist_layercol   (nth 2 (assoc "���ƲM��h" deflayer_list)))           ;���ж�y�h�C��

)

(setq system_dwg_libpath (getval "���ɺ޲z�w�]���|"))

;�u���w�q=(("�ʳs��u" "CONTINUOUS" 7)("�ӳs��u" "CONTINUOUS" 4)("��u" "DASHED" 3)("�зǤ��߽u(����20)" "CENTER" 1)("�u���߽u(����10)" "CENTER1" 1)("���Q�u" "PHANTOM" 5)("�孱�u" "CONTINUOUS" 6)("���Q�u" "PHANTOM" 5)("��v�u" "CONTINUOUS" 143 "PROJ"))
(defun get_ltypedef()
   (redefine_ltype)

;���J�u��
   (setq count 0)
   (repeat (length defltype_list)
      (setq beload_ltype (strcase (nth 1 (nth count defltype_list))))
      (if (tblsearch "LTYPE" beload_ltype)
         (command "linetype" "l" beload_ltype (strcat powdesign_path "acad.lin") "y" "")
         (command "linetype" "l" beload_ltype (strcat powdesign_path "acad.lin") "")
      )(setq count (1+ count))
   );repeat
);defun

(defun redefine_ltype()
   (setq defltype_list (read (getval "�u�ʩw�q")))

    (setq ltcolo '())
    (foreach nn defltype_list
      (progn
         (setq ltcolo (cons (cdr nn) ltcolo))
      )
    )

   (setq sys_CONT_ltype     (nth 1 (assoc "�ʳs��u" defltype_list)))         ;�ʳs��u�u��
   (setq sys_CONT_ltypecol  (nth 2 (assoc "�ʳs��u" defltype_list)))         ;�ʳs��u�C��

   (setq sys_CONT1_ltype     (nth 1 (assoc "�ӳs��u" defltype_list)))        ;�ӳs��u�u��
   (setq sys_CONT1_ltypecol  (nth 2 (assoc "�ӳs��u" defltype_list)))        ;�ӳs��u�C��

   (setq sys_dashed_ltype     (nth 1 (assoc "�зǵ�u" defltype_list)))           ;��u
   (setq sys_dashed_ltypecol  (nth 2 (assoc "�зǵ�u" defltype_list)))           ;��u

   (setq sys_Sdashed_ltype     (nth 1 (assoc "�u��u" defltype_list)))           ;�u��u
   (setq sys_Sdashed_ltypecol  (nth 2 (assoc "�u��u" defltype_list)))           ;�u��u

   (setq sys_center_ltype     (nth 1 (assoc "�зǤ��߽u" defltype_list)))     ;�зǤ��߽u
   (setq sys_center_ltypecol  (nth 2 (assoc "�зǤ��߽u" defltype_list)))     ;�зǤ��߽u

   (setq sys_stcenter_ltype     (nth 1 (assoc "�u���߽u" defltype_list)))   ;�u���߽u
   (setq sys_stcenter_ltypecol  (nth 2 (assoc "�u���߽u" defltype_list)))   ;�u���߽u

   (setq sys_phantom_ltype     (nth 1 (assoc "�зǰ��Q�u" defltype_list)))        ;���Q�u
   (setq sys_phantom_ltypecol  (nth 2 (assoc "�зǰ��Q�u" defltype_list)))        ;���Q�u

   (setq sys_Sphantom_ltype     (nth 1 (assoc "�u���Q�u" defltype_list)))        ;�u���Q�u
   (setq sys_Sphantom_ltypecol  (nth 2 (assoc "�u���Q�u" defltype_list)))        ;�u���Q�u

   (setq sys_hatch_ltype     (nth 1 (assoc "�孱�u" defltype_list)))          ;�孱�u
   (setq sys_hatch_ltypecol  (nth 2 (assoc "�孱�u" defltype_list)))          ;�孱�u

)

(setq partindel_layer (read (getval "�s��զX�ɧR�����ϼh")))
(setq partindel_BLOCK (read (getval "�s��զX�ɧR�����϶�")))

;=============================================================================================

;(defun c:#setting()       ;; AUTOCAD R14 (WIN95,98,     OLD KEYPRO)
;  (setvar "cmdecho" 0)
;  (setvar "limcheck" 0)

; ;(if (or (= &&&&&&% "3669-1704")(= &&&&&& "3669-1704")(= &&&&&& "0DFC-0540"))
;; (if (and piec_ff1 piec_ff2 piec_ff3 piec_ff4)

;  (command "designer")
;  (SETQ aaa (FINDFILE "c:\\designer\\cacd.dwk"))
;  (if aaa
;    (progn
;      (setvar "cmdecho" 0)
;      (setq PASSWORD "USEJIN" %$$$% (ascii "USEJIN"))
;      (load aaa)
;      (command "del" aaa)
;      (setq #### (+ sspp 85))

; ;  (progn
;      (setq jin "#$%")
;      (setq help "systar")
;;     (setq #### 85)
;      (setq sspp 0)
;      (prompt "\n              ���t�Υ�������T�u�{�������q   ���a�F �o�i����.")
;      (prompt "\n                   TEL:(04)230-7650   FAX:(04)231-4708")
;    )
;    (progn
;      (princ "\n���~�T�� !! POWER DESIGN ����]�p�a�w�ˤ����T !!!")
;      (PRINC "\n���ˬd�w�˵{��. �Y�ݭn�A��,�йq: (04)230-7650 ������T �ȪA��")
;    )
;  )
;  (setvar "cmdecho" 1)
;  (princ)
;)

(defun c:#setting()    ;; DraftSight 2025 移植版本（加密狗已移除）
  ;; (load "loadsys")     ;; 已移除：加密狗判斷
  ;; (CHECK_WHICH_APP)    ;; 已移除：加密狗判斷
  (princ)
)  

;���o�t�ιw�]��
;�~��������������������������������������������������������������������������������������������
;���]�p���: 1997.12. 9                                                                      ��
;����s���:                                                                                 ��
;���] �p ��: ���a�F                                                                          ��
;���\�໡��: ���o�t�ιw�]��                                                                  ��
;��                                                                                          ��
;������覡:                                                                                 ��
;�������ɮ�: system.ini, pub-lisp.lsp (get_word)                                             ��
;����������������������������������������������������������������������������������������������
(defun right()
      (prompt "\n              ���t�Υ�������T�u�{�������q   ���a�F �o�i����.")
      (prompt "\n                   TEL:(04)230-7650   FAX:(04)231-4708")
)

(apply '(lambda()
;(defun c:aaaa()
   (setvar "cmdecho" 0)
;  (vmon)
;  (getsys_date 0)
;  (if (and (or (= cyear "1998") (= cyear "1999")) (or (<= (atoi cmonth) 2)(= (atoi cmonth) 12)))
;    (progn

   (setq autocad_ver (substr (getvar "acadver") 1 2))
   (get_layerdef)             ;�ϼh�w�q
   (get_ltypedef)             ;�u���w�q
   (get_bomdef)               ;���ж�y�P���ƲM��w�q
   (get_bomlistdef)           ;���ƲM�����w�q
;; (get_sheetatt)             ;�Ϯج����w�q

  (princ "\n������T POWER�t�C����]�p�t�θ��J ! �еy��...")
  (princ "\n�t�εo�i: ������T�u�{�������q    TEL:04-2307650   FAX:04-2314708")

;;�U�_�ܰ��F�ѥ��������q
;;(princ "\n���t�ΦX�k�ϥΩ� �U�_�ܰ��F�ѥ��������q")
;;(setq piec_ff1 (findfile "L:\\design50\\system.lsp"))
;;(setq piec_ff2 (findfile "L:\\design50\\USERMENU.lsp"))
;;(setq piec_ff3 (findfile "L:\\Powparts\\function.lsp"))
;;(setq piec_ff4 (findfile "L:\\poweriso\\isochg.lsp"))

 ; (command "shell" (strcat "dir/w > " POWDESIGN_path "hd.txt"))
 ; (setq load_check (open (strcat POWDESIGN_path "hd.txt") "r")
 ;       &&&&&&% (read-line load_check)
 ;       &&&&&&% (read-line load_check)
;;       &&&&&&  (substr &&&&&&% 13 9))        ;WINDOWS NT CHINESE,DOS
 ;       &&&&&&  (substr &&&&&&% 13 9)         ;WINDOWS NT CHINESE,DOS
 ;       &&&&&&% (read-line load_check)
 ;       &&&&&&% (substr &&&&&&% 26 9))        ;WINDOWS 98 CHINESE,DOS
 ;

  (C:#SETTING)

;    );progn
;    (princ "\n�ܩ�p! POWER DESIGN ����]�p�a�եδ��w�L, �йq�� 04-2307650 ������T")
;  );IF


   (setvar "cmdecho" 1)
   (princ)
   )'()
)
