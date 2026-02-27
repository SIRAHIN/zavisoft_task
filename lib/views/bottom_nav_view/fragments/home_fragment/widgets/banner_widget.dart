// Banner Widget 
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _BannerChip(title: 'Safe Payment', icon: Icons.safety_check),
          _Divider(),
          _BannerChip(title: 'Free Delivery', icon: Icons.delivery_dining),
          _Divider(),
          _BannerChip(title: 'Easy Returns', icon: Icons.assignment_return),
        ],
      ),
    );
  }
}

class _BannerChip extends StatelessWidget {
  final String title;
  final IconData icon;
  const _BannerChip({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 6),
        Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40, width: 1, color: Colors.white38);
  }
}