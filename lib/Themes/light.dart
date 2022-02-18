import 'package:flutter/material.dart';
import 'package:hashpass/Themes/colors.dart';

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
        primaryColor: AppColors.SECONDARY_LIGHT,
        primaryTextTheme: TextTheme(
            titleLarge: buildTextStyle(
          AppColors.PRIMARY_LIGHT,
          27,
          FontWeight.bold,
        )),
        textTheme: TextTheme(
            bodyText1: buildTextStyle(
              AppColors.Black(1),
              15,
              FontWeight.normal,
            ),
            bodyText2: buildTextStyle(
              AppColors.Black(1),
              17,
              FontWeight.normal,
            ),
            button: buildTextStyle(
              AppColors.Black(1),
              15,
              FontWeight.bold,
            )),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.ACCENT_LIGHT,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppColors.ACCENT_LIGHT,
            shape: StadiumBorder(),
            textStyle: TextStyle(
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
        floatingActionButtonTheme: FloatingActionButtonThemeData(
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
      );
}
