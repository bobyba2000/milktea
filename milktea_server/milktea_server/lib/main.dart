import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/page/login_page.dart';
import 'package:milktea_server/page/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA9G_atYHjL8dBtUdWO-wLdzbrUH0JRgYo",
      authDomain: "milktea-94514.firebaseapp.com",
      databaseURL: "https://milktea-94514-default-rtdb.firebaseio.com",
      projectId: "milktea-94514",
      storageBucket: "milktea-94514.appspot.com",
      messagingSenderId: "299613566906",
      appId: "1:299613566906:web:14e7458be987d5348f8f83",
      measurementId: "G-7DVKB5RYVJ",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LandingPage(),
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(207, 152, 98, 1),
        fontFamily: 'Barlow',
      ),
      builder: EasyLoading.init(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('There has been an error.'),
          );
        } else if (snapshot.hasData) {
          return const MainPage();
        }
        return const LoginPage();
      }),
      stream: FirebaseAuth.instance.authStateChanges(),
    );
  }
}
