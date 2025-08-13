import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'presentation/pages/news_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App - Clean Architecture',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const NewsListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
