import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final Function()? onClick;
  final String? textforclick;
  final String? textonly;

   const CustomRichText({ this.onClick, this.textforclick, this.textonly});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: '$textonly',style: const TextStyle(color: Colors.grey)),
            TextSpan(
                text: ' $textforclick',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16),),
          ],
        ),
      ),
    );
  }
}