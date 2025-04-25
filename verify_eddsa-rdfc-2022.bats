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
  algo=eddsa
}

@test "Prepare the document signature verification" {
  export contract=${algo}_prepare-verification-signed-doc
  prepare data $SRC/${algo}_hash-and-sign.out.json
  prepare keys $SRC/${algo}_keyring.out.json
  cat <<EOF > $SRC/${contract}.slang
Scenario eddsa
Given I have a 'keyring'
and I have a 'dictionary' named 'document'
and I have a 'eddsa signature' part of path 'document.proof.proofValue' after string prefix 'z'
and I have a 'dictionary' in path 'document.proof'

When I rename 'proofValue' to 'eddsa signature'
and I remove 'proofValue' from 'proof'
and I remove 'proof' from 'document'
and I create copy of '@context' from 'document'
and I rename 'copy' to '@context'
and I move '@context' in 'proof'
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
  prepare data $SRC/${algo}_prepare-verification-signed-doc.out.json
  prepare keys /dev/null
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
