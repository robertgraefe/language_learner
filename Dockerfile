FROM scratch
COPY ./api/target/armv7-unknown-linux-musleabihf/release/api /api
ENTRYPOINT ["/api"]
EXPOSE 3000
