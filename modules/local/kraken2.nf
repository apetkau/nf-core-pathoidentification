process KRAKEN2 {
    publishDir params.outdir, mode:'copy'
    label 'process_medium'

    conda "bioconda::kraken2=2.1.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/kraken2:2.1.3--pl5321hdcf5f25_0' :
        'quay.io/biocontainers/kraken2:2.1.3--pl5321hdcf5f25_0' }"

    input:
    path database
    tuple val(sample_id), path(reads)

    output:
    path("${sample_id}.kraken-report.txt")
    path("${sample_id}.kraken-out.txt")

    script:
    """
    kraken2 --db $database --threads $task.cpus --paired --output ${sample_id}.kraken-out.txt --report ${sample_id}.kraken-report.txt ${reads[0]} ${reads[1]}
    """
}
