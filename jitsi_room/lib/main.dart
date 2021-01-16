import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jitsi_room/meeting.dart';
import 'package:jitsi_room/services/dynamic_link_service.dart';
import 'package:jitsi_room/services/route_generator.dart';
import 'package:jitsi_room/widgets/awesome_buttons.dart';
import 'package:jitsi_room/widgets/awesome_containers.dart';
import 'package:jitsi_room/widgets/awesome_textfield.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeModeHandler(
        builder: (ThemeMode themeMode) {
          return MaterialApp(
            title: 'Adherer - Meeting',
            themeMode: themeMode,
            darkTheme: ThemeData(
              fontFamily: GoogleFonts.fredokaOne().fontFamily,
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              primaryColor: Colors.teal,
              accentColor: Colors.orange,
            ),
            theme: ThemeData(
              fontFamily: GoogleFonts.fredokaOne().fontFamily,
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              primaryColor: Colors.blue,
              accentColor: Colors.orange,
            ),
            home: MyHomePage(),
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
        manager: ThemeModeManager());
  }
}

class ThemeModeManager implements IThemeModeManager {
  static const _key = 'example_theme_mode';

  @override
  Future<String> loadThemeMode() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(_key);
  }

  @override
  Future<bool> saveThemeMode(String value) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString(_key, value);
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDarkModeEnabled;

  @override
  void initState() {
    super.initState();
    isDarkModeEnabled =
        ThemeModeHandler.of(context).themeMode == ThemeMode.dark;
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    if (!kIsWeb) DynamicLinkService().handleDynamicLinks(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Create or Join a room',
          style: GoogleFonts.fredokaOne(color: Theme.of(context).primaryColor),
        ),
        actions: [
          Switch(
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
                if (value == true)
                  ThemeModeHandler.of(context).saveThemeMode(ThemeMode.dark);
                else
                  ThemeModeHandler.of(context).saveThemeMode(ThemeMode.light);
              })
        ],
      ),
      body: MeetingBox(),
    );
  }
}

class MeetingBox extends StatefulWidget {
  final String roomId;

  const MeetingBox({Key key, this.roomId}) : super(key: key);
  @override
  _MeetingBoxState createState() => _MeetingBoxState();
}

class _MeetingBoxState extends State<MeetingBox> {
  List _avatarList = [];
  int currentAvatarIndex = 0;
  String username, email, roomId;
  bool isDarkModeEnabled;
  TextEditingController _roomIdController = TextEditingController();

  void getAvatars() {
    for (int i = 1; i <= 5; i++) {
      String _name = 'images/avatars/Boy$i.png';
      String _nameGirl = 'images/avatars/Girl$i.png';
      setState(() {
        _avatarList.add(_name);
        _avatarList.add(_nameGirl);
      });
    }
  }

  String _generateRandomRoomId() {
    var ids = Uuid().v4().replaceAll('-', '').substring(0, 10);
    return ids; //[ids.length - 1];
  }

  Future<Uri> createDynamicLink(roomId) async {
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      Uri.parse(
          'https://adherer.page.link/?link=https://adherer-io.web.app/%23/room?roomId=$roomId&apn=yt.smazer.gabble.jitsi_room'),
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    final Uri shortUrl = shortenedLink.shortUrl;
    return shortUrl;
  }

  @override
  void initState() {
    super.initState();
    if (widget.roomId != null) {
      _roomIdController.text = widget.roomId;
      setState(() {
        roomId = widget.roomId;
      });
    }
    getAvatars();
  }

