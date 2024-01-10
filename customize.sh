set_perm_recursive $MODPATH 0 0 0755 0755
ui_print

print_done_message () {
    ui_print "Requirements met, avoiding abortion."
    ui_print "We won't patch XML right now, patch will apply duting every boot."
    ui_print "Reinstalling this module after firmware updates won't be needed."
    ui_print
    ui_print "[DONE]"
}

if [ -e $(magisk --path)/.magisk/modules/dex_feature_enabler/floating_feature.xml.patched ]; then
    ui_print "Seems, it's not a fresh install."
    ui_print "Bypassing checks and inflating new files."
    ui_print "If you're experiencing problems, try a clean install."
    ui_print
    print_done_message
    exit 0
fi

ui_print "Is /system/etc/floating_feature.xml in place?"
if [ ! -f /system/etc/floating_feature.xml ]; then
    ui_print "[FAIL] Installation process was cancelled, this path seems not to exist: /system/etc/floating_feature.xml"
    touch $MODPATH/remove
    exit 1
fi
ui_print "PASS"
ui_print

ui_print "Does it have SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE key?"
if ! grep -q SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE /system/etc/floating_feature.xml; then 
    ui_print "[UNSUPPORTED] Highly likely, Samsung DEX is unsupported on your platform,"
    ui_print "or file can't be opened due to other related problems..."
    ui_print "Installation process was cancelled."
    touch $MODPATH/remove
    exit 1
fi
ui_print "PASS"
ui_print

ui_print "Is standalone feature already enabled?"
if grep -q '<SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE>.*standalone.*</SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE>' /system/etc/floating_feature.xml; then 
    ui_print "[SKIP] Installation process was cancelled, due to persistance of 'standalone' feature flag.\nNo need for using this module!"
    touch $MODPATH/remove
    exit 1
fi
ui_print "PASS"
ui_print

print_done_message