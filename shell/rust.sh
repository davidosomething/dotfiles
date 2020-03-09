# shell/rust.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/rust.sh {"

export CARGO_HOME="${HOME}/.local/cargo"

PATH="${CARGO_HOME}/bin:${PATH}"

DKO_SOURCE="${DKO_SOURCE} }"
