use 5.008004;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME             => 'Crypto::CoinGecko',
  VERSION_FROM     => 'lib/Crypto/CoinGecko.pm',
  ABSTRACT_FROM    => 'lib/Crypto/CoinGecko.pm',
  AUTHOR           => 'Randy J',
  LICENSE          => 'freebsd',
  MIN_PERL_VERSION => '5.008004',
  #EXE_FILES        => ['script/foo'],
  PREREQ_PM        => {
    'strict'   => 0,
    'warnings' => 0,
    'DateTime' => '0.37',
  },
  (eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (META_MERGE => {
      'meta-spec' => { version => 2 },
      resources => {
          repository => {
              type => 'git',
              url  => 'https://github.com/rjheeta/CoinGecko.git',
              web  => 'https://github.com/rjheeta/CoinGecko',
          },
      }})
   : ()
  ),
);