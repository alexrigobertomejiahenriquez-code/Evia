import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'navigation/bottom_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appTheme = AppTheme();

  runApp(EviaApp(appTheme: appTheme));
}

class EviaApp extends StatefulWidget {
  final AppTheme appTheme;
  const EviaApp({super.key, required this.appTheme});

  @override
  State<EviaApp> createState() => _EviaAppState();
}

class _EviaAppState extends State<EviaApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appTheme,
      builder: (context, _) {
        return MaterialApp(
          title: 'EVIA',
          theme: widget.appTheme.lightTheme,
          darkTheme: widget.appTheme.darkTheme,
          themeMode: widget.appTheme.themeMode,
          debugShowCheckedModeBanner: false,
          home: MainNavigation(appTheme: widget.appTheme),
        );
      },
    );
  }
}
