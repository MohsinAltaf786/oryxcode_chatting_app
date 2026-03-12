import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/community_data.dart';
import 'package:chat_flow/presentation/community/community_chat_screen.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Community Screen - Discover and join communities
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allCommunities = [];

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _allCommunities = CommunityData.list;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> get _myCommunities {
    return _allCommunities.where((c) => c['isJoined'] == true).toList();
  }

  List<dynamic> get _discoverCommunities {
    var communities = _allCommunities
        .where((c) => c['isJoined'] != true)
        .toList();

    if (searchQuery.isNotEmpty) {
      communities = communities
          .where(
            (c) =>
                c['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                c['description'].toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                c['category'].toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return communities;
  }

  void _toggleJoin(dynamic community) {
    setState(() {
      final index = _allCommunities.indexWhere(
        (c) => c['id'] == community['id'],
      );
      final isJoined = community['isJoined'] == true;
      _allCommunities[index]['isJoined'] = !isJoined;
      _allCommunities[index]['memberCount'] = isJoined
          ? community['memberCount'] - 1
          : community['memberCount'] + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildMyCommunities(), _buildDiscoverCommunities()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
      child: Row(
        children: [
          Text(
            trans(context, key: 'communities'),
            style: StyleHelper.headlineMedium(
              context,
            )?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              TablerIcons.plus,
              color: _isDark ? AppColors.light80 : AppColors.darkText,
            ),
            onPressed: _showCreateCommunity,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: fieldDeco(
          prefixIcon: TablerIcons.search,
          hintText: trans(context, key: 'search_communities'),
          suffix: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    TablerIcons.x,
                    color: _isDark ? AppColors.grey60 : AppColors.greyText,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      searchQuery = '';
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: _isDark ? AppColors.light60 : AppColors.greyText,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        tabs: [
          Tab(text: trans(context, key: 'my_communities')),
          Tab(text: trans(context, key: 'discover')),
        ],
      ),
    );
  }

  Widget _buildMyCommunities() {
    if (_myCommunities.isEmpty) {
      return _buildEmptyState(
        icon: TablerIcons.users_group,
        title: trans(context, key: 'no_communities_yet'),
        description: trans(
          context,
          key:
              'join_communities_to_connect_with_people_who_share_your_interests',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: _myCommunities.length,
      itemBuilder: (context, index) {
        return _buildCommunityCard(_myCommunities[index]);
      },
    );
  }

  Widget _buildDiscoverCommunities() {
    if (_discoverCommunities.isEmpty) {
      return _buildEmptyState(
        icon: TablerIcons.search_off,
        title: trans(context, key: 'no_communities_found'),
        description: searchQuery.isNotEmpty
            ? trans(context, key: 'try_a_different_search_term')
            : trans(context, key: 'all_communities_have_been_joined'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: _discoverCommunities.length,
      itemBuilder: (context, index) {
        return _buildCommunityCard(_discoverCommunities[index]);
      },
    );
  }

  Widget _buildCommunityCard(dynamic community) {
    final bool isJoined = community['isJoined'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.grey100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommunityChatScreen(community: community),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Community Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  community['avatar'],
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        TablerIcons.users_group,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    );
                  },
                ),
              ),
              spacing(width: 14),
              // Community Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            community['name'],
                            style: StyleHelper.titleMedium(context)?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isJoined)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.tealGreen.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              trans(context, key: 'joined'),
                              style: const TextStyle(
                                color: AppColors.tealGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    spacing(height: 4),
                    Text(
                      community['description'],
                      style: StyleHelper.bodySmall(context)?.copyWith(
                        color: _isDark ? AppColors.grey60 : AppColors.greyText,
                        fontSize: 13,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    spacing(height: 10),
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: TablerIcons.tag,
                          label: community['category'],
                        ),
                        spacing(width: 12),
                        Icon(
                          TablerIcons.users,
                          size: 14,
                          color: _isDark
                              ? AppColors.grey60
                              : AppColors.greyText,
                        ),
                        spacing(width: 4),
                        Text(
                          _formatMemberCount(community['memberCount']),
                          style: TextStyle(
                            fontSize: 12,
                            color: _isDark
                                ? AppColors.grey60
                                : AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              spacing(width: 10),
              // Join/Leave Button
              CustomButton(
                title: isJoined
                    ? trans(context, key: 'leave')
                    : trans(context, key: 'join'),
                color: isJoined
                    ? (_isDark ? AppColors.grey80 : AppColors.grey30)
                    : AppColors.primary,
                textColor: isJoined
                    ? (_isDark ? AppColors.light80 : AppColors.grey80)
                    : Colors.white,
                onTap: () => _toggleJoin(community),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.grey90 : AppColors.grey20,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: _isDark ? AppColors.grey60 : AppColors.greyText,
          ),
          spacing(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _isDark ? AppColors.grey60 : AppColors.greyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _isDark ? AppColors.grey90 : AppColors.grey20,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: _isDark ? AppColors.grey60 : AppColors.greyText,
              ),
            ),
            spacing(height: 20),
            Text(
              title,
              style: StyleHelper.titleLarge(
                context,
              )?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            spacing(height: 10),
            Text(
              description,
              style: StyleHelper.bodyMedium(context)?.copyWith(
                color: _isDark ? AppColors.grey60 : AppColors.greyText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatMemberCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _showCreateCommunity() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: _isDark ? AppColors.grey100 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _isDark ? AppColors.grey80 : AppColors.grey30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trans(context, key: 'create_community'),
                    style: StyleHelper.titleLarge(
                      context,
                    )?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: Icon(
                      TablerIcons.x,
                      color: _isDark ? AppColors.light60 : AppColors.greyText,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              spacing(height: 20),
              Text(
                trans(context, key: 'community_name'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _isDark ? AppColors.light80 : AppColors.darkText,
                ),
              ),
              spacing(height: 8),
              TextField(
                style: TextStyle(
                  color: _isDark ? AppColors.light80 : AppColors.darkText,
                ),
                decoration: fieldDeco(
                  hintText: trans(context, key: 'enter_community_name'),
                ),
              ),
              spacing(height: 16),
              Text(
                trans(context, key: 'description'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _isDark ? AppColors.light80 : AppColors.darkText,
                ),
              ),
              spacing(height: 8),
              TextField(
                maxLines: 3,
                decoration: fieldDeco(
                  hintText: trans(context, key: 'describe_your_community'),
                ),
              ),
              spacing(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(title: trans(context, key: 'create_community'),
                        yPadding: 13,
                        onTap: () {
                      Navigator.pop(context);
                    }),
                  ),
                ],
              ),
              spacing(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
