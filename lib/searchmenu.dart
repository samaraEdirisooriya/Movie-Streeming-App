import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  bool _isLoading = false;

  Future<void> _search(String quary) async {
    setState(() {
      _isLoading = true;
    });
    final String apiUrl =
        'https://video.bunnycdn.com/library/339747/videos?page=1&itemsPerPage=20&orderBy=date&search=$quary';
    // replace with your actual API endpoint
    var headers = {
      'AccessKey': 'e78a5d05-9efa-4dc5-aa16e96b2ddb-96ac-4030',
      'accept': 'application/json',
    };
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _searchResults = List.from(data['items']);
        });
      } else {
        // Handle error
        print('Failed to load data. Error ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchDelayed(_searchController.text);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Enter your search query',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]['title']),
                );
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Center(
              child: _isLoading ? const CircularProgressIndicator() : Container(),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _searchDelayed(String query) async {
    // Cancel the previous search request if it exists
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults.clear();
        _searchResults = [];
      });
      return;
    }

    // Add a short delay before making the API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Perform the search
    _search(query);
  }
}
