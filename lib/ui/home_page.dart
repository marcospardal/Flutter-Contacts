import 'dart:io';

import 'package:contacts/helpers/contact_helper.dart';
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

    setState(() {
      helper.getAllContacts().then((list) {
        contacts = list;
      });
    });
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
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? '',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
        onPressed: () {},
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
