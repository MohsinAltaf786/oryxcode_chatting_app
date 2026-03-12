import 'package:chat_flow/core/bloc/language_bloc/language_bloc.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/language_data.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageWidget extends StatefulWidget {
  const LanguageWidget({super.key});

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        spacing(height: 30),
        Text(
          trans(context, key: 'language_cap'),
          style: StyleHelper.titleMedium(context)
              ?.copyWith(color: ColorHelper.titleSmallColor(context)),
        ),
        spacing(height: 10),
        Divider(
            height: 1,
            color: ColorHelper.titleSmallColor(context).withValues(alpha: 0.5)),
        spacing(height: 20),
        BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return _buildLanguagesList(LanguageData.list, state);
          },
        )
      ],
    );
  }

  Widget _buildLanguagesList(List<dynamic> list, LanguageState state) {
    return Column(
      children: [
        ListView.builder(
            itemCount: list.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              dynamic item = list[index];
              bool isSelected = state.locale?.languageCode == item['locale'];

              return GestureDetector(
                onTap: () {
                  context
                      .read<LanguageBloc>()
                      .add(ChangeLanguage(locale: Locale(item['locale'])));
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : isDarkTheme(context)
                                  ? AppColors.white.withValues(alpha: 0.1)
                                  : AppColors.grey20),
                      borderRadius: .circular(15)),
                  padding:
                      const .symmetric(horizontal: 15, vertical: 5),
                  margin: const .only(bottom: 10),
                  child: Row(
                    children: [
                      flagImage(item['flag']),
                      spacing(width: 15),
                      Text(
                        '${item['title']}',
                        style: StyleHelper.titleMedium(context),
                      ),
                      if (item['trans'] != '')
                        Text(' / ${item['trans']}',
                            style: StyleHelper.titleSmall(context)),
                      const Expanded(child: SizedBox()),
                      Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_off,
                          color: isSelected
                              ? AppColors.primary
                              : isDarkTheme(context)
                                  ? AppColors.white.withValues(alpha: 0.1)
                                  : AppColors.grey20),
                    ],
                  ),
                ),
              );
            })
      ],
    );
  }

  Widget flagImage(String flag) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
      padding: const .all(4),
      child: ImageWidget(image: flag, type: ImageType.asset, width: 35),
    );
  }
}
