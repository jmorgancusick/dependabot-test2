FROM python:3.8.4@sha256:b02c5b8aa0ace8a50cf460e1d3421166dbf61443471744f1aca6d2cffe6cdd70

ARG DJANGO_UID=1000
ARG DJANGO_GID=1000
ARG PIPENV_DEV=false

ENV PIPENV_DEV=$PIPENV_DEV

RUN pip3 install pipenv

RUN groupadd -g "$DJANGO_GID" django
RUN useradd -m -s /bin/bash -u "$DJANGO_UID" -g "$DJANGO_GID" django

# wont be created by root, since already exists
WORKDIR /home/django

USER django

COPY --chown=django:django . .

RUN pipenv install

ENV PYTHONPATH "${PYTHONPATH}:/home/django"

CMD ["pipenv", "run", "python3", "manage.py", "runserver", "0.0.0.0:8000"]
