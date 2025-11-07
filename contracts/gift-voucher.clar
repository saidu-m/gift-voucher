;; ---------------------------------------------------
;; GIFT-VOUCHER Contract
;; Author: Your Name
;; Description: Allows users to create and send non-transferable
;; appreciation vouchers (credits) to others.
;; ---------------------------------------------------

(define-map vouchers
  { owner: principal }
  { balance: uint })

;; Track how many total vouchers exist (for transparency)
(define-data-var total-issued uint u0)

;; ---------------------------------------------------
;; Read-only helpers
;; ---------------------------------------------------

(define-read-only (get-balance (user principal))
  (match (map-get? vouchers { owner: user })
    data (ok (get balance data))
    (ok u0)))

(define-read-only (get-total-issued)
  (var-get total-issued))

;; ---------------------------------------------------
;; Public Functions
;; ---------------------------------------------------

;; Mint vouchers for yourself (like receiving thank-you credits)
(define-public (mint (amount uint))
  (begin
    (asserts! (> amount u0) (err u100))
    (let (
          (old-balance (unwrap! (get-balance tx-sender) (err u0)))
         )
      (map-set vouchers { owner: tx-sender } { balance: (+ old-balance amount) })
      (var-set total-issued (+ (var-get total-issued) amount))
      (print { event: "minted", to: tx-sender, amount: amount })
      (ok { to: tx-sender, new-balance: (+ old-balance amount) })
    )
  )
)

;; Send vouchers to someone else
(define-public (send-voucher (recipient principal) (amount uint))
  (begin
    (asserts! (> amount u0) (err u101))
    
    (let (
           (sender-bal (unwrap! (get-balance tx-sender) (err u0)))
         )
      (asserts! (>= sender-bal amount) (err u102))
      (let (
             (recipient-bal (unwrap! (get-balance recipient) (err u0)))
           )
        ;; Update sender
        (map-set vouchers { owner: tx-sender } { balance: (- sender-bal amount) })
        ;; Update recipient
        (map-set vouchers { owner: recipient } { balance: (+ recipient-bal amount) })

        (print { event: "voucher-sent", from: tx-sender, to: recipient, amount: amount })
        (ok { from: tx-sender, to: recipient, amount: amount })
      )
    )
  )
)

;; Burn vouchers (remove your own vouchers permanently)
(define-public (burn (amount uint))
  (begin
    (asserts! (> amount u0) (err u103))
    (let (
          (bal (unwrap! (get-balance tx-sender) (err u0)))
         )
      (asserts! (>= bal amount) (err u102))
      (map-set vouchers { owner: tx-sender } { balance: (- bal amount) })
      (var-set total-issued (- (var-get total-issued) amount))
      (print { event: "burned", who: tx-sender, amount: amount })
      (ok { burned-by: tx-sender, amount: amount })
    )
  )
)
