import 'package:credit_cards/const.dart';
import 'package:credit_cards/widget/credit_card_item.dart';
import 'package:credit_cards/widget/credit_card_model.dart';
import 'package:credit_cards/widget/credit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CreditCardItem> _cards = [];

  LinearGradient? _selectedColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cards.add(
      CreditCardItem(
        // key: UniqueKey(),
        cardInfo: CreditCardModel(
          index: 0,
          height: 170.0,
          width: 280.0,
          cardHolderName: 'ILYA LEBEDZEU',
          expDate: '21/05',
          cardNumber: 1234567898765432,
          gradient: AppColors.corallGradient,
        ),
      ),
    );
    _cards.add(
      CreditCardItem(
        // key: UniqueKey(),
        cardInfo: CreditCardModel(
          index: 1,
          height: 170.0,
          width: 280.0,
          cardHolderName: 'ILYA LEBEDZEU',
          expDate: '21/05',
          cardNumber: 1234567898765432,
          gradient: AppColors.deepOrangeGradient,
        ),
      ),
    );
    _cards.add(
      CreditCardItem(
        // key: UniqueKey(),
        cardInfo: CreditCardModel(
          index: 2,
          height: 170.0,
          width: 280.0,
          cardHolderName: 'ILYA LEBEDZEU',
          expDate: '21/05',
          cardNumber: 1234567898765432,
          gradient: AppColors.amberGradient,
        ),
      ),
    );
    _cards.add(
      CreditCardItem(
        // key: UniqueKey(),
        cardInfo: CreditCardModel(
          index: 3,
          height: 170.0,
          width: 280.0,
          cardHolderName: 'ILYA LEBEDZEU',
          expDate: '21/05',
          cardNumber: 1234567898765432,
          gradient: AppColors.deepOrangeGradient,
        ),
      ),
    );
  }

  void _updateBackground(LinearGradient? value) {
    setState(() {
      _selectedColor = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: _selectedColor,
        ),
        child: Center(
          child: CreditCards3d(
            children: _cards,
            onSelected: _updateBackground,
          ),
        ),
      ),
    );
  }
}
