import 'dart:io';

import 'package:UserRegistration/userform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/sanitizers.dart';

import 'datamanger.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final DbUserManager dbUserManager = new DbUserManager();
  List<User> userList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      body: Container(
        // margin: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: dbUserManager.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    userList = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: userList == null ? 0 : userList.length,
                      itemBuilder: (BuildContext context, int index) {
                        User userIterate = userList[index];
                        return Card(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          "Name : ${userIterate.name}"),

                                                      Row(
                                                        children: <Widget>[
                                                           Text("Color: ${userIterate.color} "),
                                                          // Text(("0x"+"${userIterate.color.toUpperCase()}")),

                                                          CircleAvatar(
                                                            radius: 10.0,
                                                            backgroundColor:
                                                                // Color(0xFFF44336)
                                                                Color(int.parse( "${'FF'+userIterate.color.substring(0).toUpperCase()}",radix: 16)),
                                                          ),
                                                        ],
                                                      )

                                                      // Text(
                                                      //     "Address : ${userIterate.address}"),
                                                      // Text(
                                                      //     "Hobby : ${userIterate.hobby}"),
                                                      // Text(
                                                      //     "color : ${userIterate.color}"),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Text("Image"),
                                                    Image.file(
                                                      File(
                                                          '${userIterate.image.substring(7, userIterate.image.length - 1)}'),
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              RaisedButton(
                                child: Text("Edit"),
                                onPressed: () => {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => UserForm(
                                          index: index, user: userIterate))),
                                },
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return new Text("No Data Found");
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserForm())),
      ),
    );
  }
}
