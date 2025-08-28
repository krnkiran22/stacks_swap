;; Implement SIP-010 interface directly
(define-constant TOKEN_NAME "Test Token A")
(define-constant TOKEN_SYMBOL "TTA")
(define-constant TOKEN_DECIMALS u6)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_INSUFFICIENT_BALANCE (err u403))

(define-data-var token-owner principal tx-sender)
(define-map balances principal uint)

(define-read-only (get-name)
  (ok TOKEN_NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS)
)

(define-read-only (get-balance (account principal))
  (ok (default-to u0 (map-get? balances account)))
)

(define-read-only (get-total-supply)
  (ok u1000000000000)
)

(define-read-only (get-token-uri)
  (ok none)
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (let (
    (sender-balance (unwrap-panic (get-balance sender)))
  )
    (asserts! (is-eq tx-sender sender) ERR_UNAUTHORIZED)
    (asserts! (>= sender-balance amount) ERR_INSUFFICIENT_BALANCE)
    (map-set balances sender (- sender-balance amount))
    (map-set balances recipient (+ (unwrap-panic (get-balance recipient)) amount))
    (ok true)
  )
)

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (var-get token-owner)) ERR_UNAUTHORIZED)
    (map-set balances recipient (+ (unwrap-panic (get-balance recipient)) amount))
    (ok true)
  )
)