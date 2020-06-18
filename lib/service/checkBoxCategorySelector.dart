import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// =>bazaarProfilePage

class CheckBoxCategorySelector extends StatefulWidget {
  final String userPhoneNo;
  final String userName;


  CheckBoxCategorySelector({@required this.userPhoneNo, @required this.userName});

  @override
  CheckBoxCategorySelectorState createState() => CheckBoxCategorySelectorState(userPhoneNo: userPhoneNo, userName: userName);
}

class CheckBoxCategorySelectorState extends State<CheckBoxCategorySelector> {
  final String userPhoneNo;
  final String userName;

  CheckBoxCategorySelectorState({@required this.userPhoneNo, @required this.userName});

  List<bool> inputs = new List<bool>();
  int categorySize;
  bool isData;
  bool isSelected;


  getCategorySizeFuture() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("bazaarCategories").getDocuments();

    if(querySnapshot == null) return CircularProgressIndicator();//to avoid red screen(error)

    int size = querySnapshot.documents.length;
    return size;
  }
  initializeList(List<bool>inputs ) async{
    int size = await getCategorySizeFuture();
    print("size initializesize: $size");
    setState(() {
      for(int i =0; i<size; i++){
        inputs.add(false);
      }
    });
  }


  @override
  void initState() {
    initializeList(inputs);
    super.initState();
  }


  ///using scaffold does take out the black screen but it gives white screen instead.
  @override
  Widget build(BuildContext context) {
    print("userPhoneNo in chechbox  built : $userPhoneNo");
    print("userName in chechbox  built : $userName");
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,//if this is not used then shrinkwrap does not wrap, column size affects shrinkwrap
          children: <Widget>[
            categorySelector(),
            MaterialButton(
              onPressed: (){
                pushCategorySelectedToFirebase();
                print("categorySelected: ${ifNoCategorySelected()}");

                if(ifNoCategorySelected() == true){
                  print("context: true");
                  Navigator.of(context).pop({
                    setState(() {
                      isSelected = true;
                  }),
                  });
                }
                else Navigator.of(context).pop({
                  setState(() {
                    isSelected = false;
                  }),
                });
                print("context: false");
              },
               child: ifNoCategorySelected() ? Text("Save") : null,
              //child: ifNoCategorySelected() ? Text("Save") : Text("Required"),//flip and show save once and required once
            )
          ],
        ),
      );
  }



  categorySelector(){
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("bazaarCategories").snapshots(),
        builder: (context, snapshot) {

          if(snapshot.data == null) return CircularProgressIndicator();

          print("snapshot.data in category selector: ${snapshot.data.documents[0].documentID}");
          QuerySnapshot querySnapshot = snapshot.data;

          List<DocumentSnapshot> listOfDocumentSnapshot = snapshot.data.documents;

          print("categorylength: ${snapshot.data.documents.length}");
          int categoryLength = snapshot.data.documents.length;

          print("inputs: $inputs");


          ///A RenderFlex overflowed by 299361 pixels on the bottom.
          ///solution - use Container and constraints
          return Container(
            constraints: BoxConstraints(
              maxHeight: 300,
            ),
            child: ListView.builder(
                itemCount: categoryLength,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {

                  ///RenderFlex children have non-zero flex but incoming height constraints are unbounded.
                  return Container(///container was wrapped with sized box before, but we dont need it because we are using column and  flexible which are giving sizes
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: CheckboxListTile(
                            title: Text(querySnapshot.documents[index].documentID),
                            value: inputs[index],
                            //controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool val){
                              itemChange(val, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ),
          );
        }
    );
  }
  void itemChange(bool val, int index){
    setState(() {
      inputs[index] = val;
    });
  }



  //pushing the category selected to firebase
  pushCategorySelectedToFirebase() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection("bazaarCategories").getDocuments();

    if(querySnapshot == null) return CircularProgressIndicator();//to avoid red screen(error)

    String categoryName;

    for(int i=0; i<inputs.length; i++){
      if(inputs[i] == true) {//if any cateogry is selected it would be true in input array
        categoryName = querySnapshot.documents[i].documentID;
        print("category name : $categoryName");

        String phoneNo = userPhoneNo;
        print("userPhoneNo: $userPhoneNo");
        print("userName: $userName");

        //then push it to firebase:
        //1. push the name and the number of the bazaarwala to the bazaarCategories collection under that specific category document
        //bWC => category => number->name,rating
        //2. push the name and number to bazaarWalasBasicProfile
        //bWBP => number => ?  => category => name, rating
        var result = {
          userPhoneNo: {
            'name': userName
          }
        };

        Firestore.instance.collection("bazaarCategories").document(categoryName).setData(result);
        Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).setData({});
        Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).collection(userName).document(categoryName).setData({});
      }
      }
    }


    bool ifNoCategorySelected(){
      for(int i=0; i<inputs.length; i++){
        if(inputs[i] == true){
          isData = true;
            return true;
        }
      }
      return false;
    }

  }

