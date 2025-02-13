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


# Build Overview
- Build Name: H5N1 Washington focused build for HA segment
- Pathogen/Strain: Influenza A H5N1
- Scope: HA segment, Washington focused
- Purpose: This repository contains the Nextstrain build for Washington State genomic surveillance of h5n1 HA segment.

# Data Sources & Inputs
This build relies on publicly available data sourced from GISAID and GenBank. These data have been cleaned and stored on AWS.

- Sequence Data: GISAID, GenBank (for select sequences)
- Metadata: Sample collection metadata from GISAID and GenBank
- Expected Inputs:
    - new_data/raw_sequences_ha.fasta (containing viral genome sequences)
    - new_data/metadata.xlsx (with relevant sample information)

# Setup & Dependencies
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

# 4. Run the Build with Test Data
To test the pipeline with the provided example data:

```
nextstrain build .
```

# 5. High-level Build Features & Capabilities
- Washington focused subsampling strategy
- Furin Cleavage site

# 6. Scientific Decisions
- Subsampling strategy: Prioritizes WA, regional (British Columbia, Idaho, etc... ) while maintaining national/global context. Heavy emphasis on Asian subsampling.
- Root Selection:
- Other adjustments:

# 7. Adapting for Another State
- Instructions on how to adapt this build for another state.

# 8. Expected Outputs and Interpretation

- `auspice/` folder contains:
- `results/` folder contains:
