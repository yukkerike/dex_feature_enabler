#!/system/bin/sh

MODDIR=${0%/*}
PATCHED_XML=$MODDIR/floating_feature.xml.patched
ORIGINAL_XML=/system/etc/floating_feature.xml
MODULE_PROP=$MODDIR/module.prop

sed -i -E "s/description=(\[.+\] )?/description=/" $MODULE_PROP

set_success() {
    sed -i "s/description=/description=\[DONE\] /" $MODULE_PROP
}

set_failed() {
    sed -i "s/description=/description=\[FAILED: $1\] /" $MODULE_PROP
}

sed "/<SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE>/s/, *standalone//; /<SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE>/s/<SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE>\(.*\)<\/SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE>/<SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE>\1,standalone<\/SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE>/" $ORIGINAL_XML > $PATCHED_XML || set_failed patch

chown root:root $PATCHED_XML || set_failed chown
chmod 0644 $PATCHED_XML || set_failed chmod
chcon -v u:object_r:system_file:s0 $PATCHED_XML || set_failed chcon

mount -o bind $PATCHED_XML $ORIGINAL_XML || set_failed mount

grep -q "FAILED" $MODULE_PROP || set_success