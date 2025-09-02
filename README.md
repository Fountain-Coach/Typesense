
# Typesense CI: Precompiled ZIP Publisher

This repo contains a GitHub Actions workflow that:
1. Clones **upstream** `typesense/typesense` at a ref you specify,
2. Builds `typesense-server`,
3. Repackages the official tarball into a **ZIP**,
4. Publishes it as:
   - a build artifact, and
   - a GitHub Release asset (for tag pushes or when opted in via workflow dispatch).

## Usage

- **Manual run**: Go to *Actions → build-and-release-typesense* → *Run workflow*,
  choose a `ref` (e.g. `v0.25.1`, `main`), and keep "Create Release" = true if you want a release.
- **Tag-driven release**: Push a tag in this repo like `typesense-v0.25.1`.
  The workflow will build the **same** upstream tag and publish a release here.

Artifacts are named like: `typesense-server-<ref>-linux-amd64.zip` with a matching `SHA256SUMS.txt`.

> Note: We clone upstream (`typesense/typesense`) to build from the official source,
> keeping this repo focused on packaging & distribution for our Codex runs.
