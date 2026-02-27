import 'package:flutter/material.dart';
import 'package:zavisoft_task/models/product_response/product_response.dart';

class ProductCardWidget extends StatefulWidget {
  const ProductCardWidget({super.key, required this.product});

  final ProductResponse product;

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> with AutomaticKeepAliveClientMixin {
    @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  //// ======================================================================================================= \\\\
  /** NOTE : Althout Using AutomaticKeepAliveClientMixin, it is not holding the scroll position of the GridView 
   because NestedScrollView is parent of Scroller so it is not holding the scroll position of the GridView **/

  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                widget.product.image,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.product.title,
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
                  '\$${widget.product.price.toStringAsFixed(2)}',
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
                      widget.product.rating.rate.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${widget.product.rating.count})',
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
  }
}
