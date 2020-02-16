import 'package:flutter/material.dart';
import 'package:todaysassignment/functions/constants.dart';


class CustomTextForm extends StatelessWidget {

  final Function onSaved;
  final Function validator;
  final String title;
  final TextInputAction inputAction;
  final FocusNode focus;
  final Function onNext;
  final String initialValue;
  final bool obscureText;

  CustomTextForm({@required this.onSaved, @required this.validator, @required this.title, this.initialValue, this.inputAction, this.focus, this.obscureText ,this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
      child: TextFormField(
        initialValue: this.initialValue,
        focusNode: focus,
        validator: this.validator,
        obscureText: this.obscureText,
        onSaved: this.onSaved,
        textInputAction: this.inputAction,
        decoration: InputDecoration(
          labelText: this.title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding * 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: kDefaultPadding,
          ),
          hasFloatingPlaceholder: false,
        ),

        onFieldSubmitted: this.onNext,
      ),
    );
  }
}
