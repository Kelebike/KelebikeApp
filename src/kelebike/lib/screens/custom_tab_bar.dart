import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final int index;

  const CustomTabBar({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Color(0xFF6CA8F1)),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
          ),
          Expanded(
            child: CustomTabBarButton(
              text: "Take Request",
              textColor: index == 0 ? Colors.white : Colors.grey,
              borderColor: index == 0 ? Colors.transparent : Colors.transparent,
              borderWidth: index == 0 ? 3 : 0,
            ),
          ),
          Expanded(
            child: CustomTabBarButton(
              text: "Return Request",
              textColor: index == 1 ? Colors.white : Colors.grey,
              borderColor: index == 1 ? Colors.transparent : Colors.transparent,
              borderWidth: index == 1 ? 3 : 0,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTabBarButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color textColor;
  final double borderWidth;

  const CustomTabBarButton({
    Key? key,
    required this.text,
    required this.borderColor,
    required this.textColor,
    this.borderWidth = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: borderWidth),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
