import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/screens/bazaarProfilePage.dart';

class SideMenu extends StatelessWidget {
  String userName;
  SideMenu({@required this.userName});

  @override
  Widget build(BuildContext context) {
      return Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(userName,style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),),
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
}
