FROM messense/rust-musl-cross:x86_64-musl AS builder
WORKDIR language-learner/language_learner_api
COPY . .
RUN cargo build --release --target x86_64-unknown-linux-musl

FROM scratch
COPY --from=builder language-learner/language_learner_api/target/x86_64-unknown-linux-musl/release/language_learner_api language-learner/language_learner_api
ENTRYPOINT ["language-learner/language_learner_api"]
EXPOSE 3000