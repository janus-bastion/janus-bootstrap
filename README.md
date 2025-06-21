<a id="readme-top"></a> 

<h1><center>Janus bootstrap</center></h1>

<div align="center">
  <a href="https://github.com/janus-bastion">
    <img src="https://github.com/janus-bastion/janus-frontend/blob/main/public/janus-logo.png" alt="Janus Bastion Logo" width="160" height="160" />
  </a>

  <p><em>Janus Bootstrap is a utility for quickly deploying and tearing down the Janus administrative bastion environment. It automates the setup and cleanup of the entire Janus infrastructure using Docker and Git, allowing administrators to start or stop work in seconds.
</em></p>

  <table align="center">
    <tr>
      <th>Author</th>
      <th>Author</th>
      <th>Author</th>
      <th>Author</th>
    </tr>
    <tr>
      <td align="center">
        <a href="https://github.com/nathanmartel21">
          <img src="https://github.com/nathanmartel21.png?size=115" width="115" alt="@nathanmartel21" /><br />
          <sub>@nathanmartel21</sub>
        </a>
        <br /><br />
        <a href="https://github.com/sponsors/nathanmartel21">
          <img src="https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=white" alt="Sponsor nathanmartel21" />
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/xeylou">
          <img src="https://github.com/xeylou.png?size=115" width="115" alt="@xeylou" /><br />
          <sub>@xeylou</sub>
        </a>
        <br /><br />
        <a href="https://github.com/sponsors/xeylou">
          <img src="https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=white" alt="Sponsor xeylou" />
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/Djegger">
          <img src="https://github.com/Djegger.png?size=115" width="115" alt="@Djegger" /><br />
          <sub>@Djegger</sub>
        </a>
        <br /><br />
        <a href="https://github.com/sponsors/Djegger">
          <img src="https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=white" alt="Sponsor Djegger" />
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/Warsgo">
          <img src="https://github.com/Warsgo.png?size=115" width="115" alt="@Warsgo" /><br />
          <sub>@Warsgo</sub>
        </a>
        <br /><br />
        <a href="https://github.com/sponsors/Warsgo">
          <img src="https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=white" alt="Sponsor Warsgo" />
        </a>
      </td>
    </tr>
  </table>
</div>

---

## Contents

- [`janus-init.sh`](./janus-init.sh): Script to initialize and launch the Janus environment.
- [`janus-deinit.sh`](./janus-deinit.sh): Script to stop and clean up the Janus environment.

## Features

- Clones all required Janus repositories.
- Deploys the infrastructure using Docker Compose.
- Automatically detects and opens the management interface in a browser.
- Provides a clean uninstall path, including Docker volume and repo cleanup.

## Requirements

- [![Git](https://img.shields.io/badge/GIT-E44C30?style=for-the-badge&logo=git&logoColor=white)](https://git-scm.com/)

- [![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

- [![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)

- [![Bash](https://img.shields.io/badge/GNU%20Bash-4EAA25?style=for-the-badge&logo=GNU%20Bash&logoColor=white)](https://www.gnu.org/software/bash/)

- `xdg-open` (for Linux GUI environments - *but not mandatory*)


## Quick Start

### Initialization

To deploy Janus:

```bash
bash janus-init.sh || ./janus-init.sh
```

This will:

  - Prepare a workspace in ~/janus-workspace/.

  - Clone the necessary Janus repositories.

  - Remove any existing janus-infra_mysql_data Docker volume.

  - Launch the infrastructure with Docker Compose.

  - Output the access URL and attempt to open it in your browser.

Example output:

```bash
[INFO] : Preparing workspace...
[INFO] : Cloning janus-core...
...
[SUCCESS] : Janus is accessible at: https://<haproxy-ip>:8445
```

### Deinitialization

To stop and remove everything related to Janus:

```bash
bash janus-deinit.sh || ./janus-deinit.sh
```

This will:

  - Shut down the Docker infrastructure.

  - Remove the janus-infra_mysql_data volume if it exists.

  - Delete all cloned repositories from the workspace.

  - Remove the workspace directory if empty.

## Repositories Managed

The following repositories will be cloned into ~/janus-workspace/:

  - janus-core

  - janus-frontend

  - janus-cli

  - janus-infra

  - janus-devops

  - janus-monitoring

  - janus-docs

  - janus-vault

## Notes

- If the infrastructure is already running, it will not be reinitialized.

- The scripts are idempotent and safe to rerun.

## License

This project is licensed under the GNU General Public License v3.0 [GPL-3.0](https://github.com/janus-bastion/.github/blob/main/LICENSE).  
See the `LICENSE` file for more details.
