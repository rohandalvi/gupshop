var config = require('./config');

exports.findFriends= function(){

var mapOfUsersPhoneContacts= new Map();
var mapOfUnionContacts= new Map();

console.log("documentId(): ",config.db.collection("users").doc("585759"));

getUnionContactsOfUsers().then(function(data){
    console.log("getUnionContacts data: ", data);
})

}

function getUserPhoneContacts(){

}

function getUnionContactsOfUsers(){

// return Promise((resolve, reject)=> {
//     mapOfUsersPhoneContacts.forEach(number => {
//        if(config.db.collection("users").doc(number).id === number ){
//         var friendName = mapOfUsersPhoneContacts.get(number);
//         mapOfUnionContacts.set(number, friendName);
//        }resolve(number);
//     }).catch(error => {
//         console.log("Error");
//     })
// })

mapOfUsersPhoneContacts.forEach(number => {
    if(config.db.collection("users").doc(number).id === number ){
    console.log("config.db.collection(users).doc(number).id === number: ", config.db.collection("users").doc(number).id === number);
     var friendName = mapOfUsersPhoneContacts.get(number);
     mapOfUnionContacts.set(number, friendName);
    }
 })
    
}