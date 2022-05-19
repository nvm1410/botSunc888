import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' as g;
class ScreenService{
  static MediaStream? _localStream;
  static MediaStreamTrack? videoTrack;
  static final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  static Size size = Size(g.Get.width, g.Get.height);

  static Future<void> record() async {
    await _localRenderer.initialize();
    final mediaConstraints = <String, dynamic>{
      'audio': false,
      "video": {
        "width": {"exact": 1024},
        "height": {"exact": 768}
      }
    };
    var stream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
    _localStream = stream;
    if (_localStream == null) throw Exception('Stream is not initialized');
    _localRenderer.srcObject = _localStream;
    size = Size(_localRenderer.videoWidth.toDouble(),_localRenderer.videoHeight.toDouble());
    videoTrack = _localStream!.getVideoTracks().firstWhere((track) => track.kind == 'video');
  }
  static Future<ByteBuffer> getFrames()async{
    final _byteBuffer = await videoTrack!.captureFrame();
    return _byteBuffer;
  }

  static void stop(){
    videoTrack!.stop();
    _localStream!.removeTrack(videoTrack!);
  }
}