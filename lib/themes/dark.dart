import 'package:flutter/material.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/util/util.dart';

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
          color: Colors.black,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.ACCENT_LIGHT,
          selectionHandleColor: Colors.grey,
        ),
        iconTheme: IconThemeData(color: Colors.grey.shade300),
        primaryIconTheme: IconThemeData(color: Colors.grey.shade300),
        shadowColor: Colors.black.withOpacity(0.35),
        hintColor: Colors.grey,
        canvasColor: Colors.grey.shade900,
        highlightColor: AppColors.ACCENT_DARK_2,
        primaryColorLight: AppColors.SECONDARY_DARK,
        inputDecorationTheme: InputDecorationTheme(
          border: Util.defaultBorder(AppColors.ACCENT_DARK_2),
          enabledBorder: Util.defaultBorder(AppColors.ACCENT_DARK_2),
          focusedBorder: Util.defaultBorder(AppColors.ACCENT_LIGHT),
          isDense: false,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
          errorStyle: const TextStyle(color: Colors.redAccent),
          filled: false,
        ),
        unselectedWidgetColor: Colors.grey,
        indicatorColor: AppColors.ACCENT_DARK_2,
        dialogTheme: const DialogTheme(
          backgroundColor: Color(0xFF202029),
          titleTextStyle: TextStyle(
            color: Colors.grey,
          ),
          contentTextStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
        scaffoldBackgroundColor: AppColors.SECONDARY_DARK,
        primaryColor: Colors.black,
        primaryTextTheme: TextTheme(
            titleLarge: buildTextStyle(
          AppColors.PRIMARY_DARK,
          27,
          FontWeight.bold,
        )),
        textTheme: TextTheme(
          bodySmall: buildTextStyle(
            Colors.grey.shade200,
            15,
            FontWeight.normal,
          ),
          bodyMedium: buildTextStyle(
            Colors.grey.shade300,
            17,
            FontWeight.normal,
          ),
          bodyLarge: buildTextStyle(
            Colors.grey.shade300,
            15,
            FontWeight.bold,
          ),
          titleLarge: buildTextStyle(
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
            backgroundColor: Colors.black,
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              color: AppColors.ACCENT_DARK_2,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.black,
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
          backgroundColor: Colors.black,
          selectedItemColor: AppColors.PRIMARY_DARK,
          unselectedItemColor: Colors.grey.shade400,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.normal),
            backgroundColor: AppColors.ACCENT_DARK_2,
            shape: const StadiumBorder(),
            side: const BorderSide(width: 1.0, color: AppColors.ACCENT_DARK_2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
        cardColor: Colors.grey,
        sliderTheme: SliderThemeData(
          trackHeight: 3,
          thumbColor: AppColors.ACCENT_DARK_2,
          overlayColor: AppColors.ACCENT_DARK_2.withOpacity(0.09),
          activeTrackColor: AppColors.ACCENT_DARK_2.withAlpha(175),
          inactiveTrackColor: AppColors.ACCENT_DARK_2.withOpacity(0.2),
        ),
      );
}
