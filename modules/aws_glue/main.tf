resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  count = length(var.database_name) > 0 ? 1 : 0
  name  = var.database_name
}

resource "aws_glue_catalog_table" "aws_glue_table" {
  count         = length(var.table_name) > 0 ? 1 : 0
  name          = var.table_name
  database_name = var.db_catalog_name

  # Table properties
  parameters = {
    "classification"                        = var.classification
    "skip.header.line.count"                = var.skip_header_line_count
    "sizeKey"                               = var.size_key
    "objectCount"                           = var.object_count
    "ParquetCrawlerSchemaSerializerVersion" = var.parquet_crawler_schema_serializer_version
  }
  storage_descriptor {
    location      = var.s3_location
    input_format  = var.input_format
    output_format = var.output_format

    ser_de_info {
      serialization_library = var.serialization_library
      # Serde parameters
      parameters = {
        "field.delim"          = var.field_delim_param
        "serialization.format" = var.serialization_format
      }
    }

    dynamic "columns" {
      for_each = var.columns

      content {
        name = columns.value.name
        type = columns.value.type
      }
    }
  }
  dynamic "partition_keys" {
    for_each = var.partition_keys

    content {
      name = partition_keys.value.name
      type = partition_keys.value.type
    }
  }
}

resource "aws_glue_classifier" "aws_glue_classifier" {
  count = length(var.csv_classifier_name) > 0 ? 1 : 0
  name  = var.csv_classifier_name

  csv_classifier {

    contains_header        = var.contains_header
    delimiter              = var.delimiter
    header                 = var.header
    quote_symbol           = var.quote_symbol
    allow_single_column    = var.allow_single_column
    disable_value_trimming = var.disable_value_trimming
  }
}

resource "aws_glue_crawler" "aws_glue_crawler" {
  count         = length(var.crawler_name) > 0 ? 1 : 0
  database_name = var.crawler_db_name
  schedule      = var.crawler_schedule
  name          = var.crawler_name
  role          = var.crawler_role
  classifiers   = var.crawler_classifiers

  s3_target {
    path = var.crawler_path
  }

  schema_change_policy {
    update_behavior = var.update_behavior
    delete_behavior = var.delete_behavior
  }
}
