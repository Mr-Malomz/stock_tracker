import 'package:flutter/material.dart';
import 'package:stock_tracker/stock_service.dart';
import 'package:stock_tracker/utils.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<Stock>? stocks;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    _getFavStockList();
    super.initState();
  }

  _getFavStockList() {
    setState(() {
      _isLoading = true;
    });
    StockService().getFavStocks().then((value) {
      setState(() {
        stocks = value;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : _isError
            ? const Center(
                child: Text(
                  'Error loading stocks',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : stocks!.isEmpty
                ? const Center(
                    child: Text(
                      'No stock added to favourites yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: stocks?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stocks![index].symbol,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(stocks![index].name)
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$ ' + stocks![index].open,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(height: 10.0),
                                Text(stocks![index].exchange)
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
  }
}
