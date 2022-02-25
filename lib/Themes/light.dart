import 'package:flutter/material.dart';
import 'package:hashpass/Themes/colors.dart';

import '../Util/util.dart';

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
        cardTheme: CardTheme(
          color: AppColors.SECONDARY_LIGHT.withOpacity(0.9),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: AppColors.ACCENT_LIGHT_2,
        ),
        shadowColor: AppColors.ACCENT_LIGHT_2,
        scaffoldBackgroundColor: Colors.grey.shade100,
        canvasColor: AppColors.SECONDARY_LIGHT,
        highlightColor: AppColors.ACCENT_LIGHT_2,
        hintColor: AppColors.SECONDARY_LIGHT,
        primaryColor: AppColors.SECONDARY_LIGHT,
        primaryColorLight: Colors.grey.shade50,
        unselectedWidgetColor: Colors.grey,
        toggleableActiveColor: AppColors.ACCENT_LIGHT,
        inputDecorationTheme: InputDecorationTheme(
          border: Util.bordaPadrao(AppColors.ACCENT_LIGHT_2),
          enabledBorder: Util.bordaPadrao(AppColors.SECONDARY_LIGHT),
          focusedBorder: Util.bordaPadrao(AppColors.ACCENT_LIGHT),
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
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppColors.ACCENT_LIGHT,
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
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.ACCENT_LIGHT,
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
            textStyle: TextStyle(fontWeight: FontWeight.normal),
            primary: AppColors.ACCENT_LIGHT_2,
            shape: StadiumBorder(),
            side: BorderSide(width: 1.0, color: AppColors.ACCENT_LIGHT_2),
          ),
        ),
        cardColor: Colors.white,
      );
}
