#!/usr/bin/perl
# login perl file
# checks if the user's name and password match. special case for admin
# creates an authorization code for the user that allows them to navigate through the user's site
use strict;
use CGI qw( :standard );
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

# Get inputs from browser/user
my $username 	= param( "user" );
my $password 	= param( "password" );

if( $username =~ /\@usna.edu/ ) {
	$username =~ s/\D//g;
}

my @users;
if( $username eq "admin" ) {
	open( USER, "assets/admin.txt" );
		@users = <USER>;
	close (USER);
}
else {
	# Try to open file
	open (USER, "users/users.txt" );
		@users = <USER>;
	close (USER);
}
my $line;
foreach $line( @users ) {	
	chomp ($line);
	my($userID, $uName, $pWord) = split( "\t", $line );

	# if both username and password match
	if( (($uName eq $username) || $userID eq $username) && ($password eq $pWord) ){
		# Create the cookie
		my $expires = gmtime( time() + 86400 );
	
		#create authentication code
		my @code = ( "0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","X","Y","Z" );
		my $authenticationCode = "";
		for( my $ii=0; $ii<20; $ii++ ) {
			my $rand = int(rand(36));
			$authenticationCode .= $code[$rand];
		}
		
		print "Set-Cookie: userid=$userID; expires=$expires; \n";
		print "Set-Cookie: auth=$authenticationCode; expires=$expires; \n";
	
		# Save authenticationCode
		open( FOUT, ">>users/authentication.txt" );
		print FOUT "$userID\t$username\t$authenticationCode\n";
		close( FOUT );
	
		# Then login to profile page
		if( $username eq "admin" ) { print redirect("path.pl?path=admin.shtml"); }
		print redirect("path.pl?path=home.shtml");
	}
}

print header();
print "<script type=\"text/javascript\">alert(\"Your email or password were incorrect.\");window.history.back();</script>";	
