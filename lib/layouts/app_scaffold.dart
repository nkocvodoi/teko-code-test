import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool isBack;
  final bool isErrorPage;
  final Widget? bottomWidget;
  final Future<void>? onRefresh;
  final Function()? onWillPop;

  const AppScaffold({
    required this.title,
    required this.body,
    this.onRefresh,
    this.isBack = true,
    this.bottomWidget,
    this.isErrorPage = false,
    Key? key,
    this.onWillPop,
  }) : super(key: key);

  Future<bool> _willPopCallback() async {
    onWillPop?.call();
    return Future.value(isBack);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xFF16202A),
              ),
              child: NestedScrollView(
                physics: const NeverScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
                  SliverAppBar(
                    expandedHeight: 10.h,
                    floating: false,
                    pinned: false,
                    backgroundColor: Colors.transparent,
                    leading: isBack
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                size: 32, color: Colors.white),
                            onPressed: Navigator.of(context).pop,
                          )
                        : null,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: EdgeInsets.symmetric(vertical: 2.h),
                      title: ListTile(
                        leading: SvgPicture.asset('assets/images/logo.svg',
                            width: 10.w, color: Colors.white),
                        minLeadingWidth: 0,
                        title: Row(
                          children: [
                            if (isErrorPage)
                              RichText(
                                text: const TextSpan(
                                  text: 'ERROR ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.red),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'PRODUCTS',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white)),
                                  ],
                                ),
                              )
                            else
                              Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                          ],
                        ),
                        dense: true,
                      ),
                    ),
                  ),
                ],
                body: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: body),
              )),
              floatingActionButton: bottomWidget,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ));
  }
}
