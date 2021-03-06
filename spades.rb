class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://cab.spbu.ru/files/release3.10.0/SPAdes-3.10.0.tar.gz"
  sha256 "cd44686021daffb3698c85fdf292d193aee702a01ffc71346c921da1a5bd0b41"
  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"

  bottle do
    cellar :any
    sha256 "898f8697cb57f950face69caf5696fdf06147800e43188b4cf949310862cfa6e" => :sierra
    sha256 "5291fc389c160dc8749fe6418e27b596b7f8497c2344d13130a95a790de00c65" => :el_capitan
    sha256 "dbfa833dcc08a489a9219ff850974422d66608226e3bc8a20eec5044688785d3" => :yosemite
    sha256 "364ae5611dbd81739318eec905a8fa17c0702e4dc0eeef4425a4fcd70913d339" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on :python if OS.linux?

  needs :openmp

  fails_with :gcc => "4.7" do
    cause "Compiling SPAdes requires GCC >= 4.7 for OpenMP 3.1 support"
  end

  def install
    # Fix error "'strdup' was not declared in this scope"
    # Reported 2 Feb 2017 https://github.com/ablab/spades/issues/12
    inreplace "src/common/utils/autocompletion.cpp", /(#include <string>)/,
                                                     "\\1\n#include <string.h>"
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/spades.py", "--test"
  end
end
