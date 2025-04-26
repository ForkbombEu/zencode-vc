---
title: ECDSA (P256) verifiable credentials
---

# {{ $frontmatter.title }}

Conforming to:
- [Verifiable Credentials Data Model v2.0](https://www.w3.org/TR/vc-data-model-2.0/)
- [Verifiable Credential Data Integrity v1.0](https://www.w3.org/TR/vc-data-integrity/)
- [Data Integrity ECDSA Cryptosuites v1.0](https://www.w3.org/TR/vc-di-ecdsa/)

## Generate keys

<<< @/ecdsa_keyring.slang{gherkin}

### Output

💾 ecdsa_keyring

<<< @/ecdsa_keyring.out.json{json}

Results in both private and public keys, which can also be generated in two separate steps and should be stored consciously. The public key may be registered as a DID.

## Prepare for signature

### Input

📃 Example document

<<< @/unsecuredDocument.data.json

💾 ecdsa_keyring

<<< @/ecdsa_keyring.out.json

### Zencode

<<< @/ecdsa_rdf-canon-objects.slang{gherkin}

### Output

💾 ecdsa_rdf-canon-objects

<<< @/ecdsa_rdf-canon-objects.out.json

Results in seralized canonical RDF versions of the document and signature settings ready for signature, conforming to [RDF Dataset Canonicalization](https://www.w3.org/TR/rdf-canon/).

## Sign the credentials

### Input

<<< @/ecdsa_rdf-canon-objects.out.json

<<< @/ecdsa_keyring.out.json

### Zencode

<<< @/ecdsa_hash-and-sign.slang{gherkin}

### 💾 Output

<<< @/ecdsa_hash-and-sign.out.json

## Prepare for verification

### Input

<<< @/ecdsa_prepare-verification-signed-doc.data.json

<<< @/ecdsa_prepare-verification-signed-doc.keys.json

### Zencode

<<< @/ecdsa_prepare-verification-signed-doc.slang{gherkin}

### Output

<<< @/ecdsa_prepare-verification-signed-doc.out.json

Results again in serialized canonical RDF version of the document and signature settings. Public key may be retrieved from DID.

## Verify the signature

### Input

<<< @/ecdsa_verify-prepared-signed-doc.data.json

### Zencode

<<< @/ecdsa_verify-prepared-signed-doc.slang{gherkin}

### Output

SUCCESS or FAILURE
