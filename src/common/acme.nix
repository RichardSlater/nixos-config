{ config, ... }:

{
#   services.acme-dns.enable = true;
#   services.acme-dns.settings.general.domain = "net.scetrov.live";

  age.secrets.cloudflare_dns_zone_api_key.file = ../secrets/cloudflare_dns_zone_api_key.age;
  age.secrets.cloudflare_account_email.file = ../secrets/cloudflare_account_email.age;
  age.secrets.lets_encrypt_email.file = ../secrets/lets_encrypt_email.age;
  
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "letsencrypt@richard-slater.co.uk";
  security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
  security.acme.certs."scetrov.live" = {
    dnsProvider = "cloudflare";
    dnsResolver = "1.1.1.1:53";
    extraDomainNames = [ "*.net.scetrov.live" ];
    credentialFiles = {
      "CLOUDFLARE_EMAIL_FILE" = config.age.secrets.cloudflare_account_email.path;
      "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.age.secrets.cloudflare_dns_zone_api_key.path;
    };
    dnsPropagationCheck = true;
  };
}