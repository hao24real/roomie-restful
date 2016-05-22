module.exports= function(socket) {

	//accept client's subscription to the chat room
	socket.on('listen to notification', function(my_notification_ID){
		//join the room
		socket.join(my_notification_ID);
	});

	//notification from client to specific reciever of duty type
	socket.on('notification duty', function(reciever_id, duty_type){
		socket.join(reciever_id);
		socket.broadcast.to(reciever_id).emit('notification duty', {
			duty: duty_type
		});
		socket.leave(reciever_id);
	});

	//notification from client to specific reciever of common share good
	socket.on('notification csg', function(reciever_id, csg_type){
		socket.join(reciever_id);
		socket.broadcast.to(reciever_id).emit('notification duty', {
			csg: csgtype
		});
		socket.leave(reciever_id);
	});

	//not implemented for now
	//notification from client to specific reciever of common share good
	/*socket.on('notification bill', function(reciever_id, bill_type){
		socket.join(reciever_id);
		socket.broadcast.to(reciever_id).emit('notification duty', {
			csg: csgtype
		});
		socket.leave(reciever_id);
	});*/

};