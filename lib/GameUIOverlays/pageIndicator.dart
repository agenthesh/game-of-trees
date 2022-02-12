import 'package:flutter/material.dart';

class PageIndicator extends StatefulWidget {
  const PageIndicator({Key? key, required this.isActive}) : super(key: key);

  final bool isActive;

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: widget.isActive ? 8 : 6.0,
        width: widget.isActive ? 10 : 6.0,
        decoration: BoxDecoration(
          boxShadow: [
            widget.isActive
                ? BoxShadow(
                    color: Color(0XFFEC407A).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: widget.isActive ? Colors.pink : Colors.grey[400],
        ),
      ),
    );
  }
}
