#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );
# Displays the header information of the user's profile. This includes the alpha, class, company and username

# Get userProfileInformation
my $profile = cookie( "profile" );
my $user    = cookie( "userid" );
my $isUser = 0; my $isFriend = 0;

if( $profile ne "" && $user ne "" ) { 
	if( $profile eq $user ) { $isFriend = 1; }
	else { 
		open( FIN, "users/$user/friends.txt" );
			my @friends = <FIN>;
		close( FIN );

		my $friend; 
		foreach $friend( @friends ) {
			chomp( $friend );
			if( $friend eq $profile ) {	$isFriend = 1; }
		}
	}
}
elsif( $profile eq "" && $user ne "" ) { $profile = $user; $isUser = 1 }
elsif( $profile ne "" && $user eq "" ) {}
else { }

open( FIN, "users/$profile/information.txt" );
	my( $userid, $username, $firstName, $lastName, $class, $company ) = split( "\t", <FIN> );
close( FIN );

print header();

print "<div id=\"profileHeader\"><img id=\"profileImage\" alt=\"profileImage\" src=\"users/$profile/profileImage.jpg\"/><h1 style=\"display:inline\">$firstName $lastName</h1><br/><span class=\"shadow\">\@$username</span><br/>";
if( $isUser ) {
	print "<a href=\"toProfile.pl?profile=$profile\"><button class=\"profileHeaderButton\" type=\"button\">View Profile</button></a><a href=\"path.pl?path=editProfile.shtml\"><button class=\"profileHeaderButton\" type=\"button\">Edit Profile</button></a>";
}
if( !$isFriend && !$isUser ) {
	print "<a href=\"path.pl?path=addFriend.pl?friend=$profile\"><button class=\"profileHeaderButton\" type=\"button\">Add as friend</button></a>";
}
print "</div>";
	
	
	
