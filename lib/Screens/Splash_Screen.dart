import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash_Screen extends StatefulWidget {
  static const String id = 'Splash_Screen';
  final String initialRoute;

  const Splash_Screen({Key? key, required this.initialRoute}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash_Screen> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    ));

    _controller?.forward();

    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, widget.initialRoute);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: null,
        backgroundColor: Color(0XFF57419D),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _fadeAnimation!,
                      builder: (context, child) {
                        return Positioned(
                          bottom: 100,
                          right: -18,
                          width: 170,
                          height: 150,
                          child: Transform.rotate(
                            angle: 12,
                            child: Opacity(
                              opacity: _fadeAnimation!.value,
                              child: Image.asset(
                                'images/1200px-Paw-print.svg.png',
                                color: Color(0XFF7A67B1),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _fadeAnimation!,
                      builder: (context, child) {
                        return Positioned(
                          bottom: -10,
                          left: -35,
                          width: 140,
                          height: 170,
                          child: Transform.rotate(
                            angle: -18,
                            child: Opacity(
                              opacity: _fadeAnimation!.value,
                              child: Image.asset(
                                'images/1200px-Paw-print.svg.png',
                                color: Color(0XFF7A67B1),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _fadeAnimation!,
                      builder: (context, child) {
                        return Positioned(
                          top: -10,
                          left: 100,
                          width: 170,
                          height: 180,
                          child: Transform.rotate(
                            angle: -3,
                            child: Opacity(
                              opacity: _fadeAnimation!.value,
                              child: Image.asset(
                                'images/1200px-Paw-print.svg.png',
                                color: Color(0XFF7A67B1),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Center(
                      child: SlideTransition(
                        position: _slideAnimation!,
                        child: Text(
                          'Petly',
                          style: GoogleFonts.poppins(
                            fontSize: 60,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
