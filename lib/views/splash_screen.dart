import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _lineController;
  late final AnimationController _fadeController;

  late final Animation<double> _logoTurns;
  late final Animation<double> _logoScale;
  late final Animation<double> _lineFactor;
  late final Animation<double> _fadeOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoTurns = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.linearToEaseOut,
      ),
    );

    _logoScale = Tween<double>(
      begin: 0.86,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    _lineFactor = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _lineController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    _fadeController.forward(from: 0);
    _logoController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 350));
    _lineController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 2300));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _lineController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeOpacity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: _logoTurns,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    'images/cube_logo.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Orders App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 22),
              ClipRect(
                child: SizeTransition(
                  sizeFactor: _lineFactor,
                  axis: Axis.horizontal,
                  axisAlignment: 0.0,
                  child: Container(
                    width: 290,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}