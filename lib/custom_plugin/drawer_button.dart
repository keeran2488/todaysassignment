import 'package:flutter/material.dart';
import 'package:todaysassignment/functions/constants.dart';

class DrawerButton extends StatelessWidget {

  final IconData icon;
  final String title;
  final Function onclick;

  DrawerButton({@required this.icon, @required this.title, @required this.onclick});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Row(
        children: <Widget>[
          SizedBox(width: kDefaultPadding),
          Icon(this.icon),
          SizedBox(width: kDefaultPadding),
          Text(this.title),
        ],
      ),
      onPressed: this.onclick,
    );
  }
}


