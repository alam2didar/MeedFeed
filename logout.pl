#!/usr/bin/perl
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# Get cookies
my $username	= cookie( "userid" );
my $auth		= cookie( "auth" );

open( FIN, "users/authentication.txt" );
my @file = <FIN>;
close( FIN );

open( FOUT, ">users/authentication.txt" ); 
my $line;
foreach $line(@file) {
	if( !($line =~ /$username/) ) {
		print FOUT $line;
	}
}
close( FOUT );

print "Set-Cookie: userid=; expires=-1d; \n";
print "Set-Cookie: auth=; expires=-1d; \n";
print "Set-Cookie: profile=; expires=-1d; \n";
print redirect( "index.shtml" );



