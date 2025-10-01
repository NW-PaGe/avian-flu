# H5N1 Washington focused build for HA segment

## Build Overview
- **Build Name**: H5N1 Washington focused build for HA segment
- **Pathogen/Strain**: Influenza A H5N1
- **Scope**: HA segment, Washington focused
- **Purpose**: This repository contains the Nextstrain build for Washington State genomic surveillance of H5N1 HA segment.
- **Nextstrain Build Location**: https://nextstrain.org/groups/wadoh/flu/avian/washington/h5n1/4y/ha

## Table of Contents
- [Pathogen Epidemiology](#pathogen-epidemiology)
- [Scientific Decisions](#scientific-decisions)
- [Getting Started](#getting-started)
  - [Data Sources & Inputs](#data-sources--inputs)
  - [Setup & Dependencies](#setup--dependencies)
    - [Installation](#installation)
    - [Clone the repository](#clone-the-repository)
- [Run the Build with Test Data](#run-the-build-with-test-data)
- [Repository File Structure Overview](#repository-file-structure-overview)
- [Expected Outputs](#expected-outputs)
- [Customization for Local Adaptation](#customizations-for-local-adaptation)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Pathogen Epidemiology
- **Overview**:
  - H5N1 is a single stranded RNA virus with 8 segments. Due to this segments genome, novel genotypes can emerge from reassortment.
  - Transmission mainly occurs through droplets from coughing, sneezing or other aerosolization.  
- **Taxonomic Designations**:
  - Subtypes classified based on hemagglutinin (HA) and neuraminidase  (NA) surface proteins. H5N1 is just one of 130 influenza A subtypes identified.
  - Clades are classified based on the similarity of the HA segment
  <!--  **Geographic Distribution and Seasonality**:-->
- **Public Health Importance**: Surveillance of H5N1 in avian hosts and other animals allows early detection and public health risk assessment.
  <!--  **Genomic Relevance**:-->
- **Additional Resources**:
  - [Highly Pathogenic Avian Influenza A Virus Clade 2.3.4.4b Infections in Wild Terrestrial Mammals, US, 2022](https://wwwnc.cdc.gov/eid/article/29/12/23-0464-f4)



## Scientific Decisions
- **Tiered subsampling**: Subsampling prioritizes Washington and regional (British Columbia, Idaho, Oregon) sequences while maintaining national/global with emphasis on North America and Asia. Subsampling focuses on Asia because of the currently circulating D.1.1. clade that most closely resembles an introduction from Asia.
- **Reference selection**: [A/Goose/Guangdong/1/96(H5N1)](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=93838) is used as the reference because it was the first identified H5N1 subtype.
- **Furin cleavage site**:`scripts/annotate-ha-cleavage-site.py` is used by the rule cleavage_site to determine the sequence of amino acids at the HA cleavage site and annotate those sequences for whether they contain a furin cleavage site. This will show up on the Color By drop down as "furin cleavage motif" and be colored as present, absent, or missing data. A furin cleavage motif addition preceding the HA cleavage site may result in viral replication across a range of tissues as well as being one of the prime determinants of avian influenza virulence.
- **Molecular clock IQD range**: IQD range was increased from 4 - based on the [Nextrain global H5N1 build](https://nextstrain.org/avian-flu/h5n1/ha/2y) - to 10 to accommodate the D.1.1. sequences in Washington that were under diverged.  In `augur refine`, the command `--clock-filter-iqd` removes tips that deviate more than *n* quartiles ranges from the root-to-tip vs time regression. By increasing the IQD from 4 to 10, less tips are filtered out and in turn the D.1.1 sequences will not be pruned from the tree.
- **Other adjustments**:
  - `config/includes.txt`: These sequences are always included into our sampling strategy as they are relevant to our epidemiological investigations.
  - `config/excludes.txt`: These sequences are always excluded from our subsampling and filtering due to duplication and based on epidemiological linkage knowledge.

## Getting Started
This build was put together due to the need for a state focused H5N1 surveillance tool that was not previously available for Washington. The starting point for this build was the [Nextstrain H5N1 build](https://github.com/nextstrain/avian-flu) and Washington-specific subsampling and data sourcing were implemented.

Some high-level build features and capabilities are:
- **Washington focused tiered subsampling strategy**: This subsampling strategy prioritizes all Washington, Bitish Columbia, Idaho and Oregon sequences while maintaining a national and global context with subsampling from North America and global sequences.
- **Furin Cleavage Site Identification**: The Auspice color-by options includes two furin cleavage site labels: the furin cleavage site motifs are labeled as present, absent, or missing and the furin cleavage site sequences (the four bases preceding HA2) are labeled in the tree.

### Data Sources & Inputs
This build relies on publicly available data sourced from GISAID and GenBank. These data have been cleaned and stored on AWS.

- **Sequence Data**: GISAID, GenBank (for select sequences)
- **Metadata**: Sample collection metadata from GISAID and GenBank
- **Expected Inputs**:
    - `new_data/fasta/raw_sequences_ha.fasta` (containing viral genome sequences)
    - `new_data/metadata/metadata.xlsx` (with relevant sample information)

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

## Expected Outputs
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
More details on file structure of this build can be found [here](https://github.com/NW-PaGe/avian-flu/wiki/File-Structure)


Running the build with the provided fasta and metadata file in `test_data`, the runtime using a 32.0 GB computer with 4 cores should take approximately 10 minutes. After successfully running the build with test data, there will be two output folders containing the build results.


- `auspice/` folder contains:
  - `flu_avian_h5n1_ha.json` : JSON file to be visualized in Auspice
- `results/` folder contains:
  - `include/`: Text files of subsampled sequences to include and a fasta file of sequences to include in build
  - Intermediate files generated from build




## Customization for Local Adaptation
 - **Input files**: Raw fasta files and metadata files containing the starting sequences are ingested into build. The format for fasta file and metadata file should match that in the `test_data` folder.
 - **Tiered subsampling**: Tiered subsampling is a strategy that enables different numbers of sequences to be included in a Nextstrain build depending on what type of jurisdiction these sequences were sampled from , thereby allowing us to tailor sampling intensity to the jurisdiction(s) with the highest relevance for public health action, and minimize data inclusion from other areas. To adapt this subsampling to your own jurisdiction, the tiers of the sampling within the augur filter rules in the Snakefile (starting at line 107) need to be adjusted
 <!-- This feature is useful when many genome sequences for your pathogen of interest are available, and you need to constrain dataset size while prioritizing genomic surveillance visibility in your own jurisdiction, or your primary interest is in understanding transmission within a particular locality, but you wish to maintain background context of how that outbreak relates to broader scales of disease transmission. -->
 - **Reference selection**: The reference is [selected by the user](https://docs.nextstrain.org/en/latest/guides/bioinformatics/translate_ref.html) and is the sequence which all other samples in the tree are compared against for genome alignment and annotation.
<! -- - **Root selection**: The root of the tree determined the order of branching of a tree.  The root can be a reference sequence that represents the earliest known genome of a pathogen or be a fairly distant but related virus. -->
 - **Molecular clock IQD range**: This range can be specified in the command `--clock-filter-iqd` within `augur refine`. Not including this command results in no sequences being pruned form the tree, and will include all outliers.  If wanting to prune outliers, the IQD value should prune the tree in a way that includes the sequences of interest but gets rid out unwanted outliers.


## Contributing
For any questions please submit them to our [Discussions](https://github.com/NW-PaGe/avian-flu/discussions) page otherwise software issues and requests can be logged as a Git [Issue](https://github.com/NW-PaGe/avian-flu/issues).

## License
This project is licensed under a modified GPL-3.0 License.
You may use, modify, and distribute this work, but commercial use is strictly prohibited without prior written permission.

## Acknowledgements

This work is made possible by the open sharing of genetic data by research groups from all over the world. We gratefully acknowledge their contributions.  Special thanks to Washington Animal Disease Diagnostic Laboratory (WADDL) and AMD collaborators.
