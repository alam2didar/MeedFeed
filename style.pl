#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# Convenient print for the css style

# Get inputs from browser/user
my $user	  = cookie( "userid" );

print header();
if( $user ne "" && $user ne "admin" ) { 
	print "<link rel=\"stylesheet\" href=\"users/$user/css/styles.css\"/>";	
}
else{
	print "<link rel=\"stylesheet\" href=\"assets/css/styles.css\"/>"
}

