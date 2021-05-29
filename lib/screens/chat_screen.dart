import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui_starter/models/chat.dart';
import 'package:flutter_chat_ui_starter/models/message.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter_chat_ui_starter/providers/auth_provider.dart';
import 'package:flutter_chat_ui_starter/screens/chat_information.dart';
import 'package:flutter_chat_ui_starter/services/cloud_storage_service.dart';
import 'package:flutter_chat_ui_starter/services/database_service.dart';
import 'package:flutter_chat_ui_starter/services/navigation_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:flutter_chat_ui_starter/services/media_service.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  String chatID;
  String receiverID;
  String chatImage;
  String chatName;

  ChatScreen({this.chatID, this.receiverID, this.chatImage, this.chatName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int selectedIndex = 0;
  final List<String> media = ['Chat', 'Media'];
  final messageTextController = TextEditingController();

  AuthProvider _auth;
  String messageText;

  bool isRTL = false;
  String text = '';

  Widget generateItem(String imageURL) {
    DecorationImage _image =
        DecorationImage(image: NetworkImage(imageURL), fit: BoxFit.cover);
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Color(0xFF125589),
        ),
        padding: EdgeInsets.all(3.0),
        child: Container(
          height: 160.0,
          width: 121.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: _image,
          ),
        ),
      ),
    );
  }

  List<Widget> imageContainerList(int count, String imageURL) {
    List<Widget> items = [];
    for (int i = 0; i < count; i++) {
      items.add(generateItem(imageURL));
    }
    return items;
  }

  _buildMessage(String message, bool isMe, Timestamp time, String sender) {
    return StreamBuilder(
      stream: DatabaseService.instance.getUserData(sender),
      builder: (_context, _snapshot) {
        var _data = _snapshot.data;

        return Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: isMe ? Theme.of(context).accentColor : Color(0xFFF3F7FA),
              ),
              margin: isMe
                  ? EdgeInsets.only(
                      left: 150.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 10.0,
                    )
                  : EdgeInsets.only(
                      right: 150.0,
                      left: 20.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isMe
                      ? Container(
                          width: 0.0,
                        )
                      : Text(
                          _data != null ? _data.name : '',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.indigoAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  SizedBox(
                    height: 2.0,
                  ),
                  AutoDirection(
                    onDirectionChange: (isRTL) {
                      setState(() {
                        this.isRTL = isRTL;
                      });
                    },
                    text: message,
                    child: Text(
                      message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: isMe
                  ? EdgeInsets.only(
                      left: 150.0,
                      right: 20.0,
                    )
                  : EdgeInsets.only(
                      right: 150.0,
                      left: 20.0,
                    ),
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Text(
                    timeago.format(time.toDate()),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _buildImageMessage(
      bool isMe, String imageURL, Timestamp time, String sender) {
    DecorationImage _image =
        DecorationImage(image: NetworkImage(imageURL), fit: BoxFit.cover);
    return StreamBuilder(
      stream: DatabaseService.instance.getUserData(sender),
      builder: (_context, _snapshot) {
        var _data = _snapshot.data;
        return Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: isMe ? Theme.of(context).accentColor : Color(0xFFF3F7FA),
              ),
              margin: isMe
                  ? EdgeInsets.only(
                      left: 150.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 10.0,
                    )
                  : EdgeInsets.only(
                      right: 150.0,
                      left: 20.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
              padding: EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isMe
                          ? Container(
                              width: 0.0,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                _data != null ? _data.name : '',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: _image,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: isMe
                  ? EdgeInsets.only(
                      left: 150.0,
                      right: 20.0,
                    )
                  : EdgeInsets.only(
                      right: 150.0,
                      left: 20.0,
                    ),
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Text(
                    timeago.format(time.toDate()),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AutoDirection(
              onDirectionChange: (isRTL) {
                setState(() {
                  this.isRTL = isRTL;
                });
              },
              text: text,
              child: Container(
                padding: EdgeInsets.only(left: 10.0),
                margin: EdgeInsets.only(left: 11.0, top: 11.0, bottom: 11.0),
                decoration: BoxDecoration(
                  color: Color(0xFFF3F7FA),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(7.5),
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      setState(() {
                        text = value;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Colors.blueGrey,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              //right: 11.0,
              top: 11.0,
              bottom: 11.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 30.0,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  var _image =
                      await MediaService.instance.getImageFromLibrary();
                  if (_image != null) {
                    var _result = await CloudStorageService.instance
                        .uploadMediaMessage(_auth.user.uid, _image);
                    var _imageURL = await _result.ref.getDownloadURL();
                    await DatabaseService.instance.sendMessage(
                      this.widget.chatID,
                      Message(
                          message: _imageURL,
                          senderID: _auth.user.uid,
                          time: Timestamp.now(),
                          type: MessageType.Image),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 2.0),
            margin: EdgeInsets.only(top: 11.0, bottom: 11.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: IconButton(
              icon: Icon(Icons.send_rounded),
              iconSize: 30.0,
              color: Theme.of(context).accentColor,
              onPressed: () {
                messageTextController.clear();
                DatabaseService.instance.sendMessage(
                  this.widget.chatID,
                  Message(
                    message: text,
                    time: Timestamp.now(),
                    senderID: _auth.user.uid,
                    type: MessageType.Text,
                  ),
                );
                setState(() {
                  text = '';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).accentColor,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Container(
            child: Row(
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(this.widget.chatImage),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    NavigationService.instance.navigateToRoute(
                      MaterialPageRoute(
                        builder: (BuildContext _context) {
                          return ChatInformation(
                            chatID: this.widget.chatID,
                            chatImage: this.widget.chatImage,
                            chatName: this.widget.chatName,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      this.widget.chatName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            iconSize: 40.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  height: 70.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 8.5,
                            top: 17.0,
                            bottom: 13.0,
                            left: 8.5,
                          ),
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color:
                                  index == selectedIndex ? Colors.white : null,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              media[index],
                              style: TextStyle(
                                  color: index == selectedIndex
                                      ? Color(0xFF125589)
                                      : Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Builder(
                  builder: (BuildContext _context) {
                    _auth = Provider.of<AuthProvider>(_context);
                    return Expanded(
                      child: StreamBuilder<Chat>(
                        stream: DatabaseService.instance
                            .getChat(this.widget.chatID),
                        builder: (BuildContext _context, _snapshot) {
                          var _chatData = _snapshot.data;
                          if (_chatData != null) {
                            return ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: _chatData.messages.length,
                              itemBuilder: (BuildContext context, int _index) {
                                var reverse =
                                    List.from(_chatData.messages.reversed);
                                var _message = reverse[_index];
                                bool isMe = _message.senderID == _auth.user.uid;
                                return _message.type == MessageType.Text
                                    ? _buildMessage(_message.message, isMe,
                                        _message.time, _message.senderID)
                                    : _buildImageMessage(isMe, _message.message,
                                        _message.time, _message.senderID);
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).accentColor,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                _buildMessageComposer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
