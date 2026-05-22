
configfile: "config/config.yaml"

SAMPLES = config["samples"]
READS = ["1", "2"]
rule all:
    input:
        expand("results/qc/{sample}_{read}_fastqc.html", sample=SAMPLES, read=READS),
	expand("results/alignments/{sample}.sorted.bam.bai", sample=SAMPLES),
	expand("results/variants/{sample}.vcf", sample=SAMPLES)


rule fastqc:
    input:
        "data/raw/{sample}_{read}.fastq"

    output:
        html="results/qc/{sample}_{read}_fastqc.html",
        zip="results/qc/{sample}_{read}_fastqc.zip"

    threads:
        1

    log:
        "results/logs/{sample}_{read}_fastqc.log"

    shell:
        """
        fastqc {input} -o results/qc/ > {log} 2>&1
        """

rule trim:
    input:
        r1="data/raw/{sample}_1.fastq",
        r2="data/raw/{sample}_2.fastq"

    output:
        p1="results/trimmed/{sample}_1P.fastq",
        u1="results/trimmed/{sample}_1U.fastq",
        p2="results/trimmed/{sample}_2P.fastq",
        u2="results/trimmed/{sample}_2U.fastq"

    threads:
        config["threads"]

    shell:
        """
        trimmomatic PE \
        {input.r1} {input.r2} \
        {output.p1} {output.u1} \
        {output.p2} {output.u2} \
        SLIDINGWINDOW:4:20
        """

rule align:
    input:
        ref=config["reference"],
        r1="results/trimmed/{sample}_1P.fastq",
        r2="results/trimmed/{sample}_2P.fastq"

    output:
        "results/alignments/{sample}.sam"

    threads:
        config["threads"]

    shell:
        """
        bwa mem -t {threads} \
        -R "@RG\\tID:{wildcards.sample}\\tSM:{wildcards.sample}\\tPL:ILLUMINA" \
        {input.ref} {input.r1} {input.r2} > {output}
        """


rule sam_to_bam:
    input:
        "results/alignments/{sample}.sam"

    output:
        "results/alignments/{sample}.bam"

    threads:
        config["threads"]

    shell:
        """
        samtools view -@ {threads} -Sb {input} > {output}
        """

rule sort_bam:
    input:
        "results/alignments/{sample}.bam"

    output:
        "results/alignments/{sample}.sorted.bam"

    threads:
        config["threads"]

    shell:
        """
        samtools sort -@ {threads} \
        -o {output} {input}
        """

rule index_bam:
    input:
        "results/alignments/{sample}.sorted.bam"

    output:
        "results/alignments/{sample}.sorted.bam.bai"

    threads:
        config["threads"]

    shell:
        """
        samtools index -@ {threads} {input}
        """

rule call_variants:
    input:
        ref=config["reference"],
        bam="results/alignments/{sample}.sorted.bam"

    output:
        "results/variants/{sample}.vcf"

    threads:
        config["threads"]

    shell:
        """
        gatk HaplotypeCaller \
        -R {input.ref} \
        -I {input.bam} \
        -O {output}
        """
