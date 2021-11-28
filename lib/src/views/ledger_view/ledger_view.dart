import 'package:flutter/material.dart';

import '../common/sidebar.dart';

class LedgerView extends StatelessWidget {
  const LedgerView({Key? key}) : super(key: key);

  static const routeName = '/ledger';

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.name);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ledger"),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: const Sidebar(currentRouteName: routeName),
      body: const Center(
        child: Text("Sample text"),
      ),
    );
  }
}
