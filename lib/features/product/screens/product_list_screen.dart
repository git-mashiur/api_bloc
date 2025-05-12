import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routes/app_routes.dart';
import '../../product/bloc/product_bloc.dart';
import '../../product/model/product_model.dart';

class ProductListScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const ProductListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Products', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () => context.read<ProductBloc>().add(FetchProductsByCategory(categoryId)),
                    child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            );
          } else if (state is ProductLoaded) {
            return GridView.builder(
              padding: EdgeInsets.all(8.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 0.7,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product);
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                            child: product.images.isNotEmpty
                                ? CachedNetworkImage(
                              imageUrl: product.images.first,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: Center(child: Icon(Icons.broken_image, size: 40.sp, color: Colors.grey)),
                              ),
                            )
                                : Container(
                              color: Colors.grey[200],
                              child: Center(child: Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16.sp, color: Colors.teal, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}