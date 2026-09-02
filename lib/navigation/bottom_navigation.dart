import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/create/create_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/more/more_screen.dart';
import '../core/theme/app_theme.dart';

class MainNavigation extends StatefulWidget {
  final AppTheme appTheme;
  const MainNavigation({super.key, required this.appTheme});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    CreateScreen(),
    NotificationsScreen(),
    MoreScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Crear'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Avisos'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
        ],
      ),
    );
  }
}
