# Downloading H5N1 files from GISAID.org
This repository includes files needed for running a WA, ID, OR, and BC focused HPAI Nextstrain build for the HA segment.  Steps for downloading GISAID sequencing and metadata files required for the build are below:

Sequencing and metadata for this pipeline are pulled from GISAID.org

After logging into GISAID EpiFlu, go to the Search tab and enter the following parameters:
- Type: A
- H: 5
- N: 1
- Host: Human and Animal
- Location: all
- Collection date: last 4 years of data through current date
- Required Segments: HA
- Only complete sequences


With these parameters, download Sequences as FASTA with format
- Format: "Sequences (DNA) as FASTA"
- FASTA Header: 	Isolate name | Isolate ID | Collection date
- Date fotmat: YYYY-MM-DD
- Check replace spaces with underscores in FASTA header
- Check remove space before and after values in FASTA header

After downloading sequences, save FASTA file in working folder as "gisaid_epiflu_sequence_YYYY.MM.DD.fasta" with YYYY-MM-DD as day it is pulled

 
With the same paramaters as above, download "Isolates as XLS (virus metadata only)"
- Date format : YYYY-MM-DD
- Check boxes for : "Replace spaces with underscores in FASTA header" and "Remove space before and after values in FASTA header"
After downloading, open workbook and save first tabe (Tabelle1) as CSV UTF-8 as "gisaid_epiflu_isolates_YYYY.MM.DD.csv" in working folder.


 # Running R script/cleaning data

 Run the R script "Formatting_GISAID_downloads_forgit.R"
 - input file 1 = "gisaid_epiflu_sequence_YYYY.MM.DD.fasta"
 - input file 2 = "gisaid_epiflu_isolates_YYYY.MM.DD.csv"
 - output file 1 = "gisaid_epiflu_sequence_cleaned_YYYY.MM.DD.fasta"
 - output file 2= "gisaid_epiflu_isolates_cleaned_YYYY.MM.DD.tsv"

# Run Pipeline
After cloning repo, navigate to folder the cloned reop is in in wsl and use following commands to run pipeline:
```conda activate nextstrain``` then 
```nextstrain build h5n1_wa_hpai/```

If using September 2024 ingest files, the pipeline should generate the same files as found in files_for_auspice folder
Once Snakemake input files are ready, edit ingest file names in Snakefile to input to the correct tsv and fasta file.

# Highlights of build (For BC-WA collaboration) and questions for integrating builds

Questions for BC
- What data is downloaded from GISAID and included in build?
- What are the ingest files / how are they formatted?
- Is there subsampling done in build? If so, what is the sampling scheme?
- What segments are used in build?
- If builds were to be integrated, what are build priorities for BC?
  
Same questions for WA with answers
- What data is downloaded from GISAID and included in build?
   - Answer: Downloaded from GISAID: Previous 4 years of data from GISAID, complete sequences from all human and animals. Data is cleaned in an R script to filter out sequences that: dont have complete collection date, have an egg passage and are duplicate with differing metatdata (this is a very small number and doesn't currently include any North America sequences)
- What are the ingest files / how are they formatted?
   - Answer: One fasta file with all sequences and one metadata file with all sequence metedata are ingested into build. These files are downlaoded fomr GISAID and cleaned via an R script before being ingested into build.
- Is there subsampling done in build? If so, what is the sampling scheme?
   - Answer: Yes, tiered subsampling using multiple augur filter rules: 
		 - Local: Washington sequences
		 - Regional: All OR, ID, and BC sequences
		 - North America: 400 sequences per month/year
		 - World: 2 sequences per month/year
- What segments are used in build?
   - Answer: Currently HA build - we also have a whole genome build used for seal-seabird outbreak outbreak
- If builds were to be integrated, what are build priorities for WA?
   - Answer: All WA and regional sequences and annotation of cleavage sites within build

