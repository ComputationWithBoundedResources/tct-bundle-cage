mkdir modules &&
pushd modules &&
git clone https://github.com/ComputationWithBoundedResources/slogic slogic &&
git clone https://github.com/ComputationWithBoundedResources/term-rewriting-xml term-rewriting-xml &&
git clone https://github.com/ComputationWithBoundedResources/tct-core tct-core &&
pushd tct-core && git checkout cage && popd &&
git clone https://github.com/ComputationWithBoundedResources/tct-common tct-common &&
git clone https://github.com/ComputationWithBoundedResources/tct-its tct-its &&
pushd tct-its && git checkout cage && popd &&
git clone https://github.com/ComputationWithBoundedResources/tct-trs tct-trs &&
git clone https://github.com/ComputationWithBoundedResources/tct-inttrs tct-inttrs &&
popd
