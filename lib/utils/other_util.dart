
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:lighthouse/generated/l10n.dart';

class OtherUtil {
  OtherUtil._internal();

  static KeyboardActionsConfig getKeyboardActionsConfig(BuildContext context, List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: List.generate(list.length, (i) => KeyboardActionsItem(
        focusNode: list[i],
        toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(S.of(context).close),
              ),
            );
          },
        ],
      )),
    );
  }

}
