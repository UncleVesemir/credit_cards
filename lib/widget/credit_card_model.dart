import 'package:flutter/cupertino.dart';

class CreditCardModel {
  final String cardHolderName;
  final int cardNumber;
  final String expDate;
  final LinearGradient? gradient;
  final Color? color;
  final double width;
  final double height;

  CreditCardModel({
    required this.cardHolderName,
    required this.cardNumber,
    required this.expDate,
    required this.width,
    required this.height,
    this.gradient,
    this.color,
  });
}
