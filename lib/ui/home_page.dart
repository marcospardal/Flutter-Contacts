import 'dart:io';

import 'package:contacts/helpers/contact_helper.dart';
import 'package:contacts/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
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
        return 'Friends';
    }
  }

  Icon _getIcon(String icon) {
    switch (icon) {
      case 'work':
        return Icon(Icons.work);
      case 'people':
        return Icon(Icons.people);
      case 'family':
        return Icon(Icons.family_restroom);
      case 'school':
        return Icon(Icons.school);
      default:
        return Icon(Icons.people);
    }
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts[index].image != null
                            ? FileImage(File(contacts[index].image))
                            : AssetImage("images/user.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? '',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RobotoSlab',
                          color: Colors.pink[800]),
                    ),
                    Text(
                      contacts[index].email ?? '',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? '',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        _getIcon(contacts[index].icon),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            _getIconLabel(contacts[index].icon),
                            style: TextStyle(
                                color: Colors.pink[800],
                                fontFamily: 'RobotoSlab'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
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
                        onPressed: () {},
                        color: Colors.green[700],
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Call",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                        color: Colors.blue[900],
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Edit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )),
                    FlatButton(
                        onPressed: () {
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        color: Colors.red[900],
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Icon(
                                Icons.delete,
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

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
    }

    _getAllContacts();
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90,
        elevation: 0,
        title: Text(
          "Contacts",
          style: TextStyle(
              fontFamily: 'RobotoSlab', fontSize: 30, color: Colors.pink[800]),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Icon(
              Icons.menu,
              color: Colors.pink[800],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink[800],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
        itemCount: contacts.length,
        padding: EdgeInsets.all(10),
      ),
    );
  }
}
