# 1. Build Overview
- Build Name: H5N1 Washington focused build for HA segment
- Pathogen/Strain: Influenza A H5N1
- Scope: HA segment, Washington focused
- Purpose: This build is meant to provide genomic surveillance of H5N1 sequenced cases, focusing specifically on Washington state.

# 2. Data
This build relies on publicly available data sourced from GISAID and GenBank. These data have been cleaned and stored on AWS.

- Sequence Data: GISAID, GenBank (for select sequences)
    - new_data/raw_sequences_ha.fasta
- Metadata: Sample collection metadata from GISAID and GenBank
    - new_data/metadata.xlsx


# 3. Workflow and Processing
- Snakemake workflow: [Brief description of major rules]
- Subsampling strategy: [Describe selection criteria]
- Alignment & Phylogenetics:
  - Alignment: MAFFT
  - Tree Inference: IQ-Tree
- Clade Assignments:

# 4. Output Files and Interpretation
File, Description, Format

How to use these outputs
- Auspice visualiation allows real-time exploration of viral evolution
- Metadata table provides key epidemiological variables (e.g., collection dates, location)

# 5. Customization Options
- coloring variables or changing build title/text in auspice_config.json
- subsampling strategy
- furin cleavage


# 6. System Requirements & Dependencies
- Nextstrain

# 7. Running the Build
### Basic Run Command
To execute the build, navigate to the project directory and run:
```
nextstrain build .
```


# Downloading H5N1 files from GISAID.org
