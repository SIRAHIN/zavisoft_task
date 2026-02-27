import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavisoft_task/models/product_response/product_response.dart';
import 'package:zavisoft_task/viewmodels/cubit/product_cubit.dart';
import 'package:zavisoft_task/viewmodels/cubit/product_state.dart';

class ProductCard extends StatefulWidget {
  final String category;

  const ProductCard({Key? key, required this.category}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductListTabState();
}

class _ProductListTabState extends State<ProductCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final status = state.productMap[widget.category];

        if (status?.isLoading == true) {
          return const Center(child: CircularProgressIndicator());
        }

        if (status?.error != null) {
          return Center(child: Text(status!.error!));
        }

        if (status == null || status.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<ProductCubit>().refreshProductData(
              widget.category,
            );
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: status.products.length,
            itemBuilder: (context, index) {
              final product = status.products[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Expanded(
                      child: Container(
                        color: Colors.grey.shade100,
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),

                    // Product Details
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Price
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Rating Row
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: Colors.amber.shade600,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                product.rating.rate.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${product.rating.count})',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
