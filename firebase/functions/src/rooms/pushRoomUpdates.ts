import * as admin from 'firebase-admin';
import {CallableContext} from 'firebase-functions/lib/providers/https';
import * as _            from 'lodash';

export const pushRoomUpdates = async(data: any, context: CallableContext ) => {
    console.log("Received request data: ", JSON.stringify(data));
    const roomName = data.name;
    const inviteePhoneNumber = data.inviteePhoneNumber;

    const roomRef = admin.firestore().collection('rooms').doc(roomName);
    roomRef.get()
    .then((docSnapshot) => {
        if(docSnapshot.exists) {
            roomRef.update({
                invitees: admin.firestore.FieldValue.arrayUnion(inviteePhoneNumber),
                active: data.active
            });
        } else {
            roomRef.set({
                name: roomName,
                invitees: [inviteePhoneNumber],
                token: data.token,
                identity: data.identity,
                active: data.active
            });
        }
    });
    
}