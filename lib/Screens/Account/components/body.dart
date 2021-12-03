import 'package:flutter/material.dart';
import 'package:foodorder/Screens/Account/components/background.dart';


class Body extends StatefulWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular((size.height * 0.08)/2),
                child: Container(
                  width: size.height * 0.08,
                  height: size.height * 0.08,
                  child: Image.asset("assets/images/women.png", fit: BoxFit.cover,),
                ),
              )
            ],
          )
        ],
      )
    );
  }
}