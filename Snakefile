
SAMPLES = config["samples"]
READS = ["1", "2"]
RESULTS = config.get("results_dir", "results")
RAW = config.get("raw_dir", "data/raw")
rule all:
    input:
        expand(f"{RESULTS}/qc/{{sample}}_{{read}}_fastqc.html", sample=SAMPLES, read=READS),
	expand(f"{RESULTS}/alignments/{{sample}}.sorted.bam.bai", sample=SAMPLES),
	expand(f"{RESULTS}/variants/{{sample}}.vcf", sample=SAMPLES),
	f"{RESULTS}/multiqc_report.html"


rule fastqc:
    input:
        f"{RAW}/{{sample}}_{{read}}.fastq"

    output:
        html=f"{RESULTS}/qc/{{sample}}_{{read}}_fastqc.html",
        zip=f"{RESULTS}/qc/{{sample}}_{{read}}_fastqc.zip"

    threads:
        1

    log:
        f"{RESULTS}/logs/{{sample}}_{{read}}_fastqc.log"

    shell:
        """
        fastqc {input} -o {RESULTS}/qc/ > {log} 2>&1
        """

rule trim:
    input:
        r1=f"{RAW}/{{sample}}_1.fastq",
	r2=f"{RAW}/{{sample}}_2.fastq"

    output:
        p1=f"{RESULTS}/trimmed/{{sample}}_1P.fastq",
        u1=f"{RESULTS}/trimmed/{{sample}}_1U.fastq",
        p2=f"{RESULTS}/trimmed/{{sample}}_2P.fastq",
        u2=f"{RESULTS}/trimmed/{{sample}}_2U.fastq"

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
        r1=f"{RESULTS}/trimmed/{{sample}}_1P.fastq",
	r2=f"{RESULTS}/trimmed/{{sample}}_2P.fastq"

    output:
        f"{RESULTS}/alignments/{{sample}}.sam"

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
        f"{RESULTS}/alignments/{{sample}}.sam"

    output:
        f"{RESULTS}/alignments/{{sample}}.bam"

    threads:
        config["threads"]

    shell:
        """
        samtools view -@ {threads} -Sb {input} > {output}
        """

rule sort_bam:
    input:
        f"{RESULTS}/alignments/{{sample}}.bam"

    output:
        f"{RESULTS}/alignments/{{sample}}.sorted.bam"

    threads:
        config["threads"]

    shell:
        """
        samtools sort -@ {threads} \
        -o {output} {input}
        """

rule index_bam:
    input:
        f"{RESULTS}/alignments/{{sample}}.sorted.bam"

    output:
        f"{RESULTS}/alignments/{{sample}}.sorted.bam.bai"

    threads:
        config["threads"]

    shell:
        """
        samtools index -@ {threads} {input}
        """

rule call_variants:
    input:
        ref=config["reference"],
        bam=f"{RESULTS}/alignments/{{sample}}.sorted.bam"

    output:
        f"{RESULTS}/variants/{{sample}}.vcf"

    threads:
        config["threads"]

    shell:
        """
        gatk HaplotypeCaller \
        -R {input.ref} \
        -I {input.bam} \
        -O {output}
        """



rule multiqc:
    input:
        expand(f"{RESULTS}/qc/{{sample}}_{{read}}_fastqc.zip",
               sample=SAMPLES,
               read=READS)

    output:
        html=f"{RESULTS}/multiqc_report.html",
	data_dir=directory(f"{RESULTS}/multiqc_data")

    threads:
        1
    
    log:
       f"{RESULTS}/logs/multiqc.log"

    shell:
        """
        multiqc {RESULTS}/qc/ -o {RESULTS}/
        """
