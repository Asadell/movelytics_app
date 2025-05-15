import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final List<Map<String, dynamic>> _terminals = [
    {
      'name': 'Terminal Purabaya',
      'location': 'Surabaya',
      'type': 'Tipe A',
      'density': 'Tinggi',
      'count': '8,500',
    },
    {
      'name': 'Terminal Arjosari',
      'location': 'Malang',
      'type': 'Tipe A',
      'density': 'Sedang',
      'count': '5,200',
    },
    {
      'name': 'Terminal Patria',
      'location': 'Blitar',
      'type': 'Tipe B',
      'density': 'Rendah',
      'count': '2,100',
    },
    {
      'name': 'Terminal Brawijaya',
      'location': 'Banyuwangi',
      'type': 'Tipe B',
      'density': 'Sedang',
      'count': '4,300',
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
  ];

  String _sortColumn = 'name';
  bool _sortAscending = true;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari terminal...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                _buildTableHeader('Nama Terminal', 'name', flex: 3),
                _buildTableHeader('Kota/Kabupaten', 'location', flex: 2),
                _buildTableHeader('Jenis', 'type'),
                _buildTableHeader('Estimasi Penumpang', 'count', flex: 2),
              ],
            ),
          ),
          
          // Table content
          Expanded(
            child: ListView.builder(
              itemCount: filteredTerminals.length,
              itemBuilder: (context, index) {
                final terminal = filteredTerminals[index];
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
                
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.directions_bus,
                                  color: statusColor,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  terminal['name'],
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            terminal['location'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            terminal['type'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  terminal['density'],
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${terminal['count']}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title, String column, {int flex = 1}) {
    final isActive = _sortColumn == column;
    
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
                  color: isActive ? AppTheme.primaryColor : AppTheme.textColor,
                ),
              ),
            ),
            if (isActive)
              Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: AppTheme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
