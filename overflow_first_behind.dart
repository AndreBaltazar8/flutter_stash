import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class OverflowFirstBehind extends MultiChildRenderObjectWidget {
  OverflowFirstBehind({children: const <Widget>[]}) : super(children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return new RenderOverflowFirstBehind();
  }
}

class OverflowParentData  extends ContainerBoxParentData<RenderBox> {
}

class RenderOverflowFirstBehind extends RenderBox with ContainerRenderObjectMixin<RenderBox, OverflowParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, OverflowParentData> {

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! OverflowParentData)
      child.parentData = new OverflowParentData();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    var width = 0.0;
    RenderBox child = firstChild;
    while (child != null) {
      width += child.computeMinIntrinsicWidth(height);
      child = (child.parentData as OverflowParentData).nextSibling;
    }
    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    var width = 0.0;
    RenderBox child = firstChild;
    while (child != null) {
      width += child.computeMaxIntrinsicWidth(height);
      child = (child.parentData as OverflowParentData).nextSibling;
    }
    return width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    var height = double.infinity;
    RenderBox child = firstChild;
    while (child != null) {
      height = math.min(height, child.computeMinIntrinsicHeight(height));
      child = (child.parentData as OverflowParentData).nextSibling;
    }
    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    var height = 0.0;
    RenderBox child = firstChild;
    while (child != null) {
      height = math.max(height, child.computeMinIntrinsicHeight(height));
      child = (child.parentData as OverflowParentData).nextSibling;
    }
    return height;
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  bool _hasOverflow = false;

  @override
  void performLayout() {
    _hasOverflow = false;
    if (!(constraints.maxWidth < double.infinity))
      throw new FlutterError('OverflowFirstBehind must be inside a Container.');
    RenderBox child = firstChild;
    int childCount = 0;
    double layoutHeight = 0.0;
    double widthOfChildrenExceptFirst = 0.0;
    while (child != null) {
      child.layout(new BoxConstraints(maxWidth: constraints.maxWidth, maxHeight: constraints.maxWidth), parentUsesSize: true);
      if (childCount > 0)
          widthOfChildrenExceptFirst += child.size.width;
      layoutHeight = math.max(layoutHeight, child.size.height);
      final OverflowParentData childParentData = child.parentData;
      child = childParentData.nextSibling;
      childCount++;
    }

    widthOfChildrenExceptFirst += 0.0;
    var xOffset = 0.0;
    child = firstChild;
    while (child != null) {
      bool isFirst = (child == firstChild);
      var width = isFirst ? math.min((constraints.maxWidth - widthOfChildrenExceptFirst), child.size.width) : child.size.width;
      if (width < child.size.width)
        _hasOverflow = true;
      child.layout(new BoxConstraints(maxWidth: width, maxHeight: layoutHeight, minHeight: 0.0, minWidth: constraints.minWidth).normalize(), parentUsesSize: true);
      final OverflowParentData childParentData = child.parentData;
      childParentData.offset = new Offset(xOffset, 0.0);
      xOffset += width;
      child = childParentData.nextSibling;
    }

    size = constraints.constrain(new Size(xOffset, layoutHeight));
  }

  @override
  bool hitTestChildren(HitTestResult result, { Offset position }) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_hasOverflow) {
      context.pushClipRect(needsCompositing, offset, Offset.zero & size, defaultPaint);
    }else
      defaultPaint(context, offset);
  }

  @override
  Rect describeApproximatePaintClip(RenderObject child) => null;
}