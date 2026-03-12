import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/presentation/chats/chats_screen.dart';
import 'package:chat_flow/presentation/community/community_screen.dart';
import 'package:chat_flow/presentation/settings/settings_screen.dart';
import 'package:chat_flow/presentation/status/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatsScreen(),
    const StatusScreen(),
    const CommunityScreen(),
    const SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: _navbarContainerDeco(),
        clipBehavior: Clip.hardEdge,
        child: NavigationBar(
          backgroundColor: Theme.of(context).cardColor,
          indicatorColor: AppColors.primary.withValues(alpha: 0.2),
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          destinations: [
            NavigationDestination(
                icon: const Icon(TablerIcons.message, weight: 200),
                selectedIcon: const Icon(TablerIcons.message_filled),
                label: trans(context, key: 'chats')),
            NavigationDestination(
                icon: const Icon(TablerIcons.camera),
                selectedIcon: const Icon(TablerIcons.camera_filled),
                label: trans(context, key: 'status')),
            NavigationDestination(
                icon: const Icon(TablerIcons.users_group),
                selectedIcon: const Icon(TablerIcons.users_group),
                label: trans(context, key: 'communities')),
            NavigationDestination(
                icon: const Icon(TablerIcons.settings),
                selectedIcon: const Icon(TablerIcons.settings_filled),
                label: trans(context, key: 'settings')),
          ],
        ),
      ),
    );
  }

  BoxDecoration _navbarContainerDeco() {
    return const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
          ),
        ],
        borderRadius: .only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ));
  }
}
