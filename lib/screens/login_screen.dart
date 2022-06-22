import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import '../enum.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState = MobileVerificationState.phone;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  getMobileFormWidget(context) {
    return Column(
      children: [
        const Spacer(),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            hintText: 'Номер телефона',
          ),
        ),
        const SizedBox(height: 16.0),
        TextButton(
          onPressed: () async {
            setState(() => showLoading = true);
            await _auth.verifyPhoneNumber(
              phoneNumber: phoneController.text,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() => showLoading = false);
                signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              verificationFailed: (verificationFailed) async {
                setState(() => showLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(verificationFailed.message!)));
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
          },
          style: TextButton.styleFrom(
            elevation: 0,
            minimumSize: const Size.fromHeight(56.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ).merge(
            ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
                  return states.contains(MaterialState.disabled) ? Colors.blueGrey : Colors.blue;
                },
              ),
            ),
          ),
          child: const Text(
            "SEND",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        const Spacer(),
        TextField(
          controller: otpController,
          decoration: const InputDecoration(
            hintText: 'Ввести КОД',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          style: TextButton.styleFrom(
            elevation: 0,
            minimumSize: const Size.fromHeight(56.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ).merge(
            ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
                  return states.contains(MaterialState.disabled) ? Colors.blueGrey : Colors.blue;
                },
              ),
            ),
          ),
          child: Text(
            'подтвердить'.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      body: Container(
        child: showLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : currentState == MobileVerificationState.phone
                ? getMobileFormWidget(context)
                : getOtpFormWidget(context),
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      setState(
        () => showLoading = false,
      );
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

  void navigateTo() => Navigator.pushNamed(context, HomeScreen.id);
}
