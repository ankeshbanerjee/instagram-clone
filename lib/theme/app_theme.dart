import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/theme/theme.dart';

class AppTheme extends InheritedWidget {
  const AppTheme({
    super.key,
    required this.theme,
    required this.toggleTheme,
    required super.child,
  });

  final MyTheme theme;
  final VoidCallback toggleTheme;

  static AppTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTheme>();
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) => theme != oldWidget.theme;
}
