import 'package:flutter/material.dart';
import 'package:flutter_google_map_draw/dialog/popup_child.dart';

/// 弹出窗口
class PopupWindow extends PopupRoute {
  Widget child;

  PopupWindow({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  /// 显示弹窗
  static showPopupWindow(BuildContext context,
      {required Widget child,
      double? left,
      double? top,
      double? right,
      double? bottom,
      Color? color,
      bool anim = true,
      Offset? animOrigin,
      bool outsideDismissible = true,
      Function? closePopup,
      Function? closeListener}) {
    Navigator.push(
        context,
        PopupWindow(
          child: PopupChild(
              left: left,
              top: top,
              right: right,
              bottom: bottom,
              color: color,
              anim: anim,
              animOrigin: animOrigin,
              outsideDismissible: outsideDismissible,
              closePopup: closePopup,
              closeListener: closeListener,
              child: child),
        ));
  }
}
