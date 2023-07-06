import 'package:flutter/material.dart';
import 'package:my_tiffin/globalVariables/globleVariable.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //drawer header
          Container(
            padding: const EdgeInsets.only(top: 25,bottom:10),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const  EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage:NetworkImage(
                            sharedPreferences!.getString('photoUrl')!
                        ) ,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  sharedPreferences!.getString('name')!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily:'Train',
                  ),
                ),
              ],

          )
          ),
          const SizedBox(height: 12,),
          //body of container
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              children: [
                const Divider(
                  height: 18,
                    color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.home,color: Colors.black,),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){

                  },

                ),
                ListTile(
                  leading: const Icon(Icons.reorder ,color: Colors.black,),
                  title: const Text(
                    'My Order',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){

                  },

                ),
                ListTile(
                  leading: const Icon(Icons.access_time,color: Colors.black,),
                  title: const Text(
                    'History',
                    style: TextStyle(color: Colors.black),
                  ),
             onTap: (){

             },

                ),
             ListTile(
                  leading: const Icon(Icons.search,color: Colors.black,),
                  title: const Text(
                    'Search',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){

                  },

                ),
                ListTile(
                  leading:  const Icon(Icons.add_location,color: Colors.black,),
                  title: const Text(
                    'Add new Address',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){

                  },
                ),
                 ListTile(
                  leading: const Icon(Icons.exit_to_app,color: Colors.black,),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){

                  },

                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}