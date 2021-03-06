class Proxmark3 < Formula
  desc "RRG/Iceman Proxmark3 client, CDC flasher and firmware bundle"
  homepage "http://www.proxmark.org/"
  head do
    if ENV.has_key?('HOMEBREW_TRAVIS_COMMIT')
      url "https://github.com/sushiomsky/proxmark3.git", :branch => "#{ENV['HOMEBREW_TRAVIS_BRANCH']}", :revision => "#{ENV['HOMEBREW_TRAVIS_COMMIT']}"
    else
      url "https://github.com/sushiomsky/proxmark3.git"
    end
  end
  
  depends_on "readline"
  depends_on "pkg-config" => :build
  depends_on "qt5"
  depends_on "RfidResearchGroup/proxmark3/arm-none-eabi-gcc" => :build

  option "with-blueshark", "Enable Blueshark (BT Addon) support"

  def install
    ENV.deparallelize

    if not ENV.has_key?('HOMEBREW_PROXMARK3_PLATFORM')
      ENV['HOMEBREW_PROXMARK3_PLATFORM'] = 'PM3OTHER'
    end

    system "make", "clean"
    if build.with? "blueshark"
      system "make", "all", "PLATFORM=PM3OTHER STANDALONE=LF_4100RSWB"
    else
      system "make", "all", "PLATFORM=PM3OTHER STANDALONE=LF_4100RSWB"
    end

    system "make", "install", "PREFIX=#{prefix}", "PLATFORM=PM3OTHER STANDALONE=LF_4100RSWB"

    ohai "Install success!"
    ohai "The latest bootloader and firmware binaries are ready and waiting in the current homebrew Cellar within share/firmware."
  end

  test do
    system "proxmark3", "-h"
  end
end
