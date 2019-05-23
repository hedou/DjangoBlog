#!/bin/bash
NAME="djangoblog" # Name of the application
DJANGODIR=/root/test/DjangoBlog # Django project directory
USER=root # the user to run as
GROUP=root # the group to run as
NUM_WORKERS=1 # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=DjangoBlog.settings # which settings file should Django use
DJANGO_WSGI_MODULE=DjangoBlog.wsgi # WSGI module name


echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
#pip install -Ur requirements.txt -i http://pypi.douban.com/simple/  --trusted-host pypi.douban.com && \
#        pip install gunicorn  -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com
python3 manage.py makemigrations 
python3 manage.py migrate
python3 manage.py collectstatic --noinput 
python3 manage.py compress --force
# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
--name $NAME \
--workers $NUM_WORKERS \
--user=$USER --group=$GROUP \
--bind 0.0.0.0:8081 \
--log-level=debug \
--log-file=-

