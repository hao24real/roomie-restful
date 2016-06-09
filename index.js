//get the express framework 
var express = require('express');
var app = express();

//get tedious framework for sql query
var tedious = require('tedious');

//get sendgrid api
var sendgrid  = require('sendgrid')('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');

//create the server base on express framework
var server = require('http').createServer(app);

//get the socket.io api
var io = require('socket.io')(server);

//get fcm connection
var FCM = require('fcm').FCM;
var apiKey = 'AIzaSyCPdNwmqf8EDIKQHzB-U_K2GfLENZIwej4';
var fcm = new FCM(apiKey);



// forwarding the port to 3000 for us to test on local host
var port = process.env.PORT|| 3000;

//start listening to incoming http request
server.listen(port, function(){
	console.log('Server listening at port %d', port);
});

app.use(express.static(__dirname + '/public'));

io.on('connection', function(socket){

	console.log('Socket is on');

	//get the module of chatting
	var privateChat = require('./privateChat')(socket);

	//get the module of notification
	var notification = require('./notification')(socket, tedious, fcm);

	//get the module of the password_retreive
	var password_retreive = require('./password_retreive')(socket, tedious, sendgrid);

});