module.exports= function(socket) {

	var addedUser = false;
	var private_room_ID = 0;

	//accept client's subscription to the chat room
	socket.on('subscribe', function(room_ID){
		//join the room
		socket.join(room_ID);
		private_room_ID = room_ID;
	});

	//accept a new message being send from client
	socket.on('new message', function(data){
		//
		socket.broadcast.to(private_room_ID).emit('new message',{
			username: socket.username,
			message: data
		});
	});

	//when client tell sever it is actually added into the room 
	socket.on('add user', function(username){
		// this prevent same user being added twice to the room
		if(addedUser) return;

		socket.username = username;
		addedUser = true;

		//tell all the other clients that a user join the chat
		socket.broadcast.to(private_room_ID).emit('user joined', {
			username: socket.username
		});
	});

	//when client tell server it is currently typing
	socket.on('typing', function(){
		//server tell all the other clients that the client is typing
		socket.broadcast.to(private_room_ID).emit('typing', {
			username: socket.username
		});
	});

	//when client tell server it stop typing
	socket.on('stop typing', function(){
		//server tell all the other clients that the client stop typing
		socket.broadcast.to(private_room_ID).emit('stop typing', {
			username: socket.username
		});
	});

	// user disconnect
	socket.on('disconnect', function(){
		//use this check so same user won't disconnect twice
		if(addedUser){
			socket.broadcast.to(private_room_ID).emit('user left',{
				username: socket.username
			});
		}
	});

};

