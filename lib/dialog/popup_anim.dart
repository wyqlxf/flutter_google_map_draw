import 'package:flutter/material.dart';

/// 弹窗动画
class PopupAnim extends StatefulWidget {
  // 视图
  final Widget child;

  // 动画的起源坐标
  final Offset? origin;

  // 定义一个方法，把控制器对象传递出去
  final Function(AnimationController) controller;

  const PopupAnim(
      {Key? key, required this.child, this.origin, required this.controller})
      : super(key: key);

  @override
  PopupAnimState createState() => PopupAnimState();
}

/// 当创建一个AnimationController时，需要传递一个vsync参数，存在vsync时会防止屏幕外动画（译者语：动画的UI不在当前屏幕时）消耗不必要的资源。
/// 通过将SingleTickerProviderStateMixin添加到类定义中，可以将stateful对象作为vsync的值
class PopupAnimState extends State<PopupAnim>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late Animation<double> _opacity;

  // AnimationController是一个特殊的Animation对象，在屏幕刷新的每一帧，就会生成一个新的值。默认情况下，AnimationController在给定的时间段内会线性的生成从0.0到1.0的数字
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    // Tween的唯一职责就是定义从输入范围到输出范围的映射
    // 默认情况下，AnimationController对象的范围从0.0到1.0。如果您需要不同的范围或不同的数据类型，则可以使用Tween来配置动画以生成不同的范围或数据类型的值
    // CurvedAnimation 将动画过程定义为一个非线性曲线
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeOut, parent: _controller));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: const Interval(0, 1.0), parent: _controller));
    // 启动动画
    _controller.forward();
    // 把控制器通过函数传递出去
    widget.controller(_controller);
  }

  @override
  Widget build(BuildContext context) {
    // 使用AnimatedWidget创建一个可重用动画的widget。要从widget中分离出动画过渡，请使用AnimatedBuilder
    // AnimatedBuilder自动监听来自Animation对象的通知
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          origin: widget.origin,
          scale: _animation.value,
          child: Opacity(
            opacity: _opacity.value,
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() async {
    // 动画完成时释放控制器，以防止内存泄漏
    _controller.dispose();
    super.dispose();
  }
}
