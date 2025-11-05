import 'package:demo_clean_archtechture_with_provider/features/posts/presentation/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/all_post_widget.dart';


class PostPage extends StatelessWidget {
   const PostPage({super.key});

   @override
   Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
     return Scaffold(
       body: Container(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             AllPostsWidget()
           ],
         ),
       )
     );
   }
 }
