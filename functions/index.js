const functions = require('firebase-functions');
const admin = require('firebase-admin');
var serviceAccount = require("/Users/purvadalvi/Downloads/gupshop-27dcc-firebase-adminsdk-cxpq6-5e458a4851.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://gupshop-27dcc.firebaseio.com"
});

var  arrayOfContactNumbers = [];
var arrayOfUnionContacts = [];
var db = admin.firestore();


//a map for creating a collection which would have:
//Key=phoneNumber(phone number of union contacts),
//value= conversationID
var conversationNumberMap = new Map();

exports.getDb =  function() {
  return db;
}

exports.addMessage = functions.https.onRequest(async (req,res) => {
  const original = req.query.userPhoneNumber;
  const stringOfContactNumebrs = req.query.contactNumbers;
  arrayOfContactNumbers = stringOfContactNumebrs.split(",");
  var listOfPromises = myFunction(arrayOfContactNumbers);
  Promise.all(listOfPromises).then(function(snapshots) {
      var promises = findNewConversations(original, arrayOfUnionContacts);
      db.collection('friends_'+original).doc('contacts').set( JSON.parse( JSON.stringify(Object.assign({}, arrayOfUnionContacts)) ) );
      Promise.allSettled(promises).then(function(snapshots) {
          snapshots.forEach(snapshot => {
            if(snapshot.status == "rejected") {
              console.log("Error should  contain contact number  ", snapshot.reason);
              var missingPhoneNumber = snapshot.reason;
              addToConversationMetadata(original, missingPhoneNumber).then((docRefId) => {
                console.log("DocRefId ", docRefId);
                  createUserConversation(original, missingPhoneNumber, docRefId);
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

  //creating a new collection names conversation_9194134191 for mapping
  //friends phone numbers with conversationID
  //db.collection(conversation_+original).doc('contacts').set( JSON.parse(JSON.stringify(Object.assign()) ) )

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
    db.collection("users").doc(number).get().then(snapshot => {
      if(snapshot.data() !=null && snapshot.data().Name !=null) {
        arrayOfUnionContacts.push({id: snapshot.id, name: snapshot.data().Name});
      }
      resolve(snapshot);
    });
  });
}


function findNewConversations(myPhoneNumber, arrayOfUnionContacts) {

    var promises = [];
    arrayOfUnionContacts.forEach(contact => {
        promises.push(getUserConversation(myPhoneNumber, contact.id));
    });
    return promises;
}

function createUserConversation(myPhoneNumber, contactNumber, convId) {
  db.collection("conversations_"+myPhoneNumber).doc(contactNumber).set({
    id: convId
  });
}

function getUserConversation(myPhoneNumber, contactNumber) {
  return new Promise((resolve, reject)=> {
    db.collection("conversations_"+myPhoneNumber).doc(contactNumber).get().then(snapshot => {

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

    db.collection("conversationMetadata").add({
      members: [myPhoneNumber, contactPhoneNumber]
    }).then(function(docRef){
        resolve(docRef.id);
    }).catch(function(err){
        reject("error adding document for contact " + contactNumber, err);
    });
  });
}