  @override
  Widget build(BuildContext context) {
    return widget.roomId != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Room: ${widget.roomId}',
                style: GoogleFonts.fredokaOne(
                    color: Theme.of(context).primaryColor),
              ),
            ),
            body: _buildBody(),
          )
        : MediaQuery.of(context).size.width > 900
            ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 400,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              'assets/images/video_${ThemeModeHandler.of(context).themeMode == ThemeMode.dark ? 'r' : 'b'}.svg',
                              height: 400,
                            ),
                          ],
                        )),
                    SizedBox(
                      width: 80,
                    ),
                    _buildBody()
                  ],
                ),
              )
            : _buildBody();
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: AwesomeContainer(
          isContainerScrollable: true,
          actionsBgColor: Colors.transparent,
          containerDecoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                blurRadius: 5,
                color: Colors.black.withOpacity(0.2),
              )
            ],
          ),
          labelWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  !kIsWeb
                      ? IconButton(
                          icon: Icon(Icons.link),
                          onPressed: () async {
                            if (roomId != null) {
                              // var url = await createDynamicLink(roomId);
                              var url =
                                  'https://adherer.page.link/?link=https://adherer-io.web.app/%23/room?roomId=$roomId&apn=yt.smazer.gabble.jitsi_room';
                              Clipboard.setData(
                                  new ClipboardData(text: "$url"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  'Link Copied to Clipboard',
                                  style: GoogleFonts.fredokaOne(),
                                ),
                                width: 300,
                                behavior: SnackBarBehavior.floating,
                              ));
                            }
                          })
                      : SizedBox.shrink(),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      if (roomId != null) {
                        if (kIsWeb) {
                          var url =
                              'https://adherer.page.link/?link=https://adherer-io.web.app/%23/room?roomId=$roomId&apn=yt.smazer.gabble.jitsi_room';
                          Clipboard.setData(new ClipboardData(text: "$url"));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Link Copied to Clipboard',
                              style: GoogleFonts.fredokaOne(),
                            ),
                            width: 300,
                            behavior: SnackBarBehavior.floating,
                          ));
                          // var shareData = {
                          //   "title": 'Adherer Room',
                          //   "text": 'Hey Join My Room',
                          //   "url": '$url',
                          // };
                          // await html.window.navigator.share(shareData);
                        } else {
                          var url = await createDynamicLink(roomId);
                          Share.share('Hey Join My Room @ $url');
                        }
                      }
                    },
                    tooltip: 'Share room info',
                  ),
                ],
              ),
            ],
          ),
          actionWidget: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AwesomeButton(
                  isExpanded: true,
                  height: 50,
                  buttonType: AwesomeButtonType.elevated,
                  child: Text(
                    widget.roomId != null ? 'Join Room' : 'Start',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Meeting(
                                  roomText: roomId ?? 'yourroom',
                                  subjectText: roomId ?? 'Subject',
                                  username: username ?? 'username',
                                  email: '$username@gmail.com',
                                  avatarImage: Image.asset(
                                      _avatarList[currentAvatarIndex]),
                                )));
                  },
                ),
                widget.roomId != null
                    ? SizedBox(
                        height: 10,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AwesomeButton(
                          onPressed: () {
                            String id = _generateRandomRoomId();
                            setState(() {
                              roomId = id;
                            });
                            _roomIdController.text = roomId;
                          },
                          child: Text(
                            'Generate random Room Id',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          overflowChildWidget: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    child: AwesomeContainer(
                      actionWidget: SizedBox.shrink(),
                      labelText: Text(
                        'Select Avatar',
                        style: TextStyle(fontSize: 20),
                      ),
                      labelTextStyle: TextStyle(fontSize: 22),
                      isPopUp: true,
                      containerWidth: 500,
                      isContainerScrollable: false,
                      bodyWidget: Container(
                        height: MediaQuery.of(context).size.height > 500
                            ? 300
                            : 200,
                        child: GridView.count(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 500 ? 3 : 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          children: List.generate(_avatarList.length, (index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  currentAvatarIndex = index;
                                  Navigator.pop(context);
                                });
                              },
                              child: Container(
                                color: Colors.grey.withOpacity(0.1),
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  _avatarList[index],
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  // color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Image.asset(
                  _avatarList[currentAvatarIndex],
                  fit: BoxFit.fitHeight,
                  height: 100,
                )),
          ),
          overflowChildHeight: 130,
          overflowChildWidth: 130,
          bodyWidget: Container(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AwesomeTextField(
                  isReadOnly: widget.roomId != null ? true : false,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  borderType: InputBorderType.none,
                  controller: _roomIdController,
                  onChanged: (value) {
                    setState(() {
                      roomId = value;
                    });
                  },
                  labelText: 'Enter RoomId:',
                  width: 500,
                ),
                AwesomeTextField(
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  borderType: InputBorderType.none,
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  labelText: 'Enter Username:',
                  width: 500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
