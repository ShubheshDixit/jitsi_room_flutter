import 'package:flutter/material.dart';
import 'package:jitsi_room/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    var routingData = settings.name.getRoutingData;
    switch (routingData.route) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
        break;
      case '/room':
        var roomId = routingData['roomId'];
        return MaterialPageRoute(builder: (context) {
          return MeetingBox(
            roomId: roomId,
          );
        });
        break;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'images/avatars/Boy1.png',
                height: 200,
              ),
              Text(
                'Error 404 Page Not Found',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      );
    });
  }
}

class RoutingData {
  final String route;
  final Map<String, String> _queryParameters;

  RoutingData({this.route, Map<String, String> queryParameters})
      : _queryParameters = queryParameters;
  operator [](String key) => _queryParameters[key];
}

extension StringExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    print('queryParameters: ${uriData.queryParameters} path: ${uriData.path}');
    return RoutingData(
        queryParameters: uriData.queryParameters, route: uriData.path);
  }
}
