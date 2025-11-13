// progress_bar_form_theme.dart
import 'package:flutter/material.dart';

// styles
const Color brand  = Color(0xFF8B1E04);                    // focus/active border
const Color line   = Color.fromARGB(255, 229, 229, 229);   // soft dividers
const double radius = 5;

// Label stays outside the field (so it never floats). This only styles the box.
InputDecoration inputDec(String label, {String? hint, Widget? suffixIcon}) {
  return InputDecoration(
    hintText: hint,
    suffixIcon: suffixIcon,

    // Figma: Fill #787878 at 3%
    filled: true,
    fillColor:  const Color(0xFFF7F7F7), 

    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    floatingLabelBehavior: FloatingLabelBehavior.never,

    // Rounded, no visible border at rest; brand border on focus
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: brand, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Colors.red, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );
}

// Figma shadow: X 0, Y 2, Blur 4, Spread 0, #000 @ 25%
Widget fieldContainer({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.25),
          blurRadius: 4,
          offset: Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    ),
    child: child,
  );
}
