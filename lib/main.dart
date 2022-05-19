import 'package:bot_sunc_888/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:rive/rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyOverlaContent()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class MyOverlaContent extends StatefulWidget {
  const MyOverlaContent({ Key? key }) : super(key: key);

  @override
  State<MyOverlaContent> createState() => _MyOverlaContentState();
}

class _MyOverlaContentState extends State<MyOverlaContent> {
  String _dataFromApp = "Hey send data";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          TextButton(onPressed: (){FlutterOverlayWindow.closeOverlay(); print('--------------------------------');}, child: Text('Close')),
          Image.asset("assets/robot.gif", width: 200, fit: BoxFit.cover)
        ],
      ),
    );
  }
}