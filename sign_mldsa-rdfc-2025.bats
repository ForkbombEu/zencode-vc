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

# A.1 Representation: mldsa-rdfc-2025, with fips203 (dilithium2)

setup() {
  load bats/setup
  algo=mldsa
}

@test "Create the keyring and document" {
  export contract=${algo}_keyring
  cat <<EOF > $SRC/${contract}.slang
Scenario qp
Given nothing
When I create the mldsa44 key
and I create the mldsa44 public key
Then I print the keyring
and I print the 'mldsa44 public key'
EOF
  slexe $SRC/${contract}
}

@test "Create the rdf-canon objects" {
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
  export contract="${algo}_rdf-canon-objects"
  input data $SRC/unsecuredDocument.data.json
  input keys $SRC/${algo}_keyring.out.json
  cat <<EOF > $SRC/${contract}.slang
rule unknown ignore
Given I have a 'string dictionary' named 'unsecuredDocument'
and I have a 'keyring'
When I create copy of '@context' from 'unsecuredDocument'
and I rename 'copy' to '@context'
and I create the 'string dictionary' named 'proofConfig'
and I move '@context' in 'proofConfig'
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
  slexe $SRC/${contract}
}

@test "Create the signature" {
  export contract=${algo}_hash-and-sign
  input data $SRC/${algo}_rdf-canon-objects.out.json
  input keys $SRC/${algo}_keyring.out.json
  cat <<EOF > $SRC/${contract}.slang
Scenario qp
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

When I create the mldsa44 signature of 'proofConfig hash'

When I rename 'proofConfig' to 'proof'
# multisignature base58 prefix
and I write string 'z' in 'proofValue'
and I append 'base58' of 'mldsa44 signature' to 'proofValue'
and I move 'proofValue' in 'proof'
and I remove '@context' from 'proof'
and I move 'proof' in 'document'

Then print 'document' as 'string'

EOF
  slexe  $SRC/${contract}
  # cat $SRC/${contract}.out.json | >&3 jq .
}
