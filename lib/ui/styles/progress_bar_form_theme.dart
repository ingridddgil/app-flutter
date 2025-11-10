import 'package:flutter/material.dart';

  // styles
  const Color brand = Color(0xFF8B1E04); // botón / step activo
  const Color line  = Color.fromARGB(255, 229, 229, 229); // divisores / bordes suaves
  const double radius = 12;

  InputDecoration inputDec(String label, {String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F1F1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: brand, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }