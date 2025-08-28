;; Define the SIP-010 trait inline
(define-trait sip-010-token
  (
    (transfer (uint principal principal (optional (buff 34))) (response bool uint))
    (get-name () (response (string-ascii 32) uint))
    (get-symbol () (response (string-ascii 32) uint))
    (get-decimals () (response uint uint))
    (get-balance (principal) (response uint uint))
    (get-total-supply () (response uint uint))
    (get-token-uri () (response (optional (string-utf8 256)) uint))
  )
)

(define-constant ERR_PAIR_NOT_EXISTS (err u1002))
(define-constant ERR_SLIPPAGE_TOO_HIGH (err u1005))
(define-constant ERR_ZERO_AMOUNT (err u1006))
(define-constant ERR_IDENTICAL_TOKENS (err u1007))

(define-constant FEE_NUMERATOR u997)
(define-constant FEE_DENOMINATOR u1000)

(define-map pairs
  { token-a: principal, token-b: principal }
  { reserve-a: uint, reserve-b: uint }
)

(define-private (get-sorted-pair (token-a principal) (token-b principal))
  ;; Use a simple comparison - if they're the same, keep order, otherwise use hash comparison
  (if (is-eq token-a token-b)
    { token-a: token-a, token-b: token-b }
    (let (
      (hash-a (sha256 (unwrap-panic (to-consensus-buff? token-a))))
      (hash-b (sha256 (unwrap-panic (to-consensus-buff? token-b))))
      ;; Get first 8 bytes for comparison
      (first-8-a (unwrap! (as-max-len? hash-a u8) { token-a: token-a, token-b: token-b }))
      (first-8-b (unwrap! (as-max-len? hash-b u8) { token-a: token-b, token-b: token-a }))
    )
      (if (<= (buff-to-uint-be first-8-a) (buff-to-uint-be first-8-b))
        { token-a: token-a, token-b: token-b }
        { token-a: token-b, token-b: token-a }
      )
    )
  )
)

(define-read-only (get-amount-out (amount-in uint) (reserve-in uint) (reserve-out uint))
  (let (
    (amount-in-with-fee (* amount-in FEE_NUMERATOR))
    (numerator (* amount-in-with-fee reserve-out))
    (denominator (+ (* reserve-in FEE_DENOMINATOR) amount-in-with-fee))
  )
    (/ numerator denominator)
  )
)

(define-public (create-pair (token-a-trait <sip-010-token>) (token-b-trait <sip-010-token>) (amount-a uint) (amount-b uint))
  (let (
    (token-a (contract-of token-a-trait))
    (token-b (contract-of token-b-trait))
    (sorted-pair (get-sorted-pair token-a token-b))
  )
    (asserts! (not (is-eq token-a token-b)) ERR_IDENTICAL_TOKENS)
    (asserts! (and (> amount-a u0) (> amount-b u0)) ERR_ZERO_AMOUNT)
    
    (try! (contract-call? token-a-trait transfer amount-a tx-sender (as-contract tx-sender) none))
    (try! (contract-call? token-b-trait transfer amount-b tx-sender (as-contract tx-sender) none))
    
    (map-set pairs sorted-pair {
      reserve-a: (if (is-eq (get token-a sorted-pair) token-a) amount-a amount-b),
      reserve-b: (if (is-eq (get token-a sorted-pair) token-a) amount-b amount-a)
    })
    (ok true)
  )
)

(define-public (swap-exact-tokens-for-tokens (amount-in uint) (amount-out-min uint) (token-in-trait <sip-010-token>) (token-out-trait <sip-010-token>))
  (let (
    (token-in (contract-of token-in-trait))
    (token-out (contract-of token-out-trait))
    (sorted-pair (get-sorted-pair token-in token-out))
    (pair-data (unwrap! (map-get? pairs sorted-pair) ERR_PAIR_NOT_EXISTS))
    (is-token-in-a (is-eq (get token-a sorted-pair) token-in))
    (reserve-in (if is-token-in-a (get reserve-a pair-data) (get reserve-b pair-data)))
    (reserve-out (if is-token-in-a (get reserve-b pair-data) (get reserve-a pair-data)))
    (amount-out (get-amount-out amount-in reserve-in reserve-out))
  )
    (asserts! (> amount-in u0) ERR_ZERO_AMOUNT)
    (asserts! (not (is-eq token-in token-out)) ERR_IDENTICAL_TOKENS)
    (asserts! (>= amount-out amount-out-min) ERR_SLIPPAGE_TOO_HIGH)
    
    ;; Transfer tokens in from user to contract
    (try! (contract-call? token-in-trait transfer amount-in tx-sender (as-contract tx-sender) none))
    
    ;; Update pool reserves
    (map-set pairs sorted-pair {
      reserve-a: (if is-token-in-a (+ (get reserve-a pair-data) amount-in) (- (get reserve-a pair-data) amount-out)),
      reserve-b: (if is-token-in-a (- (get reserve-b pair-data) amount-out) (+ (get reserve-b pair-data) amount-in))
    })
    
    ;; Transfer tokens out from contract to user
    (as-contract (try! (contract-call? token-out-trait transfer amount-out tx-sender contract-caller none)))
    (ok amount-out)
  )
)

(define-read-only (get-swap-quote (amount-in uint) (token-in principal) (token-out principal))
  (let (
    (sorted-pair (get-sorted-pair token-in token-out))
    (pair-data (unwrap! (map-get? pairs sorted-pair) ERR_PAIR_NOT_EXISTS))
    (is-token-in-a (is-eq (get token-a sorted-pair) token-in))
    (reserve-in (if is-token-in-a (get reserve-a pair-data) (get reserve-b pair-data)))
    (reserve-out (if is-token-in-a (get reserve-b pair-data) (get reserve-a pair-data)))
  )
    (ok (get-amount-out amount-in reserve-in reserve-out))
  )
)