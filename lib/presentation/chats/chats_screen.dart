import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/chats/widgets/group_list.dart';
import 'package:chat_flow/presentation/chats/widgets/personal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin {
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabBar(),
            const Expanded(
              child: TabBarView(
                children: [
                  PersonalList(),
                  GroupList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const .fromLTRB(16, 12, 8, 4),
      child: Row(
        children: [
          Text(
            trans(context, key: 'chats'),
            style: StyleHelper.headlineMedium(context)?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              TablerIcons.dots_vertical,
              color: _isDark ? AppColors.light80 : AppColors.darkText,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const .symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        decoration: fieldDeco(
          prefixIcon: TablerIcons.search,
          hintText: trans(context, key: 'search_chat_or_something_here'),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: TabBar(
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: _isDark ? AppColors.light60 : AppColors.greyText,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        tabs: [
          Tab(text: trans(context, key: 'personal')),
          Tab(text: trans(context, key: 'group')),
        ],
      ),
    );
  }
}
