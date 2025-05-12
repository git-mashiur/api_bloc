import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.images.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: product.images.first,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300.h,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: Center(child: Icon(Icons.broken_image, size: 40.sp, color: Colors.grey)),
              ),
            )
                : Container(
              color: Colors.grey[200],
              height: 300.h,
              child: Center(child: Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey)),
            ),
            SizedBox(height: 16.h),
            Text(product.title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18.sp, color: Colors.teal, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text(product.description, style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 8.h),
            Text('Category: ${product.category.name}', style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}