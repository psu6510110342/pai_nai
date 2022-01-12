import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pai_nai/newscrssns/home.dart';
import 'package:pai_nai/newscrssns/home_2.dart';
import 'package:pai_nai/newscrssns/app_localizations.dart';

class Head_box extends StatelessWidget {
  const Head_box({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.43,
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.43 - 27,
            decoration: BoxDecoration(
                color: HexColor("#29557a"),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Image.asset(
                    'images/logo_2.png',
                    width: size.height * 0.35,
                    height: size.height * 0.35,
                  )),
            ],
          ),
          Container(
              padding: EdgeInsets.only(
                  bottom: 5.0,
                  left: size.width * 0.15,
                  top: size.height * 0.35),
              //height: size.height * 0.43 - 27,
              child: FlatButton(
                child: Text(
                  AppLocalizations.of(context).translate('Sign in'),
                  // 'sign in',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                onPressed: () {
                  MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (BuildContext context) => Home());
                  Navigator.of(context).pushReplacement(materialPageRoute);
                },
              )),
          Container(
              padding: EdgeInsets.only(
                  bottom: 5.0, left: size.width * 0.6, top: size.height * 0.35),
              child: FlatButton(
                child: Text(
                  AppLocalizations.of(context).translate('Sign up'),
                  // 'sign in',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                onPressed: () {
                  MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (BuildContext context) => Home2());
                  Navigator.of(context).pushReplacement(materialPageRoute);
                },
              )),
        ],
      ),
    );
  }
}
