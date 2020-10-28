import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToNameScreen.dart';
import 'package:gupshop/notifications/application/notifier.dart';
import 'package:gupshop/onboarding/name_screen.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: SafeArea(
              top: true,
              child: Container(
                width: ImageConfig.oneTwentyFive,/// 75 /// 200
                height: ImageConfig.oneTwentyFive,/// 75 /// 200
                child:
                Image(
                  image: AssetImage(ImageConfig.gupshupImage),
                ),
                ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Container(
              child: CustomText(text: TextConfig.gup,).welcomeTitle(),
//                    padding: EdgeInsets.fromLTRB(PaddingConfig.fifteen,
//                        PaddingConfig.oneTwenty, PaddingConfig.zero,
//                        PaddingConfig.zero),
              /// padding: EdgeInsets.fromLTRB(35, 110, 0, 0)==>if this is not included
              /// then the words gup shup would be displayed in the upper left corner
              /// of the screen
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Container(
              child: CustomText(text: TextConfig.shup,).welcomeTitle(),
//                    padding: EdgeInsets.fromLTRB(PaddingConfig.fifty,
//                        PaddingConfig.oneNinety, PaddingConfig.zero,
//                        PaddingConfig.zero),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Row(
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
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: CustomIconButton(
              onPressed: verifyphone,
              iconNameInImageFolder: IconConfig.forwardIcon,
            ),
          ),
        ],
      ),
    );
  }

  String phoneNo, verificationId, smsCode;

  Future<void> verifyphone() async {

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
          Map<String,dynamic> navigatorMap = new Map();
          navigatorMap[TextConfig.userPhoneNo] = val;

          Navigator.pushNamed(context, NavigatorConfig.nameScreen, arguments: navigatorMap);
         // NavigateToNameScreen(userPhoneNo: val).navigateNoBrackets(context);
        }).catchError((e) {
          CustomFlushBar(
            customContext: context,
            text: CustomText(text: TextConfig.wrongVerificationCode,),
            message: TextConfig.wrongVerificationCode,
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
            title: CustomText(text: TextConfig.enterSMSCode,),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child:CustomText(text: TextConfig.ok,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}