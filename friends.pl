#!/usr/bin/perl
# This Perl file prints out the friends section of profile and home page
# Only prints out 4 friends, chosen at random.
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# Get userProfileInformation
my $profile = cookie( "profile" );
my $user    = cookie( "userid" );
my $isUser = 0;

if( $profile eq "" && $user ne "" ) { $profile = $user; $isUser = 1 }

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
my $friend;
foreach $friend( @friends ) {
	chomp( $friend );

	open( FIN, "users/$friend/information.txt" );
		my( $userid, $username, $firstName, $lastName, $class, $company ) = split( "\t", <FIN> );
	close( FIN );
		
	print "<span name=\"friendsLink\"><a href=\"toProfile.pl?profile=$friend\"><button class=\"submitButton\" type=\"button\"><img id=\"profileImage\" style=\"height:40px;width:30px;vertical-align:center;left:-40px;float:left;\"src=\"users/$userid/profileImage.jpg\" alt=\"Profile Picture\"/>$firstName $lastName<br/><span class=\"shadow\" style=\"font-size:small;margin:0;padding:0;\">\@$username</span></button></a></span>";
		
}
if( $isUser == 0 ) {
	print "<hr/><a id=\"toFriends\" href=\"friends.shtml\"><button id=\"viewFriends\" class=\"submitButton\" style=\"margin-left:-10px;width:380px;\"type=\"button\">View Friends</button></a>";
}	
	