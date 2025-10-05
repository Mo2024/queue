import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String btnText;
  final double widthPercentage;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.btnText,
    required this.onPressed,
    required this.widthPercentage,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: widthPercentage * deviceWidth,
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            btnText,
            style: TextStyle(
              fontWeight: Localizations.localeOf(context).languageCode == 'ar'
                  ? FontWeight.w900
                  : FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
