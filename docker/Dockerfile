# syntax=docker/dockerfile:1.7@sha256:a57df69d0ea827fb7266491f2813635de6f17269be881f696fbfdf2d83dda33e

FROM rhysd/actionlint:1.7.12@sha256:b1934ee5f1c509618f2508e6eb47ee0d3520686341fec936f3b79331f9315667 AS actionlint

FROM ruby:3.3.10-slim-bookworm@sha256:5e91410f3dd304de860361dbb7f1eb0347b9675dc4e21036c1d36a309da25b82 AS verifier

COPY --from=actionlint /usr/local/bin/actionlint /usr/local/bin/actionlint

WORKDIR /workspace

CMD ["bash", "/workspace/scripts/verify.sh"]
