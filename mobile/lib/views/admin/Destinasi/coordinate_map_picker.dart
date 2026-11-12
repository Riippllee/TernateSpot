
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CoordinateMapPicker extends StatefulWidget {
  final double latitude;
  final double longitude;
  final ValueChanged<LatLng> onLocationChanged;

  const CoordinateMapPicker({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onLocationChanged,
  });

  @override
  State<CoordinateMapPicker> createState() =>
      _CoordinateMapPickerState();
}

class _CoordinateMapPickerState extends State<CoordinateMapPicker> {
  final MapController _mapController = MapController();

  late LatLng _selectedLocation;
  bool _mapReady = false;

  static const Color _primaryBlue = Color(0xFF0866FF);
  static const double _minZoom = 3;
  static const double _maxZoom = 19;

  @override
  void initState() {
    super.initState();

    _selectedLocation = LatLng(
      widget.latitude,
      widget.longitude,
    );
  }

  @override
  void didUpdateWidget(covariant CoordinateMapPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      final lokasiBaru = LatLng(
        widget.latitude,
        widget.longitude,
      );

      _selectedLocation = lokasiBaru;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_mapReady) return;

        _mapController.move(
          lokasiBaru,
          _mapController.camera.zoom,
        );
      });
    }
  }

  void _pilihLokasi(LatLng lokasi) {
    setState(() {
      _selectedLocation = lokasi;
    });

    widget.onLocationChanged(lokasi);
  }

  void _zoomIn() {
    if (!_mapReady) return;

    final zoom = (_mapController.camera.zoom + 1)
        .clamp(_minZoom, _maxZoom)
        .toDouble();

    _mapController.move(
      _mapController.camera.center,
      zoom,
    );
  }

  void _zoomOut() {
    if (!_mapReady) return;

    final zoom = (_mapController.camera.zoom - 1)
        .clamp(_minZoom, _maxZoom)
        .toDouble();

    _mapController.move(
      _mapController.camera.center,
      zoom,
    );
  }

  void _pusatkanLokasi() {
    if (!_mapReady) return;

    _mapController.move(_selectedLocation, 16);
  }

  Widget _tombolPeta({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              icon,
              color: _primaryBlue,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 260,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: 15,
                    minZoom: _minZoom,
                    maxZoom: _maxZoom,
                    onMapReady: () {
                      _mapReady = true;
                    },
                    onTap: (tapPosition, point) {
                      _pilihLokasi(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.ternatespot.app',
                    ),

                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation,
                          width: 54,
                          height: 64,
                          alignment: Alignment.bottomCenter,
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.location_on,
                                    color: _primaryBlue,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const RichAttributionWidget(
                      showFlutterMapAttribution: false,
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                        ),
                      ],
                    ),
                  ],
                ),

                // Label di bagian atas kiri.
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.place,
                          color: _primaryBlue,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Lokasi Destinasi',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF263238),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tombol kontrol di kanan.
                Positioned(
                  top: 12,
                  right: 12,
                  child: Column(
                    children: [
                      _tombolPeta(
                        icon: Icons.add,
                        tooltip: 'Perbesar peta',
                        onTap: _zoomIn,
                      ),
                      const SizedBox(height: 8),
                      _tombolPeta(
                        icon: Icons.remove,
                        tooltip: 'Perkecil peta',
                        onTap: _zoomOut,
                      ),
                      const SizedBox(height: 8),
                      _tombolPeta(
                        icon: Icons.my_location,
                        tooltip: 'Pusatkan ke pin',
                        onTap: _pusatkanLokasi,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Petunjuk pemakaian.
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.touch_app_outlined,
              color: _primaryBlue,
              size: 17,
            ),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                'Ketuk lokasi pada peta untuk menentukan titik destinasi.',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF757575),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
