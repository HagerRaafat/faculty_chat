import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui_starter/screens/home_screen.dart';
import 'package:flutter_chat_ui_starter/screens/profile_screen.dart';
import 'package:flutter_chat_ui_starter/screens/welcome_screen.dart';
import 'package:flutter_chat_ui_starter/screens/chat_screen.dart';
import 'package:flutter_chat_ui_starter/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_ui_starter/services/navigation_service.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xFF125589),
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.transparent,
        primaryColor: Colors.white,
        accentColor: Color(0xFF125589),
      ),
      navigatorKey: NavigationService.instance.navigatorKey,
      initialRoute: LoginScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}

//Color(0xFFEDF6F9),
