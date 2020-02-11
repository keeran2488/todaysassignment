import 'package:flutter/material.dart';
import 'package:todaysassignment/functions/constants.dart';


class CustomTextForm extends StatelessWidget {

  final Function onSaved;
  final Function validator;
  final String title;

  CustomTextForm({@required this.onSaved, @required this.validator, @required this.title});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: this.validator,
      onSaved: this.onSaved,
      decoration: InputDecoration(
        labelText: this.title,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: kDefaultPadding,
        ),
      ),
    );
  }
}
