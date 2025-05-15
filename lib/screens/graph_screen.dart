import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final textColor = isDarkMode ? AppTheme.textColorDark : AppTheme.textColor;
    final secondaryTextColor = isDarkMode
        ? AppTheme.secondaryTextColorDark
        : AppTheme.secondaryTextColor;
    final primaryColor =
        isDarkMode ? AppTheme.primaryColorDark : AppTheme.primaryColor;
    final cardColor = isDarkMode ? AppTheme.cardColorDark : Colors.white;
    final dividerColor =
        isDarkMode ? AppTheme.dividerColorDark : AppTheme.dividerColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualisasi Data'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.getPrimaryGradient(isDarkMode),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Penduduk'),
            Tab(text: 'Terminal'),
            Tab(text: 'Penumpang'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPopulationTab(isDarkMode, textColor, secondaryTextColor,
              primaryColor, cardColor, dividerColor),
          _buildTerminalTab(isDarkMode, textColor, secondaryTextColor,
              primaryColor, cardColor, dividerColor),
          _buildPassengerTab(isDarkMode, textColor, secondaryTextColor,
              primaryColor, cardColor, dividerColor),
        ],
      ),
    );
  }

  Widget _buildPopulationTab(
      bool isDarkMode,
      Color textColor,
      Color secondaryTextColor,
      Color primaryColor,
      Color cardColor,
      Color dividerColor) {
    // Sample data for population by city/regency
    final populationData = [
      {'city': 'Surabaya', 'population': 2874699},
      {'city': 'Malang', 'population': 843810},
      {'city': 'Sidoarjo', 'population': 2117279},
      {'city': 'Gresik', 'population': 1285018},
      {'city': 'Mojokerto', 'population': 1080389},
      {'city': 'Pasuruan', 'population': 1591207},
      {'city': 'Probolinggo', 'population': 1096244},
      {'city': 'Blitar', 'population': 1116639},
      {'city': 'Kediri', 'population': 1546883},
      {'city': 'Madiun', 'population': 675586},
    ];

    // Sort data by population (descending)
    populationData.sort(
        (a, b) => (b['population'] as int).compareTo(a['population'] as int));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.bar_chart,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Jumlah Penduduk per Kota/Kabupater',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Data jumlah penduduk di Provinsi Jawa Timur berdasarkan kota/kabupaten',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: secondaryTextColor,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Chart
          Container(
            height: 420,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 3000000,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor:
                        isDarkMode ? Colors.grey[800]! : Colors.white,
                    tooltipPadding: const EdgeInsets.all(12),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${populationData[groupIndex]['city']}\n',
                        TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${_formatNumber(populationData[groupIndex]['population'] as int)} jiwa',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                    tooltipRoundedRadius: 8,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value >= populationData.length || value < 0) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            populationData[value.toInt()]['city'] as String,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String text;
                        if (value == 0) {
                          text = '0';
                        } else if (value == 1000000) {
                          text = '1M';
                        } else if (value == 2000000) {
                          text = '2M';
                        } else if (value == 3000000) {
                          text = '3M';
                        } else {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: Text(
                            text,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: populationData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final population = data['population'] as int;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: population.toDouble(),
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.withOpacity(0.6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 22,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 3000000,
                          color: dividerColor.withOpacity(0.2),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1000000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: dividerColor,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Legend
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: primaryColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Keterangan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.withOpacity(0.6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Jumlah Penduduk',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data table
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data Lengkap',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Kota/Kabupaten',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Jumlah Penduduk',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...populationData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? cardColor
                                : (isDarkMode
                                    ? Colors.grey[850]
                                    : Colors.grey[50]),
                            border: Border(
                              top: BorderSide(
                                color: dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      data['city'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: textColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _formatNumber(data['population'] as int),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalTab(
      bool isDarkMode,
      Color textColor,
      Color secondaryTextColor,
      Color primaryColor,
      Color cardColor,
      Color dividerColor) {
    // Sample data for terminals by type
    final terminalData = [
      {'type': 'Tipe A', 'count': 12},
      {'type': 'Tipe B', 'count': 18},
      {'type': 'Tipe C', 'count': 8},
      {'type': 'Tipe D', 'count': 4},
    ];

    // Sample data for terminals by density
    final densityData = [
      {'density': 'Rendah', 'count': 15, 'color': AppTheme.lowDensityColor},
      {'density': 'Sedang', 'count': 18, 'color': AppTheme.mediumDensityColor},
      {'density': 'Tinggi', 'count': 9, 'color': AppTheme.highDensityColor},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.pie_chart,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Distribusi Terminal',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Data distribusi terminal di Provinsi Jawa Timur berdasarkan tipe dan tingkat kepadatan',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: secondaryTextColor,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Terminal by Type Chart
          Container(
            height: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terminal Berdasarkan Tipe',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections:
                          _getTerminalTypeSections(terminalData, isDarkMode),
                      pieTouchData: PieTouchData(
                        touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Terminal by Density Chart
          Container(
            height: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terminal Berdasarkan Kepadatan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _getTerminalDensitySections(densityData),
                      pieTouchData: PieTouchData(
                        touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Legend
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: primaryColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Keterangan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Berdasarkan Tipe:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildLegendItem(
                        context, 'Tipe A', _getTypeColor(0, isDarkMode)),
                    _buildLegendItem(
                        context, 'Tipe B', _getTypeColor(1, isDarkMode)),
                    _buildLegendItem(
                        context, 'Tipe C', _getTypeColor(2, isDarkMode)),
                    _buildLegendItem(
                        context, 'Tipe D', _getTypeColor(3, isDarkMode)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Berdasarkan Kepadatan:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildLegendItem(
                        context, 'Rendah', AppTheme.lowDensityColor),
                    _buildLegendItem(
                        context, 'Sedang', AppTheme.mediumDensityColor),
                    _buildLegendItem(
                        context, 'Tinggi', AppTheme.highDensityColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerTab(
      bool isDarkMode,
      Color textColor,
      Color secondaryTextColor,
      Color primaryColor,
      Color cardColor,
      Color dividerColor) {
    // Sample data for passenger trends
    final passengerTrendData = [
      {'month': 'Jan', 'count': 120000},
      {'month': 'Feb', 'count': 135000},
      {'month': 'Mar', 'count': 142000},
      {'month': 'Apr', 'count': 138000},
      {'month': 'Mei', 'count': 150000},
      {'month': 'Jun', 'count': 180000},
      {'month': 'Jul', 'count': 210000},
      {'month': 'Ags', 'count': 190000},
      {'month': 'Sep', 'count': 160000},
      {'month': 'Okt', 'count': 155000},
      {'month': 'Nov', 'count': 165000},
      {'month': 'Des', 'count': 220000},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tren Jumlah Penumpang',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Data tren jumlah penumpang terminal di Provinsi Jawa Timur sepanjang tahun',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: secondaryTextColor,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Passenger Trend Chart
          Container(
            height: 380,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tren Bulanan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total penumpang di semua terminal',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 50000,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: dividerColor,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= passengerTrendData.length ||
                                  value < 0) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  passengerTrendData[value.toInt()]['month']
                                      as String,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 50000,
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 8,
                                child: Text(
                                  _formatCompactNumber(value.toInt()),
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      minX: 0,
                      maxX: passengerTrendData.length - 1.0,
                      minY: 0,
                      maxY: 250000,
                      lineBarsData: [
                        LineChartBarData(
                          spots:
                              passengerTrendData.asMap().entries.map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              (entry.value['count'] as int).toDouble(),
                            );
                          }).toList(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.8),
                              primaryColor,
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: primaryColor,
                                strokeWidth: 2,
                                strokeColor:
                                    isDarkMode ? Colors.black : Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.3),
                                primaryColor.withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor:
                              isDarkMode ? Colors.grey[800]! : Colors.white,
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final index = barSpot.x.toInt();
                              return LineTooltipItem(
                                '${passengerTrendData[index]['month']}\n',
                                TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${_formatNumber(passengerTrendData[index]['count'] as int)} penumpang',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Peak months
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bulan Terpadat',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 16),

                // Top 3 months
                Row(
                  children: [
                    Expanded(
                      child: _buildPeakMonthCard(
                        context,
                        'Des',
                        '220,000',
                        '1',
                        AppTheme.highDensityColor,
                        isDarkMode,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPeakMonthCard(
                        context,
                        'Jul',
                        '210,000',
                        '2',
                        AppTheme.mediumDensityColor,
                        isDarkMode,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPeakMonthCard(
                        context,
                        'Ags',
                        '190,000',
                        '3',
                        AppTheme.lowDensityColor,
                        isDarkMode,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeakMonthCard(BuildContext context, String month, String count,
      String rank, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              '#$rank',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            month,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getTerminalTypeSections(
      List<Map<String, dynamic>> data, bool isDarkMode) {
    final total = data.fold(0, (sum, item) => sum + (item['count'] as int));

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final percentage = (item['count'] as int) / total;

      return PieChartSectionData(
        color: _getTypeColor(index, isDarkMode),
        value: (item['count'] as int).toDouble(),
        title: '${(percentage * 100).toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _Badge(
          item['type'] as String,
          size: 40,
          borderColor: _getTypeColor(index, isDarkMode),
        ),
        badgePositionPercentageOffset: 1.1,
      );
    }).toList();
  }

  List<PieChartSectionData> _getTerminalDensitySections(
      List<Map<String, dynamic>> data) {
    final total = data.fold(0, (sum, item) => sum + (item['count'] as int));

    return data.map((item) {
      final percentage = (item['count'] as int) / total;

      return PieChartSectionData(
        color: item['color'] as Color,
        value: (item['count'] as int).toDouble(),
        title: '${(percentage * 100).toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _Badge(
          item['density'] as String,
          size: 40,
          borderColor: item['color'] as Color,
        ),
        badgePositionPercentageOffset: 1.1,
      );
    }).toList();
  }

  Color _getTypeColor(int index, bool isDarkMode) {
    final colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF8B5CF6), // Purple
    ];

    return colors[index % colors.length];
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)} juta';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)} ribu';
    }
    return number.toString();
  }

  String _formatCompactNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final double size;
  final Color borderColor;

  const _Badge(
    this.text, {
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}
