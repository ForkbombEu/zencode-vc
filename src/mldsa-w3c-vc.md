---
title: Post Quantum verifiable credentials
---

# {{ $frontmatter.title }}

## Generate keys

<<< @/mldsa_keyring.slang{gherkin}

### Output

💾 mldsa_keyring

<<< @/mldsa_keyring.out.json{json}

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

## Verify the signature

### Input

<<< @/mldsa_verify-prepared-signed-doc.data.json

### Zencode

<<< @/mldsa_verify-prepared-signed-doc.slang{gherkin}

### Output

SUCCESS or FAILURE
