import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namadaapp/actions/balance.dart';
import 'dart:convert';

class ProposalsWidget extends StatefulWidget {
  @override
  _ProposalsWidgetState createState() => _ProposalsWidgetState();
}

class _ProposalsWidgetState extends State<ProposalsWidget> {
  late Future<List<Map<String, dynamic>>> futureProposals;
  final BalanceController balanceController = Get.find();

  @override
  void initState() {
    super.initState();
    futureProposals = fetchProposals();
  }

  Future<List<Map<String, dynamic>>> fetchProposals() async {
    var data = await balanceController.apiController.fetchData('/proposals');

    return List<Map<String, dynamic>>.from(json.decode(data));

    //return await balanceController.apiController.fetchData('/proposals');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proposals'),
        backgroundColor: Colors.yellow,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureProposals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var proposals = snapshot.data;
            proposals!.sort((a, b) => int.parse(b['Proposal Id'])
                .compareTo(int.parse(a['Proposal Id'])));
            return ListView.builder(
              itemCount: proposals.length,
              itemBuilder: (context, index) {
                var proposal = proposals[index];
                return Card(
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text('Proposal Id: ${proposal["Proposal Id"]}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildKeyValue('Type:', '${proposal["Type"]}'),
                              buildKeyValue('Author:', '${proposal["Author"]}'),
                              buildKeyValue(
                                  'Start Epoch:', '${proposal["Start Epoch"]}'),
                              buildKeyValue(
                                  'End Epoch:', '${proposal["End Epoch"]}'),
                              buildKeyValue(
                                  'Grace Epoch:', '${proposal["Grace Epoch"]}'),
                              buildKeyValue('Status:', '${proposal["Status"]}'),
                              buildKeyValue('Content:',
                                  '${proposal["Content"]["abstract"]}'),
                              buildKeyValue('Details:',
                                  '${proposal["Content"]["details"]}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget buildKeyValue(String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: key,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ' $value',
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
