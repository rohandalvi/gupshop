import 'package:gupshop/responsive/textConfig.dart';

class CreateMessageData{

  androidVideoCallData(Map<String, dynamic> message){
    Map<String, dynamic> result = new Map();

    var notificationMap = message[TextConfig.notificationAndroid];

    print("notificationMap in createAndroidVideoCallData: $notificationMap");
    var dataMap = message[TextConfig.data];
    print("dataMap createAndroidVideoCallData: $dataMap");

    String title = notificationMap[TextConfig.title];
    String body = notificationMap[TextConfig.body];
    String name = dataMap[TextConfig.name];
    String type = dataMap[TextConfig.type];

    result[TextConfig.title] = title;
    result[TextConfig.body] = body;
    result[TextConfig.name] = name;
    result[TextConfig.type] = type;

    print("result : $result");
    return result;
  }

  iosVideoCallData(Map<String, dynamic> message){
    /// message[TextConfig.iosAps][TextConfig.alert]
    Map<String, dynamic> result = new Map();

    var alertMap = message[TextConfig.iosAps][TextConfig.alert];

    String title = alertMap[TextConfig.title];
    String body = alertMap[TextConfig.body];
    String name = message[TextConfig.name];
    String type = message[TextConfig.type];

    result[TextConfig.title] = title;
    result[TextConfig.body] = body;
    result[TextConfig.name] = name;
    result[TextConfig.type] = type;

    return result;
  }


  iosChatMessageData(Map<String, dynamic> message){
    /// message[TextConfig.iosAps][TextConfig.alert]
    Map<String, dynamic> result = new Map();

    var alertMap = message[TextConfig.iosAps][TextConfig.alert];

    String title = alertMap[TextConfig.title];
    String body = alertMap[TextConfig.body];
    String notificationFromNumberIndividual = alertMap[TextConfig.notificationFromNumberIndividual];
    //String notificationFromName = alertMap[TextConfig.notificationFromName];
    //List<dynamic> notificationFromNumber = alertMap[TextConfig.notificationFromNumber];
    String notifierConversationId = alertMap[TextConfig.notifierConversationId];
    String type = alertMap[TextConfig.type];

    result[TextConfig.title] = title;
    result[TextConfig.body] = body;
    result[TextConfig.notificationFromNumberIndividual] = notificationFromNumberIndividual;
    //result[TextConfig.notificationFromName] = notificationFromName;
    //result[TextConfig.notificationFromNumber] = notificationFromNumber;
    result[TextConfig.notifierConversationId] = notifierConversationId;
    result[TextConfig.type] = type;

    return result;
  }


  androidChatMessageData(Map<String, dynamic> message){
    Map<String, dynamic> result = new Map();

    var notificationMap = message[TextConfig.notificationAndroid];
    print("in createAndroidMessageData : ${message[TextConfig.notificationAndroid]}");
    //Map<String, dynamic> notificationMap = message[TextConfig.notificationAndroid];
    print("notificationMap : $notificationMap");
    var dataMap = message[TextConfig.data];
    print("dataMap : $dataMap");

    String title = notificationMap[TextConfig.title];
    String body = notificationMap[TextConfig.body];
    String notificationFromNumberIndividual = dataMap[TextConfig.notificationFromNumberIndividual];
    //String notificationFromName = dataMap[TextConfig.notificationFromName];
    print("notificationFromNumberIndividual : $notificationFromNumberIndividual");
    print("message[TextConfig.data][TextConfig.notificationFromNumber] : ${message[TextConfig.data][TextConfig.notificationFromNumber]}");
//    var notificationFromNumber = dataMap[TextConfig.notificationFromNumber];
//    print("notificationFromNumber : $notificationFromNumber");
//    List<dynamic> listOfNotificationFromNumber = jsonDecode(notificationFromNumber);
//    print("list : $listOfNotificationFromNumber");
    String notifierConversationId = dataMap[TextConfig.notifierConversationId];
    print("notifierConversationId : $notifierConversationId");
    String type = dataMap[TextConfig.type];
    print("type : $type");

    result[TextConfig.title] = title;
    print("result : $result");
    result[TextConfig.body] = body;
    result[TextConfig.notificationFromNumberIndividual] = notificationFromNumberIndividual;
    //result[TextConfig.notificationFromName] = notificationFromName;
    //result[TextConfig.notificationFromNumber] = notificationFromNumber;
    result[TextConfig.notifierConversationId] = notifierConversationId;
    result[TextConfig.type] = type;

    return result;
  }
}