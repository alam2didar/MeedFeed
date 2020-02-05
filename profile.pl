#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# This perl file generates the user's profile page. 
# It shows the either the user's profile or another person's profile page.

# Get userProfileInformation
my $profile = cookie( "profile" );
my $user    = cookie( "userid" );

if( $user ne "" ) { 
	if( $profile eq $user || $profile eq "" ) { $profile = $user; }
}

open( FIN, "users/$profile/information.txt" );
my( $userid, $username, $firstName, $lastName, $class, $company ) = split( "\t", <FIN> );
close( FIN );	

print header();
print "<table id=\"profileUserTable\"><tr><td>Username:</td><td>\@$username</td></tr><tr><td>Alpha:</td><td>$userid</td></tr><tr><td>Class:</td><td>$class</td></tr><tr><td>Company:</td><td>$company</td></tr></table>";

