#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# This perl file checks to see if the user is logged in and the credentials match.
# If not, then the user is redirected to the home page to sign in (or sign up).

# Get inputs from browser/user
my $path	  = param( "path" );
my $user	  = cookie( "userid" );
my $auth  	  = cookie("auth");

#check to see users exist 
if( $user ne "" && $auth ne "" ) {
	# Open file to check if authentications match
	open (FILE, "users/authentication.txt");
		my @file = <FILE>;
	close (FILE);

	print "Set-Cookie: profile=; expires=-1d; \n";
	my $line;
	foreach $line(@file) {
		chomp($line);
		(my $userID, my $username, my $pswd)= split("\t", $line );
		if($user eq $userID && $auth eq $pswd) {
			if( $path ne "" ) {
				print redirect( "$path" );
			}
			else { redirect( "home.shtml" ); }
		}
	}
}
else {
	print header();
	print "<script type=\"text/javascript\">alert(\"Not logged in.\");window.location=\"index.shtml\";</script>";
}