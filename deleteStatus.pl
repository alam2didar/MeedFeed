#!/usr/bin/perl
# This Perl file allows a user to delete their own status. 
# Only works for the user and only on user's homepage
# Doesn't work when viewing profile
use strict;
use CGI qw( :standard );
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

# Take in the user's cookie to make sure it is the user who is deleting the status -- not anyone else
my $profile = cookie( "userid" );
# Also take the time stamp of the status to find which one to delete
my $delete = param( "time" );

# Try to open file
open( STATUS, "users/$profile/status.txt" );
	my @status = <STATUS>;
close( STATUS );

# Delete the status from status.txt
open( STATUS , ">users/$profile/status.txt" );
	my $stat;
	foreach $stat(@status) {
		#split whenever you see a tab
		my(	$compare, @junk ) = split( "\t", $stat );
		if( $compare != $delete ) { print STATUS $stat; }
	}
close( STATUS );

print redirect( "path.pl?path=home.shtml" );