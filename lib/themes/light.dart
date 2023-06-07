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
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.grey.shade400,
          circularTrackColor: AppColors.SECONDARY_LIGHT,
        ),
        cardTheme: const CardTheme(
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
        toggleableActiveColor: AppColors.ACCENT_LIGHT,
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
          bodyText1: buildTextStyle(
            Colors.grey.shade600,
            15,
            FontWeight.normal,
          ),
          bodyText2: buildTextStyle(
            Colors.grey.shade600,
            17,
            FontWeight.normal,
          ),
          button: buildTextStyle(
            Colors.grey.shade700,
            15,
            FontWeight.bold,
          ),
          headline1: buildTextStyle(
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
            primary: AppColors.SECONDARY_LIGHT,
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              color: AppColors.SECONDARY_LIGHT,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
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
          thumbColor: MaterialStateProperty.all(AppColors.SECONDARY_LIGHT),
          overlayColor: MaterialStateProperty.all(AppColors.ACCENT_LIGHT),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.SECONDARY_LIGHT,
          selectedItemColor: AppColors.PRIMARY_LIGHT,
          unselectedItemColor: Colors.grey.shade400,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.normal),
            primary: AppColors.ACCENT_LIGHT_2,
            shape: const StadiumBorder(),
            side: const BorderSide(width: 1.0, color: AppColors.ACCENT_LIGHT_2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: AppColors.ACCENT_LIGHT,
          ),
        ),
        cardColor: Colors.white,
      );
}
