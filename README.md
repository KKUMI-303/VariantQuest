# VariantQuest

VariantQuest is a Next-Generation Sequencing (NGS) analysis pipeline for detecting genetic variants from raw sequencing data.

The workflow processes FASTQ files through quality control, alignment, variant calling, and annotation using commonly adopted bioinformatics tools.


# Features
- (*NEW*) CI GitHub Actions - Automatically test changes to the workflow when pushed to GitHub
- Quality control with FastQC
- Aggregated QC reporting with MultiQC
- Read trimming with Trimmomatic
- Sequence alignment using BWA
- BAM processing with SAMtools
- Variant calling using GATK HaplotypeCaller
- Variant annotation with SnpEff (Java 21 compatible)
- Fully automated workflow using Snakemake
- Reproducible Conda-based environment


# Tools Used

| Step                | Tool        |
| ------------------- | ----------- |
| Quality Control     | FastQC      |
| QC Aggregation      | MultiQC     |
| Trimming            | Trimmomatic |
| Alignment           | BWA         |
| BAM Processing      | SAMtools    |
| Variant Calling     | GATK        |
| Workflow Management | Snakemake   |


# Pipeline Workflow

```text
FASTQ
↓
FastQC
↓
MultiQC (QC aggregation)
↓
Trimmomatic (read trimming)
↓
BWA alignment
↓
SAMtools sort + index
↓
GATK HaplotypeCaller
↓
VCF generation
↓
MultiQC report
```


# Project Structure
```text
VariantQuest/
├── .github/
│   └── workflows/
│       └── test.yml
├── config/
│   └── config.yaml
├── data/
│   ├── annotation/
│   ├── raw/
│   ├── reference/
│   └── trimmed/
├── results/
│   ├── qc/
│   ├── alignments/
│   ├── variants/
│   ├── trimmed/
│   ├── logs/
│   ├── reports/
│   └── multiqc_data/
├── scripts/
├── workflow/
├── tests/
│   ├── config/
│   │   ├── config.yaml
│   ├── data/
│   │   ├── expected/
│   │   ├── raw/
│   │   └── reference/
│   ├── results/
│   │   ├── qc/
│   │   ├── alignments/
│   │   ├── variants/
│   │   ├── trimmed/
│   │   ├── logs/
│   │   └── multiqc_data/
│   ├── scripts/
│   │   └── validate_vcf.py
│   └── run_test.sh
├── Snakefile
├── environment.yml
├── snpEff_genes.txt
├── snpEff_summary.html
├── LICENSE
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
For production

```bash
snakemake --cores 4 --configfile config/config.yaml
```

For running tests locally
```bash
bash tests/run_test.sh
```
This runs Snakemake using the CI-specific configuration and then validates the resulting VCF based on the expected VCF.

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

VariantQuest now includes an automated integration test that runs through GitHub Actions on pushes and pull requests.

The CI test does not use the production sequencing data. Instead, it uses a small deterministic synthetic dataset designed specifically for automated testing.


# Future Improvements

* Cloud execution support
* RNA-seq module integration
* Multi sample variant calling
* Interactive reporting dashboard


# License

MIT License

