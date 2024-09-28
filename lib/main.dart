import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/constants/app_colors.dart';
import 'package:timer_app/screens/home_screen.dart';

import 'blocs/timer_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => TimerBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primary,
        appBarTheme: AppBarTheme(backgroundColor: AppColors.primary),
      ),
    );
  }
}
