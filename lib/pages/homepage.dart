import 'package:chatchat/helper/helper_function.dart';
import 'package:chatchat/pages/loginpage.dart';
import 'package:chatchat/pages/profilepage.dart';
import 'package:chatchat/pages/searchpage.dart';
import 'package:chatchat/services/auth_services.dart';
import 'package:chatchat/services/database_service.dart';
import 'package:chatchat/widgets/group_tile.dart';
import 'package:chatchat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  String email = "";
  AuthServices authServices = AuthServices();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    geetingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  geetingUserData() async {
    await HelperFunction.getEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });

// geeting the list of snapshot in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, SearchPage());
              },
              icon: const Icon(
                Icons.search_outlined,
                size: 35,
              ))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Groups",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(height: 15),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreen(
                    context,
                    ProfilePage(
                      userName: userName,
                      email: email,
                    ));
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person_2),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await authServices.signout();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              )),
                        ],
                      );
                    });
                //authServices.signout().whenComplete(() {
                //nextScreenReplace(context, const LoginScreen());
                //});
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Create a new group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20))),
                      )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (groupName != "") {
                    setState(() {
                      _isLoading = true;
                    });
                    DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                    showSnaksbar(
                        context, Colors.green, "Group created successfully");
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text("Create"),
              )
            ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks

        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, Index) {
                    int reverceIndex =
                        snapshot.data['groups'].length - Index - 1;
                    return GroupTile(
                        groupId: getId(snapshot.data["groups"][reverceIndex]),
                        groupName:
                            getName(snapshot.data["groups"][reverceIndex]),
                        userName: snapshot.data['fullName']);
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey,
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "you've not join any grop tap on join button or search for groups...",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
