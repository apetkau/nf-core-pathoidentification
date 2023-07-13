process BLASTDB {
    conda "bioconda::blast=2.14.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/blast:2.14.0--h7d5a4b4_1' :
        'quay.io/biocontainers/blast:2.14.0--h7d5a4b4_1' }"

    input:
    path(database)

    output:
    tuple val("blast_db"), path("blast_db*"), emit: blast_db

    script:
    """
    makeblastdb -dbtype nucl -parse_seqids -in $database -out blast_db
    """
}
