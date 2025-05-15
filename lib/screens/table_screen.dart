import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import 'terminal_detail_screen.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final List<Map<String, dynamic>> _terminals = [
    {
      'name': 'Terminal Arjosari',
      'location': 'Malang',
      'type': 'Tipe A',
      'density': 'Sedang',
      'count': '5,200',
    },
    {
      'name': 'Terminal Brawijaya',
      'location': 'Banyuwangi',
      'type': 'Tipe B',
      'density': 'Sedang',
      'count': '4,300',
    },
    {
      'name': 'Terminal Joyoboyo',
      'location': 'Surabaya',
      'type': 'Tipe B',
      'density': 'Tinggi',
      'count': '7,200',
    },
    {
      'name': 'Terminal Kepuhsari',
      'location': 'Jember',
      'type': 'Tipe B',
      'density': 'Sedang',
      'count': '3,900',
    },
    {
      'name': 'Terminal Kertosono',
      'location': 'Nganjuk',
      'type': 'Tipe C',
      'density': 'Rendah',
      'count': '1,500',
    },
    {
      'name': 'Terminal Maospati',
      'location': 'Magetan',
      'type': 'Tipe C',
      'density': 'Rendah',
      'count': '1,200',
    },
    {
      'name': 'Terminal Patria',
      'location': 'Blitar',
      'type': 'Tipe B',
      'density': 'Rendah',
      'count': '2,100',
    },
    {
      'name': 'Terminal Purabaya',
      'location': 'Surabaya',
      'type': 'Tipe A',
      'density': 'Tinggi',
      'count': '8,500',
    },
    {
      'name': 'Terminal Rajekwesi',
      'location': 'Bojonegoro',
      'type': 'Tipe C',
      'density': 'Rendah',
      'count': '1,800',
    },
    {
      'name': 'Terminal Tambak Oso Wilangun',
      'location': 'Surabaya',
      'type': 'Tipe A',
      'density': 'Sedang',
      'count': '4,800',
    },
  ];

  String _sortColumn = 'name';
  bool _sortAscending = true;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Filter terminals based on search query
    final filteredTerminals = _terminals.where((terminal) {
      final name = terminal['name'].toString().toLowerCase();
      final location = terminal['location'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || location.contains(query);
    }).toList();

    // Sort terminals
    filteredTerminals.sort((a, b) {
      if (_sortAscending) {
        return a[_sortColumn].toString().compareTo(b[_sortColumn].toString());
      } else {
        return b[_sortColumn].toString().compareTo(a[_sortColumn].toString());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Terminal'),
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
            icon: const Icon(Icons.list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari terminal...',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () {
                      _showFilterDialog(context);
                    },
                    tooltip: 'Filter',
                  ),
                ),
              ],
            ),
          ),

          // Table header
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   decoration: BoxDecoration(
          //     color: isDarkMode
          //         ? AppTheme.primaryColorDark.withOpacity(0.1)
          //         : AppTheme.primaryColor.withOpacity(0.05),
          //   ),
          //   child: Row(
          //     children: [
          //       _buildTableHeader('Nama Terminal', 'name', flex: 3),
          //       _buildTableHeader('Kota/Kabupaten', 'location', flex: 2),
          //       _buildTableHeader('Jenis', 'type'),
          //       _buildTableHeader('Estimasi Penumpang', 'count', flex: 2),
          //     ],
          //   ),
          // ),

          // Table content
          Expanded(
            child: filteredTerminals.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredTerminals.length,
                    itemBuilder: (context, index) {
                      final terminal = filteredTerminals[index];
                      return _buildTerminalListItem(
                          terminal, context, isDarkMode);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalListItem(
      Map<String, dynamic> terminal, BuildContext context, bool isDarkMode) {
    Color statusColor;

    switch (terminal['density']) {
      case 'Tinggi':
        statusColor = AppTheme.highDensityColor;
        break;
      case 'Sedang':
        statusColor = AppTheme.mediumDensityColor;
        break;
      default:
        statusColor = AppTheme.lowDensityColor;
    }

    return InkWell(
      onTap: () => _navigateToTerminalDetail(terminal),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black12 : Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Terminal name and type
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_bus,
                    color: statusColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        terminal['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: isDarkMode
                                ? AppTheme.secondaryTextColorDark
                                : AppTheme.secondaryTextColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              terminal['location'],
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? AppTheme.secondaryTextColorDark
                                    : AppTheme.secondaryTextColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isDarkMode
                            ? AppTheme.primaryColorDark
                            : AppTheme.primaryColor)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    terminal['type'],
                    style: TextStyle(
                      color: isDarkMode
                          ? AppTheme.primaryColorDark
                          : AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Density and passenger count information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kepadatan:',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode
                              ? AppTheme.secondaryTextColorDark
                              : AppTheme.secondaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
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
                          terminal['density'],
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Jumlah Penumpang:',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppTheme.secondaryTextColorDark
                            : AppTheme.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      terminal['count'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.secondaryTextColorDark.withOpacity(0.5)
                : AppTheme.secondaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada terminal yang ditemukan',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.secondaryTextColorDark
                      : AppTheme.secondaryTextColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title, String column, {int flex = 1}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final isActive = _sortColumn == column;
    final primaryColor =
        isDarkMode ? AppTheme.primaryColorDark : AppTheme.primaryColor;

    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          setState(() {
            if (_sortColumn == column) {
              _sortAscending = !_sortAscending;
            } else {
              _sortColumn = column;
              _sortAscending = true;
            }
          });
        },
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? primaryColor
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isActive)
              Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppTheme.getPrimaryGradient(isDarkMode),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Filter Data',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Kota/Kabupaten',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Pilih Kota/Kabupaten',
                      filled: true,
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    dropdownColor:
                        Theme.of(context).inputDecorationTheme.fillColor,
                    items: ['Surabaya', 'Malang', 'Sidoarjo', 'Gresik', 'Semua']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tingkat Kepadatan',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildFilterChip(
                      'Rendah',
                      AppTheme.lowDensityColor,
                      true,
                    ),
                    _buildFilterChip(
                      'Sedang',
                      AppTheme.mediumDensityColor,
                      true,
                    ),
                    _buildFilterChip(
                      'Tinggi',
                      AppTheme.highDensityColor,
                      true,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
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
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Terapkan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, Color color, bool selected) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (selected) {},
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedColor: color.withOpacity(0.1),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: selected ? color : Theme.of(context).textTheme.bodyMedium?.color,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: selected ? color : Theme.of(context).dividerColor,
          width: 1.5,
        ),
      ),
      elevation: selected ? 2 : 0,
      shadowColor: selected ? color.withOpacity(0.3) : Colors.transparent,
    );
  }

  void _navigateToTerminalDetail(Map<String, dynamic> terminal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TerminalDetailScreen(
          terminalName: terminal['name'],
          location: terminal['location'],
          density: terminal['density'],
          count: terminal['count'],
        ),
      ),
    );
  }
}
