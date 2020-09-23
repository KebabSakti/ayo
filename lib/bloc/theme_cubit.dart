import 'package:ayo/bloc/theme_state.dart';
import 'package:ayo/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial(appThemeData[AppTheme.base]));

  void loadTheme(ThemeData themeData) {
    emit(ThemeLoading(state.themeData));
    emit(ThemeLoaded(themeData));
  }
}
