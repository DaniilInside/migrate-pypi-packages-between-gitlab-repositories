#!/bin/bash

#-----------------------------------------------------CONFIGURATIONS------------------------------------------------------------------#                           
source_repo_url="https://<DOMAIN_YOUR_INSTANCE>/api/v4/groups/<GROUP_ID>/-/packages/pypi/simple" # for projects /api/v4/projects/<PROJECT_ID>/packages/pypi/simple
target_pypi_url="https://<PYPI_REGISTRY_LOGIN>:<PYPI_REGISTRY_TOKEN>@<DOMAIN_YOUR_INSTANCE>/api/v4/projects/<TARGET_PROJECT_ID>/packages/pypi"
private_token="<GITLAB_TOKEN>" # read_api permissions
#-------------------------------------------------------------------------------------------------------------------------------------#

#-----------------------------------------------------SCRIPTZONE----------------------------------------------------------------------#
temp_folder="./downloaded_packages"
mkdir -p $temp_folder

echo "We get a list of packages and versions"
packages_list=$(curl --header "PRIVATE-TOKEN: $private_token" -s "$source_repo_url")

if [[ -z "$packages_list" ]]; then
    echo "Error when receiving the package list!"
    exit 1
fi

echo "Parse packages and their versions"
package_urls=$(echo "$packages_list" | grep -oP 'href="\K[^"]*' | grep '/simple/'  | sort | uniq)

for package_url in $package_urls; do
    package_name=$(basename $package_url)
    echo "Processing the package: $package_name"

    versions_list=$(curl --header "PRIVATE-TOKEN: $private_token" -s "$source_repo_url/$package_name/")

    version_urls=$(echo "$versions_list" | grep -oP 'href="\K[^"]*(\.tar\.gz|\.whl)')

    for version_url in $version_urls; do
        full_url="$version_url"

        echo "Download the package with the version: $version_url"
        curl -L --header "PRIVATE-TOKEN: $private_token" -o "$temp_folder/$(basename $version_url)" "$full_url"

        echo "Sending the package to the target repository: $version_url"
        python -m twine upload --repository-url $target_pypi_url $temp_folder/$(basename $version_url)

        rm "$temp_folder/$(basename $version_url)"
    done
done

rmdir $temp_folder

echo "Done!"
#-------------------------------------------------------------------------------------------------------------------------------------#
