import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'core/network/api_client.dart';
import 'core/routes/app_routes.dart';
import 'features/category/bloc/category_bloc.dart';
import 'features/category/service/category_service.dart';
import 'features/home/screens/home_screen.dart';
import 'features/product/bloc/product_bloc.dart';
import 'features/product/screens/product_detail_screen.dart';
import 'features/product/screens/product_list_screen.dart';
import 'features/product/model/product_model.dart';
import 'features/product/service/product_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(http.Client());
    final categoryService = CategoryService(apiClient);
    final productService = ProductService(apiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryBloc(categoryService)..add(FetchCategories()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(productService)..add(FetchProducts()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const App();
        },
      ),
    );
  }
}

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
            return MaterialPageRoute(builder: (_) => const HomeScreen());
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
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }
}