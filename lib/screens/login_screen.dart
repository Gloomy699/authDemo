import 'package:auth_demo/widget/data_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import '../enum/enum.dart';
import '../base/base_screen.dart';
import 'home_screen.dart';
import '../model/name_element.dart';

class LoginScreen extends BaseScreen {
  static const String id = 'login_screen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends BaseScreenLayout<LoginScreen> {
  MobileVerificationState currentState = MobileVerificationState.phone;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final elementName = NameElement();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  @override
  Widget buildLayout(BuildContext context) {
    final phoneState = currentState == MobileVerificationState.phone;
    return Container(
      key: GlobalKey(),
      padding: const EdgeInsets.all(16.0),
      child: showLoading
          ? const Center(child: CircularProgressIndicator())
          : DataWidget(
              buttonPressCallback: phoneState ? () => sendPhone() : () => sendOtp(),
              controller: phoneState ? phoneController : otpController,
              hintText: elementName.copyWith(textName: phoneState ? 'Введите номер' : 'Ввести КОД').textName,
              buttonText: elementName.copyWith(textName: phoneState ? 'SEND' : 'Подтвердить'.toUpperCase()).textName,
            ),
    );
  }

  Future<void> signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      setState(() => showLoading = false);
      if (authCredential.user != null) {
        navigateTo();
      }
    } on FirebaseAuthException catch (e) {
      setState(() => showLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  Future<void> sendPhone() async {
    setState(
      () => showLoading = true,
    );
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (phoneAuthCredential) async {
        setState(
          () => showLoading = false,
        );
        signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) async {
        setState(
          () => showLoading = false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(verificationFailed.message!),
          ),
        );
      },
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          showLoading = false;
          currentState = MobileVerificationState.otp;
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  void sendOtp() {
    PhoneAuthCredential phoneAuthCredential =
        PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text);

    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void navigateTo() => Navigator.pushNamed(context, HomeScreen.id);
}
