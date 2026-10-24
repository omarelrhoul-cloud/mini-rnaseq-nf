process FASTQC {
    tag "${sample}"
    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"

    input:
    tuple val(sample), path(read1), path(read2)

    output:
    path "*_fastqc.{zip,html}", emit: reports

    script:
    """
    fastqc ${read1} ${read2}
    """
}
