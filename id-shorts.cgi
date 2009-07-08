#!/usr/bin/perl -w

use strict;
use lib 'plugins/IdShorts/lib';
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';
use MT::Bootstrap App => 'IdShorts::App';
