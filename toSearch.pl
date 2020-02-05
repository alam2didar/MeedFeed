#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# Helper perl function that parses unwanted characters

my $search = param( "search" );

# parse unwanted character
$search =~ s/(\r*\n)+/ /g;
$search =~ s/\<(\w)+\>//g;

print "Set-Cookie: search=$search; expires=5s; \n";
print redirect( "search.shtml" );
