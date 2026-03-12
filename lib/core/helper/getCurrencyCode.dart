String getCurrencyCodeFromSymbol(String symbol) {
  final Map<String, String> currencyMap = {
    "₹": "INR",
    "\$": "USD",
    "€": "EUR",
    "£": "GBP",
    "¥": "JPY",
    "₩": "KRW",
    "₽": "RUB",
    "₺": "TRY",
    "₫": "VND",
    "₴": "UAH",
    "R\$": "BRL",
    "C\$": "CAD",
    "A\$": "AUD",
    "NZ\$": "NZD",
    "HK\$": "HKD",
    "S\$": "SGD",
    "CHF": "CHF",
    "AED": "AED",
    "SAR": "SAR",
    "ZAR": "ZAR",
    "NOK": "NOK",
    "SEK": "SEK",
    "DKK": "DKK",
  };
  return currencyMap[symbol] ?? "INR";
}