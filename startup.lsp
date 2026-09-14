;; startup.lsp - DraftSight 2025 自動載入
;; DraftSight 啟動時由 start.lsp 自動執行此檔案
;;
;; 2026-09-14：原本底下那三行 (load "command") / (load "quickey") /
;; (c:autoload) 整組又重複了一次。成因是 setup.lsp 的
;; writeto_startup_lsp：檔案已存在、但檔內找不到 ;DS_CONFIG_WRITTEN 標記時，
;; 它會用 append 追加同樣三行再補上標記（setup.lsp:123-132）。
;; 證據是被追加的那幾行行尾是 CRLF（DraftSight 的 write-line 寫的），
;; 而手寫的前幾行是 LF。重複不影響運作（c:autoload 內有守衛），只是
;; 每次啟動多跑一次載入。
;;
;; ⚠ 最後一行的 ;DS_CONFIG_WRITTEN 不可刪——setup.lsp:93 的
;;    check_have_write 靠它判斷「是否已寫入」。刪掉的話，下次跑 setup
;;    就會再追加一次，重複又會長回來。
(load "command")
(load "quickey")
(c:autoload)
(princ)
;DS_CONFIG_WRITTEN
