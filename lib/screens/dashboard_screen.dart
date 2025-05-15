import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/terminal_list_item.dart';
import 'terminal_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppTheme.cardColorDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(userProvider.profileImageUrl),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat datang,',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          userProvider.username,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Terminal',
                      value: '42',
                      icon: Icons.location_on,
                      color: isDarkMode ? AppTheme.primaryColorDark : AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Kota Terpadat',
                      value: 'Surabaya',
                      icon: Icons.people,
                      color: isDarkMode ? AppTheme.accentColorDark : AppTheme.accentColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StatCard(
                title: 'Terminal Terpadat',
                value: 'Terminal Purabaya',
                subtitle: '8,500 penumpang/hari',
                icon: Icons.directions_bus,
                color: AppTheme.highDensityColor,
              ),
              
              const SizedBox(height: 24),
              
              // Recent terminals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terminal Terbaru',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Lihat Semua'),
                    style: TextButton.styleFrom(
                      foregroundColor: isDarkMode ? AppTheme.primaryColorDark : AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Terminal list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  // Sample terminal data
                  final terminals = [
                    {
                      'name': 'Terminal Purabaya',
                      'location': 'Surabaya',
                      'density': 'Tinggi',
                      'count': '8,500',
                    },
                    {
                      'name': 'Terminal Arjosari',
                      'location': 'Malang',
                      'density': 'Sedang',
                      'count': '5,200',
                    },
                    {
                      'name': 'Terminal Patria',
                      'location': 'Blitar',
                      'density': 'Rendah',
                      'count': '2,100',
                    },
                    {
                      'name': 'Terminal Brawijaya',
                      'location': 'Banyuwangi',
                      'density': 'Sedang',
                      'count': '4,300',
                    },
                    {
                      'name': 'Terminal Rajekwesi',
                      'location': 'Bojonegoro',
                      'density': 'Rendah',
                      'count': '1,800',
                    },
                  ];
                  
                  final terminal = terminals[index];
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
                  
                  return TerminalListItem(
                    name: terminal['name']!,
                    location: terminal['location']!,
                    density: terminal['density']!,
                    count: terminal['count']!,
                    statusColor: statusColor,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TerminalDetailScreen(
                            terminalName: terminal['name']!,
                            location: terminal['location']!,
                            density: terminal['density']!,
                            count: terminal['count']!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
