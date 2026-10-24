process TRIM_GALORE {
    tag "${sample}"
    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"

    input:
    tuple val(sample), path(read1), path(read2)

    output:
    tuple val(sample), path("${sample}_val_1.fq.gz"), path("${sample}_val_2.fq.gz"), emit: reads
    path "*_trimming_report.txt", emit: reports
    path "*_fastqc.{zip,html}", emit: fastqc

    script:
    """
    trim_galore --paired --fastqc --basename ${sample} ${read1} ${read2}
    """
}
