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
  bool? playerBetLe=null;
  bool? gameIsLe=null;
  bool? botSuggestLe=null;
  bool gameFinished=false;
  Rect? chanPosition=null;
  Rect? lePosition=null;

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
    // print(text);
    if(!regexGameId.hasMatch(text)) return;
    if(regexGameId.hasMatch(text)){
      // ingame
      print('đang ở trong game');
      print('aaaaaaaaaaaaaaaaaa'+gameIsLe.toString());
      if(TiengViet.parse(text).contains('Dat cuoc')){

        //start bet
        if(startBet){
          print('giai đoạn đặt cược');
          var intValue = Random().nextInt(2);
          if(intValue==0){
            botSuggestLe=false;
            FlutterOverlayWindow.shareData("Về chẵn");
          } else {
            botSuggestLe=true;
            FlutterOverlayWindow.shareData("Về lẻ");
          }
          startBet=false;
        }
      } else if(TiengViet.parse(text).toLowerCase().contains('khong dat cuoc nua')){
        print('hết giai đoạn đặt cược');
        // stop bet
        stopBet=true;
        if(playerBetLe==null){
          FlutterOverlayWindow.shareData("Để tiền ván sau");
          gameFinished=true;
          Timer(Duration(seconds: 4),(){
            FlutterOverlayWindow.shareData('đợi ván mới nào');
            startBet=true;
            stopBet=false;
            gameFinished=false;
            chanPosition=null;
            lePosition=null;
            playerBetLe=null;
            botSuggestLe=null;
            gameIsLe=null;
          });
        }

      }
      if(!gameFinished && stopBet){
        // theo doi ket qua cuoc va lua chon cua nguoi choi

        if(gameIsLe==null || playerBetLe==null || botSuggestLe==null){

        } else {
          bool isPlayerWon=(gameIsLe! && playerBetLe!)||(!gameIsLe! && !playerBetLe!);
          bool isPlayerFollowedBot=(botSuggestLe! && playerBetLe!)||(!botSuggestLe! && !playerBetLe!);
          if(isPlayerWon && isPlayerFollowedBot){
            FlutterOverlayWindow.shareData("Ngon");
          } else if(!isPlayerWon && isPlayerFollowedBot){
            FlutterOverlayWindow.shareData("Xui thôi");
          } else if(isPlayerWon && !isPlayerFollowedBot){
            FlutterOverlayWindow.shareData("Hên thôi");
          } else if(!isPlayerWon && !isPlayerFollowedBot){
            FlutterOverlayWindow.shareData("Nói rồi mà");
          } else {
            FlutterOverlayWindow.shareData("...");
          }
          gameFinished=true;
          // sau do 4s sẽ reset game
          Timer(Duration(seconds: 4),(){
            FlutterOverlayWindow.shareData('đợi ván mới nào');
            startBet=true;
            stopBet=false;
            gameFinished=false;
            chanPosition=null;
            lePosition=null;
            playerBetLe=null;
            botSuggestLe=null;
            gameIsLe=null;
          });
        };
        //sau khi co ket qua check ket qua
        // theo va thang



      }

    }
    for (TextBlock block in recognizedText.blocks) {

      // block.text
      if(TiengViet.parse(block.text).contains('Chan') && chanPosition==null) {
        final Rect rect = block.boundingBox;
        chanPosition=rect;
        print('chan');
        print(rect);
      }
      if(TiengViet.parse(block.text).contains('Chan') && chanPosition!=null && lePosition!=null) {
        final Rect rect = block.boundingBox;

        if((rect.top-lePosition!.top).abs()>300){
          gameIsLe=false;
          print('kết quả game ra chẵn');
          print((rect.top-lePosition!.top).abs());
        }
      }
      if(TiengViet.parse(block.text).contains('Le') && lePosition==null){
        final Rect rect = block.boundingBox;
        lePosition=rect;
        print('le');
        print(rect);
      }
      if(TiengViet.parse(block.text).contains('Le') && lePosition!=null &&chanPosition!=null) {
        final Rect rect = block.boundingBox;
        print(rect.top);
        print(chanPosition!.top);
        if((rect.top-chanPosition!.top).abs()>300){
          print('kết quả game ra lẻ');
          print((rect.top-chanPosition!.top).abs());
          gameIsLe=true;

        }
      }
      if(TiengViet.parse(block.text).contains('\$')){
        final Rect rect = block.boundingBox;
        if(chanPosition!=null && lePosition!=null) {
          if((rect.left-chanPosition!.right).abs()>(rect.left-lePosition!.right).abs()){
            playerBetLe=true;
          } else {
            playerBetLe=false;
          }
        }

        print(rect);
      }

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