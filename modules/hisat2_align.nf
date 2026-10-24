process HISAT2_ALIGN {
    tag "${sample}"
    container "community.wave.seqera.io/library/hisat2_samtools:5e49f68a37dc010e"

    input:
    tuple val(sample), path(read1), path(read2)
    path index

    output:
    path "${sample}.bam", emit: bam
    path "${sample}.hisat2.log", emit: log

    script:
    """
    hisat2 -x ${index}/genome -1 ${read1} -2 ${read2} \
        --new-summary --summary-file ${sample}.hisat2.log | \
        samtools view -bS -o ${sample}.bam
    """
}
