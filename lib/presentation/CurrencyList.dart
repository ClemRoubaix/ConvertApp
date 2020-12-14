import 'package:convertApp/entity/Currency.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ConvertCurrency.dart';
import 'FavoritesDetail.dart';

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
  static const CONVERT = 1;

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
                    case CONVERT:
                      Route route = MaterialPageRoute(
                          builder: (context) => ConvertCurrency(currencies: currencies));
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
        body: ListView.builder(
          itemCount: currencies.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currencies[index].code, style: TextStyle(fontSize: 20)),
                      Text(currencies[index].name),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    _swapFavorite(currencies[index]);
                  },
                  color: currencies[index].favorite ? Colors.red : Colors.grey,
                )
              ],
            );
          },
        )
    );
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
          prefs.remove(currency.code + "_name");
        }
    });
  }
}
