//
//var config = require('./config');
//
///**
// *
// * 1. conversations_userPhoneNumber -> get all conversation id's
// * 2. conversation_convId-> get one recent message from each conversation id.
// * 3. sort the conversations using the message timestamp within each conversation.
// * 4. push result to recentChats_userPhoneNumber
// */
//
//exports.syncChats = function(userPhoneNumber) {
//    var promise = getAllConversationIds(userPhoneNumber);
//
//    promise.then(function(conversationIds){
//
//        var messagePromises = [];
//        conversationIds.forEach(conversationId => {
//            messagePromises.push(getRecentMessageFromConversation(conversationId));
//        });
//        Promise.allSettled(messagePromises).then(function(results){
//
//            results.forEach(result => {
//                if(result.status === 'fulfilled') {
//                    var cId =  result.value.id;
//                    var message = result.value.message;
//                    console.log("Result  ", message);
//                    config.db.collection("recentChats").doc(cId).set(message);
//                }
//            });
//        }).catch(error => {
//            console.log("Caught error settling promises", error);
//        })
//    }).catch(error => {
//        console.log("Error ", error);
//    });
//
//}
//
//function getRecentMessageFromConversation(conversationId) {
//    return new Promise((resolve, reject) => {
//        var reference = config.db.collection("conversations");
//        reference.orderBy('timestamp', 'desc').limit(1);
//        reference.doc(conversationId).get().then(function(snapshot){
//
//            if(!snapshot.exists) reject(snapshot);
//            else {
//                var messageArray = snapshot.data().messages;
//                console.log("Mes ", messageArray);
//                messageArray.sort(compareMessages);
//                console.log("Done");
//                resolve({id: conversationId, message:  messageArray[0]});
//            }
//
//        }).catch(error  => {
//            reject(error);
//        });
//    });
//}
//
//function compareMessages(a, b) {
//    var t1 =  b.timestamp
//    var t2 = a.timestamp;
//    console.log("t1 ", t1);
//    return t1.toMillis() - t2.toMillis();
//}
//
//function getAllConversationIds(userPhoneNumber) {
//
//    return new Promise((resolve, reject) => {
//        config.db.collection("conversations_"+userPhoneNumber).get().then(function(docs){
//            var result  = [];
//            docs.forEach(doc => {
//                result.push(doc.data().id);
//            })
//            resolve(result);
//        }).catch(error => {
//            reject(error);
//        });
//    });
//}
//
