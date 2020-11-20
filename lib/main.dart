import 'package:convert_app/Api/ApiMoneyService.dart';
import 'package:convert_app/entity/Currency.dart';
import 'package:convert_app/presentation/CurrencyList.dart';
import 'package:convert_app/presentation/FavoritesDetail.dart';
import 'package:flutter/material.dart';

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
          setState(() {
            // selected = null;
          });
          return true;
        },
      ),
    );
  }
}

class FavoritesPage extends Page {

  final List<Currency> currencies;

  FavoritesPage(this.currencies) : super(key: ValueKey(currencies));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) {
          // Passer les sharedPref ?? Possible ?
          return FavoritesDetail(currencies: currencies);
        }
    );
  }
}
