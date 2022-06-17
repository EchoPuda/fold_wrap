import 'package:flutter/material.dart';
import 'package:fold_wrap/fold_wrap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Fold Wrap'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<String> _listHistory = [
    'test',
    'shoe',
    'Fold Widget',
    'long long long long long',
    's',
    'pick pick',
    'show time',
    'next time',
    'fly to the end',
    'jomin',
    'a very long long long long long long long long long long long long long'
  ];

  bool isFold = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.maxFinite,
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isFold = true;
                });
              },
              child: Container(
                width: double.maxFinite,
                height: 50,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  'History (click to reset)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: FoldWrap(
                children: _listHistory.map((e) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[200]
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    e,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                )).toList(),
                extentHeight: 30,
                spacing: 10,
                runSpacing: 10,
                isFold: isFold,
                foldLine: 2,
                foldWidgetInEnd: true,
                foldWidget: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFold = !isFold;
                    });
                  },
                  child: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
