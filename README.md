# VariantQuest

VariantQuest is a Next-Generation Sequencing (NGS) analysis pipeline for detecting genetic variants from raw sequencing data.

The workflow processes FASTQ files through quality control, alignment, variant calling, and annotation using commonly adopted bioinformatics tools.


# Features

* Quality control with FastQC
* Read trimming with Trimmomatic
* Sequence alignment using BWA
* BAM processing with SAMtools
* Variant calling with GATK
* Variant annotation with SnpEff
* Workflow automation using Snakemake
* Reproducible Conda environment


# Tools Used

| Step                | Tool        |
| ------------------- | ----------- |
| Quality Control     | FastQC      |
| Trimming            | Trimmomatic |
| Alignment           | BWA         |
| BAM Processing      | SAMtools    |
| Variant Calling     | GATK        |
| Annotation          | SnpEff      |
| Workflow Management | Snakemake   |


# Pipeline Workflow

```text
FASTQ
  ↓
FastQC
  ↓
Trimmomatic
  ↓
BWA Alignment
  ↓
SAMtools Sort/Index
  ↓
GATK HaplotypeCaller
  ↓
VCF Variants
  ↓
SnpEff Annotation
```


# Project Structure

```text
VariantQuest/
├── config/
├── data/
│   ├── raw/
│   ├── trimmed/
│   └── reference/
├── results/
│   ├── qc/
│   ├── alignments/
│   ├── variants/
│   └── reports/
├── scripts/
├── workflow/
├── Snakefile
├── environment.yml
└── README.md
```

# Installation

```bash
git clone https://github.com/yourusername/VariantQuest.git
cd VariantQuest

conda env create -f environment.yml
conda activate variantquest
```


# Run Pipeline

```bash
snakemake --cores 4
```


# Outputs

The pipeline generates:

* Quality control reports
* Trimmed FASTQ files
* Sorted BAM alignment files
* Variant call files (VCF)
* Annotated variant reports


# Reproducibility

* Conda-managed software environment
* Snakemake workflow automation
* Configurable parameters using `config.yaml`


# Notes

SnpEff databases were unavailable for the selected test organism, so a custom annotation database was generated for testing purposes.


# Future Improvements

* Multi-sample variant calling
* Cloud execution support
* RNA-seq module integration
* Interactive reporting dashboard


# License

MIT License

