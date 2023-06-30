import 'package:flutter/material.dart';
import 'package:flutter_google_map_draw/dialog/popup_anim.dart';

/// 弹窗视图
class PopupChild extends StatefulWidget {
  // 传入自定义弹窗视图
  final Widget child;

  // 距离左边
  final double? left;

  // 距离顶部
  final double? top;

  // 距离右边
  final double? right;

  // 距离底部
  final double? bottom;

  // 背景顏色
  final Color? color;

  // 默认true开启动画
  final bool anim;

  // 弹窗动画的起点
  final Offset? animOrigin;

  // 点击外部是否关闭弹窗，默认true关闭
  final bool outsideDismissible;

  // 把关闭弹窗监听回调
  final Function? closeListener;

  // 把关闭弹窗功能作为方法传递出去
  final Function? closePopup;

  const PopupChild(
      {Key? key,
      required this.child,
      this.left,
      this.top,
      this.right,
      this.bottom,
      this.color,
      this.anim = true,
      this.animOrigin,
      this.outsideDismissible = true,
      this.closePopup,
      this.closeListener})
      : super(key: key);

  @override
  PopupChildState createState() => PopupChildState();
}

class PopupChildState extends State<PopupChild> {
  // 动画控制器
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    if (null != widget.closePopup) {
      widget.closePopup!(_closePopup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: WillPopScope(
            child: Container(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: widget.color ?? Colors.transparent,
                    ),
                    onTap: () async {
                      if (widget.outsideDismissible) {
                        _closePopup();
                      }
                    },
                  ),
                  Positioned(
                      left: widget.left,
                      top: widget.top,
                      right: widget.right,
                      bottom: widget.bottom,
                      child: widget.anim
                          ? PopupAnim(
                              origin: widget.animOrigin,
                              controller: (c) {
                                _animationController = c;
                              },
                              child: widget.child)
                          : widget.child),
                ],
              ),
            ),
            onWillPop: () => _closePopup()));
  }

  /// 关闭弹窗
  Future<bool> _closePopup() async {
    // 在关闭弹窗之前，先执行动画原路返回的效果
    await _animationController?.reverse();
    // 关闭弹窗
    Navigator.pop(context);
    // 关闭弹窗监听
    widget.closeListener?.call();
    return true;
  }
}
