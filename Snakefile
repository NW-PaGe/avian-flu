"""This file specifies the entire avian-flu pipeline that will be run, with
specific parameters for subsampling, tree building, and visualization. In this
build, you will generate 1 tree: an H5N1 tree for the HA genes. In this simple
build, clade annotation has been removed. This template should provide a
reasonable starting place to customize your own build. Simply edit and add
components to this Snakefile."""


"""Here, define your wildcards. To include more subtypes or gene segments, simply
add those to these lists, separated by commas"""
SUBTYPES = ["h5n1"]
SEGMENTS = ["ha"]

"""This rule tells Snakemake that at the end of the pipeline, you should have
generated JSON files in the auspice folder for each subtype and segment."""
rule all:
    input:
        processed_metadata = "new_data/metadata.tsv",
        auspice_json = expand("auspice/flu_avian_{subtype}_{segment}.json", subtype=SUBTYPES, segment=SEGMENTS)

# Add this new rule for processing metadata
rule process_metadata:
    message:
        """
        Processing metadata from XLSX to TSV
        """
    input:
        raw_metadata = "new_data/metadata.xlsx"
    output:
        cleaned_metadata = "new_data/metadata.tsv"
    shell:
        """
        python scripts/process_metadata.py \
            --input {input.raw_metadata} \
            --output {output.cleaned_metadata}
        """

"""Specify all input files here. For this build, you'll start with input sequences
from the example_data folder, which contain partial metadata information in the
sequence header. Specify here files denoting specific strains to include or drop,
references sequences, and files for auspice visualization"""
# Ensure all downstream rules reference the output of `process_metadata`
rule files:
    params:
        input_sequences = "new_data/raw_sequences_ha.fasta",
        input_metadata = rules.process_metadata.output.cleaned_metadata,  # Update this line
        reference = "config/reference_h5n1_ha.gb",
        colors = "config/colors_h5n1_wa.tsv",
        auspice_config = "config/auspice_config_h5n1.json"


files = rules.files.params


"""These functions allow for different rules for different wildcards. For example,
these group_by and sequences_per_group functions will result in h5nx viruses being
subsampled to 5 sequences per subtype, country,and year, while h5n1 gets will be
subsampled down to 10 sequences per region, country, and month."""

def group_by(w):
    gb = {'h5nx': 'subtype country year','h5n1': 'region country month'}
    return gb[w.subtype]

def sequences_per_group(w):
    spg = {'h5nx': '5','h5n1': '10'}
    return spg[w.subtype]

"""The minimum length required for sequences. Sequences shorter than these will be
subsampled out of the build. Here, we're requiring all segments to be basically
complete. To include partial genomes, shorten these to your desired length"""
def min_length(w):
    len_dict = {"pb2": 2100, "ha":1600}
    length = len_dict[w.segment]
    return(length)

"""Sequences with sample collection dates earlier than these will be subsampled out of the build"""
def min_date(w):
    date = {'h5nx':'1960','h5n1': '1996'}
    return date[w.subtype]

"""h5nx sequences required to have a value for region in metadata; h5n1 sequences required to have value for region and county in metadata"""
def traits_columns(w):
    traits = {'h5nx':'region','h5n1': 'region country'}
    return traits[w.subtype]

"""This function allows us to annotate HA sequences with cleavage site information,
without trying to apply it to the other segments"""
def node_data_by_wildcards(w):
    """for ha, include cleavage site data during export; for other segments, do not"""
    if w.segment == "ha":
        node_data = [rules.refine.output.node_data,rules.traits.output.node_data,rules.ancestral.output.node_data,rules.translate.output.node_data,rules.cleavage_site.output.cleavage_site_annotations,rules.cleavage_site.output.cleavage_site_sequences]
    else:
        node_data = [rules.refine.output.node_data,rules.traits.output.node_data,rules.ancestral.output.node_data,rules.translate.output.node_data]
    return(node_data)


"""In this section of the Snakefile, rules are specified for each step of the pipeline.
Each rule has inputs, outputs, parameters, and the specific text for the commands in
bash. Rules reference each other, so altering one rule may require changing another
if they depend on each other for inputs and outputs. Notes are included for
specific rules."""


"""This rule specifies how to subsample data for the build, which is highly
customizable based on your desired tree."""

rule include_washington:
    message:
        """
        Including all Washington sequences
        """
    input:
        sequences = files.input_sequences,
        metadata = files.input_metadata,
        exclude_isolates = "config/exclude_isolates.txt" # File containing isolate names to always exclude
    output:
        strains = "results/include/washington-strains_{subtype}_{segment}.txt"
    params:
        query = "division == 'Washington'"
    shell:
        """
        augur filter \
         --metadata {input.metadata} \
         --sequences {input.sequences} \
         --query {params.query:q} \
         --exclude {input.exclude_isolates} \
         --output-strains {output.strains}
         """

