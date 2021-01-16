import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_room/main.dart';
import 'package:jitsi_room/meeting.dart';

class DynamicLinkService {
  Future handleDynamicLinks(context) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data, context);
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
      _handleDeepLink(dynamicLinkData, context);
    }, onError: (OnLinkErrorException e) async {
      print('Dynamic Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data, BuildContext context) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deepLink $deepLink');
      var isRoom = deepLink.pathSegments.contains('room');
      if (isRoom) {
        var roomId = deepLink.queryParameters['roomId'];
        if (roomId != null) {
          print(roomId);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MeetingBox(
                    roomId: roomId,
                  )));
        }
      }
    }
  }
}
