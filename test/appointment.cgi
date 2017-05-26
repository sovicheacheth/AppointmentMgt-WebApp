#!/usr/bin/perl

#author: Sovichea Cheth

use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
print "Content-type: text/html\n\n";
#print "Content-Type: text/plain\n\n";
use DBI;
use DateTime;
use IO::File;
binmod STDOUT, ":utf8";
use utf8;


#Database connection
my $user = "";
my $password = "";
my $conn = DBI->connect("DBI:SQLite:database=appointment.db", $user, $password ) or die $DBI::errstr;


my $cgi = CGI->new();
print $cgi->header('text/html');

my $dateset = param('date') if (param('date'));
my $timeset = param('time') if (param('time'));
my $descset = param('description') if (param('description'));


if ($dateset && $timeset && $descset) {
 
	print $cgi->start_html(-title=>'Display Appointment');
	print "Date: $dateset | Time: $timeset | Description: $descset will be added to the database";

	my $stmt = q/INSERT INTO appointment (date, time, description) VALUES (?,?,?)/;
	my $sth = $conn->prepare($stmt);
	$sth->execute($dateset, $timeset, $descset);
	print "Successful Inserted!";

	print '<meta http-equiv="refresh" content="1;url=http://localhost/AppointmentProject/">';
} 

else{

	my @output;

	my $q = $conn->prepare('SELCT * FROM tblAppointment');
	$q -> execute;

	while(my $row = $q->fetchrow_hashref) {
		push @output, $row;
	}
    #print "hello";
	print to_json({data=> \@output});
}


#Close db connection
$conn->disconnect();
