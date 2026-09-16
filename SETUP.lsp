;;;;
;; setup.lsp - DraftSight 2025 移植版本
;; 移植說明：
;;   1. get_support_path 的系統變數改成了 SRCHPATH——那是錯的，見下方說明
;;   2. writeto_acaddoc_lsp 改為 writeto_startup_lsp
;;   3. 移除 AutoCAD LT 判斷
;;   4. config.doc 改用英文 key，避免編碼問題

;;----------------------------------------------------------------
;; 取得 Support 路徑（與 config.lsp 同一份實作）
;;----------------------------------------------------------------
;; ⚠ 這裡的 "SRCHPATH" 是移植時選錯的變數，不是刻意的設計。
;;    DraftSight 的 325 個系統變數裡沒有 SRCHPATH（原版 AutoCAD 用的是
;;    acadprefix），實測 (getvar "SRCHPATH") 回 nil——不報錯，所以下面
;;    整個 if 的第一分支走不到，一律掉到 fallback 回 disk_path\。
;;
;;    ★ 不要「順手修正」成 acadprefix：DraftSight 回傳的每一段結尾是
;;      "Support\;"（多一個反斜線），sub_get_support_path 比對的是
;;      "SUPPORT;"，取最後 8 字元得到 "upport\;"，一段都不會 match，
;;      結果仍然是 fallback。兩個變數一樣，改了只是多繞一圈，而且會讓
;;      sub_get_support_path 的 (substr typ (- str_len 7)) 活過來
;;      （路徑段少於 8 字元時起始位置 <= 0，substr 會報錯）。
;;
;;    而且對「從資料夾直接跑 setup.lsp」的安裝流程來說，fallback 到
;;    disk_path 反而是唯一正確的答案——那個時間點搜尋路徑還沒設。
;;    詳見手冊 §2.0。
(defun get_support_path (/ text_data k_num test_txt support_path)
  (setq text_data (getvar "SRCHPATH"))
  (if (and text_data (/= "" text_data))
    (progn
      (setq k_num (get_word text_data ";"))
      (setq test_txt (substr text_data 1 k_num))
      (setq support_path (sub_get_support_path test_txt))
      (setq text_data (substr text_data (1+ k_num)))
      (setq k_num (get_word text_data ";"))
      (while (/= nil k_num)
        (setq test_txt (substr text_data 1 k_num))
        (setq support_path (sub_get_support_path test_txt))
        (setq text_data (substr text_data (1+ k_num)))
        (setq k_num (get_word text_data ";"))
      )
      (setq k_path nil)
      (if support_path
        (setq support_path (strcat support_path "\\"))
        (if disk_path
          (setq support_path (strcat disk_path "\\"))
          (setq support_path "C:\\DESIGNER6_DS\\")
        )
      )
    )
    (if disk_path
      (setq support_path (strcat disk_path "\\"))
      (setq support_path "C:\\DESIGNER6_DS\\")
    )
  )
  support_path
)

(defun sub_get_support_path (typ / kword str_len)
  (setq str_len (strlen typ))
  (setq kword (substr typ (- str_len 7)))
  (if (= "SUPPORT;" (strcase kword)) (setq k_path (substr typ 1 (- str_len 1))))
  k_path
)

;;----------------------------------------------------------------
;; 字串工具
;;----------------------------------------------------------------
(defun getrealstr2 (txt)
  (if (> (strlen txt) 0)
    (while (= " " (substr txt 1 1))
      (setq txt (substr txt 2))
    )
  )
  txt
)

(defun getrealstr4 (txtt / count txt ttid)
  (setq count 1 txt "")
  (repeat (strlen txtt)
    (if (/= " " (setq ttid (substr txtt count 1)))
      (setq txt (strcat txt ttid))
    )
    (setq count (1+ count))
  )
  txt
)

(defun getrealstr3 (txtt / a b)
  (setq a (getrealstr txtt))
  (setq b (getrealstr2 a))
  b
)

