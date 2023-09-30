import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:record_example/audio_player.dart';
import 'package:record_example/audio_rec_view.dart';
import 'package:record_example/chat_item.dart';
import 'package:record_example/main.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? audioPath;
  bool show = false;
  bool showPlayer = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  // List<MessageModel> messages = [];

  @override
  void initState() {
    showPlayer = false;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        children: [
          UselessWidget(),
          Flexible(
            flex: 4,
            fit: FlexFit.loose,
            child: Column(
              children: [
                ChatItemWidget(1),
                ChatItemWidget(2),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Center(
              child: showPlayer
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: AudioRecPlayer(
                        source: audioPath!,
                        onDelete: () {
                          setState(() => showPlayer = false);
                        },
                      ),
                    )
                  : AudioRecorderView(
                      onStop: (path) {
                        if (kDebugMode) print('Recorded file path: $path');
                        setState(() {
                          audioPath = path;
                          showPlayer = true;
                        });
                      },
                    ),
            ),
          ),
        ],
      )),
    );
  }
}

class UselessWidget extends StatefulWidget {
  const UselessWidget({Key? key}) : super(key: key);

  @override
  State<UselessWidget> createState() => _UselessWidgetState();
}

class _UselessWidgetState extends State<UselessWidget> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool show = false;
  bool showPlayer = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  @override
  void initState() {
    showPlayer = false;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Card(
                    margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextFormField(
                      controller: _controller,
                      focusNode: focusNode,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      onChanged: (value) {
                        if (value.length > 0) {
                          setState(() {
                            sendButton = true;
                          });
                        } else {
                          setState(() {
                            sendButton = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: IconButton(
                          icon: Icon(
                            show
                                ? Icons.keyboard
                                : Icons.emoji_emotions_outlined,
                          ),
                          onPressed: () {
                            if (!show) {
                              focusNode.unfocus();
                              focusNode.canRequestFocus = false;
                            }
                            setState(() {
                              show = !show;
                            });
                          },
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.attach_file),
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (builder) => bottomSheet());
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (builder) =>
                                //             CameraApp()));
                              },
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    right: 2,
                    left: 2,
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF128C7E),
                    child: IconButton(
                      icon: Icon(
                        sendButton ? Icons.send : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (sendButton) {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                          // sendMessage(
                          //     _controller.text,
                          //     widget.sourchat.id,
                          //     widget.chatModel.id);
                          // _controller.clear();
                          // setState(() {
                          //   sendButton = false;
                          // });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}
