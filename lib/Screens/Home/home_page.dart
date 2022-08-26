import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/provider/registration.dart';
import 'package:flutter_application_1/provider/registration_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum MenuItem {
  item1,
}

class _HomePageState extends State<HomePage> {
  var _isInit = true;
  var _isLoading = false;
  var email;
  String? name;

  @override
  void initState() {
    email = FirebaseAuth.instance.currentUser!.email;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Registrations>(context).fetchRegistrations().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //name = data.toList()[0].name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Home'),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                if (value == MenuItem.item1) {
                  FirebaseAuth.instance.signOut();
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: MenuItem.item1, child: Text('Sign Out'))
                  ])
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              QrImage(
                data: {
                  " email": email,
                  "date": DateFormat('yyyy-MM-dd').format(DateTime.now())
                }.toString(),
                size: 300,
              ),
              SizedBox(
                height: 10,
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(primary: kPrimaryColor),
              //   child: Text('signOut'),
              //   onPressed: () => FirebaseAuth.instance.signOut(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
