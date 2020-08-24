FROM debian:stretch-slim

WORKDIR /

COPY _output/bin/kube-scheduler /usr/local/bin

CMD ["kube-scheduler"]