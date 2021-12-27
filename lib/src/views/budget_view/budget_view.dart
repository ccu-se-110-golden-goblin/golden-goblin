import 'package:flutter/material.dart';
import 'package:golden_goblin/src/views/common/sidebar.dart';

import '../../settings/settings_controller.dart';

class BudgetAmount extends StatelessWidget {
  const BudgetAmount({Key? key, required this.controller}) : super(key: key);

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    int? newBudgetAmount = controller.budgetAmount;
    AlertDialog budgetAmountInsertDialog = AlertDialog(
      title: const Text('預算設定'),
      content: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: newBudgetAmount.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "預算金額",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入金額';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (newBudgetAmount != null) {
                    newBudgetAmount = int.parse(value);
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                    child: TextButton(
                        onPressed: () {
                          controller.updateBudgetAmount(newBudgetAmount);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "完成",
                          style: TextStyle(fontSize: 12),
                        )),
                  )
                ],
              )
            ],
          )),
    );
    return ListTile(
      title: const Text('每月預算'),
      subtitle: Text(controller.budgetAmount.toString()),
      onTap: () {
        showDialog(
            context: context, builder: (context) => budgetAmountInsertDialog);
      },
    );
  }
}

class BudgetHiddenSwitch extends StatelessWidget {
  const BudgetHiddenSwitch({Key? key, required this.controller})
      : super(key: key);

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('顯示預算'),
      value: controller.budgetHidden,
      onChanged: controller.updateBudgetHidden,
    );
  }
}

class BudgetView extends StatelessWidget {
  const BudgetView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/budget';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('預算控制'),
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
      body: ListView(
        children: [
          BudgetAmount(controller: controller),
          const Divider(thickness: 0.5, height: 0),
          BudgetHiddenSwitch(controller: controller),
          const Divider(thickness: 0.5, height: 0),
        ],
      ),
    );
  }
}
