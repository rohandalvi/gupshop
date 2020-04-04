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
exports.addMessage = functions.https.onRequest(async (req,res) => {
  const original = req.query.userPhoneNumber;
  const stringOfContactNumebrs = req.query.contactNumbers;
  arrayOfContactNumbers = stringOfContactNumebrs.split(",");
  var listOfPromises = myFunction(arrayOfContactNumbers);
  Promise.all(listOfPromises).then(function(snapshots) {
    console.log("Finally ",arrayOfUnionContacts);

    const snapshot = admin.database().
    ref('/friends_'+original).
    set({contactNumbers:arrayOfUnionContacts});
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
    db.collection("users").doc(number).get().then(snapshot => {
      console.log("snap "+snapshot.id);
      if(snapshot.data() !=null && snapshot.data().Name !=null) {
        console.log("Found name "+snapshot.data().Name);
        arrayOfUnionContacts.push({id: snapshot.id, data: snapshot.data()});
      }
      resolve(snapshot);
    });
  });

}
