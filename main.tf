# Define o provedor Google Cloud
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

# Configura as credenciais e o projeto usando a variável
provider "google" {
  project = var.gcp_project_id
}

# Define a rede e a sub-rede para a VM
resource "google_compute_network" "default" {
  name = "default-network"
  auto_create_subnetworks = true
}

# Cria a instância da máquina virtual
resource "google_compute_instance" "vm_gratuita_linux" {
  # Nomes usando variáveis
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.instance_zone

  # Adiciona a tag para a regra de firewall
  tags = ["allow-ports"]

  # Configuração do boot disk usando variável
  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 30  # Define o tamanho do disco em GB
    }
  }

  # Configuração de acesso à rede
  network_interface {
    network = google_compute_network.default.self_link
    access_config {
      // Deixa a configuração vazia para obter um IP externo
    }
  }

  # Metadados para habilitar SSH e para a instalação do Docker
  metadata = {
    ssh-keys       = var.ssh_public_key
  }
  metadata_startup_script = file("${path.module}/install-docker.sh")
}

# Exibe o IP externo da VM após a criação
output "vm_ip_externo" {
  value = google_compute_instance.vm_gratuita_linux.network_interface[0].access_config[0].nat_ip
}

# Cria a regra de firewall para liberar a porta 22
resource "google_compute_firewall" "allow_ssh_specific_ip" {
  name    = "allow-ports-ssh"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-ports"]
}