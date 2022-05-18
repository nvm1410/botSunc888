import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
class MediaStreamService{
  static MediaStream? _localStream;
  static RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  static MediaStreamTrack? videoTrack;
  static Future<void> record() async {
    final mediaConstraints = <String, dynamic>{'audio': false, 'video': true};

    try {
      var stream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      stream.getVideoTracks()[0].onEnded = () {
        print('By adding a listener on onEnded you can: 1) catch stop video sharing on Web');
      };
      _localStream = stream as MediaStream?;
      // _localRenderer.srcObject = _localStream;
      if (_localStream == null) throw Exception('Stream is not initialized');
      videoTrack = _localStream!
          .getVideoTracks()
          .firstWhere((track) => track.kind == 'video');
      getFrames();

    } catch (e) {
      print(e.toString());
    }
  }
  static getFrames(){
    Timer.periodic(Duration(milliseconds: 100),(_)async{
      try {
        final frame = await videoTrack!.captureFrame();
        print(frame.lengthInBytes);
      } catch (e){
        print(e.toString());
      }
    });
  }
  static Future<void> initRenderers() async {
    await _localRenderer.initialize();
  }

}