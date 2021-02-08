#!/usr/bin/env bash

# Fail if exit != 0
set -e

# Run script in verbose
#set -x

# *********************************************************************
# Define root dir for git, for working with relative dir to this repo #
# *********************************************************************

git_dir="$(git rev-parse --show-toplevel)"

# **********************************************************************
# Set some dirs
# **********************************************************************

sourcedir="${git_dir}/submit_here"
outdir="${git_dir}/download_here" # no trailing / as it would make a double //

mkdir -p "${outdir}"

# For test results
outputDir="${git_dir}/test_results"
mkdir -p "${outputDir}"

# *******************************************
# Set the sources (file names in submit_here)
# *******************************************

porn_source="${sourcedir}/hosts.txt"
mobile_source="${sourcedir}/mobile.txt"
snuff_source="${sourcedir}/snuff.txt"
strict_source="${sourcedir}/strict_adult.txt"

# *******************************************
# Set the active (file names in submit_here)
# *******************************************

porn_active="${outputDir}/hosts.active.txt"
mobile_active="${outputDir}/mobile.active.txt"
snuff_active="${outputDir}/snuff.active.txt"
strict_active="${outputDir}/strict_adult.active.txt"

# *******************************************
# Set the INactive (file names in submit_here)
# *******************************************

porn_dead="${outputDir}/dead.hosts.txt"
mobile_dead="${outputDir}/dead.mobile.txt"
snuff_dead="${outputDir}/dead.snuff.txt"
strict_dead="${outputDir}/dead.strict_adult.txt"


delOutPutDir () {
	find "${outputDir}/output" -type f -delete
	#find "${outputDir}/output" -type d -delete
}


# Your next step is to ensure you have miniconda and PyFunceble installed
# This script is based on the PyFunceble + miniconda script template from
# https://github.com/PyFunceble-Templates/pyfunceble-miniconda
# This script also requires you to have access to an MariaDB server

# Set conda install dir
condaInstallDir="${HOME}/miniconda"

# Get the conda CLI.
source "${condaInstallDir}/etc/profile.d/conda.sh"

hash conda

# First Update Conda
conda update -q conda

# conda activate pyfunceble4
# conda install python=3.9.1

# Make sure output dir is there
mkdir -p "${outputDir}"

# pip install --upgrade pip -q
# pip uninstall -yq pyfunceble-dev
# pip install --no-cache-dir --upgrade -q --pre pyfunceble-dev

conda env update -f "${git_dir}/toolbox/.environment.yaml" --prune
conda activate pyfunceble4

# Tell the script to install/update the configuration file automatically.
export PYFUNCEBLE_AUTO_CONFIGURATION=yes

# Currently only availeble in the @dev edition see
# GH:funilrys/PyFunceble#94
export PYFUNCEBLE_OUTPUT_LOCATION="${outputDir}/"

# Export ENV variables from $HOME/.config/.pyfunceble-env
# Note: Using cat here is in violation with SC2002, but the only way I have
# been able to obtain the data from default .ENV file, with-out risking
# to reveals any sensitive data. Better suggestions are very welcome

export PYFUNCEBLE_CONFIG_DIR="${HOME}/.config/PyFunceble/"

read -erp "Enter any custom test string: " -i "-ex -h -a --hierarchical --database-type mariadb --dns 185.109.89.254 130.225.244.166 130.226.161.34 185.38.24.52 198.180.150.12 --complements" -a pyfuncebleArgs


# Run PyFunceble
# Switched to use array to keep quotes for SC2086
pyfunceble --version

printf "\nTesting: All files\n"

pyfunceble "${pyfuncebleArgs[@]}" -f "$snuff_source" "$mobile_source" \
  "$strict_source" "$porn_source"


grep -vE '^(#|$)' "${outputDir}/output/snuff.txt/domains/ACTIVE/list" > "$snuff_active" \
  && grep -vE '^(#|$)' "${outputDir}/output/snuff.txt/domains/INACTIVE/list" > "$snuff_dead" \
  && grep -vE '^(#|$)' "${outputDir}/output/mobile.txt/domains/ACTIVE/list" > "$mobile_active" \
  && grep -vE '^(#|$)' "${outputDir}/output/mobile.txt/domains/INACTIVE/list" > "$mobile_dead" \
  && grep -vE '^(#|$)' "${outputDir}/output/strict_adult.txt/domains/ACTIVE/list" > "$strict_active" \
  && grep -vE '^(#|$)' "${outputDir}/output/strict_adult.txt/domains/INACTIVE/list" > "$strict_dead" \
  && grep -vE '^(#|$)' "${outputDir}/output/hosts.txt/domains/ACTIVE/list" > "$porn_active" \
  && grep -vE '^(#|$)' "${outputDir}/output/hosts.txt/domains/INACTIVE/list" > "$porn_dead" \

  && delOutPutDir

conda deactivate

exit ${?}

# Copyright: https://www.mypdns.org/
# Content: https://www.mypdns.org/p/Spirillen/
# Source: https://github.com/Import-External-Sources/pornhosts
# License: https://www.mypdns.org/w/License
# License Comment: GNU AGPLv3, MODIFIED FOR NON COMMERCIAL USE
#
# License in short:
# You are free to copy and distribute this file for non-commercial uses,
# as long the original URL and attribution is included.
#
# Please forward any additions, corrections or comments by logging an
# issue at https://www.mypdns.org/maniphest/
