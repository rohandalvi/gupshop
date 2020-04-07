var  admin = require('firebase-admin');
//var serviceAccount = require("/Users/purvadalvi/Downloads/gupshop-27dcc-firebase-adminsdk-cxpq6-5e458a4851.json");
module.exports = {
    functions: require('firebase-functions'),
    admin: admin,
    init: init(),
    //serviceAccount: serviceAccount,
    db: admin.firestore()

} 
function init() {
    admin.initializeApp();
    // admin.initializeApp({
    //     credential: admin.credential.cert(serviceAccount),
    //     databaseURL: "https://gupshop-27dcc.firebaseio.com"
    //   });
}