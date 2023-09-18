# Synthetic lethality of TSG in hiPSC

Internal information:

* SequenceScape study: [4402](https://sequencescape.psd.sanger.ac.uk/studies/4402/information)
* CanApps project: [1527](https://canapps.sanger.ac.uk/action/Cancer_Pipeline_SampleDetails?project_id=1527)

External information:

* ENA project accession: [PRJEB23720](https://www.ebi.ac.uk/ena/browser/view/PRJEB23720)

*Note: this project contains additional samples that were not part of this CRISPR screen.*

## What's in this directory?

`QC.ipynb` is a [Jupyter/IPython Notebook](https://ipython.org/notebook.html) that runs an [R](https://www.r-project.org/) kernel. It uses the following files and directories as input:

### Raw count matrix
The raw count matrix associated with this screen in the manuscript can be found in `raw_count_matrix.tsv`.

*Note: sample names (column names) in the raw count matrix may differ from the sample labels in QC plots and tables*

### Sample metadata

Sample metadata includes the internal (e.g. Sanger sample ID), external (e.g. ENA accessions) linked to the sample names and labels they represent.

* `METADATA/sample_metadata.tsv` contains sample metadata linking internal and external sample ids/names to the labels used in plots

### `BAGEL2_f9eedca`

Results from [BAGEL2](https://github.com/hart-lab/bagel) (commit reference `f9eedca`) were used to produce ROC curves for QC. 

* BAGEL2 commands can be found in `BAGEL2_f9eedca/bagel_jobscript.sh` which is an [LSF](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=overview-lsf-introduction) jobscript
* Gene lists used for classification can be found in `BAGEL2_f9eedca/gene_lists/bagel_CEGv2_53388ad.txt` (core/common enriched) and `BAGEL2_f9eedca/gene_lists/bagel_NEGv1_53388ad.txt` (core/common depleted)
* Different permutations were run to compare DSCC1 to WT, WT to Plasmid and DSCC1 to plasmid whose outputs can be found in `BAGEL2_f9eedca/results`

