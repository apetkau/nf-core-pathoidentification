process KAT {
    label 'process_medium'

    conda "bioconda::kat=2.4.2"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/kat:2.4.2--py39h7c5ebd6_3' :
        'quay.io/biocontainers/kat:2.4.2--py39h7c5ebd6_3' }"

    input:
    path(database)
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("filtered.in.R{1,2}.fastq"), emit: filtered_reads

    script:
    """
    # Kat cannot handle gzipped input so use files
    # to transfer decompressed data
    gzip -dc ${reads[0]} > reads1.fastq
    gzip -dc ${reads[1]} > reads2.fastq

    kat filter seq -t ${task.cpus} -i -o filtered --seq reads1.fastq --seq2 reads2.fastq $database
    """
}
