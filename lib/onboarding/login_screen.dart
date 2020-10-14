import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToNameScreen.dart';
import 'package:gupshop/onboarding/name_screen.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/service/auth_service.dart';
import 'package:gupshop/widgets/countryCodeAndFlag.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customShowDialog.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customTextFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';

//LoginScreen => NameScreen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool codeSent = false;
  String val="";
  String countryCode = TextConfig.defaultCountryCode;
  String numberWithoutCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold==>Column==>Stack==>Container==>Text(Gup)
      //                         ==>Container==>Text(Shup)
      //Alternatively:
      //Scaffold==>Column==>Container==>Text(Gup)
      //                 ==>Container==>Text(Shup)
      //can also be done, but the padding alignment is much beautiful with Stack
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                    Container(
                      width: ImageConfig.welcomeScreenChatBubble,/// 200
                      height: ImageConfig.welcomeScreenChatBubble,/// 200
                      child:
                      Image(
                        image: AssetImage(ImageConfig.gupshupImage),
                      ),
                  ),
                  Container(
                    child: CustomText(text: TextConfig.gup,).welcomeTitle(),
                    padding: EdgeInsets.fromLTRB(PaddingConfig.fifteen,
                        PaddingConfig.oneTwenty, PaddingConfig.zero,
                        PaddingConfig.zero),
                    /// padding: EdgeInsets.fromLTRB(35, 110, 0, 0)==>if this is not included
                    /// then the words gup shup would be displayed in the upper left corner
                    /// of the screen
                  ),
                  Container(
                    child: CustomText(text: TextConfig.shup,).welcomeTitle(),
                    padding: EdgeInsets.fromLTRB(PaddingConfig.fifty,
                        PaddingConfig.oneNinety, PaddingConfig.zero,
                        PaddingConfig.zero),
                  )
                ],
              ),
              Row(
//                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  CountryCodeAndFlag(
                    onChanged: (value){
                      String convertedCountryCode = value.toString();
                      setState(() {
                        countryCode = convertedCountryCode;
                      });

                    },
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.25,
                      child: CustomTextFormField(
                        maxLength: 10,
                            labelText: TextConfig.enterYourNumber,
                            onChanged: (val) {
                              setState(() {
                                this.phoneNo = val;
                                this.val=val;
                                numberWithoutCode = this.val;
                              });
                            },
                          ),
                      padding: EdgeInsets.only(left: PaddingConfig.twenty,
                          top: PaddingConfig.thirtyFive,
                          right: PaddingConfig.twenty),
                    ),
                  ),
                ],
              ),
              CustomIconButton(
                onPressed: verifyphone,
                iconNameInImageFolder: IconConfig.forwardIcon,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String phoneNo, verificationId, smsCode;

  Future<void> verifyphone() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String userPhoneNo = prefs.getString('userPhoneNo');

    setState(() {
      val = countryCode + numberWithoutCode;
    });

    /// I dont think PhoneVerificationCompleted PhoneVerificationFailed is required @todo
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed = (AuthException authException) {
    };
    /// seperator


    final PhoneCodeSent smsSent = (String verId, [int forceResend]) async{
      this.verificationId = verId;

      setState(() {
        this.codeSent = true;
        UserDetails().setUserPhoneNo(val);
      });


        await smsCodeDialog(context);
        AuthCredential authCredential = PhoneAuthProvider.getCredential(verificationId: this.verificationId, smsCode: this.smsCode);

        FirebaseAuth.instance.signInWithCredential(authCredential).then( (user) {
          //Navigator.of(context).pushNamed('loggedIn');

          NavigateToNameScreen(userPhoneNo: val).navigateNoBrackets(context);

        }).catchError((e) {
          CustomFlushBar(
            customContext: context,
            text: CustomText(text: 'Wrong verification code',),
            message: 'Please enter your name to move forward',
          ).showFlushBarStopHand();
        });
    };



    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: val,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }



  smsCodeDialog(BuildContext context) async{
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: CustomText(text: 'Enter sms code',),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child:CustomText(text: 'Ok',),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}