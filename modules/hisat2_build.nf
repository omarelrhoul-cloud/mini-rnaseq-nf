process HISAT2_BUILD {
    container "community.wave.seqera.io/library/hisat2_samtools:5e49f68a37dc010e"

    input:
    path fasta

    output:
    path "index", emit: index

    script:
    """
    mkdir index
    hisat2-build ${fasta} index/genome
    """
}
