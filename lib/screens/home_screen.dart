import 'dart:async';
import 'dart:typed_data';

import 'package:bot_sunc_888/services/media_stream_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ByteBuffer? bytes;
  int count = 0;
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          SizedBox(width: 300, height: 300, child: RiveAnimation.asset('assets/bluebot.riv', )),
          // Center(
          //     child: bytes == null
          //         ? Container(
          //       width: 300,
          //       height: 400,
          //       color: Colors.blue)
          //         : Image.memory(bytes!.asUint8List(), width: 300, height: 400,)
          // ),
          TextButton(
            onPressed: () async {
              ScreenService.record();
              _timer = Timer.periodic(Duration(seconds: 1), (timer) async{
                setState(() {
                  count++;
                });
                if(count%5==0){
                  bytes = await ScreenService.getFrames();
                  setState(() {
                    bytes;
                  });
                }
              });
            },
            child: Text('Start recording'),
          ),
          TextButton(
            onPressed: () async {
              bytes = await ScreenService.getFrames();
              setState(() {
                bytes;
              });
            },
            child: Text('Capture recording'),
          ),
          TextButton(
            onPressed: () async {
              ScreenService.stop();
              _timer!.cancel();
            },
            child: Text('Stop'),
          ),
          TextButton(
            onPressed: () async {
              await FlutterOverlayWindow.showOverlay(
                alignment: OverlayAlignment.topRight,
                flag: OverlayFlag.focusPointer,
                width: 500,
                height: 1000,
              );
            },
            child: Text('Overlay'),
          ),
          TextButton(
            onPressed: () async {
              await FlutterOverlayWindow.closeOverlay();
            },
            child: Text('Close Overlay'),
          ),
          Text('${count}'),
        ],
      ),
    );
  }
}