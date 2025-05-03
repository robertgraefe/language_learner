FROM scratch
COPY ./api/target/x86_64-unknown-linux-musl/release/api /api
ENTRYPOINT ["/api"]
EXPOSE 3000
