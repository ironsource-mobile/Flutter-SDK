import 'package:flutter/material.dart';

class ButtonInfo {
  final String title;
  final void Function()? onPressed;
  ButtonInfo(this.title, this.onPressed);
}

class HorizontalButtons extends StatelessWidget {
  final List<ButtonInfo> buttons;
  const HorizontalButtons(this.buttons, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final smallBtnStyle = ElevatedButton.styleFrom(minimumSize: const Size(150, 45));
    return Row(
        children: buttons
            .map((btn) => Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: btn.onPressed,
                        child: Text(btn.title),
                        style: smallBtnStyle,
                      )),
                ))
            .toList());
  }
}
