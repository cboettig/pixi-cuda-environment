FROM ghcr.io/prefix-dev/pixi:latest
WORKDIR /repo

RUN useradd -m -s /bin/bash jovyan && chown -R jovyan:users /repo

COPY pixi.lock /repo/pixi.lock
COPY pyproject.toml /repo/pyproject.toml

RUN /usr/local/bin/pixi install --manifest-path pyproject.toml --environment cuda

USER jovyan
# Entrypoint shell script ensures that any commands we run start with `pixi shell`,
# which in turn ensures that we have the environment activated
# when running any commands.
COPY entrypoint.sh /repo/entrypoint.sh
RUN chmod 700 /repo/entrypoint.sh
ENTRYPOINT [ "/repo/entrypoint.sh" ]


CMD ["jupyter", "lab", "--ip", "0.0.0.0"]
