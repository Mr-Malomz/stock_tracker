import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_tracker/utils.dart';
import 'package:appwrite/appwrite.dart';

class StockService {
  final _accessKey = AppConstant().accessKey;
  Client client = Client();
  Databases? db;

  StockService() {
    _init();
  }

  //initialize the application
  _init() async {
    client
        .setEndpoint(AppConstant().endpoint)
        .setProject(AppConstant().projectId);

    db = Databases(client, databaseId: AppConstant().databaseId);

    //get current session
    Account account = Account(client);

    try {
      await account.get();
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        account
            .createAnonymousSession()
            .then((value) => value)
            .catchError((e) => e);
      }
    }
  }

  Future<TickerResponse> _getTicker(String ticker) async {
    String tickerKey = ticker.toUpperCase();

    var response = await http.get(Uri.parse(
        'http://api.marketstack.com/v1/tickers/$tickerKey?access_key=$_accessKey&limit=1'));

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return TickerResponse(name: data['name'], symbol: data['symbol']);
    } else {
      throw Exception('Error getting ticker');
    }
  }

  Future<PriceResponse> _getPrice(String ticker) async {
    String tickerKey = ticker.toUpperCase();

    var response = await http.get(Uri.parse(
        'http://api.marketstack.com/v1/eod?access_key=$_accessKey&symbols=$tickerKey&limit=1'));

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return PriceResponse(
          open: data['data'][0]['open'].toString(),
          exchange: data['data'][0]['exchange']);
    } else {
      throw Exception('Error getting price');
    }
  }

  Future saveStock(String ticker) async {
    try {
      var tickerDetails = await _getTicker(ticker);
      var priceDetails = await _getPrice(ticker);

      Stock newStock = Stock(
        name: tickerDetails.name,
        symbol: tickerDetails.symbol,
        open: priceDetails.open,
        exchange: priceDetails.exchange,
      );
      var data = await db?.createDocument(
        collectionId: AppConstant().collectionId,
        documentId: 'unique()',
        data: newStock.toJson(),
      );
      return data;
    } catch (e) {
      throw Exception('Error creating stock');
    }
  }

  Future<List<Stock>> getFavStocks() async {
    try {
      var data =
          await db?.listDocuments(collectionId: AppConstant().collectionId);
      var stockList =
          data?.documents.map((stock) => Stock.fromJson(stock.data)).toList();
      return stockList!;
    } catch (e) {
      throw Exception('Error getting list of products');
    }
  }
}
