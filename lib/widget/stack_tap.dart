import 'package:flutter/material.dart';

class StackTap extends StatefulWidget {
  const StackTap({
    Key? key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.splashColor,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? splashColor;

  @override
  // ignore: library_private_types_in_public_api
  _StackTapState createState() => _StackTapState();
}

class _StackTapState extends State<StackTap> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: widget.borderRadius,
              onTap: widget.onTap,
              hoverColor: Colors.white.withOpacity(0.3),
              splashColor: widget.splashColor,
              highlightColor: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }
}