rule include_regional:
    message:
        """
        Including all regional sequences
        """
    input:
        sequences = files.input_sequences,
        metadata = files.input_metadata,
        exclude_isolates = "config/exclude_isolates.txt" # File containing isolate names to always exclude
    output:
        strains = "results/include/regional-strains_{subtype}_{segment}.txt"
    params:
        group_by = ['month','year', 'region'],
        sequences_per_group = 400,
        min_date = min_date,
        min_length = min_length,
        query = "division == ['Idaho','Oregon','British Columbia','Alaska']"
    shell:
        """
        augur filter \
         --metadata {input.metadata} \
         --sequences {input.sequences} \
         --group-by {params.group_by} \
         --sequences-per-group {params.sequences_per_group}  \
         --query {params.query:q} \
         --exclude {input.exclude_isolates} \
         --output-strains {output.strains}
         """

rule include_northamerica:
    message:
        """
        Subsampling for North America sequences to include
        """
    input:
        sequences = files.input_sequences,
        metadata = files.input_metadata,
        specific_isolates = "config/include_isolates.txt",  # File containing isolate names to always include
        exclude_isolates = "config/exclude_isolates.txt"    #File containing isolate names to always exclude
    output:
        strains = "results/include/north-am-strains_{subtype}_{segment}.txt"
    params:
        group_by = ['month','year'],
        sequences_per_group = 100,
        min_date = min_date,
        min_length = min_length,
        query = "(region == 'North America') & (division != 'Washington')"
    shell:
        """
        augur filter \
         --metadata {input.metadata} \
         --sequences {input.sequences} \
         --group-by {params.group_by} \
         --sequences-per-group {params.sequences_per_group}  \
         --query {params.query:q} \
         --include {input.specific_isolates} \
         --exclude {input.exclude_isolates} \
         --output-strains {output.strains}
         """

rule include_world:
    message:
        """
        Subsampling for non North America sequences to include
        """
    input:
        sequences = files.input_sequences,
        metadata = files.input_metadata
    output:
        strains = "results/include/world-strains_{subtype}_{segment}.txt"
    params:
        group_by = ['month','year'],
        sequences_per_group = 2,
        min_date = min_date,
        min_length = min_length,
        query = "(region != 'North America' )"
    shell:
        """
        augur filter \
         --metadata {input.metadata} \
         --sequences {input.sequences} \
         --group-by {params.group_by} \
         --sequences-per-group {params.sequences_per_group}  \
         --query {params.query:q} \
         --output-strains {output.strains}
         """

rule include_asia:
    message:
        """
        Subsampling for Asia sequences to include
        """
    input:
        sequences = files.input_sequences,
        metadata = files.input_metadata
    output:
        strains = "results/include/asia-strains_{subtype}_{segment}.txt"
    params:
        group_by = ['month','year'],
        sequences_per_group = 400,
        min_date = min_date,
        min_length = min_length,
        query = "(region == 'Asia' )"
    shell:
        """
        augur filter \
         --metadata {input.metadata} \
         --sequences {input.sequences} \
         --group-by {params.group_by} \
         --sequences-per-group {params.sequences_per_group}  \
         --query {params.query:q} \
         --output-strains {output.strains}
         """

rule include:
    message:
        """
        Combining all included strains for the pipeline
        """
    input:
        sequences = files.input_sequences,
        metadata = files.input_metadata,
        include = [
            rules.include_washington.output.strains,
            rules.include_regional.output.strains,
            rules.include_northamerica.output.strains,
            rules.include_world.output.strains,
            rules.include_asia.output.strains
        ]
    output:
        sequences = "results/include/included_strains_{subtype}_{segment}.fasta"
    shell:
        """
        augur filter \
            --sequences {input.sequences} \
            --metadata {input.metadata} \
            --output {output.sequences} \
            --include {input.include} \
            --exclude-all
        """

rule align:
    message:
        """
        Aligning sequences to {input.reference}
          - filling gaps with N
        """
    input:
        sequences = rules.include.output.sequences,
        reference = files.reference
    output:
        alignment = "results/aligned_{subtype}_{segment}.fasta"
    shell:
        """
        augur align \
            --sequences {input.sequences} \
            --reference-sequence {input.reference} \
            --output {output.alignment} \
            --remove-reference \
            --nthreads 6
        """


