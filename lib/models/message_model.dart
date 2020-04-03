import 'dart:collection';

class Message {
  final User sender;
  final String time;
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender,
    this.text,
    this.time,
    this.isLiked,
    this.unread,
  });

}

class User {

  final String id;
  final String name;
  final String imageUrl;

  User({
    this.id,
    this.name,
    this.imageUrl
  });

}

// USERS
final User Moloy = User(id: '1', name: 'Moloy', imageUrl: 'assets/images/greg.jpg');
final User Basu =
User(id: '2', name: 'Basu', imageUrl: 'assets/images/james.jpg');
final User Anurag = User(id: '3', name: 'Anurag', imageUrl: 'assets/images/john.jpg');
final User Babulal =
User(id: '4', name: 'Babulal', imageUrl: 'assets/images/olivia.jpg');
final User KakaBabu = User(id: '5', name: 'KakaBabu', imageUrl: 'assets/images/sam.jpg');
final User Babubhai =
User(id: '6', name: 'Babubhai', imageUrl: 'assets/images/sophia.jpg');
final User Prerna =
User(id: '7', name: 'Prerna', imageUrl: 'assets/images/steven.jpg');

//me:
final User currentUser = User(id: '0', name:'CurrentUser', imageUrl: 'assets/images/james.jpg');
//why is this needed???






List<Message> chats =
[
  Message(
    sender: Basu,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: Babulal,
    time: '4:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: Anurag,
    time: '3:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: Babubhai,
    time: '2:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: Prerna,
    time: '1:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: KakaBabu,
    time: '12:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: Moloy,
    time: '11:30 AM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN



UnmodifiableListView<Message> messageData = messages;

List<Message> messages = [
  Message(
    sender: Basu,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: Basu,
    time: '3:45 PM',
    text: 'How\'s the doggo?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: Basu,
    time: '3:15 PM',
    text: 'All the food',
    isLiked: true,
    unread: true,
  ),
  Message(//why is this needed??
    sender: currentUser,
    time: '2:30 PM',
    text: 'Nice! What kind of food did you eat?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: Basu,
    time: '2:00 PM',
    text: 'I ate so much food today.',
    isLiked: false,
    unread: true,
  ),
];

class ChatMessage {
  User sender;
  String text;
  int time;

  ChatMessage({
    this.sender,
    this.text,
    this.time
});
}



class Chats{
  List<ChatMessage> chatMessages = [

    ChatMessage(
        sender: Basu,
        text: "Hi There",
        time: 1
    ),
    ChatMessage(
        sender: currentUser,
        text: "Hey how are you",
        time: 2
    ),
    ChatMessage(
        sender: Basu,
        text: "I am good, how are you?",
        time: 3
    ),
    ChatMessage(
        sender: currentUser,
        text: "I am good too",
        time: 4
    ),
    ChatMessage(
        sender: Basu,
        text: "Are you free over the weekend?",
        time: 5
    ),
    ChatMessage(
        sender: currentUser,
        text: "No",
        time: 6
    ),

  ];

  List<ChatMessage> getMessages(){
    chatMessages.sort((a, b) => a.time - b.time);
    return chatMessages;
  }
}


List<String> individualMessages = [
  "Hi",
  "How are you",
  "Hmm , that sounds good"
];

List<String> myMessages = [
  "Hey",
  "I am good, How are you",
  "I am in Goa",
];

List<String> individualMessagesTimings = [
  "2.30 PM",
  "2.31 PM",
  "2.40 PM",
];