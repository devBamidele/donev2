import 'package:flutter/material.dart';

/// Display a message when there are no tasks or categories
class NoneAvailable extends StatelessWidget {
  const NoneAvailable({
    required this.message,
    Key? key,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 19,
        ),
      ),
    );
  }
}
