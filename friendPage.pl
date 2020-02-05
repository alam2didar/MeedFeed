#!/usr/bin/perl
# this perl file prints out all of your friends in alpha numerical order
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# Get userProfileInformation
my $profile = cookie( "profile" );
my $user    = cookie( "userid" );
my $isFriend = 0;

if( !$profile) { $profile = $user; }

# Save result in file. Use \t as a separator
open( FRIENDS, "users/$profile/friends.txt" );
my @friends = <FRIENDS>; #read entire file into array
close( FRIENDS );


# sort friends by alpha
sub mySort($$) {
	my( $a, $b ) = @_;
	my ( $alpha1, @junk1 ) = split("\t", $a);
	my ( $alpha2, @junk2 ) = split("\t", $b);
	return $alpha1 - $alpha2;
}
@friends = sort mySort @friends;


print header();

# print out friend button
my $friend; my $i = 0;
foreach $friend( @friends ) {
	chomp( $friend );
	
	open( FIN, "users/$friend/information.txt" );
	my( $userid, $username, $firstName, $lastName, $class, $company ) = split( "\t", <FIN> );
	close( FIN );
	
	print "<a href=\"toProfile.pl?profile=$friend\"><button class=\"submitButton\" type=\"button\">$firstName $lastName</button></a>";

	if( $i == 3 ) { print "<br/>"; $i = 0; }
	
}

	