import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_app/pages/account_page.dart';
import 'package:training_app/pages/dashboard.dart';

class NavDashboard extends StatefulWidget{
  NavDashboardState createState() => NavDashboardState();
}

class NavDashboardState extends State<NavDashboard>{
  int _currentIndex = 0;
  Widget pageWidget = Dashboard();

  Widget _buildOriginDesign() {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Colors.transparent,
      strokeColor: Colors.transparent,
      unSelectedColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      items: [
        CustomNavigationBarItem(
          // icon: Image.asset(
          //   0'assets/images/rest.png':'assets/images/rest.png',
          //   height: 25.0,
          //   width: 25.0,
          // ),
          icon: Icon(
              Icons.home_outlined,
              color: _currentIndex==0?Colors.white:Colors.white60,
          )
        ),
        CustomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: _currentIndex==1?Colors.white:Colors.white60,
            )
        ),
        CustomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: _currentIndex==2?Colors.white:Colors.white60,
            )
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget mWidget(int position){
    Widget mmWidget = Dashboard();
    switch(position){
      case 0:
        mmWidget = Dashboard();
        break;
      case 1:
        mmWidget = Dashboard();
        break;
      case 2:
        mmWidget = AccountPage();
        break;
    }
    return mmWidget;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(
              "assets/images/cycle_run.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            mWidget(_currentIndex),
            Align(
                alignment: Alignment.bottomCenter,
                child: _buildOriginDesign()
            )
          ],
        ),
      ),
    );
  }

}