#!/usr/bin/env python3

from pexpect import *
import os
import stat
import subprocess
import traceback

def checkTunnelDevice():
    try:
        deviceDir = '/dev/net'
        mode = 0o644 | stat.S_IFCHR
        if not os.path.exists(deviceDir):
            os.mkdir(deviceDir)
            os.mknod(deviceDir + '/tun', mode=mode, device=200)
    except Exception as e:
        raise e

def initOpenVpn():
    subprocess.run(['./easyrsa', 'init-pki'])

def buildCa():
    try:
        child = spawn('./easyrsa build-ca')
        child.expect('Enter*')
        child.sendline(passwd)
        child.expect('Re-Enter*')
        child.sendline(passwd)
        child.expect('Common Name*')
        child.sendline('tuimac')
    except Exception as e:
        raise e

if __name__ == '__main__':
    easyrsaDir = '/usr/share/easy-rsa/3'
    passwd = 'password'

    try:
        checkTunnelDevice()
        os.chdir(easyrsaDir)
        initOpenVpn()
        buildCa()
    except:
        traceback.print_exc()
