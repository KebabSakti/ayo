import 'package:ayo/model/product/product.dart';
import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_terlaris_kategori_state.dart';

class ProductTerlarisKategoriCubit extends Cubit<ProductTerlarisKategoriState> {
  final Repository repository;
  ProductTerlarisKategoriCubit(this.repository)
      : super(ProductTerlarisKategoriInitial([]));

  // void fetchProductTerlarisKategori() async {
  //   emit(ProductTerlarisKategoriLoading(state.products));
  //   var products = await repository.fetchProduct();
  //   if (products is! DioError) {
  //     emit(ProductTerlarisKategoriCompleted(products));
  //   } else {
  //     emit(ProductTerlarisKategoriError());
  //   }
  // }
}
