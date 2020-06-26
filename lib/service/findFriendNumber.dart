class FindFriendNumber{

  friendNumber(List<dynamic> memberList, String myNumber){
    for(int i =0; i<memberList.length; i++){
      if(memberList[i] != myNumber) {
        return memberList[i];
      }
    }

  }

  createListOfFriends(List<dynamic> memberList, String myNumber){
    List<dynamic> friendNumberList =new List();

    for(int i =0; i<memberList.length; i++){
      if(memberList[i] != myNumber) {
        friendNumberList.add(memberList[i]);
        print("friendNumberList in forloop: $friendNumberList");
      }
    }
    print("friendNumberList: $friendNumberList");
    return friendNumberList;
  }

}