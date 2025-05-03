#FROM messense/rust-musl-cross:x86_64-musl AS builder
#WORKDIR /api
#COPY ./api .
#RUN cargo build --release --target x86_64-unknown-linux-musl



#FROM scratch
#COPY --from=builder /api/target/x86_64-unknown-linux-musl/release/api /api
#ENTRYPOINT ["/api"]
#EXPOSE 3000

###


#FROM messense/rust-musl-cross:armv7-musleabihf AS builder
#WORKDIR /api
#COPY ./api .
#RUN cargo build --release --target armv7-unknown-linux-musleabihf

#FROM scratch
#COPY --from=builder /api/target/armv7-unknown-linux-musleabihf/release/api /api
#ENTRYPOINT ["/api"]
#EXPOSE 3000

####


#FROM scratch
#COPY ./api/target/armv7-unknown-linux-musleabihf/release/api /api
#COPY ./out/api /api
#ENTRYPOINT ["/api"]
#EXPOSE 3000


# Builder stage
FROM rust:1.86 AS builder

# Install cross
RUN cargo install cross

# Set working directory
WORKDIR /app

COPY ./api /app

# Run the build
RUN apt update && apt install -y docker.io
RUN cross build --release --target armv7-unknown-linux-musleabihf

# Final image
FROM scratch
COPY --from=builder /app/target/armv7-unknown-linux-musleabihf/release/api /api
ENTRYPOINT ["/api"]
EXPOSE 3000