(defun canceltxt (txtt / len txt)
  (if (/= "" txtt)
    (progn
      (setq len (strlen txtt))
      (setq txt (substr txtt len 1))
      (if (or (= "/" txt) (= "\\" txt))
        (setq txtt (substr txtt 1 (- len 1)))
      )
    )
  )
  txtt
)

(defun check_have_write (docname / qq data already_write)
  (setq already_write nil)
  (setq qq (open docname "r"))
  (setq data (read-line qq))
  (while data
    (if (= ";DS_CONFIG_WRITTEN" data)
      (setq already_write t data nil)
      (setq data (read-line qq))
    )
  )
  (close qq)
  already_write
)

;;----------------------------------------------------------------
;; 寫入 STARTUP.LSP
;;----------------------------------------------------------------
(defun writeto_startup_lsp (/ startup_path qq)
  (setq startup_path (strcat disk_path "\\STARTUP.LSP"))
  (if (null (findfile startup_path))
    (progn
      (setq qq (open startup_path "w"))
      (write-line ";; STARTUP.LSP - Designer6 DraftSight 2025" qq)
      (write-line "(load \"command\")" qq)
      (write-line "(load \"quickey\")" qq)
      (write-line "(c:autoload)" qq)
      (write-line ";DS_CONFIG_WRITTEN" qq)
      (close qq)
      (princ (strcat "\n已建立 STARTUP.LSP：" startup_path))
    )
    (if (null (check_have_write startup_path))
      (progn
        (setq qq (open startup_path "a"))
        (write-line "(load \"command\")" qq)
        (write-line "(load \"quickey\")" qq)
        (write-line "(c:autoload)" qq)
        (write-line ";DS_CONFIG_WRITTEN" qq)
        (close qq)
        (princ (strcat "\n已更新 STARTUP.LSP：" startup_path))
      )
      (princ "\nSTARTUP.LSP 已包含設定，略過。")
    )
  )
)

;;----------------------------------------------------------------
;; 設定對話框主函式
;;----------------------------------------------------------------
(defun c:setup (/ yesno design50_id powparts_id
                   des50database_path des50item_path
                   parts_path sp_fg setup_fg ffname)
  (setq ffname (findfile (strcat disk_path "\\setup.lsp")))
  (if (null ffname)
    (princ "\n機械設計家系統安裝路徑輸入錯誤!")
    (progn
      (setq ffname (strcat disk_path "\\pub-lisp"))
      (load ffname)
      (actdcl (strcat disk_path "\\setup") "setup")
      (mode_tile "powparts_path" 1)
      (set_tile "design50_path" (strcase disk_path))
      (set_tile "database_path" (strcase (strcat disk_path "\\DATABASE")))
      (set_tile "block_path"    (strcase disk_path))
      (action_tile "design50"  "(set_tile \"design50\" \"1\")")
      (action_tile "powparts"  "(set_powparts)")
      (action_tile "accept"    "(setup_ok)")
      (action_tile "cancel"    "(done_dialog)")
      (start_dialog)
      (unload_dialog dcl_id)
      (if setup_fg
        (progn
          (write_configdoc)
          (sp_want_set)
          (if (null (sp_missing))
            ;; 路徑本來就齊 → 直接顯示完成
            (c:config_ok)
            ;; 缺目錄 → 印出缺什麼，再用 script 串「開選項 → 重新檢查 → 完成」
            (progn
              (princ "\n⚠ 支援檔搜尋路徑還缺下列目錄，沒加的話重開後整套功能不會載入：")
              (sp_manual (sp_missing))
              (princ "\n\n接著會開啟「選項」對話框，請在上面那個位置按「新增」把目錄")
              (princ "\n加進去並按「確定」。關閉之後會重新檢查，通過才算安裝完成。")
              (command "script" (strcat disk_path "\\setuppth"))
            )
          )
        )
        (faile_setup)
      )
    )
  )
  (princ)
)

