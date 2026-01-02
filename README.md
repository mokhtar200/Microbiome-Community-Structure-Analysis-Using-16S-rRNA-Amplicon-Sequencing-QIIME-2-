**ASV-Based Microbiome Profiling Using 16S rRNA Sequencing with QIIME 2**

---

## Project Description

This repository contains a **complete, reproducible, end-to-end 16S rRNA amplicon sequencing analysis workflow** using **QIIME 2**.

The project starts from **raw Illumina paired-end FASTQ files downloaded from NCBI SRA** and proceeds through:

* Quality control
* ASV inference using **DADA2**
* Taxonomic classification using **SILVA**
* Alpha and beta diversity analysis
* Statistical testing and visualization

This repository is suitable for:

* Teaching & workshops
* Bioinformatics portfolios
* Microbiome research projects

---

##  Dataset Information 

**BioProject:** PRJNA278478
**Data type:** 16S rRNA amplicon sequencing
**Region:** V4
**Sequencing platform:** Illumina MiSeq (paired-end)

### SRA Run Accessions Used

```
SRR1976948
SRR1976949
SRR1976950
SRR1976951
```

This dataset is widely used for benchmarking and teaching 16S rRNA analysis workflows.

---

## Project Objectives

* Import raw 16S rRNA sequencing reads into QIIME 2
* Generate high-resolution **Amplicon Sequence Variants (ASVs)**
* Assign taxonomy using a reference database
* Explore microbial community structure
* Compare diversity metrics across experimental groups

---

## Requirements

* Linux / macOS / WSL
* Conda / Miniconda
* QIIME 2 (tested on **qiime2-2023.9**)

### Install QIIME 2

```bash
conda create -n qiime2-2023.9 python=3.8
conda activate qiime2-2023.9
```

---

## Step 1: Download Raw Data from SRA

```bash
mkdir fastq && cd fastq
prefetch SRR1976948 SRR1976949 SRR1976950 SRR1976951

fasterq-dump SRR1976948 SRR1976949 SRR1976950 SRR1976951 \
  --split-files --gzip
```

---

## Step 2: Prepare Input Files

### `metadata.tsv`

* Contains sample-level information
* Must match SRA run IDs exactly

### `manifest.csv`

* Maps FASTQ file paths to sample IDs
* Required for QIIME 2 import

---

## Step 3: Run the Pipeline

Activate QIIME 2 and execute the script:

```bash
conda activate qiime2-2023.9
bash scripts/qiime2_pipeline.sh
```

All results will be generated in the `qiime2_results/` directory.

---

## Analysis Steps Performed

1. Import paired-end FASTQ files
2. Quality control & visualization
3. DADA2 denoising and chimera removal
4. Feature table & representative sequences
5. Taxonomic classification (SILVA)
6. Phylogenetic tree construction
7. Alpha diversity analysis
8. Beta diversity analysis
9. Differential abundance testing (ANCOM)

---

## Expected Results

* High-quality ASVs with single-nucleotide resolution
* Clear microbial composition profiles
* Statistically testable diversity differences
* Publication-quality QIIME 2 visualizations (`.qzv` files)

---

Ahmed Mokhtar
Bioinformatics | Metagenomics | Microbiome Data Analysis
