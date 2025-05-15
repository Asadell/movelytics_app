import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/terminal_list_item.dart';
import 'terminal_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang,',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Admin Dishub',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ],
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
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Kota Terpadat',
                      value: 'Surabaya',
                      icon: Icons.people,
                      color: AppTheme.accentColor,
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
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
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