(defun faile_setup ()
  (actdcl (strcat disk_path "\\setup") "allert1")
  (set_tile "messlable"  "安裝不完整!")
  (set_tile "ms_allert1" "安裝不完整!")
  (set_tile "ms_allert2" "機械設計家系統尚未安裝完成!")
  (action_tile "accept" "(setq sp_fg t)(done_dialog)")
  (action_tile "cancel" "(done_dialog)")
  (start_dialog)
  (unload_dialog dcl_id)
)

;; 原本這裡有 load_softmenu，安裝結束時印一行「選單載入功能待移植至
;; DraftSight，暫時略過」。那個訊息會誤導——DraftSight 的選單與工具列
;; 早就由使用者設定檔裡的 application.xml 參照 Powsoft_Light.xml 自動載入
;; （手冊 §2.1），安裝程式不需要、也不該去載選單。函式與呼叫於
;; 2026-09-15 一併移除。

;;----------------------------------------------------------------
;; 寫入 config.doc（全用英文 key，避免編碼問題）
;;----------------------------------------------------------------
(defun write_configdoc (/ wf out_lsppath ffname)
  (setq out_lsppath (get_support_path))

  ;; 原本這裡會把 powsoft.mns 複製到支援路徑。DraftSight 不吃 AutoCAD 的
  ;; .mns 選單，選單由 Powsoft_Light.xml 提供，所以這段是死碼，2026-09-15 移除。

  ;; 寫入 STARTUP.LSP
  (writeto_startup_lsp)

  ;; 寫入 config.doc
  (setq ffname (strcat out_lsppath "config.doc"))
  (setq wf (open ffname "w"))
  (write-line ";;Designer6 DraftSight config" wf)
  (write-line (strcat "DESIGN_PATH=" (strcase des50_path) "\\") wf)
  (write-line (strcat "DESIGN_SLD_PATH=" (strcase des50_path) "\\SLD\\") wf)
  (write-line (strcat "DESIGN_DCL_PATH=" (strcase des50_path) "\\DCL\\") wf)
  (write-line (strcat "DESIGN_DWG_PATH=" (strcase des50_path) "\\DWG\\") wf)
  (write-line (strcat "DESIGN_DATA_PATH=" (strcase des50database_path) "\\") wf)
  (write-line "" wf)
  (write-line (strcat "USERMENU_PATH=" (strcase des50_path) "\\") wf)
  (write-line "FUNC_COL=5" wf)
  (write-line "" wf)
  (write-line (strcat "WORD_DATA_PATH=" (strcase des50database_path) "\\") wf)
  (write-line "" wf)
  (write-line (strcat "BMANAGER_PATH=" (strcase des50item_path) "\\") wf)
  (write-line (strcat "BMANAGER_ITEM_PATH=" (strcase des50item_path) "\\") wf)
  (write-line "" wf)
  (write-line (strcat "AUTOPLOT_DWGPATH=" (strcase des50_path) "\\") wf)
  (write-line (strcat "AUTOPLOT_FILEPATH=" (strcase des50_path) "\\") wf)
  (write-line "" wf)
  ;; POWER MANAGER（圖檔管理系統）同樣不在本專案內。它的兩個對話框元件
  ;; 早在移植前就被註解掉了，fm_id 永遠是 nil，這裡固定走「未安裝」那一支；
  ;; 2026-09-16 把整條死路一併移除。config.lsp 裡 (if (and fmpath …)) 的守衛靠這
  ;; 兩行維持關閉，否則會去 (load "fm") 而 fm.lsp 並不存在。
  (write-line ";;POWERMANAGER_PATH=" wf)
  (write-line ";;POWERMANAGER_VER=1" wf)
  (write-line "" wf)
  ;; POWERISO 是另一套產品，不在本專案內（工具列已於 5cb62a8 移除，見手冊 §2.1.2），
  ;; 2026-09-16 一併從安裝對話框移除。這一行固定寫成註解，config.lsp:155 的守衛
  ;; 才會維持「未安裝」而不去定義那 4 個 c:iso* 指令。
  (write-line ";;POWERISO_PATH=" wf)
  (write-line "" wf)
  (if (= "1" powparts_id)
    (progn
      (write-line (strcat "POWERPARTS_PATH=" (strcase parts_path) "\\") wf)
      (write-line (strcat "POWERPARTS_SLD_PATH=" (strcase parts_path) "\\sld\\") wf)
      (write-line (strcat "POWERPARTS_DCL_PATH=" (strcase parts_path) "\\dcl\\") wf)
      (write-line (strcat "POWERPARTS_DWG_PATH=" (strcase parts_path) "\\dwg\\") wf)
      (write-line (strcat "POWERPARTS_DATA_PATH=" (strcase parts_path) "\\database\\") wf)
      (write-line "POWPARTS_BLOCK=0" wf)
      (write-line "POWPARTS_BLKNAME=0" wf)
    )
    (progn
      (write-line ";;POWERPARTS_PATH=" wf)
      (write-line ";;POWERPARTS_SLD_PATH=" wf)
      (write-line ";;POWERPARTS_DCL_PATH=" wf)
      (write-line ";;POWERPARTS_DWG_PATH=" wf)
      (write-line ";;POWERPARTS_DATA_PATH=" wf)
      (write-line ";;POWPARTS_BLOCK=0" wf)
      (write-line ";;POWPARTS_BLKNAME=0" wf)
    )
  )
  (close wf)
)

