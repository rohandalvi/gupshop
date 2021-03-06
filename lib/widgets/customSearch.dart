import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomSearch<T> extends StatelessWidget {
  final String noResultsText;
  String userName;
  String userPhoneNo;
  List<T> suggestions;
  final Future<List<T>> Function(String text) onSearch;
  final Widget Function(T item, int index) onItemFound;
  final String hintText;
  final GestureTapCallback backButton;

  CustomSearch({this.userName, this.userPhoneNo, this.suggestions, this.onSearch,
    this.onItemFound, this.hintText, this.backButton, this.noResultsText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<T>(
          searchBarPadding: EdgeInsets.all(PaddingConfig.ten),
          emptyWidget: Padding(
            padding: EdgeInsets.all(PaddingConfig.eight),
            child: CustomText(
              text: noResultsText == null ? ':( This name does not match your contacts ' : noResultsText,
            ),
          ),
          cancellationWidget: CustomIconButton(iconNameInImageFolder: IconConfig.cancel,),
          icon: CustomIconButton(
            iconNameInImageFolder: IconConfig.backArrow,
            onPressed: backButton == null ? () { /// back arrow
              CustomNavigator().navigateToHome(context, userName, userPhoneNo);
            } : backButton,
          ),
          minimumChars: 1,/// minimum characters to enter to start the search
          loader: Center(child: CircularProgressIndicator()),
          suggestions: suggestions,
          hintText: hintText,
          hintStyle: GoogleFonts.openSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: WidgetConfig.standardFontSize,
            ),
          ),
          onSearch: onSearch,
          onItemFound: onItemFound,
        ),
      ),
    );
  }
}
