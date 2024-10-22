let
  richardsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0UcuEUomxantLgdCj+BZt9SkOvLdxVDI8hWHnDWbYq";
  users = [ richardsl ];

  brix0001 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPxQQYxZOGA2Rn5t5yLdww7+LNQgXAp32/mj1fsz+Lxm";
  systems = [ brix0001 ];
in
{
  "user_hashed_password.age".publicKeys = [ richardsl brix0001 ];
}