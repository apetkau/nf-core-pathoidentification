process QUAST {
    label 'process_single'

    publishDir params.outdir, mode:'copy'

    conda "bioconda::quast=5.2.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/quast:5.2.0--py310pl5321h6cc9453_3' :
        'quay.io/biocontainers/quast:5.2.0--py310pl5321h6cc9453_3' }"

    input:
    path(contigs)

    output:
    path("quast_results"), emit: quast_results

    script:
    """
    quast -t $task.cpus $contigs
    """
}