rule tree:
    message: "Building tree"
    input:
        alignment = rules.align.output.alignment
    output:
        tree = "results/tree-raw_{subtype}_{segment}.nwk"
    params:
        method = "iqtree"
    shell:
        """
        augur tree \
            --alignment {input.alignment} \
            --output {output.tree} \
            --method {params.method} \
            --nthreads 6
        """

rule refine:
    message:
        """
        Refining tree
          - estimate timetree
          - use {params.coalescent} coalescent timescale
          - estimate {params.date_inference} node dates
        """
    input:
        tree = rules.tree.output.tree,
        alignment = rules.align.output,
        metadata = files.input_metadata
    output:
        tree = "results/tree_{subtype}_{segment}.nwk",
        node_data = "results/branch-lengths_{subtype}_{segment}.json"
    params:
        coalescent = "skyline",
        date_inference = "marginal",
        clock_filter_iqd = 10
    shell:
        """
        augur refine \
            --tree {input.tree} \
            --alignment {input.alignment} \
            --metadata {input.metadata} \
            --output-tree {output.tree} \
            --output-node-data {output.node_data} \
            --timetree \
            --coalescent {params.coalescent} \
            --date-confidence \
            --stochastic-resolve \
            --date-inference {params.date_inference} \
            --clock-filter-iqd {params.clock_filter_iqd}
        """

rule ancestral:
    message: "Reconstructing ancestral sequences and mutations"
    input:
        tree = rules.refine.output.tree,
        alignment = rules.align.output,
        reference = files.reference
    output:
        node_data = "results/nt-muts_{subtype}_{segment}.json"
    params:
        inference = "joint"
    shell:
        """
        augur ancestral \
            --tree {input.tree} \
            --alignment {input.alignment} \
            --output-node-data {output.node_data} \
            --inference {params.inference}\
            --infer-ambiguous \
            --root-sequence {input.reference}
        """

rule translate:
    message: "Translating amino acid sequences"
    input:
        tree = rules.refine.output.tree,
        node_data = rules.ancestral.output.node_data,
        reference = files.reference
    output:
        node_data = "results/aa-muts_{subtype}_{segment}.json"
    shell:
        """
        augur translate \
            --tree {input.tree} \
            --ancestral-sequences {input.node_data} \
            --reference-sequence {input.reference} \
            --output {output.node_data}
        """

rule traits:
    message: "Inferring ancestral traits for {params.columns!s}"
    input:
        tree = rules.refine.output.tree,
        metadata = files.input_metadata
    output:
        node_data = "results/traits_{subtype}_{segment}.json",
    params:
        columns = traits_columns,
    shell:
        """
        augur traits \
            --tree {input.tree} \
            --metadata {input.metadata} \
            --output {output.node_data} \
            --columns {params.columns} \
            --confidence
        """

"""This is a custom rule developed for the avian influenza builds and is not part
of the Nextstrain architecture. It uses custom python scripts to determine the
sequence of amino acids at the HA cleavage site, and annotate those sequences
for whether they contain a furin cleavage site."""
rule cleavage_site:
    message: "determining sequences that harbor furin cleavage sites"
    input:
        alignment = "results/aligned_{subtype}_ha.fasta"
    output:
        cleavage_site_annotations = "results/cleavage-site_{subtype}_ha.json",
        cleavage_site_sequences = "results/cleavage-site-sequences_{subtype}_ha.json"
    shell:
        """
        python scripts/annotate-ha-cleavage-site.py \
            --alignment {input.alignment} \
            --furin_site_motif {output.cleavage_site_annotations} \
            --cleavage_site_sequence {output.cleavage_site_sequences}
        """

"""This rule exports the results of the pipeline into JSON format, which is required
for visualization in auspice. To make changes to the categories of metadata
that are colored, or how the data is visualized, alter the auspice_config files"""
rule export:
    message: "Exporting data files for for auspice"
    input:
        tree = rules.refine.output.tree,
        metadata = files.input_metadata,
        node_data = node_data_by_wildcards,
        auspice_config = files.auspice_config
    output:
        auspice_json = "auspice/flu_avian_{subtype}_{segment}.json"
    shell:
        """
        augur export v2 \
            --tree {input.tree} \
            --metadata {input.metadata} \
            --node-data {input.node_data}\
            --auspice-config {input.auspice_config} \
            --include-root-sequence-inline \
            --output {output.auspice_json}
        """

rule clean:
    message: "Removing directories: {params}"
    params:
        "results ",
        "auspice"
    shell:
        "rm -rfv {params}"
