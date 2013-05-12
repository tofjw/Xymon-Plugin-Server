Xymon-Plugin-Server
===================

Xymon-Plugin-Server contains some modules to write Xymon plugins
run at server side.

INSTALLATION
------------

To install this module, run the following commands:

    perl Makefile.PL
    make
    make test
    make install


HOW TO USE
----------

This section describes basic method to run plugin.

Put following script named 'simple.pl' into $XYMONHOME/ext
($XYMONHOME may be set like "/home/xymon/server")

    use strict;

    use Xymon::Plugin::Server::Dispatch;
    use Xymon::Plugin::Server::Status qw(:colors);
    
    sub simple_test {
        my ($host, $test, $ip) = @_;
    
        my $status = Xymon::Plugin::Server::Status->new($host, $test);
        $status->add_status(GREEN, "simple test ok!");
        $status->report;
    }
    
    my $dispatch = Xymon::Plugin::Server::Dispatch
        ->new(simple => \&simple_test);

    $dispatch->run;

Add new test tag 'simple' to host entry in $XYMONHOME/etc/hosts.cfg like:

    127.0.0.1   localhost.localdomain      # test1 ... testx simple

To run simple.pl periodically, add entry to $XYMOMHOME/etc/tasks.cfg like:

    [simple]
        ENVFILE $XYMONHOME/etc/xymonserver.cfg
        CMD perl $XYMONHOME/ext/simple.pl
        LOGFILE $XYMONSERVERLOGS/simple.log
        INTERVAL 5m

After all, wait for a few minutes until script is invoked.


SUPPORT AND DOCUMENTATION
-------------------------

After installing, you can find documentation for this module with the
perldoc command.

    perldoc Xymon::Plugin::Server

You can also look for information at:

* Xymon
    * http://xymon.sourceforge.net/

* RRDTool
    * http://oss.oetiker.ch/rrdtool/

* RT, CPAN's request tracker (report bugs here)
    * http://rt.cpan.org/NoAuth/Bugs.html?Dist=Xymon-Plugin-Server

* AnnoCPAN, Annotated CPAN documentation
    * http://annocpan.org/dist/Xymon-Plugin-Server

* CPAN Ratings
    * http://cpanratings.perl.org/d/Xymon-Plugin-Server

* Search CPAN
    * http://search.cpan.org/dist/Xymon-Plugin-Server/


LICENSE AND COPYRIGHT
---------------------

Copyright (C) 2013 Toshimitsu FUJIWARA

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

* http://www.perlfoundation.org/artistic_license_2_0

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
