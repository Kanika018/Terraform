
output "testprivate" {
  value = aws_subnet.testprivate.id
}

output "testpublic" {
  value = aws_subnet.testpublic.id
}

output "test" {
  value       = aws_key_pair.test
}
