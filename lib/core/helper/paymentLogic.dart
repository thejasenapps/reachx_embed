class PaymentLogic {
  double basicPaymentLogic(int rate) {
    if(rate > 1000) {
      return (rate * 0.1) + rate;
    } else {
      return rate + 100;
    }
  }
}