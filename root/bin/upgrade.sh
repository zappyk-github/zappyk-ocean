stage=$1
stage_0_path='~'
stage_1_name="upgrade-$HOSTNAME-`date +'%F'`"
stage_2_vers='Fedora 10 (Cambridge)'
stage_3_vers='10'
stage_3_arch='i386'
stage_3_repo="ftp://download.fedora.redhat.com/pub/fedora/linux/releases/$stage_2_vers/Fedora/$stage_2_arch/os/Packages/fedora-release-"
stage_4_repo='
http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-rawhide.noarch.rpm
http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm
http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-rawhide.noarch.rpm
'

_die() { _write "$*"; exit 1; }
_write() { echo "$*"; }
_install_preupgrade() {
	_write "Init stage $stage..."
	yum clean all && yum update && yum install preupgrade && yum clean all && return 1
	_die "Package 'preupgrade' not installed!"
}
_stage_set() {
	stage=0
	for file in `ls "$stage_0_path/$stage_1_name."?`; do
	    file_name=`basename "$file"`
	    IFS=$'.' read name stage < <(echo "$file_name")
	done
	stage=$(($stage + 1))
}
_stage_0() {
	_write "Init stage $stage..."
#CZ#	preupgrade
	preupgrade-cli
	[ $? -eq 127 ] && _install_preupgrade
	return 1
}
_stage_1() {
	_write "Init stage $stage..."
	rpm -qa --qf '%-50{NAME} %{VERSION}-%{RELEASE} %{ARCH}\n' | sort | tee "$stage_0_path/$stage_1_name-rpm-query-all.txt" || return 0
	tar -zcvf "$stage_0_path/$stage_1_name-root-etc.tar.gz" /etc || return 0
	return 1
}
_stage_2() {
	_write "Init stage $stage..."
	preupgrade-cli "$stage_2_vers" || return 0
	echo 'Now reboot!'
	return 1
}
_stage_3() {
	_write "Init stage $stage..."
	rpm -Uvh $stage_3_repo*.noarch.rpm && yum upgrade || return 0
	return 1
}
_stage_4() {
	_write "Init stage $stage..."
	rpm -Uvh $stage_4_repo && yum update || return 0
	return 1
}
_stage_save() { touch "$stage_0_path/$stage_1_name.$stage"; }

[ -z "$stage" ] && _stage_set

case "$stage" in
    0) _stage_0 && _stage_save ;;
    1) _stage_1 && _stage_save ;;
    2) _stage_2 && _stage_save ;;
    3) _stage_3 && _stage_save ;;
    4) _stage_4 && _stage_save ;;
    *) _die "Stage '$stage' not exist!" ;;
esac
