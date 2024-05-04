output "cf_functions_ip_restriction_arn" {
  value = module.cf_functions_ip_restriction.arn
}

module "cf_functions_ip_restriction" {
  source = "../../../modules/cloudfront_functions/"
  name   = "foo-dev-cf-function-ip-restriction"
  code   = <<EOF
function handler(event) {
    var request = event.request;
    var clientIP = event.viewer.ip;
    var IP_WHITE_LIST = ['${var.own_ip_address}', '${var.own_ipv6_address}'];
    var isPermittedIp = IP_WHITE_LIST.includes(clientIP);

    if (isPermittedIp) {
        return request;
    } else {
        return {
            statusCode: 403,
            statusDescription: 'Forbidden',
        }
    }
}
EOF
}

module "cf_functions_basic_auth" {
  source = "../../../modules/cloudfront_functions/"
  name   = "foo-dev-cf-function-basic-auth"
  code   = <<EOF
function handler(event) {
  var request = event.request;
  var headers = request.headers;

  // echo -n user:pass | base64
  var authString = "Basic Y2xhc3NtZXRob2Q6MDkxMmNt";

  if (
    typeof headers.authorization === "undefined" ||
    headers.authorization.value !== authString
  ) {
    return {
      statusCode: 401,
      statusDescription: "Unauthorized",
      headers: { "www-authenticate": { value: "Basic" } }
    };
  }

  return request;
}
EOF
}
