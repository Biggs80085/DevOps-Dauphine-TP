terraform {
    backend "gcs" {
        bucket = "tp-cc-tfstate"
    }
}