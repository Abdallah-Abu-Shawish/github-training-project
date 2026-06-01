import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orders_manager/views/splash_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const OrdersApp());
}

class OrdersApp extends StatelessWidget {
  const OrdersApp({super.key});

  static const double mobileWidth = 430;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orders Manager',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),

      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);

        final double width = mediaQuery.size.width < mobileWidth
            ? mediaQuery.size.width
            : mobileWidth;

        return Container(
          color: const Color(0xFFE5E7EB),
          alignment: Alignment.center,
          child: Container(
            width: width,
            height: mediaQuery.size.height,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              boxShadow: mediaQuery.size.width > mobileWidth
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ]
                  : [],
            ),
            child: MediaQuery(
              data: mediaQuery.copyWith(
                size: Size(width, mediaQuery.size.height),
              ),
              child: child ?? const SizedBox(),
            ),
          ),
        );
      },

      home: const SplashScreen(),
    );
  }
}
