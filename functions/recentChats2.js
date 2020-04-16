var config = require('./config');


exports.creatRecentChatsCollection= function(){
    var convId;
    var newMessage;
    config.db.collectionGroup("messages").orderBy('timeStamp', 'desc').limit(1).onSnapshot(function(messageAdd){
        messageAdd.docChanges().forEach(function(change){
            if(change.type === "added"){
                console.log("ChangeType ", change.type);
                newMessage= change.doc.data();
                console.log("new message : ", newMessage);
                //following if condition is because the in the message before this date(11/4/20) conversationId was not  added as field in the document of subcollection messages in collection conversations
                convId = change.doc.get("conversationId");//use to get phoneNumbers from conversationMetaData

                //getting numbers from conversationMetaData 
                getNumberPromises(convId).then(function(data) {
                    var numberArray = data.members;
                    numberArray.forEach(function(currentNumber){
                        getConversationName(currentNumber, convId).then(function(convName) {
                            config.db.collection("recentChats").doc(currentNumber).collection("conversations").doc(convId).set({message: newMessage, name: convName});
                        });
                    });
                });
                console.log("convId: ", convId);
                console.log("message index: ", change.newIndex);
            }
        });

        console.log("DONEEEE!!!!!!!!!!!!!!==============");
    

        getNumberPromises(convId).then(function(data) {
            console.log("config.db.collection(convMd).doc(convId): ", data);
            var numberArray = data.members;
            var number1 = numberArray[0];//number1 to be pushed in recentChats collection
            var number2 = numberArray[1];//number2 to be pushed in recentChats collection
            console.log("numberArray: ", numberArray);
            console.log("number1: ", number1);
            console.log("number2: ", number2);

            //recentChats=>number1=> newMessage
        });
    })
    
}

function getConversationName(myNumber, convId) {
    return new Promise((resolve, reject)=> {

        config.db.collection("conversationMetadata").doc(convId).get().then(function(cMetadata){

            var convName = cMetadata.data().name;
            if(convName === undefined) {
                var phoneNumbers = cMetadata.data().members;
                var foundFlag = false;
                phoneNumbers.forEach(function(number) {
                    if(number !== myNumber) {
                        foundFlag = true;
                        config.db.collection("friends_"+myNumber).doc(number).get().then(function(data){
                            resolve(data.data().name);
                        });
                    }
                });
                if(!foundFlag) reject("NO other number besides myNumber "+myNumber+" found in  conversationMetadata."+convId);
            } else {
                resolve(convName);
            }
            
        }).catch((error)=> {
            reject(error);
        });
    });
}

function getNumberPromises(convId){
    return new Promise((resolve,reject)=>{
        config.db.collection("conversationMetadata").doc(convId).get().then(function(getNumber){
            resolve(getNumber.data());             
        }).catch(error =>{
            reject(error);
        })
    })
}

