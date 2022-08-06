import 'package:flutter/material.dart';
import 'package:hashpass/Themes/colors.dart';

import '../Util/util.dart';

class DarkAppTheme {
  DarkAppTheme(this.context);

  final BuildContext context;

  static TextStyle buildTextStyle(Color cor, double tamanho, FontWeight peso) {
    return TextStyle(
      color: cor,
      fontSize: tamanho,
      fontWeight: peso,
    );
  }

  ThemeData get defaultTheme => ThemeData(
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          circularTrackColor: Colors.grey,
          color: Colors.black,
        ),
        cardTheme: const CardTheme(
          color: AppColors.SECONDARY_DARK,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.ACCENT_LIGHT,
          selectionHandleColor: Colors.grey,
        ),
        shadowColor: AppColors.SECONDARY_DARK,
        hintColor: Colors.grey,
        canvasColor: Colors.grey.shade900,
        highlightColor: AppColors.ACCENT_DARK_2,
        primaryColorLight: const Color(0xFF202029),
        inputDecorationTheme: InputDecorationTheme(
          border: Util.bordaPadrao(AppColors.ACCENT_DARK_2),
          enabledBorder: Util.bordaPadrao(AppColors.ACCENT_DARK_2),
          focusedBorder: Util.bordaPadrao(AppColors.ACCENT_LIGHT),
          isDense: false,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
          errorStyle: const TextStyle(color: Colors.redAccent),
          filled: false,
        ),
        unselectedWidgetColor: Colors.grey,
        toggleableActiveColor: AppColors.ACCENT_DARK_2,
        dialogTheme: const DialogTheme(
          backgroundColor: Color(0xFF202029),
          titleTextStyle: TextStyle(
            color: Colors.grey,
          ),
          contentTextStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF202029),
        primaryColor: AppColors.SECONDARY_DARK,
        primaryTextTheme: TextTheme(
            titleLarge: buildTextStyle(
          AppColors.PRIMARY_DARK,
          27,
          FontWeight.bold,
        )),
        textTheme: TextTheme(
          bodyText1: buildTextStyle(
            Colors.grey.shade200,
            15,
            FontWeight.normal,
          ),
          bodyText2: buildTextStyle(
            Colors.grey.shade300,
            17,
            FontWeight.normal,
          ),
          button: buildTextStyle(
            Colors.grey.shade300,
            15,
            FontWeight.bold,
          ),
          headline1: buildTextStyle(
            Colors.grey,
            12,
            FontWeight.normal,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.ACCENT_DARK,
          tertiary: Colors.grey.shade300,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppColors.SECONDARY_DARK,
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              color: AppColors.ACCENT_DARK_2,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.SECONDARY_DARK,
          titleTextStyle: buildTextStyle(
            AppColors.PRIMARY_DARK,
            15,
            FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.ACCENT_DARK,
          foregroundColor: AppColors.PRIMARY_DARK,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Colors.grey),
          overlayColor: MaterialStateProperty.all(Colors.black),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.SECONDARY_DARK,
          selectedItemColor: AppColors.PRIMARY_DARK,
          unselectedItemColor: Colors.grey.shade400,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.normal),
            primary: AppColors.ACCENT_DARK_2,
            shape: const StadiumBorder(),
            side: const BorderSide(width: 1.0, color: AppColors.ACCENT_DARK_2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.grey,
          ),
        ),
        cardColor: Colors.grey,
      );
}
