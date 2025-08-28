;; Simple STX Swap Contract for Testnet
;; Swap your STX for mock sBTC tokens

(define-constant ERR_INVALID_AMOUNT (err u1002))
(define-constant ERR_INSUFFICIENT_BALANCE (err u1003))

;; Simple 1:1 swap rate (1 STX = 100000000 sats)  
(define-constant SWAP_RATE u100000000)

;; Internal sBTC balance tracking
(define-map sbtc-balances principal uint)

;; Swap STX for sBTC
(define-public (swap-stx-for-sbtc (stx-amount uint))
    (let (
        (sbtc-amount (* stx-amount SWAP_RATE))
    )
        (asserts! (> stx-amount u0) ERR_INVALID_AMOUNT)
        
        ;; Transfer STX from user to contract
        (try! (stx-transfer? stx-amount tx-sender (as-contract tx-sender)))
        
        ;; Give user sBTC balance
        (map-set sbtc-balances tx-sender 
            (+ (get-sbtc-balance tx-sender) sbtc-amount))
        
        (ok sbtc-amount)
    )
)

;; Swap sBTC back to STX
(define-public (swap-sbtc-for-stx (sbtc-amount uint))
    (let (
        (stx-amount (/ sbtc-amount SWAP_RATE))
        (user-sbtc-balance (get-sbtc-balance tx-sender))
    )
        (asserts! (> sbtc-amount u0) ERR_INVALID_AMOUNT)
        (asserts! (>= user-sbtc-balance sbtc-amount) ERR_INSUFFICIENT_BALANCE)
        
        ;; Deduct sBTC from user
        (map-set sbtc-balances tx-sender (- user-sbtc-balance sbtc-amount))
        
        ;; Transfer STX back to user
        (try! (as-contract (stx-transfer? stx-amount tx-sender tx-sender)))
        
        (ok stx-amount)
    )
)

;; Get users sBTC balance
(define-read-only (get-sbtc-balance (user principal))
    (default-to u0 (map-get? sbtc-balances user))
)

;; Get contract STX balance
(define-read-only (get-contract-stx-balance)
    (stx-get-balance (as-contract tx-sender))
)

;; Get swap rate
(define-read-only (get-swap-rate)
    SWAP_RATE
)
