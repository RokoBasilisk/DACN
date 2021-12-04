import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:foodorder/Screens/Authentication/components/body.dart';
import 'package:foodorder/components/cart_dialog.dart';
import 'package:foodorder/style.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  int index = 2;

  @override
  void initState() {
    super.initState();
  }

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
        appBar: AppBar(
          
        ),
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
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
                  Navigator.of(context).pushNamed('/');
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
        body: const SingleChildScrollView(child: Body()));
  }
}
