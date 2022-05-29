import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sizer/sizer.dart';
import 'package:teko_test/cubit/error_products/error_products_cubit.dart';
import 'package:teko_test/services/error_products/error_products_repository.dart';
import 'package:teko_test/utils/route/app_routing.dart';
import 'di/initialize_dependency.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependency();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (BuildContext context) => ErrorProductCubit(
                        injector.get<IErrorProductRepository>()),
                  )
                ],
                child: MaterialApp(
                  localizationsDelegates: const [
                    FormBuilderLocalizations.delegate,
                  ],
                  navigatorKey: AppRouting.mainNavigationKey,
                  onGenerateRoute: AppRouting.generateMainRoute,
                  debugShowCheckedModeBanner: false,
                  title: 'Teko',
                  home: const HomePage(),
                ))));
  }
}
