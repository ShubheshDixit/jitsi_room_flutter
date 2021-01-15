// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AwesomeTextField extends StatefulWidget {
  final bool isPassword;
  final Widget prefixIcon;
  final TextInputType keyboardType;
  final TextStyle labelNhintStyle, inputStyle;
  final Color backgroundColor, enabledBorderColor, focusedBorderColor;
  final BorderRadius borderRadius;
  final double borderWidth, width;
  final String hintText, labelText, helperText;
  final Widget suffix;
  final Function onTap, onSubmitted, onChanged, onEditingComplete;
  final int maxLines, minLines, maxLength;
  final InputBorderType borderType;
  final BoxConstraints prefixIconConstraints;
  final TextEditingController controller;
  final List<TextInputFormatter> formatter;
  final bool obscureText;

  final List<BoxShadow> boxShadow;

  const AwesomeTextField(
      {Key key,
      this.isPassword = false,
      this.borderType = InputBorderType.outlined,
      this.prefixIcon,
      this.prefixIconConstraints,
      this.maxLength,
      this.maxLines,
      this.minLines,
      this.width,
      this.labelNhintStyle,
      this.inputStyle,
      this.enabledBorderColor,
      this.focusedBorderColor,
      this.backgroundColor,
      this.borderRadius,
      this.borderWidth,
      this.hintText,
      this.labelText,
      this.suffix,
      this.onTap,
      this.onSubmitted,
      this.onChanged,
      this.onEditingComplete,
      this.boxShadow,
      this.keyboardType,
      this.controller,
      this.formatter,
      this.obscureText = false,
      this.helperText})
      : super(key: key);

  @override
  _AwesomeTextFieldState createState() => _AwesomeTextFieldState();
}

class _AwesomeTextFieldState extends State<AwesomeTextField>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  bool isHidden = false;
  bool showOuterBorder = true;
  double width = 60;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..forward();
    if (widget.isPassword) isHidden = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(_animationController),
      child: Container(
        width: widget.width ?? 300,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.transparent,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          boxShadow: widget.boxShadow ?? [],
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          inputFormatters: widget.formatter,
          onSubmitted: widget.onSubmitted,
          onEditingComplete: widget.onEditingComplete,
          onTap: widget.onTap,
          obscureText: widget.isPassword ? isHidden : widget.obscureText,
          maxLength: widget.maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          style: widget.inputStyle ??
              TextStyle(
                fontSize: 18,
              ),
          decoration: InputDecoration(
            focusedErrorBorder: _buildBorder(Colors.red),
            focusedBorder: _buildBorder(
                widget.focusedBorderColor ?? Theme.of(context).primaryColor),
            enabledBorder:
                _buildBorder(widget.enabledBorderColor ?? Colors.grey[400]),
            prefixIconConstraints: widget.prefixIconConstraints ??
                BoxConstraints(
                  minWidth: widget.prefixIcon != null ? 40 : 10,
                  maxWidth: widget.prefixIcon != null ? 60 : 10,
                ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: widget.prefixIcon)
                : SizedBox.shrink(),
            hintText: widget.hintText,
            labelText: widget.labelText,
            helperText: widget.helperText,
            floatingLabelBehavior: widget.hintText == null
                ? FloatingLabelBehavior.auto
                : FloatingLabelBehavior.always,
            suffixIconConstraints: BoxConstraints(
              minWidth: widget.suffix != null || widget.isPassword ? 40 : 10,
              maxWidth: widget.suffix != null || widget.isPassword ? 60 : 10,
            ),
            suffixIcon: widget.suffix ?? widget.isPassword
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          iconSize: 20,
                          splashRadius: 25,
                          onPressed: () {
                            setState(() {
                              isHidden = !isHidden;
                            });
                          },
                          icon: Icon(isHidden
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  _buildBorder(color) {
    if (widget.borderType == InputBorderType.none)
      return InputBorder.none;
    else if (widget.borderType == InputBorderType.outlined)
      return OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          borderSide: BorderSide(
            width: widget.borderWidth ?? 2,
            color: color,
          ));
    else
      return UnderlineInputBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        borderSide: BorderSide(width: widget.borderWidth ?? 2, color: color),
      );
  }
}

enum InputBorderType { none, outlined, underlined }
