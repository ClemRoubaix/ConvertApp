import 'package:convertApp/Api/ApiMoneyService.dart';
import 'package:convertApp/entity/Currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertCurrency extends StatefulWidget {

  final List<Currency> currencies;

  ConvertCurrency({@required this.currencies});

  @override
  State<StatefulWidget> createState() {
    return ConvertCurrencyState(currencies: currencies);
  }
}

class ConvertCurrencyState extends State<ConvertCurrency> {
  // Variables
  List<Currency> currencies;
  List<Currency> favorites;
  String dropdownValue;

  String fromCurrency;
  String toCurrency;
  String amount;

  String convertResult;

  Future convert;

  TextEditingController controller = TextEditingController();

  List<String> currenciesString = List<String>();
  // Constructor
  ConvertCurrencyState({@required this.currencies});

  @override
  void initState() {
    favorites = getFavoritesCurrencies();
    favorites.forEach((element) {
      currenciesString.add(element.code);
    });
    toCurrency = favorites[0].code;
    fromCurrency = favorites[0].code;
    convertResult = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Convertisseur")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              convertFromWidget(),
              SizedBox(height: 10.0),
              convertToWidget(),
              SizedBox(height: 10.0),
              amountWidget(),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    controller.text.length == 0 ? convertResult = ""
                        : convert = _getCurrencyConvertedFromApi(fromCurrency, toCurrency, controller.text);
                  });
                },
                child: Text("CONVERTIR")
              ),
              convert != null ?
                convertFutureBuilderWidget()
              : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget convertFromWidget() {
    return Column(
      children: [
        Text("Convertir depuis :"),
        DropdownButton<String>(
            value: fromCurrency,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newCurrencyName) {
              setState(() {
                fromCurrency = newCurrencyName;
              });
            },
            items: currenciesString.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()
        )
      ],
    );
  }

  Widget convertToWidget() {
    return Column(
      children: [
        Text("Vers :"),
        DropdownButton<String>(
            value: toCurrency,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newCurrencyName) {
              setState(() {
                toCurrency = newCurrencyName;
              });
            },
            items: currenciesString.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()
        )
      ],
    );
  }

  Widget amountWidget() {
    return Column(
      children: [
        Text("Montant"),
        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          controller: controller,
          onChanged: (String value) {
            value = controller.text;
          },
        )
      ],
    );
  }

  List<Currency> getFavoritesCurrencies() {
    List<Currency> favoritesCurrencies = List<Currency>();
    currencies.forEach((element) {
      element.favorite ? favoritesCurrencies.add(element) : "";
    });
    return favoritesCurrencies;
  }

  Future _getCurrencyConvertedFromApi(String fromCurrencyCode, String toCurrencyCode, String amount) async {
    debugPrint("_getCurrencyConvertedFromApi(): FIRED");
    ApiMoneyService apiService = ApiMoneyService();
    String endpoint = "/convert" + "/" + fromCurrency + "/" + toCurrency + "/" + amount;
    var response = await apiService.convertCurrency(endpoint: endpoint, query: null);
    return response;
  }

  Widget currenciesLoaderWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            width: 60,
            height: 60,
          )
        ]
      )
    );
  }

  convertFutureBuilderWidget() {
    return FutureBuilder(
        future: convert,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            debugPrint("connectionState.done");
            if (snapshot.data == null) {
              debugPrint("no data");
              return Text("Text");
            } else {
              debugPrint("data loaded");
              return Text(snapshot.data.value.toString());
            }
          } else {
            return currenciesLoaderWidget();
          }
        }
    );
  }
}