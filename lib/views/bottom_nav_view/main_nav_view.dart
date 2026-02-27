import 'package:flutter/material.dart';
import 'package:zavisoft_task/views/bottom_nav_view/fragments/home_fragment/home_fragment.dart';

class MainNavView extends StatelessWidget {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeFragment(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Post'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
