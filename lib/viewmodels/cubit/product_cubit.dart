import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zavisoft_task/data/repository/user_repository.dart';
import 'product_state.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  final UserRepository repository;

  ProductCubit(this.repository)
    : super(ProductState(productMap: {}, categoryType: [], isLoading: false));

  Future<void> getCategory() async {
    emit(state.copyWith(isLoading: true));

    final response = await repository.getCategories();

    print("This is response $response");

    response.fold((l) => emit(state.copyWith(isLoading: false)), (r) {
      emit(state.copyWith(categoryType: r, isLoading: false));
    });
  }

  Future<void> getProducts(String cat) async {
    if (state.productMap[cat]?.products.isNotEmpty == true) return;

    emit(
      state.copyWith(
        productMap: {...state.productMap, cat: ProductStatus(isLoading: true)},
      ),
    );

    try {
      final products = await repository.getProducts(cat);

      products.fold((l) => emit(state.copyWith(isLoading: false)), (r) {
        emit(state.copyWith(productMap: {...state.productMap, cat: ProductStatus(isLoading: false, products: r)}, isLoading: false));
      });

    } catch (e) {
      emit(
        state.copyWith(
          productMap: {
            ...state.productMap,
            cat: ProductStatus(isLoading: false, error: e.toString()),
          },
        ),
      );
    }
  }

  Future<void> refreshProductData(String cat) async {
    emit(
      state.copyWith(
        productMap: {...state.productMap, cat: ProductStatus(isLoading: true)},
      ),
    );

    try {
      final products = await repository.getProducts(cat);

      products.fold((l) => emit(state.copyWith(isLoading: false)), (r) {
        emit(state.copyWith(productMap: {...state.productMap, cat: ProductStatus(isLoading: false, products: r)}, isLoading: false));
      });

    } catch (e) {
      emit(
        state.copyWith(
          productMap: {
            ...state.productMap,
            cat: ProductStatus(isLoading: false, error: e.toString()),
          },
        ),
      );
    }
  }
}
