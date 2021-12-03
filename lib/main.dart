import 'dart:convert';
import 'dart:io';
import 'package:foodorder/components/cart_dialog.dart';
import 'package:foodorder/routes/route_generator.dart';

import 'models/product.dart';
import './style.dart';
import './utils/white_box.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

Future getData() async {
  final response =
      await http.get(Uri.http('192.168.1.12:5000', 'api/products'), headers: {
    HttpHeaders.authorizationHeader:
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MTg0YTY3MmRlYWM5NThmNDM2Y2ZjODYiLCJpYXQiOjE2MzY2MjQxMTZ9.CDz-U3kFPPqR-nd05w9F8AuPo_VaYPb0fv04i7GwUOM'
  });
  final jsondata = jsonDecode(response.body);
  List<Product> products = [];
  if (jsondata['success']) {
    for (var u in jsondata['Products']) {
      Product product = Product(
          u['title'], u['description'], u['price'], u['image'], u['_id'], 0);
      products.add(product);
    }
    return products;
  } else {
    return null;
  }
}

class DetailPage extends StatelessWidget {
  final String id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Text(id),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Widget popularCard() {
  return FutureBuilder(
      future: getData(),
      builder: (context, snapshots) {
        if (snapshots.data == null) {
          return const Text("Loading...");
        } else {
          var items = snapshots.data as List<Product>;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/itemDetail', arguments: items[index]);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.asset(
                          'assets/images/burgercheddar.png',
                          height: 140.0,
                          width: 140.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text((() {
                        var x = items[index].title;
                        if (x.length >= 14) {
                          return x.substring(0, 13) + "...";
                        }
                        return x;
                      })(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black,
                          )),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "\$ ",
                          style: const TextStyle(
                            fontSize: 16,
                            color: dolar,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: items[index].price.toString(),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            )
                          ]),
                    )
                  ],
                ),
              );
            },
          );
        }
      });
}

Widget categoryCard(context) {
  return Padding(
    padding: const EdgeInsets.only(right: 15.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        color: primarycolor,
        child: IntrinsicHeight(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/detail', arguments: 'abcfdfs');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    child: FittedBox(
                      child: Image.asset('assets/images/Hambuger.png'),
                    ),
                  ),
                ),
                IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const <Widget>[
                        Text(
                          'Burger',
                          style: TextStyle(
                            color: white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget buildNavigateButton() => FloatingActionButton(
          child: const Icon(Icons.shopping_cart),
          backgroundColor: Colors.green,
          onPressed: () {
            showGeneralDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                transitionBuilder: (context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: CartDialog(size: size),
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {
                  return Container();
                });
          },
        );
    final items = [
      const Icon(Icons.home),
      const Icon(Icons.content_paste),
      const Icon(Icons.person),
    ];
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        // appBar: AppBar(
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.white,
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       SizedBox(
        //         height: 34.0,
        //         width: 104.0,
        //         child: FittedBox(
        //           child: Image.asset(
        //             'assets/images/Logo.png',
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        floatingActionButton: buildNavigateButton(),
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: const IconThemeData(color: white)),
          child: CurvedNavigationBar(
            buttonBackgroundColor: purple,
            color: Colors.blueAccent,
            backgroundColor: transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            items: items,
            index: index,
            height: size.height * 0.08,
            onTap: (index) => setState(() {
              this.index = index;
              switch (index) {
                case 0:
                  break;
                case 1:
                  Navigator.of(context).pushNamed("/Bill");
                  break;
                case 2:
                  Navigator.of(context).pushNamed("/Account");
                  break;
                default:
                  return;
              }
            }),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/Banner.jpg'),
                        fit: BoxFit.fill,
                      )),
                      height: 183.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              left: 40,
                            ),
                            child: SizedBox(
                              width: 180,
                              child: RichText(
                                  text: const TextSpan(
                                      text: 'The Fastest In Delivery ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                      ),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: 'Food',
                                        style: TextStyle(
                                          color: primarycolor,
                                        ))
                                  ])),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 70,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                primary: primarycolor,
                              ),
                              child: const Text(
                                'Order Now',
                                style: TextStyle(
                                  color: white,
                                ),
                              ),
                              onPressed: () {
                                getData();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  WhiteBox(5),
                  SizedBox(
                    height: 120.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                color: black,
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return categoryCard(context);
                                    }),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 220.0,
                    alignment: Alignment.centerLeft,
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Popular',
                              style: TextStyle(
                                color: black,
                                fontSize: 26,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  popularCard(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
