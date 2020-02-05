#!/usr/bin/perl -w
use strict;
use CGI qw( :standard );
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );
use CGI;
use CGI::Carp qw ( fatalsToBrowser );
use File::Basename;

# Perl script to upload photos when editing user's profile

# Get userProfileInformation
my $user    = cookie( "userid" );
######
$CGI::POST_MAX = 1024 * 5000;
my $query = new CGI;
my $filename = $query->param("photo");
my $upload   = $query->param("uploadPhotoButton");

#####

##ALAM
#UPLOAD file, check for valid file name
#specify the directory to save the picture
my $safe_filename_characters = "a-zA-Z0-9_.-";
my $upload_dir = "users/$user";

# following codes only executes on click of a upload button
if ($filename && $upload)
{
my ( $name, $path, $extension ) = fileparse ( $filename, '..*' );
$filename = $name . $extension;
$filename =~ tr/ /_/;
$filename =~ s/[^$safe_filename_characters]//g;

if ( $filename =~ /^([$safe_filename_characters]+)$/ )
{
$filename = $1;
}
else
{
die "Filename contains invalid characters";
}

my $upload_filehandle = $query->upload("photo");

open ( UPLOADFILE, ">$upload_dir/$filename" ) or die "$!";
binmode UPLOADFILE;

while ( <$upload_filehandle> )
{
print UPLOADFILE;
}

close UPLOADFILE;
#replace
#unlink "$upload_dir/profileImage.jpg" or print "$!";
rename "$upload_dir/$filename", "$upload_dir/profileImage.jpg" or print "$!";
#done so go back to profile
print redirect("path.pl?path=editProfile.shtml");
}
elsif ( $upload ) {
print redirect("path.pl?path=editProfile.shtml");
}
#executes generally all other time to create the option to upload pictures
else {
print header();
#print <<HTML;
print "<h3>Change Your Profile Picture</h3>";
print "<img style=\"height:300px;width:240px;-moz-border-radius:5px;-webkit-border-radius:5px;\" src=\"users/$user/profileImage.jpg\" alt=\"Profile Image\"/>";
print "<br/>";
print "<form action=\"uploadPhoto.pl\" method=\"post\"enctype=\"multipart/form-data\">";
print "<input class=\"profileHeaderButton\" type=\"file\" name=\"photo\" />";
print "<input class=\"profileHeaderButton\" type=\"submit\" name=\"uploadPhotoButton\" value=\"Upload\" />";
print "</form>";

#HTML
}

######

	








	
