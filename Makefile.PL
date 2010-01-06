use strict;
use warnings;
use inc::Module::Install;
use Module::Install::XSUtil 0.19;

all_from 'lib/Hash/FieldHash.pm';

use_ppport 3.19;
cc_warnings;

requires 'MRO::Compat' => 0.10 if $] < 5.010;

test_requires 'Test::More'      => 0.62;
test_requires 'Test::LeakTrace' => 0.07;

tests 't/*.t t/*/*.t';
author_tests 'xt';

if(author_context){
	cc_define '-DFIELDHASH_DEBUG';
}

makemaker_args depend => { '$(C_FILES)' => 'compat58.xsi' },

auto_set_repository() if -d '.git';

clean_files q(
	Hash-FieldHash-* *.stackdump
	*.gcda *.gcno *.gcov
	nytprof *.out
	cover_db
);

WriteAll check_nmake => 0;
