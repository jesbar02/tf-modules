module "athena_query_prod_normalized_cd" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_CD"
  workgroup_name     = "primary"
  glue_database_name = "patient-forms-production-db"
  description        = "PROD_Normalized_CD"
  query_string       = <<-EOT
    /*PROD_Normalized_Case_Distribution*/
    SELECT forms.injury_name,
        CONCAT(phy.first_name, ' ', phy.last_name) AS physician_name,
        cli.name AS partner_name
    FROM "patient-forms-production-db"."production" forms
    JOIN "luxe-production-db"."patients" pat ON pat.id = forms.internal_id
    LEFT JOIN "luxe-production-db"."physicians" phy ON phy.id = pat.physician_id
    LEFT JOIN "luxe-production-db"."partner_clinics" cli ON cli.id = pat.partner_clinic_id
    WHERE pat.latest_visit_date > to_iso8601(current_date - interval '90' day);
 EOT
}

module "athena_query_prod_normalized_qoL" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_QoL"
  workgroup_name     = "primary"
  glue_database_name = "patient-forms-production-db"
  description        = "PROD_Normalized_QoL"
  query_string       = <<-EOT
    /*PROD_Normalized_Quality_of_Life*/
    SELECT forms.quality_of_life,
      CONCAT(phy.first_name, ' ', phy.last_name) AS physician_name,
      cli.name AS partner_name
    FROM "patient-forms-production-db"."production" forms
    JOIN "luxe-production-db"."patients" pat ON pat.id = forms.internal_id
    LEFT JOIN "luxe-production-db"."physicians" phy ON phy.id = pat.physician_id
    LEFT JOIN "luxe-production-db"."partner_clinics" cli ON cli.id = pat.partner_clinic_id
    WHERE forms.quality_of_life IS NOT NULL
    AND forms.quality_of_life <> ''
    AND pat.latest_visit_date > to_iso8601(current_date - interval '90' day);
 EOT
}

module "athena_query_prod_normalized_ad" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_AD"
  workgroup_name     = "primary"
  glue_database_name = "luxe-production-db"
  description        = "PROD_Normalized_AD"
  query_string       = <<-EOT
    /*PROD_Normalized_Age_Distribution*/
    SELECT CAST(pat.age AS bigint) AS age,
      pat.gender,
      CONCAT(phy.first_name, ' ', phy.last_name) AS physician_name,
      cli.name AS partner_name
    FROM "luxe-production-db"."patients" pat
    LEFT JOIN "luxe-production-db"."physicians" phy ON phy.id = pat.physician_id
    LEFT JOIN "luxe-production-db"."partner_clinics" cli ON cli.id = pat.partner_clinic_id
    WHERE pat.latest_visit_date > to_iso8601(current_date - interval '90' day);
 EOT
}

module "athena_query_prod_normalized_vbit" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_VBIT"
  workgroup_name     = "primary"
  glue_database_name = "patient-forms-production-db"
  description        = "PROD_Normalized_VBIT"
  query_string       = <<-EOT
    /*PROD_Normalized_Visits_By_Injury_Type*/
    SELECT forms.injury_name,
      pat.completed_visits_count,
      CONCAT(phy.first_name, ' ', phy.last_name) AS physician_name,
      cli.name AS partner_name
    FROM "patient-forms-production-db"."production" forms
    JOIN "luxe-production-db"."patients" pat ON pat.id = forms.internal_id
    LEFT JOIN "luxe-production-db"."physicians" phy ON phy.id = pat.physician_id
    LEFT JOIN "luxe-production-db"."partner_clinics" cli ON cli.id = pat.partner_clinic_id
    WHERE pat.latest_visit_date > to_iso8601(current_date - interval '90' day);
 EOT
}

