import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  final ThemeData themeData;
  const ThemeState(this.themeData);
}

class ThemeInitial extends ThemeState {
  ThemeInitial(ThemeData themeData) : super(themeData);

  @override
  List<Object> get props => [];
}

class ThemeLoading extends ThemeState {
  ThemeLoading(ThemeData themeData) : super(themeData);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ThemeLoaded extends ThemeState {
  ThemeLoaded(ThemeData themeData) : super(themeData);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
