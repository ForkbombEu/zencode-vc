# A.1 Representation: ecdsa-rdfc-2019, with curve P-256
# https://w3c.github.io/vc-di-ecdsa/

setup() {
  load bats/setup
}

@test "Create the keyring and document" {
  export contract=ecdsa_keyring
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
  export contract="ecdsa_rdf-canon-objects"
  prepare data $SRC/unsecuredDocument.data.json
  prepare keys $SRC/ecdsa_keyring.out.json
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
  export contract="ecdsa_hash-and-sign"
  prepare data $SRC/ecdsa_rdf-canon-objects.out.json
  prepare keys $SRC/ecdsa_keyring.out.json
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
