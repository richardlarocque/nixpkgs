{ stdenv, fetchgit, gmp, pkgconfig, autoreconfHook }:

stdenv.mkDerivation {
  name = "secp256k1-2014-12-20";

  src = fetchgit {
    url = "git://github.com/bitcoin/secp256k1.git";
    rev = "cf0c48bea5";
    sha256 = "bc84005d3b40af8f097ac37786a73970006e9802df5b2fc6276672c50a0bbb06";
  };

  buildInputs = [ autoreconfHook pkgconfig gmp ];

  meta = {
    description = "Optimized C library for EC operations on curve secp256k1";
    longDescription = ''
        Optimized C library for EC operations on curve secp256k1.

        This library is experimental, so use at your own risk.

        Features:

          * Low-level field and group operations on secp256k1.
          * ECDSA signing/verification and key generation.
          * Adding/multiplying private/public keys.
          * Serialization/parsing of private keys, public keys, signatures.
          * Very efficient implementation.
      '';
    homepage = https://github.com/bitcoin/secp256k1;
    license = stdenv.lib.licenses.mit;
    maintainers = [];
  };
}
