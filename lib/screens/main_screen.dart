import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';
import 'table_screen.dart';
import 'graph_screen.dart';
import 'add_terminal_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const MapScreen(),
    const TableScreen(),
    const GraphScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Peta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Tabel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Grafik',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddTerminalScreen(),
                  ),
                );
              },
              backgroundColor: AppTheme.accentColor,
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () {
                _showFilterBottomSheet(context);
              },
              backgroundColor: AppTheme.accentColor,
              child: const Icon(Icons.filter_list),
            ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Data',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Kota/Kabupaten'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Pilih Kota/Kabupaten',
                ),
                items: ['Surabaya', 'Malang', 'Sidoarjo', 'Gresik', 'Semua']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const Text('Tingkat Kepadatan'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Rendah'),
                    selected: true,
                    onSelected: (selected) {},
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.lowDensityColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.lowDensityColor,
                    side: BorderSide(color: AppTheme.lowDensityColor),
                  ),
                  FilterChip(
                    label: const Text('Sedang'),
                    selected: true,
                    onSelected: (selected) {},
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.mediumDensityColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.mediumDensityColor,
                    side: BorderSide(color: AppTheme.mediumDensityColor),
                  ),
                  FilterChip(
                    label: const Text('Tinggi'),
                    selected: true,
                    onSelected: (selected) {},
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.highDensityColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.highDensityColor,
                    side: BorderSide(color: AppTheme.highDensityColor),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Terapkan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
