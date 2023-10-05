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