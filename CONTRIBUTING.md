# Contributing Guide

Thank you for considering contributing to the yt-search-api project! Here are some guidelines to help you get involved in the project.

## Contribution Process

1. Fork this repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Make code changes
4. Ensure all tests pass: `npm test`
5. Commit your changes: `git commit -m 'Added some feature'`
6. Push to the branch: `git push origin feature/your-feature-name`
7. Submit a Pull Request

## Code Style

- Write all code in TypeScript
- Follow the ESLint and Prettier rules in the project
- Write tests for all new features
- Keep code comments clear and concise

## Pull Request Guidelines

- Each PR should focus on one feature or fix
- Include a clear description explaining what problem this PR solves
- If the change is related to an existing issue, reference the issue number in the PR description
- All PRs must pass CI tests before they can be merged

## Adding Support for New Platforms

If you want to add support for a new video platform, follow these steps:

1. Create a new file in the `/src/api` directory, for example `newplatform.ts`
2. Implement search functionality that conforms to the unified interface
3. Add platform-specific type definitions
4. Register the new platform in `/services/searchService.ts`
5. Add appropriate tests
6. Update documentation

## Issue Reporting

If you find an issue or have a suggestion for improvement, please create a new issue and provide as much of the following as possible:

- A clear and concise description of the issue
- Steps to reproduce
- Expected vs actual results
- System environment information (Node.js version, etc.)

## License

By contributing code, you agree that your contributions will be provided under the MIT license.

## Release preparation

`package.json` is the version source. Release tags use `vX.Y.Z` or `vX.Y.Z-alpha.N`, `vX.Y.Z-beta.N`, and `vX.Y.Z-rc.N`.
The release gate rejects leading zeroes, other suffixes, and tags that disagree with `package.json`.
Published tags stay unchanged. The version in `package.json` at the historical `v0.1.3` tag is `0.1.0`.
The current manifest uses `0.1.3` to match the latest published release.

Use Yarn 1.22.22 and git-cliff 2.14.1 from the repository root:

1. Set the next version in `package.json`.
2. Run `corepack yarn install --frozen-lockfile`.
3. Run `corepack yarn test --runInBand`.
4. Run `corepack yarn build`.
5. Generate the release entry from the previous stable release:

   ```bash
   version="v$(node -p 'require("./package.json").version')"
   previous="$(git describe --tags --abbrev=0 --match 'v[0-9]*' --exclude '*-*' --exclude "$version")"
   git-cliff --ignore-tags '.*' --tag "$version" "$previous..HEAD" --prepend CHANGELOG.md
   ```

6. Review `package.json` and `CHANGELOG.md`, then commit them with `chore(release): prepare v<version>` and sign-off.
7. After release publication is approved, create and push the matching tag.

The tag workflows validate the version before a build or publication.
The Release workflow compares generated notes with the committed changelog entry and rejects empty notes.
Every stage includes changes since the previous stable release. A candidate can advance to the next stage or stable with only version metadata changes.
GitHub prereleases use `--prerelease --latest=false`. Stable releases use `--latest`.
Prerelease images do not update the `latest`, major, or minor image tags.
The workflows do not publish an npm package.

For a local tagged commit, set `RELEASE_TAG` and a temporary `GITHUB_OUTPUT` file, then run `bash scripts/check-release-tag.sh`.
Use the generation commands in step 5 with `--strip all --output release-notes.md` instead of `--prepend CHANGELOG.md`, then run `node scripts/check-release-notes.cjs` with the same `RELEASE_TAG`.
A failed command blocks publication. Remove the temporary output and notes files after the local run.
The local fixture runs on November 25, 2026 covered stable, alpha, beta, and rc tags without publication.
Live GitHub Release and registry publication remain unverified until an approved release.
