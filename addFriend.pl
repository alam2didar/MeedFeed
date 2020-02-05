#!/usr/bin/perl
# This Perl Function allows users to add a friend.
# Adds friend to users friend's list and vise versa
# Then adds status to users status feed saying that friend was added.
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# Get inputs from browser/user
my $friend	 = param( "friend" );
my $user	 = cookie( "userid" );
my $auth  	 = cookie("auth");

# Save $friend for $user
open( OUTFILE, ">>users/$user/friends.txt" );
print OUTFILE ( "$friend\n" );
close( OUTFILE );

# Save $user for $friend
open( OUTFILE, ">>users/$friend/friends.txt" );
print OUTFILE ( "$user\n" );
close( OUTFILE );

# Print status saying that $user has added $friend
open( FIN, "users/$user/information.txt" );
my ($userid, $username, $ufname, $ulname, @ujunk) = split( "\t", <FIN> );
close( FIN );

open( FIN, "users/$friend/information.txt" );
my ($fid, $fname, $ffname, $flname, @fjunk) = split( "\t", <FIN> );
close( FIN );

my $status = "$ufname $ulname is now friends with $ffname $flname!";

print redirect( "statusUpdate.pl?user=$friend&status=$status" );

