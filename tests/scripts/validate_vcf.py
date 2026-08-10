#!/usr/bin/env python3

EXPECTED_VCF = "tests/data/expected/expected.vcf"
OBSERVED_VCF = "tests/results_ci/variants/ci_samples.vcf"


def read_variants(vcf_file):
    variants = set()

    with open(vcf_file) as f:
        for line in f:
            if line.startswith("#"):
                continue

            fields = line.strip().split("\t")

            chrom = fields[0]
            pos = fields[1]
            ref = fields[3]
            alt = fields[4]

            variants.add((chrom, pos, ref, alt))

    return variants


expected = read_variants(EXPECTED_VCF)
observed = read_variants(OBSERVED_VCF)

missing = []

for variant in expected:
    if variant not in observed:
        missing.append(variant)

if len(missing) == 0:
    print("PASS")
    print(f"Recovered {len(expected)}/{len(expected)} expected variants.")
    exit(0)

print("FAIL")

for chrom, pos, ref, alt in missing:
    print(f"Missing: {chrom} {pos} {ref} {alt}")

print(f"Recovered {len(expected) - len(missing)}/{len(expected)} expected variants.")

exit(1)
