# Byte-Code Interpreter (BCI)
# Using BCI hinting, instructions in TrueType fonts are rendered according to FreeTypes's interpreter. BCI hinting works well with fonts with good hinting instructions.
#
# Note: The BCI implementation can be switched in the script /etc/profile.d/freetype2.sh. The interpreter is set by passing the parameter truetype:interpreter-version=NN, NN corresponding to the version chosen, to the FREETYPE_PROPERTIES variable in the script. The most popular values are:
# - 35 for classic mode (emulates Windows 98),
# - 38 for "Infinality" mode (highly configurable rendering, considered slow and discontinued),
# - 40 for minimal mode (stripped down Infinality, this is the default).

export FREETYPE_PROPERTIES="truetype:interpreter-version=38"
# export FREETYPE_PROPERTIES="truetype:interpreter-version=40"
