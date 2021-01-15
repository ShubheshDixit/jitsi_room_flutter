import 'package:flutter/material.dart';
import 'package:jitsi_room/widgets/awesome_buttons.dart';

/// # AwesomeContainer
/// It is a container that can have an overflow widget with label and actions at bottom.
/// It also has a scrollable body of column that can include image or icon at start of the axis.
class AwesomeContainer extends StatelessWidget {
  // Overflow Child
  // A widget that stays on top of the container actual body.
  final Widget overflowChildWidget;
  final double overflowChildHeight, overflowChildWidth;

  // Label
  // A widget (or just text) to define heading of the contents
  final Widget labelWidget;
  final Text labelText;
  final TextStyle labelTextStyle;
  final bool isLabelHidden, isPopUp;

  // Top Child
  // A widget that is the first element of the containers body. Could be an image or icon.
  final Widget topChildWidget, topChildImage, topChildIcon;
  final bool isTopChildCentered;
  final double topChildHeight, topChildWidth;
  final Color topChildBgColor;
  final EdgeInsets topChildPadding;
  final BorderRadius topChildBorderRadius;

  // Container
  final BorderRadius containerBorderRadius;
  final Color containerBgColor;
  final double containerHeight, containerWidth;
  final bool isContainerScrollable;
  final CrossAxisAlignment contentHorizontalAlignment;
  final MainAxisAlignment contentVerticalAlignment;
  final BoxDecoration containerDecoration;

  // Body Widget
  final Widget bodyWidget;
  // Title
  final Text title;
  // Subtitle
  final Text subtitle;

  // Actions
  final Widget actionWidget;
  final List<Widget> actions;
  final bool isActionsExpanded;
  final MainAxisAlignment actionsRowAlignment;
  final EdgeInsets actionsPadding;
  final Color actionsBgColor;

  // Default action
  final String actionLabel;
  final Color actionColor;
  final Function onActionPressed;

