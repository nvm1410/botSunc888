import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
class BotOverlayScreen extends StatefulWidget {
  const BotOverlayScreen({ Key? key }) : super(key: key);

  @override
  State<BotOverlayScreen> createState() => _BotOverlayScreenState();
}

class _BotOverlayScreenState extends State<BotOverlayScreen> {
  String _dataFromApp = "Bắt đầu chơi";
  double x=0;
  double y=0;
  handleOverlayListener(){
    FlutterOverlayWindow.overlayListener.listen((event) {
      setState(() {
        _dataFromApp=event;
      });
      // print('hello world');

    });
  }
  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 2),(){
    //   setState(() {
    //     x=300;
    //     y=300;
    //   });
    // });
    this.handleOverlayListener();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: Scaffold(
        backgroundColor: Colors.green,
        body: InkWell(
          onTap:() async {
            await FlutterOverlayWindow.closeOverlay();
          },
          child: Stack(
            children: [
              // TextButton(onPressed: (){FlutterOverlayWindow.closeOverlay(); print('--------------------------------');}, child: Text('Close')),
              AnimatedPositioned(
                top: 0,
                left: 40,
                duration: Duration(seconds: 1),
                child:  Image.asset("assets/robot.gif", width: 150, fit: BoxFit.cover),
              ),
              AnimatedPositioned(
                top: 20,
                left: 0,
                duration: Duration(seconds: 1),
                child: BubbleSpecialThree(
                  text: '${_dataFromApp}',
                  color: Color(0xFF1B97F3),
                  tail: true,
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16
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