var config = require('./config');

exports.findFriends= function(){

var mapOfUsersPhoneContacts= new Map();
var mapOfUnionContacts= new Map();

}

function getUserPhoneContacts(){

}

function getUnionContactsOfUsers(){
mapOfUsersPhoneContacts.forEach(number => {
    if(config.db.collection("users").doc(number).id === number ){//find a good way to do this
    console.log("config.db.collection(users).doc(number).id === number: ", config.db.collection("users").doc(number).id === number);
     var friendName = mapOfUsersPhoneContacts.get(number);
     mapOfUnionContacts.set(number, friendName);
    }
 })
    
}