#!/bin/sh

# autopkg make-override "Adobe 2022 Import.jss.recipe" -n AdobeAPPNAME2022-$platform.jss

platform="$1"

OVERRIDES=(
    "AdobeAcrobatDC2022-$platform"
    "AdobeAfterEffects2022-$platform"
    "AdobeAnimate2022-$platform"
    "AdobeAudition2022-$platform"
    "AdobeBridge2022-$platform"
    "AdobeCharacterAnimator2022-$platform"
    "AdobeDimension2022-$platform"
    "AdobeDreamweaver2022-$platform"
    "AdobeIllustrator2022-$platform"
    "AdobeInCopy2022-$platform"
    "AdobeInDesign2022-$platform"
    "AdobeLightroom2022-$platform"
    "AdobeLightroomClassic2022-$platform"
    "AdobeMediaEncoder2022-$platform"
    "AdobePhotoshop2022-$platform"
    "AdobePremierePro2022-$platform"
    "AdobePremiereRush2022-$platform"
    "AdobeSubstance3DDesigner2022-$platform"
    "AdobeSubstance3DPainter2022-$platform"
    "AdobeSubstance3DSampler2022-$platform"
    "AdobeSubstance3DStager2022-$platform"
    "AdobeXD2022-$platform"
)

if [[ ! -z "$platform" ]]; then
	for app in "${OVERRIDES[@]}"; do
	    echo "Making override for $app.jss"
	    autopkg make-override "Adobe 2022 Import.jss.recipe" -n "$app.jss" --force
	    sed -i.backup "s/SomeAdobe2022Title/$app/g" "$HOME/Library/AutoPkg/RecipeOverrides/$app.jss.recipe"
	done
else
	echo "Must specify a platform ARM64 or Intel"
fi
