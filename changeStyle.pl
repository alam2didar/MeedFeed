#!/usr/bin/perl
# This Perl file allows user to change the styling of their page
# This file just copies one of the saved themes and replaces the users style.css
use strict;
use CGI qw( :standard );
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use File::Copy;

# this code allows the user to change which type of style they want.
my $user = cookie("userid");
my $color = param("color");

$color = $color.".css";

copy( "assets/colorTheme/$color", "users/$user/css/styles.css");
print redirect( "path.pl?path=editProfile.shtml" );