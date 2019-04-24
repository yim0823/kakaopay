# -*- coding: utf-8 -*-

'''
Created on 2019. 4. 24.

@author: Taehyoung Yim
'''
import sys
import argparse
import subprocess

"""
python3 devops.py \
 --command [start | stop | restart | deploy| check]

or

python3 devops.py \
 -c start [start | stop | restart | deploy | check]
"""

SERVICE_NAME = 'kakaopay'
DOCKER_COMPOSE_PATH = '/usr/app/' + SERVICE_NAME

def run_shell(*cmd):
    popen = subprocess.Popen(cmd, stdout=subprocess.PIPE, universal_newlines=True)

    try:
        return popen.stdout.read()
    finally:
        popen.stdout.close()

def main(unused_args):
    command = FLAGS.command.lower()
    print(command)
    
    # sudo docker-compose -p kakaopay -f /usr/app/kakaopay/docker-compose.yml ps
    fileName = DOCKER_COMPOSE_PATH + '/docker-compose'
    
    print('Checking processes of the {}'.format(SERVICE_NAME))
    exist_blue = run_shell('sudo', 'docker-compose', '-p', SERVICE_NAME + '-blue', '-f', fileName + '.blue.yml', 'ps', '|', 'Up')
    
    print()
    exist_green = run_shell('sudo', 'docker-compose', '-p', SERVICE_NAME + '-green', '-f', fileName + '.green.yml', 'ps', '|', 'Up')
    if exist_blue != '':
        fileName = fileName + '.blue.yml'
        color = 'blue'
    elif exist_green != '':
        fileName = fileName + '.green.yml'
        color = 'green'
    else:
        fileName = fileName + '.blue.yml'
        color = 'blue'
    
    if command == 'start':
        print('# Start docker-compose')
        run_shell('sudo', 'docker-compose', '-f', fileName, 'start') # sudo docker-compose -f /usr/app/kakaopay/docker-compose.yml start
    elif command == 'stop':
        print('# Stop docker-compose')
        run_shell('sudo', 'docker-compose', '-f', fileName, 'stop') # sudo docker-compose -f /usr/app/kakaopay/docker-compose.yml stop
    elif command == 'stop':
        print('# Restart docker-compose')
        run_shell('sudo', 'docker-compose', '-f', fileName, 'restart') # sudo docker-compose -f /usr/app/kakaopay/docker-compose.yml restart
    elif command == 'deploy':
        print('# Start non-disruptive deployment')
        run_shell('sudo', 'sh', 'deploy.sh')
    elif command == 'check':
        print('# Check the service')
        run_shell('sudo', 'docker-compose', '-p', SERVICE_NAME + '-' + color, '-f', fileName + '.' + color + '.yml', 'ps', '|', 'Up')
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='The objective of this program is to operate web servers of the Kakaopay.')
    parser.register("type", "bool", lambda v: v.lower() == "true")
    parser.add_argument(
        "-c",
        "--command",
        required=True,
        type=str,
        default="",
        help="Choose one of the following: [start | stop | restart | deploy | check]")
    
    FLAGS, unparsed = parser.parse_known_args()
    main([sys.argv[0]] + unparsed)
