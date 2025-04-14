setup() {
  load bats/setup
}

@test "Create the keyring" {
      cat << EOF > src/keygen.keys.json
{"zero":"000000"}
EOF
      cat <<EOF > src/keygen.slang
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
      slexe src/keygen
      assert_output '{"eddsa_public_key":"1fd1gXxvsng5gpmf7pBt9sdfG7QKij19dkQHvMLcRkD","keyring":{"ecdh":"kbTRQoI/fSDF8I32kSLeQ/NfBXqYjZYZ9tMThIXJogM=","eddsa":"Aon2riLUAiUz7re5L4DN5KHVXMpi9QG5QQbYKzq7PiF4"}}'
      echo $output > src/keyring.keys.json
}

@test "Create the proofConfig" {
  cat <<EOF > $SRC/proofConfig.slang
Given I have a 'string dictionary' named 'unsecuredDocument'
and I have a 'keyring'

When I create copy of '@context' from 'unsecuredDocument'
and I rename 'copy' to '@context'
and I create the new dictionary named 'proofConfig'
and I move '@context' in 'proofConfig'
and I write string 'DataIntegrityProof' in 'type'
and I move 'type' in 'proofConfig'
and I write string 'eddsa-rdfc-2022' in 'cryptosuite'
and I move 'cryptosuite' in 'proofConfig'

Then print 'proofConfig' as 'string'
EOF
  ln -sf $SRC/unsecuredDocument.data.json $SRC/proofConfig.data.json
  ln -sf $SRC/keyring.keys.json $SRC/proofConfig.keys.json
  slexe $SRC/proofConfig
  assert_output ''
}
