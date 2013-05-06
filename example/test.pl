use strict;

use lib './blib/lib';

use Xymon::Plugin::Server::Dispatch;

package MyMonitor;

use Xymon::Plugin::Server;
use Xymon::Plugin::Server::Status qw(:colors);
use Xymon::Plugin::Server::Devmon;

sub new {
    my $class = shift;
    my ($host, $test) = @_;

    my $self = {
	host => $host,
	test => $test,
    };

    bless $self, $class;
}

sub run {
    my $self = shift;

    my $status = Xymon::Plugin::Server::Status
	->new($self->{host}, $self->{test});

    my $devmon = Xymon::Plugin::Server::Devmon
	->new(ds0 => 'GAUGE:600:0:U',
	      ds1 => 'GAUGE:600:0:U');

    $devmon->add_data(MyData => { ds0 => 0, ds1 => 3 });
    $devmon->add_data(YourData => { ds0 => 3, ds1 => 2 });

    $status->add_status(GREEN, "test1");
    $status->add_status(GREEN, "test2");

    $status->add_message("Helloe world!\nThis is a test message\n");

    $status->add_devmon($devmon);

    $status->add_graph("test");

    $status->report;
}


package main;

my $dispatch = Xymon::Plugin::Server::Dispatch
    ->new('test' => 'MyMonitor');

$dispatch->run;
