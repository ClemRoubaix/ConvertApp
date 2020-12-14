import 'package:convertApp/presentation/CurrencyList.dart';
import 'package:flutter/material.dart';

import 'Api/ApiMoneyService.dart';
import 'entity/Currency.dart';

void main() {
  runApp(ConvertApp());
}

class ConvertApp extends StatefulWidget {
  ConvertApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ConvertAppState createState() => ConvertAppState();
}

class ConvertAppState extends State<ConvertApp> {

  List<Currency> currencies;

  @override
  void initState() {
    super.initState();
    ApiMoneyService apiService = ApiMoneyService();
    currencies = [];
    apiService.getAllCurrencies(endpoint: "/list", query: null).then((result) => {
      setState(() {
        currencies = result;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currencies',
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('CurrencyPage'),
            child: CurrencyList(currencies: currencies),
          ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return true;
        },
      ),
    );
  }
}
