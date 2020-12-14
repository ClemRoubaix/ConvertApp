import 'dart:convert';

import 'package:convertApp/Config/config.dart';
import 'package:convertApp/entity/Convert.dart';
import 'package:convertApp/entity/Currency.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiMoneyService {
  // Base API url
  static const String _baseUrl = "currency26.p.rapidapi.com";
  // Base headers for Response url
  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-host": "currency26.p.rapidapi.com",
    "x-rapidapi-key": Config.RAPID_API_KEY,
  };

  // Base API request to get response
  Future<List<Currency>> getAllCurrencies({
    @required String endpoint,
    @required Map<String, String> query,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Uri uri = Uri.https(_baseUrl, endpoint, query);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {

      Map<String, dynamic> mJson = json.decode(utf8.decode(response.bodyBytes));
      List<Currency> currencies = [];
      mJson.forEach((key, value) {
        bool favorite = pref.getBool(key) ?? false;
        currencies.add(Currency(key, value.toString(), favorite));
        // print(key);
      });
      return currencies;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }

  convertCurrency (
      {
        @required String endpoint,
        @required Map<String, String> query,
      }
      ) async {
    Uri uri = Uri.https(_baseUrl, endpoint, query);
    final response = await http.get(uri, headers: _headers);
    Convert mConvert;
    debugPrint("get: " + _baseUrl + endpoint);
    if (response.statusCode == 200) {
      debugPrint("statusCode: " + response.statusCode.toString());
      Map<String, dynamic> mJson = json.decode(utf8.decode(response.bodyBytes));
      mConvert = Convert.fromJson(mJson);
      return mConvert;
    } else {
      throw("No internet connection or something");
    }
  }
}