;;----------------------------------------------------------------
;; 支援檔搜尋路徑：檢查 →（缺的話）開「選項」→ 重新檢查 → 完成
;;----------------------------------------------------------------
;; ⚠ 這一步「檢查但不能自動設定」，原因見下。
;;
;; 支援檔搜尋路徑對應的系統變數是 ACADPREFIX（DraftSight 說明檔
;; sv_acadprefix.htm，本地化名稱 GetPthDS）。說明檔寫著 Status: Read / Write，
;; **但實測是唯讀的**——2026-09-16 試 (setvar "ACADPREFIX" …)，DraftSight 回
;; 「ACADPREFIX 為唯讀。」。所以這裡只讀不寫，缺了就印出手動步驟。
;; （不是 SRCHPATH——那個在 DraftSight 根本不存在，見手冊 §2.0。）
;;
;; 其餘管道都查過，沒有一個能寫 DraftSight 的支援路徑：
;;   setcfg  只能寫 appdata.ini 的 [AppData/…] 區段，不是 DraftSight 本身的設定
;;   setenv  文件寫的是「作業系統環境變數」，不會進使用者設定檔
;;   242 個 LISP 函式裡沒有其他寫設定的管道
;; 真正的設定存在 %APPDATA%\DraftSight\<版本>\Profiles\…\profile.xml 的
;; support_paths，那個檔由 DraftSight 擁有、執行中改了會被蓋掉（同 §2.1.1）。
;;
;; 這一步沒做的話，重開 DraftSight 後 start.lsp 用 (findfile "startup.lsp")
;; 找不到我們這支，而它的載入旗標是 0（靜默、失敗也不中斷），所以整套功能
;; 會無聲消失、完全沒有錯誤訊息。**所以寧可囉唆也要印出來。**
;;
;; 原版 AutoCAD 的做法（C:\DESIGNER6\setup.lsp:549-556）是**直接把設定對話框
;; 開給使用者**，不去程式化寫入：
;;
;;   (if (= "15" (substr aver 1 2))
;;       (command "script" (strcat disk_path "\\auto"))   ; AutoCAD 2000：跑 auto.scr
;;       (progn (command "preferences") (c:setup)))       ; R14：開 Preferences
;;
;; 而 auto.scr 的內容就是兩行 "config" 與 "setup"——用 script 把「開對話框、
;; 等使用者關掉、再繼續」串起來。DraftSight 沿用同一個思路，指令名稱換成
;; OPTIONS（選項）。
;;
;; 與原版不同的是位置與條件：原版在 c:setup **之前**無條件開啟；這裡改成
;; 安裝對話框結束後、而且**只在真的缺目錄時**才開。因為 des50_path 與
;; parts_path 要等對話框關掉才知道，這樣才講得出「缺的是哪幾個」。
;;
;; 流程（缺目錄時）：
;;   write_configdoc
;;     → 印出缺哪些目錄
;;     → (command "script" …\setuppth)   SETUPPTH.SCR = 「_OPTIONS」+「(setup_finish)」
;;         → 選項對話框（強制回應，script 會等到關閉）
;;         → (setup_finish) 重新檢查 ACADPREFIX
;;             齊了   → c:config_ok      「系統安裝完成」
;;             還缺   → setup_pathfail   「安裝尚未完成」
;;
;; ⚠ 用 script 而不是直接 (command "_OPTIONS") 的理由跟原版一樣：只有 script
;;    能保證「等對話框關掉再跑下一步」。直接呼叫若不阻塞，重新檢查會在使用者
;;    還沒設定完就執行，一定判成失敗。

