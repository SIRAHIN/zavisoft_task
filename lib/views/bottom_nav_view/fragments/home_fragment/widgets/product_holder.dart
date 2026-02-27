import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavisoft_task/viewmodels/cubit/product_cubit.dart';
import 'package:zavisoft_task/viewmodels/cubit/product_state.dart';
import 'package:zavisoft_task/views/bottom_nav_view/fragments/home_fragment/widgets/product_card_widget.dart';

class ProductHolder extends StatefulWidget {
  final String category;

  const ProductHolder({Key? key, required this.category}) : super(key: key);

  @override
  State<ProductHolder> createState() => _ProductHolderState();
}

class _ProductHolderState extends State<ProductHolder>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final productItem = state.productMap[widget.category];

        if (productItem?.isLoading == true) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productItem?.error != null) {
          return Center(child: Text(productItem!.error!));
        }

        if (productItem == null || productItem.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<ProductCubit>().refreshProductData(
              widget.category,
            );
          },
          child: GridView.builder(
            key: PageStorageKey<String>('grid_${widget.category}'),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: productItem.products.length,
            itemBuilder: (context, index) {
              final product = productItem.products[index];
              return ProductCardWidget(product: product);
            },
          ),
        );
      },
    );
  }
}
