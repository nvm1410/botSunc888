import 'dart:io';
import 'dart:typed_data';

import 'package:bot_sunc_888/services/media_stream_service.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart' as g;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';

class TextRecognitionService {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

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
    print('aaaaaaaaaaa'+ text);
    for (TextBlock block in recognizedText.blocks) {
      print(block.text);
      // block.text
      // final Rect rect = block.rect;
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