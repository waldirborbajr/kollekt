# Build Stage
FROM golang:1.22-alpine as builder

RUN apk add --no-cache git alsa-lib-dev gcc musl-dev

WORKDIR /go/src/app

COPY go.mod .
# COPY go.sum .
COPY vendor .

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-s -w -extldflags "-static"' -trimpath -o ./bin/kollekt cmd/api/main.go


# Deploy Stage
FROM alpine:3.19.1

ENV PATH=/app/:$PATH

LABEL maintainer="Waldir Borba Junior <wborbajr@gmail.com>" \
  version="v0.1.o-2024" \
  description="KolleKt | waldirborbajr/kollekt:latest"

ENV LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8

RUN apk add --update --no-cache \
  tzdata \
  htop \
  apk-cron \
  && cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
  && echo "America/Sao_Paulo" > /etc/timezone

RUN adduser -S -D -H -h /app kollekt

USER kollekt

WORKDIR /app

COPY --from=builder /go/src/app/bin/kollekt kollekt

# ENV PKG_CONFIG_PATH=/usr/lib/pkgconfig:$PKG_CONFIG_PATH

CMD ["./kollekt"]

EXPOSE 4000
