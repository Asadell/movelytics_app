import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../models/terminal.dart';
import 'package:movelytics_app/screens/terminal_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  final LatLng _indonesiaCenter = const LatLng(-2.5, 118.0);
  double _currentZoom = 5.0;

  // List to store polygons loaded from GeoJSON
  List<Polygon> _geoJsonPolygons = [];
  bool _showPolygons = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load GeoJSON data after first frame is drawn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGeoJsonData();
    });
  }

  // Load GeoJSON data from asset file
  Future<void> _loadGeoJsonData() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // Add a small delay to ensure UI has time to build completely
      await Future.delayed(const Duration(milliseconds: 300));

      // Load the GeoJSON file from assets
      final String geoJsonString =
          await rootBundle.loadString('assets/export.geojson');
      final Map<String, dynamic> geoJson = jsonDecode(geoJsonString);

      // Process the GeoJSON data in chunks to avoid UI freezes
      await _processGeoJsonFeatures(geoJson);
    } catch (e) {
      debugPrint('Error loading GeoJSON data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Process GeoJSON features and convert to polygons
  Future<void> _processGeoJsonFeatures(Map<String, dynamic> geoJson) async {
    if (geoJson['type'] != 'FeatureCollection' ||
        !geoJson.containsKey('features')) {
      debugPrint('Invalid GeoJSON format');
      return;
    }

    final features = geoJson['features'] as List;

    // Process features in chunks
    final chunks = _chunkList<dynamic>(features, 20);
    List<Polygon> polygonsList = [];

    for (final chunk in chunks) {
      if (!mounted) return;

      List<Polygon> chunkPolygons = [];

      for (var feature in chunk) {
        final polygons = _convertFeatureToPolygons(feature);
        if (polygons.isNotEmpty) {
          chunkPolygons.addAll(polygons);
        }
      }

      polygonsList.addAll(chunkPolygons);

      // Update UI after each chunk is processed
      setState(() {
        _geoJsonPolygons = List.from(polygonsList);
      });

      // Give UI time to breathe between chunks
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  // Convert a GeoJSON feature to Flutter Map Polygon objects
  List<Polygon> _convertFeatureToPolygons(dynamic feature) {
    List<Polygon> results = [];
    final properties = feature['properties'] as Map<String, dynamic>;
    final geometry = feature['geometry'] as Map<String, dynamic>;
    final String geometryType = geometry['type'];

    // Get polygon color based on properties
    // You can customize this based on your requirements
    Color polygonColor = _getPolygonColor(properties);
    Color borderColor = polygonColor.withOpacity(0.8);

    try {
      if (geometryType == 'Polygon') {
        // Handle Polygon type
        final coordinates = geometry['coordinates'] as List;

        for (var ring in coordinates) {
          List<LatLng> points = [];
          for (var coordinate in ring) {
            // GeoJSON uses [longitude, latitude] format, but LatLng uses [latitude, longitude]
            points.add(
                LatLng(coordinate[1].toDouble(), coordinate[0].toDouble()));
          }

          if (points.isNotEmpty) {
            results.add(Polygon(
              points: points,
              color: polygonColor.withOpacity(0.3),
              borderColor: borderColor,
              borderStrokeWidth: 2,
            ));
          }
        }
      } else if (geometryType == 'MultiPolygon') {
        // Handle MultiPolygon type
        final multiCoordinates = geometry['coordinates'] as List;

        for (var polygon in multiCoordinates) {
          for (var ring in polygon) {
            List<LatLng> points = [];
            for (var coordinate in ring) {
              // GeoJSON uses [longitude, latitude] format, but LatLng uses [latitude, longitude]
              points.add(
                  LatLng(coordinate[1].toDouble(), coordinate[0].toDouble()));
            }

            if (points.isNotEmpty) {
              results.add(Polygon(
                points: points,
                color: polygonColor.withOpacity(0.3),
                borderColor: borderColor,
                borderStrokeWidth: 2,
              ));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error processing feature: $e');
    }

    return results;
  }

  // Determine polygon color based on properties
  Color _getPolygonColor(Map<String, dynamic> properties) {
    // You can customize this based on property values
    // For example, use different colors for different admin_levels or population density

    // Just an example - you should adjust this based on your GeoJSON properties
    if (properties.containsKey('population')) {
      final population = int.tryParse(properties['population'].toString()) ?? 0;
      if (population > 1000000) {
        return AppTheme.highDensityColor;
      } else if (population > 500000) {
        return AppTheme.mediumDensityColor;
      }
    }

    // Default color
    return AppTheme.lowDensityColor;
  }

  // Helper method to break a large list into smaller chunks
  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    final List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      final end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  void _toggleAllPolygons() {
    setState(() {
      _showPolygons = !_showPolygons;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return WillPopScope(
      onWillPop: () async {
        // If we're loading, prevent going back to avoid state issues
        return !_isLoading;
      },
      child: Scaffold(
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
          actions: [
            IconButton(
              onPressed: _isLoading ? null : _toggleAllPolygons,
              icon: Icon(
                _showPolygons ? Icons.layers : Icons.layers_clear,
                color: Colors.white,
              ),
              tooltip: _showPolygons
                  ? 'Sembunyikan Semua Polygon'
                  : 'Tampilkan Semua Polygon',
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDarkMode
                            ? AppTheme.primaryColorDark
                            : AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Memuat data peta...',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_geoJsonPolygons.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Telah dimuat: ${_geoJsonPolygons.length} polygon',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white54 : Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _indonesiaCenter,
                      initialZoom: _currentZoom,
                      minZoom: 5.0,
                      maxZoom: 18.0,
                      onTap: (_, __) {},
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: isDarkMode
                            ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                            : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.app',
                      ),
                      if (_showPolygons)
                        PolygonLayer(
                          polygons: _geoJsonPolygons,
                        ),
                      MarkerLayer(
                        markers: _buildMarkers(terminalList, context),
                      ),
                    ],
                  ),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
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
                                    _currentZoom =
                                        _mapController.camera.zoom + 1;
                                    _mapController.move(
                                        _mapController.camera.center,
                                        _currentZoom);
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
                                    _currentZoom =
                                        _mapController.camera.zoom - 1;
                                    _mapController.move(
                                        _mapController.camera.center,
                                        _currentZoom);
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
                              _mapController.move(_indonesiaCenter, 5.0);
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
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TerminalDetailScreen(
                          terminal: terminal,
                        ),
                      ),
                    );
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
}
