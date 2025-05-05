setup() {
  load bats/setup
}

@test "slangroom-exec exists and is executable" {
  run which slangroom-exec
  assert_success
  run which slexfe
  assert_success
}

@test "Test generic template hello world" {
  export contract=hello
  slexe test/$contract
  assert_output --partial 'Welcome_to_slangroom-exec_🥳'
}

@test "Test generic template timestamp" {
  export contract=timestamp
  slexe test/$contract
  assert_output --partial 'timestamp'
}

@test "Test generic template file read" {
  export contract=fileread
  slexe test/$contract
  assert_output --partial 'Welcome to slangroom-exec 🥳'
}
