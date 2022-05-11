#!/bin/sh

# autopkg make-override "Adobe 2022 Import.jss.recipe" -n AdobeAcrobatDC2022-ARM64.jss

OVERRIDES=(
    "AdobeAcrobatDC2023-ARM64"
    "AdobeAfterEffects2022-ARM64"
    "AdobeAnimate2022-ARM64"
    "AdobeAudition2022-Intel"
    "AdobeBridge2022-ARM64"
    "AdobeCharacterAnimator2022-ARM64"
    "AdobeDimension2022-ARM64"
    "AdobeDreamweaver2022-ARM64"
    "AdobeIllustrator2022-ARM64"
    "AdobeInCopy2022-ARM64"
    "AdobeInDesign2022-ARM64"
    "AdobeLightroom2022-ARM64"
    "AdobeLightroomClassic2022-ARM64"
    "AdobeMediaEncoder2022-ARM64"
    "AdobePhotoshop2022-ARM64"
    "AdobePremierePro2022-ARM64"
    "AdobePremiereRush2022-ARM64"
    "AdobeSubstance3DDesigner2022-ARM64"
    "AdobeSubstance3DPainter2022-ARM64"
    "AdobeSubstance3DSampler2022-ARM64"
    "AdobeSubstance3DStager2022-ARM64"
    "AdobeXD2022-ARM64"
)

for app in "${OVERRIDES[@]}"; do
    echo "Making override for $app.jss"
    autopkg make-override "Adobe 2022 Import.jss.recipe" -n "$app.jss" --force
    sed -i.backup "s/SomeAdobe2022Title/$app/g" "$HOME/Library/AutoPkg/RecipeOverrides/$app.jss.recipe"
done
