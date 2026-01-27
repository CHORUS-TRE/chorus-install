terraform {
  cloud {
    organization = "CHORUS-TRE"
    workspaces {
      project = "chorus-install"
      tags    = ["stage_02"]
    }
  }
}