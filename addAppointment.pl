#!/usr/bin/perl

#author: Sovichea Cheth

use strict;
use warnings;
use CGI;
use DBI;
use JSON;
my $q = CGI->new();
my $date = $q->param('date');
my $time = $q->param('time');
my $description = $q->param('description');

my $datetime = $date . '#' . $time;

my $dbfile = "db_appointment.sqlite";
 
my $dsn      = "dbi:SQLite:dbname=$dbfile";
my $user     = "";
my $password = "";
my $dbh = DBI->connect($dsn, $user, $password, {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
});

$dbh->do('INSERT INTO appointments (datetime, description) VALUES (?, ?)',
  undef,
  $datetime, $description);
  
$dbh->disconnect;

print $q->redirect(-uri=>'http://localhost/AppointmentProject');