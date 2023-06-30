import 'package:flutter/material.dart';

/// 列表按钮+画圈按钮
class IconBottomWidget extends StatelessWidget {
  final GestureTapCallback? onListTap;
  final GestureTapCallback? onDrawTap;

  const IconBottomWidget({Key? key, this.onListTap, this.onDrawTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button('列表', Icons.list, onListTap),
          Container(width: 24, height: 0.5, color: Colors.grey),
          _button('画圈', Icons.drive_file_rename_outline_outlined, onDrawTap)
        ],
      ),
    );
  }

  /// 按鈕
  _button(String text, IconData? icon, GestureTapCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black, size: 22),
            const SizedBox(height: 2),
            Text(text,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
