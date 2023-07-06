import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memory_game/services/helpers.dart';

import 'utils.dart';

class WinLoseDialog extends StatelessWidget {
  String title;
  WinLoseDialog(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
   bool isTab=ScreenUtilClass().getIsTab(context);
   return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon at the top

          Padding(
            padding: isTab?const EdgeInsets.only(right: 800,bottom: 10):const EdgeInsets.only(right: 500),
            child: Image.asset(
              'assets/new-ui/images/blub.png',
              width: isTab?300:100.0,
              height: isTab?300:150.0,
            ),
          ),
          // Image at the center
          // Container(
          //   // margin: EdgeInsets.only(top: 16.0),
          //   child: Image.asset(
          //     'assets/new-ui/images/bg.png',
          //     width: 200.0,
          //     height: 200.0,
          //   ),
          // ),
          Padding(
            padding: isTab?const EdgeInsets.only(bottom: 200):const EdgeInsets.all(8.0),
            child: Container(
              width:isTab?800:400,
              height: isTab?300:150,
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/new-ui/images/alert.png'),
                  // fit: BoxFit.cover,
                ),
              ),
              child: Center(child:Text(
                title,
                style: SafeGoogleFont(
                  'Grandstander',
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 0.9975,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }



}
