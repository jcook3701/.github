# Default Community Health Files

[![License](https://img.shields.io/github/license/jcook3701/.github)](LICENSE.md)

This repository contains the [default community files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file) for [Jared W. Cook's](https://github.com/jcook3701) projects on GitHub.

These files are used by all public repositories if there are no own versions of these health files configured.

Changes to these community health files are maintained in this repository and apply to public repositories that do not provide their own versions.

1. **[Code of Conduct](CODE_OF_CONDUCT.md)** Defines community standards, fostering a welcoming, inclusive, and harassment-free environment for contributors.
2. **[Code owners](CODEOWNERS)** Specifies individuals or teams responsible for specific code, automating review requests and streamlining approvals.
3. **[Security](SECURITY.md)** Outlines the procedures for reporting vulnerabilities and the project’s security policy.
4. **[Funding](FUNDING.yml)** Configures custom funding links (e.g., GitHub Sponsors, Patreon) to support project maintenance.

## Automation

Run the same containerized validation used by GitHub Actions:

```console
make verify
```

The verification container runs without network access and mounts the repository read-only. Dependabot checks weekly for updates to GitHub Actions and the pinned verification images.

Dependabot configuration is repository-specific. Other repositories under `jcook3701` must keep their own `.github/dependabot.yml` files for the package ecosystems they use.

## License

Copyright (c) 2025-2026, Jared W. Cook

This project is licensed under the **AGPL-3.0-or-later License**.
See the [LICENSE](https://github.com/jcook3701/.github/blob/main/LICENSE.md) file for the full license text.

SPDX-License-Identifier: AGPL-3.0-or-later
