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
(Describe any context that new users should know before using this project.)
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

#### Clone the repository:

```
git clone https://github.com/NW-PaGe/avian-flu.git
cd avian-flu
```

## Run the Build with Test Data
To test the pipeline with the provided example data make sure you are in the build folder `avian-flu/`:

```
nextstrain build .
```

When you run the build using `nextstrain build .`, Nextstrain uses Snakemake as the workflow manager to automate genomic analyses. The Snakefile in a Nextstrain build defines how raw input data (sequences and metadata) are processed step-by-step in an automated way. Nextstrain builds are powered by Augur (for phylogenetics) and Auspice (for visualization) and Snakemake is used to automate the execution of these steps based on file dependencies.

## Repository File Structure Overview
The file structure of the repository is as follows with bolded folders denoting folders that contain the expected outputs.
.
├── README.md
├── Snakefile
├── **auspice**
│   └── flu_avian_h5n1_ha.json
├── clade-labeling
│   └── h5n1-clades.tsv
├── config
│   ├── auspice_config_h5n1.json
│   ├── colors_h5n1_wa.tsv
│   ├── exclude_isolates.txt
│   ├── include_isolates.txt
│   └── reference_h5n1_ha.gb
├── new_data
│   ├── metadata.tsv
│   ├── metadata.xlsx
│   └── raw_sequences_ha.fasta
├── **results**
│   ├── aa-muts_h5n1_ha.json
│   ├── aligned_h5n1_ha-delim.fasta.log
│   ├── aligned_h5n1_ha-delim.iqtree.log
│   ├── aligned_h5n1_ha.fasta
│   ├── aligned_h5n1_ha.fasta.insertions.csv
│   ├── aligned_h5n1_ha.fasta.log
│   ├── branch-lengths_h5n1_ha.json
│   ├── cleavage-site-sequences_h5n1_ha.json
│   ├── cleavage-site_h5n1_ha.json
│   ├── include
│   ├── nt-muts_h5n1_ha.json
│   ├── traits_h5n1_ha.json
│   ├── traits_h5n1_hacountry.mugration_model.txt
│   ├── traits_h5n1_haregion.mugration_model.txt
│   ├── tree-raw_h5n1_ha.nwk
│   └── tree_h5n1_ha.nwk
└── scripts
    ├── annotate-ha-cleavage-site.py
    └── process_metadata.py


- `config/`: contains what
- `new_data/`: contains What
- `scripts/`:
- `clade-labeling`:

## Expected Outputs and Interpretation
After successfully running the build there will be two output folders containing the build results.

- `auspice/` folder contains:
- `results/` folder contains:

## Scientific Decisions
- **Tiered subsampling**: [Prioritizes WA, regional (British Columbia, Idaho, etc... ) while maintaining national/global context. Heavy emphasis on Asia & North America subsampling. more here. What exactly is the subsampling strategy, why are we pulling from Asia more (because currently circulating D.1.1. clade most closely resembles an introduction from Asia)]}
- **Root selection**: A/Goose/Guangdong/1/96(H5N1) [Why was this root selected?]
- **Furin cleavage site**:`scripts/annotate-ha-cleavage-site.py` is used by the rule cleavage_site to determine the sequence of amino acids at the HA cleavage site and annotate those sequences for whether they contain a furin cleavage site. This will show up on the Color By drop down as "furin cleavage motif" and be colored as present, absent, or missing data. [Why is it important that we know if there's a motif present or not and what does that tell us/how do we interpret it?]
- **Molecular clock IQD range**: [IQD range was increased from 4 to 10 to accommodate the D.1.1. sequences in Washington that were under diverged]
- **Other adjustments**:
  - `config/includes.txt`: These sequences are always included into our sampling strategy as they are relevant to our epidemiological investigations.
  - `config/excludes.txt`: These sequences are always excluded from our subsampling and filtering due to duplication and based on epidemiological linkage knowledge.


## Adapting for Another State
 [Instructions on how to adapt this build for another state. What files need to be modified and in what ways. The sections should be outlined in a clear way]
 - **Input files**:
 - **Tiered subsampling**:
 - **Root selection**:
 - **Molecular clock IQD range**:




## Contributing
For any questions please submit them to our [Discussions](https://github.com/NW-PaGe/avian-flu/discussions) page otherwise software issues and requests can be logged as a Git [Issue](https://github.com/NW-PaGe/avian-flu/issues).

## License
This project is licensed under a modified GPL-3.0 License.
You may use, modify, and distribute this work, but commercial use is strictly prohibited without prior written permission.

## Acknowledgements

[add acknowledgements to AMD teams, WADDL, etc... for contributing to this work]
