import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bot_sunc_888/services/media_stream_service.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart' as g;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiengviet/tiengviet.dart';

class TextRecognitionService {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final regexGameId = RegExp(r'SD\d+-');
  bool startBet=true;
  bool stopBet=false;
  bool gameFinished=false;
  Rect? chanPosition=null;
  Rect? lePosition=null

   // true
  Future<void> processImage(ByteBuffer bytes)async{
    var _curr = DateTime.now();
    final inputImageData = InputImageData(
      size: Size(300 ,300),
      imageRotation: InputImageRotation.rotation0deg,
      inputImageFormat: InputImageFormat.yuv_420_888,
      planeData: [],
    );
    print('-----------------------------------');
    print(bytes.lengthInBytes);
    Uint8List imageInUnit8List = bytes.asUint8List();// store unit8List image here ;
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(imageInUnit8List);
    InputImage inputImage = InputImage.fromFile(file);
    final recognizedText = await textRecognizer.processImage(inputImage);
    print('Estime: ${DateTime.now().millisecondsSinceEpoch-_curr.millisecondsSinceEpoch}');
    String text = recognizedText.text;
    print(text);
    if(!regexGameId.hasMatch(text)) return;
    if(regexGameId.hasMatch(text)){
      // ingame
      print('đang ở trong game');
      if(TiengViet.parse(text).contains('Dat cuoc')){

        //start bet
        if(startBet){
          print('giai đoạn đặt cược');
          var intValue = Random().nextInt(2);
          if(intValue==0){
            FlutterOverlayWindow.shareData("Về chẵn");
          } else FlutterOverlayWindow.shareData("Về lẻ");
          startBet=false;
        }
      } else if(TiengViet.parse(text).toLowerCase().contains('khong dat cuoc nua')){
        print('hết giai đoạn đặt cược');
        // stop bet
        stopBet=true;
        // check neu nguoi dung khong dat cuoc vao chan hoac le
        FlutterOverlayWindow.shareData("Để tiền ván sau");
        gameFinished=true;
      }
      if(!gameFinished && stopBet){
        // theo doi ket qua cuoc va lua chon cua nguoi choi


        //sau khi co ket qua check ket qua
        // theo va thang
        FlutterOverlayWindow.shareData("Ngon");
        // theo va thua
        FlutterOverlayWindow.shareData("Xui thôi");
        // không theo va thang
        FlutterOverlayWindow.shareData("Hên thôi");
        // không theo  va thua
        FlutterOverlayWindow.shareData("Nói rồi mà");
        gameFinished=true;
        // sau do 4s sẽ reset game
        Timer(Duration(seconds: 4),(){
          FlutterOverlayWindow.shareData('đợi ván mới nào');
          startBet=true;
          stopBet=false;
          gameFinished=false;
        });
      }

    }
    for (TextBlock block in recognizedText.blocks) {

      // block.text
      if(TiengViet.parse(block.text).contains('Chan') && chanPosition==null) {
        final Rect rect = block.boundingBox;
        chanPosition=rect;
      }

      if(TiengViet.parse(block.text).contains('Le')){
        final Rect rect = block.boundingBox;
        lePosition=rect;
      }

      // if(TiengViet.parse(block.text).contains('\$')){
      //   print('người chơi có đặt cược');
      //   final Rect rect = block.boundingBox;
      //   print(block.text);
      //   print(rect);
      // }

      // final List<Offset> cornerPoints = block.cornerPoints;
      // final String text = block.text;
      // final List<String> languages = block.recognizedLanguages;
      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }
  void dispose(){
    textRecognizer.close();
  }
}