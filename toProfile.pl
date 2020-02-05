#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# Convenient way to redirect person to toProfile

my $profile = param( "profile" );

if( $profile eq "" ) { $profile = cookie("userid"); }

print "Set-Cookie: profile=$profile; expires=5s; \n";
print redirect( "profile.shtml" );
