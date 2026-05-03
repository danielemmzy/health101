import 'package:flutter/material.dart';

class Auth_text_field extends StatefulWidget {
  final String text;
  final String icon;
  final TextEditingController? controller;
  final bool isPassword;

  const Auth_text_field({
    super.key,
    required this.text,
    required this.icon,
    this.controller,
    this.isPassword = false,
  });

  @override
  State<Auth_text_field> createState() => _Auth_text_fieldState();
}

class _Auth_text_fieldState extends State<Auth_text_field> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextField(
          controller: widget.controller,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.none,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            focusColor: Colors.black26,
            fillColor: const Color.fromARGB(255, 247, 247, 247),
            filled: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                child: Image.asset(widget.icon),
              ),
            ),
            prefixIconColor: const Color(0xFF339CFF),
            label: Text(widget.text),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}