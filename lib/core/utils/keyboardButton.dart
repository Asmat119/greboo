import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class KeyBoardSettings extends StatelessWidget {
  final Widget child;
  final FocusNode focusNode1;

  KeyBoardSettings({
    Key? key,
    required this.child,
    required this.focusNode1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
          keyboardBarColor: Colors.grey[200],
          actions: [
            KeyboardActionsItem(
                focusNode: focusNode1,
                displayArrows: false,
                toolbarButtons: [
                  (node) {
                    return CupertinoButton(
                      padding: EdgeInsets.zero.copyWith(right: 20),
                      onPressed: () => node.unfocus(),
                      child: Text(
                        'Done',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    );
                  },
                ]),
          ]),
      child: child,
    );
  }
}
