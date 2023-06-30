process KAT {
    label 'process_medium'

    conda "bioconda::kat=2.4.2"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/kat:2.4.2--py39h7c5ebd6_3' :
        'quay.io/biocontainers/kat:2.4.2--py39h7c5ebd6_3' }"

    input:
    path(database)
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("filtered.in.R{1,2}.fastq"), emit: filtered_reads

    script:
    """
    kat filter seq -t $task.cpus -i -o filtered --seq ${reads[0]} --seq2 ${reads[1]} $database
    """
}
