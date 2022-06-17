import 'package:flutter/cupertino.dart';

/// Fold delegate
/// @author jm
class FoldWrapDelegate extends FlowDelegate {
  FoldWrapDelegate({
    required this.foldLine,
    this.maxLine = 0,
    this.isFold = false,
    this.spacing = 0,
    this.runSpacing = 0,
    required this.extentHeight,
    this.line = 0,
    this.onLine,
    this.lineMaxLength = 0,
    this.foldWidgetInEnd = false,
  });
  final int foldLine;
  final int maxLine;
  final bool isFold;
  final double spacing;
  final double runSpacing;
  final double extentHeight;
  final int line;
  final ValueChanged<int>? onLine;
  final int lineMaxLength;
  final bool foldWidgetInEnd;

  @override
  void paintChildren(FlowPaintingContext context) {
    // horizontal maximum width
    var screenW = context.size.width;

    double offsetX = 0; // x坐标
    double offsetY = 0; // y坐标

    // The last child is the folding arrow
    int foldWidgetIndex = context.childCount - 1;
    int nowLine = 1;
    int lineLength = 0;
    bool hasPainFold = false;

    for (int i = 0; i < foldWidgetIndex; i++) {
      // If the current x plus the width of the child control is less than the maximum width, continue to draw, otherwise wrap
      if (offsetX + (context.getChildSize(i)?.width ?? 0) <= screenW &&
          getLineLimit(lineLength)) {
        // need to switch to FoldWidget
        if (needChangeToFoldWidget(i, offsetX, screenW, nowLine, context)) {
          if (canAddToFoldWidget(
              i, offsetX, screenW, context, foldWidgetIndex)) {
            // paint child
            context.paintChild(i,
                transform: Matrix4.translationValues(offsetX, offsetY, 0));
            // update x
            offsetX = offsetX + (context.getChildSize(i)?.width ?? 0) + spacing;
          }
          if (!hasPainFold) {
            context.paintChild(foldWidgetIndex,
                transform: Matrix4.translationValues(
                    getFoldWidgetOffsetX(
                        context.getChildSize(foldWidgetIndex)?.width ?? 0,
                        offsetX,
                        screenW),
                    offsetY,
                    0));
            // update x
            offsetX = offsetX +
                (context.getChildSize(foldWidgetIndex)?.width ?? 0) +
                spacing;
            hasPainFold = true;
          }
          break;
        } else {
          // paint child
          context.paintChild(i,
              transform: Matrix4.translationValues(offsetX, offsetY, 0));
          // update x
          offsetX = offsetX + (context.getChildSize(i)?.width ?? 0) + spacing;
          lineLength++;
        }
      } else {
        // next line
        nowLine++;
        lineLength = 0;

        // If the limit number of lines is exceeded, end the loop and no longer draw
        if ((isFold && (nowLine > foldLine))) {
          if (!hasPainFold) {
            context.paintChild(foldWidgetIndex,
                transform: Matrix4.translationValues(
                    getFoldWidgetOffsetX(
                        context.getChildSize(foldWidgetIndex)?.width ?? 0,
                        offsetX,
                        screenW),
                    offsetY,
                    0));
            // update x
            offsetX = offsetX +
                (context.getChildSize(foldWidgetIndex)?.width ?? 0) +
                spacing;
            hasPainFold = true;
          }
          break;
        } else {
          if (maxLine != 0 && nowLine > maxLine) {
            break;
          } else {
            // reset the x to 0
            offsetX = 0;
            // Calculate the value of the y after a newline
            offsetY = offsetY + extentHeight + runSpacing;
            if (needChangeToFoldWidget(i, offsetX, screenW, nowLine, context)) {
              if (canAddToFoldWidget(
                  i, offsetX, screenW, context, foldWidgetIndex)) {
                // paint child
                context.paintChild(i,
                    transform: Matrix4.translationValues(offsetX, offsetY, 0));
                // update x
                offsetX =
                    offsetX + (context.getChildSize(i)?.width ?? 0) + spacing;
              }
              if (!hasPainFold) {
                context.paintChild(foldWidgetIndex,
                    transform: Matrix4.translationValues(
                        getFoldWidgetOffsetX(
                            context.getChildSize(foldWidgetIndex)?.width ?? 0,
                            offsetX,
                            screenW),
                        offsetY,
                        0));
                // update x
                offsetX = offsetX +
                    (context.getChildSize(foldWidgetIndex)?.width ?? 0) +
                    spacing;
                hasPainFold = true;
              }
            } else {
              // paint child
              context.paintChild(i,
                  transform: Matrix4.translationValues(offsetX, offsetY, 0));
            }

            // update x
            offsetX = offsetX + (context.getChildSize(i)?.width ?? 0) + spacing;
          }
        }
      }
    }

    onLine?.call(nowLine);
  }

  bool getLineLimit(int lineLength) {
    if (lineMaxLength == 0) {
      return true;
    }
    if (lineLength >= lineMaxLength) {
      return false;
    } else {
      return true;
    }
  }

  bool needChangeToFoldWidget(int i, double offsetX, double screenW,
      int nowLine, FlowPaintingContext context) {
    if (!isFold) {
      return false;
    }
    if ((i + 1 < context.childCount - 1) &&
        ((offsetX +
                (context.getChildSize(i)?.width ?? 0) +
                spacing +
                (context.getChildSize(i + 1)?.width ?? 0)) >
            screenW)) {
      if ((isFold && ((nowLine + 1) > foldLine))) {
        return true;
      }
    }
    return false;
  }

  bool canAddToFoldWidget(int i, double offsetX, double screenW,
      FlowPaintingContext context, int lastIndex) {
    if ((offsetX +
            (context.getChildSize(i)?.width ?? 0) +
            spacing +
            (context.getChildSize(lastIndex)?.width ?? 0)) <=
        screenW) {
      return true;
    }
    return false;
  }

  double toMaxHeight(double oldMaxHeight, newMaxHeight) {
    if (oldMaxHeight > newMaxHeight) {
      return oldMaxHeight;
    } else {
      return newMaxHeight;
    }
  }

  double getFoldWidgetOffsetX(
      double foldWidgetWidth, double offsetX, double screenWidth) {
    if (!foldWidgetInEnd) {
      return offsetX;
    }
    return screenWidth - foldWidgetWidth;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    if (isFold) {
      int kLine = line;
      if (line > foldLine) {
        kLine = foldLine;
      }
      return Size(constraints.maxWidth,
          extentHeight * kLine + runSpacing * (kLine - 1));
    }
    int kLine = line;
    if (maxLine != 0 && line > maxLine) {
      kLine = maxLine;
    }
    return Size(
        constraints.maxWidth, extentHeight * kLine + runSpacing * (kLine - 1));
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints(
        maxWidth: constraints.maxWidth,
        minWidth: 0,
        maxHeight: extentHeight,
        minHeight: 0);
  }

  @override
  bool shouldRepaint(covariant FoldWrapDelegate oldDelegate) {
    if (isFold != oldDelegate.isFold) {
      return true;
    }
    if (line != oldDelegate.line) {
      return true;
    }
    return false;
  }

  @override
  bool shouldRelayout(covariant FoldWrapDelegate oldDelegate) {
    return (line != oldDelegate.line);
  }
}
