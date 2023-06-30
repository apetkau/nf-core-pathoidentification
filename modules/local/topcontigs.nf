process TOPCONTIGS {
    label 'process_single'

    publishDir params.outdir, mode:'copy'

    conda "bioconda::seqkit=2.4.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqkit:2.4.0--h9ee0642_0' :
        'quay.io/biocontainers/seqkit:2.4.0--h9ee0642_0' }"

    input:
    path(contigs)

    output:
    path("${contigs}.top.fasta"), emit: top_contigs

    script:
    """
    # This solution with pipes does not work as it returns a non-zero exit code.
    # I suspect that the first "seqkit sort" returns non-zero if the second command exits before
    # it's finished writing output. Solution is to break up steps with intermediate file.
    #seqkit sort --by-length --reverse ${contigs} | seqkit head -n 50 > ${contigs}.top.fasta
    seqkit sort --by-length --reverse ${contigs} > sorted.fasta
    seqkit head -n 50 > ${contigs}.top.fasta < sorted.fasta
    """
}
