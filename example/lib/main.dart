import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:view_app_share_option/view_app_share_option.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformSharedFilePath = '';
  final _viewAppShareOptionPlugin = ViewAppShareOption();

  @override
  void initState() {
    super.initState();
    _viewAppShareOptionPlugin.onFileShared.listen((_) async {
      final newPath = await _viewAppShareOptionPlugin.getSharedFile() ?? 'Empty file path';
      if (!mounted) return;
      setState(() {
        _platformSharedFilePath = newPath;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Running on: $_platformSharedFilePath\n')),
      ),
    );
  }
}
