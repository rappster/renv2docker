#' Ensure directory: renv/local
#'
#' Ensure directory exists and is empty
#'
#' @return
#' @export
#'
#' @examples
#' renv_ensure_local_dir()
renv_ensure_local_dir <- function() {
    dir <- .env_dir_renv_local()

    dir %>%
        fs::dir_create() %>%
        # Ensure clean dir to start with
        fs::dir_ls(all = TRUE) %>%
        purrr::walk(~.x %>% fs::file_delete())

    dir
}

#' Ensure directory: renv/cache
#'
#' Ensure directory exists.
#'
#' @return
#' @export
#'
#' @examples
#' renv_ensure_cache_docker_dir()
renv_ensure_cache_dir <- function() {
    .env_dir_renv_cache() %>%
        fs::dir_create()
}

#' Ensure directory: renv/cache_docker
#'
#' Ensure directory exists.
#'
#' @return
#' @export
#'
#' @examples
#' renv_ensure_cache_docker_dir()
renv_ensure_cache_docker_dir <- function() {
    .env_dir_renv_cache_docker() %>%
        fs::dir_create()
}

#' Create snapshot
#'
#' @return
#' @export
#'
#' @examples
#' renv_snapshot()
renv_snapshot <- function() {
    # Important for making execution via bash shell possible!
    # Script renv/activate.R needs to be executed again in order to make snapshoting
    # work
    path <- .env_renv_activate()

    if (fs::file_exists(path)) {
        source(path)
    }

    renv::snapshot(confirm = FALSE)
}

#' Get hash of `{renv}` lockfile
#'
#' @param path [[character]] Path to `renv.lock`
#'
#' @return
#' @export
#'
#' @examples
#' renv_digest_primary_lockfile()
renv_digest_primary_lockfile <- function(
    path = .env_renv_lockfile()
) {
    digest::digest(
        readLines(
            path %>%
                here::here()
            # NOTE: the 'here::here()' is important for correct path resolution when
            # testing
            # TODO: Check out options to remove dependency on {here}
        )
    )
}

#' Digest cached `{renv}` lockfile
#'
#' @param path [[character]] Path to **cached** `renv.lock` that is used by the
#'   depencency cached manager (DCM)
#'
#' @return
#' @export
#'
#' @examples
#' renv_digest_cached_lockfile()
renv_digest_cached_lockfile <- function(
    path = .env_renv_lockfile_cached()
) {
    path <- path %>% here::here()
    # NOTE: the 'here::here()' is important for correct path resolution when
    # testing
    # TODO: Check out options to remove dependency on {here}

    if (file.exists(path)) {
        digest::digest(readLines(path))
    } else {
        ""
    }
}

#' Manage cached `{renv}` lockfile
#'
#' @param key_primary [[character]] Hash key for primary `renv.lock`
#' @param key_cached [[character]] Hash key for cached `renv.lock`
#' @param force [[logical]]
#'   - `TRUE`: force an update of the cached `renv.lock`
#'   - `FALSE`: perform update only if hash keys differ
#'
#' @return [[character]] Path to cached `{renv}` lockfile
#' @export
#'
#' @examples
#' renv_manage_cached_lockfile()
renv_manage_cached_lockfile <- function(
    key_primary = renv_digest_primary_lockfile(),
    key_cached = renv_digest_cached_lockfile(),
    force = FALSE
) {
    if (key_primary != key_cached ||
            force
    ) {
        usethis::ui_info("Updating cached lockfile ({.env_renv_lockfile_cached()})")
        fs::file_copy(
            .env_renv_lockfile() %>%
                here::here(),
            .env_renv_lockfile_cached() %>%
                here::here(),
            overwrite = TRUE
        )
        usethis::ui_done("Cached lockfile updated ({.env_renv_lockfile_cached()})")
    } else {
        usethis::ui_done("Cached lockfile up to date ({.env_renv_lockfile_cached()})")
    }

    .env_renv_lockfile_cached()
}

#' Add `{renv}` lockfile record for current package
#'
#' @return
#' @export
#'
#' @examples
#' renv_add_lockfile_record()
renv_add_lockfile_record <- function() {
    package_name <- env_package_name()
    record <- list(list(
        Package = package_name,
        Version = env_package_version(),
        Source = "Local"
    ))
    names(record) <- package_name
    renv::record(record)

    record
}

#' Remove dev package from `{renv}` library
#'
#' @return
#' @export
#'
#' @examples
#' renv_remove_dev_package()
renv_remove_dev_package <- function() {
    renv::remove(env_package_name())
}

#' Set environment variable for `{renv}` cache
#'
#' @return
#' @export
#'
#' @examples
#' renv_set_env_var_cache()
renv_set_env_var_cache <- function() {
    Sys.setenv(RENV_PATHS_CACHE = .env_dir_renv_cache() %>% here::here())
}

#' Ensure directory exists and is empty
#'
#' @return
#' @export
#'
#' @examples
#' renv_ensure_local_dir()
renv_copy_description <- function() {
    fs::file_copy(
        "DESCRIPTION",
        "DESCRIPTION_OUTER",
        overwrite = TRUE
    )
}
