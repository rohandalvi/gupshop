import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/service/customNavigators.dart';
import 'package:gupshop/service/getConversationId.dart';
import 'package:gupshop/widgets/customText.dart';
class ContactSearch extends StatefulWidget {
  bool createGroupSearch;
  final String userPhoneNo;
  final String userName;
  final data;
  final Widget Function(DocumentSnapshot item, int index) onItemFound;
  final Future<List<DocumentSnapshot>> Function(String text) onSearch;

  ContactSearch({@required this.userPhoneNo, @required this.userName, this.data, this.onItemFound, this.onSearch, this.createGroupSearch});

  @override
  _ContactSearchState createState() => _ContactSearchState(userPhoneNo: userPhoneNo, userName: userName, data: data, onItemFound: onItemFound, onSearch: onSearch, createGroupSearch: createGroupSearch);
}

class _ContactSearchState extends State<ContactSearch> {
  bool createGroupSearch;
  final String userPhoneNo;
  final String userName;
  final data;
  final Widget Function( DocumentSnapshot item, int index) onItemFound;/// make documentSnapshot dynamic
  final Future<List<DocumentSnapshot>> Function(String text) onSearch;

  List<DocumentSnapshot> list;

  _ContactSearchState(
      {@required this.userPhoneNo, @required this.userName, this.data, this.onItemFound, this.onSearch, this.createGroupSearch});

  void initState() {
    if(createGroupSearch == null) createGroupSearch=false;
    createSearchSuggestions();/// to get the list of contacts as suggestion
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<DocumentSnapshot>(
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
          suggestions: list == null ? new List() : list,
          /// as list is a future, the loading screen was
          /// throwing an error  before the list was loaded and was showing a red screen to the user.
          /// So, we are creating a placeholder new List() here till the list loads and becuase suggestions
          /// doesnt accept CircularProgressIndicator() we are using new List().
          hintText: 'Search contacts',
          hintStyle: GoogleFonts.openSans(
            //inconsolata
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          onSearch: onSearch == null? searchList : onSearch,
          onItemFound: onItemFound == null ? (DocumentSnapshot doc, int index) {
            List<dynamic> friendNo = doc.data["phone"];
            /// if it is the first time conversation the there will be no conversationId
            /// it will be created in individualChat, if a null conversationId is sent
            String conversationId = doc.data["conversationId"];
            //if(conversationId == null) GetConversationId().createNewConversationId(userPhoneNo, contactPhoneNumber)

            return ListTile(
              title: CustomText(text: doc.data["nameList"][0]),
              ///displaying on the display name
              onTap: () {
                print("friendNo in contact search : $friendNo");
                String friendName = doc.data["nameList"][0];
                print(
                    "conversationId when tapping on friendname in search: $conversationId");
                print("data in contactSearch: $data");
                if (data != null) {
                  /// forward message needs to be given searched friends conversationId
                  /// corresponding change can also be found in individualChat forwardMessage() method:
                  ///
                  /// forward messages needs to be given this conversation's conversationId:
                  ///      forwardMessage["conversationId"] = conversationId;
                  data["conversationId"] = conversationId;
                }
                //if(conversationId == null) GetConversationId().createNewConversationId(userPhoneNo, friendNo);
                CustomNavigator().navigateToIndividualChat(
                    context,
                    conversationId,
                    userName,
                    userPhoneNo,
                    friendName,
                    friendNo,
                    data);
              },
            );
          } : onItemFound,
        ),
      ),
    );
  }


  /// searchList is basically friends_number collection
  Future<List<DocumentSnapshot>> searchList(String text) async {
    var list = await Firestore.instance.collection(
        "friends_${widget.userPhoneNo}").getDocuments();

    ///right now we have a list for names, but I think this can be changed to just name,
    ///because display name includes firstname and lastname
    ///
    /// if name only is to be passed to firebase:
    /// list.documents.where((l) => l.data["name"].toLowerCase().contains(text.toLowerCase()) ||  l.documentID.contains(text)).toList();
    print("list: ${list.documents[0].data}");
    print("name in list: ${list.documents[0].data["nameList"][0]}");

    ///ToDo- here not just 0, but on every index of the list
    print("list after where: ${list.documents.where((l) =>
    l.data["nameList"][0]
        .toLowerCase()
        .contains(text.toLowerCase()) || l.documentID.contains(text))
        .toList()}");

    if(createGroupSearch){
      print("in createGroupSearch");
      return list.documents.where((l) =>
      l.data["groupName"] == null && ///to take group out of search
      l.data["nameList"][0]
          .toLowerCase()
          .contains(text.toLowerCase()) || l.documentID.contains(text)).toList();
    }

    return list.documents.where((l) =>
    l.data["nameList"][0]
        .toLowerCase()
        .contains(text.toLowerCase()) || l.documentID.contains(text)).toList();
  }


  ///we are displaying the friends collection as the suggestion.
  /// this method is called in initState
  createSearchSuggestions() async {
    var temp;
    if(createGroupSearch){
      temp = await Firestore.instance.collection("friends_$userPhoneNo")
          .where('groupName', isNull: true)
          //.orderBy("nameList", descending: false)
          .getDocuments();
      print("temp.data: ${temp.documents}");
    }
    else{
        temp = await Firestore.instance.collection("friends_$userPhoneNo")
            .orderBy("nameList", descending: false)
            .getDocuments();
    }

    var tempList = temp.documents;
    setState(() {
      list = tempList;
    });
  }
}

///FlareActor("assets/Filip.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:"idle");