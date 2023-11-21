output "vpc_id_output" {
        value = aws_vpc.terra_vpc.id
}

output "subnet_id_output" {
        value = aws_subnet.terra_pub[*].id
}

output "vpc_default_rtb_id_output" {
        value = aws_vpc.terra_vpc.default_route_table_id
}