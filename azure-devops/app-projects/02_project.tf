resource "azuredevops_project" "project" {
  name               = format("%s-projects", var.project_name_prefix)
  description        = format("This is the DevOps project for %s service projects", var.project_name_prefix)
  visibility         = "public"
  version_control    = "Git"
  work_item_template = "Basic"
}

resource "azuredevops_project_features" "project_features" {
  project_id = azuredevops_project.project.id
  features = {
    "pipelines"    = "enabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
  }
}
