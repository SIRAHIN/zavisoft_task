import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zavisoft_task/core/routes/route_manager.dart';
import 'package:zavisoft_task/injection.dart';
import 'package:zavisoft_task/viewmodels/cubit/product_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => getIt<ProductCubit>(),
          child: MaterialApp.router(
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.orange,
                primary: Colors.orange,
                secondary: Colors.lightBlue,
              ),
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: RouteManager.router,
          ),
        );
      },
    );
  }
}
