import 'package:flutter/foundation.dart' show kDebugMode;

const apiBaseURL =
    kDebugMode ? "http://10.0.0.50:3000" : "https://www.limestonemechanical.ca:6969"; // Port designed to fail for testing..

const publicKeyPEM = """-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuH2Q2UcZyghLzw6Qx/QL
O7P/BjDjKtjJo8Bf8PPW4ER9N57k5Lxv8TYg7U5CfVget+baAFG37QLGmeR3tauO
lyBprk3NJ6i0SrICzkw/mKygbrTYeSwkVcxJT9zWE+rn4OCaF9RUC7RZ0AdIjrtm
zXlhlCysY51dAEXOUQsgVnI0bR+9sYTQfBN02EDPdxCcu0XGNxug29wmRsD0M5w4
M6uy1O24jjRiuB/V640tfAqkmuc+QgF3F2xYqSXTbSU+Xg7RbVgjMf0WktUYll6d
x0hw/k1CYLaU23ldzfZ4fuJb/HyKgSPkzVYrP1bBb+njUZoNr6+AgYgEQ1+FnTwK
EQIDAQAB
-----END PUBLIC KEY-----""";
