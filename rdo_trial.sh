#!/bin/sh
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
yum install -y http://repos.fedorapeople.org/repos/openstack/openstack-icehouse/rdo-release-icehouse-4.noarch.rpm python-netaddr python-setuptools git
git clone git://github.com/stackforge/packstack
cd packstack
python setup.py install_puppet_modules
bin/packstack --gen-answer-file=answers
cp -p answers answers.org
#sed -i 's/CONFIG_AMQP_SERVER=qpid/CONFIG_AMQP_SERVER=rabbitmq/' answers
sed -i 's/CONFIG_USE_EPEL=n/CONFIG_USE_EPEL=y/' answers
sed -i s/CONFIG_COMPUTE_HOSTS=.*$/CONFIG_COMPUTE_HOSTS=${COMHOSTS}/ answers 

sed -i s/CONFIG_NOVA_COMPUTE_PRIVIF=.*$/CONFIG_NOVA_COMPUTE_PRIVIF=bond0/ answers
sed -i s/CONFIG_NOVA_NETWORK_PUBIF=.*$/CONFIG_NOVA_NETWORK_PUBIF=bond1/ answers
sed -i s/CONFIG_NOVA_NETWORK_PRIVIF=.*$/CONFIG_NOVA_NETWORK_PRIVIF=bond0/ answers
sed -i s/CONFIG_PROVISION_DEMO_FLOATRANGE=.*$/CONFIG_PROVISION_DEMO_FLOATRANGE=${FLRANGE}/ answers
bin/packstack --answer-file=answers



#    1  b0ip=`ifconfig bond0|grep "inet addr"|awk -F '[ :]*' '{print $4}'`
#    2  echo $b0ip
#    3  b1ip=`ifconfig bond1|grep "inet addr"|awk -F '[ :]*' '{print $4}'`
#openstack-neutron-ml2.noarch 0:2014.1.3-1.el6
