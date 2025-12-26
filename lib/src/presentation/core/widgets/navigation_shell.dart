import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/app_localization.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key, required this.statefulNavigationShell});

  final StatefulNavigationShell statefulNavigationShell;

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.statefulNavigationShell.currentIndex;
    
    return Scaffold(
      body: widget.statefulNavigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          widget.statefulNavigationShell.goBranch(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            activeIcon: const Icon(Icons.home),
            label: context.locale.navigation_home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school),
            activeIcon: const Icon(Icons.school),
            label: 'Luyện tập',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calculate),
            activeIcon: const Icon(Icons.calculate),
            label: 'Giải bài',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            activeIcon: const Icon(Icons.person),
            label: context.locale.navigation_profile,
          ),
        ],
      ),
    );
  }
}
