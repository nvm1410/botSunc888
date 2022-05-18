import 'package:flutter_feathersjs/flutter_feathersjs.dart';
import 'package:get/get.dart';

class Feathers {
  static const BASE_URL = "https://devtestweb.xyz";
  static FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()..init(baseUrl: BASE_URL);
  static log(dynamic message) async{
    flutterFeathersjs.create(serviceName: 'logs', data: message);
  }
}
