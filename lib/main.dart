import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Home/home_page.dart';
import 'package:flutter_application_1/Screens/Login/login_screen.dart';

import 'package:flutter_application_1/provider/class_provider.dart';
import 'package:flutter_application_1/provider/google_sign_in.dart';
import 'package:flutter_application_1/provider/registration_provider.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'utils.dart';

import '/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Registrations>(create: (context) => Registrations())
      ],
      child: MaterialApp(
        // routes: {
        //   '/': (context) => HomePage(),
        //   '/classes': (context) => ClassesScreen(),
        //   //'/register': (context) =>
        // },
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return HomePage();
              } else {
                print(snapshot);
                return LoginScreen();
              }
            }),
      ),
    );
  }
}
