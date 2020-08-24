FROM debian:stretch-slim

WORKDIR /

COPY bin/kube-scheduler /usr/local/bin

CMD ["kube-scheduler"]
