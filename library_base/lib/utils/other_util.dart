
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:library_base/generated/l10n.dart';
import 'package:library_base/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

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

  ///处理链接
  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.error("暂不能处理这条链接:$url");
    }
  }
}
