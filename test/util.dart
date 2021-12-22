import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class EmptyStateLessWidget extends StatelessWidget {
  const EmptyStateLessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('');
  }
}

Widget buildTestableWidget(Widget widget, {NavigatorObserver? navObserver}) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        home: widget,
        navigatorObservers: navObserver != null ? [navObserver] : [],
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
            builder: (BuildContext context) => const EmptyStateLessWidget(),
          );
        },
      ));
}
