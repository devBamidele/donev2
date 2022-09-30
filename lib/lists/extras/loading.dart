import 'package:donev2/constants.dart';
import 'package:flutter/material.dart';

/// Display a [CircularProgressIndicator] during load
class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: kTertiaryColor,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Loading...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
