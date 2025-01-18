import 'package:flutter/material.dart';

class NiceDropdown<T> extends StatefulWidget {
  final Future<T> futureInitialValue;
  final List<T> items;
  final String Function(T) labelBuilder;
  final void Function(T?) onSelected;
  final String noItemsText;

  const NiceDropdown({
    super.key,
    required this.futureInitialValue,
    required this.items,
    required this.labelBuilder,
    required this.onSelected,
    this.noItemsText = 'No items available',
  });

  @override
  State<NiceDropdown<T>> createState() => _NiceDropdownState<T>();
}

class _NiceDropdownState<T> extends State<NiceDropdown<T>> {
  late Future<T> _futureInitialValue;

  @override
  void initState() {
    super.initState();
    _futureInitialValue = widget.futureInitialValue;
  }

  void refresh() {
    setState(() {
      _futureInitialValue = widget.futureInitialValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _futureInitialValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return DropdownMenu<T>(
            enableFilter: false,
            enableSearch: false,
            initialSelection: snapshot.data,
            requestFocusOnTap: false,
            onSelected: widget.onSelected,
            dropdownMenuEntries: widget.items.map<DropdownMenuEntry<T>>((T item) {
              return DropdownMenuEntry<T>(
                value: item,
                label: widget.labelBuilder(item),
              );
            }).toList(),
          );
        } else {
          return Text(widget.noItemsText);
        }
      },
    );
  }
}