import 'package:flutter/material.dart';
import 'package:tf/config/config.dart';

class TextInput extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType textInputType;
  final TextEditingController controller;
  const TextInput({super.key, 
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      width: 327.0,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        style: const TextStyle(
            fontFamily: "PoppinsMedium",
            fontSize: 14.0,
            color: Config.subTitleColor),
        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: const TextStyle(color: Config.hintTextField),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Config.borderTextField),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Config.borderTextField),
            borderRadius: BorderRadius.circular(15.0),
          ),

          ///Ver la contraseña
          ///NODE FOCUS
        ),
      ),
    );
  }
}
