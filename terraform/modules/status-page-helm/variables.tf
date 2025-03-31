variable "rds_endpoint" {
  description = "the rds endpoint"
  type        = string

}
variable "db_name" {
  description = "the db name"
  type        = string
}
variable "db_user" {
  description = "the db user"
  type        = string
}
variable "rds_password" {
  description = "the rds password"
  type        = string
}
variable "superuser_name" {
  description = "the superuser name"
  type        = string
}
variable "superuser_password" {
  description = "the superuser password"
  type        = string
}
variable "superuser_email" {
  description = "the superuser email"
  type        = string
}
variable "secret_key" {
  description = "the secret key"
  type        = string
}
variable "image_repository_statuspage" {
  description = "the image repository"
  type        = string
}
variable "image_repository_nginx" {
  description = "the image repository"
  type        = string
}
