import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  String generateRandomId() {
    int min = 100000000;
    int max = 999999999;
    String dateNow = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    final _random = new Random();
    var value = min + _random.nextInt(max - min);

    return _generateMd5(dateNow + value.toString());
  }

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  String generateIdWithPrefix(prefix) {
    int min = 100000000;
    int max = 999999999;
    final _random = new Random();
    var value = min + _random.nextInt(max - min);
    var generated = '${prefix + value.toString()}';

    return generated;
  }

  String getFormattedDate(DateTime dateTime, {DateFormat mDateFormat}) {
    var dateFormat =
        (mDateFormat != null) ? mDateFormat : DateFormat('yyyy-MM-dd H:m:s');
    return dateFormat.format(dateTime);
  }

  String getFormattedNumber(var number) {
    var f = NumberFormat.currency(
      locale: 'id_ID',
      name: 'Rp ',
      decimalDigits: 0,
    );
    return f.format(number);
  }

  double getDiscountedPrice(double discount, double price) {
    return ((100 - discount) * price) / 100;
  }

  List<DateTime> getPeriode() {
    List<DateTime> periode = [];

    var now = DateTime.now();
    var awal = DateTime(now.year, now.month, 1);
    var akhir =
        DateTime(now.year, now.month, DateTime(now.year, now.month + 1, 0).day);
    periode.add(awal);
    periode.add(akhir);

    return periode;
  }

  Color convertColorString(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
