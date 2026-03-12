import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:flutter/material.dart';

/// Custom Bottom Sheet with smooth animations and drag to dismiss
class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showHandle = true,
    this.height,
    this.isScrollable = true,
    this.backgroundColor,
    this.actions,
  });

  final Widget child;
  final String? title;
  final bool showHandle;
  final double? height;
  final bool isScrollable;
  final Color? backgroundColor;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = height ?? screenHeight * 0.7;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: const .vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          if (showHandle)
            Center(
              child: Container(
                margin: const .only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: .circular(2),
                ),
              ),
            ),

          // Title and actions
          if (title != null || actions != null)
            Padding(
              padding: const .fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDarkTheme(context)
                              ? AppColors.light80
                              : AppColors.darkText,
                        ),
                      ),
                    ),
                  if (actions != null) ...actions!,
                ],
              ),
            ),

          // Content
          if (isScrollable)
            Flexible(
              child: SingleChildScrollView(
                padding: const .fromLTRB(20, 0, 20, 20),
                child: child,
              ),
            )
          else
            Padding(
              padding: const .fromLTRB(20, 0, 20, 20),
              child: child,
            ),
        ],
      ),
    );
  }

  /// Show the bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showHandle = true,
    double? height,
    bool isScrollable = true,
    Color? backgroundColor,
    List<Widget>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => CustomBottomSheet(
        title: title,
        showHandle: showHandle,
        height: height,
        isScrollable: isScrollable,
        backgroundColor: backgroundColor,
        actions: actions,
        child: child,
      ),
    );
  }
}

/// Action Sheet (iOS-style) Bottom Sheet
class ActionSheet extends StatelessWidget {
  const ActionSheet({
    super.key,
    required this.actions,
    this.title,
    this.message,
    this.cancelText = 'Cancel',
  });

  final List<ActionSheetItem> actions;
  final String? title;
  final String? message;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      showHandle: false,
      isScrollable: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title and message
          if (title != null || message != null)
            Padding(
              padding: const .only(bottom: 12),
              child: Column(
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkTheme(context)
                            ? AppColors.light80
                            : AppColors.darkText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (message != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      message!,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkTheme(context)
                            ? AppColors.light60
                            : AppColors.greyText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

          // Actions
          ...actions.map((action) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                action.onTap();
              },
              child: Container(
                width: double.infinity,
                padding: const .symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    if (action.icon != null) ...[
                      Icon(
                        action.icon,
                        size: 20,
                        color: action.isDestructive
                            ? AppColors.accent
                            : (isDarkTheme(context)
                                ? AppColors.light80
                                : AppColors.darkText),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      action.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: action.isDestructive ? FontWeight.w600 : FontWeight.w500,
                        color: action.isDestructive
                            ? AppColors.accent
                            : (isDarkTheme(context)
                                ? AppColors.light80
                                : AppColors.darkText),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Cancel button
          const SizedBox(height: 8),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const .symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isDarkTheme(context)
                    ? AppColors.grey80.withValues(alpha: 0.5)
                    : AppColors.grey20,
                borderRadius: .circular(12),
              ),
              child: Text(
                cancelText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkTheme(context)
                      ? AppColors.light80
                      : AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show action sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required List<ActionSheetItem> actions,
    String? title,
    String? message,
    String cancelText = 'Cancel',
  }) {
    return CustomBottomSheet.show<T>(
      context: context,
      showHandle: false,
      isScrollable: false,
      child: ActionSheet(
        actions: actions,
        title: title,
        message: message,
        cancelText: cancelText,
      ),
    );
  }
}

/// Action Sheet Item
class ActionSheetItem {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const ActionSheetItem({
    required this.title,
    this.icon,
    required this.onTap,
    this.isDestructive = false,
  });
}
