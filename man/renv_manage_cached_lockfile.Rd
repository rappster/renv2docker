% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/renv.R
\name{renv_manage_cached_lockfile}
\alias{renv_manage_cached_lockfile}
\title{Manage cached \code{{renv}} lockfile}
\usage{
renv_manage_cached_lockfile(
  key_primary = renv_digest_primary_lockfile(),
  key_cached = renv_digest_cached_lockfile(),
  force = FALSE
)
}
\arguments{
\item{key_primary}{[\link{character}] Hash key for primary \code{renv.lock}}

\item{key_cached}{[\link{character}] Hash key for cached \code{renv.lock}}

\item{force}{[\link{logical}]
\itemize{
\item \code{TRUE}: force an update of the cached \code{renv.lock}
\item \code{FALSE}: perform update only if hash keys differ
}}
}
\value{
[\link{character}] Path to cached \code{{renv}} lockfile
}
\description{
Manage cached \code{{renv}} lockfile
}
\examples{
renv_manage_cached_lockfile()
}
