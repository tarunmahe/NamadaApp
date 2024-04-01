import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:namadaapp/actions/balance.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({super.key});

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  final BalanceController balanceController = Get.find();
  final _formKey = GlobalKey<FormState>();
  String transactionHash = '';
  Map<String, String> data = {};

  fetchData() async {
    String response = await balanceController.apiController
        .fetchData('/transactions/$transactionHash');
    List<String> lines = response.split('\n');
    for (var line in lines) {
      if (line.startsWith('- ')) {
        List<String> parts = line.substring(2).split(': ');
        if (parts.length == 2) {
          data[parts[0]] = parts[1];
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              maxLines: 2,
              decoration:
                  const InputDecoration(labelText: 'Enter transaction hash'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a transaction hash';
                }
                return null;
              },
              onSaved: (value) {
                transactionHash = value!;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                fetchData();
              }
            },
            child: Text('Submit'),
          ),
          data.isEmpty
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: data.entries.length,
                    itemBuilder: (context, index) {
                      var entry = data.entries.elementAt(index);
                      // Skip the "Source" row if its value is "Undefined"
                      if (entry.value == 'undefined') {
                        return Container(); // return an empty container for 'undefined' values
                      }
                      // Display the "TX ID" in multiple lines if it's too long
                      return ListTile(
                        title: Text(entry.key),
                        subtitle: Text(
                          entry.value,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
