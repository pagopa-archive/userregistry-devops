resource "azuredevops_project" "project" {
  name               = format("%s-iac-projects", var.project_name_prefix)
  description        = format("This is the DevOps project for all %s IaC pipeline", var.project_name_prefix)
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Basic"
}

resource "azuredevops_project_features" "project-features" {
  project_id = azuredevops_project.project.id
  features = {
    "pipelines"    = "enabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
  }
}