;; 去掉結尾反斜線並轉大寫，讓兩個路徑可以比對
(defun sp_norm (p)
  (setq p (strcase p))
  (while (and (> (strlen p) 0) (= "\\" (substr p (strlen p) 1)))
    (setq p (substr p 1 (1- (strlen p))))
  )
  p
)

;; 以分號分隔的 cur 裡，有沒有路徑 p
(defun sp_member (cur p / i c seg hit)
  (setq p (sp_norm p) i 1 seg "" hit nil)
  (if (/= "" p)
    (progn
      (repeat (strlen cur)
        (setq c (substr cur i 1))
        (if (= c ";")
          (progn (if (= (sp_norm seg) p) (setq hit t)) (setq seg ""))
          (setq seg (strcat seg c))
        )
        (setq i (1+ i))
      )
      (if (= (sp_norm seg) p) (setq hit t))
    )
  )
  hit
)

(defun sp_manual (paths)
  (princ "\n       請手動加入：選項 → 檔案位置 → 系統 → 支援檔搜尋路徑")
  (foreach p paths (princ (strcat "\n         " p)))
  (princ)
)

;; 把「這次安裝需要哪些目錄」記成全域，供 setup_finish 使用。
;; ⚠ 不能在 sp_missing 裡直接讀 parts_path——那是 c:setup 的區域變數，
;;    script 跑到 (setup_finish) 時 c:setup 早就返回了，讀到的會是 nil。
(defun sp_want_set ()
  (setq sp_want (list des50_path))
  (if (and parts_path (/= "" parts_path))
    (setq sp_want (append sp_want (list parts_path)))
  )
  sp_want
)

;; 回傳還缺的目錄清單；nil 表示都齊了
(defun sp_missing (/ cur miss)
  (setq cur (getvar "ACADPREFIX"))
  (if (or (null cur) (= "" cur))
    sp_want                                   ; 讀不到就當全部都缺
    (progn
      (setq miss nil)
      (foreach p sp_want
        (if (null (sp_member cur p)) (setq miss (append miss (list p))))
      )
      miss
    )
  )
)

;; 安裝的最後一關，由 SETUPPTH.SCR 在「選項」對話框關閉後呼叫。
;; 路徑真的加進去了才顯示「系統安裝完成」。
(defun setup_finish (/ miss)
  (setq miss (sp_missing))
  (if (null miss)
    (c:config_ok)
    (setup_pathfail miss)
  )
  (princ)
)

