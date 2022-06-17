library fold_wrap;

import 'package:flutter/material.dart';

import 'fold_wrap_delegate.dart';

/// Collapsible Word Wrap Widget
/// @author jm
class FoldWrap extends StatefulWidget {
  const FoldWrap({
    Key? key,
    required this.children,
    this.foldWidget,
    this.foldLine = 0,
    this.maxLine = 0,
    this.isFold = false,
    this.spacing = 0,
    this.runSpacing = 0,
    this.lineMaxLength = 0,
    required this.extentHeight,
    this.onCallLineNum,
    this.foldWidgetInEnd = false,
  }) : super(key: key);

  /// List of Items
  final List<Widget> children;

  /// collapse expand widget
  final Widget? foldWidget;

  /// which line will be collapsed when [isFold] is true
  final int foldLine;

  /// maximum number of lines.
  /// when [maxLine] != 0, [maxLine] > [foldLine].
  /// when [maxLine] = 0, Unlimited maximum number of lines
  final int maxLine;

  /// Is it folded
  final bool isFold;

  /// The spacing between Items in the horizontal direction
  final double spacing;

  /// The spacing between Items in the vertical direction
  final double runSpacing;

  /// Maximum number of Items per row. 0 is no limit.
  final int lineMaxLength;

  /// item height.
  final double extentHeight;

  /// return the final line count
  final Function? onCallLineNum;

  /// Whether foldWidget is to be at the end of the line
  final bool foldWidgetInEnd;

  @override
  _FoldWrapState createState() => _FoldWrapState();
}

class _FoldWrapState extends State<FoldWrap> {
  int line = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      children: _getChildren(),
      delegate: FoldWrapDelegate(
          foldLine: widget.foldLine,
          extentHeight: widget.extentHeight,
          maxLine: widget.maxLine,
          isFold: widget.isFold,
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          line: line,
          lineMaxLength: widget.lineMaxLength,
          foldWidgetInEnd: widget.foldWidgetInEnd,
          onLine: (int i) {
            // For adaptive height, dynamic calculation and update
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              widget.onCallLineNum?.call(i);
              setState(() {
                line = i;
              });
            });
          }),
    );
  }

  List<Widget> _getChildren() {
    List<Widget> children = [];
    children.addAll(widget.children);
    // add the foldWidget to the end
    if (widget.foldWidget != null) {
      children.add(widget.foldWidget!);
    } else {
      children.add(Container());
    }

    return children;
  }
}
