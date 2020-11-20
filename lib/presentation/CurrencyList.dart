import 'package:convert_app/entity/Currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrencyList extends StatefulWidget {

  final List<Currency> currencies;

  CurrencyList({@required this.currencies});

  @override
  State<StatefulWidget> createState() => CurrencyListState(currencies: currencies);
}

class CurrencyListState extends State<CurrencyList> {

  List<Currency> currencies;

  CurrencyListState({@required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
          children: [
            for (var currency in currencies)
              Row(
                children: [
                  Expanded(child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(currency.code, style: TextStyle(fontSize: 20)),
                      Text(currency.name),
                      IconButton(
                        icon: Icon(Icons.star),
                        onPressed: () {
                          _swapFavorite(currency);
                        },
                        color: currency.favorite? Colors.red : Colors.grey,
                      ),
                    ],
                  )),
                ],
              ),
          ]
      ),
    );
  }

  void _swapFavorite(Currency currency) {
    setState(() {
      currency.favorite = !currency.favorite;
    });
  }
}