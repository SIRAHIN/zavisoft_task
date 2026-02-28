import 'package:flutter/material.dart';
import 'package:zavisoft_task/views/bottom_nav_view/fragments/account_fragment/account_view.dart';
import 'package:zavisoft_task/views/bottom_nav_view/fragments/home_fragment/home_fragment.dart';

class MainNavView extends StatelessWidget {
  MainNavView({super.key});

  ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  // navigate to account fragment
  void _navigateToAccount(int index, BuildContext context) {
    if (index != 4 && index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This feature is not available yet, go to Home or Account'),
        ),
      );
    }
    _selectedIndex.value = index;
  }

  // list of fragments
  final List<Widget> _fragments = [
    HomeFragment(),
    SizedBox.shrink(),
    SizedBox.shrink(),
    SizedBox.shrink(),
    AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedIndex,
      builder: (context, selectedIndex, child) {
        return Scaffold(
          body: _fragments[_selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              _navigateToAccount(index, context);
            },
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
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          ),
        );
      },
    );
  }
}
