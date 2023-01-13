# resource "aws_nat_gateway" "public-nat-gateway" {
#   allocation_id = aws_eip.main-eip.id
#   subnet_id     = aws_subnet.public.id

#   tags = {
#     "Name" = "public-nat-gateway"
#   }
# }
