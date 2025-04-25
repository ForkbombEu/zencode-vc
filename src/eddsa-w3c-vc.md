---
title: EDDSA (ed25519) verifiable credentials
---

# {{ $frontmatter.title }}

## Generate keys

<<< @/eddsa_keyring.slang{gherkin}

### Output

💾 eddsa_keyring

<<< @/eddsa_keyring.out.json{json}

## Prepare for signature

### Input

📃 Example document

<<< @/unsecuredDocument.data.json

💾 eddsa_keyring

<<< @/eddsa_keyring.out.json

### Zencode

<<< @/eddsa_rdf-canon-objects.slang{gherkin}

### Output

💾 eddsa_rdf-canon-objects

<<< @/eddsa_rdf-canon-objects.out.json

## Sign the credentials

### Input

<<< @/eddsa_rdf-canon-objects.out.json

<<< @/eddsa_keyring.out.json

### Zencode

<<< @/eddsa_hash-and-sign.slang{gherkin}

### 💾 Output

<<< @/eddsa_hash-and-sign.out.json

## Prepare for verification

### Input

<<< @/eddsa_prepare-verification-signed-doc.data.json

<<< @/eddsa_prepare-verification-signed-doc.keys.json

### Zencode

<<< @/eddsa_prepare-verification-signed-doc.slang{gherkin}

### Output

<<< @/eddsa_prepare-verification-signed-doc.out.json

## Verify the signature

### Input

<<< @/eddsa_verify-prepared-signed-doc.data.json

### Zencode

<<< @/eddsa_verify-prepared-signed-doc.slang{gherkin}

### Output

SUCCESS or FAILURE
