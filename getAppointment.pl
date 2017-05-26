#!/usr/bin/perl

#author: Sovichea Cheth

use strict;
use warnings;
use CGI;
use DBI;
use JSON;

my $q = CGI->new();
my $search = $q->param('search');

print qq(Content-type: Application/JSON\n\n);
 
#DB connection
my $dbfile = "appointment_db.sqlite";
my $dsn      = "dbi:SQLite:dbname=$dbfile";
my $user     = "";
my $password = "";

my $dbh = DBI->connect($dsn, $user, $password, {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
});
 
my $sql = 'SELECT datetime, description FROM appointments where description LIKE "' . $search . '%"';
my $sth = $dbh->prepare($sql);
 
$sth->execute();
my @appointments;

while (my $row = $sth->fetchrow_hashref) {
   my @datetime = split /#/, $row->{datetime};
   
   my $appointment = '{ "date" : ' . '"' . $datetime[0] . '" , "time" : ' . '"' . $datetime[1] . '" , "description" : ' . '"' . $row->{description} . '" }';
   push @appointments, $appointment;
}
my $json_str = encode_json(\@appointments);
print $json_str;

#Close db connection
$dbh->disconnect;