module "athena_query_PROD_Normalized_CIPL" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_CIPL"
  workgroup_name     = "primary"
  glue_database_name = "patient-forms-production-db"
  description        = "PROD_Normalized_CIPL"
  query_string       = <<-EOT
    /*PROD_Normalized_Change_In_Pain_Level*/
    SELECT forms.injury_name,
      forms.pain_0,
      forms.pain_1,
      forms.pain_2,
      CONCAT(phy.first_name, ' ', phy.last_name) AS physician_name,
      cli.name AS partner_name
    FROM "patient-forms-production-db"."production" forms
    JOIN "luxe-production-db"."patients" pat ON pat.id = forms.internal_id
    LEFT JOIN "luxe-production-db"."physicians" phy ON phy.id = pat.physician_id
    LEFT JOIN "luxe-production-db"."partner_clinics" cli ON cli.id = pat.partner_clinic_id
    WHERE forms.pain_0 IS NOT null
    AND pat.latest_visit_date > to_iso8601(current_date - interval '90' day);
 EOT
}

module "athena_query_prod_normalized_cips" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_CIPS"
  workgroup_name     = "primary"
  glue_database_name = "patient-forms-production-db"
  description        = "PROD_Normalized_CIPS"
  query_string       = <<-EOT
    /*PROD_Normalized_Change_In_Psfs_Scale*/
    SELECT forms.injury_name,
      forms.psfs_0,
      forms.psfs_1,
      forms.psfs_2,
      CONCAT(phy.first_name, ' ', phy.last_name) AS physician_name,
      cli.name AS partner_name
    FROM "patient-forms-production-db"."production" forms
    JOIN "luxe-production-db"."patients" pat ON pat.id = forms.internal_id
    LEFT JOIN "luxe-production-db"."physicians" phy ON phy.id = pat.physician_id
    LEFT JOIN "luxe-production-db"."partner_clinics" cli ON cli.id = pat.partner_clinic_id
    WHERE forms.psfs_0 IS NOT null
    AND pat.latest_visit_date > to_iso8601(current_date - interval '90' day);
 EOT
}

module "athena_query_prod_normalized_bp" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_BP"
  workgroup_name     = "primary"
  glue_database_name = "patient-forms-production-db"
  description        = "PROD_Normalized_BP"
  query_string       = <<-EOT
    /*PROD_Normalized_Body_Parts*/
    SELECT forms.injury_name,
      forms.form_type,
      forms.pain_0,
      forms.pain_1,
      forms.psfs_0,
      forms.psfs_1,
      forms.answers_0,
      forms.answers_1,
      CONCAT(phy.first_name, ' ', phy.last_name) AS physician_name,
      cli.name AS partner_name
    FROM "patient-forms-production-db"."production" forms
    JOIN "luxe-production-db"."patients" pat ON pat.id = forms.internal_id
    LEFT JOIN "luxe-production-db"."physicians" phy ON phy.id = pat.physician_id
    LEFT JOIN "luxe-production-db"."partner_clinics" cli ON cli.id = pat.partner_clinic_id
    WHERE forms.injury_name IN ('Knee', 'Hip', 'Lower Back', 'Shoulder/Arm', 'Neck', 'Knee - Joint Replacement', 'Hip - Joint Replacement')
    AND pat.latest_visit_date > to_iso8601(current_date - interval '90' day);
 EOT
}

