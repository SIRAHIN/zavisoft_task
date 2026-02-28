import 'package:flutter/material.dart';

class SectionHeaderWidget extends StatelessWidget {
   String title;
   SectionHeaderWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black45,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}