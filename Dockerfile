#FROM scratch
#COPY ./api/target/x86_64-unknown-linux-musl/release/api /api
#ENTRYPOINT ["/api"]
#EXPOSE 3000

# Stage 1: Build the Rust binary with MUSL
FROM clux/muslrust:stable as builder

WORKDIR /app
COPY . .

RUN cargo build --release --target x86_64-unknown-linux-musl

# Stage 2: Copy into scratch for minimal image
FROM scratch

COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/api /api

ENTRYPOINT ["/api"]
EXPOSE 3000
