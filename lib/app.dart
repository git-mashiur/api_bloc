import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'features/home/screens/home_screen.dart';
import 'features/product/screens/product_list_screen.dart';
import 'features/product/screens/product_detail_screen.dart';
import 'features/product/model/product_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => HomeScreen());
          case AppRoutes.productList:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ProductListScreen(
                categoryId: args['categoryId'],
                categoryName: args['categoryName'],
              ),
            );
          case AppRoutes.productDetail:
            final product = settings.arguments as ProductModel;
            return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            );
          default:
            return MaterialPageRoute(builder: (_) => HomeScreen());
        }
      },
    );
  }
}