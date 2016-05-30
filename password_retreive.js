module.exports = function(socket, tedious){

	var Request = tedious.Request;  
	var TYPES = tedious.TYPES;

	/* the function for sending email */
	function send_email(email, password){

		var sendgrid  = require('sendgrid')('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');

		var payload   = {
		  to      : email,
		  from    : 'password@rip.com',
		  subject : 'No-Reply Password Retreive From Roomie',
		  text    : 'Please log in again with your new password: ' + password
		}

		sendgrid.send(payload, function(err, json) {
		  if (err) { console.error(err); }
		  console.log(json);
		});
	}

	// function for generate password
	function generate_random_password(){
		return Math.random().toString(36).substring(8);
	}


	//function fro connection to sql
	function sql_connection(){

		var Connection = tedious.Connection;  
		var config = {  
		    userName: 'h4tu',  
		    password: 'R!Pdevl0g',  
		    server: 'rationallyimpairedprogrammers.database.windows.net',  
		    // If you are on Microsoft Azure, you need this:  
		    options: {encrypt: true, database: 'cse110_dev'}  
		};  
		var connection = new Connection(config);  

		return connection;
	}

	//accept client's subscription to listen to group's notification
	socket.on('password retreive',function(user_id, email){

		console.log("password retreive");

		//get the connection to database server 
		var connection = sql_connection();

		//generate the random password string
		var new_password = generate_random_password();

		connection.on('connect', function(err) {  
			// If no error, then good to proceed.  
		    console.log("Connected"); 

		    //build request for query
		    request = new Request("EXEC ChangePassword @userId = " + user_id 
		    		+ ", @password = '"+ new_password +"'", function(err) {  
			    if (err) {
			        console.log(err);
			    }  
		    });

		    //build request for query
		    request = new Request("EXEC ChangePassword @userId = " + user_id 
		    		+ ", @password = '"+ new_password +"'", function(err) {  
			    if (err) {
			        console.log(err);
			    }  
		    });  
		    //execute the query to change password
		    connection.execSql(request);  
		});

		//send the email via sendgrid
		send_email(email, new_password);

	});


}