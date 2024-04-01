import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/apicontroller.dart';

class BalanceController extends GetxController {
  final TextEditingController addressController = TextEditingController();
  final RxString balance = ''.obs;
  final RxString epoch = ''.obs;

  final RxBool isLoading = false.obs;

  final ApiController apiController =
      Get.find(); // Get the instance of ApiController

  Future<void> fetchBalance() async {
    if (!addressController.text.startsWith('tnam1')) {
      Get.snackbar('Error', 'Address must start with "tnam1"');
      return;
    }

    isLoading.value = true;
    var response = await apiController.fetchData(
        '/balance/${addressController.text}'); // Use ApiController to fetch data
    isLoading.value = false;

    if (response != null) {
      balance.value = response.toString();
    } else {
      Get.snackbar('Error', 'Failed to fetch balance');
    }
  }
}

class BalanceView extends StatefulWidget {
  const BalanceView({super.key});

  @override
  State<BalanceView> createState() => _BalanceViewState();
}

class _BalanceViewState extends State<BalanceView> {
  final BalanceController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check Balance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Enter an address starting with "tnam1"',
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: controller.fetchBalance,
                    child: const Text('Submit'),
                  )),
            const SizedBox(height: 16.0),
            Obx(() => Text('Balance: ${controller.balance.value}')),
          ],
        ),
      ),
    );
  }
}
