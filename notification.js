module.exports= function(socket, tedious, fcm) {

	console.log('notification module');

	var Request = tedious.Request;  
	var TYPES = tedious.TYPES;
	var group_id;
	var my_id;
	
	var Connection = tedious.Connection;  
	var config = {  
	    userName: 'h4tu',  
	    password: 'R!Pdevl0g',  
	    server: 'rationallyimpairedprogrammers.database.windows.net',  
	    // If you are on Microsoft Azure, you need this:  
	    options: {encrypt: true, database: 'cse110_dev'}  
	};  

	//accept client's subscription to the chat room
	socket.on('listen to notification', function(my_notification_id){
		console.log('listen to notification: ' + my_notification_id);
		//join the room
		my_id = my_notification_id;
		socket.join(my_notification_id);
	});

	//accept client's subscription to listen to group's notification
	socket.on('listen to completion',function(group_num_id){
		console.log('listen to completion: ' + group_num_id);
		// group_id =  group_num_id + "g";
		group_id =  group_num_id;
		socket.join(group_id);
	});

	//notification from client to specific reciever of duty type
	socket.on('notification duty', function(duty_id, reciever_id, duty_type){


		console.log('notification duty to: ' + reciever_id);
		console.log('duty id: '+ duty_id);


		var connection = new Connection(config);
		/*-----------------------SQL Connection--------------------*/
		connection.on('connect', function(err) {  
			    // If no error, then good to proceed.  
		    console.log("First Query"); 

		    //build request for query
		    request = new Request("SELECT Token FROM Users WHERE Users.ID = " +
		                        reciever_id, function(err) {
		        if (err) {
		            console.log(err);
		        } 

		        console.log("Second Query");		
					  //build request for query
				    request = new Request('EXEC UpdateDutyTime @id = ' +
				                        duty_id , function(err) {
				        if (err) {
				            console.log(err);
				        }  
				        connection.close();
				    }); 
				    
				    //execute the query to change password
				    connection.execSql(request);
		        // connection.close();
		    }); 
		    
		    request.on('row', function(columns) { 

		/*-----------------------Firebase Push--------------------*/
		        var token_result = columns[0].value;
		        var message = {
		            registration_id: token_result,
		            'data.title': 'Duty Reminder',
		            'data.message': 'Roomie remind you to do ' + duty_type
		        };

		        fcm.send(message, function(err, messageId){
		            if (err) {
		                console.log("Something has gone wrong!");
		            } else {
		                console.log("Sent with message ID: ", messageId);
		                console.log("Token ID: ", token_result);
		            }
		        });
		
		/*-----------------------Firebase Push--------------------*/

		    }); 
		    //execute the query to change password
		    connection.execSql(request); 
		});


	});


	//notification from client to all other group mate for duty completion
	socket.on('complete duty', function(duty_id, user_firstname, duty_type){

		console.log("complete duty"); 

		var connection = new Connection(config);
		/*-----------------------SQL Connection--------------------*/
		connection.on('connect', function(err) {  
		    // If no error, then good to proceed.  
		    console.log("Start Query"); 

		    //build request for query
		    request = new Request('EXEC FindUserFromGroup @groupid = ' + 
		    	group_id +', @userid = ' + my_id, function(err) {
		        if (err) {
		            console.log(err);
		        }  

		        console.log("Query call back");

		        console.log("duty id is " + duty_id);

		        request = new Request('EXEC RefreshDutyTime @id = ' +
				                        duty_id , function(err) {
				        if (err) {
				            console.log(err + " in complete duty");
				        }  
				        // connection.close();
				    }); 
				    
				    //execute the query to change password
				    connection.execSql(request);
		    }); 
		    
		    request.on('row', function(columns) { 

					console.log("iterate through row"); 

		    	columns.forEach(function(column) {
			      if (column.value === null) {
			        console.log('NULL');
			      } else {
			        console.log(column.value);
	        /*-----------------------Firebase Push--------------------*/
			        var token_result = column.value;
			        var message = {
			            registration_id: token_result,
			            'data.title': 'Duty Completion',
			            'data.message': user_firstname +' just completed the ' + duty_type
			        };

			        fcm.send(message, function(err, messageId){
			            if (err) {
			                console.log("Something has gone wrong!");
			            } else {
			                console.log("Sent with notification ID: ", token_result);
			            }
			        });
		
			/*-----------------------Firebase Push--------------------*/
			      }
			    });

		    }); 
		    //execute the query to change password
		    connection.execSql(request); 

		});
	});

	//notification from client to specific reciever of common share good
	socket.on('notification common good', function(csg_id, reciever_id, csg_type){
		// socket.join(reciever_id);
		// socket.broadcast.to(reciever_id).emit('notification csg', {
		// 	csg: csgtype
		// });
		// socket.leave(reciever_id);
		console.log('notification common good to: ' + reciever_id);
		var connection = new Connection(config);
		/*-----------------------SQL Connection--------------------*/
		connection.on('connect', function(err) {  
			    // If no error, then good to proceed.  
		    console.log("First Query"); 

		    //build request for query
		    request = new Request("SELECT Token FROM Users WHERE Users.ID = " +
		                        reciever_id, function(err) {
		        if (err) {
		            console.log(err);
		        }  

		        console.log("Second Query");

    		    //build request for query
				    request = new Request("EXEC UpdateCSGTime @id = " +
				                        csg_id, function(err) {
				        if (err) {
				            console.log(err);
				        }  
				        connection.close();
				    }); 
		    
				    //execute the query to change password
				    connection.execSql(request); 

		    }); 
		    
		    request.on('row', function(columns) { 

		/*-----------------------Firebase Push--------------------*/
		        var token_result = columns[0].value;
		        var message = {
		            registration_id: token_result,
		            'data.title': 'Shared Item Reminder',
		            'data.message': 'Roomie remind you to buy ' + csg_type
		        };

		        fcm.send(message, function(err, messageId){
		            if (err) {
		                console.log("Something has gone wrong!");
		            } else {
		                console.log("Sent with message ID: ", messageId);
		                console.log("Token ID: ", token_result);
		            }
		        });

		/*-----------------------Firebase Push--------------------*/
		    }); 
		    //execute the query to change password
		    connection.execSql(request); 

		});
		/*-----------------------SQL Connection--------------------*/


	});

	//notification from client to all other group mate for duty completion
	socket.on('complete common good', function(csg_id, user_firstname, csg_type){
		// socket.broadcast.to(group_id).emit('complete common good', {
		// 	user: user_firstname,
		// 	csg: csgtype
		// });
		var connection = new Connection(config);
		/*-----------------------SQL Connection--------------------*/
		connection.on('connect', function(err) {  
		    // If no error, then good to proceed.  
		    console.log("Connected"); 

		    //build request for query
		    request = new Request('EXEC FindUserFromGroup @groupid = ' + 
		    	group_id +', @userid = ' + my_id, function(err) {
		        if (err) {
		            console.log(err);
		        }  

		        console.log("Query call back");

		        request = new Request("EXEC RefreshCSGTime @id = " +
				                        csg_id , function(err) {
				        if (err) {
				            console.log(err);
				        }  
				        connection.close();
				    }); 
				    
				    //execute the query to change password
				    connection.execSql(request);
		    }); 
		    
		    request.on('row', function(columns) { 

		    	columns.forEach(function(column) {
			      if (column.value === null) {
			        console.log('NULL');
			      } else {
			        console.log(column.value);
	        /*-----------------------Firebase Push--------------------*/
			        var token_result = column.value;
			        var message = {
			            registration_id: token_result,
			            'data.title': 'Shared Item Completion',
			            'data.message': user_firstname +' just purchased the ' + csg_type
			        };

			        fcm.send(message, function(err, messageId){
			            if (err) {
			                console.log("Something has gone wrong!");
			            } else {
			                console.log("Sent with message ID: ", messageId);
			            }
			        });
			
			/*-----------------------Firebase Push--------------------*/
			      }
			    });

		    }); 
		    //execute the query to change password
		    connection.execSql(request); 
		});


	});

	//notification from client to tell a person who owe you money
	socket.on('notification bill', function(bill_id, reciever_id, 
		sender_firstname, bill_amount, bill_description){
		console.log('notification bill to: ' + reciever_id);

		var connection = new Connection(config);
		/*-----------------------SQL Connection--------------------*/
		connection.on('connect', function(err) {  
			    // If no error, then good to proceed.  
		    console.log("First Query"); 

		    //build request for query
		    request = new Request("SELECT Token FROM Users WHERE Users.ID = " +
		                        reciever_id, function(err) {
		        if (err) {
		            console.log(err);
		        }  

		        console.log("Second Query");
		        //build request for query
				    request = new Request("EXEC UpdateBillTime @id = " +
				                        bill_id , function(err) {
				        if (err) {
				            console.log(err);
				        }  
				        connection.close();
				    }); 
				    
				    //execute the query to change password
				    connection.execSql(request); 

		    }); 
		    
		    request.on('row', function(columns) { 

		/*-----------------------Firebase Push--------------------*/
		        var token_result = columns[0].value;
		        var message = {
		            registration_id: token_result,
		            'data.title': 'Bill Reminder',
		            'data.message': 'You still owe ' + sender_firstname + ' ' + 
		            				bill_amount + ' dollars\nDescription: '+ bill_description
		        };

		        fcm.send(message, function(err, messageId){
		            if (err) {
		                console.log("Something has gone wrong!");
		            } else {
		                console.log("Sent with message ID: ", messageId);
		            }
		        });
		/*-----------------------Firebase Push--------------------*/
		    }); 
		    //execute the query to change password
		    connection.execSql(request); 

		});

		/*-----------------------SQL Connection--------------------*/
	});

	//refresh token
	socket.on('refresh token', function(user_id, token){

		var connection = new Connection(config);

		connection.on('connect', function(err) {  
			// If no error, then good to proceed.  
		    console.log("Connected"); 

		    //build request for query
		    request = new Request("EXEC RefreshToken @userid = " + user_id 
		    		+ ", @token = '"+ token +"'", function(err) {  
			    if (err) {
			        console.log(err);
			    }  
			    connection.close();
		    });  
		    //execute the query to change password
		    connection.execSql(request);  
		});
	});

};