import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 自定义地图蒙层
class MaskTileOverlay implements TileProvider {
  final double width;
  final double height;

  MaskTileOverlay(this.width, this.height);

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    var paint = Paint()
      ..strokeWidth = 0
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Colors.orangeAccent.withOpacity(0.2)
      ..invertColors = false;
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, paint);
    final ui.Picture picture = recorder.endRecording();
    final Uint8List byteData = await picture
        .toImage(width.toInt(), height.toInt())
        .then((ui.Image image) =>
            image.toByteData(format: ui.ImageByteFormat.png))
        .then((ByteData? byteData) => byteData!.buffer.asUint8List());
    return Tile(width.toInt(), height.toInt(), byteData);
  }
}
