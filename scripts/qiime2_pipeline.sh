#!/bin/bash

# -------------------------------
# 0. Activate QIIME 2 environment
# -------------------------------
conda activate qiime2-2023.9

# -------------------------------
# 1. Define paths
# -------------------------------
DATA_DIR="data"
RESULTS_DIR="qiime2_results"
CLASSIFIER="silva-138-99-nb-classifier.qza"

mkdir -p ${RESULTS_DIR}

# -------------------------------
# 2. Import paired-end FASTQ files
# -------------------------------
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path ${DATA_DIR}/manifest.csv \
  --output-path ${RESULTS_DIR}/demux.qza \
  --input-format PairedEndFastqManifestPhred33V2

# -------------------------------
# 3. Demultiplex summary
# -------------------------------
qiime demux summarize \
  --i-data ${RESULTS_DIR}/demux.qza \
  --o-visualization ${RESULTS_DIR}/demux.qzv

# -------------------------------
# 4. Denoising with DADA2
# -------------------------------
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ${RESULTS_DIR}/demux.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f 240 \
  --p-trunc-len-r 200 \
  --o-table ${RESULTS_DIR}/table.qza \
  --o-representative-sequences ${RESULTS_DIR}/rep-seqs.qza \
  --o-denoising-stats ${RESULTS_DIR}/denoising-stats.qza

# -------------------------------
# 5. Feature table summary
# -------------------------------
qiime feature-table summarize \
  --i-table ${RESULTS_DIR}/table.qza \
  --m-sample-metadata-file ${DATA_DIR}/metadata.tsv \
  --o-visualization ${RESULTS_DIR}/table.qzv

qiime feature-table tabulate-seqs \
  --i-data ${RESULTS_DIR}/rep-seqs.qza \
  --o-visualization ${RESULTS_DIR}/rep-seqs.qzv

# -------------------------------
# 6. Taxonomic classification
# -------------------------------
qiime feature-classifier classify-sklearn \
  --i-classifier ${CLASSIFIER} \
  --i-reads ${RESULTS_DIR}/rep-seqs.qza \
  --o-classification ${RESULTS_DIR}/taxonomy.qza

qiime metadata tabulate \
  --m-input-file ${RESULTS_DIR}/taxonomy.qza \
  --o-visualization ${RESULTS_DIR}/taxonomy.qzv

qiime taxa barplot \
  --i-table ${RESULTS_DIR}/table.qza \
  --i-taxonomy ${RESULTS_DIR}/taxonomy.qza \
  --m-metadata-file ${DATA_DIR}/metadata.tsv \
  --o-visualization ${RESULTS_DIR}/taxa-barplot.qzv

# -------------------------------
# 7. Phylogenetic tree
# -------------------------------
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences ${RESULTS_DIR}/rep-seqs.qza \
  --o-alignment ${RESULTS_DIR}/aligned-rep-seqs.qza \
  --o-masked-alignment ${RESULTS_DIR}/masked-aligned-rep-seqs.qza \
  --o-tree ${RESULTS_DIR}/unrooted-tree.qza \
  --o-rooted-tree ${RESULTS_DIR}/rooted-tree.qza

# -------------------------------
# 8. Core diversity metrics
# -------------------------------
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ${RESULTS_DIR}/rooted-tree.qza \
  --i-table ${RESULTS_DIR}/table.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file ${DATA_DIR}/metadata.tsv \
  --output-dir ${RESULTS_DIR}/core-metrics-results

# -------------------------------
# 9. Alpha diversity significance
# -------------------------------
qiime diversity alpha-group-significance \
  --i-alpha-diversity ${RESULTS_DIR}/core-metrics-results/shannon_vector.qza \
  --m-metadata-file ${DATA_DIR}/metadata.tsv \
  --o-visualization ${RESULTS_DIR}/shannon-significance.qzv

# -------------------------------
# 10. Beta diversity significance
# -------------------------------
qiime diversity beta-group-significance \
  --i-distance-matrix ${RESULTS_DIR}/core-metrics-results/bray_curtis_distance_matrix.qza \
  --m-metadata-file ${DATA_DIR}/metadata.tsv \
  --m-metadata-column BodySite \
  --p-pairwise \
  --o-visualization ${RESULTS_DIR}/bray-curtis-significance.qzv

# -------------------------------
# 11. Differential abundance (ANCOM)
# -------------------------------
qiime composition add-pseudocount \
  --i-table ${RESULTS_DIR}/table.qza \
  --o-composition-table ${RESULTS_DIR}/comp-table.qza

qiime composition ancom \
  --i-table ${RESULTS_DIR}/comp-table.qza \
  --m-metadata-file ${DATA_DIR}/metadata.tsv \
  --m-metadata-column BodySite \
  --o-visualization ${RESULTS_DIR}/ancom-bodysite.qzv

echo "✅ QIIME 2 16S rRNA analysis pipeline completed successfully."
