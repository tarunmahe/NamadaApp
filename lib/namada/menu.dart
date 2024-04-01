// create a widget that displays a list of clickable items. 1> Balance 2> Transactions 3> Epoch Time 4> Bondsclass MyListWidget extends StatelessWidget {
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:namadaapp/actions/balance.dart';
import 'package:namadaapp/actions/bonds.dart';
import 'package:namadaapp/actions/proposals.dart';
import 'package:namadaapp/actions/transaction.dart';

final List<String> items = [
  'Balance',
  'Transactions',
  'Epoch Time',
  'Bonds',
  'Proposals'
];

class MyListWidget extends StatefulWidget {
  const MyListWidget({super.key});

  @override
  State<MyListWidget> createState() => _MyListWidgetState();
}

class _MyListWidgetState extends State<MyListWidget> {
  late List<bool> expandedList;

  @override
  void initState() {
    super.initState();
    expandedList = List<bool>.filled(items.length, false);
  }

  @override
  Widget build(BuildContext context) {
    BalanceController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namada Utilities'),
        backgroundColor: Colors.yellow,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    items[index],
                    style: const TextStyle(
                      color: Colors.black, // Change the color of the text
                      fontSize: 20.0, // Change the font size
                      fontWeight: FontWeight.bold, // Change the font weight
                    ),
                  ),
                  onTap: () async {
                    // Handle your item click here
                    final BalanceController controller = Get.find();
                    controller.balance.value = '';
                    if (items[index] == 'Balance') {
                      Get.to(
                          () => const BalanceView()); // Navigate to BalanceView
                    } else if (items[index] == 'Transactions') {
                      Get.to(() =>
                          const TransactionDetails()); // Navigate to TransactionDetails
                    } else if (items[index] == 'Bonds') {
                      Get.to(() =>
                          const BondDetails()); // Navigate to TransactionDetails
                    } else if (items[index] == 'Proposals') {
                      Get.to(() =>
                          ProposalsWidget()); // Navigate to TransactionDetails
                    } else if (items[index] == 'Epoch Time') {
                      controller.isLoading.value = true;
                      var response =
                          await controller.apiController.fetchData('/epoch');
                      controller.isLoading.value = false;
                      if (response != null) {
                        controller.epoch.value = response.toString();
                      }
                      setState(() {
                        expandedList[index] = true;
                      });
                    }
                  },
                ),
                if (items[index] == 'Epoch Time')
                  Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Container(
                          color: Colors.yellow[200],
                          child: ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                expandedList[index] = !isExpanded;
                              });
                            },
                            children: expandedList
                                .asMap()
                                .entries
                                .where(
                                    (entry) => items[entry.key] == 'Epoch Time')
                                .map<ExpansionPanel>((entry) {
                              int index = entry.key;
                              bool item = entry.value;
                              return ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(items[index]),
                                  );
                                },
                                body: ListTile(
                                  title: Text(controller.epoch.value),
                                ),
                                isExpanded: item,
                              );
                            }).toList(),
                          ),
                        )),
              ],
            ),
          );
        },
      ),
    );
  }
}
