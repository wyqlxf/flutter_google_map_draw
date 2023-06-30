import 'package:flutter/material.dart';
import 'package:flutter_google_map_draw/dialog/popup_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 图层对话框
class DialogLayers {
  /// 显示弹窗
  static showDialog(BuildContext context, GlobalKey key, MapType mapType,
      Function(MapType) callback) {
    RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (null != renderObject && renderObject is RenderBox) {
      RenderBox renderBox = renderObject;
      // 组件坐标
      var offset = renderBox.localToGlobal(Offset.zero);
      // 组件下方坐标
      // var underOffset =
      //     renderBox.localToGlobal(Offset(0.0, renderBox.size.height));
      var coordinateY = offset.dy;
      PopupWindow.showPopupWindow(context,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.map,
                        color: (mapType == MapType.normal)
                            ? Colors.blue
                            : Colors.black,
                        size: 22,
                      ),
                      Text('標準',
                          style: TextStyle(
                              color: (mapType == MapType.normal)
                                  ? Colors.blue
                                  : Colors.black,
                              fontSize: 10))
                    ],
                  ),
                  onTap: () {
                    callback(MapType.normal);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 12),
                InkWell(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.satellite,
                        color: (mapType != MapType.normal)
                            ? Colors.blue
                            : Colors.black,
                        size: 22,
                      ),
                      Text('卫星',
                          style: TextStyle(
                              color: (mapType != MapType.normal)
                                  ? Colors.blue
                                  : Colors.black,
                              fontSize: 10))
                    ],
                  ),
                  onTap: () {
                    callback(MapType.hybrid);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          top: coordinateY,
          right: renderBox.size.width + 20,
          anim: false);
    }
  }
}
