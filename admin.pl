#!/usr/bin/perl
# Prints out the main page for admin
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );
use POSIX 'strftime';

# Get userProfileInformation
my $admin = cookie( "userid" );

if( $admin ne "admin" ) { print redirect( "logout.pl" ); }

# Get users and push to array	
open( USERS, "users/users.txt" );
	my @users = <USERS>;
close( USERS );

# Sort array by alpha's
sub mySort($$) {
	my( $a, $b ) = @_;
	my ( $alpha1, @junk1 ) = split("\t", $a);
	my ( $alpha2, @junk2 ) = split("\t", $b);
	return $alpha1 - $alpha2;
}
@users = sort mySort @users;


# Get users and print
my $users; print header();
foreach $users( @users ) {
	chomp( $users );
	my( $user, @junk ) = split( "\t", $users );

	# Get friend's information
	open( FIN, "users/$user/information.txt" );
		my( $userid, $username, $firstName, $lastName, $class, $company ) = split( "\t", <FIN> );
	close( FIN );

	
	print "<div class=\"feedPost\">";
	print "<div id=\"profileHeader\" style=\"display:inline;border:0;position:relative;\"><img id=\"profileImage\" alt=\"profileImage\" src=\"users/$user/profileImage.jpg\"/><h1 style=\"display:inline\">$firstName $lastName</h1><span class=\"shadow\">\@$username</span><br/>";
	print "<a href=\"toProfile.pl?profile=$user\"><button class=\"profileHeaderButton\" type=\"button\">View Profile</button></a><a href=\"path.pl?path=deleteUser.pl?profile=$user\"><button class=\"profileHeaderButton\" type=\"button\">Delete User</button></a></div>";
	print "<table id=\"profileUserTable\"><tr><td>Username:</td><td>\@$username</td></tr><tr><td>Alpha:</td><td>$userid</td></tr><tr><td>Class:</td><td>$class</td></tr><tr><td>Company:</td><td>$company</td></tr></table>";
	print "</div>";
}
