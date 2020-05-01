import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppColors {
    AppColors._();

    static const primary = Color(0xFFAB47BC);
    static const primaryDark = Color(0xFF790e8b);
    static const primaryVariant = Color(0xFFdf78ef);
    static const colorOnPrimary = Color(0xFFFFFFFF);
    static const colorOnPrimaryVariant = Color(0xDD000000);

    static const secondary = Color(0xFF00BCD4);
    static const secondaryLight = Color(0xFF80DEEA);
    static const secondaryDark = Color(0xFF006064);

    static const surface = Color(0xFF3C3C3C);
    static const surfaceLight = Color(0xFF4F4F4F);
    static const surfaceDark = Color(0xFF303030);
    static const responseCardBackground = Color(0xFFF2F2F2);

    static const addPhotoBackground = Color(0xFF666666);
    static const addPhotoForeground = Colors.white70;
}

class AppThemes {
    AppThemes._();

    static ThemeData get light =>
        ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.primary,
            primaryColorDark: AppColors.primaryDark,
            primaryColorLight: AppColors.primaryVariant,
            accentColor: AppColors.primary,
            canvasColor: AppColors.surface,
            cardColor: Colors.white,
            textTheme: Typography.material2018(platform: defaultTargetPlatform).white,
            iconTheme: const IconThemeData(color: Colors.white),
            disabledColor: Colors.white38,
            unselectedWidgetColor: Colors.white70,
            dialogBackgroundColor: Colors.grey[700],
            appBarTheme: AppBarTheme(
                color: AppColors.surfaceDark
            ),
            bottomAppBarColor: AppColors.surfaceDark,
        );

    static ThemeData get dark =>
        ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primaryVariant,
            primaryColorDark: AppColors.primaryDark,
            primaryColorLight: AppColors.primaryVariant,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                foregroundColor: Colors.white
            ),
            accentColor: AppColors.primaryVariant,
            cardColor: Colors.grey[700],
            appBarTheme: AppBarTheme(
                color: AppColors.surface
            ),
            bottomAppBarColor: AppColors.surface,
        );
}

extension ThemeExt on BuildContext {

    ThemeData get theme => Theme.of(this);

    Color get primaryColor {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return AppColors.primaryVariant;
        } else {
            return AppColors.primary;
        }
    }

    Color get colorOnCard {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return Colors.white;
        } else {
            return Colors.black87;
        }
    }

    Color get secondaryColorOnCard {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return Colors.white54;
        } else {
            return Colors.black38;
        }
    }
}
