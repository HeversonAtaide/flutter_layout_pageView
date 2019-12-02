import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:page_indicator/page_indicator.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isColapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  List<String> _meses = ["jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez"];

  PageController pageController3 = PageController();
  var currentPageValue = 0.0;

  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  double _currentPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.8,

  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);

    pageController3.addListener(() {
      setState(() {
        currentPageValue = pageController3.page;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget menu(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Dashboard",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                SizedBox(height: 10),
                Text(
                  "Messages",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                SizedBox(height: 10),
                Text(
                  "Utility Bills",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                SizedBox(height: 10),
                Text(
                  "Funds Transfer",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                SizedBox(height: 10),
                Text(
                  "Branches",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(BuildContext context) {

    /*Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeIn,
      );
    });*/

    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isColapsed ? 0 : 0.6 * screenWidth,
      right: isColapsed ? 0 : -0.4 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          color: backgroundColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      InkWell(
                        child: Icon(Icons.menu, color: Colors.white),
                        onTap: () {
                          setState(() {
                            if (isColapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            isColapsed = !isColapsed;
                          });
                        },
                      ),
                      Text("My Cards",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      Icon(
                        Icons.settings,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 300,
                    child: pages(),
                  ),
                  /*Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 35),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < 4; i++)
                              if (i == currentPageValue)
                                circleBar(true)
                              else
                                circleBar(false),
                          ],
                        ),
                      ),
                    ],
                  ),*/
                  SizedBox(height: 20),
                  Text("Transactions", style: TextStyle(color: Colors.white, fontSize: 20),),
                  ListView.separated(
                    shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("Macbook"),
                          subtitle: Text(_meses[index]),
                          trailing: Text("-2900"),
                        );
                        /*return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(index.toString(), style: TextStyle(fontSize: 20),),
                          ),
                        );*/
                      },
                      separatorBuilder: (context, index) {
                        return Divider(height: 16);
                      },
                      itemCount: _meses.length)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget pages(){
    return PageIndicatorContainer(
      child: PageView(
        onPageChanged: (position){
          getChangedPageAndMoveBar(position);
          setState(() {

          });

        },
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        pageSnapping: true,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            child: new Sparkline(
              data: data,
            ),

          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.redAccent,
            width: 100,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.blueAccent,
            width: 100,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.greenAccent,
            width: 100,
          ),
        ],
      ),
      align: IndicatorAlign.bottom,
      length: 4,
      indicatorSpace: 10.0,
      padding: EdgeInsets.all(10),
      shape: IndicatorShape.circle(size: 8),
      indicatorColor: Colors.black12,
      indicatorSelectorColor: Colors.blueAccent,

    );
  }

  Widget pages2(){
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          width: 160.0,
          color: Colors.red,
        ),
        Container(
          width: 160.0,
          color: Colors.blue,
        ),
        Container(
          width: 160.0,
          color: Colors.green,
        ),
        Container(
          width: 160.0,
          color: Colors.yellow,
        ),
        Container(
          width: 160.0,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget pages3(){
    return PageView.builder(
      controller: pageController3,
      itemBuilder: (context, position) {
        if (position == currentPageValue.floor()) {
          return Transform.scale (
            scale: currentPageValue,
            child: Container (
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 200.0,
              width: 200.0,
              color: Colors.yellow ,
            ),
          );
        } else if (position == currentPageValue.floor() + 1){
          return Transform.scale (
            scale: currentPageValue % 1,
            child: Container (
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 200.0,
              width: 200.0,
              color: Colors.yellow ,
            ),
          );
        } else {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: position % 2 == 0 ? Colors.blue : Colors.pink,
            child: Center(
              child: Text(
                "Page",
                style: TextStyle(color: Colors.white, fontSize: 22.0),
              ),
            ),
          );
        }
      },
      itemCount: 10,
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.orange : Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
  void getChangedPageAndMoveBar(int page) {
    //currentPageValue = page;
    setState(() {});
  }
}
