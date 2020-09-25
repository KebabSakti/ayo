part of 'main_category_cubit.dart';

abstract class MainCategoryState extends Equatable {
  final List<MainCategoryModel> mainCategories;
  const MainCategoryState(this.mainCategories);
}

class MainCategoryInitial extends MainCategoryState {
  MainCategoryInitial(List<MainCategoryModel> mainCategories)
      : super(mainCategories);

  @override
  List<Object> get props => [];
}

class MainCategoryLoading extends MainCategoryState {
  MainCategoryLoading(List<MainCategoryModel> mainCategories)
      : super(mainCategories);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MainCategoryCompleted extends MainCategoryState {
  final List<MainCategoryModel> mainCategories;
  MainCategoryCompleted(this.mainCategories) : super(mainCategories);

  @override
  // TODO: implement props
  List<Object> get props => [mainCategories];
}

class MainCategoryError extends MainCategoryState {
  final String message;
  MainCategoryError({this.message}) : super([]);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
