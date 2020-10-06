part of 'sub_category_cubit.dart';

abstract class SubCategoryState extends Equatable {
  final List<SubCategory> subCategories;
  const SubCategoryState(this.subCategories);
}

class SubCategoryInitial extends SubCategoryState {
  SubCategoryInitial(List<SubCategory> subCategories) : super(subCategories);

  @override
  List<Object> get props => [];
}

class SubCategoryLoading extends SubCategoryState {
  SubCategoryLoading(List<SubCategory> subCategories) : super(subCategories);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SubCategoryCompleted extends SubCategoryState {
  final List<SubCategory> subCategories;
  SubCategoryCompleted(this.subCategories) : super(subCategories);

  @override
  // TODO: implement props
  List<Object> get props => [subCategories];
}

class SubCategoryError extends SubCategoryState {
  final String message;
  SubCategoryError({this.message}) : super(List<SubCategory>());

  @override
  // TODO: implement props
  List<Object> get props => [];
}
