# H5N1 Washington focused build for HA segment
## Table of Contents
- [Build Overview](#build-overview)
- [Data Sources & Inputs](#data-sources--inputs)
- [Setup & Dependencies](#setup--dependencies)
  - [Installation](#installation)
  - [Clone the repository](#clone-the-repository)
- [Run the Build with Test Data](#run-the-build-with-test-data)
- [High-level Build Features & Capabilities](#high-level-build-features--capabilities)
- [Scientific Decisions](#scientific-decisions)
- [Adapting for Another State](#adapting-for-another-state)
- [Expected Outputs and Interpretation](#expected-outputs-and-interpretation)
- [Questions](#questions)
- [Acknowledgements](#acknowledgements)


## Build Overview
- **Build Name**: H5N1 Washington focused build for HA segment
- **Pathogen/Strain**: Influenza A H5N1
- **Scope**: HA segment, Washington focused
- **Purpose**: This repository contains the Nextstrain build for Washington State genomic surveillance of H5N1 HA segment.
- **Nextstrain Build Location**: https://nextstrain.org/groups/wadoh/flu/avian/washington/h5n1/4y/ha

## Data Sources & Inputs
This build relies on publicly available data sourced from GISAID and GenBank. These data have been cleaned and stored on AWS.

- **Sequence Data**: GISAID, GenBank (for select sequences)
- **Metadata**: Sample collection metadata from GISAID and GenBank
- **Expected Inputs**:
    - `new_data/raw_sequences_ha.fasta` (containing viral genome sequences)
    - `new_data/metadata.xlsx` (with relevant sample information)

## Setup & Dependencies
### Installation
Ensure that you have [Nextstrain](https://docs.nextstrain.org/en/latest/install.html) installed.

To check that Nextstrain is installed:
```
nextstrain check-setup
```

### Clone the repository:

```
git clone https://github.com/NW-PaGe/avian-flu.git
cd avian-flu
```

## Run the Build with Test Data
To test the pipeline with the provided example data:

```
nextstrain build .
```

## High-level Build Features & Capabilities
- Washington focused subsampling strategy
- Furin Cleavage Site Identification

## Scientific Decisions
- **Subsampling strategy**: [Prioritizes WA, regional (British Columbia, Idaho, etc... ) while maintaining national/global context. Heavy emphasis on Asia & North America subsampling. more here. What exactly is the subsampling strategy, why are we pulling from Asia more (because currently circulating D.1.1. clade most closely resembles an introduction from Asia)]}
- **Root Selection**: A/Goose/Guangdong/1/96(H5N1) [Why was this root selected?]
- **Furin Cleavage Site**:`scripts/annotate-ha-cleavage-site.py` is used by the rule cleavage_site to determine the sequence of amino acids at the HA cleavage site and annotate those sequences for whether they contain a furin cleavage site. This will show up on the Color By drop down as "furin cleavage motif" and be colored as present, absent, or missing data. [Why is it important that we know if there's a motif present or not and what does that tell us/how do we interpret it?]
- **Molecular Clock IQD Range Increase**: [IQD range was increased from 4 to 10 to accommodate the D.1.1. sequences in Washington that were under diverged]
- **Other adjustments**:
  - `config/includes.txt`: These sequences are always included into our sampling strategy as they are relevant to our epidemiological investigations.
  - `config/excludes.txt`: These sequences are always excluded from our subsampling and filtering due to duplication and based on epidemiological linkage knowledge.


## Adapting for Another State
- [Instructions on how to adapt this build for another state. What files need to be modified and in what ways]

## Expected Outputs and Interpretation

- `auspice/` folder contains:

- `results/` folder contains:

## Questions
For any questions please submit them to our [Discussions](https://github.com/NW-PaGe/avian-flu/discussions) page otherwise software issues and requests can be logged as a [Git Issue]((https://github.com/NW-PaGe/avian-flu/issues)).

## Acknowledgements

[add acknowledgements to AMD teams, WADDL, etc... for contributing to this work]
