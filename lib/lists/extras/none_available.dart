import 'package:flutter/material.dart';

class NoneAvailable extends StatelessWidget {
  const NoneAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No current Todos',
        style: TextStyle(
          fontSize: 19,
        ),
      ),
    );
  }
}
