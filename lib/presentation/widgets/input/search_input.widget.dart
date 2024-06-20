import 'package:flutter/material.dart';
import 'package:tf/config/config.dart';

class SearchInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function function;

  const SearchInput(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      width: 327.0,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        style: const TextStyle(
            fontFamily: "PoppinsMedium",
            fontSize: 14.0,
            color: Config.subTitleColor),
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Config.iconColorBottom,
              ),
              onPressed: () {
                function();
              }),
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
