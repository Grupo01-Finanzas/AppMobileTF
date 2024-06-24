import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(locale: 'es-PE', symbol: 'S/');
  return formatter.format(amount);
}