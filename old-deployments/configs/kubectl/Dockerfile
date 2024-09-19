FROM alpine:3.16

WORKDIR /root/.kube

COPY ca.crt .
COPY client.crt .
COPY client.key .
COPY config .
COPY kubectl .
RUN chmod +x kubectl && mv kubectl /usr/local/bin