ui_print
floating_feature_path="/system/etc/floating_feature.xml"
floating_feature_key="SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE"

set_perm_recursive $MODPATH 0 0 0755 0755

installation_completed() {
    ui_print
    ui_print "Requirements met."
    ui_print "The patch to $floating_feature_path"
    ui_print "will be applied on each boot."
    ui_print "No need for reinstall after firmware updates."
    ui_print
    ui_print "[DONE]"
    exit 0
}

abort_installation() {
    ui_print
    ui_print "Installation process was cancelled."
    touch $MODPATH/remove
    exit 1
}

if [ -e $(magisk --path)/.magisk/modules/dex_feature_enabler/floating_feature.xml.patched ]; then
    ui_print "Seems like it's not a fresh install."
    ui_print "Bypassing checks and inflating new files."
    ui_print "If you're experiencing problems, try a fresh install."
    installation_completed
fi

ui_print "Is $floating_feature_path in place?"
if [ ! -f "$floating_feature_path" ]; then
    ui_print "This file seems not to exist."
    ui_print "Nothing to patch."
    abort_installation
fi
ui_print "PASS"

ui_print
ui_print "Does it have $floating_feature_key key?"
if ! grep -q $floating_feature_key "$floating_feature_path"; then 
    ui_print "[UNSUPPORTED] Highly likely, Samsung DeX"
    ui_print "is unsupported on your device."
    abort_installation
fi
ui_print "PASS"

ui_print
ui_print "Is the standalone feature already enabled?"
if grep -q "<$floating_feature_key>.*standalone.*</$floating_feature_key>" "$floating_feature_path"; then 
    ui_print "[SKIP] Standalone mode of Samsung DeX is already enabled."
    ui_print "No need to use this module!"
    abort_installation
fi
ui_print "PASS"

installation_completed
