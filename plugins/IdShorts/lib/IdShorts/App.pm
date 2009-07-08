
package IdShorts::App;

use strict;
use base qw( MT::App );

sub id { 'id_shorts' }

sub init {
    my $app = shift;
    $app->SUPER::init(@_);
    $app->{default_mode} = 'redirect';
    $app;
}

sub redirect_mode {
    my $app = shift;
    my $id = $app->path_info || $app->param ('id');
    
    return $app->error ('id required') if (!$id);
    
    require MT::Entry;
    my $e = MT::Entry->load ($id) or return $app->error ('Unknown entry');
    return $app->redirect ($e->permalink);
}


1;