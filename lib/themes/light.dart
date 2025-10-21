import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/util/util.dart';

class LightAppTheme {
  LightAppTheme(this.context);

  final BuildContext context;

  static TextStyle buildTextStyle(Color cor, double tamanho, FontWeight peso) {
    return TextStyle(
      color: cor,
      fontSize: tamanho,
      fontWeight: peso,
    );
  }

  ThemeData get defaultTheme => ThemeData(
        dialogBackgroundColor: Colors.white,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.grey.shade400,
          circularTrackColor: AppColors.SECONDARY_LIGHT,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: AppColors.SECONDARY_LIGHT.withOpacity(0.9),
          cursorColor: AppColors.SECONDARY_LIGHT.withOpacity(0.9),
        ),
        shadowColor: Colors.grey.shade300,
        scaffoldBackgroundColor: Colors.grey.shade100,
        canvasColor: AppColors.PRIMARY_LIGHT,
        highlightColor: AppColors.ACCENT_LIGHT_2,
        hintColor: AppColors.SECONDARY_LIGHT,
        primaryColor: AppColors.SECONDARY_LIGHT,
        primaryColorLight: Colors.grey.shade50,
        unselectedWidgetColor: Colors.grey,
        indicatorColor: AppColors.ACCENT_LIGHT,
        inputDecorationTheme: InputDecorationTheme(
          border: Util.defaultBorder(AppColors.ACCENT_LIGHT_2),
          enabledBorder: Util.defaultBorder(AppColors.SECONDARY_LIGHT),
          focusedBorder: Util.defaultBorder(AppColors.ACCENT_LIGHT),
          isDense: false,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 17),
          errorStyle: const TextStyle(color: Colors.redAccent),
          filled: false,
        ),
        primaryTextTheme: TextTheme(
            titleLarge: buildTextStyle(
          AppColors.PRIMARY_LIGHT,
          27,
          FontWeight.bold,
        )),
        textTheme: TextTheme(
          bodySmall: buildTextStyle(
            Colors.grey.shade600,
            15,
            FontWeight.normal,
          ),
          bodyMedium: buildTextStyle(
            Colors.grey.shade600,
            17,
            FontWeight.normal,
          ),
          bodyLarge: buildTextStyle(
            Colors.grey.shade700,
            15,
            FontWeight.bold,
          ),
          titleLarge: buildTextStyle(
            Colors.grey.shade600,
            12,
            FontWeight.normal,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.ACCENT_LIGHT,
          tertiary: Colors.grey.shade700,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.SECONDARY_LIGHT,
            shape: const StadiumBorder(),
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(
            color: AppColors.PRIMARY_LIGHT,
          ),
          color: AppColors.SECONDARY_LIGHT,
          titleTextStyle: buildTextStyle(
            AppColors.PRIMARY_LIGHT,
            15,
            FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.SECONDARY_LIGHT),
        primaryIconTheme: const IconThemeData(color: AppColors.SECONDARY_LIGHT),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.SECONDARY_LIGHT,
          foregroundColor: AppColors.PRIMARY_LIGHT,
        ),
        switchTheme: SwitchThemeData(
          trackOutlineColor: WidgetStateProperty.all(AppColors.SECONDARY_LIGHT),
          trackColor: WidgetStateProperty.all(Colors.transparent),
          thumbColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.ACCENT_LIGHT;
              }
              return Colors.grey;
            },
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.SECONDARY_LIGHT,
          selectedItemColor: AppColors.PRIMARY_LIGHT,
          unselectedItemColor: Colors.grey.shade400,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.normal),
            backgroundColor: AppColors.ACCENT_LIGHT_2,
            shape: const StadiumBorder(),
            side: const BorderSide(width: 1.0, color: AppColors.ACCENT_LIGHT_2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.ACCENT_LIGHT,
            backgroundColor: Colors.transparent,
          ),
        ),
        cardColor: Colors.white,
        sliderTheme: SliderThemeData(
          trackHeight: 3,
          thumbColor: AppColors.SECONDARY_LIGHT,
          overlayColor: AppColors.ACCENT_LIGHT.withOpacity(0.15),
          activeTrackColor: AppColors.SECONDARY_LIGHT.withAlpha(175),
          inactiveTrackColor: AppColors.SECONDARY_LIGHT.withOpacity(0.35),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.ACCENT_LIGHT;
              }
              return Colors.grey;
            },
          ),
          visualDensity: VisualDensity.compact,
        ),
      );
}
