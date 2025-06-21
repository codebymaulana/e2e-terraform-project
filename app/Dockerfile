FROM golang:1.24.4-alpine AS build-stage

WORKDIR app

COPY main.go .

RUN go build main.go

FROM alpine

WORKDIR app

COPY --from=build-stage /go/app/main .

CMD ["./main"]