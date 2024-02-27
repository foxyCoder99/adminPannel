import 'package:advisorapp/config/size_config.dart';
import 'package:flutter/material.dart';

class CirlularLoader extends StatelessWidget {
  const CirlularLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth / 2,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
