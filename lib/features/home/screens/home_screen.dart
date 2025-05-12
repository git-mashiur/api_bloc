import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../category/bloc/category_bloc.dart';
import '../../category/model/category_model.dart';
import '../../product/bloc/product_bloc.dart';
import '../../product/model/product_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Commerce App', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryLoaded) {
                print('Categories Loaded: ${state.categories.length}');
                for (var category in state.categories) {
                  if (!category.image.contains('svg') && category.image != AppConstants.defaultImage) {
                    precacheImage(NetworkImage(category.image), context);
                  }
                }
              } else if (state is CategoryError) {
                print('Category Error: ${state.message}');
              }
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductLoaded) {
                print('Products Loaded: ${state.products.length}');
                for (var product in state.products) {
                  if (product.images.isNotEmpty && !product.images.first.contains('svg')) {
                    precacheImage(NetworkImage(product.images.first), context);
                  }
                }
              } else if (state is ProductError) {
                print('Product Error: ${state.message}');
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<CategoryBloc>().add(FetchCategories());
            context.read<ProductBloc>().add(FetchProducts());
            await Future.delayed(const Duration(seconds: 1));
          },
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, categoryState) {
              return BlocBuilder<ProductBloc, ProductState>(
                builder: (context, productState) {
                  // Show a single loader if either categories or products are loading
                  if (categoryState is CategoryLoading || productState is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Show error if either fails
                  if (categoryState is CategoryError || productState is ProductError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (categoryState is CategoryError ? categoryState.message : '') +
                                (productState is ProductError ? '\n${productState.message}' : ''),
                            style: TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CategoryBloc>().add(FetchCategories());
                              context.read<ProductBloc>().add(FetchProducts());
                            },
                            child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                          ),
                        ],
                      ),
                    );
                  }

                  // Show content only if both are loaded
                  if (categoryState is CategoryLoaded && productState is ProductLoaded) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategorySection(context, categoryState.categories),
                          _buildProductCategorySection(context, 'Clothes', [1], productState.products),
                          _buildProductCategorySection(context, 'Electronics', [2], productState.products),
                          _buildProductCategorySection(context, 'Furniture', [3], productState.products),
                          _buildProductCategorySection(context, 'Shoes', [4], productState.products),
                          _buildProductCategorySection(context, 'Others', [5, 7], productState.products),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, List<CategoryModel> categories) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      color: Colors.teal[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text('Categories (${categories.length})', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: InkWell(
                    onTap: () {
                      context.read<ProductBloc>().add(FetchProductsByCategory(category.id));
                      Navigator.pushNamed(
                        context,
                        AppRoutes.productList,
                        arguments: {
                          'categoryId': category.id,
                          'categoryName': category.name,
                        },
                      );
                    },
                    child: SizedBox(
                      width: 80.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            child: ClipOval(
                              child: category.image.contains('svg')
                                  ? SvgPicture.network(
                                category.image,
                                fit: BoxFit.cover,
                                width: 56.w,
                                height: 56.h,
                                placeholderBuilder: (context) => Center(child: CircularProgressIndicator()),
                                errorBuilder: (context, error, stackTrace) => Image.network(
                                  AppConstants.defaultImage,
                                  fit: BoxFit.cover,
                                  width: 56.w,
                                  height: 56.h,
                                ),
                              )
                                  : CachedNetworkImage(
                                imageUrl: category.image,
                                fit: BoxFit.cover,
                                width: 56.w,
                                height: 56.h,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Image.network(
                                  AppConstants.defaultImage,
                                  fit: BoxFit.cover,
                                  width: 56.w,
                                  height: 56.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            category.name,
                            style: TextStyle(fontSize: 12.sp),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCategorySection(BuildContext context, String categoryName, List<int> categoryIds, List<ProductModel> products) {
    final filteredProducts = products.where((product) => categoryIds.contains(product.category.id)).toList();
    if (filteredProducts.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              '$categoryName (${filteredProducts.length})',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 0.7,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return _buildProductCard(context, product);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
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
  }
}