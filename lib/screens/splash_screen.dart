import 'package:flutter/material.dart';
import 'package:jumpin_assignment/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: 2500),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.3,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon/icon.png',
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'Profile Veri',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              CircularProgressIndicator(strokeWidth: 1.5),
            ],
          ),
        ),
      ),
    );
  }
}
