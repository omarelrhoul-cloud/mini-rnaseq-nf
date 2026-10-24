#!/usr/bin/env nextflow

/*
 * mini-rnaseq-nf : QC -> trimming -> alignement HISAT2 -> MultiQC
 */

include { FASTQC }       from './modules/fastqc.nf'
include { TRIM_GALORE }  from './modules/trim_galore.nf'
include { HISAT2_BUILD } from './modules/hisat2_build.nf'
include { HISAT2_ALIGN } from './modules/hisat2_align.nf'
include { MULTIQC }      from './modules/multiqc.nf'

params {
    input: Path
    fasta: Path
    report_name: String = 'mini_rnaseq'
}

workflow {

    main:
    // 1. Lire la samplesheet : 1 boîte [nom, fastq_1, fastq_2] par échantillon
    reads_ch = channel.fromPath(params.input)
        .splitCsv(header: true)
        .map { row -> tuple(row.sample, file(row.fastq_1), file(row.fastq_2)) }

    // 2. Contrôle qualité et nettoyage
    FASTQC(reads_ch)
    TRIM_GALORE(reads_ch)

    // 3. Index du génome (1 fois), puis alignement (1 fois par échantillon)
    HISAT2_BUILD(file(params.fasta))
    HISAT2_ALIGN(TRIM_GALORE.out.reads, HISAT2_BUILD.out.index)

    // 4. Rapport final
    multiqc_ch = channel.empty().mix(
        FASTQC.out.reports,
        TRIM_GALORE.out.reports,
        TRIM_GALORE.out.fastqc,
        HISAT2_ALIGN.out.log,
    )
    MULTIQC(multiqc_ch.collect(), params.report_name)

    publish:
    fastqc         = FASTQC.out.reports
    trim_reports   = TRIM_GALORE.out.reports
    bam            = HISAT2_ALIGN.out.bam
    align_log      = HISAT2_ALIGN.out.log
    multiqc_report = MULTIQC.out.report
    multiqc_data   = MULTIQC.out.data
}

output {
    fastqc         { path 'fastqc' }
    trim_reports   { path 'trimming' }
    bam            { path 'align' }
    align_log      { path 'align' }
    multiqc_report { path 'multiqc' }
    multiqc_data   { path 'multiqc' }
}
