import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../base/base_screen.dart';
import 'login_screen.dart';
import '../model/name_element.dart';

class HomeScreen extends BaseScreen {
  static String id = 'home_screen';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends BaseScreenLayout<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final elementName = NameElement();

  @override
  Widget buildLayout(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Text(elementName.copyWith(textName: 'Ура все получилось').textName),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FloatingActionButton(
                onPressed: () async {
                  await _auth.signOut();
                  navigateTo();
                },
                child: const Icon(Icons.logout),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigateTo() => Navigator.pushNamed(context, LoginScreen.id);
}
