import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kDefaultPadding = 25.0;
const kOnBoardingPageAnimationDuration = Duration(milliseconds: 600);
const kFontSize = 20.0;
const kBorderRadius = 15.0;
const kAppFont = "Nexa";
final dateFormat = DateFormat("h:mm a");
void disposeKeyboard() {
  return FocusManager.instance.primaryFocus?.unfocus();
}
