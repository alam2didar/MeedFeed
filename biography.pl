#!/usr/bin/perl
# This Perl file retrieves user's bio and prints it out.
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# Get userProfileInformation
my $profile = cookie( "profile" );
my $user    = cookie( "userid" );

# check to see if it is the user viewing own page or another members page
if( $profile eq "" && $user ne "" ) { $profile = $user; }

# Save result in file. Use \t as a separator
open( BIO, "users/$profile/biography.txt" );
my @bio = <BIO>; #read entire file into array
close( BIO );

print header();

my $line;
foreach $line( @bio ) {
	chomp( $line );
	$line =~ s/\<(\/)*(\w)+\>//g;
	print $line;
}

	