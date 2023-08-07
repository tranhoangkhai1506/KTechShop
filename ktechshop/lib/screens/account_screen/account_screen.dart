import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/change_password/change_password.dart';
import 'package:ktechshop/screens/edit_profile/edit.profile.dart';
import 'package:ktechshop/screens/favourite_screen/favourite_screen.dart';
import 'package:ktechshop/screens/order_screen/order_screen.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('Profile',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      appProvider.getUserInformation.image == null
                          ? Icon(
                              Icons.person_outlined,
                              size: 80,
                            )
                          : CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                  appProvider.getUserInformation.image!)),
                      Text(appProvider.getUserInformation.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(appProvider.getUserInformation.email,
                          style: TextStyle(
                            fontSize: 14,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: SizedBox(
                          width: 150,
                          child: PrimaryButton(
                              onPressed: () {
                                Routes.instance.push(
                                    widget: EditProfile(), context: context);
                              },
                              title: "Edit Profile"),
                        ),
                      )
                    ],
                  ),
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding * 2, bottom: kDefaultPadding * 3),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Routes.instance
                                .push(widget: OrderScreen(), context: context);
                          },
                          leading: Icon(Icons.shopping_bag_outlined),
                          title: Text("Your Orders"),
                        ),
                        ListTile(
                          onTap: () {
                            Routes.instance.push(
                                widget: FavouriteScreen(), context: context);
                          },
                          leading: Icon(Icons.favorite_outline),
                          title: Text("Favourites"),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(Icons.people_alt_outlined),
                          title: Text("About Us"),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(Icons.support_agent_outlined),
                          title: Text("Support"),
                        ),
                        ListTile(
                          onTap: () {
                            Routes.instance.push(
                                widget: ChangePassword(), context: context);
                          },
                          leading: Icon(Icons.key_outlined),
                          title: Text("Change Password"),
                        ),
                        ListTile(
                          onTap: () {
                            FirebaseAuthHelper.instance.signOut();
                            setState(() {});
                            // Routes.instance
                            //     .push(widget: Welcome(), context: context);
                          },
                          leading: Icon(Icons.logout_outlined),
                          title: Text("Log out"),
                        ),
                        Text("Version 1.0.0"),
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }
}
