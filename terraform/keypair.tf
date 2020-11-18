resource "aws_key_pair" "keypair" {
  key_name   = data.terraform_remote_state._42.outputs.keypair_name
  public_key = file("~/.ssh/id_rsa.pub")
}
output "key_name" { value = aws_key_pair.keypair.key_name }

