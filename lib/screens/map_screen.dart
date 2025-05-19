import 'package:flutter/material.dart';
import 'package:movelytics_app/models/region_polygons.dart';
import 'package:movelytics_app/screens/terminal_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../models/terminal.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  final LatLng _indonesiaCenter = const LatLng(-2.5, 118.0);
  double _currentZoom = 5.0;

  // Use a local list for region polygons
  List<RegionPolygon> _localRegionPolygonList = [];
  bool _showPolygons = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Start loading after first frame is drawn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRegionPolygons();
    });
  }

  // Method to load polygon data
  void _loadRegionPolygons() async {
    if (!mounted) return;

    try {
      // Add a small delay to ensure UI has time to build completely
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      // Load data in chunks to avoid UI freezes with large datasets
      final chunks = _chunkList(regionPolygonList, 50);
      List<RegionPolygon> result = [];

      for (final chunk in chunks) {
        if (!mounted) return;
        result.addAll(chunk);

        // Update UI after each chunk is loaded
        setState(() {
          _localRegionPolygonList = List.from(result);
        });

        // Give UI time to breathe between chunks
        await Future.delayed(const Duration(milliseconds: 50));
      }
    } catch (e) {
      // Handle any errors loading the data
      debugPrint('Error loading region polygons: $e');
    } finally {
      // Check if still mounted before updating state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
      for (var polygon in _localRegionPolygonList) {
        polygon.isVisible = _showPolygons;
      }
    });
  }

  void _togglePolygon(int index) {
    setState(() {
      _localRegionPolygonList[index].isVisible =
          !_localRegionPolygonList[index].isVisible;
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
                    if (_localRegionPolygonList.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Telah dimuat: ${_localRegionPolygonList.length} polygon',
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
                      PolygonLayer(
                        polygons: _getVisiblePolygons(),
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

  List<Polygon> _getVisiblePolygons() {
    return _localRegionPolygonList
        .where((region) => region.isVisible)
        .map((region) => Polygon(
              points: region.points,
              color: region.color,
              borderColor: region.borderColor,
              borderStrokeWidth: 2,
            ))
        .toList();
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
