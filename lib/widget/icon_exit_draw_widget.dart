import 'package:flutter/material.dart';

/// 画圈退出按鈕
class IconExitDrawWidget extends StatelessWidget {
  // 退出
  final VoidCallback onExitTap;

  // 重画
  final VoidCallback onAgainTap;

  // 是否拖动结束
  final bool isDrawEnd;

  const IconExitDrawWidget(
      {Key? key,
      required this.onExitTap,
      required this.onAgainTap,
      required this.isDrawEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: onExitTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.clear, color: Colors.black, size: 24),
                Text('退出',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onAgainTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.drive_file_rename_outline_outlined,
                    color: isDrawEnd ? Colors.black : Colors.grey, size: 24),
                Text('重畫',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDrawEnd ? Colors.black : Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
