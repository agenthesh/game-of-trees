import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    this.fontSize = 20,
    required this.onPressed,
    required this.label,
    this.width = 255.0,
    this.height = 50.0,
    this.opacity = 0.4,
    this.disabled = false,
    this.fontWeight = FontWeight.normal,
    this.labelColor = Colors.black,
  });
  final double opacity;
  final GestureTapCallback onPressed;
  final String label;
  final double width;
  final double height;
  final bool disabled;
  final double fontSize;
  final FontWeight fontWeight;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: disabled ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.all(Radius.circular(11.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? () {} : onPressed,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          highlightColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
          splashColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
          child: Center(
              child: AutoSizeText(
            label,
            style: TextStyle(
              color: disabled ? Color(0xFF797979) : labelColor,
              fontSize: this.fontSize,
              fontWeight: this.fontWeight,
            ),
            maxLines: 1,
          )),
        ),
      ),
    );
  }
}
