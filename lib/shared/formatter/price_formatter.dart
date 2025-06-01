import 'package:intl/intl.dart';

class PriceFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'tr_TR',
    decimalDigits: 2,
    symbol: '₺',
  );

  static String format(int price) {
    return _formatter.format(price);
  }
}
