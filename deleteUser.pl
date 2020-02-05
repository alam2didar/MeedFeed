#!/usr/bin/perl
# ONLY FOR ADMIN
# This Perl file allows the admin to delete user
# When user is deleted, it is deleted from users.txt and all of the users friend's friends list.
use strict;
use CGI qw( :standard );
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use File::Path 'rmtree';

my $profile = param("profile");

# save friends before deleting so can delete user from user's friend's friends list 
open( FRIENDS, "users/$profile/friends.txt" );
	my @friends = <FRIENDS>;
close( FRIENDS );

# delete users directory **** PLACED HERE FOR CATCHING TROUBLE **********
rmtree([ "users/$profile" ]) or die "could not delete";

# Try to open file
open (USERS, "users/users.txt" );
	my @users = <USERS>;
close( USERS );

# Delete user from users.txt
open( USERS, ">users/users.txt" );
	my $user;
	foreach $user(@users) {
		#split whenever you see a tab
		my(	$userid, @junk ) = split( "\t", $user );
		if( $userid ne $profile ) { print USERS $user; }
	}
close( USERS );

my $friend;
foreach $friend(@friends) {
	# read in $friends friends list to delete $profile
	chomp($friend);
	open( FRIENDS, "users/$friend/friends.txt" );
		my @fin = <FRIENDS>;
	close( FRIENDS );
	
	open( FOUT, ">users/$friend/friends.txt" );
		my $line;
		foreach $line(@fin) {
			chomp($line);
			if( $line ne $profile ) { print FOUT $line."\n"; }
		}
	close( FOUT );
}

print redirect("path.pl?path=admin.shtml");