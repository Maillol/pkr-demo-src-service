FROM python:3.6

WORKDIR /usr/src/app

RUN pip install uwsgi
RUN useradd -M uwsgi 

COPY requirements_prod.txt ./
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements_prod.txt

COPY . .
RUN chown -R uwsgi . 

ENV DJANGO_SETTINGS_MODULE=my_service.settings_prod

EXPOSE 8080/tcp


CMD [ "uwsgi", "--chdir", "/usr/src/app", "--uid", "uwsgi", "--http", "0.0.0.0:8080", "--wsgi", "my_service.wsgi:application" ]

