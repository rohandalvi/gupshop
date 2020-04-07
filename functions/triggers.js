var config = require('./config');


exports.setupTriggers = function() {

    
    triggerOnNewMessageEvent();
}


function triggerOnNewMessageEvent() {
    console.log("Setting  up new message event");
    
    config.functions.firestore.document('conversations/{conversationId}')
    .onUpdate((change, context) => {
        console.log("On update");
        console.log("change ", change);
    });
    config.functions.firestore.document('conversations/{conversationId}')
    .onCreate((change, context) => {
        console.log("On create");
        console.log("change ", change);
    });
}