import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHorizontalList extends StatelessWidget {
  const MyHorizontalList(
      {Key? key,
      required this.startColor,
      required this.endColor,
      required this.courseHeadline,
      required this.courseTitle,
      required this.courseImage,
      required this.width,
      required this.height,
      required this.scale})
      : super(key: key);
  final Color startColor, endColor;
  final String courseHeadline, courseTitle, courseImage;
  final double scale, width, height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(1, 0.0),
            colors: <Color>[
              startColor,
              endColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 11,
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 39,
                decoration: BoxDecoration(
                  color: const Color(0xFF6CA8F1),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Text(
                  courseHeadline,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 14,
              child: Text(
                courseTitle,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(
                courseImage,
                scale: scale,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
