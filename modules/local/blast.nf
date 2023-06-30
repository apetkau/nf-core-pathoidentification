process BLAST {
    label 'process_single'

    publishDir params.outdir, mode:'copy'

    conda "bioconda::blast=2.14.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/blast:2.14.0--h7d5a4b4_1' :
        'quay.io/biocontainers/blast:2.14.0--h7d5a4b4_1' }"

    input:
    tuple val(db_prefix), path(database)
    path(contigs)

    output:
    path("blast_results.html"), emit: blast_html
    path("blast_results.tsv"), emit: blast_tsv

    script:
    """
    blastn -db ${db_prefix} -query $contigs -html -out blast_results.html &&
    blastn -db ${db_prefix} -query $contigs -outfmt '7 qseqid length slen pident sseqid stitle' -out blast_results.tsv
    """
}
