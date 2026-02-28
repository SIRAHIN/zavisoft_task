import 'package:flutter/material.dart';
import 'package:zavisoft_task/core/cache/auth_cache_manager.dart';
import 'package:zavisoft_task/core/routes/route_manager.dart';
import 'package:zavisoft_task/views/bottom_nav_view/fragments/account_fragment/widgets/Account_tile_Widget.dart';
import 'package:zavisoft_task/views/bottom_nav_view/fragments/account_fragment/widgets/section_header_widget.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  String? _email;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // load user data from cache
  Future<void> _loadUserData() async {
    final email = await AuthCacheManager.getUserEmail();
    if (mounted) {
      setState(() {
        _email = email;
        _isLoading = false;
      });
    }
  }

  // logout function
  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthCacheManager.signOut();
      if (context.mounted) {
        RouteManager.router.goNamed(loginViewName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // ── Profile Header ──
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.orange,
                          child: Text(
                           'SI',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Demo Name
                        const Text(
                          'Si Rahin',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email from cache
                        Text(
                          _email ?? 'No email found',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Edit Profile Button
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Colors.orange,
                          ),
                          label: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.orange),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.orange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Orders Section ──
                  SectionHeaderWidget(title: 'My Orders'),
                  AccountTileWidget(
                    icon: Icons.shopping_bag_outlined,
                    title: 'All Orders',
                    subtitle: 'Track, return or buy things again',
                    onTap: () {},
                  ),
                  AccountTileWidget(
                    icon: Icons.local_shipping_outlined,
                    title: 'Pending Delivery',
                    subtitle: 'View items on the way',
                    onTap: () {},
                  ),
                  AccountTileWidget(
                    icon: Icons.check_circle_outline,
                    title: 'Completed Orders',
                    subtitle: 'Items you have received',
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  // ── Account Section ──
                  SectionHeaderWidget(title: 'Account Settings'),
                  AccountTileWidget(
                    icon: Icons.favorite_border,
                    title: 'Wishlist',
                    subtitle: 'Your saved products',
                    onTap: () {},
                  ),
                  AccountTileWidget(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: 'Manage delivery addresses',
                    onTap: () {},
                  ),
                  AccountTileWidget(
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Cards, wallets, and more',
                    onTap: () {},
                  ),
                  AccountTileWidget(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage your alerts',
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  // ── Support Section ──
                  SectionHeaderWidget(title: 'Help & Support'),
                  AccountTileWidget(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    subtitle: 'FAQs and support articles',
                    onTap: () {},
                  ),
                  AccountTileWidget(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    onTap: () {},
                  ),
                  AccountTileWidget(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version 1.0.0',
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  // ── Logout ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.logout,
                            color: Colors.red.shade400,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.red.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () => _logout(context),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}