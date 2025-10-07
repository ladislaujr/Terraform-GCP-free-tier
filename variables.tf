# Variável para o ID do projeto no GCP
variable "gcp_project_id" {
  description = "O ID do projeto do Google Cloud."
  type        = string
  default     = "Default"
}

# Variável para o nome da VM
variable "instance_name" {
  description = "O nome da instância da máquina virtual."
  type        = string
  default     = "Default"
}

# Variável para o tipo de máquina (mantido como e2-micro para o nível gratuito)
variable "instance_type" {
  description = "O tipo de máquina da instância."
  type        = string
  default     = "e2-micro"
}

# Variável para a zona (mantido como us-central1-a para o nível gratuito)
variable "instance_zone" {
  description = "A zona onde a instância será criada."
  type        = string
  default     = "us-central1-a"
}

# Variável para a imagem do sistema operacional
variable "instance_image" {
  description = "A imagem do SO para o boot disk da instância."
  type        = string
  default     = "debian-cloud/debian-11"
}

# Variável para a sua chave SSH
variable "ssh_public_key" {
  description = "Sua chave pública SSH para acessar a instância. Formato: 'user:ssh-rsa AAAA...'"
  type        = string
  sensitive   = true # Marca a variável como sensível para não ser mostrada nos logs
}