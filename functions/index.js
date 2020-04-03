const functions = require('firebase-functions');
const admin = require('firebase-admin');
var serviceAccount = require("/Users/rohandalvi/Downloads/gupshop-27dcc-firebase-adminsdk-cxpq6-32df356e81.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://gupshop-27dcc.firebaseio.com"
});

exports.addMessage = functions.https.onRequest(async (req,res) => {
  const original = req.query.userPhoneNumber;
  const stringOfContactNumebrs = req.query.contactNumbers;
  const arrayOfContactNumbers = stringOfContactNumebrs.split(",");
  console.log("original ",req.query);
  const snapshot = await admin.database().ref('/friends_'+original).push({contactNumbers:arrayOfContactNumbers});
  res.redirect(303, snapshot.ref.toString());
});
