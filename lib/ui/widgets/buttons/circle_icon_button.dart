import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget{
  final IconData icon;
  final VoidCallback onPressed;

  const CircleIconButton(
    {super.key,
    required this.icon,
    required this.onPressed
    }
  );

  @override 
  Widget build(BuildContext context){
    return InkResponse(
      onTap: onPressed,
      radius: 24,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

}