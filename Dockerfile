FROM ghcr.io/cienciadedatosysalud/aspire:latest

USER root
RUN apt update && apt install -y --no-install-recommends \
  && apt install -y xdg-utils graphviz \
  && rm -rf /var/lib/apt/lists/*


# Set time Europe/Madrid

RUN micromamba -n aspire install tzdata -c conda-forge && micromamba clean --all --yes \
    && rm -rf /opt/conda/conda-meta
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN micromamba run -n aspire date

USER $MAMBA_USER


COPY --chown=$MAMBA_USER:$MAMBA_USER env_project.yaml /tmp/env_project.yaml

# Installing dependencies
RUN micromamba install -y -n aspire -f /tmp/env_project.yaml \
    && micromamba run -n aspire Rscript -e "remotes::install_github('gadenbuie/epoxy')" \ 
    && micromamba clean --all --yes \
    && rm -rf /opt/conda/conda-meta /tmp/env_project.yaml


# Installing R packages not found in conda-forge
#RUN /opt/conda/envs/aspire/bin/Rscript -e 'install.packages("epoxy",repos = "http://cran.us.r-project.org")'

COPY --chown=$MAMBA_USER:$MAMBA_USER atlas_antibioticos /home/$MAMBA_USER/projects/atlas_antibioticos
COPY --chown=$MAMBA_USER:$MAMBA_USER atlas_opioides /home/$MAMBA_USER/projects/atlas_opioides
COPY --chown=$MAMBA_USER:$MAMBA_USER main_logo.png /temp/main_logo.png

RUN cp /temp/main_logo.png $(find front -name main_logo**)

ENV APP_PORT=3000
ENV APP_HOST=0.0.0.0
EXPOSE 3000

WORKDIR /home/$MAMBA_USER

ENTRYPOINT ["micromamba","run","-n","aspire","/opt/entrypoint.sh"]
