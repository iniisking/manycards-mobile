import 'package:flutter/material.dart';
import 'package:manycards/view/constants/widgets/colors.dart';

class CreateSubcard extends StatelessWidget {
  const CreateSubcard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.cancel_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
