---
title: ECDSA (P256) verifiable credentials
---

# {{ $frontmatter.title }}

## Generate keys

<<< @/ecdsa_keyring.slang{gherkin}

### Output

💾 ecdsa_keyring

<<< @/ecdsa_keyring.out.json{json}

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

## Verify the signature

### Input

<<< @/ecdsa_verify-prepared-signed-doc.data.json

### Zencode

<<< @/ecdsa_verify-prepared-signed-doc.slang{gherkin}

### Output

SUCCESS or FAILURE