(defun setup_pathfail (miss)
  (princ "\n⚠ 支援檔搜尋路徑仍然缺少下列目錄，安裝尚未完成：")
  (sp_manual miss)
  (actdcl (strcat disk_path "\\setup") "allert1")
  (set_tile "messlable"  "安裝尚未完成")
  (set_tile "ms_allert1" "支援檔搜尋路徑未設定,請重新執行 setup.lsp!")
  (action_tile "accept" "(done_dialog)")
  (start_dialog)
  (unload_dialog dcl_id)
  (princ)
)

;;----------------------------------------------------------------
;; 讀取對話框，驗證路徑
;;----------------------------------------------------------------
(defun setup_ok ()
  (setq design50_id       (get_tile "design50"))
  (setq powparts_id       (get_tile "powparts"))
  (setq des50_path        (getrealstr3 (get_tile "design50_path")))
  (setq des50database_path (getrealstr3 (get_tile "database_path")))
  (setq des50item_path    (getrealstr3 (get_tile "block_path")))
  (if (= "1" powparts_id) (setq parts_path (canceltxt (getrealstr3 (get_tile "powparts_path")))))
  (cond
    ((null (findfile (strcat des50_path "\\config.lsp")))
     (set_tile "error" "機械設計家安裝目錄輸入錯誤!"))
    ((null (findfile (strcat des50database_path "\\WORDLIB.DAT")))
     (set_tile "error" "系統資料庫路徑輸入錯誤!"))
    ((null (findfile (strcat des50item_path "\\userblkm.lsp")))
     (set_tile "error" "圖庫系統路徑輸入錯誤!"))
    ((and (= "1" powparts_id) (null (findfile (strcat parts_path "\\V1PARTS.lsp"))))
     (set_tile "error" "POWERPARTS安裝目錄輸入錯誤!"))

    (T (done_dialog) (setq setup_fg t))
  )
  (princ)
)

;;----------------------------------------------------------------
;; 模組勾選事件
;;----------------------------------------------------------------
;; 這裡原本有 set_poweriso，2026-09-16 隨 POWERISO 欄位一併移除。

(defun set_powparts (/ parts_id)
  (setq parts_id (get_tile "powparts"))
  (if (= "1" parts_id)
    (progn (mode_tile "powparts_path" 0) (set_tile "powparts_path" "C:\\POWPARTS_DS"))
    (progn (mode_tile "powparts_path" 1) (set_tile "powparts_path" ""))
  )
)

;; 這裡原本有 set_fm，2026-09-16 隨 POWER MANAGER 一併移除。

;; 這裡原本有 set_pdm（PowerPDM 的 Server／Client／屬性萃取檔路徑，以及
;; 「CAD拆零件時機種命名方式」「存圖時自動PURGE不存在的BLOCK」兩個下拉）。
;; PDM 模組不在本專案內：write_configdoc 從來沒有把這些值寫進 config.doc，
;; 全專案也沒有任何程式讀它們，設完即丟。2026-09-16 連同對話框欄位一併移除。

;;----------------------------------------------------------------
;; 設定完成訊息
;;----------------------------------------------------------------
(defun c:config_ok (/ ffname)
  (setq ffname (strcat disk_path "\\setup"))
  (actdcl ffname "allert1")
  (set_tile "messlable"  "系統安裝完成")
  (set_tile "ms_allert1" "系統安裝完成,請重新啟動,並請您儲存後,重新使用程式!")
  (action_tile "accept" "(done_dialog)")
  (start_dialog)
  (unload_dialog dcl_id)
  (princ)
)

;;----------------------------------------------------------------
;; 設定進入點
;;----------------------------------------------------------------
(defun c:config_path (/ ffname)
  (setvar "cmdecho" 0)
  (setq disk_path nil)
  (if (null disk_path)
    (setq disk_path (getstring "\n機械設計家系統安裝路徑: "))
  )
  (setq ffname (findfile (strcat disk_path "\\setup.lsp")))
  (if (null ffname)
    (princ "\n機械設計家系統安裝路徑輸入錯誤!")
    (c:setup)
  )
  (setvar "cmdecho" 1)
)

(c:config_path)
(princ)
