import 'package:flutter/material.dart';

class MyStatelessWidget extends StatelessWidget {
  final Function(String) addItem;
  final Function clearList;

  const MyStatelessWidget({super.key, required this.addItem, required this.clearList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              addItem("New Item");
            },
            child: const Text('Add Item'),
          ),
          ElevatedButton(
            onPressed: () {
              clearList();
            },
            child: const Text('Clear List'),
          ),
        ],
      ),
    );
  }
}