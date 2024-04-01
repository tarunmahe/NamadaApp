import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namadaapp/actions/balance.dart';

class BondDetails extends StatefulWidget {
  const BondDetails({super.key});

  @override
  _BondDetailsState createState() => _BondDetailsState();
}

class _BondDetailsState extends State<BondDetails> {
  final BalanceController balanceController = Get.find();
  Map<String, String> data = {};
  String address = '';
  bool isLoading = false;

  fetchBonds() async {
    setState(() {
      isLoading = true;
    });
    String response =
        await balanceController.apiController.fetchData('/bonds/$address');
    List<String> lines = response.split('\n');
    for (var line in lines) {
      List<String> parts = line.split(': ');
      if (parts.length == 2) {
        data[parts[0]] = parts[1];
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bond Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                address = value;
              },
              decoration: const InputDecoration(
                labelText: 'Enter address',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (address.startsWith('tnam1')) {
                  fetchBonds();
                }
              },
              child: const Text('Submit'),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: data.entries.length,
                      itemBuilder: (context, index) {
                        var entry = data.entries.elementAt(index);
                        return ListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            entry.value,
                            style: TextStyle(fontSize: 20),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
