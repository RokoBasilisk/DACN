import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodorder/Screens/Bill/components/background.dart';
import 'package:foodorder/models/bill_history_model.dart';
import 'package:foodorder/models/product.dart';
import 'package:foodorder/services/preferences_service.dart';
import 'package:foodorder/style.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future getData() async {
    final _preferencesService = PreferencesService();
    Set set = await _preferencesService.getToken();
    Map<String, dynamic> customerId = {"customerId": set.elementAt(1)};
    final response = await http.post(Uri.http('192.168.1.12:5000', 'api/bill'),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${set.elementAt(0)}'
        },
        body: jsonEncode(customerId));
    final jsondata = jsonDecode(response.body);
    List<BillHistory> data = [];
    if (jsondata['success']) {
      for (var x in jsondata['Bills']) {
        List<Product> products = [];
        for (var u in x['products']) {
          Product product = Product(
              u['product']['title'],
              u['product']['description'],
              u['product']['price'],
              u['product']['image'],
              u['product']['_id'],
              u['quantity']);

          products.add(product);
        }
        BillHistory bill = BillHistory(
            date: x['date'],
            id: x['_id'],
            products: products,
            total: x['total'],
            customerName: x['customer']['username']);
        data.add(bill);
      }
      return data;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text("Hi There")],
              )
            ],
          ),
          Expanded(
              flex: 8,
              child: FutureBuilder(
                  future: getData(),
                  builder: (context, snapshots) {
                    if (!snapshots.hasData) {
                      return const Text("Loading...");
                    } else {
                      var items = snapshots.data as List<BillHistory>;
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    BodyCardHeader(
                                        items: items, index: index),
                                    BodyCard(items: items, index: index)
                                  ],
                                )
                              ],
                            );
                          });
                    }
                  })),
        ],
      ),
    );
  }
}

class BodyCardHeader extends StatelessWidget {
  const BodyCardHeader({
    Key? key,
    required this.items,
    required this.index,
  }) : super(key: key);
  final int index;

  final List<BillHistory> items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Text("Order #${items[index].id}"),
          Text(
            items[index].date,
            style: const TextStyle(color: lightGray),
          )
        ]),
        Container(
          alignment: Alignment.centerRight,
          child: Text(items[index].total.toString()),
        )
      ],
    ));
  }
}

class BodyCard extends StatelessWidget {
  const BodyCard({Key? key, required this.items, required this.index})
      : super(key: key);
  final int index;
  final List<BillHistory> items;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: items[index].products.length,
            itemBuilder: (context, idx) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.14,
                      width: size.width * 0.14,
                      child: Image.network("http://192.168.1.12:5000/"+items[index].products[idx].image.replaceAllMapped(RegExp(r'\\'), (match) => '/'),fit: BoxFit.cover,)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              color:black,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(items[index].products[idx].title),
                                  Text(items[index].products[idx].description),
                                  Text(items[index].products[idx].price.toString()),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                                "Qty: ${items[index].products[idx].quantity.toString()}"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }
}
