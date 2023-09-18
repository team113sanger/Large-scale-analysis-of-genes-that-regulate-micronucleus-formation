#BSUB -q normal
#BSUB -J BAGEL2
#BSUB -oo "BAGEL2_f9eedca/bagel2.o"
#BSUB -eo "BAGEL2_f9eedca/bagel2.e"
#BSUB -R "select[mem>5000] rusage[mem=5000] span[hosts=1]"
#BSUB -M 5000

# Load module (Singularity pulled from Docker https://hub.docker.com/r/t113sanger/bagel2)
module load bagel2/f9eedca

# Show current working directory
echo "Current working directory: ${PWD}"

# Check output directory exists
if [ ! -d "${PWD}/BAGEL2_f9eedca" ]
then
    echo "Output directory does not exist: ${PWD}/BAGEL2_f9eedca"
fi

#---- RAW COUNT MATRIX ----#
echo "Validating raw count matrix..."

# Set raw counts matrix location
counts="${PWD}/raw_count_matrix.tsv"

# Check counts file exists
if [ ! -f "${counts}" ]
then
    echo "Count matrix file does not exist: ${counts}"
fi

#---- BAGEL ESS AND NON-ESS GENES ----#
echo "Validating essential and non-essential genes"

# Set BAGEL essential genes location
ess="${PWD}/BAGEL2_f9eedca/gene_lists/bagel_CEGv2_53388ad.txt"

# Check counts file exists
if [ ! -f "${ess}" ]
then
    echo "Essential gene file does not exist: ${ess}"
fi

# Set BAGEL non-essential genes location
noness="${PWD}/BAGEL2_f9eedca/gene_lists/bagel_NEGv1_53388ad.txt"

# Check counts file exists
if [ ! -f "${noness}" ]
then
    echo "Non-essential gene file does not exist: ${noness}"
fi

#---- BAGEL VERSION ----#

# Get BAGEL build version
echo "Writing BAGEL version to ${PWD}/BAGEL2_f9eedca/results/bagel_version.txt"
BAGEL.py version > "${PWD}/BAGEL2_f9eedca/bagel_version.txt"

#---- all vs Plasmid ----#

# Get fold changes for all samples compared to plasmid
echo "Getting LFCs for all samples vs plasmid"
BAGEL.py fc -i "${counts}" -o "${PWD}/BAGEL2_f9eedca/results/all_vs_plasmid" -c "Neo_IRES_plasmid" --min-reads 30 

#---- all vs Plasmid ----#
contrast="WT_vs_plasmid"
lfc="${PWD}/BAGEL2_f9eedca/results/all_vs_plasmid.foldchange"
bfs="${PWD}/BAGEL2_f9eedca/results/${contrast}.gene.bf"

# Get gene-level Bayes factors
echo "Getting gene BFs for ${contrast}"
BAGEL.py bf -i "${lfc}" -o "${PWD}/BAGEL2_f9eedca/results/${contrast}.gene.bf" -e "${ess}" -n "${noness}" -c "BOB_screenA,BOB_screenB,BOB_screenC"

# Get sgrna-level Bayes factors
echo "Getting sgrna BFs for ${contrast}"
BAGEL.py bf -i "${lfc}" -o "${PWD}/BAGEL2_f9eedca/results/${contrast}.sgrna.bf" -e "${ess}" -n "${noness}" -c "BOB_screenA,BOB_screenB,BOB_screenC" -r

# Get precision recall
echo "Getting gene PR for ${contrast}"
BAGEL.py pr -i "${bfs}" -o "${PWD}/BAGEL2_f9eedca/results/${contrast}.pr" -e "${ess}" -n "${noness}"

#---- DSCC1 vs Plasmid ----#
contrast="DSCC1_vs_plasmid"
lfc="${PWD}/BAGEL2_f9eedca/results/all_vs_plasmid.foldchange"
bfs="${PWD}/BAGEL2_f9eedca/results/${contrast}.gene.bf"

# Get gene-level Bayes factors
echo "Getting gene BFs for ${contrast}"
BAGEL.py bf -i "${lfc}" -o "${PWD}/BAGEL2_f9eedca/results/${contrast}.gene.bf" -e "${ess}" -n "${noness}" -c "Dcss1H06_screenA_v2,Dcss1H06_screenB_v2,Dcss1H06_screenC_v2"

# Get sgrna-level Bayes factors
echo "Getting sgrna BFs for ${contrast}"
BAGEL.py bf -i "${lfc}" -o "${PWD}/BAGEL2_f9eedca/results/${contrast}.sgrna.bf" -e "${ess}" -n "${noness}" -c "Dcss1H06_screenA_v2,Dcss1H06_screenB_v2,Dcss1H06_screenC_v2" -r

# Get precision recall
echo "Getting gene PR for ${contrast}"
BAGEL.py pr -i "${bfs}" -o "${PWD}/BAGEL2_f9eedca/results/${contrast}.pr" -e "${ess}" -n "${noness}"

#---- DSCC1 vs WT ----#
contrast="DSCC1_vs_WT"
lfc="${PWD}/BAGEL2_f9eedca/results/${contrast}.foldchange"
bfs="${PWD}/BAGEL2_f9eedca/results/${contrast}.gene.bf"

# Get fold changes for DSCC1 compared to WT
echo "Getting LFCs for ${contrast}"
BAGEL.py fc -i "${counts}" -o "${PWD}/BAGEL2_f9eedca/results/DSCC1_vs_WT" -c "BOB_screenA,BOB_screenB,BOB_screenC" --min-reads 30 

# Get gene-level Bayes factors
echo "Getting gene BFs for ${contrast}"
BAGEL.py bf -i "${lfc}" -o "${PWD}/BAGEL2_f9eedca/results/${contrast}.gene.bf" -e "${ess}" -n "${noness}" -c "Dcss1H06_screenA_v2,Dcss1H06_screenB_v2,Dcss1H06_screenC_v2"

# Get sgrna-level Bayes factors
echo "Getting sgrna BFs for ${contrast}"
BAGEL.py bf -i "${lfc}" -o "${PWD}/BAGEL2_f9eedca/results/${contrast}.sgrna.bf" -e "${ess}" -n "${noness}" -c "Dcss1H06_screenA_v2,Dcss1H06_screenB_v2,Dcss1H06_screenC_v2" -r

# Get precision recall
echo "Getting gene PR for ${contrast}"
BAGEL.py pr -i "${bfs}" -o "${PWD}/BAGEL2_f9eedca/results/${contrast}.pr" -e "${ess}" -n "${noness}"