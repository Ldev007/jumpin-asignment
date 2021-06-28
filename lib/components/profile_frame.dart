import 'package:flutter/material.dart';

class ProfilePicFrame extends StatelessWidget {
  const ProfilePicFrame({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.child,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.teal),
      ),
    );
  }
}
