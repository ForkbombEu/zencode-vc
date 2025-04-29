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

# B.1 Representation: eddsa-rdfc-2022
# https://w3c.github.io/vc-di-eddsa

setup() {
  load bats/setup
}

setup_file() {
  export algo=eddsa
  rm -f src/${algo}_exec_log.md
}

@test "Create the keyring and document" {
  export contract=${algo}_keyring
cat <<EOF > $SRC/eddsa_keyring.keys.json
{ "w3c test key": "c96ef9ea10c5e414c471723aff9de72c35fa5b70fae97e8832ecac7d2e2b8ed6" }
EOF
      cat <<EOF > $SRC/eddsa_keyring.slang
Scenario eddsa
Given I have a 'hex' named 'w3c test key'
When I create the eddsa key with secret 'w3c test key'
and I create the eddsa public key
Then I print the keyring
and I print the 'eddsa public key'
EOF
      slexe $SRC/eddsa_keyring
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
  export contract=${algo}_rdf-canon-objects
  input data $SRC/unsecuredDocument.data.json
  input keys $SRC/${algo}_keyring.out.json
  cat <<EOF > $SRC/${algo}_rdf-canon-objects.slang
rule unknown ignore
Given I have a 'string dictionary' named 'unsecuredDocument'
and I have a 'keyring'
When I create the 'string dictionary' named 'proofConfig'
and I copy '@context' from 'unsecuredDocument' in 'proofConfig'
and I write string 'DataIntegrityProof' in 'type'
and I move 'type' in 'proofConfig'
and I write string 'did:key:z6MkrJVnaZkeFzdQyMZu1cgjg7k1pZZ6pvBQ7XJPt4swbTQ2#z6MkrJVnaZkeFzdQyMZu1cgjg7k1pZZ6pvBQ7XJPt4swbTQ2' in 'verificationMethod'
and I move 'verificationMethod' in 'proofConfig'
and I write string 'eddsa-rdfc-2022' in 'cryptosuite'
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
  slexe $SRC/${algo}_rdf-canon-objects
}

@test "Create the signature" {
  export contract=${algo}_hash-and-sign
  input data $SRC/${algo}_rdf-canon-objects.out.json
  input keys $SRC/${algo}_keyring.out.json
  cat <<EOF > $SRC/${algo}_hash-and-sign.slang
Scenario eddsa
Given I have a 'keyring'
Given I have a 'base64' named 'document rdf-canon'
and I have a 'base64' named 'proofConfig rdf-canon'
and I have a 'string dictionary' named 'proofConfig'
and I have a 'string dictionary' named 'document'
#and I have a 'hex' named 'proofConfig w3c hash'
#and I have a 'hex' named 'document w3c hash'
When I create the hash of 'proofConfig rdf-canon'
and rename 'hash' to 'proofConfig hash'
and I create the hash of 'document rdf-canon'
and rename 'hash' to 'document hash'

##+ interim check with vectors by w3c vc-di-ecdsa
When I set 'document w3c hash' to '517744132ae165a5349155bef0bb0cf2258fff99dfe1dbd914b938d775a36017' as 'hex'
and I set 'proofConfig w3c hash' to 'bea7b7acfbad0126b135104024a5f1733e705108f42d59668b05c0c50004c6b0' as 'hex'
When I verify 'proofConfig w3c hash' is equal to 'proofConfig hash'
and I verify 'document w3c hash' is equal to 'document hash'
##-

When I append 'document hash' to 'proofConfig hash'

##+ interim check with vectors by w3c vc-di-ecdsa
and I set 'Combined Hashes' to 'bea7b7acfbad0126b135104024a5f1733e705108f42d59668b05c0c50004c6b0517744132ae165a5349155bef0bb0cf2258fff99dfe1dbd914b938d775a36017' as 'hex'
and I verify 'Combined Hashes' is equal to 'proofConfig hash'
##-

When I create the eddsa signature of 'proofConfig hash'

##+ interim check with vectors by w3c vc-di-eddsa
and I set 'sigcheck' to '2YwC8z3ap7yx1nZYCg4L3j3ApHsF8kgPdSb5xoS1VR7vPG3F561B52hYnQF9iseabecm3ijx4K1FBTQsCZahKZme' as 'base58'
and I verify 'eddsa signature' is equal to 'sigcheck'
##-

When I rename 'proofConfig' to 'proof'
and I create 'base58' string of 'eddsa signature'
and I rename 'base58' to 'proofValue'
# multisignature base58 prefix
and I prepend string 'z' to 'proofValue'
and I move 'proofValue' in 'proof'
and I remove '@context' from 'proof'
and I move 'proof' in 'document'

Then print 'document' as 'string'
EOF
  slexe  $SRC/${algo}_hash-and-sign
}


@test "Prepare the document signature verification" {
  export contract=${algo}_prepare-verification-signed-doc
  input data $SRC/${algo}_hash-and-sign.out.json
  input keys $SRC/${algo}_keyring.out.json
  cat <<EOF > $SRC/${contract}.slang
Scenario eddsa
Given I have a 'keyring'
and I have a 'dictionary' named 'document'
and I have a 'eddsa signature' part of path 'document.proof.proofValue' after string prefix 'z'
and I have a 'dictionary' in path 'document.proof'

When I rename 'proofValue' to 'eddsa signature'
and I remove 'proofValue' from 'proof'
and I remove 'proof' from 'document'
and I copy '@context' from 'document' in 'proof'
and I create the eddsa public key

Then print the 'eddsa signature'
and print the 'proof'
and print the 'document'
and print the 'eddsa public key'

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
Scenario eddsa
Given I have a 'base64' named 'document rdf-canon'
and I have a 'base64' named 'proof rdf-canon'
and I have a 'eddsa public key'
and I have a 'eddsa signature'

When I create the hash of 'proof rdf-canon'
and rename 'hash' to 'proof hash'
and I create the hash of 'document rdf-canon'
and rename 'hash' to 'document hash'
and I append 'document hash' to 'proof hash'

When I verify 'proof hash' has a eddsa signature in 'eddsa signature' by 'eddsa public key'

Then print the string 'VALID DOC PROOF'
EOF
  slexe ${SRC}/${contract}
  cat $TMP/out | >&3 jq .

}
