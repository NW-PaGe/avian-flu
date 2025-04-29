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

#### Clone the repository:

```
git clone https://github.com/NW-PaGe/avian-flu.git
cd avian-flu
```

## Run the Build with Test Data
To test the pipeline with the provided example data located in `new_data/` make sure you are located in the build folder `avian-flu/` before running the build command:

```
nextstrain build .
```

When you run the build using `nextstrain build .`, Nextstrain uses Snakemake as the workflow manager to automate genomic analyses. The Snakefile in a Nextstrain build defines how raw input data (sequences and metadata) are processed step-by-step in an automated way. Nextstrain builds are powered by Augur (for phylogenetics) and Auspice (for visualization) and Snakemake is used to automate the execution of these steps using Augur and Auspice based on file dependencies.

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

- `Snakefile`: The Snakefile serves as the blueprint for defining and organizing the data processing workflow. It is a plain text file that contains a series of rules, each specifying how to transform input files into output files.
- `config/`: Contains the configuration .json file that defines how data should be presented in Auspice, the reference .gb file, the .tsv file to associate discrete values with colors in visualization, the include.txt and exluced.txt files to specify which sequences in include and exclude in build
- `new_data/`: Contains the most recent sequences and metadata to be used as input files
- `test_data/`: Contains a the past 4 years of sequences and metadata sourced from NCBI to be used to test this build
- `scripts/`: Contains scripts that are called within the Snakefile.
 - `annotate-he-cleavage-site.py`: Python script that reads in HA alignment file, pulls out the 4 amino acid sites preceding HA2 and annotates the sequences for the furin cleavage site identification.
 - `process_metadata.py`: Python script that cleans and filters the metadata file.
<!-- - - `clade-labeling`: Currently not used in this build. -->

## Expected Outputs and Interpretation
After successfully running the build there will be two output folders containing the build results.

- `auspice/` folder contains:
  - `flu_avian_h5n1_ha.json` : JSON file to be visualized in Auspice
- `results/` folder contains:
  - `include/`: Text files of subsampled sequences to include and a fasta file of sequences to include in build
  - Intermediate files generated from build

## Scientific Decisions
- **Tiered subsampling**: Subsampling prioritizes Washington and regional (British Columbia, Idaho, Oregon) sequences while maintaining national/global with emphasis on North America and Asia. Subsampling focuses on Asia because of the currently circulating D.1.1. clade that most closely resembles an introduction from Asia.
- Reference selection**: [A/Goose/Guangdong/1/96(H5N1)](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=93838) is used as the reference because it was the first identified H5N1 subtype.
- **Furin cleavage site**:`scripts/annotate-ha-cleavage-site.py` is used by the rule cleavage_site to determine the sequence of amino acids at the HA cleavage site and annotate those sequences for whether they contain a furin cleavage site. This will show up on the Color By drop down as "furin cleavage motif" and be colored as present, absent, or missing data. A furin cleavage motif addition preceding the HA cleavage site may result in viral replication across a range of tissues as well as being one of the prime determinants of avian influenza virulence.
- **Molecular clock IQD range**: The IQD range was increased from 4 to 10 to accommodate the D.1.1. sequences in Washington that were under diverged. By increasing the IQD range, it allows tips that are more deviated than 10 interquartile ranges from the root-to-tip vs time regression to be included.
- **Other adjustments**:
  - `config/includes.txt`: These sequences are always included into our sampling strategy as they are relevant to our epidemiological investigations.
  - `config/excludes.txt`: These sequences are always excluded from our subsampling and filtering due to duplication and based on epidemiological linkage knowledge.


## Adapting for Another State
 - **Input files**: Raw fasta files and metadata files containing the starting sequences are ingested into build. The format for fasta file and metadata file should match that in the `test_data` folder.
 - **Tiered subsampling**: Tiered subsampling is a strategy that enables different numbers of sequences to be included in a Nextstrain build depending on what type of jurisdiction these sequences were sampled from , thereby allowing us to tailor sampling intensity to the jurisdiction(s) with the highest relevance for public health action, and minimize data inclusion from other areas. To adapt this subsampling to your own jurisdiction, the tiers of the sampling within the augur filter rules in the Snakefile (starting at line 107) need to be adjusted
 <!-- This feature is useful when many genome sequences for your pathogen of interest are available, and you need to constrain dataset size while prioritizing genomic surveillance visibility in your own jurisdiction, or your primary interest is in understanding transmission within a particular locality, but you wish to maintain background context of how that outbreak relates to broader scales of disease transmission. -->
 - **Reference selection**: The reference is [selected by the user](https://docs.nextstrain.org/en/latest/guides/bioinformatics/translate_ref.html) and is the sequence which all other samples in the tree are compared against for genome alignment and annotation.
 - **Molecular clock IQD range**: Selection of the IDQ range allows for flexibility in including or excluding more deviated sequences in the tree.  The decisions to increase or decrease IQD range parameter depends on what samples are to be included in the tree.


## Contributing
For any questions please submit them to our [Discussions](https://github.com/NW-PaGe/avian-flu/discussions) page otherwise software issues and requests can be logged as a Git [Issue](https://github.com/NW-PaGe/avian-flu/issues).

## License
This project is licensed under a modified GPL-3.0 License.
You may use, modify, and distribute this work, but commercial use is strictly prohibited without prior written permission.

## Acknowledgements

This work is made possible by the open sharing of genetic data by research groups from all over the world. We gratefully acknowledge their contributions.  Special thanks to Washington Animal Disease Diagnostic Laboratory (WADDL) and AMD collaborators.
