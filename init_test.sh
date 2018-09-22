#!/usr/bin/env bash

sleep 5  # Wait for postgres container to be running

cd /usr/src/app
python manage.py collectstatic --no-input
python manage.py migrate

# Create Superuser
python manage.py shell -c "
from django.contrib.auth.models import User;
from os import environ;

(
    User.objects.filter(is_superuser=True).first()
    or User.objects.create_superuser(
        environ['DJANGO_USERNAME'], '', environ['DJANGO_PASSWORD'])
)
"

uwsgi --chdir /usr/src/app --uid uwsgi --http 0.0.0.0:8080 --wsgi my_service.wsgi:application
