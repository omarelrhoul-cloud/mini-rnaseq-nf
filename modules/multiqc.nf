process MULTIQC {
    container "community.wave.seqera.io/library/pip_multiqc:a3c26f6199d64b7c"

    input:
    path '*'
    val report_name

    output:
    path "${report_name}.html", emit: report
    path "${report_name}_data", emit: data

    script:
    """
    multiqc . -n ${report_name}.html
    """
}
