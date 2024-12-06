import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RenderSvg extends StatefulWidget {
  final String path;
  final Color? color;
  final double? size;
  const RenderSvg({Key? key, required this.path, this.color, this.size})
      : super(key: key);

  @override
  State<RenderSvg> createState() => _RenderSvgState();
}

class _RenderSvgState extends State<RenderSvg> {
  @override
  Widget build(BuildContext context) {
    // Wrapping the SvgPicture with SizedBox to control the size
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: SvgPicture.asset(
        widget.path,
        colorFilter: widget.color != null
            ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
            : null,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain, // Ensuring it scales to the defined size
      ),
    );
  }
}
