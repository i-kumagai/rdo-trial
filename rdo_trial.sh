#!/bin/sh
# Timezoneの変更
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# パッケージインストール
yum install -y http://repos.fedorapeople.org/repos/openstack/openstack-icehouse/rdo-release-icehouse-4.noarch.rpm python-netaddr python-setuptools git

# PackStackの取得
git clone git://github.com/stackforge/packstack
cd packstack

# Pappetのインストール
python setup.py install_puppet_modules

# answer ファイル生成とバックアップ
bin/packstack --gen-answer-file=answers
cp -p answers answers.org

## answer ファイル書き換え
# EPELを利用するように修正 (Centの場合必須)
sed -i 's/CONFIG_USE_EPEL=n/CONFIG_USE_EPEL=y/' answers

# コンピュートノードのIPアドレスを,区切りリストで指定
sed -i s/CONFIG_COMPUTE_HOSTS=.*$/CONFIG_COMPUTE_HOSTS=${COMHOSTS}/ answers 

# nic インターフェースと OpenStack のvSwitcのインタフェースをあわせる
sed -i s/CONFIG_NOVA_COMPUTE_PRIVIF=.*$/CONFIG_NOVA_COMPUTE_PRIVIF=bond0/ answers
sed -i s/CONFIG_NOVA_NETWORK_PUBIF=.*$/CONFIG_NOVA_NETWORK_PUBIF=bond1/ answers
sed -i s/CONFIG_NOVA_NETWORK_PRIVIF=.*$/CONFIG_NOVA_NETWORK_PRIVIF=bond0/ answers

# floating IPレンジの指定(ポータブルIPを指定する)
sed -i s/CONFIG_PROVISION_DEMO_FLOATRANGE=.*$/CONFIG_PROVISION_DEMO_FLOATRANGE=${FLRANGE}/ answers

# インストールの実行
bin/packstack --answer-file=answers

