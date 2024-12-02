#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path .

if [[ ${build_platform} == ${target_platform} ]]; then
    mkdir -p ${PREFIX}/etc/bash_completion.d
    mkdir -p ${PREFIX}/share/fish/vendor_completions.d
    mkdir -p ${PREFIX}/share/zsh/site-functions
    mkdir -p ${PREFIX}/share/man/man1
    install -m 644 Documentation/git-absorb.1 ${PREFIX}/share/man/man1/git-absorb.1
    git-absorb --gen-completions bash > ${PREFIX}/etc/bash_completion.d/git-absorb
    git-absorb --gen-completions fish > ${PREFIX}/share/fish/vendor_completions.d/git-absorb.fish
    git-absorb --gen-completions zsh > ${PREFIX}/share/zsh/site-functions/_git-absorb
fi
