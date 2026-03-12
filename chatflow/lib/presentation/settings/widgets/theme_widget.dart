import 'package:chat_flow/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/storage/local_storage.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ThemeWidget extends StatefulWidget {
  const ThemeWidget({super.key});

  @override
  State<ThemeWidget> createState() => _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget> {
  final localStorage = GetIt.I.get<LocalStorage>();

  int _selectedValue = 0;

  @override
  void initState() {
    final savedTheme = localStorage.getTheme();

    if (savedTheme == AppTheme.lightTheme.toString()) {
      _selectedValue = 0;
    } else if (savedTheme == AppTheme.darkTheme.toString()) {
      _selectedValue = 1;
    } else {
      _selectedValue = 2;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        spacing(height: 15),
        Text(
          trans(context, key: 'appearance_cap'),
          style: StyleHelper.titleMedium(context)
              ?.copyWith(color: ColorHelper.titleSmallColor(context)),
        ),
        spacing(height: 10),
        Divider(
            height: 1,
            color: ColorHelper.titleSmallColor(context).withValues(alpha: 0.5)),
        spacing(height: 20),
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Row(
              children: [
                toggleItem(
                  value: 0,
                  label: trans(context, key: 'light'),
                  asset: AssetsConst.themeLight,
                  appTheme: AppTheme.lightTheme,
                ),
                spacing(width: 15),
                toggleItem(
                  value: 1,
                  label: trans(context, key: 'dark'),
                  asset: AssetsConst.themeDark,
                  appTheme: AppTheme.darkTheme,
                ),
                spacing(width: 15),
                toggleItem(
                    value: 2,
                    label: trans(context, key: 'system'),
                    asset: AssetsConst.themeSystem,
                    systemTheme: true),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget toggleItem(
      {required int value,
      required String asset,
      required String label,
      AppTheme? appTheme,
      bool systemTheme = false}) {
    Brightness systemBrightness = MediaQuery.of(context).platformBrightness;

    // Determine system theme
    ThemeMode systemThemeMode =
        systemBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          setState(() {
            _selectedValue = value;
          });
          if (appTheme != null) {
            await localStorage.saveTheme(appTheme.toString());
            if (!mounted) return;
            context.read<ThemeBloc>().add(ThemeEvent(appTheme: appTheme));
          } else if (systemTheme) {
            await localStorage.saveTheme(AppTheme.systemTheme.toString());
            if (systemThemeMode == ThemeMode.dark) {
              if (!mounted) return;
              context
                  .read<ThemeBloc>()
                  .add(ThemeEvent(appTheme: AppTheme.darkTheme));
            } else {
              if (!mounted) return;
              context
                  .read<ThemeBloc>()
                  .add(ThemeEvent(appTheme: AppTheme.lightTheme));
            }
          }
        },
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
                decoration:
                    BoxDecoration(
                        border: Border.all(color: _selectedValue == value ? ColorHelper.titleMediumColor(context) : Colors.transparent, width: 2),
                        borderRadius: .circular(18)),
                child: Padding(
                  padding: const .all(3),
                  child: Image.asset(
                    asset,
                    width: double.infinity,
                  ),
                )),
            spacing(height: 8),
            Text(label, style: StyleHelper.titleMedium(context))
          ],
        ),
      ),
    );
  }
}
