terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~> 4.10"
        }
    }
}

resource "google_project_service" "api-cloudresourcemanager" {
    service ="cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "api-serviceusage" {
    service ="serviceusage.googleapis.com"
}

resource "google_project_service" "api-artifactregistry" {
    service ="artifactregistry.googleapis.com"
}

resource "google_project_service" "api-sqladmin" {
    service ="sqladmin.googleapis.com"
}

resource "google_project_service" "api-cloudbuild" {
    service ="cloudbuild.googleapis.com"
}

resource "google_project_service" "api-cloudrun" {
    service ="run.googleapis.com"
}

resource "google_artifact_registry_repository" "artifact" {
    repository_id = "website-tools"
    location = "us-west2"
    description = "TP CC devops"
    format = "DOCKER"
}

resource "google_sql_user" "wordpress" {
   name     = "wordpress"
   instance = "main-instance"
   password = "ilovedevops"
}

resource "google_cloud_run_service" "default" {
name     = "serveur-wordpress"
location = "us-west2"

template {
   spec {
      containers {
      image = "us-west2-docker.pkg.dev/devops-399708/website-tools/wordpress-image"
      ports {
        container_port = 80
      }
      }
   }

   metadata {
      annotations = {
            "run.googleapis.com/cloudsql-instances" = "devops-399708:us-west2:main-instance"
      }
   }
}

traffic {
   percent         = 100
   latest_revision = true
}
}

data "google_iam_policy" "noauth" {
   binding {
      role = "roles/run.invoker"
      members = [
         "allUsers",
      ]
   }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
   location    = google_cloud_run_service.default.location
   project     = google_cloud_run_service.default.project
   service     = google_cloud_run_service.default.name

   policy_data = data.google_iam_policy.noauth.policy_data
}