# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit git-r3 bash-completion-r1 distutils-r1

DESCRIPTION="A dockerized approach to test a Gentoo package within a clean stage3 container (fork)"
HOMEPAGE="https://github.com/linxon/ebuildtester"
EGIT_REPO_URI="https://github.com/linxon/ebuildtester"

LICENSE="BSD"
SLOT="0"

RDEPEND="app-emulation/docker"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install
	newbashcomp "${FILESDIR}/${PN}.bash-completion" "${PN}"
	doman docs/*.1
}
