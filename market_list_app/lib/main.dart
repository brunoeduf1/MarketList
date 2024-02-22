// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_list_app/pages/cubits/product_cubit.dart';
import 'package:market_list_app/pages/home_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => ProductCubit(),
      child: MaterialApp(
          title: 'Cubit',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: const HomePage(title: 'Shopping List'),
          debugShowCheckedModeBanner: false,   
        ),
    );
  }
}
