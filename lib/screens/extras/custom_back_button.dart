import 'package:flutter/material.dart';
import '../../constants.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Navigate back',
      iconSize: kIconSize,
      color: Colors.black54,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: kTertiaryColor,
      ),
    );
  }
}
