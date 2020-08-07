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

mkdir -p "$outdir"

# For test results
outputDir="${git_dir}/test_results"
mkdir -p "$outputDir"

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

conda activate pyfunceble-dev

# Make sure output dir is there
mkdir -p "${outputDir}"

#pip install --upgrade pip -q
#pip uninstall -yq pyfunceble-dev
#pip install --no-cache-dir --upgrade -q pyfunceble-dev


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

read -erp "Enter any custom test string: " -i "-dbr 30 -ex -m -p $(nproc --ignore=2) -h --http --idna --mining -a --plain --hierarchical -db --database-type mariadb --dns 192.168.1.105:53" -a pyfuncebleArgs

# Run PyFunceble
# Switched to use array to keep quotes for SC2086
pyfunceble --version

pyfunceble "${pyfuncebleArgs[@]}" -f "$snuff_source" && grep -vE '^(#|$)' "${outputDir}/output/domains/ACTIVE/list" \
  | tee > "$snuff_active" && grep -vE '^(#|$)' "${outputDir}/output/domains/INACTIVE/list" \
  | tee > "$snuff_dead" && delOutPutDir


pyfunceble "${pyfuncebleArgs[@]}" -f "$mobile_source" && grep -vE '^(#|$)' "${outputDir}/output/domains/ACTIVE/list" \
  | tee > "$mobile_active" && grep -vE '^(#|$)' "${outputDir}/output/domains/INACTIVE/list" \
  | tee > "$mobile_dead" && delOutPutDir

pyfunceble "${pyfuncebleArgs[@]}" -f "$strict_source" && grep -vE '^(#|$)' "${outputDir}/output/domains/ACTIVE/list" \
  | tee > "$strict_active" && grep -vE '^(#|$)' "${outputDir}/output/domains/INACTIVE/list" \
  | tee > "$strict_dead" && delOutPutDir


pyfunceble "${pyfuncebleArgs[@]}" -f  "$porn_source" && grep -vE '^(#|$)' "${outputDir}/output/domains/ACTIVE/list" \
  | tee > "$porn_active" && grep -vE '^(#|$)' "${outputDir}/output/domains/INACTIVE/list" \
  | tee > "$porn_dead" && delOutPutDir








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
