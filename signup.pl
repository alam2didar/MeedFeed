#!/usr/bin/perl
# Signup perl file -- Takes in the user's information and inputs it into user.txt and makes their own directory
use strict;
use CGI qw( :standard );
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use File::Copy::Recursive qw(fcopy dircopy);

# Get inputs from browser/user
my $fName 		= param("fname");
my $lName 		= param("lname");
my $cYear 		= param("class");
my $company 	= param("company");
my $userid 		= param("userid");
my $username    = param("username");
my $password 	= param("password");
my $bio			= param("bio");

if( !$fName || !$lName || !$cYear || !$company || !$userid || !$username || !$password || !$bio ) {
	print header(); print start_html();
	print "<script type=\"text/javascript\">alert(\"There seems to be an issue with your signup. Try again.\");window.history.back();</script>";
	print end_html();
	die;
}
# Function to create user profile
if( !$userid || $userid eq "" ) {
	print header(); print start_html();
	print "<script type=\"text/javascript\">alert(\"There seems to be an issue with your signup\");window.history.back();</script>";
	print end_html();
	die;
} 

#check to see if username is used
open( USERS, "users/users.txt" );
	my @users = <USERS>;
close( USERS );

my $line;
foreach $line( @users ) {
	chomp( $line );
	my( $checkId, $checkName, $junk ) = split( "\t", $line );
	if( $checkId eq $userid || $username eq $checkName || $username eq "admin" || $userid eq "admin") {
		print header(); print start_html();
		print "<script type=\"text/javascript\">alert(\"User $userid already exsist.\");window.history.back();</script>";
		print end_html();
		die;
	}
}


sub createDir {
  my $directory = "users/$userid";
    unless(mkdir $directory) {
		print header(); print start_html();
		print "<script type=\"text/javascript\">alert(\"User $userid already exsist.\");window.history.back();</script>";
		print end_html();
		die;
    }
}
createDir();
fcopy( "assets/profileImage.jpg", "users/$userid/profileImage.jpg");
dircopy( "assets/css", "users/$userid/css" );

# Save inputs into a user file
open ( OUTFILE, ">>users/$userid/information.txt" );
	print OUTFILE $userid."\t";
	print OUTFILE $username."\t";
	print OUTFILE $fName."\t";
	print OUTFILE $lName."\t";
	print OUTFILE $cYear."\t";
	print OUTFILE $company;
close ( OUTFILE );

# Save the user 
# Format is USER PASSWORD
open( SAVE, ">>users/users.txt" );
	print SAVE $userid."\t";
	print SAVE $username."\t";
	print SAVE $password."\n";
close( SAVE );

open( SAVE, ">>users/$userid/biography.txt" );
	print SAVE $bio."\n";
close( SAVE );

print redirect("index.shtml");