module "athena_query_prod_normalized_pt" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_PT"
  workgroup_name     = "primary"
  glue_database_name = "luxe-production-db"
  description        = "PROD_Normalized_PT"
  query_string       = <<-EOT
    /*PROD_Normalized_Patients_Treated*/
    SELECT pat.first_name,
      CONCAT(phy.first_name, ' ', phy.last_name) AS physician_name,
      pat.completed_visits_count, pat.pending_visits_count,
      forms.pain_0, forms.psfs_0,
      forms.pain_1, forms.psfs_1,
      forms.pain_2, forms.psfs_2,
      forms.pain_3, forms.psfs_3,
      forms.pain_4, forms.psfs_4,
      forms.pain_5, forms.psfs_5,
      forms.pain_6, forms.psfs_6,
      forms.pain_7, forms.psfs_7,
      forms.pain_8, forms.psfs_8,
      forms.pain_9, forms.psfs_9,
      pat.discharged, forms.injury_name, forms.form_type,
      forms.answers_0, forms.answers_1, forms.answers_2, forms.answers_3, forms.answers_4,
      forms.answers_5, forms.answers_6, forms.answers_7, forms.answers_8, forms.answers_9,
      pat.last_name,
      cli.name AS partner_name,
      pat.id AS patient_id,
      phy.id AS physician_id
    FROM "luxe-production-db"."patients" pat
    LEFT JOIN "patient-forms-production-db"."production" forms ON pat.id = forms.internal_id
    LEFT JOIN "luxe-production-db"."physicians" phy ON phy.id = pat.physician_id
    LEFT JOIN "luxe-production-db"."partner_clinics" cli ON cli.id = pat.partner_clinic_id
    WHERE pat.latest_visit_date > to_iso8601(current_date - interval '90' day)
    ORDER BY pat.last_name;
 EOT
}

module "athena_query_prod_normalized_pl" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_PL"
  workgroup_name     = "primary"
  glue_database_name = "luxe-production-db"
  description        = "PROD_Normalized_PL"
  query_string       = <<-EOT
    /*PROD_Normalized_Physicians_List*/
    SELECT CONCAT(phy.first_name, ' ', phy.last_name) AS physician_name,
      gro.name AS group_name,
      phy.prefix AS physician_prefix,
      phy.id AS physician_id,
      phy.physician_group_id AS group_id
    FROM "luxe-production-db"."patients" pat
    LEFT JOIN "luxe-production-db"."physicians" phy ON phy.id = pat.physician_id
    LEFT JOIN "luxe-production-db"."physician_groups" gro ON gro.id = phy.physician_group_id
    WHERE pat.latest_visit_date > to_iso8601(current_date - interval '90' day)
    GROUP BY phy.first_name,
      phy.prefix,
      CONCAT(phy.first_name, ' ', phy.last_name),
      gro.name,
      phy.id,
      phy.physician_group_id
    ORDER BY phy.first_name;
 EOT
}

module "athena_query_prod_normalized_phy_p" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_Phy_P"
  workgroup_name     = "primary"
  glue_database_name = "luxe-production-db"
  description        = "PROD_Normalized_Phy_P"
  query_string       = <<-EOT
    /*PROD_Normalized_Physicians_Permissions*/
    SELECT DISTINCT
      first_name,
      last_name,
      can_sign_patient_pocs,
      can_view_patient_charts,
      can_view_assigned_physicians
    FROM "luxe-production-db"."physicians"
    ORDER BY first_name ASC;
 EOT
}

module "athena_query_prod_normalized_cgp" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_CGP"
  workgroup_name     = "primary"
  glue_database_name = "luxe-production-db"
  description        = "PROD_Normalized_CGP"
  query_string       = <<-EOT
    /*PROD_Normalized_Clinic_Groups_Permissions*/
    SELECT DISTINCT
        name,
        can_sign_patient_pocs,
        can_view_patient_charts,
        can_view_assigned_physicians
    FROM "luxe-production-db"."physician_groups"
    ORDER BY name ASC;
 EOT
}

module "athena_query_prod_normalized_part_p" {
  source             = "../modules//aws_athena/"
  query_name         = "PROD_Normalized_Part_P"
  workgroup_name     = "primary"
  glue_database_name = "luxe-production-db"
  description        = "PROD_Normalized_Part_P"
  query_string       = <<-EOT
    /*PROD_Normalized_Partner_Permissions*/
    SELECT DISTINCT
        name,
        code,
        can_sign_patient_pocs,
        can_view_patient_charts,
        can_view_assigned_physicians
    FROM "luxe-production-db"."partner_clinics"
    ORDER BY name ASC;
 EOT
}

