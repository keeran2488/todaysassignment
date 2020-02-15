import 'package:flutter/material.dart';
import 'package:todaysassignment/functions/constants.dart';


class DashboardButton extends StatelessWidget {

  final IconData icon;
  final String title;
  final Function onClick;

  DashboardButton({@required this.icon,@required this.title, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: kDefaultPadding,
              ),
              Icon(
                this.icon,
                size: kDefaultPadding * 2.5,
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Text(
                this.title,
                style: TextStyle(
                  fontSize: kDefaultPadding * .75,
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
            ],
          ),
        ),
        onPressed: this.onClick,
      ),
    );
  }
}
