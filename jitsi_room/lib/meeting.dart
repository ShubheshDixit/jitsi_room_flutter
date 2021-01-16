import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_room/widgets/awesome_buttons.dart';

class Meeting extends StatefulWidget {
  final String roomText, username, email;
  final Widget avatarImage;
  final String subjectText;

  const Meeting({
    Key key,
    this.roomText,
    this.subjectText,
    this.username,
    this.email,
    this.avatarImage,
  }) : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "plugintestroom");
  final subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final nameText = TextEditingController(text: "Plugin Test User");
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  // bool isAudioOnly = false;
  bool isAudioMuted = false;
  bool isVideoMuted = false;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    // JitsiMeet.addListener(JitsiMeetingListener(
    //     onConferenceWillJoin: _onConferenceWillJoin,
    //     onConferenceJoined: _onConferenceJoined,
    //     onConferenceTerminated: _onConferenceTerminated,
    //     onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: !connected
            ? Center(
                child: Container(
                width: 300,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(500),
                          child: Container(
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                            child: widget.avatarImage,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.username,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(isAudioMuted ? Icons.mic_off : Icons.mic),
                          Switch.adaptive(
                              value: !isAudioMuted,
                              onChanged: _onAudioMutedChanged),
                          Icon(isVideoMuted
                              ? Icons.videocam_off
                              : Icons.videocam),
                          Switch.adaptive(
                              value: !isVideoMuted,
                              onChanged: _onVideoMutedChanged)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AwesomeButton(
                        height: 40,
                        buttonType: AwesomeButtonType.elevated,
                        isExpanded: true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Join Room'),
                        ),
                        onPressed: () {
                          setState(() {
                            connected = true;
                          });
                          Timer(Duration(milliseconds: 100),
                              () => _joinMeeting());
                        },
                      ),
                    ),
                  ],
                ),
              ))
            : kIsWeb
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                color: Colors.green[100],
                                child: SizedBox(
                                  width: width,
                                  height: height,
                                  child: JitsiMeetConferencing(
                                    extraJS: [
                                      // extraJs setup example
                                      '<script>function echo(){console.log("echo!!!")};</script>',
                                      '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                                      // '<script defer>document.getElementsByClass("leftwatermark")[0].style.display = "none"</script>'
                                    ],
                                  ),
                                )),
                          ))
                    ],
                  )
                : CenterInfo(
                    connected: connected,
                  ),
      ),
    );
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = !value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = !value;
    });
  }

  _joinMeeting() async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
      FeatureFlagEnum.CALENDAR_ENABLED: false,
      FeatureFlagEnum.INVITE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions()
      ..room = widget.roomText ?? "roomid"
      ..serverURL = serverUrl
      ..subject = widget.subjectText ?? subjectText.text
      ..userDisplayName = widget.username ?? nameText.text
      ..userEmail = widget.email ?? emailText.text
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = false
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": widget.roomText,
        "width": "100%",
        "height": "100%",
        "configOverwrite": {
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
          "enableWelcomePage": false,
        },
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "interfaceConfigOverwrite": {
          "DISPLAY_WELCOME_FOOTER": false,
          "DISPLAY_WELCOME_PAGE_ADDITIONAL_CARD": false,
          "DISPLAY_WELCOME_PAGE_CONTENT": false,
          "DISPLAY_WELCOME_PAGE_TOOLBAR_ADDITIONAL_CONTENT": false,
          "SHOW_JITSI_WATERMARK": false,
          "DEFAULT_LOGO_URL": '',
          "DEFAULT_WELCOME_PAGE_LOGO_URL": '',
          "SHOW_WATERMARK_FOR_GUESTS": false,
          "JITSI_WATERMARK_LINK": '',
          "ENABLE_DIAL_OUT": false,
          "SHOW_CHROME_EXTENSION_BANNER": false,
          "SHOW_BRAND_WATERMARK": false,
          "HIDE_INVITE_MORE_HEADER": true,
          "HIDE_DEEP_LINKING_LOGO": true,
          "TOOLBAR_BUTTONS": [
            'microphone',
            'camera',
            'closedcaptions',
            'desktop',
            // 'embedmeeting',
            'fullscreen',
            'fodeviceselection',
            'hangup',
            // 'profile',
            'chat',
            'recording',
            'livestreaming',
            'etherpad',
            'sharedvideo',
            'settings',
            'raisehand',
            'videoquality',
            'filmstrip',
            // 'feedback',
            // 'stats',
            // 'shortcuts',
            'tileview',
            'videobackgroundblur',
            'download',
            // 'help',
            'mute-everyone',
            // 'security'
          ],
        },
        "userInfo": {"displayName": widget.username, "email": widget.email}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
        onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        },
        onConferenceJoined: ({message}) {
          setState(() {
            connected = true;
          });
          debugPrint("${options.room} joined with message: $message");
        },
        onConferenceTerminated: ({message}) {
          if (connected) {
            Navigator.pop(context);
            setState(() {
              connected = false;
            });
            JitsiMeet.closeMeeting();
          }
          debugPrint("${options.room} terminated with message: $message");
        },
      ),
      // genericListeners: [
      //   JitsiGenericListener(
      //       eventName: 'readyToClose',
      //       callback: (dynamic message) {
      //         debugPrint("readyToClose callback");
      //       }),
      // ]),
    );
  }

  // static final Map<RoomNameConstraintType, RoomNameConstraint>
  //     customContraints = {
  //   RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
  //     return value.trim().length <= 50;
  //   }, "Maximum room name length should be 30."),
  //   RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
  //     return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
  //             .hasMatch(value) ==
  //         false;
  //   }, "Currencies characters aren't allowed in room names."),
  // };

  // void _onConferenceWillJoin({message}) {
  //   debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  // }

  // void _onConferenceJoined({message}) {
  //   setState(() {
  //     connected = true;
  //   });
  //   debugPrint("_onConferenceJoined broadcasted with message: $message");
  // }

  // void _onConferenceTerminated({message}) {
  //   Navigator.pop(context);
  //   // debugPrint("_onConferenceTerminated broadcasted with message: $message");
  // }

  // _onError(error) {
  //   debugPrint("_onError broadcasted: $error");
  // }
}

class CenterInfo extends StatelessWidget {
  final connected;

  const CenterInfo({Key key, this.connected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text('Connecting',
              style: TextStyle(
                fontSize: 22,
              )),
        ),
      ),
    );
  }
}
