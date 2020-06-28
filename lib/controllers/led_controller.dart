import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../settings.dart';
import '../widgets/led_slider.dart';

class LedController extends StatefulWidget {
  @override
  _LedControllerState createState() => _LedControllerState();
}

class _LedControllerState extends State<LedController> {
  WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect(led1url);
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: channel.stream,
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Text('connection state done'),
          );
        }

        final data = jsonDecode(snapshot.data);

        final newValue = (data['value'] as num).toDouble();

        return LedSlider(
          initValue: newValue,
          onSliderValueChange: (value) {
            var message = {'message': 'set_led_1', 'value': value};
            channel.sink.add(jsonEncode(message));
          },
        );
      },
    );
  }
}
