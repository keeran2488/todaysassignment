import 'package:flutter/material.dart';
import 'package:todaysassignment/functions/constants.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String title;

  CustomButton({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding * 1.5),
        ),
        color: Colors.blue,
        onPressed: this.onPressed,
        child: Text(
          this.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
