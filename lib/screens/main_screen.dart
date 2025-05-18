import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';
import 'table_screen.dart';
import 'graph_screen.dart';
import 'profile_screen.dart';
import 'add_terminal_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final List<Widget> screens = [
      const DashboardScreen(),
      const MapScreen(),
      const TableScreen(),
      const GraphScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Peta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_chart_outlined),
              activeIcon: Icon(Icons.table_chart),
              label: 'Tabel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Grafik',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
      // floatingActionButton: _currentIndex != 4
      //     ? Container(
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             colors: AppTheme.getAccentGradient(isDarkMode),
      //           ),
      //           borderRadius: BorderRadius.circular(16),
      //           boxShadow: [
      //             BoxShadow(
      //               color: AppTheme.accentColor.withOpacity(0.4),
      //               blurRadius: 12,
      //               offset: const Offset(0, 6),
      //             ),
      //           ],
      //         ),
      //         child: FloatingActionButton(
      //           onPressed: () {
      //             if (_currentIndex == 0) {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (context) => const AddTerminalScreen(),
      //                 ),
      //               );
      //             } else {
      //               // _showFilterBottomSheet(context);
      //             }
      //           },
      //           backgroundColor: Colors.transparent,
      //           elevation: 0,
      //           child: Icon(
      //             _currentIndex == 0 ? Icons.add : Icons.filter_list,
      //             color: Colors.white,
      //           ),
      //         ),
      //       )
      //     : null,
    );
  }

  // void _showFilterBottomSheet(BuildContext context) {
  //   final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  //   final isDarkMode = themeProvider.isDarkMode;

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return Container(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(context).viewInsets.bottom,
  //         ),
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).scaffoldBackgroundColor,
  //           borderRadius: const BorderRadius.only(
  //             topLeft: Radius.circular(24),
  //             topRight: Radius.circular(24),
  //           ),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(24.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.all(8),
  //                         decoration: BoxDecoration(
  //                           gradient: LinearGradient(
  //                             colors: AppTheme.getPrimaryGradient(isDarkMode),
  //                           ),
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         child: const Icon(
  //                           Icons.filter_list,
  //                           color: Colors.white,
  //                           size: 20,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       Text(
  //                         'Filter Data',
  //                         style: Theme.of(context).textTheme.displaySmall?.copyWith(
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                       ),
  //                     ],
  //                   ),
  //                   IconButton(
  //                     icon: Container(
  //                       padding: const EdgeInsets.all(4),
  //                       decoration: BoxDecoration(
  //                         color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
  //                         shape: BoxShape.circle,
  //                       ),
  //                       child: Icon(
  //                         Icons.close,
  //                         size: 20,
  //                         color: Theme.of(context).textTheme.bodyMedium?.color,
  //                       ),
  //                     ),
  //                     onPressed: () => Navigator.pop(context),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 24),
  //               Text(
  //                 'Kota/Kabupaten',
  //                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //               ),
  //               const SizedBox(height: 8),
  //               Container(
  //                 decoration: BoxDecoration(
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.05),
  //                       blurRadius: 10,
  //                       offset: const Offset(0, 4),
  //                     ),
  //                   ],
  //                 ),
  //                 child: DropdownButtonFormField<String>(
  //                   decoration: InputDecoration(
  //                     hintText: 'Pilih Kota/Kabupaten',
  //                     filled: true,
  //                     fillColor: Theme.of(context).inputDecorationTheme.fillColor,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: BorderSide.none,
  //                     ),
  //                     contentPadding: const EdgeInsets.symmetric(
  //                       horizontal: 16,
  //                       vertical: 16,
  //                     ),
  //                   ),
  //                   dropdownColor: Theme.of(context).inputDecorationTheme.fillColor,
  //                   items: ['Surabaya', 'Malang', 'Sidoarjo', 'Gresik', 'Semua']
  //                       .map((String value) {
  //                     return DropdownMenuItem<String>(
  //                       value: value,
  //                       child: Text(value),
  //                     );
  //                   }).toList(),
  //                   onChanged: (value) {},
  //                 ),
  //               ),
  //               const SizedBox(height: 24),
  //               Text(
  //                 'Tingkat Kepadatan',
  //                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //               ),
  //               const SizedBox(height: 12),
  //               Wrap(
  //                 spacing: 12,
  //                 runSpacing: 12,
  //                 children: [
  //                   _buildFilterChip(
  //                     'Rendah',
  //                     AppTheme.lowDensityColor,
  //                     true,
  //                   ),
  //                   _buildFilterChip(
  //                     'Sedang',
  //                     AppTheme.mediumDensityColor,
  //                     true,
  //                   ),
  //                   _buildFilterChip(
  //                     'Tinggi',
  //                     AppTheme.highDensityColor,
  //                     true,
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 32),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: OutlinedButton(
  //                       onPressed: () {},
  //                       style: OutlinedButton.styleFrom(
  //                         padding: const EdgeInsets.symmetric(vertical: 16),
  //                       ),
  //                       child: const Text('Reset'),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 16),
  //                   Expanded(
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         gradient: LinearGradient(
  //                           colors: AppTheme.getPrimaryGradient(isDarkMode),
  //                         ),
  //                         borderRadius: BorderRadius.circular(12),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: (isDarkMode ? AppTheme.primaryColorDark : AppTheme.primaryColor).withOpacity(0.3),
  //                             blurRadius: 8,
  //                             offset: const Offset(0, 4),
  //                           ),
  //                         ],
  //                       ),
  //                       child: ElevatedButton(
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.transparent,
  //                           shadowColor: Colors.transparent,
  //                           padding: const EdgeInsets.symmetric(vertical: 16),
  //                         ),
  //                         child: const Text(
  //                           'Terapkan',
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 16),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
}
