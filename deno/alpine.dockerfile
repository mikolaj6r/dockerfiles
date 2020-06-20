FROM frolvlad/alpine-glibc:alpine-3.11_glibc-2.31

ARG DENO_VERSION

RUN apk add --virtual .download --no-cache curl

RUN if [[ -n "$DENO_VERSION" ]] ; then curl -fsSL https://deno.land/x/install/install.sh | sh -s v${DENO_VERSION} ; else curl -fsSL https://deno.land/x/install/install.sh | sh ; fi
RUN apk del .download

# Setup environment
ENV DENO_DIR /deno_dir
ENV DENO_INSTALL "/root/.deno"
ENV PATH "$DENO_INSTALL/bin:$PATH"

RUN addgroup -g 1993 -S deno \
 && adduser -u 1993 -S deno -G deno \
 && mkdir /deno-dir \
 && chown deno:deno /deno-dir

ENTRYPOINT ["deno"]
CMD ["-h"]