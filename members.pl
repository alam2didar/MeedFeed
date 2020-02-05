#!/usr/bin/perl

# Members.pl links all of the users to a different page: 
# Allows a person to see all users currently active on the website when clicking 'Members' tab

use strict;
use CGI qw( :standard );
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

# Print HTML STUFF
print header(); 
# Try to open file
open (USERS, "users/users.txt" );
my @users = <USERS>;
close( USERS );

# Print user names out to html
my $user;
foreach $user(@users) {
    chomp ($user);
	#split whenever you see a tab
	my($userid, @junk ) = split( "\t", $user );
	
	open( INFO, "users/$userid/information.txt" );
	my( $userID, $username, $firstName, $lastName, $class, $company ) = split( "\t", <INFO> );
	close( INFO );
	
	print "<span name=\"friendsLink\"><a href=\"toProfile.pl?profile=$userID\"><button class=\"submitButton\" type=\"button\" style=\"width:400px;\"><img id=\"profileImage\" style=\"height:40px;width:30px;vertical-align:center;left:-40px;float:left;\"src=\"users/$userID/profileImage.jpg\" alt=\"Profile Picture\"/>$firstName $lastName<br/><span class=\"shadow\" style=\"font-size:small;margin:0;padding:0;\">\@$username</span></button></a></span>";

	
}