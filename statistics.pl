#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# This is the statistics page -- Made by Kim

# REQUIREMENTS :
#				(1) NUMBER of members
#				(2) NUMBER of status updates
#				(3) Aggregate count of Moods over all status updates

# VARIABLES:
			my $memCount=0, my $statCount=0;
# MOODS:
			my $madCount=0, my $sadCount=0, my $happyCount=0, my $chillCount=0;

# (1) Number of Members
open( MEM, "users/users.txt" );
my @MEM = <MEM>;
close( MEM );

my $line, my $junk, my @junk;

foreach $line( @MEM ) {
  chomp ($line);
  $memCount = $memCount + 1;
}

my $uLine;
# (2) Number of status updates
open( USERS, "users/users.txt" );
my @USERS = <USERS>;
close( USERS );

my $user;

# For each user found, check through their status.txt
foreach $uLine( @USERS ) {
  chomp( $uLine );
  my( $user, $junk, $junk ) = split( "\t", $uLine );
  
  # Opens each user's status and counts each status update
  open( STAT, "users/$user/status.txt" );
  while( my $sLine = <STAT> ) {
    chomp( $sLine );
	$statCount = $statCount + 1;	# Increment counter for each status in users
	
	
	# Check the user's Mood and add to appropriate one
	my( $junk, $junk, $junk, $mood, $junk ) = split( "\t", $sLine );
	# Check to see what the mood
	if( $mood eq 'Mad' ) {
	  $madCount=$madCount+1;
	}
	if( $mood eq 'Sad' ) {
	  $sadCount=$sadCount+1;
	}
	if( $mood eq 'Happy' ) {
	  $happyCount=$happyCount+1;
	}
	if( $mood eq 'Chillin...' ) {
	  $chillCount=$chillCount+1;
    }
  }	
  close( STAT );
}

# Print the rest of the information
print header();
print '<div class="feedPost">';
print "Number of current Members: $memCount.<br />";
print "Number of statuses: $statCount. </br>";
print "Mood counter: $madCount Mad posts, $sadCount Sad Posts, $happyCount Happy posts, $chillCount Chilling Post.";
print '</div>';


