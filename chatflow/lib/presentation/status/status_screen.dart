import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/status_data.dart';
import 'package:chat_flow/presentation/status/widgets/status_list_item.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: ListView(
              padding: const .symmetric(horizontal: 16),
              children: [
                spacing(height: 8),
                _buildMyStatusWidget(),
                spacing(height: 24),
                _buildSectionHeader(trans(context, key: 'recent_updates')),
                spacing(height: 8),
                _buildStatusList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const .fromLTRB(16, 12, 8, 8),
      child: Row(
        children: [
          Text(
            trans(context, key: 'status'),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: StyleHelper.bodySmall(context)?.copyWith(
        color: _isDark ? AppColors.light60 : AppColors.greyText,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildStatusList() {
    return ListView.separated(
      itemCount: StatusData.list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const .only(top: 8, bottom: 100),
      separatorBuilder: (context, index) => spacing(height: 4),
      itemBuilder: (context, index) {
        return StatusListItem(data: StatusData.list[index]);
      },
    );
  }

  Widget _buildMyStatusWidget() {
    return GestureDetector(
      onTap: pickPhoto,
      child: Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: _isDark ? AppColors.grey100 : Colors.white,
          borderRadius: .circular(16),
          boxShadow: _isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: .circular(16),
                  ),
                  child: const Icon(
                    TablerIcons.camera_plus,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const .all(2),
                    decoration: BoxDecoration(
                      color: _isDark ? AppColors.grey100 : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const .all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        TablerIcons.plus,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            spacing(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    trans(context, key: 'my_status'),
                    style: StyleHelper.titleMedium(context)?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  spacing(height: 4),
                  Text(
                    trans(context, key: 'tap_to_add_your_status'),
                    style: StyleHelper.bodySmall(context)?.copyWith(
                      color: _isDark ? AppColors.light60 : AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              TablerIcons.chevron_right,
              color: _isDark ? AppColors.light60 : AppColors.greyText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (mounted && image != null) {
      navigateToScreen(context, ImageEditor(image: image));
    }
  }
}
