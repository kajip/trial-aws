/** 変数定義 */

variable "pipeline_name" {
  description = "CodePipelineの名前"
}

variable "build_project_name" {
  description = "CodeBuildのプロジェクト名"
}


variable "build_timeout" {
  description = "Buildタイムアウト"
  default = "10"
}


variable "source_artifacts" {
  description = "ソースの格納場所"
  default = "source"
}

variable "distribution_artifacts" {
  description = "生成物の格納場所"
  default = "distribution"
}
