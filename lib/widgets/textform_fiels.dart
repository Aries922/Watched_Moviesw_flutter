import 'package:flutter/material.dart';

const _border = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
  borderSide: BorderSide(color: Colors.black),
);

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    this.hintText,
    this.onSaved,
    this.validator,
    this.textInputType,
  }) : super(key: key);
  final String? hintText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType? textInputType;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onSaved: widget.onSaved,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        
        fillColor: Colors.transparent,
        hintText: widget.hintText,
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,
      ),
    );
  }

 
}



class MyPasswordField extends StatefulWidget {
   final String? hintText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType? textInputType;

  const MyPasswordField({Key? key, this.hintText, this.onSaved, this.validator, this.textInputType}) : super(key: key);

  @override
  _MyPasswordFieldState createState() => _MyPasswordFieldState();
}

class _MyPasswordFieldState extends State<MyPasswordField> {
  bool _showPassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _showPassword,
       validator: widget.validator,
      onSaved: widget.onSaved,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
          suffixIcon: GestureDetector(
              onTap: _togglePasswordVisibility,
              child: _showPassword
                  ? const Icon(Icons.visibility_off_outlined)
                  : const Icon(Icons.visibility_outlined)),
          fillColor: Colors.transparent,
        hintText: widget.hintText,
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,),
    );
  }

  _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }
}
