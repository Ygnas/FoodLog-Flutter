import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyNavigation extends StatelessWidget {
  const MyNavigation({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 1,
      currentIndex: selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum_rounded),
          label: 'Community',
        )
      ],
      onTap: (index) {
        if (index == 0) {
          context.go('/');
        }
        if (index == 1) {
          context.push('/addlisting');
        }
        if (index == 2) {
          context.push('/map');
        }
        if (index == 3) {
          context.push('/community');
        }
      },
    );
  }
}
