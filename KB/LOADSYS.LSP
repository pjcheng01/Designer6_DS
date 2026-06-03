;;;
;; (creat_keypro_data): 建立產品 keypro 資料副式
;; 2000/2/14
;;(defun creat_keypro_data()
;;  (startapp (strcat KEYPRO_path "findkey"))
;;  (setq sysini (findfile "c:\\powsoft.ini"))
;;  (setq ff (open sysini "r"))
;;  (setq keyprodata (read (read-line ff)))
;;  (close ff)
;;  keyprodata
;;)
(defun creat_keypro_data(/ fff sysini keyprodata)
  (startapp (strcat KEYPRO_path "findkey.exe"))
  (setq sysini nil)
  (while (null sysini)
	 (setq sysini (findfile "c:\\powsoft.ini"))	     
  )
  (setq fff (open sysini "r"))
  (setq keyprodata (read (read-line fff)))
  (close fff)
  keyprodata
)
;;================查特定檔案(榮富)========================================================
;; 查 特定檔案
;(defun CHECK_WHICH_APP()
;    (setvar "cmdecho" 0)
;
;    (if (and (findfile "p:\\藝祥資訊\\designer6\\pub-lisp.lsp") (or (and (findfile "c:\\winnt\\system32\\findkey.exe") (findfile "c:\\winnt\\system32\\manadwg.exe"))(and (findfile "d:\\winnt\\system32\\findkey.exe") (findfile "d:\\winnt\\system32\\manadwg.exe"))))
;        (setq jin "#$%" #### 85  sspp 0)
;        (progn
;           (setq POWERSOFT nil)
;           (princ "\n保護鎖未插上或非合法版本!")
;           (princ "\n若有任何問題,請電洽 04-22307650 藝祥資訊 工程部!!")
;           (PRINC)
;        );progn
;    );if
;
;
;);;

;;================查 HARDDISK 序號========================================================

;; 查 HARDDISK 序號
;(defun CHECK_WHICH_APP()
;       (setvar "cmdecho" 0)
;       (command "dir" "C:\\*.* > C:\\pass.txt")
;       (setq aa (open "C:\\pass.txt" "r"))
;       (setq aadata (read-line aa))
;    ;;*******以下兩行擇一*******
;       (setq sndata (read-line aa));WINNT WIN2000
;    ;   (setq sndata (read-line aa));WIN95 WIN98
;
;    ;;*******以下三行擇一*******
;       (setq sndata (substr sndata 13 9));WINNT
;    ;   (setq sndata (substr sndata 26 9));WIN95 WIN98
;    ;   (setq sndata (substr sndata 15 9));WIN2000
;
;    (if (= sndata "序號")
;        (setq jin "#$%" #### 85  sspp 0)
;        (progn
;           (setq POWERSOFT nil)
;           (princ "\n保護鎖未插上或非合法版本!")
;           (princ "\n若有任何問題,請電洽 04-22307650 藝祥資訊 工程部!!")
;           (PRINC)
;        );progn
;    );if
;
;
;);;查 HARDDISK 序號

;;================查 KEYPRO 序號========================================================
;; (check_whick_app): 系統載入時檢查 keypro 用於何種產品之主式
;; 2000/2/14
(defun CHECK_WHICH_APP()
  (setvar "cmdecho" 0)
  ;;(setq data (creat_keypro_data))
  (setq data '(6 7))
  (if (or (/= "" data)(/= nil data))
    (progn
      (foreach nn data
        (progn
          (cond
            ;; 1: PCADR4
            ((= 1 nn)  (if (findfile "powercad.mns")
                         (progn
                           (setq POWERSOFT 121092147)(load "pub-lisp")(load "quickey")
                           (load "#setline")(c:get_pcad_set)
                         );progn
                       )
            );1
            ;; 2: PCADR4
            ((= 2 nn)  (princ))
            ;; 3: PCADCE
            ((= 3 nn)  (princ))
            ;; 4: POWERCASE
            ((= 4 nn)  (princ))
            ;; 5: DESIGNER 2000
            ((= 5 nn)  (if (findfile "des2000.mns")
                         (progn
                           (setq piec_designer1 "#$%&" piec_designer2 "###@")
                           (2000define_ltype)         ;2000線型定義
                           (2000define_layer)         ;2000圖層定義
                           (get50_ltypedef)           ;機械設計家 5.0 線型定義
                         );progn
                       );if
            );5
            ;; 6: DESIGNER 5
            ((= 6 nn) (if (findfile "system.lsp")
                         (progn
                           (setq jin "#$%" #### 85  sspp 0)
                           ;(SETQ help "systar")
                         );progn
                       );if
             )
            ;; 7: POWER PARTS
            ((= 7 nn)(if (findfile "v1parts.lsp")
                         (progn
                           (setq jin "#$%" #### 85 #help "systar" sspp 0)

                         );progn
                       );if
             (princ))
            ;; 8: POWERISO
            ((= 8 nn)
             (princ)
            )
            ;; 9: FILE MANAGER
            ((= 9 nn)  (princ))
            ;; 10: 鋼筋估算系統
            ((= 10 nn) (princ))
            ;; 11: 道路標線系統
            ((= 11 nn) (princ))
          );cond

        );progn
      );foreach
      (if (null (member 7 data))
          (progn
               (setq POWPARTS_path      nil)
               (setq POWPARTS_sld_path  nil)
               (setq POWPARTS_dcl_path  nil)
               (setq POWPARTS_dwg_path  nil)
               (setq POWPARTS_DATA_path nil)
               (defun c:openpin() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:sprpin() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:parpinA() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:parpinB() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:tappin() (alert "您沒有機械元件模組之使用權 !")(princ))

               (defun c:parkey7() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:parkey8() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:parkey6() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:parkey5() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:parkey1() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:parkey2() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:parkey3() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:parkey4() (alert "您沒有機械元件模組之使用權 !")(princ))

               (defun c:soilseal() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:smoilseal() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:saoilseal() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:doilseal() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:dmoilseal() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:daoilseal() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:goilseal() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:gmoilseal() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:gaoilseal() (alert "您沒有機械元件模組之使用權 !")(princ))

               (defun c:UcF() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:Ucpp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:Uct() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:UkF() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:Ukp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:Ukt() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:UcFl() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:UkFl() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:UcFc() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:UkFc() (alert "您沒有機械元件模組之使用權 !")(princ))

               (defun c:cirwash1() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:recwash1() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:recwash2() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:spwasher() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:bearwash1() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:bearwash2() (alert "您沒有機械元件模組之使用權 !")(princ))

               (defun c:l_steel() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:c_steel() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:i_steel() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:h_steel() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:l_steel2() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:l_steel3() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:l_steel4() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:t_steel() (alert "您沒有機械元件模組之使用權 !")(princ))

               (defun c:SCsteel1() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:SNsteel() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:SCsteel2() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:SLsteel() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:SZsteel1() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:SZsteel2() (alert "您沒有機械元件模組之使用權 !")(princ))

               (defun c:Jbase() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:lbase() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:lAbase() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:JAbase() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:sockhead() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:outsixp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6screwendcp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6sgefp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6sgecp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:sqscwp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:sqsecp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:1sisefp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:1sisecp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:1siskefp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:1siskecp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_nceap() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_ncetp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_nceup() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_ntefp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_nteap() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_ntetp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_nteup() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_ndeap() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_ndetp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:6f_ndeup() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:wing_1erp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:wing_1efp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:wing_1ecp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:wing_2erp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:wing_2efp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:wing_2ecp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:wing_3erp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:wing_3efp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:wing_3ecp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:Lnkscrewp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:skescrewp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:eyeboltp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:sockless() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:fixsock() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:tscrew() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:tscrewcp() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:six-snut() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:six-bnut() (alert "您沒有機械元件模組之使用權 !")(princ))

               (defun c:bear32x() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:bear6x() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:bear12x() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:bear230x() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:bearnxx() (alert "您沒有機械元件模組之使用權 !")(princ))

               (defun c:shaftc() (alert "您沒有機械元件模組之使用權 !")(princ))
               (defun c:shafte() (alert "您沒有機械元件模組之使用權 !")(princ))
          )progn
      );if
      (if (null (member 8 data))
          (progn
                (setq poweriso_path nil)
                (defun C:isomenu1() (alert "您沒有等角立體圖模組之使用權 !")(princ))
                (defun C:isomenu2() (alert "您沒有等角立體圖模組之使用權 !")(princ))
                (defun c:isoblk1() (alert "您沒有等角立體圖模組之使用權 !")(princ))
                (defun c:isoblk2() (alert "您沒有等角立體圖模組之使用權 !")(princ))
          );progn
      );if

      (startapp "delfile")
     (prompt "\n           本系統由 [ 藝祥資訊工程有限公司 ] 發展完成.")
     (prompt "\n                 TEL:(04)2230-7650  FAX:(04)2231-4708")
    );progn
    (progn
      (setq POWERSOFT nil)
      (startapp "delfile")
      (princ "\n保護鎖未插上或非合法版本!")
      (princ "\n若有任何問題,請電洽 04-22307650 藝祥資訊 工程部!!")
      (PRINC)
    );progn
  );if
  (setvar "cmdecho" 1)
  (princ)
)

;;=================================================================================================
;;; POWERCAD R4 檢查 KEYPRO
(defun POWERSOFT_PCADR4()
  (setq data (creat_keypro_data))
  (setq have_pacdr4 nil)
  (if (or (/= "" data)(/= nil data))
    (progn
      (foreach nn data
        (progn
          (if (= 1 nn)(setq have_pcadr4 t))
        );progn
      );foreach
    );progn
    (setq POWERSOFT nil)
 );if
 (startapp "delfile")
 (if (or (null have_pcadr4) (null powersoft))
    (progn
      (setq POWERSOFT nil)
      (princ "\n保護鎖未插上或非合法版本!")         
      (princ "\n若有任何問題,請電洽 04-2307650 藝祥資訊 工程部!!")
      (PRINC)
    );progn  
  );if
  (princ)
)
(defun c:pcadr4_right()
  (prompt "\n    藝祥POWERCAD軟體版權歸屬: 藝祥資訊工程有限公司    系統發展: 陳冠達 ")
  (princ)
)
;;=================================================================================================
;;; DESIGNER2000 檢查 KEYPRO

(defun POWERSOFT_DESIGNER2000()
  (setq data (creat_keypro_data))
  (setq have_DESIGNER2000 nil)
  (if (or (/= "" data)(/= nil data))
    (progn
      (foreach nn data
        (progn
          (if (= 1 nn)(setq have_DESIGNER2000 t))
        );progn
      );foreach
    );progn
    (setq piec_designer1 nil piec_designer2 nil)
 );if
 (startapp "delfile")
 (if (or (null have_designer2000) (null piec_designer1))
    (progn
      (setq piec_designer1 nil piec_designer2 nil)
      (princ "\n保護鎖未插上或非合法版本!")         
      (princ "\n若有任何問題,請電洽 04-2307650 藝祥資訊 工程部!!")
      (PRINC)
    );progn  
  );if
  (princ)
)
