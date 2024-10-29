let
  richardsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0UcuEUomxantLgdCj+BZt9SkOvLdxVDI8hWHnDWbYq";
  users = [ richardsl ];

  brix0001 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPxQQYxZOGA2Rn5t5yLdww7+LNQgXAp32/mj1fsz+Lxm";
  systems = [ brix0001 ];
in
{
  "user_hashed_password.age".publicKeys = [ richardsl brix0001 ];
  "cloudflare_dns_zone_api_key.age".publicKeys = [ richardsl brix0001 ];
  "cloudflare_account_email.age".publicKeys = [ richardsl brix0001 ];
  "lets_encrypt_email.age".publicKeys = [ richardsl brix0001 ];
}