#
# plugin dispatcher
#
package Xymon::Plugin::Server::Dispatch;

use strict;
use warnings;

=head1 NAME

Xymon::Plugin::Server::Dispatch - Xymon plugin dispatcher

=head1 SYNOPSIS

    use Xymon::Plugin::Server::Dispatch;
    use YourMonitor;

    my $dispatch = Xymon::Plugin::Server::Dispatch
                   ->new('test' => 'YourMonitor');
    $dispatch->run;

    # You can this script into
    #  tasks.cfg (Xymon 4.3)
    #  hobbitlaunch.cfg (Xymon 4.2)

=cut;

use Xymon::Plugin::Server::Hosts;


=head1 SUBROUTINES/METHODS

=head2 new(testName1 => ModuleName1, ...)

Create dispatch object for tests and modules.

If testName has wildcard character(like http:*), $test will be ARRAYREF
when run method is called.

=cut

sub new {
    my $class = shift;
    my @keyvalue = @_;

    my @keys;
    my %dic;

    while (@keyvalue > 0) {
	my $key = shift @keyvalue;
	push(@keys, $key);
	$dic{$key} = shift @keyvalue;
    }

    my $self = {
	_keys => \@keys,
	_dic => \%dic,
    };

    bless $self, $class;
}

=head1 SUBROUTINES/METHODS

=head2 run

For every host listed in bb-hosts(Xymon 4.2) or hosts.cfg (Xymon 4.3),
following operation is executed.

    my $module = YourMonitor->new($host, $test);
    $module->run;

=cut

sub run {
    my $self = shift;

    for my $key (@{$self->{_keys}}) {
	my $module_class = $self->{_dic}->{$key};

	for my $entry (Xymon::Plugin::Server::Hosts->new->grep($key)) {
	    eval {
		my $host = $entry->[1];
		my $test = $entry->[2];

		my $module = $module_class->new($entry->[1], $entry->[2]);
		$module->run;
	    };
	    if ($@) {
		print STDERR $@;
	    }
	}
    }
}

1;
