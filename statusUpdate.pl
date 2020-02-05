#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# Updates the status of a user -- appends to user/user/status.txt

# Get inputs from browser/user
my $user	  = param( "userid" );
my $status    = param( "status" );
my $mood	  = param( "mood" );
my $location  = param( "location" );

my $isUser = 0;
if( $user eq "" ) {
	$user = cookie( "userid" );
	$isUser = 1;
}

# get timestamp
my $timeStamp = time;

#check to see if parameters are empty
if( $location eq "" ) {
	$location = 0;
}
if( $mood eq "" ) {
	$location = 0;
}

$status =~ s/(\r*\n)+/&&/g;
$status =~ s/\<(\w)+\>//g;
$status =~ s/\<|\>//g;
# Save result in file. Use \t as a separator
open( OUTFILE, ">>users/$user/status.txt" );
print OUTFILE ( "$timeStamp\t$user\t$status\t$mood\t$location\n" );
close( OUTFILE );
	
if( $isUser ) {
	print redirect( "path.pl?path=home.shtml" );
}
else {
	print redirect( "toProfile.pl?profile=$user" );
}

