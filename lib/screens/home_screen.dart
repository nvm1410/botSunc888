import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bot_sunc_888/services/media_stream_service.dart';
import 'package:bot_sunc_888/services/text_recognition_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextRecognitionService textRecognitionService = TextRecognitionService();
  ByteBuffer? bytes;
  int count = 0;
  Timer? _timer;
  bool canProcessFrame=true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textRecognitionService.dispose();
  }
  void onLatestScreenRecordFrame()async{
    if(!canProcessFrame) return;
    setState(() {
      count++;
    });
    bytes = await ScreenService.getFrames();
    if(bytes!.lengthInBytes!=0){
      await textRecognitionService.processImage(bytes!);
      setState(() {
        bytes;
      });
    }
    onLatestScreenRecordFrame();
  }
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
          // Center(
          //     child: bytes == null
          //         ? Container(
          //       width: 300,
          //       height: 400,
          //       color: Colors.blue)
          //         : Image.memory(bytes!.asUint8List(), width: 300, height: 400,)
          // ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Hướng dẫn sử dụng:\n Bật bot rồi bấm start recording, sau đó chuyển qua màn hình game để chơi.\nKhi muốn dừng bot bấm vào Tắt bot rồi bấm vào stop'),
          ),
          TextButton(
            onPressed: () async {
              await ScreenService.record();
              onLatestScreenRecordFrame();
            },
            child: Text('Start recording'),
          ),

          TextButton(
            onPressed: () async {
              ScreenService.stop();
              canProcessFrame=false;
            },
            child: Text('Stop'),
          ),
          TextButton(
            onPressed: () async {
              final bool status = await FlutterOverlayWindow.isPermissionGranted();
              if(!status) await FlutterOverlayWindow.requestPermission();
              await FlutterOverlayWindow.showOverlay(
                alignment: OverlayAlignment.topRight,
                flag: OverlayFlag.clickThrough,
              );
            },
            child: Text('Bật bot'),
          ),
          TextButton(
            onPressed: () async {
              FlutterOverlayWindow.shareData('closeBot');
            },
            child: Text('Tắt bot'),
          ),
          Text('${count}'),
        ],
      ),
    );
  }
}
