import 'package:amap_map_example/const_config.dart';
import 'package:flutter/material.dart';
import 'package:amap_map/amap_map.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchRepository _searchRepository = SearchRepository();
  final TextEditingController _searchController = TextEditingController();
  List<PoiResult> _searchResults = [];
  bool _isLoading = false;

  Future<void> _performSearch(String keyword) async {
    if (keyword.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _searchRepository.searchKeyword(keyword);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('搜索失败：$e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '请输入搜索关键词',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _performSearch(_searchController.text),
              ),
            ),
            onSubmitted: _performSearch,
          ),
        ),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final poi = _searchResults[index];
                    return ListTile(
                      title: Text(poi.name),
                      subtitle: Text(poi.address),
                      onTap: () {
                        // 处理选中的地点
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
