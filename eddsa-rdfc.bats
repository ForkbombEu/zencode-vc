# Copyright (C) 2025 Dyne.org Foundation
#
# Designed, written and maintained by Denis Roio <jaromil@dyne.org>
#
# This source code is free software; you can redistribute it and/or
# modify it under the terms of the GNU Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This source code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	Please refer
# to the GNU Public License for more details.
#
# You should have received a copy of the GNU Public License along with
# this source code; if not, , see <https://www.gnu.org/licenses/>.

function setup() {
  load bats/setup
  export contract=${step}_${algo}

}

function setup_file() {
  export algo=eddsa
  rm -f src/${algo}_exec_log.md
}

@test "Create the keyring and document" {
  export step=1_keyring
  cat <<EOF | slang
Scenario eddsa
Given nothing
When I create the eddsa key
and I create the eddsa public key
Then I print the keyring
and I print the 'eddsa public key'
EOF
  slexe
  describe out keyring
}

@test "Create the rdf-canon objects" {
  export step=2_rdfcanon
  cat <<EOF > $SRC/unsecuredDocument.data.json
{
  "unsecuredDocument": {
    "@context": [
      "https://www.w3.org/ns/credentials/v2",
      "https://www.w3.org/ns/credentials/examples/v2"
    ],
    "id": "urn:uuid:58172aac-d8ba-11ed-83dd-0b3aef56cc33",
    "type": ["VerifiableCredential", "AlumniCredential"],
    "name": "Alumni Credential",
    "description": "A minimum viable example of an Alumni Credential.",
    "issuer": "https://vc.example/issuers/5678",
    "validFrom": "2023-01-01T00:00:00Z",
    "credentialSubject": {
      "id": "did:example:abcdefgh",
      "alumniOf": "The School of Examples"
    }
  }
}
EOF
#  export contract="${algo}_rdf-canon-objects"
  input data $SRC/unsecuredDocument.data.json
  input keys $SRC/1_keyring_${algo}.out.json
  describe data unsecuredDocument
  describe keys eddsa_public_key
  cat <<EOF | slang
rule unknown ignore
Given I have a 'string dictionary' named 'unsecuredDocument'
and I have a 'keyring'
When I create the 'string dictionary' named 'proofConfig'
and I copy '@context' from 'unsecuredDocument' in 'proofConfig'
and I write string 'DataIntegrityProof' in 'type'
and I move 'type' in 'proofConfig'
and I write string 'did:dyne:b4dc0ff3' in 'verificationMethod'
and I move 'verificationMethod' in 'proofConfig'
and I write string 'mldsa-rdfc-2025' in 'cryptosuite'
and I move 'cryptosuite' in 'proofConfig'
and I write string 'assertionMethod' in 'proofPurpose'
and I move 'proofPurpose' in 'proofConfig'
and I write string '2025-04-25T09:07:09Z' in 'created'
and I move 'created' in 'proofConfig'
and I rename 'unsecuredDocument' to 'document'
Then print 'proofConfig' as 'string'
and print 'document' as 'string'
Compute 'proofConfig rdf-canon': generate serialized canonical rdf with dictionary 'proofConfig'
Compute 'document rdf-canon': generate serialized canonical rdf with dictionary 'document'
EOF
  slexe
  describe out proofConfig_rdf-canon document_rdf-canon
}

@test "Create the signature" {
  export step=3_sign
  input data $SRC/2_rdfcanon_${algo}.out.json
  input keys $SRC/1_keyring_${algo}.out.json
  describe data proofConfig_rdf-canon document_rdf-canon
  describe keys keyring
  cat <<EOF | slang
Scenario eddsa
Given I have a 'keyring'
and I have a 'string dictionary' named 'proofConfig'
and I have a 'string dictionary' named 'document'
Given I have a 'base64' named 'document rdf-canon'
and I have a 'base64' named 'proofConfig rdf-canon'
#and I have a 'hex' named 'proofConfig w3c hash'
#and I have a 'hex' named 'document w3c hash'
When I create the hash of 'proofConfig rdf-canon'
and rename 'hash' to 'proofConfig hash'
and I create the hash of 'document rdf-canon'
and rename 'hash' to 'document hash'

When I append 'document hash' to 'proofConfig hash'

When I create the eddsa signature of 'proofConfig hash'

When I rename 'proofConfig' to 'proof'
# multisignature base58 prefix
and I write string 'z' in 'proofValue'
and I append 'base58' of 'eddsa signature' to 'proofValue'
and I move 'proofValue' in 'proof'
and I remove '@context' from 'proof'
and I move 'proof' in 'document'

Then print 'document' as 'string'

EOF
  slexe
  describe out document
  # cat $SRC/${contract}.out.json | >&3 jq .
}


@test "Prepare the document signature verification" {
  export step=4_preverif
  input data $SRC/3_sign_${algo}.out.json
  input keys $SRC/1_keyring_${algo}.out.json
  describe data document
  describe keys eddsa_public_key
  cat <<EOF | slang
rule output encoding base64
Scenario eddsa
Given I have a 'keyring'
and I have a 'dictionary' named 'document'
and I have a 'base58' part of path 'document.proof.proofValue' after string prefix 'z'
and I have a 'dictionary' in path 'document.proof'

When I rename 'proofValue' to 'eddsa signature'
and I remove 'proofValue' from 'proof'
and I remove 'proof' from 'document'
and I copy '@context' from 'document' in 'proof'
and I create the eddsa public key

Then print the 'eddsa signature' as 'base64'
and print the 'proof'
and print the 'document'
and print the 'eddsa public key'

Compute 'proof rdf-canon': generate serialized canonical rdf with dictionary 'proof'
Compute 'document rdf-canon': generate serialized canonical rdf with dictionary 'document'
EOF
  slexe
  describe out proof_rdf-canon document_rdf-canon
#  cat $TMP/out | >&3 jq .
}

@test "Verify the signature" {
  export step=5_verify
  input data $SRC/4_preverif_${algo}.out.json
  input keys /dev/null
  describe data proof_rdf-canon document_rdf-canon eddsa_public_key
  cat <<EOF | slang
Scenario eddsa
Given I have a 'base64' named 'document rdf-canon'
and I have a 'base64' named 'proof rdf-canon'
and I have a 'eddsa public key'
and I have a 'base64' named 'eddsa signature'

When I create the hash of 'proof rdf-canon'
and rename 'hash' to 'proof hash'
and I create the hash of 'document rdf-canon'
and rename 'hash' to 'document hash'
and I append 'document hash' to 'proof hash'

When I verify 'proof hash' has a eddsa signature in 'eddsa signature' by 'eddsa public key'

Then print the string 'VALID DOC PROOF'
EOF
  slexe
  describe out output
  cat $TMP/out | >&3 jq .
}
