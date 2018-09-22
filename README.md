# Dev mode

1) install dependencies

    ```bash
    pip install requirements.txt
    ```
2) Initialize service

    ```bash
    python manage.py migrate
    python manage.py createsuperuser
    ```

3) Run service    

    ```bash
    python manage.py runserver
    ```

And go to http://127.0.0.1:8000


4) Launch test

    ```bash
    ./functional_test.sh
    ```


# Pseudo-prod mode


1) Create my_service.env file containing:

    ```
    POSTGRES_PASSWORD=mypassword
    POSTGRES_USER=mydatabaseuser
    POSTGRES_DB=mydatabase
    SECRET_KEY=mysecretkey
    ```

2) Build and launch containers

    ```bash
    docker-compose up
    ```

3) Migrate database and create superuser

    ```bash
    docker-compose exec web python manage.py collectstatic
    docker-compose exec web python manage.py migrate
    docker-compose exec web python manage.py createsuperuser
    ```

And go to http://127.0.0.1


# CI mode

```bash
docker-compose -f docker-compose.test.yml -p ci build
docker-compose -f docker-compose.test.yml -p ci up -d
docker logs -f ci_test_1
docker wait ci_test_1
```
