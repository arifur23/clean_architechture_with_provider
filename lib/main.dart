import 'package:demo_clean_archtechture_with_provider/features/posts/presentation/pages/post_page.dart';
import 'package:demo_clean_archtechture_with_provider/features/posts/presentation/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
      ChangeNotifierProvider(create: (context) => PostProvider())
    ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: Home()
      ),
    );

  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<PostProvider>(context, listen: false).eitherFailureOrPost(value: '1');
  }

  @override
  Widget build(BuildContext context) {
    return PostPage();
  }
}

