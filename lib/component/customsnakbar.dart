import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSnackBarContent extends StatelessWidget {
  const CustomSnackBarContent({Key? key, required this.errorText})
      : super(key: key);
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 80,
          decoration: const BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Oh snap!",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    errorText,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -20,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /* SvgPicture.asset(
                "assets/drop.svg",
                height: 48,
                width: 40,
                color: const Color(0xFF801336),
              ), */
              SvgPicture.asset(
                "assets/cancel.svg",
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            ],
          ),
        )
      ],
    );
  }
}
