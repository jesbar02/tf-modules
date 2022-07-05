module "pipe_double_quote_classifier" {
  source              = "../modules//aws_glue/"
  csv_classifier_name = "CSV Pipe Double-Quote Classifier"
  contains_header     = "UNKNOWN"
  header              = []
  delimiter           = "|"
  quote_symbol        = "\""
}
