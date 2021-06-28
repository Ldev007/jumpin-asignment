import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Loading..'),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
      ],
    );
  }
}
