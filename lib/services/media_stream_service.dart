import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
class ScreenService{
  static MediaStream? _localStream;
  static MediaStreamTrack? videoTrack;

  static Future<void> record() async {
    final mediaConstraints = <String, dynamic>{'audio': false, 'video': true};
    var stream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
    _localStream = stream;
    if (_localStream == null) throw Exception('Stream is not initialized');
    videoTrack = _localStream!.getVideoTracks().firstWhere((track) => track.kind == 'video');
  }
  // VoidCallback Function(ByteBuffer s) onByteAvailable
  static Future<ByteBuffer> getFrames()async{
    final _byteBuffer = await videoTrack!.captureFrame();
    final bytes = _byteBuffer.asUint8List();
    final Size imageSize = Size(videoTrack?.getSettings().width, cameraImage.height.toDouble());
    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: InputImageRotation.rotation0deg,
      inputImageFormat:  InputImageFormat.nv21,
    );
    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    return _byteBuffer;
  }

  static void stop(){
    videoTrack!.stop();
    _localStream!.removeTrack(videoTrack!);
  }
}