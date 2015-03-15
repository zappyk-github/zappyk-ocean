#git clone    https://github.com/ruzickap/linux.xvx.cz.git
########################################################################################################################
 svn checkout https://github.com/ruzickap/linux.xvx.cz.git/trunk/files/systemd_cheatsheet systemd_cheatsheet~
 rm -vRf systemd_cheatsheet~/.svn && diff -dqr systemd_cheatsheet systemd_cheatsheet~ && rm -vRf systemd_cheatsheet~
