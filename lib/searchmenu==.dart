import 'package:flutter/material.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search>
    with SingleTickerProviderStateMixin {
   int _selectedIndex = 0;

  List<String> tabTitles = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tabTitles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  // Add your logic or function call here when a tab is selected
                  // For example: _handleTabSelection(index);
                },
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _selectedIndex == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tabTitles[index],
                    style: TextStyle(
                      color: _selectedIndex == index ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Content for ${tabTitles[_selectedIndex]}',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}