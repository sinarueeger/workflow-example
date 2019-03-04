FROM rocker/r-ver:3.5.1

RUN mkdir /home/analysis
RUN mkdir /home/analysis/results

ARG WHEN

RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('readr')"

RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('dplyr')"

RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('glue')"

RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('broom')"

RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('here')"


COPY mini-docker.Rproj /home/analysis/mini-docker.Rproj
COPY code/functions.R /home/analysis/code/functions.R
COPY code/A_dataprep.R /home/analysis/code/A_dataprep.R
COPY code/B_fit.R /home/analysis/code/B_fit.R
COPY data/genotyping_data_subset_train.bim /home/analysis/data/genotyping_data_subset_train.bim
COPY data/training_set_details.txt /home/analysis/data/training_set_details.txt
COPY data/genotyping_data_subset_train.raw /home/analysis/data/genotyping_data_subset_train.raw

CMD cd /home/analysis \
  && R -e "source('code/A_dataprep.R')" \
  && R -e "source('code/B_fit.R')"