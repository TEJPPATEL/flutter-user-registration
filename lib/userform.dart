import 'dart:io';
import 'package:UserRegistration/datamanger.dart';
import 'package:UserRegistration/userlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'navigator.dart';

class UserForm extends StatefulWidget {
  final User user;
  final int index;
  UserForm({this.user, this.index});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  Color pickerColor = Colors.green;
  Color currentColor = Colors.green;
  File _image;
  Position _currentPosition;
  final picker = ImagePicker();

  final DbUserManager dbUserManager = new DbUserManager();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _dropdownControll = "Reading";
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String _currentAddress = " ";
  String _dob = new DateTime.now().toString().split(' ')[0];

  String valueString;
  User user;

  final _formKey = new GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      print(_image);
      print(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    valueString = currentColor
        .toString()
        .split('(0xff')[1]
        .split(')')[0]; // kind of hacky..
    print(currentColor.toString());
    // int valueColor = int.parse(valueString, radix: 16);
    return Scaffold(
        appBar: AppBar(
          title: Text("User Form"),
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
//            Text("Form")
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: TextFormField(
                        initialValue: this.user != null ? this.user.name : null,
                        validator: (val) =>
                            val.isNotEmpty ? null : 'Name should not be empty',
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          // validator :
                        ),
                        onChanged: (value) => {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: TextFormField(
                        validator: (val) =>
                            val.isNotEmpty ? null : 'Name should not be empty',
                        controller: _addressController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.home),
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                          // validator :
                        ),
                        onChanged: (value) => {},
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Row(children: <Widget>[
                        Text("Hobby"),
                        SizedBox(
                          width: 20,
                        ),
                        DropdownButton<String>(
                          hint: Text("Select Your hobby"),
                          value: _dropdownControll,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              _dropdownControll = newValue;
                            });
                          },
                          items: <String>[
                            'Reading',
                            'Playing',
                            'Dancing',
                            'Cooking'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ]),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Row(children: <Widget>[
                        Text("DOB"),
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child: Text("Pick Date"),
                          onPressed: () => _selctedDate(),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(_dob),
                      ]),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Row(children: <Widget>[
                        Text("Color"),
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton(
                          color: currentColor,
                          child: Text("Pick Color"),
                          onPressed: () => _colorpicker(),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(valueString),
                      ]),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Row(children: <Widget>[
                        Text("Image"),
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton(
                          color: currentColor,
                          child: Text("Pick Image"),
                          onPressed: () => getImage(),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        _image == null
                            ? Text("No Image")
                            : Image.file(
                                _image,
                                width: 120,
                                height: 120,
                              ),
                      ]),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              FlatButton(
                                child: Text("Get location"),
                                onPressed: () {
                                  _getCurrentLocation();
                                },
                              ),
                              FlatButton(
                                child: Text("Location Via Map"),
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NavigatorMap()))
                                },
                              ),
                            ],
                          ),
                          Text(_currentAddress)
                          //  if (_currentPosition != null) {
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: MaterialButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Container(
                            child: Text(
                              "SAVE",
                              textAlign: TextAlign.center,
                            ),
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                          onPressed: () => {
                                _submitUser(context),
                              }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  _submitUser(context) {
    print(currentColor);
    if (_formKey.currentState.validate()) {
      if (user == null) {
        User user = new User(
            name: _nameController.text,
            address: _addressController.text,
            hobby: _dropdownControll,
            color: valueString,
            image: _image.toString());
        print(currentColor);
        dbUserManager.insertUser(user).then((id) => {
              _nameController.clear(),
              _addressController.clear(),
              print('User Added ${id}'),
              print(user.name),
              print(user.image)
              // print(currentColor)
              //      print(user.id)
            });

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserList()));
      } else {
        _nameController.value = TextEditingValue(text: user.name);
        _addressController.value = TextEditingValue(text: user.address);
      }
    }
  }

  _selctedDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2021));
    if (picked != null) {
      setState(() {
        _dob = picked.toString().split(' ')[0];
      });
    }
  }

  _colorpicker() {
    // raise the [showDialog] widget
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Pick a color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            showLabel: true,
            onColorChanged: (Color colorvalue) {
              pickerColor = colorvalue;
            },
            // onColorChanged: (color) => {setState(() => pickerColor = color)},
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            child: Text("Got It"),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) => {print(e)});
  }

  _getAddressFromLatLng() async {
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);

    Placemark place = p[0];

    setState(() {
      _currentAddress = "${place.country}";
    });
  }
}
