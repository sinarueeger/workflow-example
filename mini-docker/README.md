
# Rocker (R + Docker)

This folder contains 

- Docker container
- the R script for associations between a (tiny) subset of genetic markers and height.

## Docker

Inspiration through [blogpost by Colin Fay](https://colinfay.me/docker-r-reproducibility/)

How to run the docker file
1. Install Docker
2. Create or modify `Dockerfile`
3. Create a folder `mkdir results`
4. `docker build --build-arg WHEN=2019-01-06 -t analysis .`
5. `docker run -v ~/mini-docker/results:/home/analysis/results analysis`

This means that within docker, the results are stored in `/home/analysis/results` and on my computer under `~/mini-docker/results`

## Files

- `Dockerfile`
- `functions.R`: contains functions for data prep.
- `A_dataprep.R`: should be ran first, prepares the data for `B_fit.R`, `.RData` as output.
- `B_fit.R`: fits a simple and a multiple linear regression, `.RData` as output.
- `data/`: https://github.com/sinarueeger/create-data-workflow-example

No `rmarkdown` here, since the docker has no pandoc. 

## Output

- `results`

