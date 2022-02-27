import 'package:credit_cards/widget/credit_card_model.dart';
import 'package:flutter/material.dart';

class CreditCardItem extends StatefulWidget {
  final CreditCardModel cardInfo;
  const CreditCardItem({
    required this.cardInfo,
    required Key key,
  }) : super(key: key);

  @override
  State<CreditCardItem> createState() => _CreditCardItemState();
}

class _CreditCardItemState extends State<CreditCardItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.cardInfo.height,
      width: widget.cardInfo.width,
      decoration: BoxDecoration(
        color: widget.cardInfo.color,
        gradient: widget.cardInfo.gradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, bottom: 18, right: 24),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      widget.cardInfo.expDate,
                      style: TextStyle(color: Colors.black.withOpacity(0.5)),
                    ),
                    Text(
                      widget.cardInfo.cardHolderName,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    )
                  ],
                )),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  SizedBox(
                    height: 40,
                    width: 80,
                    child: Image.asset(
                      'assets/images/mastercard.png',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
