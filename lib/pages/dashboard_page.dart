import 'package:flutter/material.dart';
import '/pages/profile_page.dart';
import '/pages/pertemuan_page.dart';
import '/widgets/pertemuan_card.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final List<Map<String, dynamic>> pertemuanList = [
    {
      'title': 'Pertemuan 1',
      'icon': Icons.install_mobile,
      'color': const Color(0xFF3B82F6),
      'desc': 'Instalasi Flutter SDK',
    },
    {
      'title': 'Pertemuan 2',
      'icon': Icons.settings,
      'color': const Color(0xFF10B981),
      'desc': 'Setup SDK & Environment',
    },
    {
      'title': 'Pertemuan 3',
      'icon': Icons.text_fields,
      'color': const Color(0xFFF59E0B),
      'desc': 'Hello World & Layout',
    },
    {
      'title': 'Pertemuan 4',
      'icon': Icons.radio_button_checked,
      'color': const Color(0xFFEF4444),
      'desc': 'Form dengan Radio Button',
    },
    {
      'title': 'Pertemuan 5',
      'icon': Icons.list_alt,
      'color': const Color(0xFF8B5CF6),
      'desc': 'Form dengan ListView',
    },
    {
      'title': 'Pertemuan 6',
      'icon': Icons.check_box,
      'color': const Color(0xFFEC4899),
      'desc': 'Form dengan Checkbox',
    },
    {
      'title': 'Pertemuan 7',
      'icon': Icons.star,
      'color': const Color(0xFF14B8A6),
      'desc': 'Review & Latihan',
    },
    {
      'title': 'Pertemuan 8',
      'icon': Icons.assignment_turned_in,
      'color': const Color(0xFF6366F1),
      'desc': 'Ujian & Evaluasi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header dengan gradient (tanpa SliverAppBar)
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, size: 50, color: Colors.white70),
                  SizedBox(height: 10),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Mobile Programming',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Navigation Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                _buildNavItem(context, 0, 'Beranda', Icons.home),
                _buildNavItem(context, 1, 'Profile', Icons.person),
              ],
            ),
          ),
          
          // Content - Grid Card Pertemuan
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: pertemuanList.length,
                itemBuilder: (context, index) {
                  return PertemuanCard(
                    title: pertemuanList[index]['title'],
                    icon: pertemuanList[index]['icon'],
                    color: pertemuanList[index]['color'],
                    desc: pertemuanList[index]['desc'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PertemuanPage(
                            pertemuanKe: index + 1,
                            title: pertemuanList[index]['title'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String title, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: index == 0 ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: index == 0 ? Colors.blue : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: index == 0 ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}