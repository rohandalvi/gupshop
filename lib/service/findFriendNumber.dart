import 'dart:collection';

class FindFriendNumber{

  friendNumber(List<dynamic> memberList, String myNumber){
    print("memberlist in friendNumber : $memberList");
    for(int i =0; i<memberList.length; i++){
      if(memberList[i] != myNumber) {
        return memberList[i];
      }
    }return myNumber;/// for chatting with self

//  Set set = new HashSet();
//  set.addAll(memberList);

  }

  createListOfFriends(List<dynamic> memberList, String myNumber){
    List<dynamic> friendNumberList =new List();

    for(int i =0; i<memberList.length; i++){
      if(memberList[i] != myNumber) {
        friendNumberList.add(memberList[i]);
      }
    }if(friendNumberList.isEmpty) friendNumberList.add(myNumber);/// for chatting with self
    return friendNumberList;
  }

}