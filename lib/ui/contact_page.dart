import 'dart:io';

import 'package:contacts/helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _userEdited = false;
  Contact _editedContact;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  String _getIconLabel(String icon) {
    switch (icon) {
      case 'work':
        return 'Work';
      case 'people':
        return 'Friends';
      case 'family':
        return 'Family';
      case 'school':
        return 'School';
      default:
        return '';
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Discard Changes?",
                style: TextStyle(
                    color: Colors.pink[800], fontFamily: 'RobotoSlab'),
              ),
              content: Text("If you leave now, all changes will be lost."),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.pink[800]),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    color: Colors.pink[800],
                    child: Text(
                      "Leave",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          ImagePicker.pickImage(source: ImageSource.camera)
                              .then((file) {
                            if (file == null) return;
                            setState(() {
                              _editedContact.image = file.path;
                            });
                          });
                          Navigator.pop(context);
                        },
                        color: Colors.pink[800],
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Camera",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Icon(
                                Icons.camera,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )),
                    FlatButton(
                        onPressed: () {
                          ImagePicker.pickImage(source: ImageSource.gallery)
                              .then((file) {
                            if (file == null) return;
                            setState(() {
                              _editedContact.image = file.path;
                            });
                          });
                          Navigator.pop(context);
                        },
                        color: Colors.pink[800],
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Gallery",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Icon(
                                Icons.photo_album,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink[800],
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              _editedContact.name ?? 'New Contact',
              style: TextStyle(color: Colors.white, fontFamily: 'RobotoSlab'),
            ),
            centerTitle: true,
          ),
          floatingActionButton: Container(
            height: 50,
            width: 100,
            child: FloatingActionButton(
              onPressed: () {
                if (_editedContact.name != null &&
                    _editedContact.name.isNotEmpty) {
                  Navigator.pop(context, _editedContact);
                } else {
                  FocusScope.of(context).requestFocus(_nameFocus);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'RobotoSlab',
                    fontSize: 20),
              ),
              backgroundColor: Colors.pink[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _editedContact.image != null
                                ? FileImage(File(_editedContact.image))
                                : AssetImage("images/user.png"))),
                  ),
                  onTap: () {
                    _showOptions(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(
                                color: Colors.pink[800],
                                fontFamily: 'RobotoSlab'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (text) {
                            setState(() {
                              _userEdited = true;
                              _editedContact.name = text;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: Colors.pink[800],
                                fontFamily: 'RobotoSlab'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (text) {
                            _userEdited = true;
                            _editedContact.email = text;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            labelStyle: TextStyle(
                                color: Colors.pink[800],
                                fontFamily: 'RobotoSlab'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (text) {
                            _userEdited = true;
                            _editedContact.phone = text;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: IconButton(
                                icon: Icon(Icons.work),
                                onPressed: () {
                                  setState(() {
                                    _editedContact.icon = 'work';
                                  });
                                },
                                iconSize: 40,
                                color: _editedContact.icon == 'work'
                                    ? Colors.pink[800]
                                    : Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: IconButton(
                                icon: Icon(Icons.people),
                                onPressed: () {
                                  setState(() {
                                    _editedContact.icon = 'people';
                                  });
                                },
                                iconSize: 40,
                                color: _editedContact.icon == 'people'
                                    ? Colors.pink[800]
                                    : Colors.grey),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: IconButton(
                                  icon: Icon(Icons.family_restroom),
                                  onPressed: () {
                                    setState(() {
                                      _editedContact.icon = 'family';
                                    });
                                  },
                                  iconSize: 40,
                                  color: _editedContact.icon == 'family'
                                      ? Colors.pink[800]
                                      : Colors.grey)),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: IconButton(
                                icon: Icon(Icons.school),
                                onPressed: () {
                                  setState(() {
                                    _editedContact.icon = 'school';
                                  });
                                },
                                iconSize: 40,
                                color: _editedContact.icon == 'school'
                                    ? Colors.pink[800]
                                    : Colors.grey),
                          )
                        ],
                      ),
                      Text(
                        _getIconLabel(_editedContact.icon),
                        style: TextStyle(
                            color: Colors.pink[800],
                            fontSize: 35,
                            fontFamily: 'RobotoSlab'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
