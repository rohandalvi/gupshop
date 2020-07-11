import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/service/customNavigators.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomSearch<T> extends StatelessWidget {
  String userName;
  String userPhoneNo;
  List<T> suggestions;
  final Future<List<T>> Function(String text) onSearch;
  final Widget Function(T item, int index) onItemFound;
  final String hintText;

  CustomSearch({this.userName, this.userPhoneNo, this.suggestions, this.onSearch, this.onItemFound, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<T>(
          searchBarPadding: EdgeInsets.all(10),
          emptyWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: ':( This name does not match your contacts ',),
          ),
          cancellationWidget: IconButton( /// cancel button
            icon: SvgPicture.asset('images/cancel.svg',),
            /// onPressed is taken care by the cancellationWidget
          ),
          icon: GestureDetector(
            onTap: () { /// back arrow
              CustomNavigator().navigateToHome(context, userName, userPhoneNo);
            },
            child: SvgPicture.asset('images/backArrowColor.svg',
              width: 35,
              height: 35,
              //placeholderBuilder: CircularProgressIndicator(),
            ),
          ),
          minimumChars: 1,/// minimum characters to enter to start the search
          loader: CircularProgressIndicator(),
          suggestions: suggestions,
          hintText: hintText,
          hintStyle: GoogleFonts.openSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          onSearch: onSearch,
          onItemFound: onItemFound,
        ),
      ),
    );
  }
}
