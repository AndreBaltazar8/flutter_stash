import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class RestrictContainer extends MultiChildRenderObjectWidget {
  RestrictContainer({children: const <Widget>[]}) : super(children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return new RenderRestrictContainer();
  }
}

class RestrictContainerParentData  extends ContainerBoxParentData<RenderBox> {
}

class RenderRestrictContainer extends RenderBox with ContainerRenderObjectMixin<RenderBox, RestrictContainerParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, RestrictContainerParentData> {

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! RestrictContainerParentData)
      child.parentData = new RestrictContainerParentData();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    var width = 0.0;
    RenderBox child = firstChild;
    while (child != null) {
      width += child.computeMinIntrinsicWidth(height);
      child = (child.parentData as RestrictContainerParentData).nextSibling;
    }
    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    var width = 0.0;
    RenderBox child = firstChild;
    while (child != null) {
      width += child.computeMaxIntrinsicWidth(height);
      child = (child.parentData as RestrictContainerParentData).nextSibling;
    }
    return width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    var height = double.infinity;
    RenderBox child = firstChild;
    while (child != null) {
      height = math.min(height, child.computeMinIntrinsicHeight(height));
      child = (child.parentData as RestrictContainerParentData).nextSibling;
    }
    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    var height = 0.0;
    RenderBox child = firstChild;
    while (child != null) {
      height = math.max(height, child.computeMinIntrinsicHeight(height));
      child = (child.parentData as RestrictContainerParentData).nextSibling;
    }
    return height;
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  void performLayout() {
    if (!(constraints.maxWidth < double.infinity))
      throw new FlutterError('RestrictContainer must be have a maxWidth contraint that is not infinite.');

    double layoutHeight = 0.0;

    RenderBox child = firstChild;
    while (child != null) {
      child.layout(new BoxConstraints(maxWidth: constraints.maxWidth, maxHeight: constraints.maxWidth), parentUsesSize: true);

      layoutHeight = math.max(layoutHeight, child.size.height);

      final RestrictContainerParentData childParentData = child.parentData;
      child = childParentData.nextSibling;
    }

    var availableWidth = constraints.maxWidth;
    var xOffset = 0.0;

    child = firstChild;
    while (child != null) {
      var width = child.size.width;
      if (width > availableWidth)
        width = math.min(availableWidth, width);
      availableWidth -= width;
      child.layout(new BoxConstraints(maxWidth: width, maxHeight: layoutHeight, minHeight: 0.0, minWidth: constraints.minWidth).normalize(), parentUsesSize: true);

      final RestrictContainerParentData childParentData = child.parentData;
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
    defaultPaint(context, offset);
  }

  @override
  Rect describeApproximatePaintClip(RenderObject child) => null;
}