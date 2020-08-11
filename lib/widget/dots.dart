import 'package:flutter/cupertino.dart';

class DotGoodDay extends StatelessWidget {
  final Color color;
  final int size;

  const DotGoodDay({Key key, this.color, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size != null ? size.toDouble() : 4,
      decoration: BoxDecoration(color: this.color, shape: BoxShape.circle),
    );
  }
}
