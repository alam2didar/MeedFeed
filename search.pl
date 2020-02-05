#!/usr/bin/perl
# login perl file
use strict;
use CGI qw( :standard );
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

# This is the search portion of the Website. It searches through all of the statuses
# matching the 'keyword' input. It's available on the navigation bar.

# Grab search keyword
my $search = cookie( "search" );
print header();

# Try to open file
open (USERS, "users/users.txt" );

my $user, my $junk, my @status;	# NOTE: $flag is an empty string -- important when handling if no search results

# Search through the users' statuses to find keyword
# users.txt is open--find usernames for each person
while ( my $line = <USERS> ) {
  chomp ($line);
  ( $user, $junk, $junk ) = split( "\t", $line );
  
  # Found a person's username -- open his/her status.txt to look for keyword
  open ( uStatus, "users/$user/status.txt" );
  
  # Loop through each person's status to match key word
  while ( my $uStatusLine = <uStatus> ) {
    chomp( $uStatusLine );
	my ( $time, $alpha, $status, $mood, $location ) = split( "\t", $uStatusLine );
	# Look for a match in each status
	  if ( $status =~ /$search/i ) {
	  
	  # Get friend's information
		open( FIN, "users/$alpha/information.txt" );
		my( $userid, $username, $firstName, $lastName, @junk ) = split( "\t", <FIN> );
		close( FIN );
		
	   my $timestamp;
			my $ago  = int((time-$time)/(30*24*60*60)); #months
			if( $ago == 0 ) { 
				$ago = int((time-$time)/(24*60*60)); #days
				if( $ago == 0 ) { 
					$ago = int((time-$time)/(60*60)); #hours
					if( $ago == 0 ) { 
						$ago = int((time-$time)/(60)); #minutes
						if( $ago == 0 ) { 
							$ago = int(time-$time); #seconds
							$timestamp = "$ago"."s ago";
						} else { $timestamp = "$ago"."m ago"; }
					} else { $timestamp = "$ago"."h ago"; }
				} else { $timestamp = "$ago"."d ago"; }
			} else { $timestamp = "$ago month(s) ago"; }
		
			$status =~ s/&&/<br\/>/g;
			if( $mood eq "0" ) { $mood = ""; }
			else { $mood = " -feeling $mood"; }
			if( $location eq "0" ) { $location = ""; }
			else { $location = "-at $location"; }
			push( @status, "$time&&<a class=\"feedLink\"href=\"toProfile.pl?profile=$userid\"><div class=\"feedPost\"><h5>$firstName $lastName</h5><span class=\"shadow\">\@$username<span class=\"date\">$timestamp</span></span><br/>$status<span class=\"shadow\">$mood</span><br/><span class=\"shadow\">$location</span></div></a>" );
		}
	  }
  }

# Handles no matches: Checks to see that the flag is still empty
if( @status ) {
  # Sort statuses by time
	sub statusSort($$) {
		my( $a, $b ) = @_;
		my ( $atime, $astatus ) = split("&&", $a);
		my ( $btime, $bstatus ) = split("&&", $b);
		return $btime - $atime;
	}
	my @sortedStatus = sort statusSort @status;

	# Print statuses
	my $line; 
	foreach $line( @sortedStatus ) {
		my ( $time, $status ) = split("&&", $line);
		print $status;
	}
}
else { print "<div class=\"feedPost\" style=\"text-align:center\"><h1>No matches found.<h1> </div>"; }