import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/layouts/app_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isBack: false,
        isErrorPage: true,
        title: '',
        body: SizedBox(height: 120.h,));
  }
}
