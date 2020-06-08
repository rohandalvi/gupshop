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
import 'package:gupshop/widgets/customText.dart';



class ContactSearch extends StatefulWidget {
  final String userPhoneNo;
  final String userName;
  final data;

  ContactSearch({@required this.userPhoneNo, @required this.userName, this.data});

  @override
  _ContactSearchState createState() => _ContactSearchState(userPhoneNo: userPhoneNo, userName: userName, data: data);
}

class _ContactSearchState extends State<ContactSearch> {
  final String userPhoneNo;
  final String userName;
  final data;

  List<DocumentSnapshot> list;

  _ContactSearchState({@required this.userPhoneNo, @required this.userName, this.data});

  void initState() {
    print("in initsate");
    //futureOfCreateSearchSuggestions();
    //waitToCreateFriendsCollection();
    super.initState();
    //CreateFriendsCollection(userName: userName, userPhoneNo: userPhoneNo,).getUnionContacts();
    //createSearchSuggestions();//to get the list of contacts as suggestion
    print("data in initstate of contactSearch: $data");
  }

  getFriendNo(String conversationId) async{
     return await ChatListState().getFriendPhoneNo(conversationId, widget.userPhoneNo);
  }


  @override
  Widget build(BuildContext context) {
    //createSearchSuggestions();
    print("in build");
    print("userName in contactSearch: $userName");
    return Scaffold(
      body: SafeArea(
        child: SearchBar<DocumentSnapshot>(
          searchBarPadding: EdgeInsets.all(10),
          emptyWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(text: ':( This name does not match your contacts ',),
          ),
          cancellationWidget: IconButton(
            icon: SvgPicture.asset('images/cancel.svg',),
            /// onPressed is taken care by the cancellationWidget
          ),
          icon: GestureDetector(
            onTap: (){
              CustomNavigator().navigateToHome(context, userName, userPhoneNo);
            },
            child: SvgPicture.asset('images/backArrowColor.svg',
              width: 35,
              height: 35,
              //placeholderBuilder: CircularProgressIndicator(),
            ),
          ),
          minimumChars: 1,//minimum characters to enter to start the search
          //suggestions:list,
          //createSuggestionList(),
          //list,///this is giving error as we need to build this from future but this
          hintText: 'Search contacts',
          hintStyle: GoogleFonts.openSans(
            //inconsolata
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          onSearch: searchList,
          onItemFound: (DocumentSnapshot doc, int index){
            print("DocumentSnapshot doc: $doc");
            String conversationId = doc.data["conversationId"];
            print("conversationId: $conversationId");
            String friendNo;

            //friendNo =  await getFriendNo(conversationId);

            return ListTile(
              leading: SizedBox(
                width: 0,
//                height: 0,
                child: FutureBuilder(
                  future: getFriendNo(conversationId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {

                    print("snapshot in listtile: ${snapshot.data}");
                    if(snapshot.connectionState == ConnectionState.done) {
                      print("snapshot.data: ${snapshot.data}");
                      friendNo = snapshot.data;
                    }
                    return Container();
                  },
                )
                ,
              ),
              title: CustomText(text:doc.data["nameList"][0]),///displaying on the display name
              onTap: () {
                print("friendNo in contact search : $friendNo");
                String friendName = doc.data["name"];
                print("data in contactSearch: $data");
                    CustomNavigator().navigateToIndividualChat(context, conversationId, userName, userPhoneNo, friendName, friendNo, data  );
                  },
            );
          },
        ),
      ),
    );
  }


   Future<List<DocumentSnapshot>> searchList(String text) async {
     var list = await Firestore.instance.collection("friends_${widget.userPhoneNo}").getDocuments();
     ///right now we have a list for names, but I think this can be changed to just name,
     ///because display name includes firstname and lastname
     ///
     /// if name only is to be passed to firebase:
     /// list.documents.where((l) => l.data["name"].toLowerCase().contains(text.toLowerCase()) ||  l.documentID.contains(text)).toList();
     print("list: ${list.documents[0].data}");
     print("name in list: ${list.documents[0].data["nameList"][0]}");

     ///ToDo- here not just 0, but on every index of the list
     print("list after where: ${list.documents.where((l) => l.data["nameList"][0].toLowerCase().contains(text.toLowerCase()) ||  l.documentID.contains(text)).toList()}");

    return list.documents.where((l) => l.data["nameList"][0].toLowerCase().contains(text.toLowerCase()) ||  l.documentID.contains(text)).toList();
  }



  ///we are displaying the friends collection as the suggestion.
  ///But since, suggestion in SearchBar requires a List and not
  createSearchSuggestions() async{
    print("in getContactsList");
    var temp= await Firestore.instance.collection("friends_$userPhoneNo").getDocuments();
    print("temp: $temp");
    var tempList = temp.documents;
    print("tempList: $tempList");
    setState(() {
      list = tempList;
      print("in setState");
    });

  }


  createSuggestionList() async{
    var temp= await Firestore.instance.collection("friends_$userPhoneNo").getDocuments();
    return temp.documents;
  }

//  listFutureBuilder(){
//    return FutureBuilder(
//      future: Firestore.instance.collection("friends_$userPhoneNo").getDocuments(),
//      builder: (context, snapshot){
//        if(snapshot.connectionState == ConnectionState.done){
//          return snapshot.data.documents;
//        } return Center(
//          child: CircularProgressIndicator(),
//        );
//      },
//    );
//  }
}





//class ContactSearch extends SearchDelegate<String>{
//  final String userPhoneNo;
//  final String userName;
//
//  ContactSearch({@required this.userPhoneNo, @required this.userName});
//
//  @override
//  List<Widget> buildActions(BuildContext context) {
//    return[
//      IconButton(
//        icon: Icon(Icons.clear),
//        onPressed: (){
//          query='';
//        },
//      ),
//    ];
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
////    return IconButton(
////      icon: Icon(Icons.arrow_back),
////      onPressed: (){
////        close(context, null);
////      },
////    );
//  return null;
//  }
//
//  @override
//  Widget buildResults(BuildContext context) {
//
//  }
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    print("userphoneno in contact_search: ${userPhoneNo}");
//    return StreamBuilder(
//        stream: Firestore.instance.collection("friends_$userPhoneNo").snapshots(),//use userPhoneNo ToDo
//        builder: (context, snapshot) {
//
//          //final streamShortcut =Firestore.instance.collection("friends_9194134191").document("contacts").snapshots();
//
//          if(snapshot.hasError) return Text("Error occurred");
//          if(!snapshot.hasData) return Text("Now Loading!");
//
//
//          //print("snapshot in streambuilder: ${snapshot.data}");
//
//          return ListView.builder(
//              itemCount: snapshot.data.documents.length,
//              itemBuilder: (context, index){
//                //final result = streamShortcut.where();
//                print("userName= $userName");
//                print("snapshotdatadoc[index]data[convID] = ${snapshot.data.documents[index].data["conversationId"]}");
//                print("userphoneno in contact_search in Listview Builder: ${userPhoneNo}");
//                //print("userName:=${snapshot.data.documents[int.parse(userPhoneNo)].data["name"]}");
//                print("userName= $userName");
//                return ListTile(
//                  title: Text(
//                      snapshot.data.documents[index].data["name"],
//                  ),
//                  onTap: (){
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(//to send conversationId along with the navigator to the next page
//                        builder: (context) => IndividualChat(
//                          conversationId: snapshot.data.documents[index].data["conversationId"],
//                          userPhoneNo: userPhoneNo,
//                          userName: userName,
//                          friendName: snapshot.data.documents[index].data["name"],
//                        ),
//                      ),
//                    );
//                  },
//                );
//              },
//          );
//
//        }
//    );
//  }
//
////  Stream filter(){
////
////  }
//
//}

///FlareActor("assets/Filip.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:"idle");