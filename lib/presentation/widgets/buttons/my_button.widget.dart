import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function onPressed;
  final String texto;
  final bool camposRellenos;

  const MyButton(
      {super.key, required this.onPressed,
      required this.texto,
      this.camposRellenos = false});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    Color buttonColor = widget.camposRellenos
        ? const Color(0xFF3629B7)
        : const Color(
            0xFFFFFFFF); // Cambia el color del botón según el estado de los campos

    return SizedBox(
      height: 44,
      width: 327,
      child: ElevatedButton(
        onPressed: widget.camposRellenos
            ? () {
                widget.onPressed();
              }
            : () {},
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(buttonColor),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ))),
        child: Text(widget.texto),
      ),
    );
  }
}
