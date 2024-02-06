import 'package:flutter/material.dart';

class CustomTile extends StatefulWidget {
  final IconData eliteIconData;
  final String eliteIconText;
  final String eliteRouteName;
  final Object eliteRouteArgs;
  const CustomTile(this.eliteIconData, this.eliteIconText, this.eliteRouteName,
      this.eliteRouteArgs,
      {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CustomTileState createState() => _CustomTileState();
}

//CustomTile(this.eliteIconData, this.eliteIconText, this.eliteRouteName);

class _CustomTileState extends State<CustomTile> {
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.blueGrey))),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(widget.eliteIconData),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      widget.eliteIconText,
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_right),
            ],
          ),
          onTap: () => Navigator.pushNamed(context, widget.eliteRouteName,
              arguments: widget.eliteRouteArgs),
        ),
      ),
    );
  }
}
