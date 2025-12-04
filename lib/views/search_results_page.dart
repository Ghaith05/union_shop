import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/services/search_service.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/product_page.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({Key? key}) : super(key: key);

  static const routeName = '/search';

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final _controller = TextEditingController();
  final _svc = SearchService();
  List<Product> _results = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && arg.trim().isNotEmpty) {
      _controller.text = arg;
      _doSearch(arg);
    }
  }

  void _doSearch(String q) {
    final res = _svc.search(q);
    setState(() => _results = res);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  
