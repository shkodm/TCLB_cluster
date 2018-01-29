# magnus-.*

echo "Magnus!"

[ -z "$RHOME" ] && RHOME=$(echo /pawsey/cle*/apps/PrgEnv-gnu/*/gcc/*/haswell/r/*/bin/R | sed 's|bin/R||' | head -n1)
MODULE_RUN_DEF=$(module list 2>&1 | grep PrgEnv | sed 's/^.*) //') #Getting the PrgEnv module loaded now.
