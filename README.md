# Comparative Analysis of Gut Microbiota in Immune‑Mediated Inflammatory Diseases (16S rRNA, QIIME 2)

## Project Overview

This repository presents a **complete, reproducible 16S rRNA amplicon sequencing analysis** using **QIIME 2**, based on the **real human gut microbiome dataset PRJNA450340**.

**Study title (original):**
*A comparative study of the gut microbiota in immune‑mediated inflammatory diseases*

The study compares stool microbiota profiles among patients with:

* Crohn’s disease (CD, n = 20)
* Ulcerative colitis (UC, n = 19)
* Multiple sclerosis (MS, n = 19)
* Rheumatoid arthritis (RA, n = 21)
* Healthy controls (HC, n = 23)

Biological replicates were collected within a **2‑month interval**, enabling robust microbiome comparisons.

---

## Objectives

* Profile gut microbial composition using **16S rRNA amplicon sequencing**
* Identify disease‑specific microbiome signatures
* Compare alpha and beta diversity across immune‑mediated inflammatory diseases
* Detect differentially abundant taxa between disease groups and healthy controls

---

## Dataset Information

* **NCBI BioProject:** PRJNA450340
* **Sample type:** Human stool
* **Sequencing strategy:** 16S rRNA targeted amplicon sequencing
* **Platform:** Illumina MiSeq (paired‑end)
* **Target region:** V3–V4 16S rRNA gene
* **Design:** Case–control with longitudinal biological replicates

---

## Repository Structure

```
PRJNA450340_16S_QIIME2/
│
├── README.md
├── data/
│   ├── metadata.tsv
│   └── manifest.csv
│
├── scripts/
│   └── qiime2_pipeline.sh
│
├── results/
│   ├── demux.qzv
│   ├── dada2_stats.qzv
│   ├── taxonomy.qzv
│   ├── alpha_diversity.qzv
│   └── beta_diversity.qzv
│
└── environment/
    └── qiime2_env.yml
```

---

## Methods Summary

### Data Import

* FASTQ files downloaded from SRA using `fasterq-dump`
* Imported into QIIME 2 using a **manifest‑based paired‑end approach**

### Quality Control & Denoising

* Adapter and quality trimming
* **DADA2** used for:

  * Error correction
  * Chimera removal
  * Amplicon Sequence Variant (ASV) inference

### Taxonomic Classification

* SILVA 138 database
* Naive Bayes classifier trained on the V3–V4 region

###  Diversity Analysis

* Alpha diversity:

  * Shannon index
  * Observed features
* Beta diversity:

  * Bray–Curtis
  * Jaccard
  * PCoA visualization

### Statistical Testing

* Kruskal–Wallis tests for alpha diversity
* PERMANOVA for beta diversity
* Group comparisons: CD vs HC, UC vs HC, MS vs HC, RA vs HC

---

## Metadata Description

`metadata.tsv` includes:

* `sample-id`
* `disease_group` (CD, UC, MS, RA, HC)
* `subject_id`
* `replicate_timepoint`
* `sex`
* `age`

---

## QIIME 2 Pipeline

All steps are automated in:

```
scripts/qiime2_pipeline.sh
```

The script includes:

* Importing data
* Quality visualization
* DADA2 denoising
* Feature table generation
* Taxonomy assignment
* Diversity analysis

---

## Expected Outputs

* Interactive `.qzv` visualizations
* Taxonomic bar plots per disease group
* PCoA plots showing microbiome separation
* Alpha diversity boxplots comparing diseases

---

## 🔬 Biological Interpretation (Key Questions)

* Do immune‑mediated inflammatory diseases share common gut dysbiosis patterns?
* Which taxa are uniquely enriched or depleted per disease?
* Is microbiome diversity reduced compared to healthy controls?

---

##  How to Run

```bash
# Activate QIIME 2
conda activate qiime2-2023.9

# Run pipeline
bash scripts/qiime2_pipeline.sh
```

---

##  Skills Demonstrated

* Human gut microbiome analysis
* QIIME 2 (ASV‑based workflow)
* Reproducible bioinformatics pipelines
* Disease‑associated microbiome interpretation

---

## Author

**Ahmed Mokhtar**
Bioinformatics | Microbiome Analysis | NGS Data Science

* Integration with clinical metadata
* Machine learning‑based disease classification
