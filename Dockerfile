FROM centos:7

# Bundle app source
ADD app /app
WORKDIR /app

ADD .env /.env
RUN . /.env

EXPOSE 3000

CMD ["/app/exec"]
