import 'package:convert_app/entity/Currency.dart';
import 'package:convert_app/presentation/FavoritesDetail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class CurrencyList extends StatefulWidget {
  final List<Currency> currencies;

  CurrencyList({@required this.currencies})
      : super(key: Key(currencies.toString()));

  @override
  State<StatefulWidget> createState() =>
      CurrencyListState(currencies: currencies);
}

enum PopUpMenu { favorite, convert }

class CurrencyListState extends State<CurrencyList> {
  static const FAVORITE = 0;

  List<Currency> currencies;

  CurrencyListState({@required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Liste des monnaies"),
          actions: [
            PopupMenuButton<PopUpMenu>(
              onSelected: (PopUpMenu result) {
                setState(() {
                  switch (result.index) {
                    case FAVORITE:
                      Route route = MaterialPageRoute(
                          builder: (context) => FavoritesDetail(currencies: currencies));
                      Navigator.push(context, route);
                      break;
                    default:
                      print(result.index);
                  }
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<PopUpMenu>>[
                const PopupMenuItem<PopUpMenu>(
                  value: PopUpMenu.favorite,
                  child: Text('Favorite'),
                ),
                const PopupMenuItem<PopUpMenu>(
                  value: PopUpMenu.convert,
                  child: Text('Convert'),
                )
              ],
            ),
          ],
        ),
        body: ListView(
          children: [
            for (var currency in currencies)
              Row(
                children: [
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text(currency.code, style: TextStyle(fontSize: 20)),
                        Text(currency.name),
                        IconButton(
                          icon: Icon(Icons.star),
                          onPressed: () {
                            _swapFavorite(currency);
                          },
                        color: currency.favorite ? Colors.red : Colors.grey,
                      ),
                    ],
                  )),
                ],
              ),
          ],
        ));
  }

  void _swapFavorite(Currency currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        currency.favorite = !currency.favorite;
        if (currency.favorite) {
          prefs.setBool(currency.code, currency.favorite);
          prefs.setString(currency.code + "_name", currency.name);
        } else {
          prefs.remove(currency.code);
        }
    });
  }
}
