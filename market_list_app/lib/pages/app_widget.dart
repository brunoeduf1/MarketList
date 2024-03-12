import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_list_app/pages/cubits/product_cubit.dart';
import 'package:market_list_app/pages/home_page.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => ProductCubit(),
      child: MaterialApp(
          title: 'Cubit',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(title: 'Shopping List'),
          debugShowCheckedModeBanner: false,   
        ),
    );
  }
}