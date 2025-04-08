# H5N1 Washington focused build for HA segment

## Build Overview
- **Build Name**: H5N1 Washington focused build for HA segment
- **Pathogen/Strain**: Influenza A H5N1
- **Scope**: HA segment, Washington focused
- **Purpose**: This repository contains the Nextstrain build for Washington State genomic surveillance of H5N1 HA segment.
- **Nextstrain Build Location**: https://nextstrain.org/groups/wadoh/flu/avian/washington/h5n1/4y/ha

## Table of Contents
- [Getting Started](#getting-started)
  - [Data Sources & Inputs](#data-sources--inputs)
  - [Setup & Dependencies](#setup--dependencies)
    - [Installation](#installation)
    - [Clone the repository](#clone-the-repository)
- [Run the Build with Test Data](#run-the-build-with-test-data)
- [Repository File Structure Overview](#repository-file-structure-overview)
- [Expected Outputs and Interpretation](#expected-outputs-and-interpretation)
- [Scientific Decisions](#scientific-decisions)
- [Adapting for Another State](#adapting-for-another-state)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Getting Started
This build was put together due to the need for a state focused H5N1 surveillance tool that was not previously available for Washington. The starting point for this build was the [Nextstrain H5N1 build](https://github.com/nextstrain/avian-flu) and Washington-specific subsampling and data sourcing were implemented.
Some high-level build features and capabilities are:
- Washington focused tiered subsampling strategy
- Furin Cleavage Site Identification

### Data Sources & Inputs
This build relies on publicly available data sourced from GISAID and GenBank. These data have been cleaned and stored on AWS.

- **Sequence Data**: GISAID, GenBank (for select sequences)
- **Metadata**: Sample collection metadata from GISAID and GenBank
- **Expected Inputs**:
    - `new_data/raw_sequences_ha.fasta` (containing viral genome sequences)
    - `new_data/metadata.xlsx` (with relevant sample information)

### Setup & Dependencies
#### Installation
Ensure that you have [Nextstrain](https://docs.nextstrain.org/en/latest/install.html) installed.

To check that Nextstrain is installed:
```
nextstrain check-setup
```
If Nextstrain is not installed, follow [Nextstrian installation guidelines](https://docs.nextstrain.org/en/latest/install.html)

#### Clone the repository:

```
git clone https://github.com/NW-PaGe/avian-flu.git
cd avian-flu
```

## Run the Build with Test Data
To test the pipeline with the provided example data located in `test_data/`, you will need to copy over the contents of this folder, including the `metadata/` and `fasta/` subfolders, into the `new_data/` folder.  The Snakefile will pull ingest the contents of the `new_data/` folder into the build.  

Make sure you are located in the build folder `avian-flu/` before running the build command:

```
nextstrain build .
```

When you run the build using `nextstrain build .` Nextstrain uses Snakemake as the workflow manager to automate genomic analyses. The Snakefile in a Nextstrain build defines how raw input data (sequences and metadata) are processed step-by-step in an automated way. Nextstrain builds are powered by Augur (for phylogenetics) and Auspice (for visualization) and Snakemake is used to automate the execution of these steps using Augur and Auspice based on file dependencies.

## Repository File Structure Overview
The file structure of the repository is as follows with `*`" folders denoting folders that are the build's expected outputs.

```
.
├── README.md
├── Snakefile
├── auspice*
├── clade-labeling
├── config
├── new_data
├── test_data
├── results*
└── scripts
```

- `Snakefile`: This file specifies the entire avian-flu pipeline that will be run, with specific parameters for subsampling, tree building and visualization.
- `config/`: Contains configuration files that specify default parameters such as which sequences to include and exclude in the build, the reference sequence, and which colors to visualize elements in the tree
- `new_data/`: This folder is empty in the repo, but when running the build should contain a fasta and xlsx file that will be ingested and run through the build.
- `test_data/`: Contains a fasta and metadata file from NCBI that can be ingested and run through this build when copied into `new_data/`.  It includes subfolders `metadata/` and `fasta /`.
- `scripts/`: Contains pythons scripts that are called from the Snakefile during the build.
- `clade-labeling`: Contains a tsv of the annotated clade for each H5N1 sequence that has been assigned using using a tool developed by using the [LABEL tool](https://wonder.cdc.gov/amd/flu/label/) **How will this be routinely updated?

## Expected Outputs and Interpretation
Running the build with the provided fasta and metadata file in `test_data`, the runtime using a 32.0 GB computer with 4 cores should take approximately 10 minutes. After successfully running the build with test data, there will be two output folders containing the build results.

- `auspice/` folder contains the JSON file to be visualized on [auspice.us](https://auspice.us/)
- `results/` folder contains multiple intermediate files which include aligned sequences, subsampled sequences and phylogenetic trees in .nwk format

## Scientific Decisions
- **Tiered subsampling**: The subsampling scheme prioritizes Washington and regional (Oregon, Idaho, British Columbia and Alaska) sequences while maintaining national and global context. The contextual global subsampling includes a emphasis on North America to include national context as well as emphasis Asia because the currently circulating D.1.1. clade most closely resembles an introduction from Asia.
- **Root selection**: A/Goose/Guangdong/1/96(H5N1) ; this root sequence is the same sequences as the reference sequences for this build. This virus is the precursor of currently circulating H5N1 viruses and was isolated from a farmed goose in 1996.
- **Furin cleavage site**:`scripts/annotate-ha-cleavage-site.py` is used by the rule cleavage_site to determine the sequence of amino acids at the HA cleavage site and annotate those sequences for whether they contain a furin cleavage site. This will show up on the Color By drop down as "furin cleavage motif" and be colored as present, absent, or missing data. By understanding the furin cleavage motif, we are able to understand virulence.  Some viruses have additional basic residues preceding the HA cleavage site.  The addition of a furin cleavge motif may allow the HA to be cleaved by furin and in turn allow for viral replication across a range of tissue.  Sequences with this furin cleavage motif are indicated with `R-X-K/R-R` in the "furin cleavage motif" drop down representing the 4 bases preceding HA2 and `X` being any amino acid.
- **Molecular clock IQD range**: IQD range was increased from 4 - based on the [Nextrain global H5N1 build](https://nextstrain.org/avian-flu/h5n1/ha/2y) - to 10 to accommodate the D.1.1. sequences in Washington that were under diverged.  In `augur refine`, the command `--clock-filter-iqd` removes tips that deviate more than *n* quartiles ranges from the root-to-tip vs time regression. By increasing the IQD from 4 to 10, less tips are filtered out and in turn the D.1.1 sequences will not be pruned from the tree.
- **Other adjustments**:
  - `config/includes.txt`: These sequences are always included into our sampling strategy as they are relevant to our epidemiological investigations.
  - `config/excludes.txt`: These sequences are always excluded from our subsampling and filtering due to duplication and based on epidemiological linkage knowledge.


## Adapting for Another State
 If wanting to adapt this build to your state, the following files will need to be modified to fit your needs:[Instructions on how to adapt this build for another state. What files need to be modified and in what ways. The sections should be outlined in a clear way]
 - **Input files**:
 - **Tiered subsampling**:
 - **Root selection**: The root of the tree determined the order of branching of a tree.  The root can be a reference sequence that represents the earliest known genome of a pathogen or be a fairly distant but related virus.
 - **Molecular clock IQD range**: This range can be specified in the command `--clock-filter-iqd` within `augur refine`. Not including this command results in no sequences being pruned form the tree, and will include all outliers.  If wanting to prune outliers, the IQD value should prune the tree in a way that includes the sequences of interest but gets rid out unwanted outliers.


## Contributing
For any questions please submit them to our [Discussions](https://github.com/NW-PaGe/avian-flu/discussions) page otherwise software issues and requests can be logged as a Git [Issue](https://github.com/NW-PaGe/avian-flu/issues).

## License
This project is licensed under a modified GPL-3.0 License.
You may use, modify, and distribute this work, but commercial use is strictly prohibited without prior written permission.

## Acknowledgements

[add acknowledgements to AMD teams, WADDL, etc... for contributing to this work]
