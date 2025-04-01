# PyPI Package Migration Script

## Overview
This script automates the process of retrieving all packages from a source GitLab PyPI package registry and uploading them to a target PyPI registry. It ensures that all unique package versions are transferred efficiently.

## Features
- Fetches a list of unique packages from the source PyPI repository.
- Extracts all available versions (`.tar.gz` and `.whl` files) of each package.
- Downloads the package files.
- Uploads the packages to the target PyPI registry using `twine`.
- Cleans up temporary files after the upload process.

## Prerequisites
Before running the script, ensure you have:

- **GitLab API Token** with `read_api` permissions.
- **Python and Twine** installed:
  ```sh
  pip install twine
  ```
- **Curl** installed (typically pre-installed on Linux and macOS).

## Configuration
Modify the following environment variables in the script:

```sh
source_repo_url="https://<DOMAIN_YOUR_INSTANCE>/api/v4/groups/<GROUP_ID>/-/packages/pypi/simple"
# For projects, use: /api/v4/projects/<PROJECT_ID>/packages/pypi/simple

target_pypi_url="https://<PYPI_REGISTRY_LOGIN>:<PYPI_REGISTRY_TOKEN>@<DOMAIN_YOUR_INSTANCE>/api/v4/projects/<TARGET_PROJECT_ID>/packages/pypi"

private_token="<GITLAB_TOKEN>" # Token with read_api permissions
```

Replace `<DOMAIN_YOUR_INSTANCE>`, `<GROUP_ID>`, `<PROJECT_ID>`, `<TARGET_PROJECT_ID>`, and authentication credentials with your actual values.

## Usage
1. **Make the script executable:**
   ```sh
   chmod +x migrate_pypi.sh
   ```
2. **Run the script:**
   ```sh
   ./migrate_pypi.sh
   ```

## How It Works
1. Retrieves a list of available packages from the source repository.
2. Extracts unique package names.
3. Fetches all available versions of each package.
4. Downloads `.tar.gz` and `.whl` package files.
5. Uploads each package file to the target PyPI registry using `twine`.
6. Deletes the temporary files after the upload is complete.

## Example Output
```
We get a list of packages and versions
Processing the package: django-utils
Download the package with the version: django-utils-1.2.3.tar.gz
Sending the package to the target repository: django-utils-1.2.3.tar.gz
Done!
```

## Notes
- If the script fails due to authentication issues, verify your `private_token` and `target_pypi_url` credentials.
- Make sure your `twine` installation is correctly configured for authentication.

## License
This script is provided "as is" without warranty. Use it at your own risk.

