# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils xdg-utils

DESCRIPTION="A advanced launcher for Minecraft"
HOMEPAGE="https://tlauncher.org"
LICENSE="all-rights-reserved"

# Get url: http://tlauncherrepo.com/tlauncher/legacy/bootstrap.json
PKG_HASH="00aa8d0014ce30f2116a13b8313de65cc9be690f475758d83359e7756fa848f0"
SRC_URI="http://tlauncherrepo.com/legacy/bootstrap/${PKG_HASH}.jar -> ${P}.jar
         https://minecraft.net/apple-icon-180x180.png -> ${P}.png"

RESTRICT="mirror"
KEYWORDS="amd64 x86"
SLOT="1"

DEPEND=""
RDEPEND="${DEPEND}
	dev-java/oracle-jdk-bin"

S="${WORKDIR}"

src_install() {
	local inst_dir="/opt/${P}"
	local ex_file="${PN}.jar"

	insinto "${inst_dir}"
	newins "${DISTDIR}"/"${P}.jar" "${ex_file}"
	insinto /usr/share/pixmaps/
	newins "${DISTDIR}"/${P}.png ${PN}-${SLOT}.png

	# Fix error message — "Could not access JAR file."
	fowners -R root:games "${inst_dir}"
	fperms 775 "${inst_dir}"
	fperms 664 "${inst_dir}"/${ex_file}

	make_wrapper "${PN}${SLOT}" "/usr/bin/java -jar \"${inst_dir}/${ex_file}\""
	make_desktop_entry \
		"/usr/bin/${PN}${SLOT}" \
		"TLauncher Legacy" \
		"${PN}-${SLOT}" \
		"Game" \
		"Path=${inst_dir}"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	ewarn
	ewarn "Just run 'gpasswd -a <USER> games' and 'gpasswd -a <USER> video', then have <USER> re-login."
	ewarn

	xdg_desktop_database_update
	gnome2_icon_cache_update
}
