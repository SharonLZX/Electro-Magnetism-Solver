import 'package:flutter/material.dart';

class ResultList extends StatefulWidget {
  final List<String> result;

  const ResultList({super.key, required this.result});

  @override
  State<ResultList> createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      shrinkWrap: true,
      itemCount: widget.result.length,
      itemBuilder: (context, index) {
        return Card(
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            color: index.isEven ? Colors.grey[300] : Colors.grey[350],
            child: ListTile(
              title: Text("Step $index"),
              subtitle: Text(widget.result[index]),
            ));
      },
    );
  }
}
