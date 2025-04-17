setup() {
  load bats/setup
}

@test "Create the keyring and document" {
      cat << EOF > $SRC/keygen.keys.json
{"zero":"000000"}
EOF
      cat <<EOF > $SRC/keygen.slang
Scenario eddsa
Scenario ecdh
Given I have a 'string' named 'zero'
When I create the hash of 'zero'
When I create the eddsa key with secret 'hash'
When I create the ecdh key with secret 'hash'
and I create the eddsa public key
Then I print the keyring
and I print the 'eddsa public key'
EOF
      slexe $SRC/keygen
      assert_output '{"eddsa_public_key":"1fd1gXxvsng5gpmf7pBt9sdfG7QKij19dkQHvMLcRkD","keyring":{"ecdh":"kbTRQoI/fSDF8I32kSLeQ/NfBXqYjZYZ9tMThIXJogM=","eddsa":"Aon2riLUAiUz7re5L4DN5KHVXMpi9QG5QQbYKzq7PiF4"}}'
      save_output $SRC/keyring.keys.json

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
}

@test "Create the rdf-canon objects" {
  ln -sf $SRC/unsecuredDocument.data.json $SRC/rdf-canon-objects.data.json
  ln -sf $SRC/keyring.keys.json $SRC/rdf-canon-objects.keys.json
  cat <<EOF > $SRC/rdf-canon-objects.slang
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
and I write string 'eddsa-rdfc-2019' in 'cryptosuite'
and I move 'cryptosuite' in 'proofConfig'
and I write string 'assertionMethod' in 'proofPurpose'
and I move 'proofPurpose' in 'proofConfig'
and I write string '2023-02-24T23:36:38Z' in 'created'
and I move 'created' in 'proofConfig'
Then print 'proofConfig' as 'string'
and print 'unsecuredDocument' as 'string'
Compute 'proofConfig rdf-canon': generate serialized canonical rdf with dictionary 'proofConfig'
Compute 'unsecuredDocument rdf-canon': generate serialized canonical rdf with dictionary 'unsecuredDocument'
EOF
  slexe $SRC/rdf-canon-objects
  # reproduce https://w3c.github.io/vc-di-ecdsa/#example-proof-options-document
  save_output $SRC/rdf-canon-objects.out.json
#   output=`cat src/rdf-canon-objects.out.json | jq -r '."proofConfig rdf-canon"' | base64 -d`
#   # Compare with https://w3c.github.io/vc-di-ecdsa/#example-canonical-proof-options-document
#   cat <<EOF > example10.rdf
# _:c14n0 <http://purl.org/dc/terms/created> "2023-02-24T23:36:38Z"^^<http://www.w3.org/2001/XMLSchema#dateTime> .
# _:c14n0 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <https://w3id.org/security#DataIntegrityProof> .
# _:c14n0 <https://w3id.org/security#cryptosuite> "ecdsa-rdfc-2019"^^<https://w3id.org/security#cryptosuiteString> .
# _:c14n0 <https://w3id.org/security#proofPurpose> <https://w3id.org/security#assertionMethod> .
# _:c14n0 <https://w3id.org/security#verificationMethod> <did:key:zDnaepBuvsQ8cpsWrVKw8fbpGpvPeNSjVPTWoq6cRqaYzBKVP#zDnaepBuvsQ8cpsWrVKw8fbpGpvPeNSjVPTWoq6cRqaYzBKVP> .
# EOF
#   echo $output > config-rdf-canon.rdf
#   diff -u config-rdf-canon.rdf example10.rdf
#   assert_output "`cat example10.rdf`"
#   assert_output '_:c14n0 <http://purl.org/dc/terms/created> "2023-02-24T23:36:38Z"^^<http://www.w3.org/2001/XMLSchema#dateTime> .
# _:c14n0 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <https://w3id.org/security#DataIntegrityProof> .
# _:c14n0 <https://w3id.org/security#cryptosuite> "ecdsa-rdfc-2019"^^<https://w3id.org/security#cryptosuiteString> .
# _:c14n0 <https://w3id.org/security#proofPurpose> <https://w3id.org/security#assertionMethod> .
# _:c14n0 <https://w3id.org/security#verificationMethod> <did:key:zDnaepBuvsQ8cpsWrVKw8fbpGpvPeNSjVPTWoq6cRqaYzBKVP#zDnaepBuvsQ8cpsWrVKw8fbpGpvPeNSjVPTWoq6cRqaYzBKVP> .'

}

@test "Create the signature" {
  ln -sf $SRC/rdf-canon-objects.out.json $SRC/hash-and-sign.data.json
  ln -sf $SRC/keyring.keys.json $SRC/hash-and-sign.keys.json
  cat <<EOF > $SRC/hash-and-sign.slang
Given I have a 'base64' named 'unsecuredDocument rdf-canon'
and I have a 'base64' named 'proofConfig rdf-canon'
When I create the hash of 'proofConfig rdf-canon'
and rename 'hash' to 'proofConfig hash'
and I create the hash of 'unsecuredDocument rdf-canon'
and rename 'hash' to 'unsecuredDocument hash'
Then print 'unsecuredDocument hash' as 'hex'
and print 'proofConfig hash' as 'hex'
EOF
  slexe  $SRC/hash-and-sign
  save_output $SRC/hash-and-sign.out.json
  >&3 cat $SRC/hash-and-sign.out.json | jq .
  # assert_output '{"proofConfig_rdf-canon":"_:c14n0 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <https://w3id.org/security#DataIntegrityProof> .\n_:c14n0 <https://w3id.org/security#cryptosuite> \"eddsa-rdfc-2022\"^^<https://w3id.org/security#cryptosuiteString> .\n","unsecuredDocument_rdf-canon":"<did:example:abcdefgh> <https://www.w3.org/ns/credentials/examples#alumniOf> \"The School of Examples\" .\n<urn:uuid:58172aac-d8ba-11ed-83dd-0b3aef56cc33> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <https://www.w3.org/2018/credentials#VerifiableCredential> .\n<urn:uuid:58172aac-d8ba-11ed-83dd-0b3aef56cc33> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <https://www.w3.org/ns/credentials/examples#AlumniCredential> .\n<urn:uuid:58172aac-d8ba-11ed-83dd-0b3aef56cc33> <https://schema.org/description> \"A minimum viable example of an Alumni Credential.\" .\n<urn:uuid:58172aac-d8ba-11ed-83dd-0b3aef56cc33> <https://schema.org/name> \"Alumni Credential\" .\n<urn:uuid:58172aac-d8ba-11ed-83dd-0b3aef56cc33> <https://www.w3.org/2018/credentials#credentialSubject> <did:example:abcdefgh> .\n<urn:uuid:58172aac-d8ba-11ed-83dd-0b3aef56cc33> <https://www.w3.org/2018/credentials#issuer> <https://vc.example/issuers/5678> .\n<urn:uuid:58172aac-d8ba-11ed-83dd-0b3aef56cc33> <https://www.w3.org/2018/credentials#validFrom> \"2023-01-01T00:00:00Z\"^^<http://www.w3.org/2001/XMLSchema#dateTime> .\n"}'
}
