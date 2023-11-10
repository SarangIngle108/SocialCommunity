import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
   ErrorText({Key? key,required this.error}) : super(key: key);
  String error;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
