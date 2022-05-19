import 'dart:typed_data';

import 'package:bot_sunc_888/services/media_stream_service.dart';
import 'package:flutter/painting.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextRecognitionService {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> processImage(ByteBuffer bytes)async{
    var _curr = DateTime.now();
    final inputImageData = InputImageData(
      size: ScreenService.size,
      imageRotation: InputImageRotation.rotation0deg,
      inputImageFormat: InputImageFormat.yuv_420_888,
      planeData: [],
    );
    print('-----------------------------------');
    print(bytes.lengthInBytes);
    InputImage inputImage = InputImage.fromBytes(bytes: bytes.asUint8List(), inputImageData: inputImageData);
    final recognizedText = await textRecognizer.processImage(inputImage);
    print('Estime: ${DateTime.now().millisecondsSinceEpoch-_curr.millisecondsSinceEpoch}');
    String text = recognizedText.text;
    print(text);
    for (TextBlock block in recognizedText.blocks) {
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