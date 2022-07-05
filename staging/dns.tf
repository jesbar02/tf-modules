module "dns" {
  source      = "../modules//aws_dns/"
  project     = var.project
  domain_name = var.route53_public_domain

  ns_records = {
    "private.lunacare.co." = ["ns-1988.awsdns-56.co.uk.", "ns-200.awsdns-25.com.", "ns-641.awsdns-16.net.", "ns-1192.awsdns-21.org."]
    "kong.lunacare.co." = ["ns-1312.awsdns-36.org.", "ns-600.awsdns-11.net.", "ns-321.awsdns-40.com.", "ns-1678.awsdns-17.co.uk."]
  }

  txt_records = {
    "_amazonses.lunacare.co." = ["dsyt8WGhVwtl7PcNfnrQFCleoCmfeCD60TKVT7QuPrM="]
  }

  alias_records = {
    "www.lunacare.co."                 = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
    "edge.lunacare.co."                = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
    "marketplace.lunacare.co."         = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
    "provider-portal.lunacare.co."     = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
    "patient-self-report.lunacare.co." = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
    "therapist-signup.lunacare.co."    = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
    "forms.lunacare.co."               = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
    "success.lunacare.co."             = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
    "marketing-site.lunacare.co."      = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
    "luxe.lunacare.co."                = ["Z1H1FL5HABSF5", "luna-staging-public-883208217.us-west-2.elb.amazonaws.com."]
  }

  a_records = {
    "lunacare.co."            = ["34.102.136.180"]
    "kong-admin.lunacare.co." = ["18.237.176.137"]
  }

  cname_records = {
    "_9033c72e1462bb88222d7216ab5eca4b.lunacare.co."           = "_8da0d531569dae125278b19bc79305c8.rlltrpyzyf.acm-validations.aws."
    "4ddgeljbemjjphgeegreml5qmxgtdifa._domainkey.lunacare.co." = "4ddgeljbemjjphgeegreml5qmxgtdifa.dkim.amazonses.com."
    "e5cnq56uimmibsqlsvknjntwfa3edhib._domainkey.lunacare.co." = "e5cnq56uimmibsqlsvknjntwfa3edhib.dkim.amazonses.com."
    "wclsroysj7dgex7kfbm3k3zmcrz5wmbi._domainkey.lunacare.co." = "wclsroysj7dgex7kfbm3k3zmcrz5wmbi.dkim.amazonses.com."
  }
}

module "dns-private" {
  source      = "../modules//aws_dns/"
  project     = var.project
  domain_name = "private.${var.route53_public_domain}"

  alias_records = {
    "edge.private.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "forms.private.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "marketing-site.private.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "marketplace.private.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "patient-self-report.private.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "provider-portal.private.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "success.private.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "therapist-signup.private.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "www.private.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
  }

  cname_records = {
    "_9a067076d311482a63426bebf0f668d3.private.lunacare.co." = "_3d7ae971cb9e9dc5284a30912e6b784c.bbfvkzsszw.acm-validations.aws."
  }
}

module "dns-kong" {
  source      = "../modules//aws_dns/"
  project     = var.project
  domain_name = "kong.${var.route53_public_domain}"

  alias_records = {
    "edge.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "edge.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "forms.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "marketing-site.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "marketplace.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "patient-self-report.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "provider-portal.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "success.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "therapist-signup.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
    "www.kong.lunacare.co." = ["Z1H1FL5HABSF5", "internal-luna-staging-private-993554193.us-west-2.elb.amazonaws.com."]
  }

  cname_records = {
    "_e9858988c06d3c33dd8c59a9f258b7f6.kong.lunacare.co." = "_e4d25bb9d38d455d07b9b5571b27510f.bbfvkzsszw.acm-validations.aws."
  }
}
