# Maintainer: Barnaby Shearer <b@Zi.iS>
pkgname=htmloverpdf
pkgver=0.0.3
pkgrel=1
pkgdesc="Render a HTML overlay over existing PDF files."
arch=('any')
url="https://github.com/BarnabyShearer/htmloverpdf"
license=('BSD')
groups=()
depends=('python-weasyprint<53' 'python-gobject' 'python-lxml' 'pango' 'poppler-glib')
makedepends=('python-setuptools' 'python-pytest')
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=("https://files.pythonhosted.org/packages/source/${pkgname::1}/$pkgname/$pkgname-$pkgver.tar.gz")
noextract=()
md5sums=('17b930e49920784a0f8313daa8f074a0')

build() {
  cd "$pkgname-$pkgver"

  python -c "from setuptools import setup; setup()" build
}

package() {
  cd "$pkgname-$pkgver"

  python -c "from setuptools import setup; setup()" install --root="$pkgdir" --optimize=1
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

check() {
  cd "$pkgname-$pkgver"

  pytest
}
