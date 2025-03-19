import 'package:flutter/material.dart';
import 'package:movie/test2.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<String> myList = ["Item 1", "Item 2", "Item 3"];

  void addItem(String newItem) {
    setState(() {
      myList.add(newItem);
    });
  }

  void clearList() {
    setState(() {
      myList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatefulWidget Example'),
      ),
      body: Column(
        children: [
          MyStatelessWidget(addItem: addItem, clearList: clearList),
          Expanded(
            child: ListView.builder(
              itemCount: myList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(myList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}