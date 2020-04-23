import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  InputField({this.icon, this.hint, this.obscure, this.stream, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChanged,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            errorText: snapshot.hasError ? snapshot.error : null,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            contentPadding: EdgeInsets.only(
              left: 5,
              right: 30,
              top: 30,
              bottom: 30
            )
          ),
          style: TextStyle(
            color: Colors.white,
          ),
        );
      }
    );
  }
}
