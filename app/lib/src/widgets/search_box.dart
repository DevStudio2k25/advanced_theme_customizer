import 'package:flutter/material.dart';

import 'resolved_surface.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant SearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller
        ..text = widget.value
        ..selection = TextSelection.collapsed(offset: widget.value.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResolvedSurface(
      componentKey: 'discover.search.input',
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      fallbackFill: const Color(0xFF111A2D),
      fallbackBorder: const Color(0xFF30476C),
      fallbackRadius: 16,
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: 'Search by title, genre or mood...',
        ),
      ),
    );
  }
}
