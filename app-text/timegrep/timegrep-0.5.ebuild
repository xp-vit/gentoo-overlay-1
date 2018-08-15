# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utility to grep log between two dates or tail last lines to time ago"
HOMEPAGE="https://github.com/abbat/timegrep"
SRC_URI="https://github.com/abbat/timegrep/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
SLOT="0"
IUSE=""

DEPEND="dev-libs/libpcre"
RDEPEND="${DEPEND}"
