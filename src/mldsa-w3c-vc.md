---
title: Post Quantum verifiable credentials
---

# {{ $frontmatter.title }}

Conforming to:
- [Module-Lattice-Based Digital Signature Standard (FIPS 204)](https://csrc.nist.gov/pubs/fips/204/final)
- [Verifiable Credentials Data Model v2.0](https://www.w3.org/TR/vc-data-model-2.0/)
- [Verifiable Credential Data Integrity v1.0](https://www.w3.org/TR/vc-data-integrity/)
- [Quantum-Safe Cryptosuites v0.3](https://w3c-ccg.github.io/di-quantum-safe/)

## Generate keys

<<< @/mldsa_keyring.slang{gherkin}

### Output

💾 mldsa_keyring

<<< @/mldsa_keyring.out.json{json}

Results in both private and public keys, which can also be generated in two separate steps and should be stored consciously. The public key may be registered as a DID.

## Prepare for signature

### Input

📃 Example document

<<< @/unsecuredDocument.data.json

💾 mldsa_keyring

<<< @/mldsa_keyring.out.json

### Zencode

<<< @/mldsa_rdf-canon-objects.slang{gherkin}

### Output

💾 mldsa_rdf-canon-objects

<<< @/mldsa_rdf-canon-objects.out.json

Results in seralized canonical RDF versions of the document and signature settings ready for signature, conforming to [RDF Dataset Canonicalization](https://www.w3.org/TR/rdf-canon/).

## Sign the credentials

### Input

<<< @/mldsa_rdf-canon-objects.out.json

<<< @/mldsa_keyring.out.json

### Zencode

<<< @/mldsa_hash-and-sign.slang{gherkin}

### 💾 Output

<<< @/mldsa_hash-and-sign.out.json

## Prepare for verification

### Input

<<< @/mldsa_prepare-verification-signed-doc.data.json

<<< @/mldsa_prepare-verification-signed-doc.keys.json

### Zencode

<<< @/mldsa_prepare-verification-signed-doc.slang{gherkin}

### Output

<<< @/mldsa_prepare-verification-signed-doc.out.json

Results again in serialized canonical RDF version of the document and signature settings. Public key may be retrieved from DID.

## Verify the signature

### Input

<<< @/mldsa_verify-prepared-signed-doc.data.json

### Zencode

<<< @/mldsa_verify-prepared-signed-doc.slang{gherkin}

### Output

SUCCESS or FAILURE
