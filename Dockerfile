FROM ghcr.io/cienciadedatosysalud/aspirev2-testing:latest
ARG pipeline_version="Non-versioned"
ENV PIPELINE_VERSION=$pipeline_version

ARG github_repo="Non-versioned"
ENV GITHUB_REPO=$github_repo

USER root
RUN apt update && apt install -y --no-install-recommends \
  && apt install -y xdg-utils graphviz \
  && rm -rf /var/lib/apt/lists/*


# Set time Europe/Madrid

# Creamos el entrypoint en una ruta segura y ejecutable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh


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
    && micromamba run -n aspire Rscript -e "remotes::install_github('duckdb/duckdb-r')" \ 
    && micromamba clean --all --yes \
    && rm -rf /opt/conda/conda-meta /tmp/env_project.yaml



# Installing R packages not found in conda-forge
#RUN /opt/conda/envs/aspire/bin/Rscript -e 'install.packages("epoxy",repos = "http://cran.us.r-project.org")'

COPY --chown=$MAMBA_USER:$MAMBA_USER atlas_antibioticos /home/$MAMBA_USER/projects/atlas_antibioticos
COPY --chown=$MAMBA_USER:$MAMBA_USER atlas_opioides /home/$MAMBA_USER/projects/atlas_opioides
COPY --chown=$MAMBA_USER:$MAMBA_USER atlas_antipsicoticos /home/$MAMBA_USER/projects/atlas_antipsicoticos
COPY --chown=$MAMBA_USER:$MAMBA_USER atlas_antidepresivos /home/$MAMBA_USER/projects/atlas_antidepresivos
#COPY --chown=$MAMBA_USER:$MAMBA_USER main_logo.png /temp/main_logo.png
COPY --chown=$MAMBA_USER:$MAMBA_USER main_logo.png /tmp/main_logo.png
#RUN cp /temp/main_logo.png $(find front -name main_logo**)
RUN cp -f /tmp/main_logo.png $(find /var/www/html/ -type f -name "main_logo*" | head -n 1)  


#ENV APP_PORT=3000
#ENV APP_HOST=0.0.0.0
#EXPOSE 3000

WORKDIR /home/$MAMBA_USER

# ENTRYPOINT fijo para RHEL / SELinux
ENTRYPOINT ["micromamba","run","-n","aspire","entrypoint.sh"]
