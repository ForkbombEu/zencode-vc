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

# A.1 Representation: ecdsa-rdfc-2019, with curve P-256
# https://w3c.github.io/vc-di-ecdsa/

setup() {
  load bats/setup
}

setup_file() {
  export algo=ecdsa
  rm -f src/${algo}_exec_log.md
}

@test "Create the keyring and document" {
  export contract=${algo}_keyring
  cat <<EOF > $SRC/${contract}.slang
Scenario es256
Given nothing
When I create the es256 key
and I create the es256 public key
Then I print the keyring
and I print the 'es256 public key'
EOF
  slexe $SRC/${contract}
}

@test "Create the rdf-canon objects" {
  export contract=${algo}_rdf-canon-objects
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
  input data $SRC/unsecuredDocument.data.json
  input keys $SRC/${algo}_keyring.out.json
  cat <<EOF > $SRC/${contract}.slang
rule unknown ignore
Given I have a 'string dictionary' named 'unsecuredDocument'
and I have a 'keyring'
When I create the 'string dictionary' named 'proofConfig'
and I copy '@context' from 'unsecuredDocument' in 'proofConfig'
and I write string 'DataIntegrityProof' in 'type'
and I move 'type' in 'proofConfig'
and I write string 'did:key:zDnaepBuvsQ8cpsWrVKw8fbpGpvPeNSjVPTWoq6cRqaYzBKVP#zDnaepBuvsQ8cpsWrVKw8fbpGpvPeNSjVPTWoq6cRqaYzBKVP' in 'verificationMethod'
and I move 'verificationMethod' in 'proofConfig'
and I write string 'ecdsa-rdfc-2019' in 'cryptosuite'
and I move 'cryptosuite' in 'proofConfig'
and I write string 'assertionMethod' in 'proofPurpose'
and I move 'proofPurpose' in 'proofConfig'
and I write string '2023-02-24T23:36:38Z' in 'created'
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
Scenario es256
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

##+ interim check with vectors by w3c vc-di-ecdsa
When I set 'document w3c hash' to '517744132ae165a5349155bef0bb0cf2258fff99dfe1dbd914b938d775a36017' as 'hex'
and I set 'proofConfig w3c hash' to '3a8a522f689025727fb9d1f0fa99a618da023e8494ac74f51015d009d35abc2e' as 'hex'
When I verify 'proofConfig w3c hash' is equal to 'proofConfig hash'
and I verify 'document w3c hash' is equal to 'document hash'
##-

When I append 'document hash' to 'proofConfig hash'

##+ interim check with vectors by w3c vc-di-ecdsa
and I set 'Combined Hashes' to '3a8a522f689025727fb9d1f0fa99a618da023e8494ac74f51015d009d35abc2e517744132ae165a5349155bef0bb0cf2258fff99dfe1dbd914b938d775a36017' as 'hex'
and I verify 'Combined Hashes' is equal to 'proofConfig hash'
##-

When I create the es256 signature of 'proofConfig hash'

When I rename 'proofConfig' to 'proof'
# multisignature base58 prefix
and I write string 'z' in 'proofValue'
and I append 'base58' of 'es256 signature' to 'proofValue'
and I move 'proofValue' in 'proof'
and I remove '@context' from 'proof'
and I move 'proof' in 'document'

Then print 'document' as 'string'

EOF
  slexe  $SRC/${contract}
  # cat $SRC/${contract}.out.json | >&3 jq .
}


@test "Prepare the document signature verification" {
  export contract=${algo}_prepare-verification-signed-doc
  input data $SRC/${algo}_hash-and-sign.out.json
  input keys $SRC/${algo}_keyring.out.json
  cat <<EOF > $SRC/${contract}.slang
rule output encoding base64
Scenario es256
Given I have a 'keyring'
and I have a 'dictionary' named 'document'
and I have a 'base58' part of path 'document.proof.proofValue' after string prefix 'z'
and I have a 'dictionary' in path 'document.proof'

When I rename 'proofValue' to 'es256 signature'
and I remove 'proofValue' from 'proof'
and I remove 'proof' from 'document'
and I copy '@context' from 'document' in 'proof'
and I create the es256 public key

Then print the 'es256 signature' as 'base64'
and print the 'proof'
and print the 'document'
and print the 'es256 public key'

Compute 'proof rdf-canon': generate serialized canonical rdf with dictionary 'proof'
Compute 'document rdf-canon': generate serialized canonical rdf with dictionary 'document'
EOF
  slexe $SRC/${contract}
#  cat $TMP/out | >&3 jq .
}

@test "Verify the signature" {
  export contract=${algo}_verify-prepared-signed-doc
  input data $SRC/${algo}_prepare-verification-signed-doc.out.json
  input keys /dev/null
  cat <<EOF > ${SRC}/${contract}.slang
Scenario es256
Given I have a 'base64' named 'document rdf-canon'
and I have a 'base64' named 'proof rdf-canon'
and I have a 'es256 public key'
and I have a 'es256 signature'

When I create the hash of 'proof rdf-canon'
and rename 'hash' to 'proof hash'
and I create the hash of 'document rdf-canon'
and rename 'hash' to 'document hash'
and I append 'document hash' to 'proof hash'

When I verify 'proof hash' has a es256 signature in 'es256 signature' by 'es256 public key'

Then print the string 'VALID DOC PROOF'
EOF
  slexe ${SRC}/${contract}
  cat $TMP/out | >&3 jq .

}
