# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, base16Bytestring, base64Bytestring
, blazeBuilder, byteable, caseInsensitive, cereal, conduit
, conduitExtra, cryptohash, dataDefault, errors, filepath
, httpClient, httpConduit, httpTypes, liftedBase, monadControl, mtl
, network, QuickCheck, quickcheckInstances, resourcet, safe
, scientific, tagged, tasty, tastyQuickcheck, text, time
, transformers, transformersBase, unorderedContainers, utf8String
, vector, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "aws";
  version = "0.11";
  sha256 = "19q7r74c5xw04vpwl2fwm675bvkp3vhlak63iqfl1927z2jsyva9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec base16Bytestring base64Bytestring blazeBuilder
    byteable caseInsensitive cereal conduit conduitExtra cryptohash
    dataDefault filepath httpConduit httpTypes liftedBase monadControl
    mtl network resourcet safe scientific tagged text time transformers
    unorderedContainers utf8String vector xmlConduit
  ];
  testDepends = [
    aeson errors httpClient liftedBase monadControl mtl QuickCheck
    quickcheckInstances resourcet tagged tasty tastyQuickcheck text
    time transformers transformersBase
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://github.com/aristidb/aws";
    description = "Amazon Web Services (AWS) for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
