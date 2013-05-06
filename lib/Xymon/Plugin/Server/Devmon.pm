#
# Devmon data object
#
package Xymon::Plugin::Server::Devmon;

use strict;

=head1 NAME

Xymon::Plugin::Server::Devmon - Devmon data object

=head1 SYNOPSIS

    my $devmon = Xymon::Plugin::Server::Devmon
        ->new(ds0 => 'GAUGE:600:0:U',
              ds1 => 'GAUGE:600:0:U');

    $devmon->add_data(device1 => { ds0 => 0, ds1 => 2 });
    $devmon->add_data(device2 => { ds0 => 0, ds1 => 2 });

    # add to data to be reported.
    my $status = Xymon::Plugin::Server::Status
                 ->new("localhost.localdomain", "test1");

    $status->add_devmon($devmon);

=head1 DESCRIPTION

This module handles data structure for Xymon 'devmon' module.
To store data into RRD database, add entry to TEST2RRD variable
 in server config.

(named hobbitserver.cfg in Xymon 4.2, xymonserver.cfg in Xymon 4.3)

 ex.
  TEST2RRD="cpu=la,disk,...(snipped)...,test1=devmon"


=head1 SUBROUTINES/METHODS

=head2 new(ds1 => dsdef1, ...)

Create devmon object with data store definition.
(To know meanings of dsdef field, please read document in RRDTool.)

=cut

sub new {
    my $class = shift;
    my @datadef = @_;	# key, def, key, def, ...

    my @dskeys;
    my %dsdefs;

    while (@datadef) {
	my $key = shift @datadef;
	push(@dskeys, $key);
	$dsdefs{$key} = shift @datadef;
    }

    my $self = {
	_dskeys => \@dskeys,
	_dsdefs => \%dsdefs,
	_data => {},
    };

    bless $self, $class;
}

=head2 add_data(devname, { ds1 => ds1value, ...})

Set values for devname.

=cut

sub add_data {
    my $self = shift;
    my ($key, $values) = @_;

    $self->{_data}->{$key} = $values;
}

=head2 format

Format data structure to report to Xymon.

=cut

sub format {
    my $self = shift;
    my @ret;

    push(@ret, "<!--DEVMON RRD: ");
    my $dsline = join(" ",
		      map { join(':', 'DS', $_, $self->{_dsdefs}->{$_}) }
		      @{$self->{_dskeys}});

    push(@ret, $dsline);

    while (my ($key, $values) = each %{$self->{_data}}) {
	
	my $line = $key . " "
	    . join(":",
		   map { defined($values->{$_}) ? $values->{$_} : ''; }
		   @{$self->{_dskeys}});

	push(@ret, $line);
    }

    push(@ret, "-->\n");

    return join("\n", @ret); 
}

1;
