FROM centos:7
RUN yum -y update && yum -y group install "development tools" && yum -y install epel-release mod_perl-devel mod_perl httpd http-devel git gcc perl-CPAN tar mysql mysql-devel && yum -y install libapreq2 && curl -L http://cpanmin.us | perl - App::cpanminus
RUN git clone https://github.com/cvicente/Netdot.git
RUN cd /Netdot && ( echo -n mysql;sleep 10;yes) | make rpm-install
RUN /usr/local/bin/cpanm -n install http://cpan.metacpan.org/authors/id/S/SH/SHAY/Apache-Test-1.39.tar.gz Class::DBI Class::DBI::AbstractSearch HTML::Mason SQL::Translator Net::IRR Time::Local Net::Appliance::Session BIND::Config::Parser Net::DNS::ZoneFile::Fast Apache2::SiteControl Net::Patricia Authen::Radius Apache2::AuthCookie NetAddr::IP
RUN cd /usr/share && curl -L "http://downloads.sourceforge.net/project/netdisco/netdisco-mibs/latest-snapshot/netdisco-mibs-snapshot.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fnetdisco%2Ffiles%2Fnetdisco-mibs%2Flatest-snapshot%2F&ts=1393793276&use_mirror=heanet" |tar zxvf -
ADD Site.conf /Netdot/etc/Site.conf
ADD init.sh /init.sh
RUN cd /Netdot && make install
RUN rpm --erase perl-SNMP-Info
RUN cd / && git clone https://github.com/42wim/snmp-info.git && cd snmp-info && git checkout develop && perl Makefile.PL && make && make install
RUN cp /usr/local/netdot/etc/netdot_apache24_local.conf /etc/httpd/conf.d/
RUN sed -i '1iPerlPassEnv MYSQL_PORT_3306_TCP_ADDR' /etc/httpd/conf.d/netdot_apache24_local.conf
