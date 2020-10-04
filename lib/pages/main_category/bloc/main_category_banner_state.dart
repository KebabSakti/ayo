part of 'main_category_banner_cubit.dart';

abstract class MainCategoryBannerState extends Equatable {
  final List<SlideBanner> banners;
  const MainCategoryBannerState(this.banners);
}

class MainCategoryBannerInitial extends MainCategoryBannerState {
  MainCategoryBannerInitial(List<SlideBanner> banners) : super(banners);

  @override
  List<Object> get props => [];
}

class MainCategoryBannerLoading extends MainCategoryBannerState {
  MainCategoryBannerLoading(List<SlideBanner> banners) : super(banners);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MainCategoryBannerComplete extends MainCategoryBannerState {
  final List<SlideBanner> banners;
  MainCategoryBannerComplete({@required this.banners}) : super(banners);

  @override
  // TODO: implement props
  List<Object> get props => [banners];
}

class MainCategoryBannerError extends MainCategoryBannerState {
  final String message;
  MainCategoryBannerError({this.message}) : super(List<SlideBanner>());

  @override
  // TODO: implement props
  List<Object> get props => [];
}
