import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../models/terminal.dart';
import 'terminal_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // East Java center coordinates
  final LatLng _eastJavaCenter = const LatLng(-7.8, 112.5);
  double _currentZoom = 8.0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Terminal'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.getPrimaryGradient(isDarkMode),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _eastJavaCenter,
              initialZoom: _currentZoom,
              minZoom: 6.0,
              maxZoom: 18.0,
              onTap: (_, __) {},
            ),
            children: [
              // Base map layer
              TileLayer(
                urlTemplate: isDarkMode
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),

              // Polygon layer for East Java districts (simplified for demo)
              PolygonLayer(
                polygons: _getEastJavaPolygons(),
              ),

              // Terminal markers
              MarkerLayer(
                markers: _buildMarkers(terminalList, context),
              ),
            ],
          ),

          // Map legend
          Positioned(
            top: 16,
            right: 16,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (isDarkMode
                                    ? AppTheme.primaryColorDark
                                    : AppTheme.primaryColor)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: isDarkMode
                                ? AppTheme.primaryColorDark
                                : AppTheme.primaryColor,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Keterangan',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildLegendItem(
                      context,
                      'Kepadatan Rendah',
                      AppTheme.lowDensityColor,
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      context,
                      'Kepadatan Sedang',
                      AppTheme.mediumDensityColor,
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      context,
                      'Kepadatan Tinggi',
                      AppTheme.highDensityColor,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Map controls
          Positioned(
            bottom: 24,
            right: 24,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentZoom = _mapController.camera.zoom + 1;
                            _mapController.move(
                                _mapController.camera.center, _currentZoom);
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: isDarkMode
                              ? AppTheme.primaryColorDark
                              : AppTheme.primaryColor,
                        ),
                      ),
                      Container(
                        height: 1,
                        width: 24,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentZoom = _mapController.camera.zoom - 1;
                            _mapController.move(
                                _mapController.camera.center, _currentZoom);
                          });
                        },
                        icon: Icon(
                          Icons.remove,
                          color: isDarkMode
                              ? AppTheme.primaryColorDark
                              : AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppTheme.getPrimaryGradient(isDarkMode),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode
                                ? AppTheme.primaryColorDark
                                : AppTheme.primaryColor)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      _mapController.move(_eastJavaCenter, 8.0);
                    },
                    icon: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers(List<Terminal> terminals, BuildContext context) {
    return terminals.map((terminal) {
      Color markerColor;

      switch (terminal.density) {
        case 'Tinggi':
          markerColor = AppTheme.highDensityColor;
          break;
        case 'Sedang':
          markerColor = AppTheme.mediumDensityColor;
          break;
        default:
          markerColor = AppTheme.lowDensityColor;
      }

      return Marker(
        point: LatLng(terminal.latitude, terminal.longitude),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            _showTerminalInfo(context, terminal);
          },
          child: Container(
            decoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: markerColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.directions_bus,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showTerminalInfo(BuildContext context, Terminal terminal) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    Color statusColor;
    switch (terminal.density) {
      case 'Tinggi':
        statusColor = AppTheme.highDensityColor;
        break;
      case 'Sedang':
        statusColor = AppTheme.mediumDensityColor;
        break;
      default:
        statusColor = AppTheme.lowDensityColor;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      terminal.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      terminal.density,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    terminal.city,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? AppTheme.secondaryTextColorDark
                              : AppTheme.secondaryTextColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 14,
                    color: statusColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${terminal.estimatedPassengers > 0 ? terminal.estimatedPassengers : "N/A"} penumpang/hari',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppTheme.getPrimaryGradient(isDarkMode),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: (isDarkMode
                              ? AppTheme.primaryColorDark
                              : AppTheme.primaryColor)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pop(context); // Close dialog
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => TerminalDetailScreen(
                    //       terminalName: terminal.name,
                    //       location: terminal.city,
                    //       density: terminal.density,
                    //       count: terminal.estimatedPassengers.toString(),
                    //     ),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Polygon> _getEastJavaPolygons() {
    // Simplified polygons for East Java districts
    // In a real app, you would load these from GeoJSON data
    return [
      // Surabaya (simplified)
      Polygon(
        points: const [
          LatLng(-7.2, 112.6),
          LatLng(-7.2, 112.8),
          LatLng(-7.4, 112.8),
          LatLng(-7.4, 112.6),
        ],
        color: Colors.blue.withOpacity(0.2),
        borderColor: Colors.blue.withOpacity(0.7),
        borderStrokeWidth: 2,
      ),
      // Malang (simplified)
      Polygon(
        points: const [
          LatLng(-7.9, 112.5),
          LatLng(-7.9, 112.7),
          LatLng(-8.1, 112.7),
          LatLng(-8.1, 112.5),
        ],
        color: Colors.green.withOpacity(0.2),
        borderColor: Colors.green.withOpacity(0.7),
        borderStrokeWidth: 2,
      ),
      // Kediri (simplified)
      Polygon(
        points: const [
          LatLng(-7.7, 111.9),
          LatLng(-7.7, 112.1),
          LatLng(-7.9, 112.1),
          LatLng(-7.9, 111.9),
        ],
        color: Colors.orange.withOpacity(0.2),
        borderColor: Colors.orange.withOpacity(0.7),
        borderStrokeWidth: 2,
      ),
    ];
  }
}
