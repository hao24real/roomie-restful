module.exports= function(socket) {

	var group_id;
	
	//accept client's subscription to the chat room
	socket.on('listen to notification', function(my_notification_id){
		console.log('listen to notification: ' + my_notification_id);
		//join the room
		socket.join(my_notification_id);
	});

	//accept client's subscription to listen to group's notification
	socket.on('listen to completion',function(group_num_id){
		console.log('listen to completion: ' + group_num_id);
		group_id =  group_num_id + "g";
		socket.join(group_id);
	});

	//notification from client to specific reciever of duty type
	socket.on('notification duty', function(reciever_id, duty_type){

		console.log('notification duty to: ' + reciever_id);

		socket.join(reciever_id);
		socket.broadcast.to(reciever_id).emit('notification duty', {
			duty: duty_type
		});
		socket.leave(reciever_id);
	});

	//notification from client to all other group mate for duty completion
	socket.on('complete duty', function(user_firstname, duty_type){
		socket.broadcast.to(group_id).emit('complete duty', {
			user: user_firstname,
			duty: duty_type
		});
	});

	//notification from client to specific reciever of common share good
	socket.on('notification common good', function(reciever_id, csg_type){
		socket.join(reciever_id);
		socket.broadcast.to(reciever_id).emit('notification csg', {
			csg: csgtype
		});
		socket.leave(reciever_id);
	});

	//notification from client to all other group mate for duty completion
	socket.on('complete common good', function(user_firstname, csg_type){
		socket.broadcast.to(group_id).emit('complete common good', {
			user: user_firstname,
			csg: csgtype
		});
	});

	//notification from client to tell a person who owe you money
	socket.on('notification bill', function(reciever_id, 
		sender_firstname, bill_amount, bill_description){
		socket.broadcast.to(reciever_id).emit('notification bill', {
			user: user_firstname, 
			amount: amount,
			description: bill_description
		});
	});



};