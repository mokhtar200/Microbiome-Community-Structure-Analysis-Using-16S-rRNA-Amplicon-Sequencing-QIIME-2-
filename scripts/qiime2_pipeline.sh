#!/bin/bash
set -e


# Activate QIIME2 environment
conda activate qiime2-2023.9


# Paths
DATA_DIR=data
RESULTS_DIR=results


mkdir -p ${RESULTS_DIR}


# 1. Import data
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path ${DATA_DIR}/manifest.csv \
--output-path ${RESULTS_DIR}/demux-paired.qza \
--input-format PairedEndFastqManifestPhred33V2


# 2. Demultiplex summary
qiime demux summarize \
--i-data ${RESULTS_DIR}/demux-paired.qza \
--o-visualization ${RESULTS_DIR}/demux.qzv


# 3. DADA2 denoising
qiime dada2 denoise-paired \
--i-demultiplexed-seqs ${RESULTS_DIR}/demux-paired.qza \
--p-trunc-len-f 240 \
--p-trunc-len-r 200 \
--o-table ${RESULTS_DIR}/table.qza \
--o-representative-sequences ${RESULTS_DIR}/rep-seqs.qza \
--o-denoising-stats ${RESULTS_DIR}/dada2-stats.qza


# 4. Feature table summary
qiime feature-table summarize \
--i-table ${RESULTS_DIR}/table.qza \
--m-sample-metadata-file ${DATA_DIR}/metadata.tsv \
--o-visualization ${RESULTS_DIR}/table.qzv


# 5. Taxonomy assignment
qiime feature-classifier classify-sklearn \
--i-classifier silva-138-99-nb-classifier.qza \
--i-reads ${RESULTS_DIR}/rep-seqs.qza \
--o-classification ${RESULTS_DIR}/taxonomy.qza


qiime metadata tabulate \
--m-input-file ${RESULTS_DIR}/taxonomy.qza \
--o-visualization ${RESULTS_DIR}/taxonomy.qzv


# 6. Diversity analysis
qiime diversity core-metrics-phylogenetic \
--i-table ${RESULTS_DIR}/table.qza \
--p-sampling-depth 10000 \
--m-metadata-file ${DATA_DIR}/metadata.tsv \
--output-dir ${RESULTS_DIR}/core-metrics


# 7. Alpha diversity group significance
qiime diversity alpha-group-significance \
--i-alpha-diversity ${RESULTS_DIR}/core-metrics/shannon_vector.qza \
--m-metadata-file ${DATA_DIR}/metadata.tsv \
--o-visualization ${RESULTS_DIR}/shannon-group-significance.qzv
