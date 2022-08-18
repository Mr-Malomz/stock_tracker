class AppConstant {
  //marketstack
  final String accessKey = "c2e0799c655f3533e48431cac7c92e02";

  //appwrite
  final String databaseId = "62fd8cd2b67d0edab8e4";
  final String projectId = "62fd8c8766522d6a0c35";
  final String endpoint = "http://192.168.1.11/v1";
  final String collectionId = "62fd8cfe5923c756372e";
}

class TickerResponse {
  String name;
  String symbol;

  TickerResponse({required this.name, required this.symbol});

  factory TickerResponse.fromJson(Map<dynamic, dynamic> json) {
    return TickerResponse(
      name: json['name'],
      symbol: json['symbol'],
    );
  }
}

class PriceResponse {
  String open;
  String exchange;

  PriceResponse({required this.open, required this.exchange});

  factory PriceResponse.fromJson(Map<dynamic, dynamic> json) {
    return PriceResponse(
      open: json['open'],
      exchange: json['exchange'],
    );
  }
}

class Stock {
  String? $id;
  String name;
  String symbol;
  String open;
  String exchange;

  Stock({
    this.$id,
    required this.name,
    required this.symbol,
    required this.open,
    required this.exchange,
  });

  factory Stock.fromJson(Map<dynamic, dynamic> json) {
    return Stock(
      $id: json['\$id'],
      name: json['name'],
      symbol: json['symbol'],
      open: json['open'],
      exchange: json['exchange'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {'name': name, 'symbol': symbol, 'open': open, 'exchange': exchange};
  }
}
