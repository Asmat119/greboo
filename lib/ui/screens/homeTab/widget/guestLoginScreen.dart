import 'package:flutter/material.dart';
import 'package:grebooo/ui/screens/homeTab/widget/guestLoginView.dart';
import 'package:grebooo/ui/shared/appbar.dart';

class GuestLoginScreen extends StatelessWidget {
  const GuestLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: ""),
      body: GuestLoginView(),
    );
  }
}
