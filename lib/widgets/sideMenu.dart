
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/bazaar/bazaarProfilePage.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/image/displayAvatar.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  String userName;

  SideMenu({@required this.userName});

  @override
  SideMenuState createState() => SideMenuState(userName: userName);
}

class SideMenuState extends State<SideMenu> {
  String userPhoneNo;
  String userName;

  SideMenuState({@required this.userName});

  @override
  void initState() {
    getUserPhone();
    super.initState();
  }

  Future<void> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPhoneNoInGetUserPhone = prefs.getString('userPhoneNo');
    setState(() {
      userPhoneNo = userPhoneNoInGetUserPhone;
    });
    print("userPhoneNo: $userPhoneNo");
    print("prefs: $prefs");
  }

  @override
  Widget build(BuildContext context) {
    print("userPhoneNo sideMenu build :$userPhoneNo");
      return Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(widget.userName,style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),),
              currentAccountPicture: GestureDetector(
                onTap: (){
                  print("profile picture clicked");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeProfilePicture(userName: userName,),//pass Name() here and pass Home()in name_screen
                      )
                  );
                },
                child: DisplayAvatar().getProfilePicture(userPhoneNo, 35),
                //getProfilePicture(userPhoneNo),//Todo- use Profile picture class getUserProfilePicture()
//                StreamBuilder(
//                  stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
//                  builder: (context, snapshot) {
//                    if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
//                    print("imageUrl in sideMenu: ${snapshot.data['url']}");
//                    String imageUrl = snapshot.data['url'];
//                    return Container(
////                      height:
////                      MediaQuery.of(context).size.height / 1.25,
////                      width:
////                      MediaQuery.of(context).size.width / 1.25,
////                      child: Image(
////                        image: Image.network(snapshot.data),
////                      ),
//                      decoration: new BoxDecoration(
//                        shape: BoxShape.circle,
//                        image: new DecorationImage(
//                            image: NetworkImage(imageUrl),
//                            //new AssetImage('images/sampleProfilePicture.jpeg'),
//                        )
//                      ),
//                    );
//                  }
//                ),
              ),
            ),
            SizedBox(height: 5,),
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BazaarProfilePage(),//pass Name() here and pass Home()in name_screen
                    )
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('Become a Bazaar wala',style: GoogleFonts.openSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),),
              ),
            ),
          ],
        ),
      );
  }

//  getProfilePicture(String userPhoneNo){
//    String imageUrl;
//    print("friendNo in getProfilePicture(): $userPhoneNo");
//    DocumentReference isProfilePictureAdded = Firestore.instance.collection("profilePictures").document(userPhoneNo);
//    print("isProfilepictureAdded: ${isProfilePictureAdded.snapshots()}");
//    return StreamBuilder(
//                  stream: Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots(),
//                  builder: (context, snapshot) {
////                    print("snapshot in getProfilePic: ${snapshot.data['url']}");
//                    if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter do
//                    print("imageUrl in sideMenu: ${snapshot.data['url']}");
//                    imageUrl = snapshot.data['url'];
//                    return
////                        CircleAvatar(
////                          radius: 35,
////                          backgroundImage: NetworkImage(imageUrl),
////                        );
//
//                      DisplayPicture(
//                      height: 370,
//                      width: 370,
//                      image: NetworkImage(imageUrl),
//                    ).smallSizePicture(35);
//
//
////                      Container(
//////                      height:
//////                      MediaQuery.of(context).size.height / 1.25,
//////                      width:
//////                      MediaQuery.of(context).size.width / 1.25,
//////                      child: Image(
//////                        image: Image.network(snapshot.data),
//////                      ),
////                      decoration: new BoxDecoration(
////                        shape: BoxShape.circle,
////                        image: imageUrl==null?  new DecorationImage(
////                          image: AssetImage('images/sampleProfilePicture.jpeg'),
////                          fit: BoxFit.cover,
////                          //new AssetImage('images/sampleProfilePicture.jpeg'),
////                        ):
////                        new DecorationImage(
////                            image: NetworkImage(imageUrl),
////                          fit: BoxFit.cover,
////                            //new AssetImage('images/sampleProfilePicture.jpeg'),
////                        ),
////                      ),
////                    );
//                  }
//                );
//  }


}