  /// # AwesomeContainer
  /// It is a container that can have an overflow widget with label and actions at bottom.
  /// It also has a scrollable body of column that can include image or icon at start of the axis.
  ///
  /// ## Content
  ///
  /// ### Container:
  /// The main container with custom decoration, height, width passed as [containerDecoration], [containerHeight], [containerWidth] respectively.
  ///
  /// ### Overflow Child:
  /// A widget that stays on top of the container's actual body. Passed as [overflowChild] with properties [overflowChildHeight] and [overflowChildWidth].
  ///
  /// ### Label:
  /// A widget (or just text) to define heading of the contents. Could be passed as a widget [labelWidget] or just the [labelText] with textStyle as [labelTextStyle]
  ///
  /// ### TopChild:
  /// A widget that (could be an image) to design the container.
  ///
  /// ### Body:
  /// A widget to define the body as [bodyWidget] or as [title] and [subtitle] that are Text.
  ///
  /// ### Actions:
  /// A widget to have action buttons or other action command at the end of column. Can be [actionWidget] or List of row elements send as [actions]. Defaults to expanded RaisedButton.
  const AwesomeContainer(
      {Key key,
      this.overflowChildWidget,
      this.overflowChildHeight = 150,
      this.overflowChildWidth = 150,
      this.labelWidget,
      this.labelText,
      this.labelTextStyle,
      this.isLabelHidden = false,
      this.topChildWidget,
      this.topChildImage,
      this.topChildIcon,
      this.isTopChildCentered = false,
      this.topChildHeight = 150,
      this.topChildWidth,
      this.topChildBgColor = Colors.transparent,
      this.topChildPadding,
      this.topChildBorderRadius,
      this.containerBorderRadius,
      this.containerBgColor,
      this.containerHeight,
      this.containerWidth,
      this.containerDecoration,
      this.isContainerScrollable = false,
      this.contentHorizontalAlignment,
      this.contentVerticalAlignment,
      this.bodyWidget,
      this.title,
      this.subtitle,
      this.actionWidget,
      this.actions,
      this.isActionsExpanded = true,
      this.actionsRowAlignment,
      this.actionsPadding,
      this.actionsBgColor,
      this.actionLabel,
      this.onActionPressed,
      this.actionColor,
      this.isPopUp = false})
      : assert(!(labelWidget != null && labelText != null),
            'Either provide a label widget or the label text'),
        assert(!(actionWidget != null && actions != null),
            'Either provide the entire action widget or just the list of widgets in that row'),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: containerWidth ?? 400,
          height: containerHeight,
          margin: EdgeInsets.only(
              top: overflowChildWidget == null
                  ? 0
                  : overflowChildHeight != null || overflowChildWidth != null
                      ? (overflowChildHeight > overflowChildWidth
                          ? overflowChildHeight / 1.5
                          : overflowChildWidth / 1.5)
                      : 0.0),
          decoration: containerDecoration ??
              BoxDecoration(
                borderRadius: containerDecoration == null
                    ? containerBorderRadius ?? BorderRadius.circular(4.0)
                    : BorderRadius.circular(0.0),
                color: containerBgColor ??
                    Theme.of(context).scaffoldBackgroundColor,
              ),
          child: isContainerScrollable
              ? SingleChildScrollView(child: _buildBody(context))
              : _buildBody(context),
        ),
        overflowChildWidget == null
            ? SizedBox.shrink()
            : Positioned(
                left: 20.0,
                right: 20.0,
                child: Center(
                  child: Container(
                      height: overflowChildHeight ?? 150,
                      width: overflowChildWidth ?? 150,
                      child: overflowChildWidget),
                ),
              ),
      ],
    );
  }

  Widget _buildBody(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          contentHorizontalAlignment ?? CrossAxisAlignment.center,
      mainAxisAlignment: contentVerticalAlignment ?? MainAxisAlignment.start,
      children: [
        isLabelHidden
            ? SizedBox.shrink()
            : Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: topChildWidget == null
                    ? 60
                    : (topChildHeight != null ? (topChildHeight / 2) : 20) +
                        10.0,
                child: labelWidget ??
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: labelText == null
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child:
                              labelText == null ? SizedBox.shrink() : labelText,
                        ),
                        isPopUp
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                                onPressed: () => Navigator.pop(context))
                            : SizedBox.shrink(),
                      ],
                    ),
              ),
        topChildWidget != null || topChildImage != null || topChildIcon != null
            ? _buildTopChild(context)
            : SizedBox.shrink(),
        title != null
            ? Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: title),
                ],
              )
            : SizedBox.shrink(),
        bodyWidget == null
            ? subtitle != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: subtitle,
                  )
                : SizedBox.shrink()
            : bodyWidget,
        actionWidget ??
            Container(
                width: MediaQuery.of(context).size.width,
                color: actionsBgColor ?? Colors.black.withOpacity(0.2),
                margin: EdgeInsets.only(top: 10),
                padding: actionsPadding ?? EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      actionsRowAlignment ?? MainAxisAlignment.end,
                  children: actions ??
                      [
                        isActionsExpanded
                            ? Expanded(
                                child: _buildActionButton(context),
                              )
                            : _buildActionButton(context),
                      ],
                )),
      ],
    );
  }

  Widget _buildTopChild(context) {
    return !isTopChildCentered
        ? Container(
            height: topChildHeight ?? 150,
            width: topChildWidth ?? MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 10),
            padding: topChildPadding ?? EdgeInsets.zero,
            decoration:
                BoxDecoration(color: topChildBgColor ?? Colors.transparent),
            child: topChildWidget ??
                ClipRRect(
                  borderRadius:
                      topChildBorderRadius ?? BorderRadius.circular(0),
                  child: topChildImage ?? topChildIcon,
                ),
          )
        : Container(
            height: topChildHeight ?? 150,
            width: topChildWidth,
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: ClipRRect(
              borderRadius: topChildBorderRadius ?? BorderRadius.circular(0),
              child: topChildWidget ??
                  Container(
                    padding: topChildPadding ?? EdgeInsets.zero,
                    color: topChildBgColor,
                    child: topChildImage ?? topChildIcon,
                  ),
            ),
          );
  }

  Widget _buildActionButton(context) {
    return AwesomeButton(
      onPressed: onActionPressed ?? () {},
      buttonType: AwesomeButtonType.elevated,
      height: 40,
      icon: Icon(Icons.check_circle, color: Colors.white),
      label: Text(
        actionLabel ?? 'Done',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      buttonStyle: ButtonStyle(
        shape: MaterialStateProperty.resolveWith((states) =>
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
        foregroundColor: MaterialStateColor.resolveWith(
            (states) => Theme.of(context).primaryColor),
      ),
    );
  }
}
