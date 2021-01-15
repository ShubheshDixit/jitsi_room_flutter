import 'package:flutter/material.dart';

class AwesomeButton extends StatefulWidget {
  final bool isExpanded;
  final AwesomeButtonType buttonType;
  final Widget child, icon, label;
  final double width, height;
  final Function onPressed, onLongPressed;
  final ButtonStyle buttonStyle;

  const AwesomeButton(
      {Key key,
      this.isExpanded = false,
      this.buttonType = AwesomeButtonType.text,
      this.child,
      this.icon,
      this.label,
      this.onPressed,
      this.onLongPressed,
      this.buttonStyle,
      this.width,
      this.height})
      : assert(
            !(child != null && icon != null), 'Can have either child or icon'),
        super(key: key);
  @override
  _AwesomeButtonState createState() => _AwesomeButtonState();
}

class _AwesomeButtonState extends State<AwesomeButton> {
  Widget _buildChild() {
    switch (widget.buttonType) {
      case AwesomeButtonType.text:
        return widget.child != null
            ? Container(
                width: widget.isExpanded
                    ? MediaQuery.of(context).size.width
                    : widget.width,
                height: widget.height,
                child: TextButton(
                  onLongPress: widget.onLongPressed,
                  onPressed: widget.onPressed,
                  child: widget.child,
                  style: widget.buttonStyle,
                ),
              )
            : Container(
                width: widget.isExpanded
                    ? MediaQuery.of(context).size.width
                    : widget.width,
                height: widget.height,
                child: TextButton.icon(
                  onLongPress: widget.onLongPressed,
                  onPressed: widget.onPressed,
                  icon: widget.icon,
                  label: widget.label,
                  style: widget.buttonStyle,
                ),
              );
        break;
      case AwesomeButtonType.elevated:
        return widget.child != null
            ? Container(
                width: widget.isExpanded
                    ? MediaQuery.of(context).size.width
                    : widget.width,
                height: widget.height,
                child: ElevatedButton(
                  onLongPress: widget.onLongPressed,
                  onPressed: widget.onPressed,
                  child: widget.child,
                  style: widget.buttonStyle,
                ),
              )
            : Container(
                width: widget.isExpanded
                    ? MediaQuery.of(context).size.width
                    : widget.width,
                height: widget.height,
                child: ElevatedButton.icon(
                  onLongPress: widget.onLongPressed,
                  onPressed: widget.onPressed,
                  icon: widget.icon,
                  label: widget.label,
                  style: widget.buttonStyle,
                ),
              );
        break;
      case AwesomeButtonType.outline:
        return widget.child != null
            ? Container(
                width: widget.isExpanded
                    ? MediaQuery.of(context).size.width
                    : widget.width,
                height: widget.height,
                child: OutlinedButton(
                  onLongPress: widget.onLongPressed,
                  onPressed: widget.onPressed,
                  child: widget.child,
                  style: widget.buttonStyle,
                ),
              )
            : Container(
                width: widget.isExpanded
                    ? MediaQuery.of(context).size.width
                    : widget.width,
                height: widget.height,
                child: OutlinedButton.icon(
                  onLongPress: widget.onLongPressed,
                  onPressed: widget.onPressed,
                  icon: widget.icon,
                  label: widget.label,
                  style: widget.buttonStyle,
                ),
              );
        break;
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildChild(),
    );
  }
}

enum AwesomeButtonType { text, outline, elevated }

class AwesomeGradientButton extends StatefulWidget {
  final bool isExpanded;
  final Widget child, icon, label;
  final double width, height;
  final Function onPressed, onLongPressed;
  final Gradient gradient;
  final BorderRadius borderRadius;
  final BoxShadow boxShadow;

  const AwesomeGradientButton(
      {Key key,
      this.isExpanded = false,
      this.icon,
      this.label,
      this.width,
      this.height,
      this.onPressed,
      this.onLongPressed,
      this.gradient,
      this.child,
      this.borderRadius,
      this.boxShadow})
      : super(key: key);
  @override
  _AwesomeGradientButtonState createState() => _AwesomeGradientButtonState();
}

class _AwesomeGradientButtonState extends State<AwesomeGradientButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.gradient ??
            LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ],
            ),
      ),
    );
  }
}
