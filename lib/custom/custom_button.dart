import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {Key? key,
      this.text = "",
      this.highlight = false,
      required this.onPressed})
      : super(key: key);
  final String text;
  final bool highlight;
  final VoidCallback? onPressed;

  @override
  // ignore: library_private_types_in_public_api
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _active = false;

  void _handleOnTapDown(tapDownDetails) {
    setState(() {
      _active = true;
    });
  }

  void _handleOnTapUp(tapUpDetails) {
    widget.onPressed!();
    setState(() {
      _active = false;
    });
  }

  Color _getColor() {
    if (_active) {
      if (widget.highlight) {
        return const Color.fromARGB(
            1, 34, 215, 255); //Color.fromRGBO(248, 248, 153, 1);
      } else {
        return const Color.fromARGB(
            255, 105, 100, 99); //Color.fromRGBO(0, 0, 0, 0.25);
      }
    } else {
      if (widget.highlight) {
        return const Color.fromARGB(
            255, 17, 166, 240); // Color.fromRGBO(23, 234, 255, 1);
      } else {
        return const Color.fromARGB(
            255, 105, 100, 99); //Color.fromRGBO(0, 0, 0, 0.5);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleOnTapDown,
      onTapUp: _handleOnTapUp,
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: _getColor(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 18,
                color: widget.highlight
                    ? Colors.white //Color.fromRGBO(198, 83, 141, 1)
                    : _active
                        ? const Color.fromRGBO(255, 255, 255, 0.5)
                        : Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
