import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:growa/controllers/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Websocket extends StatefulWidget {
  const Websocket({super.key});

  @override
  State<Websocket> createState() => _WebsocketState();
}

class _WebsocketState extends State<Websocket> {
  WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse(
      "ws://51.21.132.209/app/nywcgjbzz5yhljss7pbt?protocol=7&client=js&version=8.4.0-rc2&flash=false",
    ),
  );

  @override
  void initState() {
    super.initState();

    // 1. Connect
    channel = WebSocketChannel.connect(
      Uri.parse(
        'ws://51.21.132.209/app/nywcgjbzz5yhljss7pbt?protocol=7&client=js&version=8.4.0-rc2&flash=false',
      ),
    );

    // 2. Subscribe (CRITICAL STEP)
    // This tells the server: "Start sending me data for the sensors channel"
    channel.sink.add(
      jsonEncode({
        "event": "pusher:subscribe",
        "data": {
          "channel": "control.GH-112233",
        }, // Check your backend for the exact channel name
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text("data: ${snapshot.data}");
            }
            return Text("data");
          },
        ),
      ),
    );
  }
}
