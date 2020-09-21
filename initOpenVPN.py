#!/usr/bin/env python3

from pexpect import *
import os
import subprocess

if __name__ == '__main__':
    easyrsaDir = '/usr/share/easy-rsa/3'
    passwd = 'password'

    os.chdir(easyrsaDir)
    subprocess.run(['./easyrsa', 'init-pki'])
    child = spawn('./easyrsa build-ca')
    child.expect('Enter*')
    child.sendline(passwd)
    child.expect('Re-Enter*')
    child.sendline(passwd)
    child.expect('Common Name*')
    child.sendline('tuimac')
