 SELECT BillingNumber, BillingDate, BillingTotal,
     BillingTotal - PaymentTotal - CreditTotal AS BalanceDue
 FROM Billings
 WHERE BillingTotal - PaymentTotal - CreditTotal > 0