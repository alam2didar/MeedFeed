#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );
use POSIX 'strftime';

# Displays the status ( Feed ) for the user

# Get userProfileInformation
my $profile = cookie( "profile" );
my $user    = cookie( "userid" );
my $isFriend = 0;

if( $profile eq "" && $user ne "" ) { $profile = $user; $isFriend = 1 }


print header();

# Get friends and push to array	
open( FRIENDS, "users/$profile/friends.txt" );
my @friends = <FRIENDS>;
close( FRIENDS );

push( @friends, $profile );

# Get friend's status and push to array
my ( $friend, @status );
foreach $friend( @friends ) {
	chomp( $friend );

	# Get friend's information
	open( FIN, "users/$friend/information.txt" );
	my( $userid, $username, $firstName, $lastName, @junk ) = split( "\t", <FIN> );
	close( FIN );

	# Get friend's status
	open( INFILE, "users/$friend/status.txt" );
	my @fileLines = <INFILE>; #read entire file into array
	close( INFILE );
	
	my $bLine;
	foreach $bLine( @fileLines ) {
		chomp( $bLine );
		my ( $time, $alpha, $status, $mood, $location ) = split("\t", $bLine); 

		# do calculations to find out time lapse since post
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
	
		$status =~ s/&&/ /g;
		if( $mood eq "0" ) { $mood = ""; }
		else { $mood = " -feeling $mood"; }
		if( $location eq "0" ) { $location = ""; }
		else { $location = "-at $location"; }
		
		# Print the delete status button for user
		if( $friend eq $profile && $profile eq $user ) {
			push( @status, "$time&&<div class=\"feedPost\" style=\"min-height:60px;\"><a class=\"feedLink\"href=\"toProfile.pl?profile=$userid\"><img id=\"profileImage\" style=\"height:50px;width:45px;vertical-align:center;\"src=\"users/$userid/profileImage.jpg\" alt=\"Profile Picture\"/><h5>$firstName $lastName</h5><span class=\"shadow\">\@$username</a><span class=\"date\">$timestamp</span></span><br/>$status<span class=\"shadow\">$mood</span><br/><span class=\"shadow\">$location</span><form style=\"position:relative;float:right;\" method=\"post\" action=\"deleteStatus.pl\"><input type=\"hidden\" name=\"time\" value=\"$time\"/><button class=\"shadow\" style=\"background:transparent;border:none!important;\" type=\"submit\">x</button></form></div>" );
		}
		else {
			push( @status, "$time&&<div class=\"feedPost\" style=\"min-height:60px;\"><a class=\"feedLink\"href=\"toProfile.pl?profile=$userid\"><img id=\"profileImage\" style=\"height:50px;width:45px;vertical-align:center;\"src=\"users/$userid/profileImage.jpg\" alt=\"Profile Picture\"/><h5>$firstName $lastName</h5><span class=\"shadow\">\@$username</a><span class=\"date\">$timestamp</span></span><br/>$status<span class=\"shadow\">$mood</span><br/><span class=\"shadow\">$location</span></div>" );
		}
	}
}

# Sort statuses by time
sub statusSort($$) {
	my( $a, $b ) = @_;
	my ( $atime, $astatus ) = split("&&", $a);
	my ( $btime, $bstatus ) = split("&&", $b);
	return $btime - $atime;
}
my @sortedStatus = sort statusSort @status;

# Print max of 50 statuses
my $length = @sortedStatus;
for( my $ii = 0; $ii < $length || $ii < 50; $ii++) {
	my ( $time, $status ) = split("&&", @sortedStatus[$ii]);
	print $status;
}


	
	
	
