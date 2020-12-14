import 'package:convert_app/entity/Currency.dart';
import 'package:flutter/material.dart';

class FavoritesDetail extends StatelessWidget {
  List<Currency> currencies;

  FavoritesDetail({@required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.lightBlueAccent,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text("Add in your favorite to convers", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            for (var currency in currencies)
              if (currency.favorite)
                Row(children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(currency.code, style: TextStyle(fontSize: 20)),
                        Text(currency.name),
                      ],
                    ),
                  )
                ])
          ],
        ));
  }
}
