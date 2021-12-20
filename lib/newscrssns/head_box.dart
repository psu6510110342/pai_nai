import 'package:flutter/material.dart';
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
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
          ),
          Positioned(
              bottom: 21,
              left: 50,
              child: FlatButton(
                child: Text(
                  AppLocalizations.of(context).translate('Sign in'),
                  // 'sign in',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                onPressed: () {
                  MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (BuildContext context) => Home());
                  Navigator.of(context).pushReplacement(materialPageRoute);
                },
              )),
          Positioned(
              bottom: 23,
              left: 217,
              child: FlatButton(
                child: Text(
                  AppLocalizations.of(context).translate('Sign up'),
                  // 'sign in',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
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
