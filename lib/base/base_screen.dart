// Barbara Liskov principle

import 'package:flutter/material.dart';

abstract class BaseScreen extends StatefulWidget {}

abstract class BaseScreenLayout<L extends BaseScreen> extends State<L> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildLayout(context),
          Container(),
        ],
      ),
    );
  }

  @protected
  Widget buildLayout(BuildContext context);
}


