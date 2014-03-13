FROM blalor/centos 
MAINTAINER @42wim
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
RUN yum -y install git gcc perl-CPAN tar mysql mysql-devel && curl -L http://cpanmin.us | perl - App::cpanminus
RUN git clone https://github.com/cvicente/Netdot.git
RUN cd Netdot && ( echo -n mysql;sleep 10;yes) | make rpm-install
RUN /usr/local/bin/cpanm -n install Apache2::Request Time::Local Net::Appliance::Session BIND::Config::Parser Net::DNS::ZoneFile::Fast Apache2::SiteControl Net::Patricia Authen::Radius Apache2::AuthCookie NetAddr::IP DBD::mysql
RUN cd /usr/share && curl -L "http://downloads.sourceforge.net/project/netdisco/netdisco-mibs/latest-snapshot/netdisco-mibs-snapshot.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fnetdisco%2Ffiles%2Fnetdisco-mibs%2Flatest-snapshot%2F&ts=1393793276&use_mirror=heanet" |tar zxvf -
ADD Site.conf /Netdot/etc/Site.conf
ADD init.sh /init.sh
RUN cd /Netdot && make install
RUN cp /usr/local/netdot/etc/netdot_apache2_local.conf /etc/httpd/conf.d/
RUN echo "PassEnv DB_PORT_3306_TCP_ADDR" >> /etc/httpd/conf.d/netdot_apache2_local.conf
