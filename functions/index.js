var config =  require('./config');
var chats = require('./recentChats');
var triggers = require('./triggers');
var  arrayOfContactNumbers = [];
var arrayOfUnionContacts = [];



//a map for creating a collection which would have:
//Key=phoneNumber(phone number of union contacts),
//value= conversationID
var conversationNumberMap = new Map();

exports.recentMessages = config.functions.https.onRequest(async (req,res) => {

  userPhoneNumber = req.query.userPhoneNumber;
  chats.syncChats(userPhoneNumber);
});

exports.triggers = config.functions.https.onRequest(async (req, res) =>{
  triggers.setupTriggers();
});

exports.addMessage = config.functions.https.onRequest(async (req,res) => {
  const original = req.query.userPhoneNumber;
  const stringOfContactNumebrs = req.query.contactNumbers;
  arrayOfContactNumbers = stringOfContactNumebrs.split(",");
  var listOfPromises = myFunction(arrayOfContactNumbers);
  Promise.all(listOfPromises).then(function(snapshots) {
      var promises = findNewConversations(original, arrayOfUnionContacts);
      Promise.allSettled(promises).then(function(snapshots) {
          snapshots.forEach(snapshot => {
            if(snapshot.status == "rejected") {
              console.log("Error should  contain contact number  ", snapshot.reason);
              var missingPhoneNumber = snapshot.reason;
              addToConversationMetadata(original, missingPhoneNumber).then((docRefId) => {
                console.log("DocRefId ", docRefId);
                  config.db.collection('friends_'+original).doc(missingPhoneNumber).set( JSON.parse( JSON.stringify(Object.assign({}, {name: arrayOfUnionContacts[missingPhoneNumber], conversationId: docRefId})) ) );
                  createUserConversation(original, missingPhoneNumber, docRefId);
                  createUserConversation(missingPhoneNumber, original, docRefId);
              }).catch(error  => {
                console.log("Caught error ", error);
              });
            }
          });
      });
  })
  .catch(error => {
    console.log("Caught error ",error);
  });

});

function myFunction(arrayOfContactNumbers){
  var listOfPromises = [];
  arrayOfContactNumbers.forEach(number => {
    var promise  = getPromise(number);
    console.log("Found promise ", promise);
    listOfPromises.push(promise);
  });
  return listOfPromises;
}

function getPromise(number) {
  return new Promise((resolve, reject)=> {
    config.db.collection("users").doc(number).get().then(snapshot => {
      if(snapshot.data() !=null && snapshot.data().Name !=null) {
        arrayOfUnionContacts[snapshot.id] = snapshot.data().Name;
        //arrayOfUnionContacts.push({id: snapshot.id, name: snapshot.data().Name});
      }
      resolve(snapshot);
    }).catch(error => {
        console.log("Error resolving promise ", error);
    });
  });
}


function findNewConversations(myPhoneNumber, arrayOfUnionContacts) {

    var promises = [];
    for(var contact in arrayOfUnionContacts)  {
      promises.push(getUserConversation(myPhoneNumber, contact));
    }
    
    return promises;
}

//create collection conversation_919
function createUserConversation(myPhoneNumber, contactNumber, convId) {
  config.db.collection("conversations_"+myPhoneNumber).doc(contactNumber).set({
    id: convId
  });
}

function getUserConversation(myPhoneNumber, contactNumber) {
  return new Promise((resolve, reject)=> {
    config.db.collection("conversations_"+myPhoneNumber).doc(contactNumber).get().then(snapshot => {

      if(snapshot.data()!=null &&  snapshot.data().id!=null ) {
        console.log("User conversation "+snapshot.data().id);
        resolve(snapshot);
      }else {
        reject(contactNumber);
      }
    });
  });
}

function addToConversationMetadata(myPhoneNumber, contactPhoneNumber) {
  return new Promise((resolve, reject)=> {

    config.db.collection("conversationMetadata").add({
      members: [myPhoneNumber, contactPhoneNumber]
    }).then(function(docRef){
        resolve(docRef.id);
    }).catch(function(err){
        reject("error adding document for contact " + contactNumber, err);
    });
  });
}
