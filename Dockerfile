FROM messense/rust-musl-cross:x86_64-musl AS builder
WORKDIR /api
COPY ./api .
RUN cargo build --release --target x86_64-unknown-linux-musl

FROM scratch
COPY --from=builder /api/target/x86_64-unknown-linux-musl/release/api /api
ENTRYPOINT ["/api"]
EXPOSE 3000