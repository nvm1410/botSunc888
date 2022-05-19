import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
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
    final _byte = await videoTrack!.captureFrame();
    return _byte;
  }

  static void stop(){
    videoTrack!.stop();
    _localStream!.removeTrack(videoTrack!);
  }
}