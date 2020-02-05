#!/usr/bin/perl
# this profile just prints out the bio part of editProfile.shtml
# retrieves bio from users files and prints it in the textbox
use strict;
use CGI qw( :standard );
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

my $user = cookie("userid");
my $change = param("bio");

# if no parameter is passed, print off bio so user CAN change it
if( $change eq "" ) {
	open ( BIO, "users/$user/biography.txt" );
		my @bio = <BIO>;
	close( BIO );

	print header();
	print "<form action=\"editProfile.pl\" method=\"get\">";
	print "<hr/><h3>Update You Bio</h3>";
	print "<textarea placeholder=\"Enter bio\" id=\"bioText\" name=\"bio\">@bio</textarea><br/>";
	print "<input type=\"submit\" class=\"profileHeaderButton\" style=\"position:relative;\" value=\"Change\">";
	print "</form>";
}
else { # user wants to update bio
	open ( BIO, ">users/$user/biography.txt" );
		print BIO $change;
	close( BIO );
	
	print redirect( "home.shtml" );
}

