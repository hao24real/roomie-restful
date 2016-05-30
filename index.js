//get the express framework 
var express = require('express');
var app = express();

//get tedious framework for sql query
var tedious = require('tedious');

//create the server base on express framework
var server = require('http').createServer(app);

//get the socket.io api
var io = require('socket.io')(server);

// forwarding the port to 3000 for us to test on local host
var port = process.env.PORT|| 3000;

//start listening to incoming http request
server.listen(port, function(){
	console.log('Server listening at port %d', port);
});

io.on('connection', function(socket){
	//get the module of chatting
	var privateChat = require('./privateChat')(socket);

	//get the module of notification
	var notification = require('./notification')(socket);

	//get the module of the password_retreive
	var password_retreive = require('./password_retreive')(socket, tedious);

});