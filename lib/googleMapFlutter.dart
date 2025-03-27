import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  // Controller để quản lý bản đồ
  final Completer<GoogleMapController> _controller = Completer();

  // Vị trí mặc định ban đầu (TP. Hồ Chí Minh)
  static const LatLng _initialLocation = LatLng(10.762622, 106.660172);

  // Danh sách Marker
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarker(_initialLocation, "Vị trí của bạn");
  }

  // Hàm thêm marker
  void _addMarker(LatLng position, String title) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(title),
          position: position,
          infoWindow: InfoWindow(title: title),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Map Flutter")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _initialLocation,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers, // Hiển thị marker
        myLocationEnabled: true, // Hiển thị vị trí hiện tại của người dùng
        myLocationButtonEnabled: true, // Nút định vị GPS
        zoomControlsEnabled: false, // Ẩn nút zoom (+/-)
      ),
    );
  }
}
