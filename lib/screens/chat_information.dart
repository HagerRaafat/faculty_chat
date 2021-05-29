import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui_starter/models/chat.dart';
import 'package:flutter_chat_ui_starter/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_ui_starter/models/contact.dart';
import 'package:flutter_chat_ui_starter/services/database_service.dart';

// ignore: must_be_immutable
class ChatInformation extends StatefulWidget {
  String chatID;
  String chatImage;
  String chatName;

  ChatInformation({this.chatID, this.chatImage, this.chatName});

  @override
  _ChatInformationState createState() => _ChatInformationState();
}

class _ChatInformationState extends State<ChatInformation> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: Builder(
            builder: (BuildContext context) {
              return StreamBuilder<Chat>(
                stream: DatabaseService.instance.getChat(this.widget.chatID),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  var chatData = snapshot.data;

                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                        height: 170.0,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60.0,
                              backgroundImage:
                                  NetworkImage(this.widget.chatImage),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              this.widget.chatName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          left: 20.0,
                          bottom: 20.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 27.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Course Professor',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  chatData.admin,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.group,
                              color: Colors.grey,
                              size: 27.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Students',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 5.0,
                                  ),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: ListView.builder(
                                      itemCount: chatData.members.length,
                                      itemBuilder:
                                          (BuildContext context, int _index) {
                                        var _members = chatData.members[_index];

                                        return StreamBuilder<Contact>(
                                            stream: DatabaseService.instance
                                                .getUserData(_members),
                                            builder: (context, snapshot) {
                                              var _member = snapshot.data;

                                              return _member != null
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.all(2.0),
                                                      child: Container(
                                                        child: Text(
                                                          _member.fullName,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Text('');
                                            });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
