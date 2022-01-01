//import 'dart:html';//
//import 'dart:ui';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pai_nai/newscreens_2/cafe_screen .dart';
import 'package:pai_nai/newscreens_2/market_screen .dart';
import 'package:pai_nai/newscreens_2/nature_screen .dart';
import 'package:pai_nai/newscreens_2/newdestination_screen .dart';
import 'package:pai_nai/newscreens_2/popular_screen .dart';
import 'package:pai_nai/newscreens_2/temple_screen.dart';
import 'package:pai_nai/newscreens_2/recommend_screen.Dart';

class Homescreen extends StatefulWidget {
  static const String idScreen = 'tourist';
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  // Page Controller
  TabController _controller;
  TabController _controller1;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);
    _controller1 = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              // Custom Navigation
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 28.8, left: 28.8, right: 28.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 45,
                      width: 45,
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1), // changes position of shadow
                          )
                        ],
                        color: Color(0x080a0928),
                      ),
                      child: Icon(Icons.arrow_back),
                      //SvgPicture.asset('assets/svg/arrow.svg'),
                    ),
                  ],
                ),
              ),
              // Widget for title
              Padding(
                padding: EdgeInsets.only(top: 48, left: 28.8),
                child: Text(
                  'Tourist\nattraction',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 45.6, fontWeight: FontWeight.w700),
                ),
              ),
              // Custom tab bar
              Container(
                height: 30,
                margin: EdgeInsets.only(left: 14.4, top: 28.8),
                child: DefaultTabController(
                  length: 3,
                  child: TabBar(
                    labelPadding: EdgeInsets.only(left: 14.4, right: 14.4),
                    indicatorPadding: EdgeInsets.only(left: 14.4, right: 14.4),
                    isScrollable: true,
                    controller: _controller,
                    labelColor: Color(0xFF000000),
                    unselectedLabelColor: Color(0xFF8a8a8a),
                    labelStyle: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.w700),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Color(0xFF000000),
                    indicatorWeight: 2.4,
                    tabs: [
                      Tab(
                        child: Container(
                          child: Text('Recommended'),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Text('Popular'),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Text('New destination'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //tabView with pictures
              Container(
                height: 333.6,
                width: 218.6,
                child: DefaultTabController(
                  length: 3,
                  child: TabBarView(
                    children: <Widget>[
                      Recommendedscreen(),
                      Popularscreen(),
                      Newdestinationscreen(),
                    ],
                    controller: _controller,
                  ),
                ),
              ),

              //Text Widget For Categories
              Padding(
                padding: EdgeInsets.only(top: 50, left: 28.8, right: 28.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Categories',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff000000)),
                    ),
                  ],
                ),
              ),
              //ListView for  Categories
              Container(
                height: 30,
                margin: EdgeInsets.only(left: 14.4, top: 28.8, bottom: 10),
                child: DefaultTabController(
                  length: 4,
                  child: TabBar(
                    labelPadding: EdgeInsets.only(left: 14.4, right: 14.4),
                    indicatorPadding: EdgeInsets.only(left: 14.4, right: 14.4),
                    isScrollable: true,
                    controller: _controller1,
                    labelColor: Color(0xFF000000),
                    unselectedLabelColor: Color(0xFF8a8a8a),
                    labelStyle: GoogleFonts.lato(
                        fontSize: 16, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: GoogleFonts.lato(
                        fontSize: 16, fontWeight: FontWeight.w700),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Color(0xFF000000),
                    indicatorWeight: 2.4,
                    tabs: [
                      Tab(
                        child: Container(
                          child: Text('cafe'),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Text('Market'),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Text('Temple'),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Text('Nature'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //ListView for Beach Section
              Container(
                height: 333.6,
                width: 218.6,
                child: DefaultTabController(
                  length: 4,
                  child: TabBarView(
                    children: <Widget>[
                      Cafescreen(),
                      Marketscreen(),
                      Tamplescreen(),
                      NatureScreen(),
                    ],
                    controller: _controller1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
