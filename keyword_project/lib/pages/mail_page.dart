import 'package:flutter/material.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});
  
  @override
  State<MailPage> createState() => _MailPageState();
  
}

class _MailPageState extends State<MailPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 400,
            height: double.infinity,
            color: Colors.red,
          ),
        )
      ],
    );
  }
}