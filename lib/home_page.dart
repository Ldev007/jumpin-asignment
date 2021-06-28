import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumpin_assignment/person_model.dart';
import 'package:jumpin_assignment/profile_frame.dart';

import 'loading_widget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double filterBoxHeight = 0;
  Icon selectedIcon = Icon(
    Icons.check_circle_outline_rounded,
    size: 25,
  );
  Icon unselectedIcon = Icon(
    Icons.add_circle_outline_rounded,
    size: 25,
  );

  List<bool> interestSelectedOrNot = [];
  List<PersonModel> profiles = [];
  List<PersonModel> allProfiles = [];

  List<String> selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('People'),
        leading: IconButton(
          icon: Icon(Icons.filter_alt_rounded),
          onPressed: () {
            setState(() {
              filterBoxHeight = filterBoxHeight == 0 ? MediaQuery.of(context).size.height * 0.3 : 0;
            });
          },
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.teal[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              content: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Text(
                    'Tap on each profile to see their interests',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Icon(
          Icons.info_outline_rounded,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: rootBundle.loadString(
            'assets/profiles.json',
          ),
          builder: (ctx, profileSnap) {
            if (profileSnap.hasData) {
              dynamic data = json.decode(
                profileSnap.data.toString(),
              );

              if (allProfiles.isEmpty) {
                allProfiles = data['profiles']
                    .map<PersonModel>(
                      (jsonElement) => PersonModel.fromJSON(jsonElement),
                    )
                    .toList();
              }

              if (selectedInterests.isEmpty) {
                profiles = allProfiles;
              }

              if (interestSelectedOrNot.isEmpty) {
                data['all_interests'].forEach(
                  (val) => interestSelectedOrNot.add(false),
                );
              }

              return Column(
                children: [
                  AnimatedContainer(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    duration: Duration(milliseconds: 500),
                    height: filterBoxHeight,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: filterBoxHeight > 0
                          ? [
                              Text(
                                'Choose filter',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Divider(
                                height: 10,
                                indent: MediaQuery.of(context).size.width * 1,
                                endIndent: MediaQuery.of(context).size.width * 1,
                              ),
                              Expanded(
                                child: Wrap(
                                  runSpacing: 5,
                                  spacing: 10,
                                  verticalDirection: VerticalDirection.down,
                                  children: List.generate(
                                    data['all_interests'].length,
                                    (i) => Chip(
                                      backgroundColor: Colors.teal[300],
                                      deleteIconColor: Colors.white,
                                      labelStyle: TextStyle(color: Colors.white),
                                      deleteIcon: interestSelectedOrNot[i] ?? false ? selectedIcon : unselectedIcon,
                                      onDeleted: () {
                                        setState(() {
                                          interestSelectedOrNot[i] = !interestSelectedOrNot[i];
                                          if (interestSelectedOrNot[i]) {
                                            selectedInterests.add(data['all_interests'][i]);
                                          } else {
                                            selectedInterests.remove(data['all_interests'][i]);
                                          }

                                          if (selectedInterests.isNotEmpty) {
                                            profiles = filterByInterest(
                                              selectedInterests: selectedInterests,
                                              unfilteredProfiles: allProfiles,
                                            );
                                          }
                                        });
                                      },
                                      label: Text(
                                        data['all_interests'][i].toString(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : [],
                    ),
                  ),
                  Expanded(
                    child: profiles.isNotEmpty
                        ? ListView.builder(
                          
                            itemCount: profiles.length,
                            itemBuilder: (ctx, i) => Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.teal,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: ExpansionTile(
                                backgroundColor: Colors.teal[100],
                                tilePadding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * 0.05,
                                  vertical: MediaQuery.of(context).size.height * 0.01,
                                ),
                                leading: ProfilePicFrame(
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(profiles[i].imgURL),
                                  ),
                                ),
                                title: Text(
                                  profiles[i].name,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                subtitle: Text('Age: ${profiles[i].age}'),
                                children: [
                                  Wrap(
                                    spacing: MediaQuery.of(context).size.width * 0.02,
                                    children: List.generate(
                                      profiles[i].interests.length,
                                      (index) => Chip(
                                        backgroundColor: Colors.teal[300],
                                        labelStyle: TextStyle(color: Colors.white),
                                        label: Text(
                                          profiles[i].interests[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              'No one has selcted the choosen interests combination yet !',
                            ),
                          ),
                  ),
                ],
              );
            } else if (profileSnap.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            } else {
              return Center(
                child: Text(
                  'Some unknown error occured !',
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<PersonModel> filterByInterest({List<String> selectedInterests, List<PersonModel> unfilteredProfiles}) {
    List<PersonModel> filteredProfiles = [];
    filteredProfiles = unfilteredProfiles.where((profile) {
      bool s = true;
      for (String selectedInterest in selectedInterests) {
        s = profile.interests.contains(selectedInterest);
        if (s == false) {
          break;
        } else {
          continue;
        }
      }
      return s;
    }).toList();
    return filteredProfiles;
  }
}
