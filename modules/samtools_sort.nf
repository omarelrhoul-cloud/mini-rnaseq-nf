process SAMTOOLS_SORT {
    tag "${bam.baseName}"
    container "community.wave.seqera.io/library/hisat2_samtools:5e49f68a37dc010e"

    input:
    path bam

    output:
    path "${bam.baseName}.sorted.bam", emit: bam
    path "${bam.baseName}.sorted.bam.bai", emit: bai
    path "${bam.baseName}.flagstat.txt", emit: flagstat

    script:
    """
    samtools sort -o ${bam.baseName}.sorted.bam ${bam}
    samtools index ${bam.baseName}.sorted.bam
    samtools flagstat ${bam.baseName}.sorted.bam > ${bam.baseName}.flagstat.txt
    """
}
