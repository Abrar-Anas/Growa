import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthService extends StatefulWidget {
  const AuthService({super.key});

  @override
  State<AuthService> createState() => _AuthServiceState();
}

class _AuthServiceState extends State<AuthService> {
  List post = [];

  void fetchPosts() async {
    try {
      var respone = await Dio().get("https://dummyjson.com/auth/login");
      setState(() {
        post = respone.data;
      });
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: post.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(post[index]['title']),
          subtitle: Text(post[index]['body']),);
        },
      ),
    );
  }
}
