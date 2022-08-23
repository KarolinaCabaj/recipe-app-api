FROM python:3.9-alpine3.13

ENV PYTHONUNBUFFERED 1

COPY backend/requirements.txt /tmp/requirements.txt
COPY backend/requirements.dev.txt /tmp/requirements.dev.txt
COPY backend/app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

# RUN chown django-user:django-user -R /app/ && \
#     chmod +x /app
#
# USER django-user