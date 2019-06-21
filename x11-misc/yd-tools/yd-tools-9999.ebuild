# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )
PLOCALES="be bg el ru"

inherit eutils gnome2-utils l10n xdg-utils python-r1

DESCRIPTION="Panel indicator (GUI) for YandexDisk CLI client"
HOMEPAGE="https://github.com/slytomcat/yandex-disk-indicator"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/slytomcat/yandex-disk-indicator"
else
	MY_P="yandex-disk-indicator-${PV}"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/slytomcat/yandex-disk-indicator/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
	S="${WORKDIR}"/${MY_P}
fi

LICENSE="GPL-3"
SLOT=0
IUSE="nls"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.0:2
	dev-libs/libappindicator:3
	>=dev-python/pyinotify-0.9.6[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gnome-extra/zenity
	net-misc/yandex-disk
	x11-misc/xclip
	>=x11-libs/gtk+-3.0:3
	>=x11-libs/gdk-pixbuf-2.0:2"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	mv todo.txt TODO || die
	mv build/yd-tools/debian/changelog ChangeLog || die

	# Change "Exec" path in *.desktop files
	sed -i \
		-e "s:Exec=yandex-disk-indicator:Exec=/usr/bin/yandex-disk-indicator.py:" \
		Yandex.Disk-indicator.desktop || die "sed failed!"

	if use nls; then
		l10n_find_plocales_changes "translations" "yandex-disk-indicator_" ".po"

		rm_loc() {
			ebegin "Disable locale: ${1}"
			rm -f translations/yandex-disk-indicator_${1}.{mo,po} || die
			rm -f translations/{actions-,ya-setup-}${1}.lang || die
			eend
		}
		l10n_for_each_disabled_locale_do rm_loc
	else
		for x in ${PLOCALES}; do
			ebegin "Disable locale: ${x}"
			rm -f translations/yandex-disk-indicator_${x}.{mo,po} || die
			rm -f translations/{actions-,ya-setup-}${x}.lang || die
			eend
		done
	fi

	eapply_user
}

src_install() {
	if use nls; then
		do_loc() {
			insinto /usr/share/locale/${1}/LC_MESSAGES
			newins translations/yandex-disk-indicator_${1}.mo yandex-disk-indicator.mo

			# Remove other excluded translations
			rm -f translations/yandex-disk-indicator_${1}.{mo,po} || die
		}
		l10n_for_each_locale_do do_loc
	fi

	insinto /usr/share/yd-tools && exeinto /usr/share/yd-tools
	doins -r translations icons fm-actions
	doexe ya-setup

	dodoc README.md TODO ChangeLog man/yd-tools
	domenu Yandex.Disk-indicator.desktop
	doman man/yd-tools.1

	python_foreach_impl python_doscript yandex-disk-indicator.py

	make_wrapper \
		"yandex-disk-indicator" \
		"python3 /usr/bin/yandex-disk-indicator.py"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
