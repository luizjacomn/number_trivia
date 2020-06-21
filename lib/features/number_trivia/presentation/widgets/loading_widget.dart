import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 3,
      child: Center(
        child: SizedBox(
          height: 8.0,
          child: LinearProgressIndicator(
            backgroundColor: Colors.deepOrange.shade200,
            valueColor: AlwaysStoppedAnimation(Colors.deepOrange.shade500),
          ),
        ),
      ),
    );
  }
}
