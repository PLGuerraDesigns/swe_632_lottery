import 'package:flutter/material.dart';

/// Adds a hover scale effect to a widget. Scales a widget up when the
/// mouse is hovering over it and down when the mouse is not hovering
/// over it or when the widget is tapped.
class HoverScaleHandler extends StatefulWidget {
  const HoverScaleHandler({
    super.key,
    required this.child,
    required this.onTap,
    this.enabled = true,
  });

  /// The widget to apply the hover scale effect to.
  final Widget child;

  /// The function to call when the widget is tapped.
  final Function()? onTap;

  /// Whether onTap is allowed.
  final bool enabled;

  @override
  State<HoverScaleHandler> createState() => HoverScaleHandlerState();
}

class HoverScaleHandlerState extends State<HoverScaleHandler> {
  /// The duration of the animation in milliseconds.
  final int _msAnimationDuration = 100;

  /// The default scale of the widget.
  final double _defaultScale = 1;

  /// The scale of the widget when the mouse is hovering over it.
  final double _scaleOnHover = 1.05;

  /// The current scale of the widget.
  double _currentScale = 1;

  /// Whether the widget has been tapped.
  bool _tapped = false;

  /// Whether the mouse is hovering over the widget.
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(
        () {
          _isHovering = true;
          _currentScale = _scaleOnHover;
        },
      ),
      onExit: (_) => setState(
        () {
          _isHovering = false;
          _currentScale = _defaultScale;
        },
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: !widget.enabled
            ? null
            : () async {
                if (_tapped) {
                  return;
                }

                _tapped = true;

                setState(() {
                  _currentScale = 1;
                });

                await Future<void>.delayed(
                    Duration(milliseconds: _msAnimationDuration + 50));

                setState(() {
                  _currentScale = _scaleOnHover;
                });

                await Future<void>.delayed(
                    Duration(milliseconds: _msAnimationDuration));

                if (!_isHovering) {
                  setState(() {
                    _currentScale = _defaultScale;
                  });
                }

                widget.onTap?.call();

                _tapped = false;
              },
        child: AnimatedScale(
          scale: _currentScale,
          duration: Duration(milliseconds: _msAnimationDuration),
          child: widget.child,
        ),
      ),
    );
  }
}
