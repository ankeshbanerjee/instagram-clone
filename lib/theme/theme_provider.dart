import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/theme/dark_theme.dart';
import 'package:instagram_clone/theme/light_theme.dart';
import 'package:instagram_clone/theme/theme.dart';
import 'package:instagram_clone/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends StatefulWidget {
  final Widget child;

  const ThemeProvider({Key? key, required this.child}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ThemeProviderState createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> {
  late MyTheme _theme;
  late SharedPreferences _prefs;

  Future<void> setTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final bool isDark = _prefs.getBool('isDark') ?? false;
    setState(() {
      _theme = isDark ? darkTheme : lightTheme;
    });
  }

  @override
  void initState() {
    super.initState();
    setTheme(); // default theme
  }

  void toggleThemeFunction() {
    _prefs.setBool('isDark', _theme == lightTheme);
    setState(() {
      _theme = _theme == lightTheme ? darkTheme : lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      theme: _theme,
      toggleTheme: toggleThemeFunction,
      child: widget.child,
    );
  }
}
