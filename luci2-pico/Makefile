include $(TOPDIR)/rules.mk

PKG_NAME:=luci2-pico
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/luci2-pico
  SECTION:=luci2
  CATEGORY:=LuCI2
  TITLE:=LuCI2 pico billing module
  DEPENDS:=luci2 pico
endef

define Package/luci2-pico/description
  LuCI2 module for pico billing
endef

define Build/Compile
endef

define Package/luci2-pico/install
	$(INSTALL_DIR) $(1)/usr/share/rpcd/menu.d
	$(INSTALL_DATA) ./files/usr/share/rpcd/menu.d/pico.json $(1)/usr/share/rpcd/menu.d/

	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./files/usr/share/rpcd/acl.d/pico.json $(1)/usr/share/rpcd/acl.d/

	$(INSTALL_DIR) $(1)/www/luci2/template
	$(INSTALL_DATA) ./files/www/luci2/template/pico.htm $(1)/www/luci2/template

	$(INSTALL_DIR) $(1)/www/luci2/view
	$(INSTALL_DATA) ./files/www/luci2/view/pico.js $(1)/www/luci2/view
endef

$(eval $(call BuildPackage,luci2-pico))
