import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_map_draw/dialog/dialog_layers.dart';
import 'package:flutter_google_map_draw/widget/icon_bottom_widget.dart';
import 'package:flutter_google_map_draw/widget/icon_exit_draw_widget.dart';
import 'package:flutter_google_map_draw/widget/icon_layers_widget.dart';
import 'package:flutter_google_map_draw/widget/icon_location_widget.dart';
import 'package:flutter_google_map_draw/widget/mask_tile_overlay.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Google地图页面
class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<StatefulWidget> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  // 是否开始画圈
  bool isDraw = false;

  // 是否画圈结束
  bool isDrawEnd = false;

  // 是否拖动结束
  bool isPanEnd = false;

  // 画圈经纬度集合
  List<LatLng> latLngList = [];
  final Set<Polyline> polyLines = {};
  final Set<Polygon> polygons = {};

  // 地图图层
  MapType mapType = MapType.normal;

  // 圖層key
  final GlobalKey layersGlobalKey = GlobalKey();

  // 标记集合
  final Map<String, Marker> markers = <String, Marker>{};

  // 地图控制器
  final Completer<GoogleMapController> mapController = Completer();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: isDraw && !isDrawEnd
                ? (DragStartDetails details) {
                    // 拖动开始
                    onPanStart(details);
                  }
                : null,
            onPanUpdate: isDraw && !isDrawEnd
                ? (DragUpdateDetails details) {
                    // 拖动进行中
                    onPanUpdate(details);
                  }
                : null,
            onPanEnd: isDraw && !isDrawEnd
                ? (DragEndDetails details) {
                    // 拖动结束
                    onPanEnd(details);
                  }
                : null,
            child: GoogleMap(
              mapType: mapType,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(22.5551997, 113.0636046),
                zoom: 10.5,
              ),
              markers: isDraw ? const <Marker>{} : markers.values.toSet(),
              onTap: (LatLng latLng) {
                // 点击地图
              },
              onCameraMoveStarted: () {
                // 移动地图开始
              },
              onCameraMove: (CameraPosition cameraPosition) {
                // 移动地图进行中
              },
              onCameraIdle: () {
                // 移动地图停止
              },
              tileOverlays: <TileOverlay>{
                if (isDraw)
                  TileOverlay(
                    tileOverlayId: const TileOverlayId('maskTileOverlay'),
                    tileProvider: MaskTileOverlay(screenWidth, screenHeight),
                  ),
              },
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomGesturesEnabled: isDraw ? false : true,
              scrollGesturesEnabled: isDraw && !isDrawEnd ? false : true,
              polylines: isDraw && !isPanEnd ? polyLines : const <Polyline>{},
              polygons: isDraw && isPanEnd ? polygons : const <Polygon>{},
            ),
          ),
          // 圖層+定位
          if (!isDraw)
            Positioned(
              top: 72,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconLayersWidget(
                    key: layersGlobalKey,
                    onTap: () {
                      // 点击图层
                      clickLayers();
                    },
                  ),
                  const SizedBox(height: 10),
                  IconLocationWidget(
                    onTap: () {
                      // 点击定位
                      clickLocation();
                    },
                  )
                ],
              ),
            ),
          // 列表+画圈
          if (!isDraw)
            Positioned(
              right: 16,
              bottom: 48,
              child: IconBottomWidget(
                onListTap: () {
                  // 点击列表
                  clickList();
                },
                onDrawTap: () {
                  // 点击画圈
                  clickDraw(true);
                },
              ),
            ),
          if (isDraw)
            Positioned(
                top: 48,
                left: 96,
                right: 96,
                child: IconExitDrawWidget(
                    isDrawEnd: isDrawEnd,
                    onExitTap: () {
                      clickDraw(false);
                    },
                    onAgainTap: () {
                      clickDraw(true);
                    }))
        ],
      ),
    );
  }

  /// 手势监听拖动开始
  onPanStart(DragStartDetails details) async {
    setState(() {
      isPanEnd = false;
      latLngList.clear();
      polyLines.clear();
      polyLines.add(Polyline(
        polylineId: const PolylineId('polylineId'),
        points: latLngList,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        consumeTapEvents: true,
        width: 10,
      ));

      polygons.clear();
      polygons.add(Polygon(
        polygonId: const PolygonId('polygonId'),
        points: latLngList,
        strokeWidth: 10,
        strokeColor: Colors.blue,
        consumeTapEvents: true,
        fillColor: Colors.blue.withOpacity(0.5),
      ));
    });
  }

  /// 手势监听拖动进行中
  onPanUpdate(DragUpdateDetails details) async {
    if (isPanEnd) {
      return;
    }
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    Offset offset = details.localPosition;
    GoogleMapController controller = await mapController.future;
    // ScreenCoordinate 要求 (x,y) 参数是实际像素的数量，所以需要将devicePixelRatio考虑在内
    LatLng latLng = await controller.getLatLng(ScreenCoordinate(
        x: (offset.dx * pixelRatio).round(),
        y: (offset.dy * pixelRatio).round()));
    setState(() {
      latLngList.add(latLng);
    });
  }

  /// 手势监听拖动结束
  onPanEnd(DragEndDetails details) async {
    setState(() {
      isPanEnd = true;
      isDrawEnd = true;
    });
  }

  /// 点击图层
  clickLayers() {
    DialogLayers.showDialog(context, layersGlobalKey, mapType, (type) {
      setState(() {
        mapType = type;
      });
    });
  }

  /// 点击定位
  clickLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 定位服务被禁用，请开启定位服务
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 权限被拒绝，允許再次请求权限，並向用戶解釋原因
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // 权限被永久拒绝，不能再次请求权限，請前往設置中開啟權限
      return;
    }
    // 确定权限被授予后，再获取位置
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    _moveLatLngWithZoom(position.latitude, position.longitude, 16);
  }

  /// 移动位置并缩放
  _moveLatLngWithZoom(double latitude, double longitude, double zoom) async {
    final GoogleMapController controller = await mapController.future;
    LatLng latLng = LatLng(latitude, longitude);
    CameraUpdate llCu = CameraUpdate.newLatLng(latLng);
    controller.moveCamera(llCu);
    CameraUpdate zoomCu = CameraUpdate.zoomTo(zoom);
    controller.animateCamera(zoomCu);
  }

  /// 点击列表
  clickList() async {}

  /// 点击画圈
  clickDraw(bool draw) {
    setState(() {
      isDraw = draw;
      isDrawEnd = false;
      latLngList.clear();
      polyLines.clear();
      polygons.clear();
    });
  }
}
