// =============================== CLIENT SIDE ===============================
// 
// The below api shows each coversation done by USER.
// The value of "newMessage" is the message entered by user.
// $scope.conversationId gives null value for the first conversation ( first message entered by USER ).
// Then in response of the api returns an ID, that id stored as conversationId  


// If response get JSON value then try block will execute and call API to fetch data from database.
// else execute catch block and response message will show to USER.

let response = await $http.post('http://localhost:1020/admin/sendChatBotMessage', { newMessage: newMessage, id: $scope.conversationId });
$scope.conversationId = response.data.id;
let allMessage = response.data.message;
for (let i = 0; i < allMessage.length; i++) {
    try {
        let response1 = await $http.get(JSON.parse(allMessage[i].text).api);
        message = response1.data;

        // ************** APPEND message TO VIEW PAGE OF CLIENT **************


    } catch (e) {
        message = allMessage[i].text;

        //************** APPEND message TO VIEW PAGE OF CLIENT **************

    }
}




// =============================== SERVER SIDE ===============================


// In server first check conversationId is available or not
// If there is an id on USER request then send conversationId to rasa API 
// else create a random ID and send it to rasa API
// When Server got response from rasa API 
// That reaponse value send to client with conversationId.
const request = require('request');
router.post('/sendChatBotMessage', async(req, res) => {
    try {
        const id = req.body.id == undefined ? (Math.floor(Math.random() * 1000) + 10) : req.body.id;
        const data = {
            sender: id,
            message: req.body.newMessage
        }
        request.post({
            headers: { 'content-type': 'application/json' },
            url: 'http://164.100.140.200/webhooks/rest/webhook',
            // url:     'http://localhost:5005/webhooks/rest/webhook',
            body: JSON.stringify(data)
        }, function(error, response, body) {
            try {
                let rData = JSON.parse(body);
                res.send({ message: rData, id: id });
            } catch (e) {
                console.log(e);
            }
        });
    } catch (e) {
        console.log(e);
    }
});