import 'package:convertApp/entity/Currency.dart';
import 'package:flutter/material.dart';

class FavoritesDetail extends StatelessWidget {
  final List<Currency> currencies;

  FavoritesDetail({@required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var currency in currencies)
          currency.favorite ?
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(currency.code, style: TextStyle(fontSize: 20)),
                      Text(currency.name),
                    ],
                  ),
                )
              ]
          ) : Container()
        ],
      )
    );
  }
}
