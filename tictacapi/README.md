# TICTACTOE

This is a simple guide to get the tictactoe game up and running in a local machine environment.


* System dependencies
This game version requires the target system to have installed:
	- Ruby 2.2.5
	- Rails 5
	- Javascript
	- Postgresql 

* Setup 

This version has been written on a Windows x64 system. As a result, some incompatibility may occur.
To install, clone the repo in the target system

**For the back end
1. From a command line, open the tictactoe repo directory.
2. `cd` to the tictacapi directory
3. Type `rake db:migrate` to create the database
4. When its completed successfully, 
5. Type `rails s` to start the server

**For the front end
1. Go back to the 'tictactoe' repo directory
2. Right click on the 'tictactoe.html' file and choose 'Open in browser'
3. When it opens, you can then play the game.