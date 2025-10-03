import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar("Search",LucideIcons.search),

      body: Center(
          child:  Text('Search UI goes here for Renan , UGH! yeah HAHAHAHAH'),
      ),
    );
  }
}