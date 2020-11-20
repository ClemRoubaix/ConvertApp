import 'package:convert_app/entity/Currency.dart';
import 'package:convert_app/entity/CustomPopUpMenu.dart';
import 'package:flutter/material.dart';

class CurrencyList extends StatefulWidget {
  final List<Currency> currencies;

  CurrencyList({@required this.currencies}) : super(key: Key('list'));

  @override
  State<StatefulWidget> createState() =>
      CurrencyListState(currencies: currencies);
}

List choices = [CustomPopupMenu(title: 'Favoris', icon: Icons.favorite)];

class CurrencyListState extends State<CurrencyList> {
  CustomPopupMenu _selectedChoices = choices[0];

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
  }

  List<Currency> currencies;

  CurrencyListState({@required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des favoris"),
        actions: [
          PopupMenuButton<CustomPopupMenu>(
            elevation: 3.2,
            initialValue: choices[0],
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                // return PopupMenuItem(
                //   value: choice,
                //   child: Text(choice.title),
                // );
              }).toList();
            },
          ),
        ],
      ),
      body: bodyWidget(),
    );
  }

  bodyWidget() {
    return ListView(
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
        Container(
          child: SelectedOption(choice: _selectedChoices),
        ),
      ],
    );
  }

  // add
  void _swapFavorite(Currency currency) {
    setState(() {
      currency.favorite = !currency.favorite;
    });
  }
}

class SelectedOption extends StatelessWidget {
  CustomPopupMenu choice;

  SelectedOption({Key key, this.choice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(choice.icon, size: 140.0, color: Colors.white),
            Text(
              choice.title,
              style: TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
