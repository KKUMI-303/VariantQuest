from Bio import SeqIO

reference = "ecoli.fa"
output = "ecoli_mut.fa"
mutation_file = "mutations.tsv"

records = list(SeqIO.parse(reference, "fasta"))

for record in records:

    if record.id == "NC_002695.2":

        sequence = list(str(record.seq))

        with open(mutation_file) as f:
            for line in f:
                chrom, pos, old, new = line.strip().split()

                pos = int(pos)

                actual = sequence[pos - 1]

                if actual != old:
                    raise ValueError(
                        f"Mismatch at {pos}: expected {old}, found {actual}"
                    )

                sequence[pos - 1] = new

        record.seq = type(record.seq)("".join(sequence))

SeqIO.write(records, output, "fasta")

print(f"Created {output}")
